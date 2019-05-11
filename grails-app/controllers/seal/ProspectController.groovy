package seal

import static org.springframework.http.HttpStatus.OK
import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*

import io.seal.common.ApplicationConstants

import io.seal.ProspectSalesAction
import io.seal.ProspectContact
import io.seal.ProspectDocument
import io.seal.ProspectNote
import io.seal.ProspectWebsite

import io.seal.Prospect
import io.seal.Country

import io.seal.Territory
import io.seal.Status
import io.seal.ImportJob
import io.seal.ProspectSize
import io.seal.SalesAction

import io.seal.SalesEffort


class ProspectController {

	static allowedMethods = [ save: "POST", update: "POST", delete: "POST", update_selected: "POST"]
	

	def commonUtilities
	def encoding
	def csvMimeType


	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def index(){
		redirect(action: "search")
	}
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def search(){
		def prospectInstanceList = Prospect.list()
		[prospectInstanceList: prospectInstanceList]
	}
	
	/**Uses DataTables**/
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def search_results(){
		def query = ""
		
		if(params.query){
			query = params.query.trim()
			query = query.replaceAll("[\\t\\n\\r]+"," ");
		}
		
		def territory = [:]
		if(params.territory?.id){
			territory = Territory.get(params.territory.id)
			query = query + " " + territory?.name
		}
		
		def status = [:]
		if(params.status?.id){
			status = Status.get(params.status.id)
			query = query + " " + status?.name
		}
		
		def verified = ""
		if(params.verified){
			verified = params.verified == "true" ? "Verified" : "Verified Needed"
			query = query + " " + verified
		}
		query = query.replaceAll("[\\t\\n\\r]+"," ");
		
		println "query : " + query
		
		def prospectInstanceList = Prospect.list()
		[prospectInstanceList: prospectInstanceList, query: query]
	}
	
	
	/**traditional search**/
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def results(){
		

		def prospectInstanceTotal = 0
		def prospectInstanceList = []
		
		if(session["prospects"] && 
			(!params.search || params.search == "false")){

			println "returning session results..."

			session["prospects"].each{ id ->

				def prospect = Prospect.get(id)

				if(prospect){
					prospectInstanceList.add(prospect)
					prospectInstanceTotal++
				}

			}

		}


		if(params.search == "true"){
			println "performing search...."
			if(params.query){
				//gather prospects by query
				//check if territory, status, verified
				//gather by each
				//collect into one unique list
				//no pagination
				//save ids into session
				def countCriteria = Prospect.createCriteria()
				def prospectCriteria = Prospect.createCriteria()
				
				def queryString = params.query.replaceAll("[\\t\\n\\r]+"," ");
				def queries = queryString.split(" ")
				
				//prospectInstanceList = prospectCriteria.list(max: max, offset: offset, sort: sort, order: order){
				prospectInstanceList = prospectCriteria.list(){
					or {
						queries.each(){ query ->
							ilike("company", "%${query}%")
							ilike("contactName", "%${query}%")
							ilike("address1", "%${query}%")
							ilike("address2", "%${query}%")
							ilike("city", "%${query}%")
							ilike("phone", "%${query}%")
							ilike("cellPhone", "%${query}%")
							ilike("email", "%${query}%")
						}
					}
				}
				
				if(params.territory?.id){
					def territory = Territory.get(params.territory?.id)
					if(territory){
						def p1 = Prospect.findAllByTerritory(territory)
						prospectInstanceList = prospectInstanceList + p1
						prospectInstanceList.unique()
					}
				}
				if(params.status?.id){
					def status = Status.get(params.status?.id)
					if(status){
						def p2 = Prospect.findAllByStatus(status)
						prospectInstanceList = prospectInstanceList + p2
						prospectInstanceList.unique()
					}
				}
				if(params.verified){
					def p3 = Prospect.findAllByVerified(params.verified)
					if(p3){
						prospectInstanceList = prospectInstanceList + p3
						prospectInstanceList.unique()
					}
				}
				if(params.salesAction?.id){
					def salesAction = SalesAction.get(params.salesAction?.id)
					if(salesAction){
						def salesActions = ProspectSalesAction.findAllBySalesAction(salesAction.id)
						def p4 = salesActions.collect { it.prospect }
						prospectInstanceList = prospectInstanceList + p4
						prospectInstanceList.unique()
					}
				}
			
			}else{
				/**dont filter at all**/
				if(!params.territory?.id && !params.status?.id && !params.verified && !params.salesAction?.id){
					prospectInstanceList = Prospect.list()
				}else{
					if(params.territory?.id){
						def territory = Territory.get(params.territory?.id)
						if(territory){
							def p1 = Prospect.findAllByTerritory(territory)
							prospectInstanceList = prospectInstanceList + p1
							prospectInstanceList.unique()
						}
					}
					if(params.status?.id){
						def status = Status.get(params.status?.id)
						if(status){
							def p2 = Prospect.findAllByStatus(status)
							prospectInstanceList = prospectInstanceList + p2
							prospectInstanceList.unique()
						}
					}
					if(params.verified){
						def p3 = Prospect.findAllByVerified(params.verified)
						if(p3){
							prospectInstanceList = prospectInstanceList + p3
							prospectInstanceList.unique()
						}
					}
					if(params.salesAction?.id){
						def salesAction = SalesAction.get(params.salesAction?.id)
						println "sales action" + salesAction
						if(salesAction){
							def salesActions = ProspectSalesAction.findAllBySalesAction(salesAction)
							def p4 = salesActions.collect { it.prospect }
							prospectInstanceList = prospectInstanceList + p4
							prospectInstanceList.unique()
						}
					}
				}
			}
			
			
			//prospectInstanceList.sort { a, b -> a?.state?.name <=> b?.state?.name }
			//prospectInstanceList.sort { a, b -> b?.state?.name <=> a?.state?.name }
		}


		if(params.sort == "importUuid" || params.sort == "company" || params.sort == "city" || 
				params.sort == "zip" || params.sort == "contactName" || params.sort == "verified" ){
			if(params.order == "asc")prospectInstanceList.sort { a, b -> a[params.sort] <=> b[params.sort] }
			if(params.order == "desc")prospectInstanceList.sort { a, b -> b[params.sort] <=> a[params.sort] }
		}
		
		if(params.sort == "territory" || params.sort == "status" || params.sort == "state"){
			if(params.order == "asc")prospectInstanceList.sort { a, b -> a[params.sort]?.name <=> b[params.sort]?.name }
			if(params.order == "desc")prospectInstanceList.sort { a, b -> b[params.sort]?.name <=> a[params.sort]?.name }
		}
		
		if(params.sort == "size"){
			if(params.order == "asc")prospectInstanceList.sort { a, b -> a?.prospectSize?.id <=> b?.prospectSize?.id }
			if(params.order == "desc")prospectInstanceList.sort { a, b -> b?.prospectSize?.id <=> a?.prospectSize?.id }
		}



		def ids = []
		def containsImports = false
		prospectInstanceList.eachWithIndex { prospect, index ->
			ids[index] = prospect.id
			if(prospect.importUuid)containsImports = true
		}
		
		session["prospects"] = ids
		
		[ prospectInstanceList: prospectInstanceList, containsImports: containsImports ]
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def create(){
    	[prospectInstance: new Prospect(params), countries: Country.list()]
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def save(){
		def prospectInstance = new Prospect(params)
		
		if(!prospectInstance.company && !prospectInstance.contactName){
			flash.message = "Please make sure company or contact name is complete"
			redirect(action: "create", params:params)
			return
		}
		
		if(prospectInstance.validate()){
			prospectInstance.save(flush:true)
			
			flash.message = "Prospect successfully created..."
	       	redirect(action: "show", id: prospectInstance.id)
			
		}else{
			def message = "Something went wrong while saving prospect.<br/>"
			message = message + "Please make sure Company or Contact Name is complete...<br/>"
			
			flash.message = message
			
		    prospectInstance.errors.allErrors.each {
		        println it
		    }
			redirect(action: 'create', params: params)
		}
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def edit(Long id){
    	def prospectInstance = Prospect.get(id)
    	if (!prospectInstance) {
    	    flash.message = "Prospect not found"
    	    redirect(action: "message")
    	    return
    	}  
		
		//println session["prospects"].findIndexOf {
		//    it == id;
		//}
		
		def salesEffortInstance = prospectInstance.currentSalesEffort
		def completedSalesEfforts = SalesEffort.countByProspectAndRecording(prospectInstance, false)
		def upcomingSalesActions = ProspectSalesAction.findAllByProspectAndCompleted(prospectInstance, false)
		def completedSalesActionsCount = ProspectSalesAction.countByProspectAndCompleted(prospectInstance, true)
		
		[prospectInstance: prospectInstance, countries: Country.list(), upcomingSalesActions: upcomingSalesActions, 
			completedSalesActionsCount: completedSalesActionsCount, salesEffortInstance: salesEffortInstance, completedSalesEfforts: completedSalesEfforts]
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def history(Long id){
    	def prospectInstance = Prospect.get(id)
    	if (!prospectInstance) {
    	    flash.message = "Prospect was not found. Please contact support"
    	    redirect(action: "message")
    	    return
    	}  

		def salesEffortInstance = prospectInstance.currentSalesEffort
		def completedSalesEfforts = SalesEffort.countByProspectAndRecording(prospectInstance, false)
		def pastSalesEfforts = SalesEffort.findAllByProspectAndRecording(prospectInstance, false)
		def upcomingSalesActions = ProspectSalesAction.findAllByProspectAndCompleted(prospectInstance, false)
		def completedSalesActionsCount = ProspectSalesAction.countByProspectAndCompleted(prospectInstance, true)
		def completedSalesActions = ProspectSalesAction.findAllByProspectAndCompleted(prospectInstance, true)
		
		[prospectInstance: prospectInstance, upcomingSalesActions: upcomingSalesActions, 
			completedSalesActionsCount: completedSalesActionsCount, salesEffortInstance: salesEffortInstance, 
			completedSalesEfforts: completedSalesEfforts, pastSalesEfforts: pastSalesEfforts, completedSalesActions: completedSalesActions]	
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def show(Long id){
   		def prospectInstance = Prospect.get(id)
   		if (!prospectInstance) {
   		    flash.message = "Prospect not found"
   		    redirect(action: "message")
   		    return
   		}  		
   		[prospectInstance: prospectInstance, countries: Country.list()]	
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update(Long id){
		def prospectInstance = Prospect.get(id)
		
   		if (!prospectInstance) {
   		    flash.message = "Prospect not found..."
   		    redirect(action: "message")
   		    return
   		}
		println "params:  " + params
		prospectInstance.properties = params

   		if (!prospectInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating prospect, please try again..."
   		    render(view: "edit", model: [prospectInstance: prospectInstance])
   		    return
   		}
   		
   		flash.message = "Prospect successfully updated..."
   		redirect(action: "edit", id: prospectInstance.id)
	}
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def delete(Long id){
		def prospectInstance = Prospect.get(id)
		if(!prospectInstance){
			flash.message = "Prospect not found... it may have been deleted already"
			redirect(action: "message")
			return
		}
		try{

			deleteProspectAttributes(prospectInstance)
			
			prospectInstance.delete(flush:true)
			flash.message = "Successfully deleted Prospect " + prospectInstance.id
			redirect(action: "message")
		}catch(Exception e){
			e.printStackTrace()
			flash.message = "Something went wrong " + e
			redirect(action: "edit", id: prospectInstance.id)
		}
	}
	
	

	def deleteProspectAttributes(prospectInstance){
		def salesActions = ProspectSalesAction.findAllByProspect(prospectInstance)
		salesActions?.each(){
			it.delete(flush:true)
		}
		
		def contacts = ProspectContact.findAllByProspect(prospectInstance)
		contacts?.each(){
			it.delete(flush:true)
		}
		
		def notes = ProspectNote.findAllByProspect(prospectInstance)
		notes?.each(){
			it.delete(flush:true)
		}
		
		def documents = ProspectDocument.findAllByProspect(prospectInstance)
		documents?.each(){
			it.delete(flush:true)
		}
		
		def websites = ProspectWebsite.findAllByProspect(prospectInstance)
		websites?.each(){
			it.delete(flush:true)
		}

		prospectInstance.currentSalesEffort = null
		prospectInstance.save(flush:true)

		def salesEfforts = SalesEffort.findAllByProspect(prospectInstance)
		salesEfforts.each { 
			it.delete(flush:true)
		}
	}
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def edit_selected(){
		println "ids : " + params.ids
		if(!params.ids){
			flash.message = "You haven't selected any prospects to update yet..."
			redirect(action:"action_error")
			return
		}
		def prospectIds = params.ids.split(",")
		def ids = []
		def prospectInstanceList = []
		prospectIds.each(){ it ->
			def prospectInstance = Prospect.get(it)
			if(prospectInstance){
				ids.add(it)
				prospectInstanceList.add(prospectInstance)
			}
		}
		
		[ids: ids.join(", "), prospectInstanceList: prospectInstanceList]
	}
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update_selected(){
		if(!params.ids){
			flash.message = "You haven't selected any prospects to update yet..."
			redirect(action:"action_error")
			return
		}

		def prospectIds = params.ids.split(",")
		
		def prospectInstanceList = []
		prospectIds.each(){
			def prospectInstance = Prospect.get(it)
			if(prospectInstance){
				if(params.territory){
					def territory = Territory.get(params.territory.id)
					if(territory){
						println "territory" + territory
						prospectInstance.territory = territory
					}
				}

				if(params.status){
					def status = Status.get(params.status.id)
					if(status){
						println "status" + status
						prospectInstance.status = status
					}
				}

				if(params.verified){
					println "params.verified : ${params.verified}"
					prospectInstance.verified = params.verified.toBoolean()
				}
				
				prospectInstance.save(flush:true)

				println "prospectInstance.verified : " + prospectInstance.verified
			}
		}
		flash.message = "Successfully updated all selected prospects..."
		redirect(action: "action_success")
	}
	
	

	@Secured([ApplicationConstants.ROLE_ADMIN])
	def confirm_delete_selected(){
		if(!params.ids){
			flash.message = "You haven't selected any prospects to delete yet..."
			redirect(action: "action_error")
			return
		}
		def prospectIds = params.ids.split(",")
		println "prospect ids : " + prospectIds
		def ids = []
		def prospectInstanceList = []
		prospectIds.each(){ it ->
			def prospectInstance = Prospect.get(it)
			if(prospectInstance){
				ids.add(prospectInstance.id)
				prospectInstanceList.add(prospectInstance)
			}
		}
		
		println "join : " + ids.join(", ")

		[ids: ids.join(", "), prospectInstanceList: prospectInstanceList]
	}



	@Secured([ApplicationConstants.ROLE_ADMIN])
	def delete_selected(){
		if(!params.ids){
			flash.message = "You haven't selected any prospects to update yet..."
			redirect(action:"action_error")
			return
		}

		def prospectIds = params.ids.split(",")
		
		def prospectInstanceList = []
		prospectIds.each(){
			def prospectInstance = Prospect.get(it)
			if(prospectInstance){
				deleteProspectAttributes(prospectInstance)
				prospectInstance.delete(flush:true)
			}
		}
		flash.message = "Successfully deleted all selected prospects..."
		redirect(action: "action_success")
	}




	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def remove_selected(){
		if(!params.ids){
			flash.message = "You haven't selected any prospects to update yet..."
			redirect(action: "action_error")
			return
		}
		def prospectIds = params.ids.split(",")
		println "prospects being removed : " + prospectIds

		def idsNumerical = []
		prospectIds.each{ id -> idsNumerical.add(id as Integer)}

		def remove = []
		idsNumerical.each { n ->
			session["prospects"].eachWithIndex { o, index ->
				if(n == o){
					remove.add(o)
				}
			}
		}

		remove.each{
			session["prospects"].remove(it)
		}

		redirect(action: "results")
	}



	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def export_selected(){
		if(!params.ids){
			flash.message = "You haven't selected any prospects to export yet..."
			redirect(action: "action_error")
			return
		}
		def prospectIds = params.ids.split(",")
		println "prospects being exported : " + prospectIds

		def idsNumerical = []
		prospectIds.each{ id -> idsNumerical.add(id as Integer)}

		def prospects = []
		idsNumerical.each {
			def prospect = Prospect.get(it)
			if(prospect)prospects.add(prospect)
		}


		def prospectsCsvLines = commonUtilities.createProspectCsvLines(prospects)


        def filename = "prospects.csv"
        def outs = response.outputStream
        response.status = OK.value()
        response.contentType = "${csvMimeType};charset=${encoding}";
        response.setHeader "Content-disposition", "attachment; filename=${filename}"
 
        prospectsCsvLines.each { String line ->
        	println line
            outs << "${line}\n"
        }
 
        outs.flush()
        outs.close()
	}




	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def export_results(){
		def prospects = []
		session["prospects"].each{ id ->
			def prospect = Prospect.get(id)
			if(prospect)prospects.add(prospect)
		}

		if(!prospects){
			flash.message = "No prospects selected..."
			redirect(action: "results")
			return
		}

		def prospectsCsvLines = commonUtilities.createProspectCsvLines(prospects)


        def filename = "prospects.csv"
        def outs = response.outputStream
        response.status = OK.value()
        response.contentType = "${csvMimeType};charset=${encoding}";
        response.setHeader "Content-disposition", "attachment; filename=${filename}"
 
        prospectsCsvLines.each { String line ->
        	println line
            outs << "${line}\n"
        }
 
        outs.flush()
        outs.close()
	}



	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def imports(){    	
		def max = 20
		def offset = params?.offset ? params.offset : 0
		def sort = params?.sort ? params.sort : "id"
		def order = params?.order ? params.order : "asc"
		
		def importJobInstances = ImportJob.list(max: max, sort: sort, order: order, offset: offset)
		
		importJobInstances.each{ importJob ->
			def prospects = Prospect.countByImportUuid(importJob.uuid)
			importJob.metaClass.prospects = prospects
		}
		
		def importJobInstanceTotal = ImportJob.count()
		[importJobInstances : importJobInstances, importJobInstanceTotal: importJobInstanceTotal]
	}
		
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def imported(Long id){    	
		def importJob = ImportJob.get(id)
		if(!importJob){
			flash.message = "Unable to find import... please try again"
			redirect(action: "imports")
			return
		}
			
		def sort = params?.sort ? params.sort : "id"
		def order = params?.order ? params.order : "asc"
			
		def prospectInstanceList = Prospect.findAllByImportUuid(importJob.uuid, [sort: sort, order: order])
		
		println "prospectInstanceList : ${prospectInstanceList.size()}"
		
		def ids = []
		prospectInstanceList.eachWithIndex { prospect, index ->
			ids[index] = prospect.id
		}
		session["prospects"] = ids
		
		[ prospectInstanceList: prospectInstanceList, importJob: importJob ]
	}	
		
		
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def delete_import(Long id){
		def importJobInstance = ImportJob.get(id)
		if(!importJobInstance){
			flash.message = "Import not found... it may have been deleted already"
			redirect(action: "imports")
			return
		}
		try{
			def prospects = Prospect.findAllByImportUuid(importJobInstance.uuid)
			prospects?.each(){
				it.delete(flush:true)
			}
			
			importJobInstance.delete(flush:true)
			
			flash.message = "Successfully delete import..."
			redirect(action: "imports")
			
		}catch(Exception e){
			e.printStackTrace()
		}
	}
	
		
		
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def action_success(){}
		
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def action_error(){}
		
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def message(){}
	
}