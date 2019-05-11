package io.seal

class Permission {
	
	Permission(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid

   	Account account
   	String permission

	static constraints = {
		uuid(nullable:true)
		id generator: 'sequence', params:[sequence:'ID_ABCR_PERMISSION_PK_SEQ']
	}
}

