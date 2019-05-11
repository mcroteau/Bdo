package seal

import grails.plugin.springsecurity.annotation.Secured
import groovy.text.SimpleTemplateEngine

import io.seal.common.ApplicationConstants
import io.seal.Account
import io.seal.Role
import io.seal.AccountRole
import io.seal.Permission
import io.seal.Country

class AccountController {

    static allowedMethods = [ save: "POST", update: "POST", delete: "POST", reset_password: "POST"]
	
	
	def emailService
	def applicationService
	def springSecurityService
	def commonUtilities
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def index(){
    	def max = 10
		def offset = params?.offset ? params.offset : 0
		def sort = params?.sort ? params.sort : "id"
		def order = params?.order ? params.order : "asc"
		
		def accountInstanceList = []
		def accountInstanceTotal = 0

		def hasAdminRole = (params?.admin && params?.admin == "true") ? true : false
		
		if(params.query){
			
			def accountCriteria = Account.createCriteria()
			def countCriteria = Account.createCriteria()

			accountInstanceTotal = countCriteria.count(){
				and{
					or {
						ilike("username", "%${params.query}%")
						ilike("name", "%${params.query}%")
					}
					eq("hasAdminRole", hasAdminRole)
				}
			}
			
			
			accountInstanceList = accountCriteria.list(max: max, offset: offset, sort: sort, order: order){
				and{
					or {
						ilike("username", "%${params.query}%")
						ilike("name", "%${params.query}%")
					}
					eq("hasAdminRole", hasAdminRole)
				}
			}
		
		}else{
			accountInstanceList = Account.findAllByHasAdminRole(hasAdminRole, [max: max, offset: offset, sort: sort, order: order])
			accountInstanceTotal = Account.countByHasAdminRole(hasAdminRole)
		}
		
		[ accountInstanceList: accountInstanceList, accountInstanceTotal: accountInstanceTotal, admin: hasAdminRole, query : params.query ]
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def create(){
		if(params.admin == "true")request.admin = "true"
		
    	[accountInstance: new Account(params), countries: Country.list()]
	}
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def show(Long id){
   		def accountInstance = Account.get(id)
   		if (!accountInstance) {
   		    flash.message = "Account not found"
   		    redirect(action: "index")
   		    return
   		}  		
   		[accountInstance: accountInstance, countries: Country.list()]	
	}

	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def save(){
		def accountInstance = new Account(params)
		
   		def password = springSecurityService.encodePassword(params.password)
		accountInstance.password = password

		def includeAdminRole = false
		if(params.admin == "true" ||
				params.admin == "on"){
			includeAdminRole = true
		}
		
		accountInstance.hasAdminRole = includeAdminRole
		
		if(accountInstance.validate()){
			accountInstance.save(flush:true)
			
			accountInstance.createAccountRoles(includeAdminRole)
			accountInstance.createAccountPermission()

	       	flash.message = "Account successfully created..."
	       	redirect(action: "show", id: accountInstance.id)
			
		}else{
			def message = "Something went wrong while saving account.<br/>"
			message = message + "Please make sure username is a valid email address and is not already in use.<br/>"
			
			flash.message = message
			
		    accountInstance.errors.allErrors.each {
		        println it
		    }
			redirect(action: 'create', accountInstance: accountInstance, params: params)
		}
	}
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def edit(Long id){
    	def accountInstance = Account.get(id)
    	if (!accountInstance) {
    	    flash.message = "Account not found"
    	    redirect(action: "index")
    	    return
    	}   	

		def admin = false
		if(accountInstance.hasAdminRole)admin = true
		
    	[accountInstance: accountInstance, admin : admin, countries: Country.list()]
	}
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def update(Long id){
		def accountInstance = Account.get(id)
		
   		if (!accountInstance) {
   		    flash.message = "Account not found"
   		    redirect(action: "index")
   		    return
   		}

		
		accountInstance.properties = params
		def adminRole = Role.findByAuthority(ApplicationConstants.ROLE_ADMIN)
		

		if(params.admin == "true" ||
				params.admin == "on"){
			accountInstance.createAccountRole(adminRole)
			accountInstance.hasAdminRole = true
		}else{
			def accountRole = AccountRole.findByRoleAndAccount(adminRole, accountInstance)
			if(accountRole){
				accountRole.delete(flush:true)
				accountInstance.hasAdminRole = false
			}
		}

   		if (!accountInstance.save(flush: true)) {
   			flash.message = "Something went wrong when updating account, please try again..."
   		    render(view: "edit", model: [accountInstance: accountInstance])
   		    return
   		}
   		
   		flash.message = "Account successfully updated"
   		redirect(action: "show", id: accountInstance.id)
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def delete(Long id){
		def accountInstance = Account.get(id)
    	if (!accountInstance) {
    	    flash.message = "Account not found..."
    	    redirect(action: "index")
    	    return
    	}
		
		try {
			
			def accountRoles = AccountRole.findAllByAccount(accountInstance)
			accountRoles.each(){
				it.delete(flush:true)
			}

			def permissions = Permission.findAllByAccount(accountInstance)
			permissions.each(){
				it.delete(flush:true)
			}
            accountInstance.delete(flush: true)
            flash.message = "Successfully deleted the account...."
            redirect(action: "index")
        
        } catch (Exception e) {
			e.printStackTrace()
            flash.message = "Something went wrong while trying to delete."
            redirect(action: "edit", id: id)
        }
	}
	
	
	
	@Secured([ApplicationConstants.PERMIT_ALL])
	def forgot(){}



	@Secured([ApplicationConstants.PERMIT_ALL])	
	def send_forgot(){

		if(params.username){

			def accountInstance = Account.findByUsername(params.username)
			if(accountInstance){
				def resetUUID = UUID.randomUUID()
				accountInstance.resetUUID = resetUUID
				accountInstance.save(flush:true)
				
				def url = request.getRequestURL()
				
				def split = url.toString().split("/${applicationService.getContextName()}/")
				def httpSection = split[0]
				def resetUrl = "${httpSection}/${applicationService.getContextName()}/abcrAccount/confirm_reset?"
				def params = "username=${accountInstance.username}&uuid=${resetUUID}"
				resetUrl+= params
				
				//http://localhost:9463/abcr/abcrAccount/confirm_reset?username=admin@mail.com&uuid=e4cd4247-7a92-4e5c-9c38-0de54021e3fc
				println "reset url " + resetUrl
				
				sendResetPasswordEmail(accountInstance, resetUrl)
			}else{
				flash.message = "Account not found with following username : ${params.username}"
				redirect(action: "forgot")
			}
		}else{
			flash.message = "Please enter an email to continue the reset password process"
			redirect(action: "forgot")
		}
	
	}
	

	@Secured([ApplicationConstants.PERMIT_ALL])
	def confirm_reset(){
		def accountInstance = Account.findByUsernameAndResetUUID(params.username, params.uuid)
		
		if(!accountInstance){
			flash.message = "Something went wrong, please try again."
			redirect(action: 'forgot')
		}	

		[accountInstance: accountInstance]	
	}
	
	
	@Secured([ApplicationConstants.PERMIT_ALL])
	def reset_password(){
		def username = params.username
		def newPassword = params.password
		def confirmPassword = params.confirmPassword
		
		def accountInstance = Account.findByUsername(username)
		if(accountInstance && newPassword && confirmPassword){	
		
			if(confirmPassword == newPassword){
			
				if(newPassword.length() >= 5){
					
					def password = springSecurityService.encodePassword(newPassword)
					accountInstance.password = password
					
					if(accountInstance.save(flush:true)){
				
						//def authToken = new UsernamePasswordToken(username, newPassword as String)					
						flash.message = "Successfully reset password... Login with new credentials"
						redirect(controller : "login", action : "auth", params : [ username : username ])
						return

					}else{
						flash.message = "We were unable to reset your password, please try again."
						redirect(action:'confirm_reset', params : [username : username, uuid : accountInstance.resetUUID ])
					}
				}else{
					flash.message = "Passwords must be at least 5 characters in length. Please try again"
					redirect(action: 'confirm_reset', params : [uuid : accountInstance.resetUUID, username : username])
				}

			}else{
				flash.message = "Passwords must match. Please try again"
				redirect(action: 'confirm_reset', params : [uuid : accountInstance.resetUUID, username : username])
				
			}
		}else{
			flash.message = "Password cannot be blank, please try again."
			redirect(action: 'confirm_reset', params : [uuid : accountInstance.resetUUID, username : username])
		}
	}
	
	

	@Secured([ApplicationConstants.ROLE_ADMIN])
	def change_password(Long id){
		def accountInstance = Account.get(id)
		if(!accountInstance){
			flash.message = "Account not found with id : " + id + ". Please try again"
			redirect(action:"index")
			return
		}
		[accountInstance: accountInstance]
	}
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def update_password(){
		def accountInstance = Account.get(params.id)
		if(!accountInstance){
			flash.message = "Account not found with id : " + params.id + ". Please try again"
			redirect(action:"index")
			return
		}
		def password = params.password
		if(password.length() < 5){
			flash.message = "Password needs to be 5 characters in length at the least."
			redirect(action:"index")
			return
		}
		
		accountInstance.password = springSecurityService.encodePassword(password)
		accountInstance.save(flush:true)
		
		flash.message = "Password successfully updated..."
		redirect(action:"edit", id : accountInstance.id)
	}
	



	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def account(){
		def accountInstance = commonUtilities.getAuthenticatedAccount()
		[accountInstance : accountInstance]
	}	


	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def update_account(){
		def accountInstance = commonUtilities.getAuthenticatedAccount()

		accountInstance.properties = params
		accountInstance.phone = params.phone

		println "phone : ${accountInstance.phone}"

		def password = params.password
		
		if(password){
			accountInstance.password = springSecurityService.encodePassword(password)
		}

		accountInstance.save(flush:true)

		println "phone : ${accountInstance.phone}"

		render(view:"account", model: [accountInstance: accountInstance])
	}	

	
	def sendResetPasswordEmail(accountInstance, resetUrl){
		try { 
		
			def fromAddress = applicationService.getSupportEmailAddress()
			//def toAddress = accountInstance.username
			//TODO:change
			def toAddress = "croteau.mike@gmail.com"
			def subject = "${applicationService.getCompanyName()}: Reset password"

			
			File templateFile = grailsAttributes.getApplicationContext().getResource(  "/templates/email/password_reset.html").getFile();

			def binding = [ "companyName" : applicationService.getCompanyName(),
				 			"supportEmail" : applicationService.getSupportEmailAddress(),
							"resetUrl": resetUrl ]
			def engine = new SimpleTemplateEngine()
			def template = engine.createTemplate(templateFile).make(binding)
			def bodyString = template.toString()
			
			
			emailService.send(toAddress, fromAddress, subject, bodyString)
			
		}catch(Exception e){
			e.printStackTrace()
		}
	}
		

}