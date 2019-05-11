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
	
	<p>Prospect Id : ${prospectInstance.id}, Click <g:link action="edit" id="${prospectInstance.id}">here</g:link> to edit.</p>
	
	<g:if test="${prospectInstance.company}">
		<p>Prospect Company : ${prospectInstance.company}</p>
	</g:if>
	
	<g:if test="${prospectInstance.contactName}">	
		<p>Contact Name : ${prospectInstance.contactName}</p>
	</g:if>
	
	
	<g:if test="${prospectInstance.phone}">	
		<p>Phone : ${prospectInstance.phone}</p>
	</g:if>

	
	<g:link action="create">Create New Prospect</g:link>

</div>	




</body>
</html>
