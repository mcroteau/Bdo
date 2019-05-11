package io.seal

import io.seal.Permission
import io.seal.Role

import io.seal.common.ApplicationConstants

class Account {
	
	Account(){
		this.uuid = UUID.randomUUID().toString()
	}
	
	String uuid
	
	String username
    String password
	
	String name	
	String phone
	
	String resetUUID
	
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

	boolean hasAdminRole

	
	Date dateCreated
	Date lastUpdated
	

	static hasMany = [ permissions: Permission, salesActions: SalesAction, sales: ProspectSale ]
	
	
	Set<Role> getAuthorities() {
		AccountRole.findAllByAccount(this)*.role
	}

	def createAccountPermission(){
		createPermission(ApplicationConstants.ACCOUNT_PERMISSION + this.id)
	}

	def createAdminAccountRole(){
		def adminRole = Role.findByAuthority(ApplicationConstants.ROLE_ADMIN)
		createAccountRole(adminRole)
	}

	def createAccountRoles(includeAdminRole){
		this.hasAdminRole = false
		this.save(flush:true)

		def role = Role.findByAuthority(ApplicationConstants.ROLE_SALESMAN)
		createAccountRole(role)
	
		if(includeAdminRole){
			def adminRole = Role.findByAuthority(ApplicationConstants.ROLE_ADMIN)
			createAccountRole(adminRole)
			this.hasAdminRole = true
		}

		this.save(flush:true)
	}

	def createAccountRole(role){
		if(!this)throw new Exception("Account didn't save correctly")
		def accountRole = new AccountRole()
		accountRole.account = this
		accountRole.role = role
		accountRole.save(flush:true)	
	}

	def createPermission(permissionString){
		def permission = new Permission()
		permission.account = this
		permission.permission = permissionString
		permission.save(flush:true)

		this.addToPermissions(permission)
		this.save(flush:true)
	}


	def getNameEmail(){
		if(this.name){
			return this.name
		}else{
			return this.email
		}
	}
	
	static constraints = {
		uuid(nullable:true)
        username(email:true, nullable:false, blank:false, unique: true)
		password(minSize: 5, nullable:false, blank:false, column: '`password`')
		name(blank:true, nullable:true)
		phone(nullable:true)
		hasAdminRole(nullabe:true)
		resetUUID(nullable:true)
		enabled(nullable:true, default:true)
		accountExpired(nullable:true)
		accountLocked(nullable:true)
		passwordExpired(nullable:true)
		id generator: 'sequence', params:[sequence:'ID_ABCR_ACCOUNT_PK_SEQ']
    }
	
}
