<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default"/>
		<title><g:message code="accounts"/></title>
	</head>
	<body>

		<div id="list-account" class="content scaffold-list" role="main">
		

			<g:if test="${admin}">
				<h2 class="pull-left">Admin Accounts</h2>
			</g:if>
			<g:else>
				<h2 class="pull-left">Salesman Accounts</h2>
			</g:else>
			

			<g:if test="${admin}">
				<div style="float:right; width:470px; text-align:right ">
					<g:form action="index" class="form-horizontal">
						<input type="hidden" name="admin" value="true"/>
						<input type="text" name="query" id="searchbox" class="form-control" style="width:250px;" placeholder="search name, username or email" value="${query}"/>
						<g:submitButton name="submit" value="Search" id="search" class="btn btn-info"/>
					</g:form>
				</div>
			</g:if>
			<g:else>
				<div style="float:right; width:470px; text-align:right ">
					<g:form action="index" class="form-horizontal">
						<input type="hidden" name="admin" value="false"/>
						<input type="text" name="query" id="searchbox" class="form-control" style="width:250px;" placeholder="search name, username or email" value="${query}"/>
						<g:submitButton name="submit" value="Search" id="search" class="btn btn-info"/>
					</g:form>
				</div>
			</g:else>
		
			<br class="clear"/>
			
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${flash.message}</div>
			</g:if>
			

			<g:if test="${admin}">
				<g:form action="create">
					<input type="hidden" name="admin" value="true"/>
					<g:submitButton class="btn btn-primary pull-right" name="create" value="Create New Admin User"/>
				</g:form>
				<p class="information secondary">Admin Accounts have access to all administrative functions.</p>
			</g:if>
			<g:else>
				<g:form action="create">
					<input type="hidden" name="admin" value="false"/>
					<g:submitButton class="btn btn-primary pull-right" name="create" value="New Salesman"/>
				</g:form>
				<p class="information secondary">Salesman accounts have access to everything prospects</p>
			</g:else>
			
						
			<ul class="nav nav-tabs">

				<g:if test="${admin}">
			  		<li class="inactive"><g:link uri="/abcrAccount?admin=false" class="btn btn-default">Salesmen</g:link></li>
			  	  	<li class="active"><g:link uri="/abcrAccount?admin=true" class="btn btn-default">Admin Users</g:link></li>
				</g:if>
				<g:else>
			  		<li class="active"><g:link uri="/abcrAccount?admin=false" class="btn btn-default">Salesmen</g:link></li>
			  	  	<li class="inactive"><g:link uri="/abcrAccount?admin=true" class="btn btn-default">Admin Users</g:link></li>
				</g:else>
			</ul>
			
			
			<g:if test="${accountInstanceList}">
			
			
				<table class="table">
					<thead>
						<tr>
							<!-- TODO: make sortable, may require refactoring Account hasMany to include hasMany roles/authorities -->
							<g:sortableColumn property="id" title="Id" params="${[admin:admin]}"/>
							
							<g:sortableColumn property="name" title="Name" params="${[admin:admin]}"/>
							
							<g:sortableColumn property="email" title="Username" params="${[admin:admin]}"/>
							
							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${accountInstanceList}" status="i" var="accountInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
			
							<td>
								<g:link action="edit" id="${accountInstance.id}">${accountInstance.id}</g:link>
							</td>
							
							<td>${accountInstance.name}</td>
						
							<td>${accountInstance.username}</td>

							<td>
								<g:link action="edit" params="[id: accountInstance.id]" class="edit-${accountInstance.id}" elementId="edit-${accountInstance.id}">Edit</g:link>
							</td>
						
						</tr>
					</g:each>
					</tbody>
				</table>
				
				<div class="btn-group">
					<g:paginate total="${accountInstanceTotal}" 
						 	params="${[query : params.query ]}"/>
				</div>
			</g:if>
			<g:else>
				<br/>
				<p style="color:#333;padding:0px 40px;">No Accounts found...</p>
			</g:else>
		</div>
	</body>
</html>
