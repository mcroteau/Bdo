package seal

import grails.plugin.springsecurity.annotation.Secured
import java.text.SimpleDateFormat

import io.seal.common.ApplicationConstants
import io.seal.Status
import io.seal.Prospect
import io.seal.Account
import groovy.time.TimeCategory

import io.seal.common.CommonUtilities

class StatusController {

    static allowedMethods = [ save: "POST", update: "POST", delete: "POST"]

	def commonUtilities
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def index(){    	
		def max = 10
		def offset = params?.offset ? params.offset : 0
		def sort = params?.sort ? params.sort : "id"
		def order = params?.order ? params.order : "asc"
		
		def statusInstanceList = Status.list(max: max, sort: sort, order: order, offset: offset)
		def statusInstanceTotal = Status.count()
		
		[ statusInstanceList: statusInstanceList, statusInstanceTotal: statusInstanceTotal]
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def create(){
    	//[statusInstance: new Status(params) ]
    	flash.message = "Status change has been disabled..."
    	redirect(action:"index")
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def save(){
		try{
			
			def existingStatus = Status.findByName(params.name)
			if(existingStatus){
				flash.message = "Name must be unique... please try again"
				redirect(action: "create", params: params)
				return
			}
			
			def statusInstance = new Status()
			statusInstance.properties = params
			
			if(!statusInstance.save(flush:true)){
				flash.message = "Something went wrong on our end. Please contact support"
				redirect(action: "create", params: params)
				return
			}
			
		    statusInstance.errors.allErrors.each {
		        println it
		    }
			
			
			flash.message = "Status successfully added..."
	    	redirect(controller:"status", action: "show", id: statusInstance.id)

		}catch(Exception e){
			e.printStackTrace()
			flash.message = "Something went wrong on our end, please contact support"
			redirect(action: "create", params: params)
			return
		}
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def show(Long id){		    	
		def statusInstance = Status.get(id)
    	if (!statusInstance) {
    	    flash.message = "Status wasn't found. It may have already been deleted..."
    	    redirect(controller: "status", action: "index")
    	    return
    	}  
		
    	[ statusInstance: statusInstance ]
    }
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def edit(Long id){		
    	def statusInstance = Status.get(id)
    	if (!statusInstance) {
    	    flash.message = "Status wasn't found. It may have already been deleted..."
    	    redirect(controller: "status", action: "index")
    	    return
    	}  
		
    	[ statusInstance: statusInstance ]
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def update(Long id){
		def statusInstance = Status.get(id)
    	if (!statusInstance) {
    	    flash.message = "Status wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}
		
		statusInstance.properties = params

   		if (!statusInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating Status, please try again..."
   		    render(view: "edit", model: [statusInstance: statusInstance])
   		    return
   		}
   		
   		flash.message = "Status successfully updated..."
   		redirect(action: "edit", id: statusInstance.id)
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def delete(Long id){
		
		def statusInstance = Status.get(id)
    	if (!statusInstance) {
    	    flash.message = "Status wasn't found. It may have already been deleted..."
    	    redirect(controller: "status", action: "index")
    	    return
    	}
		
		def prospects = Prospect.findAllByStatus(statusInstance)
		
		if(prospects){
			flash.message = "Unable to delete, there are currently prospects with this status assigned to them."
			redirect(action: "index")
			return
		}
		
		try {
			
            statusInstance.delete(flush: true)
            flash.message = "Successfully deleted the Status <strong>" + statusInstance.id + "</strong>"
	    	redirect(controller: "status", action: "index")
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete the Status."
	    	redirect(controller: "status", action: "index")
        }
	}
	
}