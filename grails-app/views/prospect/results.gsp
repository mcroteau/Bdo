<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="edit_prospect"/>
		<title>Search Results</title>

		<link rel="icon" type="image/png" href="${resource(dir:'images/seal-icon.png')}" />

		<script type="text/javascript" src="${resource(dir:'js/lib/datatables/datatables.min.js')}"></script>

		<link rel="stylesheet" href="${resource(dir:'js/lib/datatables/datatables.min.css')}" />
	</head>
	<body>

	<style type="text/css">
	table, th, td{
		font-size:0.97em !important;
		//font-size:0.97em !important;
	}
	#prospects-table{
		display:none;
	}

	#prospects-table th{
		color: #428bca;
		font-weight:normal;
	}

	#prospects-table th:hover{
		text-decoration:underline
	}

	#prospects-table_length{
		margin-top:10px;
	}
	#prospects-table_filter{
		padding:5px;
		background:#f8f8f8;
		border:solid 1px #ddd;
		width:474px;
		padding-bottom:0px;
		-webkit-border-radius: 2px;
		-moz-border-radius: 2x;
		border-radius: 2px;
	}
	#prospects-table_filter input[type="search"]{
		width:346px;
		font-size:17px;
		font-weight:normal !important;
	}
	#prospects-table_filter label{
		color:#000;
		font-weight:normal;
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
	td{
  	  	vertical-align: middle !important;
	}
	</style>






	<div style="border:solid 0px #ddd; background:#fff">
	

		<div class="alert alert-info pull-right" id="loading">Loading prospects...</div>
	

		<div id="list-account" class="content scaffold-list" role="main">
		
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${flash.message}</div>
			</g:if>
		
				
			<style type="text/css">
				#search-results-actions{
					margin:30px auto 0px auto;
					border:solid 0px #ddd;
				}
				#none-found{
					width:75%;
					padding:50px;
					margin:71px auto 300px auto;
					background:#f8f8f8;
					border:solid 1px #ddd;
				}
				#none-found p{
					font-size:19px;
				}
			</style>


			<div id="search-results-header" class="pull-left">
				<h2 class="pull-left" style="">Search Results</h2>
				<br/>
				<p class="information pull-left" style="margin:0px 0px 0px 0px">
				<strong>${prospectInstanceList.size()}</strong> Prospects in result set&nbsp;
				<strong id="selected-count">0</strong> selected
				</p>
				<br class="clear"/>
				<!--<p class="">Selecting all selects all prospects in result set. <br/>Filter, then select individually to get the collection that you want.</p>-->
			</div>
		

			<style type="text/css">
				#search-results-actions a{
					margin-left:20px;
					display:inline-block;
				}

				#select-all-btn{
					margin-left:10px;
					display:inline-block;
				}
			</style>

			<g:if test="${prospectInstanceList}">
				<div id="search-results-actions" class="pull-right">
					
					<!--<a href="javascript:" id="select-all-btn" class="pull-right">Select All</a>-->

					<g:link action="export_results" class="pull-right">Export Result Set CSV</g:link>

					<a href="javascript:" class="pull-right" id="export-collection-btn">
						<!--<img src="${resource(dir:'images/icons/continue.gif')}"/>-->
						Export Selected CSV</a>	


					<a href="javascript:" class="pull-right" id="remove-collection-btn">
						<!--<img src="${resource(dir:'images/icons/delete.gif')}"/>-->
						Remove from Result Set</a>

					<a href="javascript:" class="collection-action pull-right" collection-action="confirm_delete_selected">
						<!--<img src="${resource(dir:'images/icons/delete_cascade.gif')}"/>-->
						Delete Selected</a>

					<a href="javascript:" class="collection-action pull-right" collection-action="edit_selected">
						<!--<img src="${resource(dir:'images/icons/edit_collection.gif')}"/>-->
						Edit Selected</a>



					<br class="clear"/>
				</div>
			</g:if>		
				
			<br class="clear"/>

			<g:if test="${prospectInstanceList}">
			
			
				<table class="table table-condensed table-striped display" id="prospects-table">
					<thead>

						<!--
						<tr>
						
							<th style="width:27px;">
								<input type="checkbox" name="select-all" id="select-all-checkbox"/>
							</th>

							<g:if test="${containsImports}">
								<g:sortableColumn property="importUuid" title="Import Id"
									params="['query': params.query, 'territory.id': 	params.territory?.id, 
											'status.id': params.status?.id, 'verified': 	params.verified]"/>
							</g:if>
							
							<g:sortableColumn property="company" title="Company" style="width:181px" 
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
						
							<g:sortableColumn property="city" title="City"
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
						
							<g:sortableColumn property="zip" title="Zip"
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
										
							<g:sortableColumn property="state" title="Country & State"
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
						
							<g:sortableColumn property="contactName" title="Contact"
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
						
							<g:sortableColumn property="territory" title="Territory"
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
										
							<g:sortableColumn property="status" title="Status"
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
										
							<g:sortableColumn property="size" title="Size"
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
						
							<g:sortableColumn property="verified" title="Verified"
								params="['query': params.query, 'territory.id': params.territory?.id, 
										'status.id': params.status?.id, 'verified': params.verified]"/>
							
							<th></th>
							<th></th>
						</tr>
						-->

						<tr>
							<th style="width:27px;">
								<input type="checkbox" name="select-all" id="select-all-checkbox"/>
							</th>

							<g:if test="${containsImports}">
								<th>Import Id</th>
							</g:if>

							<th>Company</th>
							<th>City</th>
							<th>Zip</th>
							<th>Country <br/>&amp; State</th>
							<th>Contact</th>
							<th>Territory</th>
							<th>Status</th>
							<th>Size</th>
							<th>Verified</th>
							<th>Sales Effort</th>
							<th></th>
						</tr>

					</thead>
					<tbody>
					<g:each in="${prospectInstanceList}" status="i" var="prospectInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						

							<td><input type="checkbox" class="form-control prospect-checkbox" prospect-id="${prospectInstance.id}"/></td>
							

							<g:if test="${containsImports}">
								<td>${prospectInstance.importUuid}</td>
							</g:if>

							
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
							
							<td>
								<g:if test="${prospectInstance.state}">
									${prospectInstance.state?.name}
									<br/>
								</g:if>
								${prospectInstance.country?.name}
							</td>
							
							<td>
								${prospectInstance.contactName}
							
								<g:if test="${prospectInstance.contactTitle}">
									<span class="information secondary">(${prospectInstance.contactTitle})</span>
									<br/>
								</g:if>
							
								<g:if test="${prospectInstance.phone}">
									${prospectInstance.phone}
									<br/>
								</g:if>
								<g:if test="${prospectInstance.cellPhone}">
									${prospectInstance.cellPhone}
									<br/>
								</g:if>
								<g:if test="${prospectInstance.fax}">
									${prospectInstance.fax}
									<br/>
								</g:if>
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
								<g:if test="${prospectInstance?.currentSalesEffort?.recording}">
									<span class="label label-primary">Recording</span>
								</g:if>
								<g:else>
									<span class="label label-default">Not Recording</span>
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

				<div id="none-found">
					<p style="color:#333;padding:0px 40px;">No Prospects found in search... &nbsp;<br/><br/>
					<g:link action="search">Search Again</g:link>
					&nbsp;&nbsp;&nbsp;
					<g:link action="create">Create New Prospect</g:link>
					&nbsp;&nbsp;&nbsp;
					<g:link controller="importExport" action="view_import">Import Prospects</g:link>
					</p>
				</div>

			</g:else>
		</div>
	</div>

	<form name="change_selection" action="/${applicationService.getContextName()}/prospect/change_selection" method="post" id="change-selection" class="form-horizontal">
		<input type="hidden" name="prospect-ids" value=""/>
	</form>

<script type="text/javascript">

<g:if test="${prospectInstanceList}">
	$(document).ready(function(){

		var DURATION = 402

		$("#loading").fadeOut(DURATION, function(){})
		$("#prospects-table").fadeIn(DURATION, function(){})
		
		var ids = []
		var w = {};

			
		var initial              = true
		var closedByClick        = false;	
		var $changeSelectedForm  = $("#change-selection");
		var $prospectIdsInput    = $("#prospect-ids");
		var $checkboxes          = $(".prospect-checkbox");
		var $selectAllBtn        = $("#select-all-btn");
		var $selectAllCheckbox   = $("#select-all-checkbox");
		var $removeCollectionBtn = $("#remove-collection-btn");
		var $exportCollectionBtn = $("#export-collection-btn");
		var $exportResultSetBtn  = $("#export-result-set-btn");
		var $selectedCount       = $("#selected-count");

		var $collectionActions = $(".collection-action")
		
		var $prospectsTable = $("#prospects-table")

		var $filter,
			$selectWrapper;

		
		var timer = setInterval(checkWindowClosed, 500);
		

		var filterInputHtml = "<input type=\"search\" class=\"\" placeholder=\"\" aria-controls=\"prospects-table\">"

		var filterHtml = "<span id=\"filter-label\">Filter Results : </span>" + filterInputHtml



		$collectionActions.click(function(event){
			var $target = $(event.target)
			event.preventDefault()

			var action = $target.attr("collection-action")
			var actionFull = "/${applicationService.getContextName()}/prospect/" + action + "?ids=" + ids

			if(ids.length > 0){
				w = window.open(actionFull, "UPDATE_SELECTION", "width=640, height=700")
			}else{
				alert("You have not selected any prospects to update yet...")
			}
		});


		$selectAllBtn.click(function(){
			//$selectAll.click()
			if($selectAllBtn.html() == "Select All"){
				$selectAllBtn.html("Deselect All")
			}else{
				$selectAllBtn.html("Select All")
			}
		});
		
		
		$checkboxes.change(function(event){
			refreshCheckedCheckboxes()
		});
		
		$selectAllCheckbox.change(function(){
			$checkboxes = $(".prospect-checkbox");
			$checkboxes.prop("checked", !$checkboxes.prop("checked"));
			refreshCheckedCheckboxes()
		})
		
		function refreshCheckedCheckboxes(){
			ids = []
			$checkboxes.each(function(index, checkbox){
				if(checkbox.checked){
					var id = $(checkbox).attr("prospect-id")
					ids.push(id)
				}
				$selectedCount.html(ids.length)
			})
			var removeHref = "/${applicationService.getContextName()}/prospect/remove_selected?ids=" + ids 
			$removeCollectionBtn.attr("href", removeHref)

			var exportHref = "/${applicationService.getContextName()}/prospect/export_selected?ids=" + ids 
			$exportCollectionBtn.attr("href", exportHref)
		}
			
		$exportCollectionBtn.click(function(){
			if(ids.lenght == 0)alert("Please select prospects to export to csv")		
		})	

		$removeCollectionBtn.click(function(event){
			if(ids.length == 0){
				alert("You haven't selected any prospects to remove from results yet.")
				event.preventDefault();
			}
		})


		function checkWindowClosed() {
		    if (w.closed) {
		        clearInterval(timer);
				if(!closedByClick){
					location.reload();
				}
		    }
		}


		var table = $prospectsTable.DataTable({
			"init" : function(event, settings, json){
			},
			"drawCallback": function( settings, o, q ) {
				$filter = $("#prospects-table_filter");
				$selectWrapper = $("#prospects-table_wrapper")
				$pageination = $(".paginate_button ")

				$filter.find("input").addClass("form-control")
				$selectWrapper.find("select").addClass("form-control")
				$pageination.removeClass("paginate_button").addClass("btn")
				$(".current").addClass("btn-default")
			},
			"initComplete" : function(){
			}
		})

		table.on( 'draw.dt', function (o, p) {
			$checkboxes = $(".prospect-checkbox");
			refreshCheckedCheckboxes()
		});

		$('#prospects-table_filter').find("input").on("keyup", function(event){
			var id = $(event.target).attr("id")
			if(id != "select-all-checkbox"){
				$checkboxes = $(".prospect-checkbox");
				refreshCheckedCheckboxes()
			}
		})

		$('#prospects-table_filter').find("label").contents().filter(function() {
		    return this.nodeType == 3
		}).each(function(){
		    this.textContent = this.textContent.replace("Search:","Filter Results: ");
		});



	});
</g:if>	
<g:else>
$(document).ready(function(){
	$("#loading").fadeOut(903, function(){})	
});
</g:else>	
</script>	
	</body>
</html>
