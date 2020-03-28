<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<%@page import="io.seal.State"%>
<%@page import="io.seal.Territory%>
<%@page import="io.seal.Status%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Create Prospect</title>	
</head>
	
<body>

<h1 style="padding:10px;text-align:center">Create Prospect</h1>


<div class="form-outer-container" style="width:573px; float:left;">

	<div class="form-container">

		<br class="clear"/>
		
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${raw(flash.message)}</div>
			</g:if>
				
			<g:hasErrors bean="${prospectInstance}">
				<div class="alert alert-danger">
					<ul>
						<g:eachError bean="${prospectInstance}" var="error">
							<li><g:message error="${error}"/></li>
						</g:eachError>
					</ul>
				</div>
			</g:hasErrors>
			
		</div>
		
	
		
		<g:form action="save" class="form-horizontal" role="form" method="post">



			<div class="form-row">
				<span class="form-label full">* Company
				</span>
				
				<span class="input-container">
					<g:textField type="text" name="company" value="${prospectInstance?.company}" class="form-control threehundred"/>
					<p class="information secondary" style="margin-top:7px;">Contact Name or Company must be complete</p>
				</span>
				<br class="clear"/>
			</div>
			
			
			<!--
			<div class="form-row">
				<span class="form-label full">Address 1</span>
				<span class="input-container">
					<g:textField class="threehundred form-control"  name="address1" value="${prospectInstance?.address1}"/>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			<div class="form-row ">
				<span class="form-label full">Address 2</span>
				<span class="input-container">
					<g:textField class="threehundred form-control"  name="address2" value="${prospectInstance?.address2}"/>
				</span>
				<br class="clear"/>
			</div>



			<div class="form-row">
				<span class="form-label full">City</span>
				<span class="input-container">
					<g:textField class="twotwentyfive form-control"  name="city" value="${prospectInstance?.city}"/>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			<div class="form-row">
			  	<label for="country" class="form-label full">Country</label>
				<span class="input-container">
					<g:select name="country.id"
							from="${countries}"
							value="${prospectInstance?.country?.id}"
							optionKey="id" 
							optionValue="name"
							class="form-control"
							id="countrySelect"/>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			<div class="form-row">
				<span class="form-label full">State</span>
				<span class="input-container">	
					<g:select name="state.id"
							from="${State.list()}"
							value="${prospectInstance?.state?.id}"
							optionKey="id" 
							optionValue="name" 
							class="form-control"
							id="stateSelect"/>
				</span>
				<br class="clear"/>	
			</div>
			
			
			

			<div class="form-row">
				<span class="form-label full">Zip</span>
				<span class="input-container">
					<g:textField class="onefifty form-control"  name="zip" value="${prospectInstance?.zip}"/>
				</span>
				<br class="clear"/>
			</div>
			
			-->
				

			<div class="form-row">
				<span class="form-label full">* Contact Name
					<!--<p class="information secondary">Contact Name or Company must be complete</p>-->
				</span>
				<span class="input-container">
					<g:textField class="form-control threehundred"  name="contactName" value="${prospectInstance?.contactName}"/>
				</span>
				<br class="clear"/>
			</div>


			<div class="form-row">
				<span class="form-label full">Phone</span>
				<span class="input-container">
					<g:textField class="twohundred form-control"  name="phone" value="${prospectInstance?.phone}"/>
				</span>
				<br class="clear"/>
			</div>
			

			<div class="form-row">
			  	<label for="country" class="form-label full">Territory</label>
				<span class="input-container">
					<g:select name="territory.id"
							from="${io.seal.Territory.list()}"
							value="${prospectInstance?.territory?.id}"
							optionKey="id" 
							optionValue="name"
							class="form-control"
							id="territorySelect"
							style="width:275px;"
                            noSelection="${['': 'Select One...']}"/>
				</span>
				<br class="clear"/>
			</div>

			
			
			
			<div class="form-row">
			  	<label for="country" class="form-label full">Status</label>
				<span class="input-container">
					<g:select name="status.id"
							from="${io.seal.Status.list()}"
							value="${prospectInstance?.status?.id}"
							optionKey="id" 
							optionValue="name"
							class="form-control"
							id="statusSelect"
							style="width:225px"
                            noSelection="${['': 'Select One...']}"/>
				</span>
				<br class="clear"/>
			</div>


			
			<div class="buttons-container">	

				<g:submitButton name="create" class="button retro" value="Create Prospect" />		
				<br class="clear"/>
			</div>

			<br class="clear"/>
			
		</g:form>

	</div>
	
	
	<br class="clear"/>

</div>		

<br class="clear"/>

<script type="text/javascript" src="${resource(dir:'js/country_states.js')}"></script>

<script type="text/javascript">
	$(document).ready(function(){
		countryStatesInit("${applicationService.getContextName()}", 1000)
	})
</script>

</body>
</html>
