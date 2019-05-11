<%@ page import="io.seal.Account" %>
<%@ page import="io.seal.State" %>
<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>


<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default">
		<title>Edit Account</title>
	</head>
	<body>


	<div class="form-outer-container">
	
	
		<div class="form-container">
		

			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${flash.message}</div>
			</g:if>
		
		
			<h2>Edit Account			
				
				<div style="display:inline-block;width:10px;height:10px;" class="pull-right"></div>
				<br class="clear"/>
			</h2>

			<br class="clear"/>
			
			
			
			<g:hasErrors bean="${accountInstance}">
				<ul class="errors" role="alert" class="alert alert-info">
					<g:eachError bean="${accountInstance}" var="error">
					<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
					</g:eachError>
				</ul>
			</g:hasErrors>
			
			
			
			
			<g:form action="update_account" method="post" class="form-horizontal" autocomplete="off">
			
				<g:hiddenField name="id" value="${accountInstance?.id}" />
				
				
				<g:if test="${accountInstance.username == 'admin'}">
					<div class="form-row">
						<span class="form-label full">UUID</span>
						<span class="input-container">
							<g:textField type="uuid" name="uuid" value="${accountInstance?.uuid}" class="form-control twofifty"/>
						</span>
						<span class="information">You can manually set UUID to match exported data UUID for admin account</span>
						<br class="clear"/>
					</div>
				</g:if>

				<div class="form-row">
					<span class="form-label full">Username</span>
					<span class="input-container">
						${accountInstance.username}
					</span>
					<br class="clear"/>
				</div>


				<div class="form-row">
					<span class="form-label full">Name</span>
					<span class="input-container">
						<g:textField class="form-control twohundred"  name="name" value="${accountInstance?.name}"/>
					</span>
					<br class="clear"/>
				</div>



				<div class="form-row">
					<span class="form-label full">Phone</span>
					<span class="input-container">
						<input type="text" class="twoseventyfive form-control"  name="phone" id="phone" value="${accountInstance?.phone}" autocomplete="false" />
					</span>
					<br class="clear"/>
				</div>



				<div class="form-row">
					<span class="form-label full">Password</span>
					<span class="input-container">
						<input type="password" class="twofifty form-control"  name="passwordRaw" value="" placeholder="********"  autocomplete="false" /><br/>
						<span class="information secondary">Leave to keep password the same</span>
					</span>
					<br class="clear"/>
				</div>

				
				
				<div class="buttons-container" style="margin-top:82px;">
					
					<input type="submit" class="btn btn-primary" value="Update Account" />
					
				</div>
				
			</g:form>
	
		</div>
	
	</div>	
	
	
	<script type="text/javascript" src="${resource(dir:'js/country_states.js')}"></script>
	
	<script type="text/javascript">
		$(document).ready(function(){

			var phone = "${accountInstance?.phone}"
			if(phone == ""){
				$("#phone").val(" ")
			}
		})
	</script>
	
	</body>
</html>
