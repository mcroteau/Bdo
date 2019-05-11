<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="edit_prospect"/>
		<title>Search Results</title>
	</head>
	<body>

	<style type="text/css">
	table, th, td{
		font-size:1.0em !important;
		//font-size:0.97em !important;
	}
	</style>
	
		<div id="list-account" class="content scaffold-list" role="main">
		
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${flash.message}</div>
			</g:if>
		
		
			<h2 class="pull-left">Search Results</h2>
			<br class="clear"/>
			
			<div style="float:right; text-align:right; width:755px;background:#f8f8f8;border:solid 1px #ddd; padding:3px;">

				<!--
				<g:form action="create">
					<g:submitButton class="btn btn-primary pull-right" name="create" value="New Prospect" style="margin-top:2px; margin-left:10px;margin-bottom:0px;"/>
				</g:form>
				-->
			
				<div class="pull-right" style=" ">
					<g:form action="perform_search" class="form-horizontal" method="get">
						<input type="text" name="query" id="searchbox" class="form-control" style="width:655px;" placeholder="search company, contact name, phone, email" value="${query}"/>
						<g:submitButton name="submit" value="Search" id="search" class="btn btn-info" style="margin-bottom:2px;"/>
					</g:form>
				</div>
				<br class="clear"/>
			</div>
		
			<br class="clear"/>
			


			
					
			
			<g:if test="${prospectInstanceList}">
			
			
				<table class="table table-condensed table-striped">
					<thead>
						<tr>
							<!-- TODO: make sortable, may require refactoring Account hasMany to include hasMany roles/authorities -->
							<!--Company
							Name	Address	City	Zip	County	Country and State	Contact	L.O.B.	Territory	User Dropdown 1	User Dropdown 2	ID/Status	Verified	Size-->
							<th></th>
							
							<th>Id</th>
							
							<th>Company</th>
							
							<th>Address</th>
							
							<th>City</th>
							
							<th>Zip</th>
							
							<th>Country & State</th>
							
							<th>Contact</th>
							
							<th>Territory</th>
							
							<th>Status</th>
							
							<th>Size</th>
							
							<th>Verified</th>
							
							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${prospectInstanceList}" status="i" var="prospectInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
			
							<td><input type="checkbox" name="prospect-chk-${prospectInstance.id}"
										class="prospect-checkbox"/></td>
						
							<td>
								<g:link action="edit" id="${prospectInstance.id}">${prospectInstance.id}</g:link>
							</td>
							
							<td>${prospectInstance.company}</td>
							
							<td>
								<address>
									${prospectInstance.address1}<br/>
									${prospectInstance.address2}
								</address>
							</td>
							
							<td>${prospectInstance.city}</td>
							
							<td>${prospectInstance.zip}</td>
							
							<td>${prospectInstance.country?.name}<br/>${prospectInstance.state?.name}</td>
							
							<td>
								${prospectInstance.contactName}
							
								<g:if test="${prospectInstance.contactTitle}">
									<span class="information secondary">(${prospectInstance.contactTitle})</span>
								</g:if>
								<br/>
							
								${prospectInstance.phone}
								<br/>
								<g:if test="${prospectInstance.email}">
									<a href="mailto:${prospectInstance.email}">${prospectInstance.email}</a>
								</g:if>
							</td>
						
							<td>${prospectInstance?.territory?.name}</td>
						
							<td>${prospectInstance?.status?.name}</td>
							
							<td>${prospectInstance?.prospectSize?.size}</td>
							
							<td>${prospectInstance?.verified}</td>
							
							<td>
								<g:link action="edit" params="[id: prospectInstance.id]" class="edit-${prospectInstance.id}" elementId="edit-${prospectInstance.id}">Edit</g:link>
							</td>
						
						</tr>
					</g:each>
					</tbody>
				</table>
				
				<div class="btn-group">
					<g:paginate total="${prospectInstanceTotal}" 
							max="20"
							params="${[query : query ]}"/>
				</div>
			</g:if>
			<g:else>
				<br/>
				<p style="color:#333;padding:0px 40px;">No Prospects found...</p>
			</g:else>
		</div>
	</body>
</html>
