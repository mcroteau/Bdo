package seal

import grails.plugin.springsecurity.annotation.Secured
import java.text.SimpleDateFormat

import io.seal.common.ApplicationConstants
import io.seal.ProspectContact
import io.seal.Prospect
import io.seal.Account
import groovy.time.TimeCategory

import io.seal.common.CommonUtilities

class ProspectContactController {

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
		
    	[prospectInstance: prospectInstance, prospectContactInstance: new ProspectContact(params) ]
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
			
			def prospectContactInstance = new ProspectContact()
			prospectContactInstance.properties = params
			prospectContactInstance.prospect = prospectInstance
			
			if(!prospectContactInstance.save(flush:true)){
				flash.message = "Please make sure contact name is complete and you have entered a valid email. Please try again"
				redirect(action: "create", params: params)
			    
				prospectContactInstance.errors.allErrors.each {
			        println it
			    }
				
				return
			}

			
			flash.message = "Contact successfully added..."
	    	redirect(controller:"prospect", action: "action_success")

		}catch(Exception e){
			e.printStackTrace()
			flash.message = "Something went wrong on our end, please contact support. Please make sure you entered a valid email."
			redirect(action: "create", params: params)
			return
		}
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def edit(Long id){
    	def prospectContactInstance = ProspectContact.get(id)
    	if (!prospectContactInstance) {
    	    flash.message = "Contact wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}  
		
    	[ prospectContactInstance: prospectContactInstance ]
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update(Long id){
		
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}

		def prospectContactInstance = ProspectContact.get(id)
    	if (!prospectContactInstance) {
    	    flash.message = "Contact wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}
		
		prospectContactInstance.properties = params

   		if (!prospectContactInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating Contact, please try again..."
   		    render(view: "edit", model: [prospectContactInstance: prospectContactInstance])
   		    return
   		}
   		
   		flash.message = "Contact successfully updated..."
   		redirect(action: "edit", id: prospectContactInstance.id)
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def delete(Long id){
		println "deleting contact"
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}
		
		def prospectContactInstance = ProspectContact.get(id)
    	if (!prospectContactInstance) {
			
			if(prospectInstance){
	    	    flash.message = "Prospect wasn't found. Prospect may have already been deleted..."
	    	    redirect(controller: "prospect", action: "edit", id: params.prospectId)
	    	    return
			}
    	    flash.message = "Contact wasn't found. It may have already been deleted..."
    	    redirect(controller: "dashboard", action: "index")
    	    return
    	}
		
		try {
			
            prospectContactInstance.delete(flush: true)
            flash.message = "Successfully deleted the Contact <strong>" + prospectContactInstance.id + "</strong>"
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete the Contact."
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        }
	}
	
	
	
}