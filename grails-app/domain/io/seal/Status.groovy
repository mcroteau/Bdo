package io.seal

class Status {
	
	Status(){
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
		id generator: 'sequence', params:[sequence:'ID_STATUS_PK_SEQ']
    }
}