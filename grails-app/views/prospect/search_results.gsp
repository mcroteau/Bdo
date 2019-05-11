<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="edit_prospect"/>
		<title>Work Prospects</title>
		<script type="text/javascript" src="${resource(dir:'js/lib/datatables/datatables.min.js')}"></script>
		<link rel="stylesheet" href="${resource(dir:'js/lib/datatables/datatables.min.css')}" />
	</head>
	<body >

	<style type="text/css">
	table, th, td{
		font-size:0.97em !important;
		//font-size:0.97em !important;
	}
	#prospects-table{
		display:none;
	}
	#prospects-table_length{
		margin-top:10px;
	}
	#prospects-table_filter{
		padding:5px;
		background:#f8f8f8;
		border:solid 1px #ddd;
		width:634px;
		padding-bottom:0px;
		-webkit-border-radius: 2px;
		-moz-border-radius: 2x;
		border-radius: 2px;
	}
	#prospects-table_filter input[type="search"]{
		width:546px;
		font-size:17px;
		font-weight:normal !important;
	}
	#prospects-table_filter label{
		color:#777;
	}
	.dataTables_length label{
		font-size:11px;
		font-weight:normal;
	}
	.dataTables_length select{
		width:75px;
		font-weight:normal;
	}
	#loading{
		top:300px;
		right:455px;
		z-index:2000;
		position:absolute;
	}
	#search-instructions{
		display:none;
	}
	.btn-group a{
		border:solid 1px #fff;
		padding:4px 10px;
		display:inline-block;
	}
	.btn-group a.current{
		background:#f8f8f8 !important;
		border:dashed 1px #ddd !important;
	}
	.btn-group a:hover{
		cursor:hand;
		cursor:pointer;
		text-decoration:none;
		color:#333333 !important;
		background:#efefef;
		border:solid 1px #ddd !important;
		background-image:none !important;
	}
	</style>
	<div style="height:700px; border:solid 0px #ddd; background:#fff">
		<div class="alert alert-info pull-right" id="loading">Loading all prospects...</div>
	
		<div id="list-account" class="content scaffold-list" role="main">
		
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${flash.message}</div>
			</g:if>
		
		
			<h2 class="pull-left">Working Prospects</h2>
			<p class="information secondary pull-right" id="search-instructions" style="margin-top:50px;text-align:right">Filter on any attribute of a <strong>Prospect</strong>, including company, contact information, territory, status etc...<br/>
			<!--There are currently <strong>${prospectInstanceList.size()}</strong> prospects in your database--></p>
			<br class="clear"/>

			<g:if test="${prospectInstanceList}">
			
			
				<table class="table table-condensed table-striped display" id="prospects-table">
					<thead>
						<tr>
							
							<th>Id</th>
							
							<th style="width:181px;">Company</th>
							
							<!--<th>Address</th>-->
							
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
			
							<td>${prospectInstance.id}</td>
							
							<td>${prospectInstance.company}</td>
							
							<!--
							<td>
								<address>
									${prospectInstance.address1}<br/>
									${prospectInstance.address2}
								</address>
							</td>
							-->
							
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
								${prospectInstance.cellPhone}
								<br/>
								${prospectInstance.fax}
								<g:if test="${prospectInstance.email}">
									<a href="mailto:${prospectInstance.email}">${prospectInstance.email}</a>
								</g:if>
							</td>
						
							<td>${prospectInstance?.territory?.name}</td>
						
							<td>${prospectInstance?.status?.name}</td>
							
							<td>${prospectInstance?.prospectSize?.size}</td>
							
							<td>
								<g:if test="${prospectInstance?.verified}">
									Verified
								</g:if>
								<g:else>
									Verification Needed
								</g:else>
							</td>

							<td>
								<a 
									href="/${applicationService.getContextName()}/prospect/edit/${prospectInstance.id}"><img src="${resource(dir:'images/icons/edit.gif')}"/>
								</a>
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>

			</g:if>
			<g:else>
				<br/>
				<p style="color:#333;padding:0px 40px;">No Prospects found...</p>
				<p><g:link action="create">Create Prospect</g:link>
			</g:else>
		</div>
	</div>
<script type="text/javascript">

<g:if test="${prospectInstanceList}">
	$(document).ready(function(){
		
		var DISPLAY_SPEED = 903;
		
		var table = $("#prospects-table").DataTable({
		  	"initComplete": function(settings, json) {
				$("#prospects-table_wrapper").hide()
				$("#prospects-table_filter input[type=search]").addClass("form-control")
				$("#prospects-table_wrapper select").addClass("form-control")
				$("#prospects-table").fadeIn(DISPLAY_SPEED, function(){})
				$("#prospects-table_wrapper").fadeIn(DISPLAY_SPEED, function(){})
				$("#loading").fadeOut(DISPLAY_SPEED, function(){})
				$("#search-instructions").fadeIn(DISPLAY_SPEED, function(){})
				$(".dataTables_paginate").addClass("btn-group")
				$(".paginate_button").removeClass("paginate_button");
				//.removeClass("paging_simple_numbers").removeClass("dataTables_paginate")
				
			},
			"drawCallback": function( settings, o, q ) {
				//console.log(settings, o, q)
				var ids = []
				$(settings.aoData).each(function(){
					/**TODO: 
						consider sending array of ids and query 
						to server side to save in session 
						for navigating back and forward through results
					**/
					//console.log(this._aData[0])
				})
			}
		})
		
		table.on( 'select', function ( e, dt, type, indexes ) {
				console.log(e, dt, type, indexes)
		    if (type === 'row') {
		        //var data = table.rows( indexes ).data().pluck( 'id' );
				console.log(e, dt, type, indexes)
		        // do something with the ID of the selected items
			}
		});
		
		<g:if test="${query}">
			table.search("${query}").draw();
			$("#prospects-table_filter input[type=search]").val("${query}")
		</g:if>
		
		
	})
</g:if>
</script>		
	</body>
</html>
