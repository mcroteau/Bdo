package seal.interceptors

import io.seal.common.ApplicationConstants

class SettingsActiveInterceptor {

	SettingsActiveInterceptor(){
		match(controller:"settings", action: ~/(index|company|email|sms)/)
	}

    boolean before() { 
    	request.settingsActive = ApplicationConstants.ACTIVE_CLASS_NAME
    	true 
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
