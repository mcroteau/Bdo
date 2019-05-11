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
	
	<p>Territory Id : ${territoryInstance.id}, Click <g:link action="edit" id="${territoryInstance?.id}">here</g:link> to edit.</p>
	
	<p>Territory Name : ${territoryInstance.name}</p>
	
	<g:link action="create">Create New Territory</g:link><br/>
	
	<g:link action="index">Back to Territories</g:link>

</div>	




</body>
</html>
