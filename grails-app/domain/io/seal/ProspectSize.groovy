package io.seal

class ProspectSize {
	
	ProspectSize(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid
	String size

	static mapping = {
	    sort id : "asc"
	}
		
    static constraints = {
		uuid(nullable:true)
		size(unique:true)
		id generator: 'sequence', params:[sequence:'ID_SIZE_PK_SEQ']
    }
}