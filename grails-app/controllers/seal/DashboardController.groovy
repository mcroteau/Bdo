package seal

import grails.plugin.springsecurity.annotation.Secured

import io.seal.common.ApplicationConstants
import io.seal.ProspectSalesAction
import io.seal.Prospect

import java.text.DecimalFormat

import io.seal.SalesAction
import io.seal.ProspectSalesAction
import io.seal.ProspectSale

import io.seal.Territory
import io.seal.Status

class DashboardController {
	
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

		def account = commonUtilities.getAuthenticatedAccount()
		def salesCount = getSalesCount(account, startDate, endDate)
		def sales = getProspectSales(account, startDate, endDate)

		def salesTotal = calculateSalesTotal(sales)

		def prospectSalesActionsCount = getProspectSalesActionsCount(account, startDate, endDate)

		addAdditionalDashboardValues(data, salesCount, prospectSalesActionsCount, salesTotal)

		def salesActions = SalesAction.list()
		salesActions.each{ sa ->
			def countCompleted = ProspectSalesAction.countBySalesActionAndAccountAndCompleted(sa, account, true)
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

		println data

		def formattedStartDate = "--"
		def formattedEndDate = "--"
		if(startDate && endDate){
			formattedStartDate = startDate.format('MM/dd/yyyy')
			formattedEndDate = endDate.format('MM/dd/yyyy')
		}

		[ data: data, startDate: formattedStartDate, endDate: formattedEndDate]

	}


	def getProspectSalesActionsCount(account, startDate, endDate){
		def prospectSalesActionsCount
		if(startDate && endDate){
			prospectSalesActionsCount = ProspectSalesAction.countByAccountAndDateCompletedBetween(account, startDate, endDate)
		}else{
			prospectSalesActionsCount = ProspectSalesAction.countByAccount(account)
		}
		return prospectSalesActionsCount
	}



	def getProspectSales(account, startDate, endDate){
		def sales
		if(startDate && endDate){
			sales = ProspectSale.findAllBySalesPersonAndSalesDateBetween(account, startDate, endDate)
		}else{
			sales = ProspectSale.findAllBySalesPerson(account)
		}
		return sales
	}


	def getSalesCount(account, startDate, endDate){
		def salesCount
		if(startDate && endDate){
			salesCount = ProspectSale.countBySalesPersonAndSalesDateBetween(account, startDate, endDate)
		}else{
			salesCount = ProspectSale.countBySalesPerson(account)
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

		DecimalFormat df1 = new DecimalFormat("###,###.##");
		df1.setMinimumFractionDigits(2)
		def salesTotalFormatted = df1.format(salesTotal)
		data.salesTotal = salesTotalFormatted

		DecimalFormat df2 = new DecimalFormat("###,###.##");
		df2.setMinimumFractionDigits(2)
		def averageSale = "0"

		if(salesTotal && salesCount){
			println "salesTotal : ${salesTotal} ${salesCount}"
			def unformattedAverage = Math.round(salesTotal/salesCount * 100)/100
			averageSale = df2.format(unformattedAverage)
			println averageSale
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