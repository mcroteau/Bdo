package io.seal

import io.seal.common.ApplicationConstants

class ProspectNote {
	
	ProspectNote(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid

	Date dateCreated
	Date lastUpdated
	
	String note
	
	Account account
	
	static belongsTo = [ prospect: Prospect ]

	static mapping = {
		sort id: "asc"
		note type: "text"
	}
	
	static constraints = {
		uuid(nullable:true)
		note(nullable:false)
		id generator: 'sequence', params:[sequence:'ID_PROSPECT_NOTE_ID_PK_SEQ']
    }
}