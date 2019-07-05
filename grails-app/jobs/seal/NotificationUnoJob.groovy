package seal

class NotificationUnoJob {
	
	def notificationService

    static triggers = {
      	simple startDelay: 60000, repeatInterval: 60000 * 10
    }

    void execute() {
    	println "********** Uno ***********"
    	//notificationService.run()
    }
	
}
