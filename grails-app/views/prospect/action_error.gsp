<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Success</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">

		<h2 style="text-align:left">Something went wrong</h2>
		

		<br class="clear"/>
		
		
		<div class="messages">
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${raw(flash.message)}</div>
			</g:if>
		</div>
		
		
	</div>
	
	
	<div class="buttons-container">	
		<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
	</div>
</div>	

</body>
</html>
