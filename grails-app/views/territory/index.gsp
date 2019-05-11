<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default"/>
		<title>Territories</title>
	</head>
	<body>

		<div id="list-territory" class="content scaffold-list" role="main">
		

			<h2>Edit Territories</h2>
		
			<g:link action="create" class="pull-right">Create New Territory</g:link>
			
			<br class="clear"/>
			
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${raw(flash.message)}</div>
			</g:if>
			

			
			<g:if test="${territoryInstanceList}">
			
			
				<table class="table">
					<thead>
						<tr>
							
							<g:sortableColumn property="id" title="Id"/>
							
							<g:sortableColumn property="name" title="Name"/>
							
							<th style="width:172px;"></th>
						</tr>
					</thead>
					<tbody>
						<style type="text/css">
							.entity-maintenance .btn,
							.entity-maintenance input[type="submit"]{
								float:left;
							}
							</style>
							
					<g:each in="${territoryInstanceList}" status="i" var="territoryInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
			
							<td>
								<g:link action="edit" id="${territoryInstance.id}">${territoryInstance.id}</g:link>
							</td>
							
							<td>${territoryInstance.name}</td>
						
							<td class="entity-maintenance">

								<g:link action="edit" params="[id: territoryInstance.id]" class="edit-${territoryInstance.id} btn btn-default" elementId="edit-${territoryInstance.id}" style="margin-right:10px;">Edit</g:link>
								
								<g:form action="delete" method="post" id="${territoryInstance.id}">
									<g:actionSubmit value="Delete" class="btn btn-default"
				                onclick="return confirm('Are you sure you would like to delete this territory?')"/>
								</g:form>
								
								<br class="clear"/>
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>
				
				<div class="btn-group">
					<g:paginate total="${territoryInstanceTotal}"/>
				</div>
			</g:if>
			<g:else>
				<br/>
				<p style="color:#333;padding:0px 40px;">No Territories available...</p>
			</g:else>
		</div>
	</body>
</html>
