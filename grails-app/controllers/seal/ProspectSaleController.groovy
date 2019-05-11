package seal

import grails.plugin.springsecurity.annotation.Secured
import java.text.SimpleDateFormat

import io.seal.common.ApplicationConstants
import io.seal.ProspectSale
import io.seal.Prospect
import io.seal.Account
import groovy.time.TimeCategory

import io.seal.common.CommonUtilities

class ProspectSaleController {

    static allowedMethods = [ save: "POST", update: "POST", delete: "POST"]

	def commonUtilities
	
	
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
		
    	[prospectInstance: prospectInstance, prospectSaleInstance: new ProspectSale(params) ]
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def save(){
		try{
			def prospectInstance = Prospect.get(params.id)
			if(!prospectInstance){
				flash.message = "Prospect wasn't found. Please make sure the Prospect hasn't been deleted"
				redirect(controller: "prospect", action: "action_error")
				return
			}
			
			def prospectSaleInstance = new ProspectSale()
			prospectSaleInstance.properties = params
			prospectSaleInstance.prospect = prospectInstance
			prospectSaleInstance.salesPerson = commonUtilities.getAuthenticatedAccount()

			if(!prospectSaleInstance.save(flush:true)){
				flash.message = "Something went wrong on our end. Please contact support"
				redirect(action: "create", params: params)
				return
			}
			
		    prospectSaleInstance.errors.allErrors.each {
		        println it
		    }
			
			
			flash.message = "Sale successfully added..."
	    	redirect(controller:"prospect", action: "action_success")

		}catch(Exception e){
			e.printStackTrace()
			flash.message = "Something went wrong on our end, please contact support"
			redirect(action: "create", params: params)
			return
		}
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def edit(Long id){		
    	def prospectSaleInstance = ProspectSale.get(id)
    	if (!prospectSaleInstance) {
    	    flash.message = "Sale wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}  
		
    	[ prospectSaleInstance: prospectSaleInstance ]
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update(Long id){
		
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}

		def prospectSaleInstance = ProspectSale.get(id)
    	if (!prospectSaleInstance) {
    	    flash.message = "Sale wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}
		
		prospectSaleInstance.properties = params

   		if (!prospectSaleInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating Sale, please try again..."
   		    render(view: "edit", model: [prospectSaleInstance: prospectSaleInstance])
   		    return
   		}
   		
   		flash.message = "Sale successfully updated..."
   		redirect(action: "edit", id: prospectSaleInstance.id)
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def delete(Long id){
		
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}
		
		def prospectSaleInstance = ProspectSale.get(id)
    	if (!prospectSaleInstance) {
			
			if(prospectInstance){
	    	    flash.message = "Prospect wasn't found. Prospect may have already been deleted..."
	    	    redirect(controller: "prospect", action: "edit", id: params.prospectId)
	    	    return
			}
    	    flash.message = "Sale wasn't found. It may have already been deleted..."
    	    redirect(controller: "dashboard", action: "index")
    	    return
    	}
		
		try {
			
            prospectSaleInstance.delete(flush: true)
            flash.message = "Successfully deleted the Sale <strong>" + prospectSaleInstance.id + "</strong>"
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete the Sale."
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        }
	}
	
	
	
}