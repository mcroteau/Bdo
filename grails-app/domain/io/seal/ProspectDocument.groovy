package io.seal

import io.seal.common.ApplicationConstants

class ProspectDocument {
	
	ProspectDocument(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid
	
	String fileName
	String originalFileName
	long fileSize
	String documentUrl
	String description

	Account salesPerson

	Date dateCreated
	Date lastUpdated
		
	
	static belongsTo = [ prospect: Prospect ]

	static mapping = {
		sort id: "asc"
		description type: "text"
	}
	
	static constraints = {
		uuid(nullable:true)
		fileName(nullable:false)
		originalFileName(nullable:false)
		fileSize(nullable:false)
		documentUrl(nullable:false)
		description(nullable:true)
		salesPerson(nullable:true)
		id generator: 'sequence', params:[sequence:'ID_PROSPECT_DOCUMENT_ID_PK_SEQ']
    }
}