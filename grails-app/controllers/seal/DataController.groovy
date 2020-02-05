package seal

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.*

import io.seal.Country
import io.seal.State

import io.seal.common.ApplicationConstants
import io.seal.common.SalesActions

import io.seal.Prospect
import io.seal.SalesAction
import io.seal.ProspectSalesAction
import io.seal.SalesEffort
import io.seal.Account
import io.seal.Status

import io.seal.common.SalesActions

import grails.util.Holders
import static grails.async.Promises.*

import static org.springframework.http.HttpStatus.OK
import groovy.time.TimeDuration
import groovy.time.TimeCategory

class DataController {

	String encoding
    String csvMimeType
    
	def commonUtilities

	@Secured([ApplicationConstants.PERMIT_ALL])
	def actions(){
		def oneMinute
		def notificationTime = new Date()

		notificationTime[Calendar.SECOND] = 0
		notificationTime[Calendar.MILLISECOND] = 0

		use( TimeCategory ) {
		    oneMinute = notificationTime - 5.minutes
		}

		def salesman = Account.findByUsername("croteau.mike+admin@gmail.com")
		println salesman

		println notificationTime.format("HH:mm")
		println notificationTime

		def salesActions = ProspectSalesAction.findAllByRemindedAndReminderDateBetweenAndAccountAndStatus(false, oneMinute, notificationTime, salesman, ApplicationConstants.SALES_ACTION_ACTIVE)

		println "sales actions : " + salesActions


		def data = []
		salesActions.each { salesAction ->
			def prospect = salesAction.prospect 

			def action = [:]
			action.action = [:]
			action.action.time = salesAction.actionDate.format("HH:mm")
			action.prospect = prospect.company

			println "here..."
			data.add(action)

			salesAction.reminded = true
			salesAction.save(flush:true)

		}


		render data as JSON
	}



	@Secured([ApplicationConstants.ROLE_ADMIN])	
	def c(){}




	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])	
	def d(){
		render data()
	}

	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])	
	def salesman_sequences(){

		def account = commonUtilities.getAuthenticatedAccount()
		def salesEfforts = SalesEffort.findAllByRecordingAndSalesman(false, account)
		def effortMap = [:]

		salesEfforts.each { effort ->
			
			def salesActions = effort.salesActions
			def sequence = ""
			salesActions.eachWithIndex { sa, index ->
				println sa
				sequence = sequence + sa.salesAction.name.toLowerCase().replaceAll("\\s","")
					println "here.... ${salesActions.size()} ${sequence}"
				if(index + 1 < salesActions.size()) {
					println "here.... ${salesActions.size()}"
					sequence = sequence + "-"
				}else{
					sequence = sequence + "-" + effort.completeStatus.name.toLowerCase().replaceAll("\\s","")
				}
			}

			if(!effortMap[sequence]){
				effortMap[sequence] = 1
			}else{
				effortMap[sequence]++
			}
		}

		def csv = ""
		effortMap.each{
			println "${it.properties}"
			csv += it.key + "," + it.value + "\n"
		}

		println csv

  		render csv
	}


	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def overview_sequences(){
		println "here..."
		def salesEfforts = SalesEffort.findAllByRecording(false)
		def effortMap = [:]

		salesEfforts.each { effort ->

			def salesActions = effort.salesActions
			def sequence = ""
			salesActions.eachWithIndex { sa, index ->
				println sa
				sequence = sequence + sa.salesAction.name.toLowerCase().replaceAll("\\s","")
				if(index + 1 < salesActions.size()) {
					//println "here.... ${salesActions.size()}"
					sequence = sequence + "-"
				}else{
					sequence = sequence + "-" + effort.completeStatus.name.toLowerCase().replaceAll("\\s","")
				}
			}

			if(!effortMap[sequence]){
				effortMap[sequence] = 1
			}else{
				effortMap[sequence]++
			}
		}

		def csv = ""
		println "effortMap ${effortMap}"

		effortMap.each{
			println "${it.key}, ${it.value}"
			csv += it.key + "," + it.value + "\n"
		}

		println "csv + ${csv}"

		render csv
	}


	@Secured([ApplicationConstants.ROLE_ADMIN])	
	def o(){


		if(!grailsApplication){
			grailsApplication = Holders.grailsApplication
		}
		if(!commonUtilties){
		    commonUtilties = grailsApplication.classLoader.loadClass("io.seal.common.CommonUtilities").newInstance()
		}


		def salesEfforts = SalesEffort.list()

		salesEfforts.each{
			def prospect = it.prospect
			prospect.currentSalesEffort = null
			prospect.save(flush:true)
			it.delete(flush:true)
		}

		def sas = ProspectSalesAction.list()
		sas.each { 
			it.delete(flush:true)
		}

		def statuses = Status.list()
		def accounts = Account.list()
		def salesActions = SalesAction.list()
		def prospects = Prospect.list()

		def startingActions = [
			SalesAction.findByName(SalesActions.MAILER.name),
			SalesAction.findByName(SalesActions.COLD_CALL.name),
			SalesAction.findByName(SalesActions.EMAIL.name)
		]


		//(0..2).each{ n ->
			def min = commonUtilties.randomNumber(0, prospects.size() - 1)
			def max = commonUtilties.randomNumber(min, prospects.size() - 1)
			println min + " " + max + " " + prospects.size()

			def startingSalesAction = startingActions[commonUtilties.randomNumber(1, startingActions.size()) - 1]
			(min..max).each{ o ->
				def prospect = prospects[o]
				def salesEffort = setupSalesEffort(prospect, statuses, accounts, salesActions)

				def days = commonUtilties.randomNumber(3, 7)
				(0..days).each{ d ->

					def brn = commonUtilties.randomNumber(1, 7)
					if(d % brn == 0){
						return
					}

					def br = commonUtilties.randomNumber(1, 7)
					if(d % br == 0){
						return
					}

					// def b = commonUtilties.randomNumber(1, 7)
					// if(d % b == 0){
					// 	return
					// }

					def actionDate = new Date() - d //* n
					def salesAction = salesActions[commonUtilties.randomNumber(1, salesActions.size()) - 1]
					if(d == days || (d + br + 1) == days)salesAction = startingSalesAction


					println days + ":" + d + " " + actionDate.toString() + " " + prospect.company + " " + o + " " + salesAction.name

					def prospectSalesAction = setupSalesAction(actionDate, salesAction, prospect, accounts, salesEffort)

				}

			//}

		}

		render ""
	}


	def setupSalesEffort(prospect, statuses, accounts, salesActions){
		def startingStatus = statuses[commonUtilties.randomNumber(1, statuses.size()) - 1]
		def completeStatus = statuses[commonUtilties.randomNumber(1, statuses.size()) - 1]
		def salesman = accounts[commonUtilties.randomNumber(1, accounts.size()) - 1]

		def salesEffort = new SalesEffort()
		salesEffort.prospect = prospect
		salesEffort.startingStatus = startingStatus

		salesEffort.salesman = salesman
		salesEffort.recording = false
		salesEffort.isCurrent = false
		salesEffort.dateComplete = new Date()
		salesEffort.completeStatus = completeStatus
		salesEffort.save(flush:true)

		prospect.status = completeStatus
		//prospect.currentSalesEffort = salesEffort
		prospect.save(flush:true)

		return salesEffort

	}


	def setupSalesAction(actionDate, salesAction, prospect, accounts, salesEffort){
		def salesPerson = accounts[commonUtilties.randomNumber(1, accounts.size()) - 1]
		def prospectSalesAction = new ProspectSalesAction()
		prospectSalesAction.salesAction = salesAction
		prospectSalesAction.prospect = prospect
		prospectSalesAction.account = salesPerson
		prospectSalesAction.status = ApplicationConstants.SALES_ACTION_COMPLETED
		prospectSalesAction.completed = true
		prospectSalesAction.actionDate = actionDate
		prospectSalesAction.dateCreated = actionDate
		prospectSalesAction.dateCompleted = actionDate
		prospectSalesAction.save(flush:true)
		salesEffort.addToSalesActions(prospectSalesAction)
		salesEffort.save(flush:true)
		return prospectSalesAction
	}




	@Secured([ApplicationConstants.PERMIT_ALL])	
	def states(){
		
		def country
		if(params.country && params.country != "undefined"){
			country = Country.get(params.country)
		}
		
		def states = [:]
		if(country){
			states = State.findAllByCountry(country)
		}
		
		render states as JSON
	}


	//https://stackoverflow.com/questions/25692515/groovy-built-in-rest-http-client
	@Secured([ApplicationConstants.PERMIT_ALL])	
	def greenfield(){
		def uri = params.uri
		println "uri : " + uri
		
		def checkConnection = new URL(uri).openConnection();
		def checkConnectionResponse = checkConnection.getResponseCode();
		
		println(checkConnectionResponse);
		
		def connection = [:]
		
		if(checkConnectionResponse.equals(200)) {
			connection.success = true
		}else{
			connection.errored = true
		}
		render connection as JSON
	}




	@Secured([ApplicationConstants.ROLE_ADMIN])	
	def notification_check(){
		def now = new Date()
		def account = commonUtilties.getAuthenticatedAccount()

		def fifteen
		def five
		def thirty
		use( TimeCategory ) {
			fifteen = new Date() - 15.minutes
			five = new Date() - 5.minutes
			thirty = new Date() - 30.seconds
		}
		def dueFifteen = getSalesActions(account, fifteen, now, "15 Minutes")
		def dueFive = getSalesActions(account, five, now, "5 Minutes")
		def dueThirty = getSalesActions(account, thirty, now, "30 Seconds")

		def data = []
		data.add(dueFifteen)
		data.add(dueFive)
		data.add(dueThirty)

		render data as JSON
	}


	def getSalesActions(account, start, end, duration){
		def salesActions = ProspectSalesAction.findAllByAccountAndReminderAndActionDateBetween(account, true, start, end)	
		
		def salesActionsArr = []
		salesActions.each { sa ->
			def salesAction = [:]
			salesAction["id"] = sa.prospect.id
			salesAction["duration"] = duration
			salesAction["prospect"] = sa.prospect?.company ? sa.prospect?.company : sa.prospect?.contactName
			salesActionsArr.add(salesAction)
		}
		return salesActionsArr
	}



}