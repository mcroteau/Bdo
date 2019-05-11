package io.seal.common

import grails.io.IOUtils

import java.io.FileOutputStream;
import java.io.FileInputStream

import grails.util.Holders

import io.seal.Account

class CommonUtilities {
	
	def grailsApplication
	def springSecurityService
	
	
	CommonUtilities(){
		if(!grailsApplication){
			grailsApplication = Holders.grailsApplication
		}
		if(!springSecurityService){
		    springSecurityService = grailsApplication.classLoader.loadClass("grails.plugin.springsecurity.SpringSecurityService").newInstance()
		}
	}
	

	def percent(total, amount){
		println amount + ": " + total
		if(total != 0 && amount != 0){
			return Math.round((total/amount) * 100)
		}
		return 0
	}

	
	def getAuthenticatedAccount(){
		def username = springSecurityService.principal.username
		def account = Account.findByUsername(username)
		return account
	}
	
	def randomNumber(min, max){
		def random = new Random()
		def n = random.nextInt(max)
		if( n + min > max){
			return max
		}else{
			return n + min
		}
	}

	def generateRandomNumber(min, max){
		def random = new Random()
		def n = random.nextInt(max)
		if( n + min > max){
			return max
		}else{
			return n + min
		}
	}

	public randomString(int n){
		def alphabet = (('a'..'z')+('A'..'Z')+('0'..'9')).join()
		new Random().with {
		  	(1..n).collect { alphabet[ nextInt( alphabet.length() ) ] }.join()
		}
	}

	public generateRandomString(int n){
		def alphabet = (('a'..'z')+('A'..'Z')+('0'..'9')).join()
		new Random().with {
		  	(1..n).collect { alphabet[ nextInt( alphabet.length() ) ] }.join()
		}
	}
	
	def generateFileName(file){
		def fullFileName = file.getOriginalFilename()
		println "fullFileName : ${fullFileName}"
		
		String[] nameSplit = fullFileName.toString().split("\\.")
		def fileName = generateRandomString(9)
			
		println "extension : ${nameSplit[nameSplit.length - 1]}"
		def extension = nameSplit[nameSplit.length - 1]
	
		def newFileName = "${fileName}.${extension}"
		
		println "generateFileName ${newFileName}"
		return newFileName
	}


	def nullToBlankCheck(value){
		if(value == null)return ""
		return value.toString()
	}


    def createProspectCsvLines(prospects){
    	def prospectsCsvLines = []

    	prospects.eachWithIndex { prospect, index ->
        	def prospectLine = ""
			prospectLine+= nullToBlankCheck(prospect?.company) + ","
			prospectLine+= nullToBlankCheck(prospect?.address1) + ","
			prospectLine+= nullToBlankCheck(prospect?.address2) + ","
			prospectLine+= nullToBlankCheck(prospect?.city) + ","
			prospectLine+= nullToBlankCheck(prospect?.state?.name) + ","
			prospectLine+= nullToBlankCheck(prospect?.country?.name) + ","
			prospectLine+= nullToBlankCheck(prospect?.zip) + ","
        	prospectLine+= nullToBlankCheck(prospect?.contactName) + ","
        	prospectLine+= nullToBlankCheck(prospect?.contactTitle) + ","
			prospectLine+= nullToBlankCheck(prospect?.phone) + ","
			prospectLine+= nullToBlankCheck(prospect?.phoneExtension) + ","
			prospectLine+= nullToBlankCheck(prospect?.cellPhone) + ","
			prospectLine+= nullToBlankCheck(prospect?.fax) + ","
        	prospectLine+= nullToBlankCheck(prospect?.email) + ","
			prospectLine+= nullToBlankCheck(prospect?.website) + ","
			prospectLine+= nullToBlankCheck(prospect?.territory?.name) + ","
			prospectLine+= nullToBlankCheck(prospect?.status?.name) + ","
			println "113:" + nullToBlankCheck(prospect?.verified)
			prospectLine+= nullToBlankCheck(prospect?.verified)+ ","
			prospectLine+= nullToBlankCheck(prospect?.emailOptIn).toBoolean()
			prospectsCsvLines.add(prospectLine)
        }
        return prospectsCsvLines
    }
}