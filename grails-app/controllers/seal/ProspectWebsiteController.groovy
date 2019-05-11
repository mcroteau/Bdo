package seal

import grails.plugin.springsecurity.annotation.Secured
import java.text.SimpleDateFormat

import io.seal.common.ApplicationConstants
import io.seal.ProspectWebsite
import io.seal.Prospect
import io.seal.Account
import groovy.time.TimeCategory

import io.seal.common.CommonUtilities

class ProspectWebsiteController {

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
		
    	[prospectInstance: prospectInstance, prospectWebsiteInstance: new ProspectWebsite(params) ]
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
			
			def prospectWebsiteInstance = new ProspectWebsite()
			prospectWebsiteInstance.properties = params
			prospectWebsiteInstance.prospect = prospectInstance
			
			if(!prospectWebsiteInstance.save(flush:true)){
				flash.message = "Something went wrong on our end. Please contact support"
				redirect(action: "create", params: params)
				return
			}
			
		    prospectWebsiteInstance.errors.allErrors.each {
		        println it
		    }
			
			
			flash.message = "Website successfully added..."
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
    	def prospectWebsiteInstance = ProspectWebsite.get(id)
    	if (!prospectWebsiteInstance) {
    	    flash.message = "Website wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}  
		
    	[ prospectWebsiteInstance: prospectWebsiteInstance ]
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update(Long id){
		
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}

		def prospectWebsiteInstance = ProspectWebsite.get(id)
    	if (!prospectWebsiteInstance) {
    	    flash.message = "Website wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}
		
		prospectWebsiteInstance.properties = params

   		if (!prospectWebsiteInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating Website, please try again..."
   		    render(view: "edit", model: [prospectWebsiteInstance: prospectWebsiteInstance])
   		    return
   		}
   		
   		flash.message = "Website successfully updated..."
   		redirect(action: "edit", id: prospectWebsiteInstance.id)
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
		
		def prospectWebsiteInstance = ProspectWebsite.get(id)
    	if (!prospectWebsiteInstance) {
			
			if(prospectInstance){
	    	    flash.message = "Prospect wasn't found. Prospect may have already been deleted..."
	    	    redirect(controller: "prospect", action: "edit", id: params.prospectId)
	    	    return
			}
    	    flash.message = "Website wasn't found. It may have already been deleted..."
    	    redirect(controller: "dashboard", action: "index")
    	    return
    	}
		
		try {
			
            prospectWebsiteInstance.delete(flush: true)
            flash.message = "Successfully deleted the Website <strong>" + prospectWebsiteInstance.id + "</strong>"
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete the Website."
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        }
	}
	
	
	
}