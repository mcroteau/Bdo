<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<%@page import="io.seal.SalesAction"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Confirm Delete</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<div class="alert alert-warning" role="status">This action cannot be undone...</div>

		<h2>Delete Selection</h2>
		
		<br class="clear"/>
		

		<g:form action="delete_selected" class="form-horizontal" role="form" method="post">

			<input type="hidden" name="ids" value="${ids}"/>
						
			<div class="form-row">
			  	<label for="country" class="form-label half">Prospects
					<p class="information secondary">The prospects that will be deleted</p>
				</label>
				<span class="input-container">
					<div class="form-control twofifty" style="background:#f8f8f8;height:179px;overflow:scroll;">
						<g:each in="${prospectInstanceList}" var="prospectInstance">
							${prospectInstance.id} : ${prospectInstance.company}<br/>
						</g:each>
					</div>	
				</span>
			</div>
			<br class="clear"/>
			
			
			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="create" class="btn btn-danger" value="Permanently Delete Prospects" />		
				<br class="clear"/>
			</div>
			
		</g:form>

	</div>

</div>	



<script type="text/javascript">
	$(document).ready(function(){
		var $actionDate = $("#action-date")
		
		$actionDate.datepicker({autoclose: true});
		
	})
</script>

</body>
</html>
