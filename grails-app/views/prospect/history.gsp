<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<%@page import="io.seal.State"%>
<%@page import="io.seal.common.ApplicationConstants"%>

<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="edit_prospect"/>
	<title>Prospect</title>	
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
		float:right;
		width:575px;
	}
	
	.prospect-detail{
		color:#777;
		background:#fafafa;
		background:#fff;
		border:solid 0px #ddd;
		margin:0px auto 20px auto;
		padding:5px;
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
		margin-top:10px;
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
	
	<g:link action="search" class="nostyle pull-right">Back to Search</g:link>
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
			<li class="inactive"><g:link uri="/prospect/edit/${prospectInstance.id}" class="btn btn-default">
					Prospect Details 
					<g:if test="${salesEffortInstance?.recording}">
						<span class="label label-primary">Recording</label>
					</g:if>
					<g:else>
						<span class="label label-default">Not Recording</label>
					</g:else>
				</g:link>
			</li>
			<li class="active"><g:link uri="/prospect/history/${prospectInstance.id}" class="btn btn-default">Prospect History</g:link></li>
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
		
		
		
	<style type="text/css">
		#past-sales-efforts{
			float:left;
			width:532px;
		}
		#completed-sales-actions{
			float:right;
			width:460px;
		}
	</style>
	
	
	<div id="history-header">
		<h3>
			<%if(prospectInstance.company){%>
				${prospectInstance.company}
			<%}else{%>
				${prospectInstance.contactName}
			<%}%>
		</h3>
	</div>
		
	<div id="past-sales-efforts">

		<h4>Sales</h4>

		<g:if test="${prospectInstance?.prospectSales?.size() > 0}">
			<div>
				<table class="table table-condensed">
					<tr>
						<th>Id</th>
						<th>Date</th>
						<th>Sales Person</th>
						<th></th>
					</tr>
					<g:each in="${prospectInstance.prospectSales}" var="sale">
						<tr>
							<td>${sale.id}</td>
							<td><g:formatDate date="${sale.salesDate}" format="dd MMM yyyy"/></td>
							<td>
								<a
									href="mailto:${sale?.salesPerson?.username}"
									title="Email ${sale?.salesPerson?.nameEmail}">
										${sale?.salesPerson?.nameEmail}</a>
							</td>
						   	<td class="asset-actions">
						   		<img src="${resource(dir:'images/icons/edit.gif')}"  
						   			class="prospect-action" window-height="540" window-width="700"
									alt="Edit Sale"
									title="Edit Sale"
									action="/${applicationService.getContextName()}/prospectSale/edit/${sale.id}" 
						   			/>
						   		<form 	
						   		action="/${applicationService.getContextName()}/prospectSale/delete/${sale.id}" 
						   		method="post" id="form-${sale.id}">
						   			<input type="hidden" name="prospectId" value="${prospectInstance.id}"/>
						   			<img src="${resource(dir:'images/icons/delete.gif')}"  
						   				class="delete-attribute" asset="Sale" 
						   				style="margin-left:7px;"
										alt="Delete Sales Action"
										title="Delete Sales Action"
						   				form="form-${sale.id}"/>
						   		</form>								
						   		<br class="clear"/>
						   	</td>
						</tr>

					</g:each>
				</table>
			</div>
		</g:if>
		<g:else>
			<p class="information">No Sales yet...</p>
		</g:else>

		<div style="height:30px;"></div>


		<h4>Completed Sales Efforts</h4>
		<g:if test="${pastSalesEfforts.size() > 0}">
			<table class="table table-condensed">
				<tr>
					<th>Id</th>
					<th>Starting &amp; Ending Status</th>
					<th># Days</th>
					<th style="width:60px;">Sales<br/>Actions</th>
				</tr>	
				<g:each in="${pastSalesEfforts}" var="pastSalesEffort">
					<tr>
						<td>
							<a href="#sales-effort-${pastSalesEffort.id}">${pastSalesEffort.id}</a>
						</td>
						<td>
							<span class="label label-default">${pastSalesEffort.startingStatus.name}</span>
							&rarr;
							<span class="label label-default">${pastSalesEffort.completeStatus.name}</span>
						</td>
						<td>
							<%def numberOfDays = (pastSalesEffort?.dateCreated ? pastSalesEffort?.dateCreated : 0) - (pastSalesEffort?.dateComplete ? pastSalesEffort?.dateComplete : pastSalesEffort?.dateCreated)%>
							${numberOfDays}
						</td>
						<td>${pastSalesEffort.salesActions.size()}</td>
					</tr>
				</g:each>
			</table>
			
			

			<h4 style="margin-top:100px; margin-bottom:20px;">Sales Efforts Details</h4>
				
			<g:each in="${pastSalesEfforts}" var="pastSalesEffort">
			<div style="background:#f8f8f8; border:solid 1px #ddd;">
				<h5 id="sales-effort-${pastSalesEffort.id}">${pastSalesEffort.id} : 
					<g:formatDate date="${pastSalesEffort.dateCreated}" format="dd MMM yyyy hh:mm a"/>
					<span class="label label-default">${pastSalesEffort.startingStatus.name}</span>&nbsp;&rarr;&nbsp;
					<span class="label label-default">${pastSalesEffort.completeStatus.name}</span>
					<g:formatDate date="${pastSalesEffort.dateComplete}" format="dd MMM yyyy hh:mm a"/>
				</h5>
					
				<g:if test="${pastSalesEffort.salesActions?.size() > 0}">
					<table class="table table-condensed">
						<tr>
							<th>Id</th>
							<th>Date</th>
							<th>Action</th>
							<th>Sales Person</th>
						</tr>
						<g:each in="${pastSalesEffort?.salesActions}" var="salesAction">
							<tr>
								<td>${salesAction.id}</td>
								<td><g:formatDate date="${salesAction?.actionDate}" format="dd MMM yyyy hh:mm a"/></td>
								<td>${salesAction.salesAction.name}</td>
								<td>
									
									<g:if test="${salesAction?.account}">
                	
									<a
										href="mailto:${salesAction?.account?.username}"
										title="Email ${salesAction?.account?.nameEmail}">
											${salesAction?.account?.nameEmail}</a>
									</g:if>
									<g:else>
										<p class="information">Was never <br/>assigned to anyone</p>
									</g:else>
							
								</td>
							</tr>
                		</g:each>
					</table>
				</g:if>
				<g:else>
					<p class="alert alert-info">No Sales Actions were performed during this Effort</p>
				</g:else>
			</div>
			<p style="margin-top:50px;"></p>
			</g:each>
		</g:if>
		<g:else>
			<p>No Sales Efforts started for this prospect</p>
		</g:else>
	</div>
	
	
	
	<div id="completed-sales-actions">
		<h4>All Completed Sales Actions</h4>
		<g:if test="${completedSalesActions?.size() > 0}">
			<div>
				<table class="table table-condensed">
					<tr>
						<th>Id</th>
						<th>Date</th>
						<th>Action</th>
						<th>Sales Person</th>
						<th class="asset-actions"></th>
					</tr>
					<g:each in="${completedSalesActions}" var="salesAction">
						<tr>
							<td>${salesAction.id}</td>
							<td><g:formatDate date="${salesAction.actionDate}" format="dd MMM yyyy hh:mm a"/></td>
							<td>${salesAction.salesAction.name}</td>
							<td>
								
								<g:if test="${salesAction?.account}">

								<a
									href="mailto:${salesAction?.account?.username}"
									title="Email ${salesAction?.account?.nameEmail}">
										${salesAction?.account?.nameEmail}</a>
								</g:if>
								<g:else>
									<p class="information">Was never <br/>assigned to anyone</p>
								</g:else>
							</td>
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

					</g:each>
				</table>
			</div>
		</g:if>
		<g:else>
			<p class="information">No Completed Sales Actions yet...</p>
		</g:else>
	</div>



	<style type="text/css">
		#prospect-sales{
			float: left;
    		width: 563px;
		}
	</style>



	<div id="prospect-sales">

	</div>
	
	<br class="clear"/>


	<script type="text/javascript">
		
		var pageStart = Date.now()
		
		
		$(document).ready(function(){
			
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

		});
	</script>
</body>
</html>
