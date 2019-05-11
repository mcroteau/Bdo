<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Settings</title>

	<style type="text/css">
		.section{
			margin:10px 20px 30px 0px;
		}
	</style>
	
	<link rel="stylesheet" href="${resource(dir:'css', file:'admin.css')}" />
	
</head>
<body>

	<h2>Company Settings</h2>
	
	<g:if test="${flash.message}">
		<div class="alert alert-info" role="status">${flash.message}</div>
	</g:if>
	
	
	<ul class="nav nav-tabs" style="margin-bottom:30px;">
		<li class="active"><g:link uri="/settings/index" class="btn btn-default">Company Settings</g:link></li>
		<li class="inactive"><g:link uri="/settings/email_settings" class="btn btn-default">Email Settings</g:link></li>
	</ul>
	
	
	
	<form action="save" class="form-horizontal" method="post">
		
			
		<div class="form-row">
			<span class="form-label twohundred">Company Name
				<br/>
				<span class="information secondary">Important, required for page titles etc.</span>
			</span>
			<span class="input-container">
				<input type="text" class="form-control threehundred" name="companyName" value="${settings?.companyName}" style="width:370px;"/>
			</span>
			<br class="clear"/>
		</div>
		
			
		<div class="form-row">
			<span class="form-label twohundred">Phone
				<br/>
				<span class="information secondary">Used when creating shipping labels</span>
			</span>
			<span class="input-container">
				<input type="text" class="form-control" name="companyPhone" value="${settings?.companyPhone}" style="width:273px;"/>
			</span>
			<br class="clear"/>
		</div>
		
			
		<div class="form-row">
			<span class="form-label twohundred">Company Email
				<br/>
				<span class="information secondary"></span>
			</span>
			<span class="input-container">
				<input type="text" class="form-control" name="companyEmail" value="${settings?.companyEmail}" style="width:273px;"/>
			</span>
			<br class="clear"/>
		</div>

		
		
		<div class="buttons-container">
			<g:link controller="configuration" action="index" class="btn btn-default">Cancel</g:link>
			<g:submitButton value="Save Settings" name="submit" class="btn btn-primary"/>
		</div>
		
		
	</form>
	
	<g:link action="hilo_settings" class="pull-right">Manage Hilo Settings</g:link>
	
	
	<br class="clear"/>
</body>
</html>