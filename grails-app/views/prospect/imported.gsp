<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="edit_prospect"/>
		<title>Imported Prospects</title>
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
		
		
			<h2 class="pull-left" style="border:solid 0px #ddd; margin-top:5px;">Prospects Imported</h2>
			
			<p class="information secondary pull-left" style="border:solid 0px #ddd; margin:20px 0px 0px 20px"><strong>${prospectInstanceList.size()}</strong> Prospects imported on <g:formatDate format="yyyy-MM-dd" date="${importJob.dateCreated}"/></p>
		
		
		
		
		
		
			<g:link action="imports" class="pull-right" style="margin-top:30px;margin-bottom:13px;margin-left:10px;">Back: View Imports</g:link>
			
			<g:if test="${prospectInstanceList}">
			
				<span class="pull-right" style="margin-top:30px;margin-left:10px;color:#999">&nbsp;|&nbsp;</span>
			
				<a href="javascript:" id="select-all-btn" class="pull-right" style="margin-top:30px;margin-bottom:13px;margin-left:10px;">Select All</a>
				
				<span class="pull-right" style="margin-top:30px;margin-left:10px;color:#999">&nbsp;|&nbsp;</span>
				
				<a href="javascript:" id="change-selection-btn" class="pull-right" style="margin-top:30px;">
					<img src="${resource(dir:'images/icons/edit_collection.gif')}" style=""/>
					Update All Prospects Selected</a>
			</g:if>	
			
				

			<br class="clear"/>

			<g:if test="${prospectInstanceList}">
			
			
				<table class="table table-condensed table-striped display" id="prospects-table">
					<thead>
						<tr>
						
							<th style="width:27px;">
								<input type="checkbox" name="select-all" id="select-all-checkbox"/>
							</th>
						
							<g:sortableColumn property="id" title="Id"/>
							
							<g:sortableColumn property="company" title="Company" style="width:181px"/>
						
							<g:sortableColumn property="city" title="City"/>
						
							<g:sortableColumn property="zip" title="Zip"/>
										
							<g:sortableColumn property="state" title="Country & State"/>
						
							<g:sortableColumn property="contactName" title="Contact"/>
						
							<g:sortableColumn property="territory" title="Territory"/>
										
							<g:sortableColumn property="status" title="Status"/>
										
							<g:sortableColumn property="size" title="Size"/>
						
							<g:sortableColumn property="verified" title="Verified"/>
							
							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${prospectInstanceList}" status="i" var="prospectInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						
							<td><input type="checkbox" class="form-control prospect-checkbox" prospect-id="${prospectInstance.id}"/></td>
						
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
				<p style="color:#333;padding:0px 40px;">No Prospects found... </p>
			</g:else>
		</div>
	</div>

	<form name="change_selection" action="/${applicationService.getContextName()}/prospect/change_selection" method="post" id="change-selection" class="form-horizontal">
		<input type="hidden" name="prospect-ids" value=""/>
	</form>

<script type="text/javascript">

<g:if test="${prospectInstanceList}">
	$(document).ready(function(){
		$("#prospects-table").fadeIn(903, function(){})
		$("#loading").fadeOut(903, function(){})
		
		var ids = []
		var w = {};
			
		var closedByClick = false;	
		var $changeSelectedForm = $("#change-selection");
		var $prospectIdsInput = $("#prospect-ids");
		var $checkboxes = $(".prospect-checkbox");
		var $changeSelectionBtn = $("#change-selection-btn");
		var $selectAllBtn = $("#select-all-btn");
		var $selectAll = $("#select-all-checkbox");
		
		
		var timer = setInterval(checkWindowClosed, 500);
		var action = "/${applicationService.getContextName()}/prospect/change_selection?ids=" + ids
		
		$changeSelectionBtn.click(function(event){
			if(ids.length > 0){
				w = window.open(action, "UPDATE_SELECTION", "width=640, height=700")
			}else{
				alert("You have not selected any prospects to update yet...")
			}
		});
		
		$selectAllBtn.click(function(){
			$selectAll.click()
			console.log($selectAllBtn.html())
			if($selectAllBtn.html() == "Select All"){
				console.log("equals")
				$selectAllBtn.html("Deselect All")
			}else{
				$selectAllBtn.html("Select All")
			}
		});
		
		
		$checkboxes.change(function(event){
			refreshCheckedCheckboxes()
		});
		
		$selectAll.change(function(){
			$checkboxes.prop("checked", !$checkboxes.prop("checked"));
			refreshCheckedCheckboxes()
		})
		
		function refreshCheckedCheckboxes(){
			ids = []
			$checkboxes.each(function(index, checkbox){
				if(checkbox.checked){
					var id = $(checkbox).attr("prospect-id")
					ids.push(id)
					action = "/${applicationService.getContextName()}/prospect/change_selection?ids=" + ids
				}
			})
		}
		
		function checkWindowClosed() {
		    if (w.closed) {
		        clearInterval(timer);
				if(!closedByClick){
					location.reload();
				}
		    }
		}
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
