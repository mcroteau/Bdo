package seal

class NotificationUnoJob {
	
	def notificationService

    static triggers = {
      	simple startDelay: 60000, repeatInterval: 10000
    }

    void execute() {
    	println "********** Uno ***********"
    	notificationService.run()
    }
	
}
