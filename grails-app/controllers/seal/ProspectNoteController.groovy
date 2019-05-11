package seal

import grails.plugin.springsecurity.annotation.Secured
import java.text.SimpleDateFormat

import io.seal.common.ApplicationConstants
import io.seal.ProspectNote
import io.seal.Prospect
import io.seal.Account
import groovy.time.TimeCategory

import io.seal.common.CommonUtilities

class ProspectNoteController {

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
		
    	[prospectInstance: prospectInstance, prospectNoteInstance: new ProspectNote(params) ]
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
			
			def prospectNoteInstance = new ProspectNote()
			prospectNoteInstance.properties = params
			prospectNoteInstance.prospect = prospectInstance
			prospectNoteInstance.account = commonUtilities.getAuthenticatedAccount()
			
			if(!prospectNoteInstance.save(flush:true)){
				flash.message = "Something went wrong on our end. Please contact support"
				redirect(action: "create", params: params)
				return
			}
			
		    prospectNoteInstance.errors.allErrors.each {
		        println it
		    }
			
			
			flash.message = "Note successfully added..."
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
    	def prospectNoteInstance = ProspectNote.get(id)
    	if (!prospectNoteInstance) {
    	    flash.message = "Note wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}  
		
    	[ prospectNoteInstance: prospectNoteInstance ]
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update(Long id){
		
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}

		def prospectNoteInstance = ProspectNote.get(id)
    	if (!prospectNoteInstance) {
    	    flash.message = "Note wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}
		
		prospectNoteInstance.properties = params

   		if (!prospectNoteInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating Note, please try again..."
   		    render(view: "edit", model: [prospectNoteInstance: prospectNoteInstance])
   		    return
   		}
   		
   		flash.message = "Note successfully updated..."
   		redirect(action: "edit", id: prospectNoteInstance.id)
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def delete(Long id){
		
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}
		
		def prospectNoteInstance = ProspectNote.get(id)
    	if (!prospectNoteInstance) {
			
			if(prospectInstance){
	    	    flash.message = "Prospect wasn't found. Prospect may have already been deleted..."
	    	    redirect(controller: "prospect", action: "edit", id: params.prospectId)
	    	    return
			}
    	    flash.message = "Note wasn't found. It may have already been deleted..."
    	    redirect(controller: "dashboard", action: "index")
    	    return
    	}
		
		try {
			
            prospectNoteInstance.delete(flush: true)
            flash.message = "Successfully deleted the Note <strong>" + prospectNoteInstance.id + "</strong>"
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete the Note."
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        }
	}
	
	
	
}