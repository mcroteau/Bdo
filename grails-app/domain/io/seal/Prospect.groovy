package io.seal

class Prospect {
	
	Prospect(){
		this.uuid = UUID.randomUUID().toString()
		this.emailOptIn = true
	}
	
	String uuid
	String company
	
	String address1
	String address2
	
	String city
	State state
	Country country
	String zip

	String contactName		
	String contactTitle	
	String phone
	String phoneExtension
	String cellPhone
	
	String fax
	String email
	String website
	
	Territory territory
	Status status
	ProspectSize prospectSize
	
	boolean verified
	boolean emailOptIn
	
	BigDecimal totalSalesValue
	
	SalesEffort currentSalesEffort
	
	
	String importUuid
	
	Date dateCreated
	Date lastUpdated
	

	static hasMany = [ prospectSales: ProspectSale, salesActions: ProspectSalesAction, salesEfforts: SalesEffort, prospectContacts: ProspectContact, prospectNotes: ProspectNote, prospectDocuments: ProspectDocument, prospectWebsites: ProspectWebsite ]
	
	static mapping = {
		sort id: "asc"
		prospectSales sort: "id", order: "desc"
		salesActions sort: "actionDate", order: "asc"
		prospectNotes sort: "id", order: "asc"
		prospectContacts sort: "id", order: "asc"
		prospectDocuments sort: "id", order: "asc"
		salesEfforts sort: "id", order: "desc"
	}
	
	static constraints = {
		uuid(nullable:true)
		company(blank:true, nullable:false)
		address1(nullable:true)
		address2(nullable:true)
		city(nullable:true)
		country(nullable:true)
		state(nullable:true)
		zip(nullable:true)
		contactName(nullable:true)
		contactTitle(nullable:true)
		phone(nullable:true)
		phoneExtension(nullable:true)
		cellPhone(nullable:true)
		fax(nullable:true)
        email(email:true, nullable: true, unique: true)
		website(nullable:true)
		territory(nullable:true)
		status(nullable:true)
		prospectSize(nullable:true)//size reserved word?
		verified(nullable:true, default: false)
		emailOptIn(nullable:true, default:true)
		totalSalesValue(nullable:true, default: 0)
		currentSalesEffort(nullable:true)
		importUuid(nullable:true)
		id generator: 'sequence', params:[sequence:'ID_PROSPECT_PK_SEQ']
    }
}