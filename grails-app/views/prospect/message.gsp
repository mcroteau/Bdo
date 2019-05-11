<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>

<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Administration</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<g:if test="${flash.message}">
		<div class="alert alert-info" role="status">${raw(flash.message)}</div>
	</g:if>
	
	<g:link action="create">Create New Prospect</g:link>
	<br/>
	<br/>
	<g:link action="search">Search Prospects</g:link>

</div>	




</body>
</html>
