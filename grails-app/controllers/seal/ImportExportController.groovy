package seal

import static org.springframework.http.HttpStatus.OK

import grails.plugin.springsecurity.annotation.Secured
import grails.io.IOUtils

import io.seal.common.ApplicationConstants

import io.seal.Country
import io.seal.State
import io.seal.Territory
import io.seal.Status
import io.seal.Prospect


class ImportExportController {
	
	def commonUtilities
	def encoding
	def csvMimeType//it might be time

	@Secured([ApplicationConstants.ROLE_ADMIN])
	def index(){}


	@Secured([ApplicationConstants.ROLE_ADMIN])
	def view_import(){
		[ count: params.count, skipped: params.skipped, errored: params.errored ]
	}	


	@Secured([ApplicationConstants.ROLE_ADMIN])
	def import_prospects(){
		def file = request.getFile('file')
		def is = file.getInputStream()
		
		BufferedReader br = null;
		StringBuilder sb = new StringBuilder();
        
 	   	def count = 0
		def skipped = 0
		def errored = 0
		String line;
		
		try {
	    
			def importUuid = commonUtilities.generateRandomString(7)

			br = new BufferedReader(new InputStreamReader(is));
			while ((line = br.readLine()) != null) {
				def fields = line.split(",", -1);
				println "# of fields : " + fields.size()
				try{
					
					def prospect = createProspectFromData(importUuid, fields)
					def existingProspectCompany = Prospect.findByCompany(prospect?.company)
					//def existingProspectEmail = Prospect.findByEmail(prospect?.email)
					def existingProspectEmail = null

					if(prospect?.company &&
						!existingProspectCompany &&
							!existingProspectEmail){

						println "save prospect : ${prospect.verified}"
						prospect.save(flush:true)
						count++							
						println "inserted prospect..." + count
					}else{
						skipped++
						println "prospect exists..." + prospect.company + " : " + skipped
					}
					
				}catch(Exception ae){
					println ae
					errored++
					println "errored on insert..." + errored
				}
			}
			
		} catch (IOException e) {
			flash.error = "Something went wrong while trying to import.  Please confirm correct formatting"
			e.printStackTrace();
		} finally {
			closeBufferedReader(br)
		}
		
		if(count == 0 && skipped > 0){
			flash.message = "Prospects already exist"
		}
 	   	if(count > 0){
			flash.message = "Successfully imported <strong>${count}</strong> prospects"
		}
		if(errored > 0){
			flash.error = "Errored on <strong>${errored}</strong> prospects.  Please review file and results to resolve"
		}

		redirect(action: "view_import", params: [ count: count, skipped: skipped, errored: errored ])
	}



	def createProspectFromData(importUuid, fields){

		def prospect = new Prospect()
		prospect.company = fields[0]
		prospect.address1 = fields[1]
		prospect.address2 = fields[2]
		prospect.city = fields[3]

		def state = State.findByName(fields[4])
		prospect.state = state ? state : null

		def country = Country.findByName(fields[5])
		prospect.country = country ? country : null

		prospect.zip = fields[6]
		prospect.contactName = fields[7]
		prospect.contactTitle = fields[8]
		prospect.phone = fields[9]
		prospect.phoneExtension = fields[10]
		prospect.cellPhone = fields[11]
		prospect.fax = fields[12]

		println "'" + fields[13] +  "'"

        def email = fields[13]

        if(email){
        	prospect.email = email
        }

		prospect.website = fields[14]
		
		def territory = Territory.findByName(fields[15])
		def importTerritory = Territory.findByName("Imported")
		prospect.territory = territory ? territory : (importTerritory ? importTerritory : null)

		def status = Status.findByName(fields[16])
		prospect.status = status ? status : null
		
		println "boolean : " + fields[17]

		prospect.verified = fields[17].toBoolean()
		//prospect.emailOptIn = fields[18].toBoolean()
		//add back sales count?
		//prospect.totalSalesValue = fields[0]
		prospect.importUuid = importUuid
		println "verified : ${prospect.verified}"
		return prospect
	}



	@Secured([ApplicationConstants.ROLE_ADMIN])
    def export_all(){
        def prospects = Prospect.list()
        def prospectsCsvLines = commonUtilities.createProspectCsvLines(prospects)

        def filename = "prospects.csv"
        def outs = response.outputStream
        response.status = OK.value()
        response.contentType = "${csvMimeType};charset=${encoding}";
        response.setHeader "Content-disposition", "attachment; filename=${filename}"
 
        prospectsCsvLines.each { String line ->
        	println line
            outs << "${line}\n"
        }
 
        outs.flush()
        outs.close()
    } 




	def closeBufferedReader(br){
		if (br != null) {
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}


}