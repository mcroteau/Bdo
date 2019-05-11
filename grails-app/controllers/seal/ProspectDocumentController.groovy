package seal

import grails.plugin.springsecurity.annotation.Secured
import java.text.SimpleDateFormat

import grails.io.IOUtils

import java.io.FileOutputStream;
import java.io.FileInputStream

import io.seal.common.ApplicationConstants
import io.seal.ProspectDocument
import io.seal.Prospect
import io.seal.Account
import groovy.time.TimeCategory

import io.seal.common.CommonUtilities

class ProspectDocumentController{

    static allowedMethods = [ save: "POST", update: "POST", delete: "POST"]

	def commonUtilities
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def index(){
    	redirect(action:"create")
	}
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def create(Long id){
		println "here..."
		def prospectInstance = Prospect.get(id)
		if(!prospectInstance){
			flash.message = "Something went wrong, close and try again."
			redirect(controller:"prospect", action:"action_error")
		}
		
    	[prospectInstance: prospectInstance, prospectDocumentInstance: new ProspectDocument(params) ]
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
			
			def prospectDocumentInstance = new ProspectDocument()
			prospectDocumentInstance.properties = params
			prospectDocumentInstance.prospect = prospectInstance
			
			
			
			
			
			def file = request.getFile('file')
			if(file){
				println "file : ${file}"

				def fileSize = file.size
				def originalFileName = file.originalFilename
				
				println "fileSize : ${fileSize} -> ${originalFileName}"
				
				def existingDocument = ProspectDocument.findByFileNameAndFileSize(originalFileName, fileSize)
				
				println "existing : ${existingDocument}"
				println "file size : ${file.size}"
				
				
				def fileName = commonUtilities.generateFileName(file)

				prospectDocumentInstance.fileSize = fileSize
				prospectDocumentInstance.fileName = fileName
				prospectDocumentInstance.originalFileName = originalFileName
				
				
				if(!existingDocument){
					writeFile(file, fileName)
					prospectDocumentInstance.documentUrl = "documents/${fileName}"
				}
				
				
				if(existingDocument){
					prospectDocumentInstance.documentUrl = existingDocument.documentUrl
				}
				
				prospectDocumentInstance.salesPerson = commonUtilities.getAuthenticatedAccount()
				
				
				if(!prospectDocumentInstance.save(flush:true)){
					flash.message = "Something went wrong. Please contact support"
					redirect(action: "create", params: params)
				    
					prospectDocumentInstance.errors.allErrors.each {
				        println it
				    }
					
					return
				}
				
				
				
			}else{
				println "no file selected"
				flash.message = "Please specify a file to upload"
				redirect(action: "create")
				return
			}
			
			flash.message = "Document successfully added..."
	    	redirect(controller:"prospect", action: "action_success")

		}catch(Exception e){
			e.printStackTrace()
			flash.message = "Please specify a file to upload... if this continues, please contact support"
			redirect(action: "create", params: params)
			return
		}
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def edit(Long id){
    	def prospectDocumentInstance = ProspectDocument.get(id)
    	if (!prospectDocumentInstance) {
    	    flash.message = "Document wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}  
		
    	[ prospectDocumentInstance: prospectDocumentInstance ]
	}
	
	
	
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update(Long id){
		
		def prospectInstance = Prospect.get(params.prospectId)
		if(!prospectInstance){
    	    flash.message = "Must have a prospect to work from. Check that the prospect hasn't already been deleted"
    	    redirect(controller: "prospect", action: "action_error")
    	    return
		}

		def prospectDocumentInstance = ProspectDocument.get(id)
    	if (!prospectDocumentInstance) {
    	    flash.message = "Document wasn't found. It may have already been deleted..."
    	    redirect(controller: "prospect", action: "action_error")
    	    return
    	}
		
		prospectDocumentInstance.properties = params

   		if (!prospectDocumentInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating Document, please try again..."
   		    render(view: "edit", model: [prospectDocumentInstance: prospectDocumentInstance])
   		    return
   		}
   		
   		flash.message = "Document successfully updated..."
   		redirect(action: "edit", id: prospectDocumentInstance.id)
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
		
		def prospectDocumentInstance = ProspectDocument.get(id)
    	if (!prospectDocumentInstance) {
			
			if(prospectInstance){
	    	    flash.message = "Prospect wasn't found. Prospect may have already been deleted..."
	    	    redirect(controller: "prospect", action: "edit", id: params.prospectId)
	    	    return
			}
    	    flash.message = "Document wasn't found. It may have already been deleted..."
    	    redirect(controller: "dashboard", action: "index")
    	    return
    	}
		
		try {
			
            prospectDocumentInstance.delete(flush: true)
        	deleteFile(prospectDocumentInstance.fileName)
		
		    flash.message = "Successfully deleted the Document <strong>" + prospectDocumentInstance.id + "</strong>"
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete the Document."
	    	redirect(controller: "prospect", action: "edit", id: params.prospectId)
        }
	}
	
	
	def writeFile(file, fileName){
		def absolutePath = grailsApplication.mainContext.servletContext.getRealPath("documents")
		absolutePath = absolutePath.endsWith("/") ? absolutePath : absolutePath + "/"
		def filePath = "${absolutePath}${fileName}"
		
		InputStream is = file.getInputStream()
		OutputStream os = new FileOutputStream(filePath)
	
		try {
		    IOUtils.copy(is, os);
		} finally {
		    IOUtils.closeQuietly(os);
		    IOUtils.closeQuietly(is);
		}
	}
	
	
	def deleteFile(fileName){
	
    	try{
    		def absolutePath = grailsApplication.mainContext.servletContext.getRealPath("documents")
			absolutePath = absolutePath.endsWith("/") ? absolutePath : absolutePath + "/"
			def filePath = "${absolutePath}${fileName}"
			
    		def file = new File(filePath);
        	
			println "file to delete : ${filePath} : ${file}"
			
    		if(file.delete()){
				println "** deleted file from directory ** ${file.name}"
    		}else{
				println "** something went wrong while trying to delete the file from path... **"
    		}
    	   
    	}catch(Exception e){
    		e.printStackTrace();
    	}
	}
	
	
}