package io.seal

import io.seal.common.ApplicationConstants

class ProspectSale {
	
	ProspectSale(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid
	BigDecimal total

	Date salesDate

	Account salesPerson

	Date dateCreated
	Date lastUpdated		
	
	static belongsTo = [ prospect: Prospect ]
	
	static mapping = {
		sort id: "asc"
		salesPeople sort: "id", order: "asc"
	}
	
	static constraints = {
		uuid(nullable:true)
		total(nullable:false)
		salesDate(nullable:false)
		salesPerson(nullable:true)
		id generator: 'sequence', params:[sequence:'ID_PROSPECT_SALE_ID_PK_SEQ']
    }
}