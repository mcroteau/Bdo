<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Update Sale</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Update Sale</h2>
		

		<br class="clear"/>
		
		
		<g:form action="update" class="form-horizontal" role="form" method="post">

			
			<input type="hidden" name="id" value="${prospectSaleInstance?.id}"/>
			<input type="hidden" name="prospectId" value="${prospectSaleInstance?.prospect.id}"/>
			
			

			
			<div class="form-row">
				<span class="form-label full hint">Sales Person
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">${prospectSaleInstance?.salesPerson?.nameEmail}</span>
				<br class="clear"/>
			</div>

			
			<div class="form-row">
				<span class="form-label full hint">Total Amount $
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">
					<input type="text" name="total" id="total" class="form-control twohundred" value="${prospectSaleInstance?.total}">
				</span>
				<br class="clear"/>
			</div>
			
			
			<div class="form-row">
				<span class="form-label full hint">Date
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">
					<g:datePicker name="salesDate" value="${prospectSaleInstance?.salesDate}"
              				precision="day"/>
				</span>
				<br class="clear"/>
			</div>
			
			
			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="update" class="btn btn-primary" value="Update Sale" />		
				<br class="clear"/>
			</div>
			
		</g:form>

	</div>

</div>	

</body>
</html>
