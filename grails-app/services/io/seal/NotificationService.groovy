package io.seal

import grails.util.Holders
import groovy.text.SimpleTemplateEngine
import static grails.async.Promises.*


class NotificationService {
	
	def emailService
	def grailsApplication
	
	NotificationService(){
		if(!grailsApplication){
			grailsApplication = Holders.grailsApplication
		}
		if(!emailService){
		    emailService = grailsApplication.classLoader.loadClass("io.seal.EmailService").newInstance()
		}
		println "NotificationService initialized...."
	}
	

	def sendNotifications(salesActions){
		salesActions.each{ salesAction ->

			
			def to = getEmails(salesAction)
			def from = "app@mail.datatundra.com"
			def subject = "Sales Action : " + salesAction.salesAction.name
			def body = getEmailBody(salesAction)
			
			emailService.send(to, from, subject, body)
		}
	}
	
	
	def getEmails(salesAction){
		def emails = ""
		if(!salesAction.account){
			def accounts = Account.list()
			accounts.each{ account ->
				emails += account.username
				emails += ","
			}
		}else{
			emails = salesAction.account.username
		}
		return emails
	}
	
	
	def getEmailBody(salesAction){
		
		File templateFile = grailsApplication.mainContext.getResource(File.separator + "templates" + File.separator + "email" + File.separator + "notification.html").file
		
		//File templateFile = grailsAttributes.getApplicationContext().getResource( File.separator + "templates" + File.separator + "email" + File.separator + "notification.html").getFile();
		def prospectUrl = getProspectUrl(salesAction.prospect)
		def binding = [
			"salesAction" : salesAction.salesAction.name,
			"actionDate" : salesAction.actionDate,
			"prospectUrl" : prospectUrl
		]
		def engine = new SimpleTemplateEngine()
		def template = engine.createTemplate(templateFile).make(binding)
		return template.toString()
	}
	
	
	private def getProspectUrl(prospect){
		//TODO:
		return "http://localhost:9463/bdo/prospect/edit/" + prospect.id
	}
	
}