<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Update Contact</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Update Contact</h2>
		

		<br class="clear"/>
		
		
		<g:form action="update" class="form-horizontal" role="form" method="post">

			
			<input type="hidden" name="id" value="${prospectContactInstance.id}"/>
			<input type="hidden" name="prospectId" value="${prospectContactInstance?.prospect?.id}"/>
			
			
			<div class="form-row">
				<span class="form-label full">Name</span>
				<span class="input-container">
					<input type="text" name="contactName" value="${prospectContactInstance.contactName}" class="form-control threehundred"/>
				</span>
				<br class="clear"/>
			</div>
			

			
			<div class="form-row">
				<span class="form-label full">Title</span>
				<span class="input-container">
					<input type="text" name="contactTitle" value="${prospectContactInstance.contactTitle}" class="form-control"/>
				</span>
				<br class="clear"/>
			</div>
			

			
			<div class="form-row">
				<span class="form-label full">Phone</span>
				<span class="input-container">
					<input type="text" name="phone" value="${prospectContactInstance.phone}" class="form-control onefifty" style="float:left;"/>
					<span style="float:left;display:inline-block;width:20px;text-align:center; margin:10px 0px 0px 10px" class="information">Ext.</span>
					<input type="text" name="phoneExtension" value="${prospectContactInstance.phoneExtension}" class="form-control" style="width:75px;float:left"/>
				</span>
				<br class="clear"/>
			</div>
			

			
			<div class="form-row">
				<span class="form-label full">Cell Phone</span>
				<span class="input-container">
					<input type="text" name="cellPhone" value="${prospectContactInstance.cellPhone}" class="form-control"/>
				</span>
				<br class="clear"/>
			</div>
			

			
			<div class="form-row">
				<span class="form-label full">Fax</span>
				<span class="input-container">
					<input type="text" name="fax" value="${prospectContactInstance.fax}" class="form-control"/>
				</span>
				<br class="clear"/>
			</div>
			

			
			<div class="form-row">
				<span class="form-label full">Email</span>
				<span class="input-container">
					<input type="text" name="email" value="${prospectContactInstance.email}" class="form-control threehundred"/>
				</span>
				<br class="clear"/>
			</div>

			

			
			
			
			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="create" class="btn btn-primary" value="Update Contact" />		
				<br class="clear"/>
			</div>
			
		</g:form>

	</div>

</div>	


</body>
</html>
