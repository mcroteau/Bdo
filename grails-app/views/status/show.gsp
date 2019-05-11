<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>

<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Show Prospect</title>	
</head>
	
<body>
<div class="form-outer-container" style="margin-top:50px;">
	
	<g:if test="${flash.message}">
		<p>${raw(flash.message)}</p>
	</g:if>
	
	<p>Status Id : ${statusInstance.id}, Click <g:link action="edit" id="${statusInstance?.id}">here</g:link> to edit.</p>
	
	<p>Status Name : ${statusInstance.name}</p>
	
	<g:link action="create">Create New Status</g:link><br/>
	
	<g:link action="index">Back to Statuses</g:link>

</div>	




</body>
</html>
