<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Update Note</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Update Note</h2>
		

		<br class="clear"/>
		
		
		<g:form action="update" class="form-horizontal" role="form" method="post" id="${prospectNoteInstance?.id}">
		
		
			<input type="hidden" name="id" value="${prospectNoteInstance?.id}"/>
			<input type="hidden" name="prospectId" value="${prospectNoteInstance?.prospect?.id}"/>
			
			
			<div class="form-row">
				<span class="form-label half hint">Notes
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">
					<textarea name="note" id="note" class="form-control" style="height:150px; width:380px;">${prospectNoteInstance?.note}</textarea>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			
			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="update" class="btn btn-primary" value="Update Note" />		
				<br class="clear"/>
			</div>
			
		</g:form>

	</div>

</div>	

</body>
</html>

