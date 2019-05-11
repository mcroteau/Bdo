package seal

import grails.plugin.springsecurity.annotation.Secured

import io.seal.common.ApplicationConstants

class AdministrationController {
	
	@Secured([ApplicationConstants.ROLE_ADMIN])
	def index(){}

}