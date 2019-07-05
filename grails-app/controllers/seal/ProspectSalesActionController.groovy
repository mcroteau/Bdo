package seal

import grails.plugin.springsecurity.annotation.Secured
import java.text.SimpleDateFormat

import io.seal.common.ApplicationConstants
import io.seal.ProspectSalesAction
import io.seal.Prospect
import io.seal.SalesAction
import io.seal.Account
import groovy.time.TimeCategory
import static java.util.Calendar.*

class ProspectSalesActionController {
	
    static allowedMethods = [ save: "POST", update: "POST", delete: "POST"]
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def index(){
    	redirect(action:"create")
	}
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def create(Long id){
		def prospectInstance = Prospect.get(id)
		if(!prospectInstance){
			flash.message = "Something went wrong, close and try again."
			redirect(controller:"prospect", action:"action_error")
		}
		
		def date = new Date()
		def sdf = new SimpleDateFormat("MM/dd/yyyy")
		def presetActionDate = sdf.format(date)
		
    	[prospectInstance: prospectInstance, prospectSalesActionInstance: new ProspectSalesAction(params), presetActionDate: presetActionDate ]
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def save(){
		try{
			def prospect = Prospect.get(params.id)
			if(!prospect){
				flash.message = "Prospect wasn't found. Please make sure the Prospect hasn't been deleted"
				redirect(controller: "prospect", action: "action_error")
				return
			}





			def prospectSalesActionInstance = new ProspectSalesAction()
			prospectSalesActionInstance.prospect = prospect
			println "params.salesAction : " + params.salesAction
			println "*** r ${params.reminder} *** "
			println "*** rt ${params.reminderTime} *** "
			
			def salesAction = SalesAction.get(params.salesAction?.id)
			println "sales action : " + salesAction
			
			prospectSalesActionInstance.salesAction = salesAction
			
			
			println "action date : " + params.actionDate
			if(!params.actionDate){
				flash.message = "Please set action date to continue..."
				redirect(action: "create", params: params)
				return
			}
			
			def hourMinutes = getHoursMinutes(params)
			if(hourMinutes?.error){
				flash.message = hourMinutes.error
				redirect(action: "create", params: params)
				return
			}
			
			def dateString = params.actionDate + " " + hourMinutes.hours + ":" + hourMinutes.minutes
			def date = new Date().parse("MM/dd/yyyy H:mm", dateString)
			
			println date

			def account = Account.get(params.account?.id)


			def existingProspectSalesAction = ProspectSalesAction.findAllByAccountAndActionDate(account, date)
			if(existingProspectSalesAction){
				flash.message = "Another sales action exists for this date and time slot, please try again"
				redirect(action: "create", params: params)
				return
			}


			
			prospectSalesActionInstance.actionDate = date
			prospectSalesActionInstance.note = params.note
			prospectSalesActionInstance.reminder = params.reminder
			prospectSalesActionInstance.reminderTime = params.reminderTime.toInteger()
			prospectSalesActionInstance.account = account
			if(params.reminder == "true"){
				use( TimeCategory ) {
					def reminderDate = date - prospectSalesActionInstance.reminderTime.minutes
					reminderDate[SECOND] = 0
					remdinerDate[MILLISECOND] = 0
					prospectSalesActionInstance.reminderDate = reminderDate
				}
			}else{
				prospectSalesActionInstance.reminderDate = null
			}
			
			if(!prospectSalesActionInstance.save(flush:true)){
				flash.message = "Something went wrong on our end. Please try again or contact support"
				redirect(action: "create", id: params.id)
				return
			}
			
			
		    prospectSalesActionInstance.errors.allErrors.each {
		        println it
		    }
			
			
			flash.message = "Sales Action successfully added..."
	    	redirect(controller:"prospect", action: "action_success")

		}catch(Exception e){
			e.printStackTrace()
			flash.message = "Please select a date with the format MM/dd/yyyy..."
			redirect(action: "create", params: params)
			return
		}
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def edit(Long id){		
    	def prospectSalesActionInstance = ProspectSalesAction.get(id)
    	if (!prospectSalesActionInstance) {
    	    flash.message = "Sales Action wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}  
		
		def sdf = new SimpleDateFormat("MM/dd/yyyy")
		def actionDate = sdf.format(prospectSalesActionInstance.actionDate)

		def sdfh = new SimpleDateFormat("H")
		def actionHours = sdfh.format(prospectSalesActionInstance.actionDate)
		
		def sdfm = new SimpleDateFormat("mm")
		def actionMinutes = sdfm.format(prospectSalesActionInstance.actionDate)
		
    	[ prospectSalesActionInstance: prospectSalesActionInstance, actionDate: actionDate, actionHours: actionHours, actionMinutes: actionMinutes ]
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update(Long id){
		
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}

		def prospectSalesActionInstance = ProspectSalesAction.get(id)
    	if (!prospectSalesActionInstance) {
    	    flash.message = "Sales Action wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}
		
		prospectSalesActionInstance.prospect = prospectInstance
		println "params.salesAction : " + params.salesAction
		
		def salesAction = SalesAction.get(params.salesAction?.id)
		println "sales action : " + salesAction
		
		prospectSalesActionInstance.salesAction = salesAction
		prospectSalesActionInstance.status = params.status
		prospectSalesActionInstance.reminder = params.reminder
		prospectSalesActionInstance.reminderTime = params.reminderTime.toInteger()
		prospectSalesActionInstance.account = Account.get(params.account?.id)
		
		prospectSalesActionInstance.reminded = false


		println "action date : " + params.actionDate
		if(!params.actionDate){
			flash.message = "Please set action date below..."
			redirect(action: "create", params: params)
			return
		}
		
		def hourMinutes = getHoursMinutes(params)
		if(hourMinutes?.error){
			flash.message = hourMinutes.error
			redirect(action: "edit", id: prospectSalesActionInstance.id)
			return
		}
		
		def dateString = params.actionDate + " " + hourMinutes.hours + ":" + hourMinutes.minutes
		def date = new Date().parse("MM/dd/yyyy H:mm", dateString)
		
		println "date " + date
		
		
		prospectSalesActionInstance.actionDate = date
		if(params.reminder == "true"){
			use( TimeCategory ) {
				def reminderDate = date - prospectSalesActionInstance.reminderTime.minutes
				reminderDate[SECOND] = 0
				remdinerDate[MILLISECOND] = 0
				prospectSalesActionInstance.reminderDate = reminderDate
				println "prospectSalesActionInstance.reminderDate ${prospectSalesActionInstance.reminderDate}"
			}
		}else{
			prospectSalesActionInstance.reminderDate = null
		}
		prospectSalesActionInstance.note = params.note
		
		
		
		
		if(prospectSalesActionInstance.status == ApplicationConstants.SALES_ACTION_COMPLETED){
			println "completed...."
			prospectSalesActionInstance.completed = true
			prospectSalesActionInstance.dateCompleted = new Date()
			prospectSalesActionInstance.save(flush:true)
			
			if(prospectInstance.currentSalesEffort){
				def salesEffort = prospectInstance.currentSalesEffort
				salesEffort.addToSalesActions(prospectSalesActionInstance)	
				salesEffort.save(flush:true)
				prospectSalesActionInstance.salesEffort = salesEffort
			}
		}
		
		

   		if (!prospectSalesActionInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating Sales Action, please try again..."
   		    render(view: "edit", model: [prospectSalesActionInstance: prospectSalesActionInstance])
   		    return
   		}
   		
   		flash.message = "Sales Action successfully updated..."
   		redirect(action: "edit", id: prospectSalesActionInstance.id)
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def delete(Long id){
		println "deleting sales action"
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}
		
		def prospectSalesActionInstance = ProspectSalesAction.get(id)
    	if (!prospectSalesActionInstance) {
			
			if(prospectInstance){
	    	    flash.message = "Prospect wasn't found. Prospect may have already been deleted..."
	    	    redirect(controller: "prospect", action: "edit", id: params.prospectId)
	    	    return
			}
    	    flash.message = "Sales Action wasn't found. It may have already been deleted..."
    	    redirect(controller: "dashboard", action: "index")
    	    return
    	}
		
		try {
			
            prospectSalesActionInstance.delete(flush: true)
            flash.message = "Successfully deleted the Sales Action <strong>" + prospectSalesActionInstance.id + "</strong>"
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete the Sales Action."
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        }
	}
	
	
	
	def getHoursMinutes(params){
		def hours = "00"
		def minutes = "00"
		
		def hourMinutes = [:]
		
		if(params.hours){
			println "hours : "+ params.hours
			if(params.hours.isInteger()){
				def h = params.hours.toInteger()
				if(h < 0 || h > 23){
					hourMinutes.error = "Please enter a valid number for hours between 0 & 23"
					return hourMinutes
				}
				hours = params.hours
			}
			if(!params.hours.isInteger()){
				hourMinutes.error = "Please enter a valid number for hours between 0 & 23"
				return hourMinutes
			}
		}
		
    	
		
		if(params.minutes){
			if(params.minutes.isInteger()){
				def h = params.minutes.toInteger()
				if(h < 0 || h > 59){
					hourMinutes.error = "Please enter a valid number for minutes between 0 & 59"
					return hourMinutes
				}
				minutes = params.minutes
			}
			if(!params.minutes.isInteger()){
				hourMinutes.error= "Please enter a valid number for minutes between 0 & 59"
				return hourMinutes
			}
		}
		
		hourMinutes.hours = hours
		hourMinutes.minutes = minutes
		return hourMinutes
	}
	
}