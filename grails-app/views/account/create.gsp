<%@ page import="io.seal.Account" %>
<%@ page import="io.seal.State" %>
<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>

<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Create Account</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">

		<h2>

			<g:if test="${admin == 'true'}">
				Create Administrator			
			</g:if>
			<g:else>
				Create Sales Person		
			</g:else>

			<g:link controller="abcrAccount" action="index" params="[admin:false]" class="pull-right" style="font-size:13px;">Back to Accounts</g:link>
			<br class="clear"/>
		</h2>
		

		<br class="clear"/>
		
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${raw(flash.message)}</div>
			</g:if>
				
			<g:hasErrors bean="${accountInstance}">
				<div class="alert alert-danger">
					<ul>
						<g:eachError bean="${accountInstance}" var="error">
							<li><g:message error="${error}"/></li>
						</g:eachError>
					</ul>
				</div>
			</g:hasErrors>
			
		</div>
		
	
		
		<g:form action="save" class="form-horizontal" role="form" method="post">



			<div class="form-row">
				<span class="form-label full">Username
					<p class="information secondary">Username must be a valid email address</p>
				</span>
				
				<span class="input-container">
					<g:textField type="text" name="username" required="" value="${accountInstance?.username}" class="form-control twofifty"/>
				</span>
				<br class="clear"/>
			</div>
			
			

			<div class="form-row">
				<span class="form-label full">Password
					<p class="information secondary">Password must be at least 5 characters long</p>
				</span>
				<span class="input-container">
					<g:textField type="text" name="password" required="" value="${accountInstance?.password}" class="form-control twofifty"/>
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
					<g:textField class="twofifty form-control"  name="phone" value="${accountInstance?.phone}"/>
				</span>
				<br class="clear"/>
			</div>

			

			<div class="form-row">
				<span class="form-label full">Is Adminstrator
					<p class="information">All Accounts are Salesman by default</p>
				</span>
				<span class="input-container">
					<g:checkBox name="admin" value="${accountInstance.hasAdminRole}" checked="${admin}"/>
				</span>
				<br class="clear"/>
			</div>	
			
			
			<div class="buttons-container">	
				<g:submitButton name="create" class="btn btn-primary" value="Create Account" />		
			</div>
			
		</g:form>

	</div>

</div>	


<script type="text/javascript" src="${resource(dir:'js/country_states.js')}"></script>

<script type="text/javascript">
	$(document).ready(function(){
	})
</script>

</body>
</html>
