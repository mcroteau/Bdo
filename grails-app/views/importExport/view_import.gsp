<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default">
		<title>Prospect Import</title>
	</head>
	<body>
	
		<div id="file-upload" class="content scaffold-create" role="main">
			
			<h1>Prospect Import</h1>
			
			<g:if test="${flash.message}">
				<div class="alert alert-info">${raw(flash.message)}</div>
			</g:if>
			
			<g:if test="${flash.error}">
				<div class="alert alert-danger">${raw(flash.error)}</div>
			</g:if>
			
			

			<div style="width:600px;">
			
				<g:uploadForm action="import_prospects" method="post" >
				
					<div class="form-group">
						<label>Select Import File</label>
						<input type="file" name="file" id="file" />	
					</div>
					
					<div class="form-group" style="margin-top:20px;">	
						<g:link controller="administration" action="index" name="cancel" class="btn btn-default">Cancel</g:link>
						<g:submitButton name="add" class="btn btn-primary" value="Import Prospects" />
					</div>
					
					<div style="color:#999; margin-bottom:30px;">
						<strong>Saved</strong> : ${count} <strong>Skipped</strong> : ${skipped} <strong>Errored</strong> : ${errored}
					</div>

					<p style="font-size:12px;" class="secondary">File should be comma separated value (csv) formatted with the following values</p>
					
					<p>
						company, address1, address2, city, state, country, zip, contact_name, contact_title, phone, phone_ext, cell_phone, fax, email, website, territory, status, verified, email_opt_in
					</p>
					
					<ul>
						<li>No Headings</li>
						<li>No $ signs or commas in values</li>
					</ul>
					
				</g:uploadForm>
				
			</div>
		</div>
	</body>
</html>
