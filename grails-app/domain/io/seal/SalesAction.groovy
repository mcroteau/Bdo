package io.seal

class SalesAction {
	
	SalesAction(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid
	String name
		
	static mapping = {
	    sort id: "asc"
	}
		
    static constraints = {
		uuid(nullable:true)
		name(unique:true)
		id generator: 'sequence', params:[sequence:'ID_SALES_ACTION_PK_SEQ']
    }
}
