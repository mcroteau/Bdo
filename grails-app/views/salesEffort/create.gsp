<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Start Sales Effort</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Start Sales Effort</h2>
		

		<br class="clear"/>
		
		
		<g:form action="start" class="form-horizontal" role="form" method="post">

			
			<input type="hidden" name="id" value="${prospectInstance.id}"/>
			
			
			<div class="form-row">
			  	<label for="country" class="form-label full">Prospect Status</label>
				<span class="input-container">
					${statusInstance.name}
				</span>
				<br class="clear"/>
			</div>
			
			<div class="form-row">
				<span class="form-label full">Date</span>
				<span class="input-container">
					${new Date()}
				</span>
				<br class="clear"/>
			</div>
			

			<div class="form-row">
				<span class="form-label full">Salesman</span>
				<span class="input-container">
					${accountInstance.name}<br/>
					${accountInstance.username}
				</span>
				<br class="clear"/>
			</div>
			

			

			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="start" class="btn btn-primary" value="Start Recording New Effort" />		
				<br class="clear"/>
			</div>
			
		</g:form>

	</div>

</div>	


</body>
</html>
