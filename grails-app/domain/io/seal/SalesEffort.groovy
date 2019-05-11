package io.seal

class SalesEffort {
	
	SalesEffort(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid
	
	boolean isCurrent
	boolean recording
	
	Status startingStatus
	Status completeStatus
	
	Account salesman
	Prospect prospect
	
	Date dateComplete
	
	Date dateCreated
	Date lastUpdated

	static hasMany = [ salesActions: ProspectSalesAction ]
	
	static mapping = {
		sort id: "asc"
		salesActions sort: "actionDate", order: "asc"
        salesActions cascade: 'all-delete-orphan'
	}
	
	static constraints = {
		uuid(nullable:true)
		isCurrent(nullable:true, default:false)
		recording(nullable:false, default:true)
		startingStatus(nullable:false)
		completeStatus(nullable:true)
		dateComplete(nullable:true)
		id generator: 'sequence', params:[sequence:'ID_SALES_EFFORT_PK_SEQ']
    }
}