<%@ page import="grails.util.Environment" %>

<%@ page import="grails.util.Environment" %>
<% def commonUtilities = grailsApplication.classLoader.loadClass('io.seal.common.CommonUtilities').newInstance()%>

<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

	<link href="https://fonts.googleapis.com/css?family=Roboto:100,100i,300,300i,400,400i,500,500i,700,700i,900,900i&display=swap" rel="stylesheet">

	<link rel="icon" type="image/png" href="/${applicationService.getContextName()}/static/images/favicon.png" />
	
	<title>${applicationService.getSiteName()}: <g:layoutTitle default="Open Source Sales Management" /></title>

	<script type="text/javascript" src="${resource(dir:'js/lib/jquery/jquery.min.js')}"></script>

	<link rel="stylesheet" href="${resource(dir:'bootstrap', file:'responsive.css')}" />

	<link rel="stylesheet" href="${resource(dir:'css', file:'application.css')}" />

	<g:layoutHead/>

</head>
<body>
	
	<%
		def account = commonUtilities.getAuthenticatedAccount()
	%>	


	<div id="outer-container" class="container">
		
		<div class="row">
			
			<div class="col-md-2"></div>
			<div class="col-md-8">

				<div id="content-container" class="shadow-lg" >
					<div id="header">

			    		<g:link uri="/accounts" elementId="logo-logo">
			    			<span style="font-size:19px">Bdo<span>&nbsp;
			    		</g:link>
						<span class="tiny-tiny" style="display:inline-block;margin-top:20px;">[open source<br/> sales software]</span>


						<div id="navigation">
							<ul class="light" style="margin-bottom:21px !important">
								<li><g:link uri="/dashboard" class="${dashboardActive}"><g:message code="dashboard" /></g:link></li>

								<li><g:link uri="/prospect/search" class="${prospectsActive}">Search</g:link></li>

								<li><g:link uri="/prospect/create" class="${prospectsActive}">New Prospect</g:link></li>

							</ul>
						</div>
						
						<br class="clear"/>

					</div>

					<div id="container">
						<g:layoutBody/>
					</div>


					<div class="align-right" style="margin-top:70px;">
					<sec:ifAllGranted roles='ROLE_ADMIN'>
						<g:link uri="/administration" class="${administrationActive}"><g:message code="administration" /></g:link>
						<g:link uri="/settings" class="${settingsActive}"><g:message code="settings" /></g:link>
					</sec:ifAllGranted>
						<g:link uri="/account/account" class="${accountsActive}"><g:message code="your.account" /></g:link>
						<g:link uri="/logout">Logout</g:link>
					</div>

				</div>
			</div>
			<div class="col-md-2"></div>
		</div>
	</div>




	<div style="margin-top:221px; text-align:center"></div>

</body>
</html>