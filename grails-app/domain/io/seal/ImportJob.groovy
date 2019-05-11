package io.seal

class ImportJob {

	ImportJob(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid
	
	Date dateCreated

	static mapping = {
		sort id: "desc"
	}
	
	static constraints = {
		uuid(nullable:true)
		id generator: 'sequence', params:[sequence:'ID_IMPORT_JOB_PK_SEQ']
    }
}