<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<%@page import="io.seal.State"%>
<%@page import="io.seal.common.ApplicationConstants"%>

<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="edit_prospect"/>
	<title>Prospect Details</title>	
</head>
	
<body>
	
<style type="text/css">	
	#form-outer-container{
		float:left;
		width:490px !important;
		border-right:solid 1px #ddd;
	}
	#prospect-actions{
		text-align:center;
		padding:10px;
		margin:0px auto 11px auto;
		border-top:dashed 1px #ddd;
		border-bottom:dashed 1px #ddd;
		width:100%;
	}
	.prospect-action.action{
		display:inline-block;
		margin:0px 20px;
	}

	#prospect-details{
		padding-left:40px;
		padding-top:20px;
		float:right;
		width:575px;
	}
	
	.prospect-detail{
		color:#777;
		background:#fafafa;
		background:#fff;
		border:solid 0px #ddd;
		margin:0px auto 20px auto;
		padding: 5px 5px 0px 5px;
	}
	
	th.asset-actions{
		width:57px !important;
		height:20px;
		position:relative;
		text-align:center;
	}
	.asset-actions img:hover{
		cursor:pointer;
		cursor:hand;
	}
	.asset-actions img{
		height:16px;
		width:16px;
		float:left;
	}
	.past-due{
		color:red;
	}
	.prospect-detail h4{
		float:left;
	}
	.asset-link{
		margin-top:0px;
		display:inline-block;
	}
	input[type="button"].nostyle,
	input[type="button"].nostyle:hover,
	input[type="button"].nostyle:active,
	input[type="submit"].nostyle,
	input[type="submit"].nostyle:hover,
	input[type="submit"].nostyle:active{
		border:none !important; 
		background:none !important; 
		color:blue !important;
	}
	
	#sales-effort-container{
		padding: 17px 20px;
		background:#f8f8f8;
		border:solid 1px #ddd;
	}
</style>
		
<g:if test="${flash.message}">
	<div class="alert alert-info" role="status">${raw(flash.message)}</div>
</g:if>


<%

def index = false
def next = false
def back = false
def current = false
if(session["prospects"]){
	index = session["prospects"].findIndexOf { it == prospectInstance.id; }
	next = index + 1
	back = index - 1
	current = index + 1
	if(!session["prospects"][next])next = 0
}

%>

	
	<g:if test="${index != false}">
		<p class="pull-left information secondary">
			<strong>${current}</strong> out of <strong>${session["prospects"]?.size()}</strong> Prospects in result set</p>
	</g:if>
	
	
	<g:if test="${session["prospects"]?.size() > 0}">
		<g:link action="results" class="nostyle pull-right" style="display:inline-block;margin-left:10px;">Back to Results</g:link>
	</g:if>

	<g:link action="search" class="nostyle pull-right">New Search</g:link>
	<br class="clear"/>
		
		
		
		
	<div id="prospect-actions">
		<%if(back != false){%>
			<g:link action="edit" id="${session["prospects"][back]}" class="pull-left">&larr;&nbsp;Previous</g:link>
		<%}%>


		<div class="prospect-action action">
			<span><a href="javascript:" class="prospect-action" window-height="740" window-width="700" 	
					action="/${applicationService.getContextName()}/prospectSalesAction/create/${prospectInstance.id}">Add Sales Action</a></span>
		</div>
	
	
		<div class="prospect-action action">
			<span><a href="javascript:" class="prospect-action" window-height="540" window-width="700" 	
					action="/${applicationService.getContextName()}/prospectNote/create/${prospectInstance.id}">Add Note</a></span>
		</div>
		
		
		<div class="prospect-action action">
			<span><a href="javascript:" class="prospect-action" window-height="740" window-width="700" 	
					action="/${applicationService.getContextName()}/prospectContact/create/${prospectInstance.id}">Add Contact</a></span>
		</div>
		
		
		<div class="prospect-action action">
			<span><a href="javascript:" class="prospect-action" window-height="740" window-width="700" 	
					action="/${applicationService.getContextName()}/prospectDocument/create/${prospectInstance.id}">Add Document</a></span>
		</div>
		
		
		<div class="prospect-action action">
			<span><a href="javascript:" class="prospect-action" window-height="540" window-width="700" 	
					action="/${applicationService.getContextName()}/prospectWebsite/create/${prospectInstance.id}">Add Website</a></span>
		</div>

		
		<div class="prospect-action action">
			<span><a href="javascript:" class="prospect-action" window-height="540" window-width="700" 	
					action="/${applicationService.getContextName()}/prospectSale/create/${prospectInstance.id}">Add Sale</a></span>
		</div>


		
		<%if(next != false){%>
			<g:link action="edit" id="${session["prospects"][next]}" class="pull-right">Next&nbsp;&rarr;</g:link>
		<%}%>
		
		<br class="clear"/>
	</div>
	
	
	<style type="text/css">
		#prospect-navigation-details{
			position:relative;
			margin-top:13px;
		}
		
		#prospect-sales-values{
			position:absolute;
			bottom:4px;
			right:0px;
			width:671px;
			text-align:right;
			border:solid 0px #ddd;
		}
		
		.prospect-sales-value-container{
			float:right;
			margin-left:52px;
			display:inline-block;
		}
		
		.prospect-sales-value-container span{
			display:block;
		}
		.prospect-sales-value-container strong{
			font-weight:normal !important;
		}
		.prospect-sales-value{
			font-size:24px;
			font-weight:bold;
			line-height:0.9;
			}
	</style>
		
		
	<div id="prospect-navigation-details">
		<ul class="nav nav-tabs" style="margin-bottom:10px;">
			<li class="active"><g:link uri="/prospect/edit/${prospectInstance.id}" class="btn btn-default">
					Prospect Details 
					<g:if test="${salesEffortInstance?.recording}">
						<span class="label label-primary">Recording</label>
					</g:if>
					<g:else>
						<span class="label label-default">Not Recording</label>
					</g:else>
				</g:link>
			</li>
			<li class="inactive"><g:link uri="/prospect/history/${prospectInstance.id}" class="btn btn-default">Prospect History</g:link></li>
		</ul>
		
		
		<div id="prospect-sales-values">
			<div class="prospect-sales-value-container">
				<span class="prospect-sales-value">
					${completedSalesActionsCount}
				</span>
				<span class="prospect-sales-label information secondary">
					<%if(completedSalesActionsCount == 1){%>
						Completed Sales Action
					<%}else{%>
						Completed Sales Actions
					<%}%>
				</span>
			</div>			
			<div class="prospect-sales-value-container">
				<span class="prospect-sales-value">
					${upcomingSalesActions?.size()}
				</span>
				<span class="prospect-sales-label information secondary">
					<%if(upcomingSalesActions?.size() == 1){%>
						Upcoming Sales Action
					<%}else{%>
						Upcoming Sales Actions
					<%}%>
				</span>
			</div>
			<div class="prospect-sales-value-container">
				<span class="prospect-sales-value">
					${prospectInstance?.prospectSales?.size()}
				</span>
				<span class="prospect-sales-label information secondary">
					<%if(prospectInstance?.prospectSales?.size() == 1){%>
						Sale
					<%}else{%>
						Sales
					<%}%>
				</span>
			</div>
			<div class="prospect-sales-value-container">
				<span class="prospect-sales-value">
					${completedSalesEfforts}
				</span>
				<span class="prospect-sales-label information secondary">
					<%if(completedSalesEfforts == 1){%>
						Completed Effort
					<%}else{%>
						Completed Efforts
					<%}%>
				</span>
			</div>		
			<br class="clear"/>
		</div>
	</div>	
	<!-- End of Navigation -->
	
	
	
	
	
		
	<div id="form-outer-container">
		
		<div class="form-container" style="margin-top:0px;">
	
	
			<br class="clear"/>
			
			
			<div class="messages">
			
				<g:hasErrors bean="${prospectInstance}">
					<div class="alert alert-danger">
						<ul>
							<g:eachError bean="${prospectInstance}" var="error">
								<li><g:message error="${error}"/></li>
							</g:eachError>
						</ul>
					</div>
				</g:hasErrors>
				
			</div>
			
		
			
			<g:form action="update" class="form-horizontal" role="form" method="post">
	
			
				<input type="hidden" name="id" value="${prospectInstance?.id}"/>

				<div class="form-row">
					<span class="form-label half"></span>
					<span class="input-container">
						<h3 style="margin:0px auto 10px auto; padding:0px; line-height:1.0; text-align:center">
							<%if(prospectInstance.company){%>
								${prospectInstance.company}
							<%}else{%>
								${prospectInstance.contactName}
							<%}%>
						</h3>
					</span>
					<br class="clear"/>
				</div>

				<div class="form-row">
					<span class="form-label half">Company
					</span>
					
					<span class="input-container">
						<g:textField type="text" name="company" value="${prospectInstance?.company}" class="form-control threehundred"/>
						<p class="information secondary">Contact Name or Company must be complete</p>
					</span>
					<br class="clear"/>
				</div>
				
				<div class="form-row">
					<span class="form-label half">Address 1</span>
					<span class="input-container">
						<g:textField class="threehundred form-control"  name="address1" value="${prospectInstance?.address1}"/>
					</span>
					<br class="clear"/>
				</div>
				
				
				
				<div class="form-row ">
					<span class="form-label half">Address 2</span>
					<span class="input-container">
						<g:textField class="threehundred form-control"  name="address2" value="${prospectInstance?.address2}"/>
					</span>
					<br class="clear"/>
				</div>
	
	
	
				<div class="form-row">
					<span class="form-label half">City</span>
					<span class="input-container">
						<g:textField class="twotwentyfive form-control"  name="city" value="${prospectInstance?.city}"/>
					</span>
					<br class="clear"/>
				</div>
				
				
				
				<div class="form-row">
				  	<label for="country" class="form-label half">Country</label>
					<span class="input-container">
						<g:select name="country.id"
								from="${countries}"
								value="${prospectInstance?.country?.id}"
								optionKey="id" 
								optionValue="name"
								class="form-control twohundred"
								id="countrySelect"/>
					</span>
					<br class="clear"/>
				</div>
				
				
				
				<div class="form-row">
					<span class="form-label half">State</span>
					<span class="input-container">	
						<g:select name="state.id"
								from="${State.list()}"
								value="${prospectInstance?.state?.id}"
								optionKey="id" 
								optionValue="name" 
								class="form-control"
								id="stateSelect"/>
					</span>
					<br class="clear"/>	
				</div>
				
				
				
	
				<div class="form-row">
					<span class="form-label half">Zip</span>
					<span class="input-container">
						<g:textField class="onefifty form-control"  name="zip" value="${prospectInstance?.zip}"/>
					</span>
					<br class="clear"/>
				</div>
				
		
	
	
				<div class="form-row">
					<span class="form-label half">Contact Name
						<p class="information secondary">Contact Name or Company must be complete</p>
					</span>
					<span class="input-container">
						<g:textField class="form-control twohundred"  name="contactName" value="${prospectInstance?.contactName}"/>
					</span>
					<br class="clear"/>
				</div>
	
	
	
				<div class="form-row">
					<span class="form-label half">Contact Title</span>
					<span class="input-container">
						<g:textField class="form-control twohundred"  name="contactTitle" value="${prospectInstance?.contactTitle}"/>
					</span>
					<br class="clear"/>
				</div>
	
	
	
	
				<div class="form-row">
					<span class="form-label half">Phone</span>
					<span class="input-container">
						<g:textField class="twofifty form-control"  name="phone" value="${prospectInstance?.phone}"/>
					</span>
					<br class="clear"/>
				</div>
				
	
				<div class="form-row">
					<span class="form-label half">Phone Extension</span>
					<span class="input-container">
						<g:textField class="onefifty form-control"  name="phoneExtension" value="${prospectInstance?.phoneExtension}"/>
					</span>
					<br class="clear"/>
				</div>
				
	
				<div class="form-row">
					<span class="form-label half">Cell Phone</span>
					<span class="input-container">
						<g:textField class="twofifty form-control"  name="cellPhone" value="${prospectInstance?.cellPhone}"/>
					</span>
					<br class="clear"/>
				</div>
				
	
				<div class="form-row">
					<span class="form-label half">Fax</span>
					<span class="input-container">
						<g:textField class="twofifty form-control"  name="fax" value="${prospectInstance?.fax}"/>
					</span>
					<br class="clear"/>
				</div>
				
	
				<div class="form-row">
					<span class="form-label half">Email</span>
					<span class="input-container">
						<g:textField class="threehundred form-control"  name="email" value="${prospectInstance?.email}"/>
					</span>
					<br class="clear"/>
				</div>
				
	
				<div class="form-row">
					<span class="form-label half">Website</span>
					<span class="input-container">
						<g:textField class="threehundred form-control"  name="website" value="${prospectInstance?.website}"/>
					</span>
					<br class="clear"/>
				</div>
				
				
				
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
	                            noSelection="${['': 'Select One...']}"/>
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
	                            noSelection="${['': 'Select One...']}"/>
					</span>
					<br class="clear"/>
				</div>
	
				
				<div class="form-row">
				  	<label for="country" class="form-label half">Size</label>
					<span class="input-container">
						<g:select name="prospectSize.id"
								from="${io.seal.ProspectSize.list()}"
								value="${prospectInstance?.prospectSize?.id}"
								optionKey="id" 
								optionValue="size"
								class="form-control"
								id="sizeSelect"
								style="width:225px"
	                            noSelection="${['': 'Select One...']}"/>
					</span>
					<br class="clear"/>
				</div>
	
	
	
				
				<%
				String unverifiedSelected = prospectInstance?.verified ? "" : "selected"
				String verifiedSelected = prospectInstance?.verified ? "selected" : ""
				%>
				
				<div class="form-row">
				  	<label for="country" class="form-label half">Verified</label>
					<span class="input-container">
						<select name="verified" class="form-control">
							<option <%=unverifiedSelected%> value="false">Needs Verification</option>
							<option <%=verifiedSelected%> value="true">Verified</option>
						</select>	
					</span>
					<br class="clear"/>
				</div>
	

				<div class="form-row">
					<span class="form-label half hint">Opt In Email</span>
					<span class="input-container">
						<g:checkBox name="emailOptIn" value="${prospectInstance.emailOptIn}" />
					</span>
					<br class="clear"/>
				</div>
				
				
				<div class="buttons-container">	
					<g:submitButton name="update" class="btn btn-primary" value="Update Prospect" />		
					<br class="clear"/>
				</div>
				
			</g:form>
	
			
		</div>
	
	</div>	
	
	
	
	
	
	
	<div id="prospect-details">
		
		
		<div class="sales-effort-record-container">
			<span class="information secondary" id="sales-effort-top-label" style="display:none"></span>
		</div>
		
		<!-- Start of Sales Actions -->
		
		<div class="prospect-detail">
			<h4>Upcoming</h4>
			<a href="#sales-efforts" title="See Sales Effort" class="asset-link pull-right">See Sales Effort</a>
			<span class="asset-link information secondary pull-right">&nbsp;|&nbsp;</span>
			<a href="javascript:" title="Add Sales Action"
					class="asset-link prospect-action pull-right" 
					window-height="740" window-width="700" 
					action="/${applicationService.getContextName()}/prospectSalesAction/create/${prospectInstance.id}">Add Sales Action</a>
			<br class="clear"/>
			<g:if test="${upcomingSalesActions?.size() > 0}">
				<table class="table table-condensed table-bordered">
					<tr style="background:#e7e7e7">
						<th>Id</th>
						<th>Date</th>
						<th>Action</th>
						<th class="asset-actions"></th>
					</tr>
					<g:each in="${upcomingSalesActions}" var="salesAction">
					   <tr style="background:#efefef">
						   	<td>${salesAction.id}</td>
						   	<%
						   		String pastDueClass = ""
						   		def today = new Date()
						   		if(salesAction.actionDate < today)pastDueClass = "past-due"
						   	%>
						   	<td class="${pastDueClass}"><g:formatDate date="${salesAction.actionDate}" format="dd MMM yyyy hh:mm a"/></td>
						   	<td>${salesAction.salesAction.name}</td>
						   	<td class="asset-actions">
						   		<img src="${resource(dir:'images/icons/edit.gif')}"  
						   			class="prospect-action" window-height="740" window-width="700"
									alt="Complete Sales Action"
									title="Complete Sales Action"
									action="/${applicationService.getContextName()}/prospectSalesAction/edit/${salesAction.id}" 
						   			/>
						   		<form 	
						   		action="/${applicationService.getContextName()}/prospectSalesAction/delete/${salesAction.id}" 
						   		method="post" id="form-${salesAction.id}">
						   			<input type="hidden" name="prospectId" value="${prospectInstance.id}"/>
						   			<img src="${resource(dir:'images/icons/delete.gif')}"  
						   				class="delete-attribute" asset="Sales Action" 
						   				style="margin-left:7px;"
										alt="Delete Sales Action"
										title="Delete Sales Action"
						   				form="form-${salesAction.id}"/>
						   		</form>								
						   		<br class="clear"/>
						   	</td>
					   </tr>
					   <tr>
							<td><strong>Note:</strong></td>
							<td colspan="3">${salesAction.note}

								<g:if test="${salesAction?.account}">
									<span style="display:block">${salesAction.account.name}<br/>
										<a href="mailto:${salesAction.account.username}">${salesAction.account.username}</a>
									</span>
								</g:if>
							</td>
					   </tr>
					</g:each>
				</table>
			</g:if>
			<g:else>
				<span>No Upcoming Sales Actions...</span>
			</g:else>
		</div>
		
		<!-- End of Sales Actions -->
		
		
		
		
		
		<!-- Start of Sales Effort, only displaying current sales effort -->
		<div id="sales-effort-container" class="prospect-detail" style="background:#fff; background:#f8f8f8; border:solid 1px #ddd;">
			<h4 id="sales-efforts">Sales Effort</h4>
			
			<g:if test="${salesEffortInstance && salesEffortInstance?.recording}">
				<span class="label label-primary pull-left" style="font-weight:normal !important; margin-top:0px;margin-left:10px;">Recording</span>
			</g:if>
			
			
			<g:if test="${salesEffortInstance && !salesEffortInstance?.recording}">
			
				<span class="label label-primary pull-left" style="font-weight:normal !important;margin-top:10px;margin-left:10px;">Completed</span>
				
				<%if(salesEffortInstance.completeStatus.name == "Sale"){%>
				
					<span class="label label-success pull-left" style="font-weight:normal !important;margin-top:10px;margin-left:10px;">${salesEffortInstance.completeStatus.name}</span>
				
				<%}else{%>
					
					<span class="label label-primary pull-left" style="font-weight:normal !important;margin-top:10px;margin-left:10px;">${salesEffortInstance.completeStatus.name}</span>
				
				<%}%>
				
			</g:if>
			
			
			<g:if test="${!salesEffortInstance}">
				<span class="label label-default pull-left" style="font-weight:normal !important;margin-top:0px;margin-left:10px;">Not Recording</span>
			</g:if>
		
			<g:if test="${prospectInstance?.currentSalesEffort?.recording}">
				<a href="javascript:" title="Complete Sales Effort Maintenance" 
					class="prospect-action pull-right"
					window-height="540" window-width="700" 
					style="margin-top:10px;"
					action="/${applicationService.getContextName()}/salesEffort/confirm_complete/${salesEffortInstance?.id}">Effort Complete</a>
			</g:if>	
			<g:else>
				<a href="javascript:" title="Begin Sales Effort" 
					class="asset-link prospect-action pull-right"
					window-height="540" window-width="700" 
					action="/${applicationService.getContextName()}/salesEffort/create/${prospectInstance.id}">Begin New Sales Effort</a>
			</g:else>

			<br class="clear"/>
			
			
			<g:if test="${prospectInstance.currentSalesEffort}">
				<g:if test="${prospectInstance.currentSalesEffort?.salesActions?.size() > 0}">
					<p class="secondary">Sales Person: <a href="mailto:${prospectInstance.currentSalesEffort.salesman.username}" title="Send email">${prospectInstance.currentSalesEffort.salesman.nameEmail}</a></p>
					<p class="information secondary">Completed Sales Actions</p>
					<table class="table table-condensed" style="background:#fff !important;">
						<tr>
							<th>Id</th>
							<th>Date</th>
							<th>Action</th>
						</tr>
						<g:each in="${prospectInstance.currentSalesEffort?.salesActions}" var="salesAction">
							<tr>
								<td>${salesAction.id}</td>
								<td><g:formatDate date="${salesAction.actionDate}" format="dd MMM yyyy hh:mm a"/></td>
								<td>${salesAction.salesAction.name}</td>
							</tr>
						</g:each>
					</table>

			

					<g:if test="${prospectInstance?.currentSalesEffort?.recording}">
						<a href="javascript:" title="Complete Sales Effort Maintenance" 
							class="asset-link prospect-action pull-right"
							window-height="540" window-width="700" 
							action="/${applicationService.getContextName()}/salesEffort/confirm_complete/${salesEffortInstance?.id}">Complete Effort</a>
					</g:if>	
					<g:else>
						<a href="javascript:" title="Begin Sales Effort" 
							class="asset-link prospect-action pull-right"
							window-height="540" window-width="700" 
							action="/${applicationService.getContextName()}/salesEffort/create/${prospectInstance.id}">Begin New Sales Effort</a>
					</g:else>
					<span class="secondary asset-link pull-right">&nbsp;|&nbsp;</span>
					<a href="javascript:" title="Add Sales Action"
							class="asset-link prospect-action pull-right" 
							window-height="740" window-width="700" 
							action="/${applicationService.getContextName()}/prospectSalesAction/create/${prospectInstance.id}">Add Sales Action</a>
					<br class="clear"/>
				</g:if>
				<g:else>
				
				<g:if test="${salesEffortInstance && salesEffortInstance?.recording}">
					<p>Your efforts are currently being measured. Start completing Sales Actions to continue 
						<a href="mailto:${prospectInstance.currentSalesEffort.salesman.username}">
							${salesEffortInstance.salesman.nameEmail}.</a></p>
				</g:if>
				<g:if test="${salesEffortInstance && !salesEffortInstance?.recording}">
					<p><a href="mailto:${prospectInstance.currentSalesEffort.salesman.username}">
							${salesEffortInstance.salesman.nameEmail}</a>, your efforts were recorded. Good job. Make another go?	<a href="javascript:" title="Begin Sales Effort" 
							class="prospect-action"
							window-height="540" window-width="700" 
							action="/${applicationService.getContextName()}/salesEffort/create/${prospectInstance.id}">Begin New Effort?</a>
						</p>
				</g:if>
				</g:else>
			</g:if>
			<g:else>
				<p>No Sales Effort in progress currently for this prospect. Click 
						<a href="javascript:" title="Begin Sales Effort" 
							class="prospect-action"
							window-height="540" window-width="700" 
							action="/${applicationService.getContextName()}/salesEffort/create/${prospectInstance.id}">Begin New Sales Effort</a> to start recording your efforts.</p>
			</g:else>
			<p class="information secondary" style="margin-top:15px;">Sales at times can be a numbers game, understanding your numbers will make you a better, happier sales person on a happier more competitive sales team.</p>
		</div>
		<!-- End of Sales Effort-->
		
		
		
		
		
		
		
		<!-- Start of Additional Contacts -->
		<div class="prospect-detail">
			<g:if test="${prospectInstance?.prospectContacts?.size() > 0}">
				<h4>Additional Contacts</h4>
				<a href="javascript:" 
					class="asset-link prospect-action pull-right" 
					window-height="740" window-width="700" 
					action="/${applicationService.getContextName()}/prospectContact/create/${prospectInstance.id}">Add Contact</a>
				<br class="clear"/>
				
				<table class="table table-condensed table-bordered">
					<tr>
						<th>Contact Name &amp; Title</th>
						<th>Contact Details</th>
						<th class="asset-actions"></th>
					</tr>
					<g:each in="${prospectInstance?.prospectContacts}" var="prospectContact">
						<tr>
							<td>
								${prospectContact.contactName}<br/>
								${prospectContact.contactTitle}
							</td>
							<td>
								<%if(prospectContact.phone){%>
									${prospectContact.phone}
								<%}%>
								<%if(prospectContact.phoneExtension){%>
									&nbsp;${prospectContact.phoneExtension}
								<%}%>
								<br/>
								<%if(prospectContact.cellPhone){%>
									${prospectContact.cellPhone}<br/>
								<%}%>
								<%if(prospectContact.fax){%>
									${prospectContact.fax}<br/>
								<%}%>
								<%if(prospectContact.email){%>
									<a href="mailto:${prospectContact.email}">${prospectContact.email}</a>
								<%}%>
							</td>
							<td class="asset-actions" >
						   		<img src="${resource(dir:'images/icons/edit.gif')}"  
						   			class="prospect-action" window-height="740" window-width="700"
									alt="Edit Contact"
									title="Edit Contact"
									action="/${applicationService.getContextName()}/prospectContact/edit/${prospectContact.id}" 
						   			/>
						   	<form 
								action="/${applicationService.getContextName()}/prospectContact/delete/${prospectContact.id}" 
						   		method="post" id="form-contact-${prospectContact.id}">
						   			<input type="hidden" name="prospectId" value="${prospectInstance.id}"/>
						   			<img src="${resource(dir:'images/icons/delete.gif')}"  
						   				class="delete-attribute" asset="Contact" 
						   				style="margin-left:7px;"
										alt="Delete Sales Action"
										title="Delete Sales Action"
						   				form="form-contact-${prospectContact.id}"/>
						   		</form>								
						   		<br class="clear"/>
							</td>
						</tr>
					</g:each>
				</table>
			</g:if>
			<g:else>
			</g:else>
		
		</div>
		<!-- End of Additional Contacts -->
		
		
		
		
		
		<!-- Start of Notes -->
		<div class="prospect-detail">
			<g:if test="${prospectInstance?.prospectNotes?.size() > 0}">
				<h4>Notes</h4>
				<a href="javascript:" 
					class="asset-link prospect-action pull-right" 
					window-height="540" window-width="700" 
					action="/${applicationService.getContextName()}/prospectNote/create/${prospectInstance.id}">Add Note</a>
				<br class="clear"/>
				<table class="table table-condensed table-bordered">
					<tr>
						<th>Id</th>
						<th>Note</th>
						<th class="asset-actions"></th>
					</tr>
					<g:each in="${prospectInstance?.prospectNotes}" var="prospectNote">
						<tr>
							<td rowspan="2">${prospectNote.id}</td>
							<td>
								<textarea disabled="disabled" style="height:73px; width:100%;" class="form-control">${prospectNote.note}</textarea>
							</td>
							<td class="asset-actions" rowspan="2">
								<img src="${resource(dir:'images/icons/edit.gif')}"  
									class="prospect-action" window-height="540" window-width="700" 
								action="/${applicationService.getContextName()}/prospectNote/edit/${prospectNote.id}" 
									/>
								<form 	
								action="/${applicationService.getContextName()}/prospectNote/delete/${prospectNote.id}" 
								method="post" id="form-note-${prospectNote.id}">
									<input type="hidden" name="prospectId" value="${prospectInstance.id}"/>
									<img src="${resource(dir:'images/icons/delete.gif')}"  
										class="delete-attribute" asset="Note" 
										style="margin-left:7px;"
										form="form-note-${prospectNote.id}"/>
								</form>								
								<br class="clear"/>
							</td>
						</tr>
						<tr>
							<td>
								<span class="information">
									<g:formatDate date="${prospectNote.dateCreated}" format="dd MMM yyyy hh:mm a"/>
								</span>
								<g:if test="${prospectNote.account?.name}">
									<span class="information">
										<a 
											href="mailto:${prospectNote.account.username}"
											title="${prospectNote.account.username}">${prospectNote.account?.username}</a></span>
								</g:if>
								<g:else>
									<span class="information">
										<a 
											href="mailto:${prospectNote.account.username}" 
											title="${prospectNote.account.username}">${prospectNote.account.username}</a></span>
								</g:else>
							</td>
						</tr>
					</g:each>
				</table>
			</g:if>
			<g:else>
			</g:else>
		</div>
		<!-- End of Notes -->
		
		
		
		
		
		
		
		
		<!-- Start of Documents -->
		<div class="prospect-detail">
			<g:if test="${prospectInstance?.prospectDocuments?.size() > 0}">
				<h4>Documents</h4>
				<a href="javascript:" 
					class="asset-link prospect-action pull-right" 
					window-height="540" window-width="700" 
					action="/${applicationService.getContextName()}/prospectDocument/create/${prospectInstance.id}">Add Document</a>
				<br class="clear"/>
				<table class="table table-condensed table-bordered">
					<tr>
						<th>Id</th>
						<th>Document &amp; Description</th>
						<th class="asset-actions"></th>
					</tr>
					<g:each in="${prospectInstance?.prospectDocuments}" var="prospectDocument">
						<tr>	
							<td>${prospectDocument.id}</td>
							<td>
								<a href="/${applicationService.getContextName()}/static/${prospectDocument.documentUrl}" target="_blank" title="Download">${prospectDocument.originalFileName}</a><br/>
								${prospectDocument.description}
							</td>
							<td class="asset-actions">
								<img src="${resource(dir:'images/icons/edit.gif')}"  
									class="prospect-action" window-height="540" window-width="700" 
								action="/${applicationService.getContextName()}/prospectDocument/edit/${prospectDocument.id}" 
									/>
								<form 	
								action="/${applicationService.getContextName()}/prospectDocument/delete/${prospectDocument.id}" 
								method="post" id="form-document-${prospectDocument.id}">
									<input type="hidden" name="prospectId" value="${prospectInstance.id}"/>
									<img src="${resource(dir:'images/icons/delete.gif')}"  
										class="delete-attribute" asset="Document" 
										style="margin-left:7px;"
										form="form-document-${prospectDocument.id}"/>
								</form>								
								<br class="clear"/>
							</td>
						</tr>
					</g:each>
				</table>
			</g:if>
			<g:else>
			</g:else>
		</div>
		<!-- End of Documents -->
		
		
		
		
		<!-- Start of Websites -->
		<div class="prospect-detail">
			<g:if test="${prospectInstance?.prospectWebsites?.size() > 0}">
				<h4>Websites</h4>
				<a href="javascript:" 
					class="asset-link prospect-action pull-right" 
					window-height="540" window-width="700" 
					action="/${applicationService.getContextName()}/prospectWebsite/create/${prospectInstance.id}">Add Website</a>
				<br class="clear"/>
				<table class="table table-condensed table-bordered">
					<tr>
						<th>Id</th>
						<th>Website &amp; Description</th>
						<th class="asset-actions"></th>
					</tr>
					<g:each in="${prospectInstance?.prospectWebsites}" var="prospectWebsite">
						<tr>
							<td>${prospectWebsite.id}</td>
							<td>
								<a href="http://${prospectWebsite.website}" title="Visit" target="_blank">${prospectWebsite.website}</a><br/>
								${prospectWebsite.description}
							</td>
							<td class="asset-actions">
								<img src="${resource(dir:'images/icons/edit.gif')}"  
									class="prospect-action" window-height="540" window-width="700" 
								action="/${applicationService.getContextName()}/prospectWebsite/edit/${prospectWebsite.id}" 
									/>
								<form 	
									action="/${applicationService.getContextName()}/prospectWebsite/delete/${prospectWebsite.id}" 
										method="post" id="form-website-${prospectWebsite.id}">
									<input type="hidden" name="prospectId" value="${prospectInstance.id}"/>
									<img src="${resource(dir:'images/icons/delete.gif')}"  
										class="delete-attribute" asset="Website" 
										style="margin-left:7px;"
										form="form-website-${prospectWebsite.id}"/>
								</form>								
								<br class="clear"/>
							</td>
						</tr>
					</g:each>
				</table>
			</g:if>
			<g:else>
			</g:else>
		</div>
		<!-- End of Websites -->
		
		
		
		
		
		
		
		
		
		
		
		
	</div>
	<br class="clear"/>
	
	
	<div id="prospect-details-bottom">
		<!--
		<g:form controller="prospect" name="delete-prospect" id="${prospectInstance.id}">
			<g:actionSubmit class="btn btn-danger" action="delete" 
				value="Delete" formnovalidate="" 
				onclick="return confirm('Please confirm, this will delete all Sales Actions, Contacts, Notes, etc?');" 
				class="nostyle" />
		</g:form>
		-->
	
		<style type="text/css">
			#prospect-details-bottom{
				text-align:right;
				margin-top:20px;
				position:relative;
				border:solid 0px #ddd;
			}
		</style>
	
	

	</div>
	
	
	
	
	
	
	
	
	
	
	
	<script type="text/javascript" src="${resource(dir:'js/country_states.js')}"></script>
	
	<script type="text/javascript">
		
		var pageStart = Date.now()
		
		
		$(document).ready(function(){
			countryStatesInit("${applicationService.getContextName()}", ${prospectInstance?.state?.id})
			
			
			var $actions = $(".prospect-action")
			var w = {}
			var closeable = false
			var closedByClick = false
		
			$actions.click(function(event){
				event.preventDefault()
				var $action = $(event.target)
				var height = $action.attr("window-height")
				var width = $action.attr("window-width")
				var action = $action.attr("action")
				
				//console.log(height, width)
	
				w = window.open(action, "PROSPECT_ACTION", "width=" + width + ", height=" + height)
	
				w.onload = function() {
					//console.log("opened set closeable");
					closeable = true
				}
			})
			
			var timer = setInterval(checkWindowClosed, 500);
	
			function checkWindowClosed() {
			    if (w.closed) {
			        clearInterval(timer);
					if(!closedByClick){
						location.reload();
					}
			    }
			}
	
	
			var $deleteAttributes = $(".delete-attribute")
			$deleteAttributes.click(promptUserDelete)
			
			function promptUserDelete(event){
				var $button = $(event.target)
				var asset = $button.attr("asset");
				var $form = $("#"+ $button.attr("form"));
				var confirmation = confirm("Confirm to delete " + asset);
				if (confirmation) {
					$form.submit()
				}
			}
			
			
			//var $salesEffortBtn = $("#sales-effort-btn");
			//var $salesEffortTopLabel = $("#sales-effort-top-label");
			//var $salesEffortBottomLabel = $("#sales-effort-bottom-label");
				
			

		})
	</script>

</body>
</html>
