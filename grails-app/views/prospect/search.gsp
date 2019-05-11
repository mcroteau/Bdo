<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default">
		<title>Search Prospects</title>
	</head>
	<body>
		

		
<div class="form-outer-container">
	
	<div class="form-container" style="text-align:center">
		
		<g:if test="${flash.message}">
			<div class="alert alert-info" role="status">${raw(flash.message)}</div>
		</g:if>
		
		

		<br class="clear"/>
			
		<style type="text/css">
			#query-container{
				width:540px;
				padding:20px;
				margin:20px auto;
				text-align:center;
				background:#f1fbff;
				background:#fefff6;
				background:#f8f8f8;
				border:solid 1px #ddd;
			}
			textarea.query{
				height:100px;
				width:330px;
				margin:5px auto 20px auto;
			}
		</style>
		
		<g:form action="results" class="form-horizontal" role="form" method="get">

			<div id="query-container">
		
				<h2>Search Prospects</h2>
				
				<p class="information secondary">Performs an <strong>"AND"</strong> search on spaces and new lines</p>
				
				<textarea name="query" class="form-control query" placeholder="Search on any attribute of a Prospect, including company, contact information, territory, size etc..."></textarea>	
		
			
			
				<div class="form-row">
				  	<label for="country" class="form-label half">Territory</label>
					<span class="input-container">
						<g:select name="territory.id"
								from="${io.seal.Territory.list()}"
								value="${prospectInstance?.territory?.id}"
								optionKey="id" 
								optionValue="name"
								class="form-control"
								id="territorySelect"
								style="width:275px;"
            	                noSelection="${['': '-']}"/>
					</span>
					<br class="clear"/>
				</div>
            	
				
				
				
				<div class="form-row">
				  	<label for="country" class="form-label half">Status</label>
					<span class="input-container">
						<g:select name="status.id"
								from="${io.seal.Status.list()}"
								value="${prospectInstance?.status?.id}"
								optionKey="id" 
								optionValue="name"
								class="form-control"
								id="statusSelect"
								style="width:225px"
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
            	
				<input type="hidden" name="search" value="true"/>
            	
				
				<div class="buttons-container" style="margin:20px auto;">	
					<g:submitButton name="create" class="btn btn-primary" value="Search Prospects" />		
					<br class="clear"/>
				</div>

			</div>
			



			<div class="pull-right" style="width:523px;margin-top:130px;">
				<g:link controller="prospect" action="imports" class="pull-right" style="margin-top:0px;">View Backgroung Imports</g:link>
				<br class="clear"/>
				<p class="information secondary" style="width:543px; text-align:right; padding-right:20px;">R works closely with Greenfield, an open source eCommerce platform. You can configure R to periodically import new accounts from Greenfield into R.</p>
				
			</div>
		
			<br class="clear"/>
			
		</g:form>
	</div>
</div>

</body>
</html>