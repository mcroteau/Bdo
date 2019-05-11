package seal

import grails.plugin.springsecurity.annotation.Secured
import java.text.SimpleDateFormat

import io.seal.common.ApplicationConstants
import io.seal.Territory
import io.seal.Prospect
import io.seal.Account
import groovy.time.TimeCategory

import io.seal.common.CommonUtilities

class TerritoryController {

    static allowedMethods = [ save: "POST", update: "POST", delete: "POST"]

	def commonUtilities
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def index(){    	
		def max = 10
		def offset = params?.offset ? params.offset : 0
		def sort = params?.sort ? params.sort : "id"
		def order = params?.order ? params.order : "asc"
		
		def territoryInstanceList = Territory.list(max: max, sort: sort, order: order, offset: offset)
		def territoryInstanceTotal = Territory.count()
		
		[ territoryInstanceList: territoryInstanceList, territoryInstanceTotal: territoryInstanceTotal]
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def create(){
    	[territoryInstance: new Territory(params) ]
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def save(){
		try{
			
			def existingTerritory = Territory.findByName(params.name)
			if(existingTerritory){
				flash.message = "Name must be unique... please try again"
				redirect(action: "create", params: params)
				return
			}
			
			def territoryInstance = new Territory()
			territoryInstance.properties = params
			
			if(!territoryInstance.save(flush:true)){
				flash.message = "Something went wrong on our end. Please contact support"
				redirect(action: "create", params: params)
				return
			}
			
		    territoryInstance.errors.allErrors.each {
		        println it
		    }
			
			
			flash.message = "Territory successfully added..."
	    	redirect(controller:"territory", action: "show", id: territoryInstance.id)

		}catch(Exception e){
			e.printStackTrace()
			flash.message = "Something went wrong on our end, please contact support"
			redirect(action: "create", params: params)
			return
		}
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def show(Long id){		    	
		def territoryInstance = Territory.get(id)
    	if (!territoryInstance) {
    	    flash.message = "Territory wasn't found. It may have already been deleted..."
    	    redirect(controller: "territory", action: "index")
    	    return
    	}  
		
    	[ territoryInstance: territoryInstance ]
    }
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def edit(Long id){		
    	def territoryInstance = Territory.get(id)
    	if (!territoryInstance) {
    	    flash.message = "Territory wasn't found. It may have already been deleted..."
    	    redirect(controller: "territory", action: "index")
    	    return
    	}  
		
    	[ territoryInstance: territoryInstance ]
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def update(Long id){
		def territoryInstance = Territory.get(id)
    	if (!territoryInstance) {
    	    flash.message = "Territory wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}
		
		territoryInstance.properties = params

   		if (!territoryInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating Territory, please try again..."
   		    render(view: "edit", model: [territoryInstance: territoryInstance])
   		    return
   		}
   		
   		flash.message = "Territory successfully updated..."
   		redirect(action: "edit", id: territoryInstance.id)
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def delete(Long id){
		
		def territoryInstance = Territory.get(id)
    	if (!territoryInstance) {
    	    flash.message = "Territory wasn't found. It may have already been deleted..."
    	    redirect(controller: "territory", action: "index")
    	    return
    	}
		
		def prospects = Prospect.findAllByTerritory(territoryInstance)
		
		if(prospects){
			flash.message = "Unable to delete, there are currently prospects with this territory assigned to them."
			redirect(action: "index")
			return
		}
		
		try {
			
            territoryInstance.delete(flush: true)
            flash.message = "Successfully deleted the Territory <strong>" + territoryInstance.id + "</strong>"
	    	redirect(controller: "territory", action: "index")
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete the Territory."
	    	redirect(controller: "territory", action: "index")
        }
	}
	
}