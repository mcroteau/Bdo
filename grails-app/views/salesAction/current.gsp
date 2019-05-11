<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default">
		<title>Sales Actions</title>
	</head>
	<body>
		
		<g:if test="${flash.message}">
			<div class="alert alert-info" role="status">${raw(flash.message)}</div>
		</g:if>
		
		<g:if test="${all}">
			<h2>All Sales Actions</h2>
		</g:if>
		<g:else>
			<h2>My Sales Actions</h2>
		</g:else>
		
		<g:link controller="salesAction" action="current" params="['all':false]">View My Sales Actions</g:link>
		&nbsp;&nbsp;|&nbsp;&nbsp;
		<g:link controller="salesAction" action="current" params="['all':true]">View All</g:link>

		<br/>

		<%
			def pastDue = 0
			def today = new Date()
			prospectSalesActions?.each(){ 
				if(it.actionDate < today)pastDue++
			}
		%>
		<div style="border:dashed 1px #ddd;padding:10px;">
			<g:if test="${prospectSalesActions?.size() > 0}">
				<p class="information secondary"><strong>${prospectSalesActions?.size()}</strong> current Sales Actions.
					<strong>${pastDue}</strong> Past Due
				</p>
				<div style="overflow:scroll; height:400px;">
					<table class="table">
						<tr>
							<!--<th>Id</th>-->
							<th>Date</th>
							<th>Action</th>
							<th>Prospect</th>
							<th>Sales Person</th>
							<th class="asset-actions"></th>
						</tr>
						<g:each in="${prospectSalesActions}" var="salesAction">
							<tr>
								<!--<td>${salesAction.id}</td>-->
								<%
									String pastDueClass = ""
									def t = new Date()
									if(salesAction.actionDate < t)pastDueClass = "past-due"
								%>
								<td class="${pastDueClass}"><g:formatDate date="${salesAction.actionDate}" format="dd MMM yyyy hh:mm a"/></td>
								<td>${salesAction.salesAction.name}</td>
								<td>${salesAction.prospect.company}<br/>${salesAction.prospect.contactName}</td>
								<td>${salesAction.account.nameEmail}</td>
								<td class="asset-actions">
									<a href="/${applicationService.getContextName()}/prospect/edit/${salesAction.prospect.id}">
										<img src="${resource(dir:'images/icons/edit.gif')}" style="margin-left:7px;"/></a>
									<br class="clear"/>
								</td>
							</tr>
							<!--
							<tr>
								<td><strong>Note:</strong></td>
								<td colspan="4">${salesAction.note}</td>
							</tr>
							-->
						</g:each>
					</table>
				</div>
			</g:if>
			<g:else>
				<span>No Sales Actions yet...</span>
			</g:else>
		</div>
	</body>
</html>