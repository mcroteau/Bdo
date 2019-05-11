package io.seal.common

enum Statuses {

	IDLE("Idle"),
	PROSPECT("Prospect"),
	SALES_EFFORT("Sales Effort"),
	SALE("Sale"),
	CLIENT("Client"), 
	IMPORTED("Imported")

	private final String name

	Statuses(name){
		this.name = name
	}

	def getT(){
		return this.name
	}
}