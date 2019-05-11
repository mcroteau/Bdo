package io.seal

class ProspectWebsite {
	
	ProspectWebsite(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid

	String website
	String description
	
	Date dateCreated
	Date lastUpdated
	
	static belongsTo = [ prospect: Prospect ]

	static mapping = {
		sort id: "asc"
		description type: "text"
	}
	
	static constraints = {
		uuid(nullable:true)
		website(nullable:false)
		description(nullable:true)
		id generator: 'sequence', params:[sequence:'ID_PROSPECT_WEBSITE_ID_PK_SEQ']
    }
}