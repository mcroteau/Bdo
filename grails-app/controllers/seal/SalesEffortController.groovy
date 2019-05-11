package seal

import grails.plugin.springsecurity.annotation.Secured

import io.seal.SalesEffort
import io.seal.Prospect
import io.seal.Status

import io.seal.common.ApplicationConstants

import io.seal.common.Statuses

class SalesEffortController {

    static allowedMethods = [ start: "POST", stop: "POST" ]
	
	
	def commonUtilities
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def create(Long id){
		def prospectInstance = Prospect.get(id)
		if(!prospectInstance){
			flash.message = "Something went wrong. Unable to find prospect with id : ${id}"
			redirect(controller:"prospect", action: "action_error")
			return
		}
		def statusInstance = Status.findByName(Statuses.SALES_EFFORT.name)
		
		[prospectInstance: prospectInstance, salesEffortInstance: new SalesEffort(params), accountInstance: commonUtilities.getAuthenticatedAccount(), statusInstance: statusInstance]
		
	}

	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def start(Long id){
		def prospectInstance = Prospect.get(id)
		if(!prospectInstance){
			flash.message = "Something went wrong. Unable to find prospect with id : ${id}"
			redirect(controller:"prospect", action: "action_error")
			return
		}
		
		def salesEffortInstance = new SalesEffort()
		
		def status = Status.findByName(Statuses.SALES_EFFORT.name)
		 
		
		def existingSalesEfforts = SalesEffort.findAllByProspectAndIsCurrent(prospectInstance, true)
		existingSalesEfforts.each{ existingSalesEffort ->
			existingSalesEffort.isCurrent = false
			salesEffortInstance.recording = false
			existingSalesEffort.completeStatus = prospectInstance.status
			existingSalesEffort.save(flush:true)
		}
		
		salesEffortInstance.isCurrent = true
		salesEffortInstance.startingStatus = status
		salesEffortInstance.prospect = prospectInstance
		salesEffortInstance.recording = true
		salesEffortInstance.salesman = commonUtilities.getAuthenticatedAccount()
		
		salesEffortInstance.save(flush:true)	
		
		salesEffortInstance.errors.allErrors.each{
			println "${it}"
		}
		
		
		prospectInstance.currentSalesEffort = salesEffortInstance
		prospectInstance.status = status
		prospectInstance.save(flush:true)
		
		println "Sales Efforts : ${SalesEffort.count()}"
		
		flash.message = "Successfully began new Sales effort..."
		redirect(controller: "prospect", action: "action_success")
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def confirm_complete(Long id){
		def salesEffortInstance = SalesEffort.get(id)
		if(!salesEffortInstance){
			flash.message = "Something went wrong. Unable to find sales effort with id : ${id}"
			redirect(controller:"prospect", action: "action_error")
			return
		}
		[salesEffortInstance: salesEffortInstance]
	}


	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def complete(){
		def salesEffortInstance = SalesEffort.get(params.id)
		if(!salesEffortInstance){
			flash.message = "Something went wrong. Unable to find effort with id : ${params.id}"
			redirect(controller:"prospect", action: "action_error")
			return
		}
		def prospectInstance = salesEffortInstance.prospect
		
		def completeStatus = Status.get(params?.status.id)

		if(!completeStatus){
			flash.message = "Please select a status to complete effort..."
			redirect(action: "confirm_complete", id : params.id)
			return
		}

		def message = "Successfully completed Sales Effort. Congratulations on your new sale!"
		
		def saleStatus = Status.findByName("Sale")
		if(completeStatus.id != saleStatus.id){
			message = "Successfully completed Sales Effort. Maybe some time will help."
		}
		salesEffortInstance.recording = false
		salesEffortInstance.completeStatus = completeStatus
		salesEffortInstance.dateComplete = new Date()
		salesEffortInstance.save(flush:true)
		
		salesEffortInstance.errors.allErrors.each{
			println "${it}"
		}
		
		if(prospectInstance.currentSalesEffort != salesEffortInstance){
			prospectInstance.currentSalesEffort = salesEffortInstance
			prospectInstance.save(flush:true)
		}
		
		println prospectInstance.currentSalesEffort
		
		println "recording : ? ${salesEffortInstance.recording}"
		prospectInstance.status = completeStatus
		prospectInstance.save(flush:true)
		
		flash.message = message
		redirect(controller: "prospect", action: "action_success")
	}
	
}