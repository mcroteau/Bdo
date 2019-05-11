<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Finish Effort</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Finish Sales Effort</h2>
		

		<br class="clear"/>
		
		
		<g:form action="complete" class="form-horizontal" role="form" method="post">

			
			<input type="hidden" name="id" value="${salesEffortInstance?.id}"/>
			
			<div class="form-row">
			  	<label for="country" class="form-label full">Prospect Status
					<p class="information secondary">How did you do?<br/> Did you make a sale?</p>
				</label>
				<span class="input-container">
					<g:select name="status.id"
							from="${io.seal.Status.list()}"
							optionKey="id" 
							optionValue="name"
							class="form-control"
							id="statusSelect"
							style="width:225px"
                            noSelection="${['': 'Select One...']}"/>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			<div class="form-row">
				<span class="form-label full">Current Date Complete<br/>
					<span class="information secondary">Date &amp; Time is recorded<br/> when you click "Finish Effort"</span>
				</span>
				<span class="input-container">
					${new Date()}
				</span>
				<br class="clear"/>
			</div>
			

			<div class="form-row">
				<span class="form-label full">Salesman</span>
				<span class="input-container">
					${salesEffortInstance?.salesman?.name}<br/>
					${salesEffortInstance?.salesman?.username}
				</span>
				<br class="clear"/>
			</div>
			

			

			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Cancel</a>
				<g:submitButton name="start" class="btn btn-primary" value="Finish Effort" />		
				<br class="clear"/>
			</div>
			
		</g:form>

	</div>

</div>	


</body>
</html>
