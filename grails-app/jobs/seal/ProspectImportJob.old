package seal

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

class ProspectImportJob {
	
	def prospectImportService
		
  static triggers = {
    	//simple startDelay: 60000 * 7, repeatInterval: 60000 * 73
    	simple startDelay: 20000, repeatInterval: 20000
  }

  void execute() {    
    println "*************   Fetching Hilo Accounts   *************"
    prospectImportService.fetch()
    println "*************   Fetch Complete   *************"
  }

}
