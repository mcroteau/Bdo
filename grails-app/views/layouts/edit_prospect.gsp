<%@ page import="grails.util.Environment" %>
<% def commonUtilities = grailsApplication.classLoader.loadClass('io.seal.common.CommonUtilities').newInstance()%>
<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
	<title><g:layoutTitle default="${message(code: "administration")}" /></title>


	<link rel="stylesheet" href="${resource(dir:'bootstrap/3.1.1/css', file:'bootstrap.min.css')}" />
	<script type="text/javascript" src="${resource(dir:'js/lib/jquery/1.11.0/jquery.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'bootstrap/3.1.1/js/bootstrap.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js/lib/datepicker/datepicker.js')}"></script>
	
	<script type="text/javascript" src="${resource(dir:'js/lib/datepicker/bootstrap-datepicker.js')}"></script>
	<link rel="stylesheet" href="${resource(dir:'js/lib/datepicker', file:'datepicker.css')}" />
	
	<script type="text/javascript" src="${resource(dir:'js/lib/dygraphs/1.1.0/dygraph-combined.min.js')}"></script>
	
	<link rel="stylesheet" href="${resource(dir:'css', file:'admin.css')}" />

	
	<g:layoutHead/>
	
	
<style type="text/css">	
	
	html,body{
		background:#e9f6f2;
		background:#f0faf7;
		background:#f8f8f8;
    	/**background: #337AB7;**/
	}
		
	@font-face { 
		font-family: Roboto-Regular; 
		src: url("${resource(dir:'fonts/Roboto-Regular.ttf')}"); 
	} 
	@font-face { 
		font-family: Roboto-Bold;
		src: url("${resource(dir:'fonts/Roboto-Bold.ttf')}"); 
	}
	@font-face { 
		font-family: Roboto-Thin; 
		src: url("${resource(dir:'fonts/Roboto-Thin.ttf')}"); 
	}
	@font-face { 
		font-family: Roboto-Light; 
		src: url("${resource(dir:'fonts/Roboto-Light.ttf')}"); 
	}
	@font-face { 
		font-family: Roboto-Black; 
		src: url("${resource(dir:'fonts/Roboto-Black.ttf')}"); 
	}
	@font-face { 
		font-family: Roboto-Medium; 
		src: url("${resource(dir:'fonts/Roboto-Medium.ttf')}"); 
	}

	#developer-mode{
		/**
		position:absolute; 
		top:1px; 
		left:13px;**/ 
		width:962px;
		line-height:1.0;
		margin:0px 0px 0px 13px; 
		padding:7px 0px 7px 0px; 
		color:#97c4b6;
		font-size:13px;
		background:#fff !important;
		border:solid 1px #bcddd3 !important;
		-webkit-border-radius: 0px;
		-moz-border-radius: 0px;
		border-radius: 0px;
	}

	#seeking-developers-container{
		width:200px;
		left:1000px;
		position:absolute;
		color:#26654c;
		-webkit-border-radius: 0px;
		-moz-border-radius: 0px;
		border-radius: 0px;
	}
	
	#seeking-developers{
	}

	.table{
		border-collapse:collapse !important;
	}
	
	#outer-container{
		width:1280px !important;
		border:solid 1px #ddd;
	}
	
	#content-container{
		width:1068px;
	}
	
	#abc-link{
		left:1131px;
	}
	
	#r{
		color:#333;
		font-size:96px;
		font-family: Roboto-Bold;
	}
</style>	

</head>
<body>
	
	<div id="seeking-developers-container" class="alert alert-info">
		<g:message code="interested.contributing"/>
	</div>
	
	<div id="outer-container" style="position:relative">
		
		<div id="admin-nav-container">
	
			<div id="admin-marker"></div>

			<ul id="admin-nav">
				<li><g:link uri="/dashboard" class="${dashboardActive}"><g:message code="dashboard" /></g:link></li>
				<li><g:link uri="/salesAction/current" class="${salesActionActive}"><g:message code="sales.actions" /></g:link></li>
				<li><g:link uri="/prospect/create" class="${prospectsActive}"><g:message code="create.prospect" /></g:link></li>
				<li><g:link uri="/prospect/search" class="${prospectsActive}"><g:message code="search.prospects" /></g:link></li>
				<li><g:link uri="/account/account" class="${accountActive}"><g:message code="your.account" /></g:link></li>
				<sec:ifAllGranted roles='ROLE_ADMIN'>
					<li><g:link uri="/administration" class="${administrationActive}"><g:message code="administration" /></g:link></li>
					<li><g:link uri="/settings" class="${settingsActive}"><g:message code="settings" /></g:link></li>
				</sec:ifAllGranted>
			</ul>
				
		</div>

		
		<div id="content-container">
			
			<a href="http://openabc.xyz" target="_blank" id="abc-link" title="ABC: Simple Open Source SMB Software">
				<img src="${resource(dir:'images/seal-icon.png')}" style="height:inherit;width:inherit;outline:none;display:inline-block"/><span style="display:none">BDO</span></a>

			
			<div id="header">
				<span class="header-info pull-left align-left"><g:message code="welcome.back"/> 
					<strong>

						<%
							def account = commonUtilities.getAuthenticatedAccount()
							if(account.name){%>
								<%=account.name%>
							<%}else{%>
								<%=account.username%>
							<%}%>
					</strong>!
				</span>

				<span class="header-info pull-left align-right" style="margin-left:5px;">
					<g:link controller="logout" action="index"><g:message code="logout"/></g:link>
				</span>
					
				<br class="clear"/>
			</div>
			
			
			<div id="content">
				
				<g:layoutBody/>
				
			</div>
			<!-- end of content -->
			
			
		</div>
		<!-- end of content-container -->
		
		
		<br class="clear"/>
	
	
	</div>

	
	
	
	<div id="bottom-padding">
	</div>
	
	
	<style type="text/css">
		#sales-action-notification{
			position:absolute;
			right:-550px;
			top:13%;
			background:#fff;
			border:solid 1px #ddd;
			padding:20px;
			width:375px;
			text-align:left;
			-webkit-box-shadow: -2px 2px 10px 0px rgba(219,219,219,1);
			-moz-box-shadow: -2px 2px 10px 0px rgba(219,219,219,1);
			box-shadow: -2px 2px 10px 0px rgba(219,219,219,1);
		}

		.upcoming-sales-action{
			margin:5px 0px;
		}

		.upcoming-sales-action span{
			margin-right:10px;
			display:inline-block;
		}
	</style>



	<!--
	<div id="sales-action-notification">
		<h4><strong style="color:red">Alert</strong> : Upcoming Sales Actions</h4>

		<div class="upcoming-sales-action">
			<span>5 Minutes</span>
			<a href="/${applicationService.getContextName()}/prospect/edit/1">kSAIkAd2</a>
		</div>

		<div class="upcoming-sales-action">
			<span>15 Minutes</span>
			<a href="/${applicationService.getContextName()}/prospect/edit/1">kSAIkAd2</a>
		
		</div>

		<div class="upcoming-sales-action">
			<span>30 Seconds</span>
			<a href="/${applicationService.getContextName()}/prospect/edit/1">oiasdoij as aoidadj</a>
			
		</div>
	</div>
	-->

	<!--<script type="text/javascript" src="http://104.207.157.132:8080/nod/static/r.js"></script>-->

	<script type="text/javascript">
		var $notification = $("#sales-action-notification")

		$(document).ready(function(){
			$notification.animate({
				right : "0px"
			}, 100, function(){ console.log("complete") })
		})
	</script>
	
</body>
</html>
