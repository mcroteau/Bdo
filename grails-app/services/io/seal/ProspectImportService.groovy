package io.seal


import java.io.FileOutputStream;
import java.io.FileInputStream

import java.io.InputStream
import java.io.ByteArrayInputStream
import java.text.SimpleDateFormat
import groovy.json.JsonSlurper

import groovy.time.TimeDuration
import groovy.time.TimeCategory
import io.seal.ProspectSalesAction
import io.seal.Prospect
import io.seal.Country
import io.seal.State
import io.seal.ImportJob

import io.seal.common.ApplicationConstants
import io.seal.common.Statuses


class ProspectImportService {
	
	static scope = "singleton"
	
	private final String SETTINGS_FILE = "settings.properties"
	
	private final String PELICAN_PRIVATE_KEY = "hilo.key"
	private final String PELICAN_URL = "hilo.url"
	
	def processing = false
	
	def sessionFactory
	def grailsApplication
	def emailService//TODO: add emails for success & failure
	def commonUtilities
	
	//http://krixisolutions.com/bulk-insert-grails-gorm/
	def fetch(){

		if(processing)return false
		processing = true
		
		
		println "***********************************************************************************"
		println "Seal (BDO) import process : go get customer/prospect accounts...                            "
		println "***********************************************************************************"
		
		Properties prop = new Properties();
		try{
	
			File propertiesFile = grailsApplication.mainContext.getResource("settings/${SETTINGS_FILE}").file
			FileInputStream inputStream = new FileInputStream(propertiesFile)
			prop.load(inputStream);
			
			def hiloUrl = prop.getProperty(PELICAN_URL);
			def hiloKey = prop.getProperty(PELICAN_PRIVATE_KEY);
			
			
			if(hiloUrl && hiloKey){
				
				
				
				def url = hiloUrl + "/data/accounts?k=" + hiloKey
				def connection = new URL(url).openConnection();
				def connectionResponse = connection.getResponseCode();
				
				
				
				if(connectionResponse.equals(200)) {
				
					def dataResponse = connection.getInputStream().getText()
					def jsonSlurper = new JsonSlurper()
					def data = jsonSlurper.parseText(dataResponse)
					
					println "count: " + data.count
					
					
					def importUuid = commonUtilities.generateRandomString(7)
					def importJob = new ImportJob()
					importJob.uuid = importUuid
					importJob.save(flush:true)
					
					
					def session = sessionFactory.getCurrentSession();
					def tx = session.beginTransaction();
					

					data.accounts.eachWithIndex(){ account, index ->

						//println "uuid : ${account.uuid}"
						def existingProspectUuid = Prospect.findByUuid(account.uuid)
						def existingProspectEmail = Prospect.findByEmail(account.email)
						
						if(!existingProspectUuid && 
								!existingProspectEmail){
							
							if(index % 3 == 0){
								return false
							}
								
							saveCreateProspect(account, importUuid)
						
							System.out.print(".")
							
						}else{
							if(existingProspectUuid){
								updateProspectOrderDetails(existingProspectUuid, account)
							}
							if(existingProspectEmail){
								updateProspectOrderDetails(existingProspectEmail, account)
							}
							
						}
						
				        if(index % 100 == 0) {
				        	//clear session and save records after every 100 records
				            session.flush();
				            session.clear();
				        }
						
					}
					
					System.out.println("")
					println()

					
 				    session.flush();
				    session.clear();
				    tx.commit();
					
					def prospectsImported = Prospect.countByImportUuid(importUuid)
		
					println "***********************************************************************************"
					println "Hilo (BDO) import process issue complete : prospects imported : ${prospectsImported}        "
					println "***********************************************************************************"
					
					processing = false
				
				}else{
					println "***********************************************************************************"
					println "Hilo (BDO) import process issue : "
					println "***********************************************************************************"
					processing = false
				}
				
				
			}
			

			
		}catch(Exception e){
			//e.printStackTrace()
			println "***********************************************************************************"
			println "Hilo (BDO) import process issue : " + e
			println "***********************************************************************************"
			processing = false
		}
	}
	
	
	def saveCreateProspect(account, importUuid){
		def prospect = new Prospect()
		prospect.uuid = account.uuid
		prospect.email = account.email
		prospect.company = account.name
		prospect.address1 = account.address1
		prospect.address2 = account.address2
		prospect.city = account.city
		prospect.country = account.country ? Country.findByName(account.country) : null
		prospect.state = account.state ? State.findByName(account.state) : null
		prospect.zip = account.zip
		prospect.contactName = account.name
		prospect.phone = account.phone
		//prospect.ipAddress = account.ipAddress

		prospect.territory = Territory.findByName(ApplicationConstants.TERRITORY_IMPORTED)
		prospect.status = Status.findByName(Statuses.IMPORTED.t)
		prospect.importUuid = importUuid
		
		//session.save(prospect)
		prospect.save(flush:true)

		//TODO: do something with sales count add to sales
		//prospect.salesCount = account.salesCount
		//prospect.totalSalesValue = account.totalSalesValue
		saveAccountAverageOrders(prospect, account)
	}
	
	
	def updateProspectOrderDetails(existingProspect, account){
		saveAccountAverageOrders(existingProspect, account)
	}


	def saveAccountAverageOrders(prospect, account){
		if(account?.salesCount > 0){
			def averageOrder = account?.totalSalesValue / account?.salesCount
			(0..account?.salesCount).each{
				def prospectSale = new ProspectSale()
				prospectSale.saleDate = new Date()
				prospectSale.prospect = prospect
				prospectSale.total = averageOrder
				prospectSale.save(flush:true)
	
				prospect.addToProspectSales(prospectSale)
				prospect.save(flush:true)
			}
		}
	}
	
}