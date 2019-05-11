<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Update Website</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Update Website</h2>
		

		<br class="clear"/>
		
		
		<g:form action="update" class="form-horizontal" role="form" method="post" id="${prospectWebsiteInstance?.id}">
		
		
			<input type="hidden" name="id" value="${prospectWebsiteInstance?.id}"/>
			<input type="hidden" name="prospectId" value="${prospectWebsiteInstance?.prospect?.id}"/>
			
			
			<div class="form-row">
				<span class="form-label half hint">Url
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">
					<input type="text" name="website" value="${prospectWebsiteInstance?.website}" class="form-control fourhundred" placeholder="http://"/>
				</span>
				<br class="clear"/>
			</div>
			
			
			<div class="form-row">
				<span class="form-label half hint">Description
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">
					<textarea name="description" id="description" class="form-control" style="height:150px; width:323px;">${prospectWebsiteInstance?.description}</textarea>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			
			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="update" class="btn btn-primary" value="Update Website" />		
				<br class="clear"/>
			</div>
			
		</g:form>

	</div>

</div>	

</body>
</html>

