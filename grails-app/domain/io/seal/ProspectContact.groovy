package io.seal

class ProspectContact {
	
	ProspectContact(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid

	String contactName
	String contactTitle
	String phone
	String phoneExtension
	String cellPhone
	String fax
	String email


	Date dateCreated
	Date lastUpdated
	
	
	static belongsTo = [ prospect: Prospect ]


	static mapping = {
		sort id: "asc"
	}
	
	static constraints = {
		uuid(nullable:true)
		contactName(nullable:false)
		contactTitle(nullable:true)
		phone(nullable:true)
		phoneExtension(nullable:true)
		cellPhone(nullable:true)
		fax(nullable:true)
		email(nullable:true, email:true)
		id generator: 'sequence', params:[sequence:'ID_PROSPECT_CONTACT_ID_PK_SEQ']
    }
}