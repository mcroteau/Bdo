<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<%@page import="io.seal.SalesAction"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Update Selection</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Update Selection</h2>
		
		<br class="clear"/>
		
		
		<g:form action="update_selected" class="form-horizontal" role="form" method="post">


			<input type="hidden" name="ids" value="${ids}"/>
			
			
			<div class="form-row">
			  	<label for="country" class="form-label half">Territory</label>
				<span class="input-container">
					<g:select name="territory.id"
							from="${io.seal.Territory.list()}"
							value=""
							optionKey="id" 
							optionValue="name"
							class="form-control twofifty"
							id="territorySelect"
							style="width:225px;"
                            noSelection="${['': '-']}"/>
				</span>
				<br class="clear"/>
			</div>
			
			<div class="form-row">
			  	<label for="country" class="form-label half">Status</label>
				<span class="input-container">
					<g:select name="status.id"
							from="${io.seal.Status.list()}"
							value=""
							optionKey="id" 
							optionValue="name"
							class="form-control twofifty"
							id="statusSelect"
							style="width:225px;"
                            noSelection="${['': '-']}"/>
				</span>
				<br class="clear"/>
			</div>


			
			<div class="form-row">
			  	<label for="country" class="form-label half">Verified</label>
				<span class="input-container">
					<select name="verified" class="form-control">
						<option value="false">Not Verified</option>
						<option value="true">Verified</option>
						<option value="" selected>-</option>
					</select>	
				</span>
				<br class="clear"/>
			</div>
			
			
			<div class="form-row">
			  	<label for="country" class="form-label half">Prospects
					<p class="information secondary">The prospects that will be updated</p>
				</label>
				<span class="input-container">
					<div class="form-control twofifty" style="height:179px;overflow:scroll">
						<g:each in="${prospectInstanceList}" var="prospectInstance">
							${prospectInstance.id} : ${prospectInstance.company} : ${prospectInstance.contactName}<br/>
						</g:each>
					</div>	
				</span>
			</div>
			<br class="clear"/>
			
			
			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="create" class="btn btn-primary" value="Update Selected Prospects" />		
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
