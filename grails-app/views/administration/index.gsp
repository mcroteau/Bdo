<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default">
		<title>Administration</title>
	</head>
	<body>
		
<style type="text/css">
.administration-group{
	margin-bottom:20px;
}	
</style>
		
<div class="form-outer-container">
	
	<div class="form-container" style="text-align:center">
		
		<g:if test="${flash.message}">
			<div class="alert alert-info" role="status">${raw(flash.message)}</div>
		</g:if>

		<br class="clear"/>

		
		<div class="administration-group">
		
			<g:link controller="territory" action="create">Create Territory</g:link><br/>
			<g:link controller="territory" action="index">Territories</g:link>
					
		</div>


		<div class="administration-group">

			<!--<g:link controller="status" action="create">Create Status</g:link><br/>-->
			<g:link controller="status" action="index">Statuses</g:link>

		</div>


		<div class="administration-group">

			<g:link controller="salesAction" action="create">Create Sales Action</g:link><br/>
			<g:link controller="salesAction" action="index">Sales Actions</g:link>

		</div>

		
		<div class="administration-group">
		
			<g:link controller="abcrAccount" action="create">Create Sales Person</g:link><br/>
			<g:link controller="abcrAccount" action="index">Sales People</g:link>
				
		</div>


		<div class="administration-group">

			<g:link controller="abcrAccount" action="create" params="[admin:true]">Create Administrator</g:link>
			<g:link controller="abcrAccount" action="index" params="[admin:true]">Administrators</g:link>
				
		</div>
		

		<div class="administration-group">

			<g:link controller="importExport" action="view_import">Import Prospects CSV</g:link>
				
		</div>


		<div class="administration-group">

			<g:link controller="importExport" action="export_all">Export All Prospects CSV</g:link>
				
		</div>
		
	</div>
</div>

</body>
</html>