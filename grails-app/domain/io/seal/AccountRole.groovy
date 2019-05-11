package io.seal

import grails.gorm.DetachedCriteria
import groovy.transform.ToString

import org.apache.commons.lang.builder.HashCodeBuilder

@ToString(cache=true, includeNames=true, includePackage=false)
class AccountRole implements Serializable {

	private static final long serialVersionUID = 1

	Account account
	Role role

	AccountRole(Account u, Role r) {
		this()
		account = u
		role = r
	}

	@Override
	boolean equals(other) {
		if (!(other instanceof AccountRole)) {
			return false
		}
		other.account?.id == account?.id && other.role?.id == role?.id
	}

	@Override
	int hashCode() {
		def builder = new HashCodeBuilder()
		if (account) builder.append(account.id)
		if (role) builder.append(role.id)
		builder.toHashCode()
	}


	static mapping = {
		id composite: ['account', 'role']
		version false
	}
}
