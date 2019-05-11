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
	td{
  	  vertical-align: middle !important;
	}
	</style>
	<div style="border:solid 0px #ddd; background:#fff">
	
		<div id="list-account" class="content scaffold-list" role="main">
		
			<g:if test="${flash.message}">
				<div class="alert alert-info" role="status">${flash.message}</div>
			</g:if>
		
		
			<h2 class="pull-left" style="border:solid 0px #ddd; margin-top:5px;">Imports</h2>
			
			<p class="information secondary pull-left" style="border:solid 0px #ddd; margin:20px 0px 0px 20px"><strong>${importJobInstances.size()}</strong> Imports in result set</p>
		

			<br class="clear"/>

			<g:if test="${importJobInstances}">
			
			
				<table class="table table-condensed table-striped" id="">
					<thead>
						<tr>
							<g:sortableColumn property="id" title="Id"/>
							<g:sortableColumn property="dateCreated" title="Date"/>
							<g:sortableColumn property="uuid" title="UUID"/>
							<th>Prospects</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${importJobInstances}" status="i" var="importJobInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						
							<td>${importJobInstance.id}</td>
							
							<td>${importJobInstance.dateCreated}</td>
							
							<td>${importJobInstance.uuid}</td>
							
							<td>${importJobInstance.prospects}</td>

							<td>
								<a 
									href="/${applicationService.getContextName()}/prospect/imported/${importJobInstance.id}">View Prospects</a>
									<form 	
									action="/${applicationService.getContextName()}/prospect/delete_import/${importJobInstance.id}" 
									method="post" id="form-${importJobInstance.id}">
										<img src="${resource(dir:'images/icons/delete.gif')}"  
											class="delete-attribute" asset="Import" 
											style="margin-left:7px;"
											form="form-${importJobInstance.id}"/>
									</form>		
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>
				
				<div class="btn-group">
					<g:paginate total="${importJobInstanceTotal}"/>
				</div>
			</g:if>
			<g:else>
				<br/>
				<p style="color:#333;padding:0px 40px;">No background imports completed yet...</p>
			</g:else>
		</div>
	</div>

	<script type="text/javascript">
	$(document).ready(function(){
		var $deleteAttributes = $(".delete-attribute")
		$deleteAttributes.click(promptUserDelete)
		
		function promptUserDelete(event){
			var $button = $(event.target)
			var asset = $button.attr("asset");
			var $form = $("#"+ $button.attr("form"));
			var confirmation = confirm("Confirm to delete Import and imported prospects? This will delete all imported prospects as well for this import. Are you sure?");
			if (confirmation) {
				$form.submit()
			}
		}
	})
	</script>
	</body>
</html>
