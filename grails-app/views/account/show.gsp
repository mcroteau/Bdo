<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>

<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Show Account</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<g:if test="${flash.message}">
		<p>${raw(flash.message)}</p>
	</g:if>
	
	<p>Id : ${accountInstance.id}, Click <g:link action="edit" id="${accountInstance.id}">here</g:link> to edit.</p>
	
	<p>Username : ${accountInstance.username}</p>
	
	<g:if test="${accountInstance.name}">	
		<p>Contact Name : ${accountInstance.name}</p>
	</g:if>
	
	
	<g:if test="${accountInstance.phone}">	
		<p>Phone : ${accountInstance.phone}</p>
	</g:if>

	
	<g:link action="create">Create New Account</g:link>

</div>


</body>
</html>
