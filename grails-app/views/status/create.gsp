<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Create Status</title>	
</head>
	
<body>
<div class="form-outer-container" style="width:573px; float:left;">
	
	<div class="form-container">

		<h2 style="text-align:left">Create Status</h2>
		

		<br class="clear"/>
		
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${raw(flash.message)}</div>
			</g:if>
				
			<g:hasErrors bean="${statusInstance}">
				<div class="alert alert-danger">
					<ul>
						<g:eachError bean="${statusInstance}" var="error">
							<li><g:message error="${error}"/></li>
						</g:eachError>
					</ul>
				</div>
			</g:hasErrors>
			
		</div>
		
	
		
		<g:form action="save" class="form-horizontal" role="form" method="post">


			<div class="form-row">
				<span class="form-label half">Name
				</span>
				
				<span class="input-container">
					<g:textField type="text" name="name" value="${statusInstance?.name}" class="form-control threehundred"/>
					<p class="information secondary" style="margin-top:7px;">Name must be complete and unique</p>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			<div class="buttons-container">	
				<g:link action="index">Back to List</g:link>&nbsp;&nbsp;
				<g:submitButton name="create" class="btn btn-primary" value="Create Status" />		
				<br class="clear"/>
			</div>

			<br class="clear"/>
			
		</g:form>

	</div>
	
	

</div>		

<div style="float:right; margin-top:80px; margin-right:100px; border-left:dashed 2px #ddd; height:430px;"></div>


</body>
</html>
