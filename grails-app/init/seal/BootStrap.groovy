package seal

import groovy.time.TimeCategory
import grails.util.Environment

import io.seal.common.ApplicationConstants			
			
import io.seal.CountryStateHelper
import io.seal.Role
import io.seal.Account
import io.seal.Country		
import io.seal.State	
import io.seal.SalesAction
import io.seal.Territory
import io.seal.Status
import io.seal.ProspectSize

import io.seal.Prospect
import io.seal.SalesAction
import io.seal.ProspectSalesAction

import io.seal.common.SalesActions
import io.seal.common.Statuses

import io.seal.SalesEffort
import io.seal.ProspectSale


class BootStrap {

	def salesmanRole
	def administratorRole
	
	def springSecurityService
	def commonUtilities

    
	def init = { servletContext ->

		println "***********************************************"
		println "*******           BDO Bootstrap         *******"
		println "***********************************************"
		createCountriesAndStates()
		createRoles()
		createAdministrator()
		createTerritories()
		createStatuses()
		createSizes()
		createSalesActions()

		if(Environment.current == Environment.DEVELOPMENT) {
			createMockProspects()
			//createMockSalesmen()
			//createMockSalesEfforts(true)
			//createMockSalesEfforts(false)
		}
		
		n()
    }
	
	
	def createMockSalesmen(){
		
		(1..10).each { it ->
			def password = springSecurityService.encodePassword("salesman")
			def mockSalesman = new Account(username : "croteau.mike+salesman${it}@gmail.com", password : password, name : "Mock Salesman ${it}")
			mockSalesman.hasAdminRole = false
			mockSalesman.save(flush:true)
			mockSalesman.createAccountPermission()
			mockSalesman.createAccountRoles(false)
		}

		println "Mock Sales People : " + Account.findAllByHasAdminRole(false)
	}
	
	
	def createAdministrator(){
		if(Account.count() == 0){
			def password = springSecurityService.encodePassword("admin")
			def adminAccount = new Account(username : "croteau.mike+admin@gmail.com", password : password, name : 'Administrator')
			adminAccount.hasAdminRole = true
			adminAccount.save(flush:true)

			adminAccount.createAccountRoles(true)
			adminAccount.createAccountPermission()
		}		

		println "Accounts : " + Account.count()
	}


	def createRoles(){
		if(Role.count() == 0){
			administratorRole = new Role(authority : ApplicationConstants.ROLE_ADMIN).save(flush:true)
			salesmanRole = new Role(authority : ApplicationConstants.ROLE_SALESMAN).save(flush:true)
		}else{
			administratorRole = Role.findByAuthority(ApplicationConstants.ROLE_ADMIN)
			salesmanRole = Role.findByAuthority(ApplicationConstants.ROLE_SALESMAN)
		}
		
		println 'Roles : ' + Role.count()
	
	}
	
	
	def createCountriesAndStates(){
		if(Country.count() == 0){
			CountryStateHelper countryStateHelper = new CountryStateHelper()
			countryStateHelper.countryStates.each(){ countryData ->
				createCountryAndStates(countryData)
			}
		}
		println "Countries : ${Country.count()}"
		println "States : ${State.count()}"
	}
	
	
	def createCountryAndStates(countryData){
		def country = new Country()
		country.name = countryData.name
		country.save(flush:true)
		
		countryData.states.each(){ stateData ->
			def state = new State()
			state.country = country
			state.name = stateData
			state.save(flush:true)
		}
	}
	
	
	def createTerritories(){
		if(Territory.count() == 0){
			def territories = ["Northern", "Southern", "Eastern", "Western", ApplicationConstants.TERRITORY_IMPORTED]
			territories.each(){ t ->
				def territory = new Territory()
				territory.name = t
				territory.save(flush:true)
			}
		}
		println "Territories : ${Territory.count()}"
	}
	
	
	def createStatuses(){
		if(Status.count() == 0){
			Statuses.values().each{ it ->
				println "status : " + it.name
				def status = new Status()
				status.name = it.name
				status.save(flush:true)
			}
		}
		println "Statuses : ${Status.count()}"
	}
	
	
	def createSizes(){
		if(ProspectSize.count() == 0){
			def sizes = ["0 - 10", "10 - 49", "50 - 250", "250 - 1,000", "1,000 >"]
			sizes.each(){ si ->
				def size = new ProspectSize()
				size.size = si
				size.save(flush:true)
			}
		}
		println "Sizes : ${ProspectSize.count()}"
	}

	
	
	def createSalesActions(){
		if(SalesAction.count() == 0){
			SalesActions.values().each{ action ->
				println "sales action : " + action.name
				def salesAction = new SalesAction()
				salesAction.name = action.name
				salesAction.save(flush:true)
			}
		}
		println "Sales Actions : ${SalesAction.count()}"
	}
	
	
	
	def createMockProspects(){
		def salesAction = SalesAction.findByName("Follow Up")
		(0..34).each(){ it ->
			def index = it
			def date = new Date()
			
			def prospect = new Prospect()
			def randomString = commonUtilities.randomString(7)
			
			prospect.company = randomString
			prospect.phone = "(907) 123-" + commonUtilities.generateRandomNumber(1000, 9800)
			prospect.save(flush:true)
			
			def prospectSalesAction = new ProspectSalesAction()
			prospectSalesAction.prospect = prospect
			prospectSalesAction.salesAction = salesAction
			
			if(it % 3 == 0){
				use( TimeCategory ) {
				    date = date - index.hours
				}
			}else{
				use( TimeCategory ) {
				    date = date + index.hours
				}
			}
			
			println date
			prospectSalesAction.actionDate = date
			prospectSalesAction.save(flush:true)
			
		    prospectSalesAction.errors.allErrors.each {
		        println it
		    }
			
			prospect.addToSalesActions(prospectSalesAction)
			prospect.save(flush:true)
			println "creating data ${it}... ${salesAction} : ${prospectSalesAction}"
		}
		
		println "Prospects : ${Prospect.count()}"
	
	}


	def createMockSalesEfforts(complete){

		def statuses = Status.list()
		def accounts = Account.list()
		def salesActions = SalesAction.list()
		def prospects = Prospect.list()


		def startingActions = [
			SalesAction.findByName(SalesActions.MAILER.name),
			SalesAction.findByName(SalesActions.COLD_CALL.name),
			SalesAction.findByName(SalesActions.EMAIL.name)
		]


		(0..12).each{ n ->
			def min = commonUtilities.randomNumber(0, prospects.size() - 1)
			def max = commonUtilities.randomNumber(min, prospects.size() - 1)
			println min + " " + max + " " + prospects.size()

			def startingSalesAction = startingActions[commonUtilities.randomNumber(1, startingActions.size()) - 1]
			(min..max).each{ o ->
				def prospect = prospects[o]

				def salesCount = commonUtilities.generateRandomNumber(1, 10)
				def saleComplete = false
				if(salesCount % 2 == 0 || salesCount % 3 == 0)saleComplete = true

				def salesEffort = setupSalesEffort(prospect, statuses, accounts, salesActions, complete, saleComplete)

				def days = commonUtilities.randomNumber(3, 7)
				(0..days).each{ d ->


					def brn = commonUtilities.randomNumber(1, 7)
					if(d % brn == 0){
						return
					}

					def br = commonUtilities.randomNumber(1, 7)
					if(d % br == 0){
						return
					}

					def actionDate = new Date() - d //* n
					def salesAction = salesActions[commonUtilities.randomNumber(1, salesActions.size()) - 1]
					if(d == days || (d + br + 1) == days)salesAction = startingSalesAction

					println days + ":" + d + " " + actionDate.toString() + " " + prospect.company + " " + o + " " + salesAction.name

					def prospectSalesAction = setupSalesAction(actionDate, salesAction, prospect, accounts, salesEffort)

				}
			}

		}

	}



	def setupSalesEffort(prospect, statuses, accounts, salesActions, complete, saleComplete){
		def startingStatus = statuses[commonUtilities.randomNumber(1, statuses.size()) - 1]
		def completeStatus = statuses[commonUtilities.randomNumber(1, statuses.size()) - 1]
		def salesman = accounts[commonUtilities.randomNumber(1, accounts.size()) - 1]

		def salesEffort = new SalesEffort()
		salesEffort.prospect = prospect
		salesEffort.startingStatus = startingStatus

		salesEffort.salesman = salesman

		def endDate = new Date() - commonUtilities.generateRandomNumber(1, 31)

		if(complete){
			salesEffort.recording = false
			salesEffort.isCurrent = false
			salesEffort.dateComplete = endDate
			
			if(saleComplete){
				def prospectStatus = Status.findByName("Sale")
				salesEffort.completeStatus = prospectStatus
				prospect.status = prospectStatus

				def prospectSale = new ProspectSale()
				prospectSale.prospect = prospect
				prospectSale.salesPerson = salesman
				prospectSale.total = new BigDecimal(commonUtilities.generateRandomNumber(53, 1000))
				prospectSale.salesDate = endDate
				prospectSale.save(flush:true)
				println prospectSale
				println prospect.errors

			}else{
				salesEffort.completeStatus = completeStatus
				prospect.status = completeStatus
			}


			prospect.save(flush:true)
		}else{
			salesEffort.recording = true
			salesEffort.isCurrent = true
			prospect.currentSalesEffort = salesEffort
		}
		salesEffort.save(flush:true)


		return salesEffort

	}


	def setupSalesAction(actionDate, salesAction, prospect, accounts, salesEffort){
		def salesPerson = accounts[commonUtilities.randomNumber(1, accounts.size()) - 1]
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
	
	def n(){
		//TODO: add
	}
	
    def destroy = {
    }
}
