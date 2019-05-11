<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default"/>
		<title>Statuses</title>
	</head>
	<body>

		<div id="list-status" class="content scaffold-list" role="main">
		

			<h2>Edit Statuses</h2>
		
			<!--<g:link action="create" class="pull-right">Create New Status</g:link>-->
			
			<br class="clear"/>
			
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${raw(flash.message)}</div>
			</g:if>
			

			
			<g:if test="${statusInstanceList}">
			
			
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
							
					<g:each in="${statusInstanceList}" status="i" var="statusInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
			
							<td>
								<g:link action="edit" id="${statusInstance.id}">${statusInstance.id}</g:link>
							</td>
							
							<td>${statusInstance.name}</td>
						
							<td class="entity-maintenance">

								<g:link action="edit" params="[id: statusInstance.id]" class="edit-${statusInstance.id} btn btn-default" elementId="edit-${statusInstance.id}" style="margin-right:10px;">Edit</g:link>
								
								<!--
								<g:form action="delete" method="post" id="${statusInstance.id}">
									<g:actionSubmit value="Delete" class="btn btn-default"
				                onclick="return confirm('Are you sure you would like to delete this status?')"/>
								</g:form>
								-->

								<br class="clear"/>
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>
				
				<div class="btn-group">
					<g:paginate total="${statusInstanceTotal}"/>
				</div>
			</g:if>
			<g:else>
				<br/>
				<p style="color:#333;padding:0px 40px;">No Territories available...</p>
			</g:else>
		</div>
	</body>
</html>
