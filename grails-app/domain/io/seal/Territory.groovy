package io.seal

class Territory {
	
	Territory(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid	
	String name
	
	static mapping = {
	    sort id: "asc"
	}
		
    static constraints = {
		uuid(nullable:true)
		name(nullable:false, unique:true)
		id generator: 'sequence', params:[sequence:'ID_TERRITORY_PK_SEQ']
    }
}