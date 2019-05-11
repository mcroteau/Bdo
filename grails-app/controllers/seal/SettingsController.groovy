package seal

import java.io.FileOutputStream;
import java.io.FileInputStream

import io.seal.common.ApplicationConstants
import grails.plugin.springsecurity.annotation.Secured


class SettingsController {
	
	private final String SETTINGS_FILE = "settings.properties"
	
	private final String PELICAN_PRIVATE_KEY = "hilo.key"
	private final String PELICAN_URL = "hilo.url"
	
	//TODO:add currency selection
	private final String COMPANY_CURRENCY = "company.currency"
	private final String COMPANY_COUNTRY_CODE = "company.country.code"
	
	private final String COMPANY_NAME = "company.name"
	private final String COMPANY_PHONE = "company.phone"
	private final String COMPANY_EMAIL = "company.email"
	
	private final String MAIL_ADMIN_EMAIL_ADDRESS = "mail.smtp.adminEmail"
	private final String MAIL_SUPPORT_EMAIL_ADDRESS = "mail.smtp.supportEmail"
	private final String MAIL_USERNAME = "mail.smtp.username"
	private final String MAIL_PASSWORD = "mail.smtp.password"
	private final String MAIL_HOST = "mail.smtp.host"
	private final String MAIL_PORT = "mail.smtp.port"
	private final String MAIL_STARTTLS = "mail.smtp.starttls.enabled"
	private final String MAIL_AUTH = "mail.smtp.auth"
	
	def applicationService
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def index(){
		Properties prop = new Properties();
		try{
		
			File propertiesFile = grailsApplication.mainContext.getResource("settings/${SETTINGS_FILE}").file
			FileInputStream inputStream = new FileInputStream(propertiesFile)
			prop.load(inputStream);
			
			def settings = [:]
			settings["companyName"] = prop.getProperty(COMPANY_NAME);
			settings["companyPhone"] = prop.getProperty(COMPANY_PHONE);
			settings["companyEmail"] = prop.getProperty(COMPANY_EMAIL);

			[ settings : settings ]
			
		} catch (IOException e){
		    log.debug"Exception occured while reading properties file :"+e
		} //TODO:add excpetion handler for IOException
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def save(){
		String companyName = params.companyName
		String companyPhone = params.companyPhone
		String companyEmail = params.companyEmail
		
		Properties prop = new Properties();
		
		File propertiesFile = grailsApplication.mainContext.getResource("settings/${SETTINGS_FILE}").file
		FileInputStream inputStream = new FileInputStream(propertiesFile)
		prop.load(inputStream);
		
		try{
		    
			prop.setProperty(COMPANY_NAME, companyName);
			prop.setProperty(COMPANY_PHONE, companyPhone);
			prop.setProperty(COMPANY_EMAIL, companyEmail);
			
			def absolutePath = grailsApplication.mainContext.servletContext.getRealPath('settings')
			
			absolutePath = absolutePath.endsWith("/") ? absolutePath : absolutePath + "/"
			println "abs ${SETTINGS_FILE}"
			def filePath = absolutePath + SETTINGS_FILE
			
		    prop.store(new FileOutputStream(filePath), null);
			applicationService.setProperties()
			
			flash.message = "Successfully saved settings..."
			redirect(action : 'settings')
			
		} catch (IOException e){
		    log.debug"exception occured while saving properties file :"+e
			flash.message = "Something went wrong... "
			redirect(action : 'settings')
			return
		}
			
	}
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def email_settings(){			
		Properties prop = new Properties();
		try{
		
			File propertiesFile = grailsApplication.mainContext.getResource("settings/${SETTINGS_FILE}").file
			FileInputStream inputStream = new FileInputStream(propertiesFile)
			
			prop.load(inputStream);
			
			def email_settings = [:]
			email_settings["adminEmail"] = prop.getProperty(MAIL_ADMIN_EMAIL_ADDRESS)
			email_settings["supportEmail"] = prop.getProperty(MAIL_SUPPORT_EMAIL_ADDRESS)
			email_settings["username"] = prop.getProperty(MAIL_USERNAME)
			email_settings["password"] = prop.getProperty(MAIL_PASSWORD)
			email_settings["host"] = prop.getProperty(MAIL_HOST)
			email_settings["port"] = prop.getProperty(MAIL_PORT)
			
			def startTls = prop.getProperty(MAIL_STARTTLS)
			def auth = prop.getProperty(MAIL_AUTH)
			
			if(startTls == "true")email_settings["startTls"] = prop.getProperty(MAIL_STARTTLS)
			if(auth == "true")email_settings["auth"] = prop.getProperty(MAIL_AUTH)
			
			if(email_settings["startTls"])email_settings["startTls"] = "checked"
			if(email_settings["auth"])email_settings["auth"] = "checked"
			
			[ email_settings : email_settings ]
			
		} catch (IOException e){
		    log.debug"Exception occured while reading properties file :"+e
		}
	}
	
	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def save_email_settings(){
    	
		String adminEmail = params.adminEmail
		String supportEmail = params.supportEmail
		String username = params.username
		String password = params.password
		String host = params.host
		String port = params.port
		String startTls = params.startTls
		String auth = params.auth
		
		if(startTls == "on")startTls = true
		if(auth == "on")auth = true
		
		if(!startTls)startTls = false
		if(!auth)auth = false
		
		
		Properties prop = new Properties();
		
		File propertiesFile = grailsApplication.mainContext.getResource("settings/${SETTINGS_FILE}").file
		FileInputStream inputStream = new FileInputStream(propertiesFile)
		
		prop.load(inputStream);
		
		try{
			
			prop.setProperty(MAIL_ADMIN_EMAIL_ADDRESS, adminEmail)
			prop.setProperty(MAIL_SUPPORT_EMAIL_ADDRESS, supportEmail)
			prop.setProperty(MAIL_USERNAME, username);
			prop.setProperty(MAIL_PASSWORD, password);
			prop.setProperty(MAIL_HOST, host);
			prop.setProperty(MAIL_PORT, port);
			prop.setProperty(MAIL_STARTTLS, startTls)
			prop.setProperty(MAIL_AUTH, auth)
			
			def absolutePath = grailsApplication.mainContext.servletContext.getRealPath('settings')
			absolutePath = absolutePath.endsWith("/") ? absolutePath : absolutePath + "/"
			def filePath = absolutePath + SETTINGS_FILE
			
		    prop.store(new FileOutputStream(filePath), null);
			
			applicationService.setProperties()
			
			flash.message = "Successfully saved email settings..."
			redirect(action : 'email_settings')
			
		} catch (IOException e){
		    log.debug"exception occured while saving properties file :"+e
			flash.message = "Something went wrong... "
			redirect(action : 'email_settings')
			return
		}			
	}
	
	
	
 	@Secured([ApplicationConstants.ROLE_ADMIN])
	def hilo_settings(){
		Properties prop = new Properties();
		try{
	
			File propertiesFile = grailsApplication.mainContext.getResource("settings/${SETTINGS_FILE}").file
			FileInputStream inputStream = new FileInputStream(propertiesFile)
			prop.load(inputStream);
			
			def hiloUrl = prop.getProperty(PELICAN_URL);
			def hiloPrivateKey = prop.getProperty(PELICAN_PRIVATE_KEY);
			
			[ hiloPrivateKey : hiloPrivateKey, hiloUrl: hiloUrl ]
			
		}catch(Exception e){
			e.printStackTrace()
		}
	}
 	
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def save_hilo_settings(){
		
		def key = params.hiloPrivateKey
		def hiloUrl = params.hiloUrl
		
		Properties prop = new Properties();
		File propertiesFile = grailsApplication.mainContext.getResource("settings/${SETTINGS_FILE}").file
		FileInputStream inputStream = new FileInputStream(propertiesFile)
		
		prop.load(inputStream);
		prop.setProperty(PELICAN_PRIVATE_KEY, key);
		prop.setProperty(PELICAN_URL, hiloUrl);
		
		def absolutePath = grailsApplication.mainContext.servletContext.getRealPath('settings')
		absolutePath = absolutePath.endsWith("/") ? absolutePath : absolutePath + "/"
		def filePath = absolutePath + SETTINGS_FILE
		
	    prop.store(new FileOutputStream(filePath), null);
		applicationService.setProperties()
		
		flash.message = "Successfully set Hilo data access settings. Seal will begin checking for data now..."
		redirect(action: "hilo_settings")
	}
	
	
	
}