package seal

import java.io.InputStream
import java.io.ByteArrayInputStream
import java.text.SimpleDateFormat

import groovy.time.TimeDuration
import groovy.time.TimeCategory
import io.seal.ProspectSalesAction

import io.seal.common.ApplicationConstants


class NotificationJob {
	
	def notificationService

    static triggers = {
      	simple startDelay: 15000, repeatInterval: 15000
    }

    void execute() {
		def now = new Date()
		
		def notificationTime
		use( TimeCategory ) {
			notificationTime = new Date() + 30.seconds
			now.putAt(Calendar.SECOND, 0)
		}
		
		println "*** right now ${now} : ${notificationTime} ***"
		
		def salesActions = ProspectSalesAction.findAllByReminderDateBetweenAndRemindedAndStatus(now, notificationTime, false, ApplicationConstants.SALES_ACTION_ACTIVE)
	
		notificationService.sendNotifications(salesActions)
		
		println "*** ${salesActions} ***"
		salesActions.each{ salesAction ->
			salesAction.reminded = true
			salesAction.save(flush:true)
		}
    }
	
}
