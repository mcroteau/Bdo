package io.seal

import grails.util.Holders
import groovy.text.SimpleTemplateEngine
import static grails.async.Promises.*

import java.io.InputStream
import java.io.ByteArrayInputStream
import java.text.SimpleDateFormat

import groovy.time.TimeDuration
import groovy.time.TimeCategory
import io.seal.ProspectSalesAction

import io.seal.common.ApplicationConstants
import java.util.Calendar

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
	

	def run(){

		def prospect = Prospect.get(1)
		def sa = SalesAction.get(1)

		def prospectSalesAction = new ProspectSalesAction()

		def salesman = Account.findByUsername("croteau.mike+admin@gmail.com")

		prospectSalesAction.account = salesman
		prospectSalesAction.prospect = prospect
		prospectSalesAction.salesAction = sa

		def date = new Date()
		def reminderDate
		use( TimeCategory ) {
		    date = date + 5.minutes
		    reminderDate = date - 5.minutes
		}

		reminderDate[Calendar.SECOND] = 0
		reminderDate[Calendar.MILLISECOND] = 0
		println "${reminderDate.format('HH:mm')}:${date.format('HH:mm')}"


		prospectSalesAction.status = ApplicationConstants.SALES_ACTION_ACTIVE
		prospectSalesAction.actionDate = date
		prospectSalesAction.reminder = false
		prospectSalesAction.reminded = false
		prospectSalesAction.reminderTime = 5
		prospectSalesAction.reminderDate = reminderDate
		prospectSalesAction.save(flush:true)



		/** REMOVE ABOVE **/


		def now = new Date()
		
		def notificationTime
		use( TimeCategory ) {
			notificationTime = new Date()
			notificationTime[Calendar.SECOND] = 0
			notificationTime[Calendar.MILLISECOND] = 0
		}
		

		println "${notificationTime.format('HH:mm')}:${reminderDate.format('HH:mm')}"
		println "Sales Actions : ${ProspectSalesAction.count()}"

		def salesActions = ProspectSalesAction.findAllByRemindedAndReminderDateAndStatus(false, notificationTime, ApplicationConstants.SALES_ACTION_ACTIVE)
	
		//sendNotifications(salesActions)
		
		println "*** ${salesActions} ***"
		// salesActions.each{ salesAction ->
		// 	salesAction.reminded = true
		// 	salesAction.save(flush:true)
		// }

		def count = ProspectSalesAction.count()
		if(count > 23){
			def list = ProspectSalesAction.list()
			list.each{
				it.delete(flush:true)
			}
		}

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