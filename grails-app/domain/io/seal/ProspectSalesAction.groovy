package io.seal

import io.seal.common.ApplicationConstants


class ProspectSalesAction { 
	
	ProspectSalesAction(){
		this.uuid = UUID.randomUUID().toString()
	}

	String uuid
	
	Date actionDate
	String note
	String status
	
	boolean reminder
	int reminderTime
	Date reminderDate
	boolean reminded
	
	boolean completed
	Date dateCompleted
	
	Date dateCreated
	Date lastUpdated

	SalesAction salesAction
	Account account
	
	SalesEffort salesEffort
	
	static belongsTo = [ prospect: Prospect ]


	static mapping = {
		sort actionDate: "asc"
		note type: "text"
	}
	
	static constraints = {
		uuid(nullable:true)
		actionDate(nullable:false)
		note(nullable:true)
		reminder(nullable:true, default:false)
		reminderTime(nullable:true)
		reminderDate(nullable:true)
		reminded(nullable:true, default:false)
		account(nullable:true)
		salesEffort(nullable:true)
		completed(nullable:true, default:false)
		dateCompleted(nullable:true)
		status(nullable:true, default: ApplicationConstants.SALES_ACTION_ACTIVE)
		id generator: 'sequence', params:[sequence:'ID_PROSPECT_SALES_ACTION_ID_PK_SEQ']
    }
}
