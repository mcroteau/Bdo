package seal

import grails.plugin.springsecurity.annotation.Secured

import io.seal.common.ApplicationConstants
import io.seal.ProspectSalesAction
import io.seal.Prospect

import java.text.DecimalFormat

import io.seal.SalesAction
import io.seal.ProspectSalesAction
import io.seal.ProspectSale

import io.seal.Status
import io.seal.Account


class OverviewController {

	def commonUtilities


	@Secured([ApplicationConstants.ROLE_ADMIN, ApplicationConstants.ROLE_SALESMAN])
	def index(){
		def startDate
		def endDate

		if(params.startDate && params.endDate){
			try{
				startDate = Date.parse("MM/dd/yyyy", params.startDate)
				endDate = Date.parse("MM/dd/yyyy", params.endDate)
			}catch (Exception e){
				flash.message = "Incorrect date format, please specify dates as mm/dd/yyy"
				startDate = new Date() - 30
				endDate = new Date()
			}
			
			if(!startDate || !endDate){
				flash.message = "Date Range must have correct dates formatted as mm/dd/yyyy"
				startDate = new Date() - 30
				endDate = new Date()
			}
			
			if(!endDate.after(startDate)){
				flash.message = "Start Date must be before End Date"
				startDate = new Date() - 30
				endDate = new Date()
			}
		
		}else if(params.allData){
			//set dates to null
			startDate = null
			endDate = null
		}else{
			//last month
			startDate = new Date() - 30
			endDate = new Date() 
		}

		def data = [:]

		setupDataObject(data)

		def salesCount = getSalesCount(startDate, endDate)
		def sales = getProspectSales(startDate, endDate)
		def prospectSalesActionsCount = getProspectSalesActionsCount(startDate, endDate)
		def prospectSalesActions = getProspectSalesActions(startDate, endDate)
		def salesTotal = calculateSalesTotal(sales)

		def salesmen = getTopProducingSalesRepresentatives(data, sales, prospectSalesActions)
		addAdditionalDashboardValues(data, salesCount, prospectSalesActionsCount, salesTotal)

		def salesActions = SalesAction.list()

		salesActions.each{ sa ->
			def countCompleted = ProspectSalesAction.countBySalesActionAndCompleted(sa, true)
			println "adding ... ${sa.name} : ${countCompleted}"

			switch(sa.name){
				case "Mailer" :
					data.mailers.value = countCompleted
					data.mailers.percent = commonUtilities.percent(countCompleted, prospectSalesActionsCount)
					//data.mailers.sales = commonUtilities.percent(countCompleted, salesCount)
					data.mailers.name = "Mailers"
					data.mailers.color = "#599fbe"

					data.salesActions.add(data.mailers)
					break

				case "Email" :
					data.emails.value = countCompleted
					data.emails.percent = commonUtilities.percent(countCompleted, prospectSalesActionsCount)
					//data.emails.sales = commonUtilities.percent(countCompleted, salesCount)
					data.emails.name = "Emails"
					data.emails.color = "#599fbe"

					data.salesActions.add(data.emails)
					break

				case "Cold Call" :
					data.coldCalls.value = countCompleted
					data.coldCalls.percent = commonUtilities.percent(countCompleted, prospectSalesActionsCount)
					//data.coldCalls.sales = commonUtilities.percent(countCompleted, salesCount)
					data.coldCalls.name = "Cold Calls"
					data.coldCalls.color = "#e25330"

					data.salesActions.add(data.coldCalls)
					break

				case "Follow Up" :
					data.followUps.value = countCompleted
					data.followUps.percent = commonUtilities.percent(countCompleted, prospectSalesActionsCount)
					//data.followUps.sales = commonUtilities.percent(countCompleted, salesCount)
					data.followUps.name = "Follow Ups"
					data.followUps.color = "#2c6b85"

					data.salesActions.add(data.followUps)
					break

				case "Meeting" :
					data.meetings.value = countCompleted
					data.meetings.percent = commonUtilities.percent(countCompleted, prospectSalesActionsCount)
					//data.meetings.sales = commonUtilities.percent(countCompleted, salesCount)
					data.meetings.name = "Meetings"
					data.meetings.color = "#074865"

					data.salesActions.add(data.meetings)
					break

				case "Demo" :
					data.demos.value = countCompleted
					data.demos.percent = commonUtilities.percent(countCompleted, prospectSalesActionsCount)
					//data.demos.sales = commonUtilities.percent(countCompleted, salesCount)
					data.demos.name = "Demos"
					data.demos.color = "#074865"

					data.salesActions.add(data.demos)
					break
				default :
					break
			}
		}

		//println data

		def formattedStartDate = "--"
		def formattedEndDate = "--"
		if(startDate && endDate){
			formattedStartDate = startDate.format('MM/dd/yyyy')
			formattedEndDate = endDate.format('MM/dd/yyyy')
		}


        def statusList = Status.list()
        def statuses = []
        println statusList

        statusList.each{ it ->
            println it.name
            def statusObj = [:]
            def count = Prospect.countByStatus(it)
            statusObj.name = it.name
            statusObj.count = count
            statuses.add(statusObj)
        }

        println statuses

		[ data: data, salesmen: salesmen, statuses: statuses, startDate: formattedStartDate, endDate: formattedEndDate]

	}


	def getTopProducingSalesRepresentatives(data, sales, prospectSalesActions){
		def salesmen = []

		def accounts = Account.list()

		accounts.each{ account ->
			def salesman = [:]
			salesman.name = account.nameEmail
			salesman.actions = ProspectSalesAction.countByAccount(account)
			salesman.sales = ProspectSale.countBySalesPerson(account)
			salesmen.add(salesman)
		}

		salesmen.sort { b, a -> a?.actions <=> b?.actions }

		return salesmen

	}



	def getProspectSalesActionsCount(startDate, endDate){
		def prospectSalesActionsCount
		if(startDate && endDate){
			prospectSalesActionsCount = ProspectSalesAction.countByDateCompletedBetween(startDate, endDate)
		}else{
			prospectSalesActionsCount = ProspectSalesAction.count()
		}
		return prospectSalesActionsCount
	}




	def getProspectSalesActions(startDate, endDate){
		def prospectSalesActions
		if(startDate && endDate){
			prospectSalesActions = ProspectSalesAction.findAllByDateCompletedBetween(startDate, endDate)
		}else{
			prospectSalesActions = ProspectSalesAction.list()
		}
		return prospectSalesActions
	}


	def getProspectSales(startDate, endDate){
		def sales
		if(startDate && endDate){
			sales = ProspectSale.findAllBySalesDateBetween(startDate, endDate)
		}else{
			sales = ProspectSale.list()
		}
		return sales
	}


	def getSalesCount(startDate, endDate){
		def salesCount
		if(startDate && endDate){
			salesCount = ProspectSale.countBySalesDateBetween(startDate, endDate)
		}else{
			salesCount = ProspectSale.count()
		}
		return salesCount
	}


	def calculateSalesTotal(sales){
		def salesValue = 0
		sales.each{ sale ->
			salesValue += sale.total
		}
		return salesValue
	}


	def addAdditionalDashboardValues(data, salesCount, prospectSalesActionsCount, salesTotal){
		data.salesCount = salesCount 
		data.salesActionsCount = prospectSalesActionsCount
		data.salesTotal = salesTotal

		DecimalFormat df = new DecimalFormat("###,###.##"); 
		df.setMinimumFractionDigits(2)
		def averageSale = "0"

		if(salesTotal && salesCount){
			def unformattedAverage = Math.round(salesTotal/salesCount * 100)/100
			averageSale = df.format(unformattedAverage)
		}
		def conversionRate = commonUtilities.percent(salesCount, prospectSalesActionsCount)

		data.conversionRate = conversionRate
		data.averageSale = averageSale

		return data
	}


	def setupDataObject(data){
		data.salesActions = []
		data.mailers = [:]
		data.emails = [:]
		data.coldCalls = [:]
		data.followUps = [:]
		data.meetings = [:]
		data.demos = [:]

	}

}