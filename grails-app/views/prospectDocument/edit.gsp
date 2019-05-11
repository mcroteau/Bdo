<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Add Document</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Add Document</h2>
		

		<br class="clear"/>
		
	
		<g:uploadForm action="update" method="post"  class="form-horizontal" role="form" id="${prospectDocumentInstance?.id}" >
			
			<input type="hidden" name="id" value="${prospectDocumentInstance?.id}"/>
			<input type="hidden" name="prospectId" value="${prospectDocumentInstance?.prospect?.id}"/>
			
			
			<div class="form-row">
				<span class="form-label half hint">File : 
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">
					${prospectDocumentInstance.fileName}
				</span>
				<br class="clear"/>
			</div>
			
			<div class="form-row">
				<span class="form-label half hint">Description/Notes
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">
					<textarea name="description" id="description" class="form-control" style="height:150px; width:380px;">${prospectDocumentInstance?.description}</textarea>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="create" class="btn btn-primary" value="Add Document" />		
				<br class="clear"/>
			</div>
			
		</g:uploadForm>

	</div>

</div>	

</body>
</html>
