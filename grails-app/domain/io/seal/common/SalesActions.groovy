package io.seal.common

enum SalesActions {
	
	MAILER("Mailer"),
	COLD_CALL("Cold Call"),
	EMAIL("Email"),
	FOLLOW_UP("Follow Up"),
	MEETING("Meeting"),
	DEMO("Demo")

	private final String title

	SalesActions(title){
		this.title = title
	}

	def getT(){
		return this.title
	}

	def getName(){
		return this.title
	}
}