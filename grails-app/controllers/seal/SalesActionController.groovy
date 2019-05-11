package seal

import io.seal.Account
import io.seal.SalesAction
import io.seal.ProspectSalesAction

import grails.plugin.springsecurity.annotation.Secured
import io.seal.common.ApplicationConstants

class SalesActionController {

	def springSecurityService

	def commonUtilities
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def current(){
		def accountInstance = commonUtilities.getAuthenticatedAccount()
		println "accountInstance : ${accountInstance}"
		def prospectSalesActions = ProspectSalesAction.findAllByAccountAndStatus(accountInstance, ApplicationConstants.SALES_ACTION_ACTIVE)
		
		if(params.all == "true"){
			prospectSalesActions = ProspectSalesAction.list()
		}
		
		[ prospectSalesActions: prospectSalesActions, all: params.all ]
	}



	@Secured([ApplicationConstants.ROLE_ADMIN])
	def index(){
		def max = 10
		def offset = params?.offset ? params.offset : 0
		def sort = params?.sort ? params.sort : "id"
		def order = params?.order ? params.order : "asc"

		def salesActionInstanceList = SalesAction.list(max: max, sort: sort, order: order, offset: offset)
		ded salesActionInstanceTotal = SalesAction.count()

		[ salesActionInstanceList: salesActionInstanceList, salesActionInstanceTotal: salesActionInstanceTotal]
	}



	@Secured([ApplicationConstants.ROLE_ADMIN])
	def create(){
		[salesActionInstance: new SalesAction(params) ]
	}



	@Secured([ApplicationConstants.ROLE_ADMIN])
	def save(){
		try{

			def existingSalesAction = SalesAction.findByName(params.name)
			if(existingSalesAction){
				flash.message = "Name must be unique... please try again"
				redirect(action: "create", params: params)
				return
			}

			def salesActionInstance = new SalesAction()
			salesActionInstance.properties = params

			if(!salesActionInstance.save(flush:true)){
				flash.message = "Something went wrong on our end. Please contact support"
				redirect(action: "create", params: params)
				return
			}

			salesActionInstance.errors.allErrors.each {
				println it
			}


			flash.message = "SalesAction successfully added..."
			redirect(controller:"salesAction", action: "show", id: salesActionInstance.id)

		}catch(Exception e){
			e.printStackTrace()
			flash.message = "Something went wrong on our end, please contact support"
			redirect(action: "create", params: params)
			return
		}
	}



	@Secured([ApplicationConstants.ROLE_ADMIN])
	def show(Long id){
		def salesActionInstance = SalesAction.get(id)
		if (!salesActionInstance) {
			flash.message = "SalesAction wasn't found. It may have already been deleted..."
			redirect(controller: "salesAction", action: "index")
			return
		}

		[ salesActionInstance: salesActionInstance ]
	}




	@Secured([ApplicationConstants.ROLE_ADMIN])
	def edit(Long id){
		def salesActionInstance = SalesAction.get(id)
		if (!salesActionInstance) {
			flash.message = "SalesAction wasn't found. It may have already been deleted..."
			redirect(controller: "salesAction", action: "index")
			return
		}

		[ salesActionInstance: salesActionInstance ]
	}






	@Secured([ApplicationConstants.ROLE_ADMIN])
	def update(Long id){
		def salesActionInstance = SalesAction.get(id)
		if (!salesActionInstance) {
			flash.message = "SalesAction wasn't found. It may have already been deleted..."
			redirect(controller: "prospect", action: "action_error")
			return
		}

		salesActionInstance.properties = params

		if (!salesActionInstance.save(flush: true)) {
			flash.message = "Something went wrong when updating SalesAction, please try again..."
			render(view: "edit", model: [salesActionInstance: salesActionInstance])
			return
		}

		flash.message = "SalesAction successfully updated..."
		redirect(action: "edit", id: salesActionInstance.id)
	}




	@Secured([ApplicationConstants.ROLE_ADMIN])
	def delete(Long id){

		def salesActionInstance = SalesAction.get(id)
		if (!salesActionInstance) {
			flash.message = "SalesAction wasn't found. It may have already been deleted..."
			redirect(controller: "salesAction", action: "index")
			return
		}

		def prospects = Prospect.findAllBySalesAction(salesActionInstance)

		if(prospects){
			flash.message = "Unable to delete, there are currently prospects with this salesAction assigned to them."
			redirect(action: "index")
			return
		}

		try {

			salesActionInstance.delete(flush: true)
			flash.message = "Successfully deleted the SalesAction <strong>" + salesActionInstance.id + "</strong>"
			redirect(controller: "salesAction", action: "index")

		} catch (Exception e) {
			e.printStackTrace()
			flash.message = "Something went wrong while trying to delete the SalesAction."
			redirect(controller: "salesAction", action: "index")
		}
	}

}