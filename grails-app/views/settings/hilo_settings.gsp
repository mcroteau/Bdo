<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="default">
		<title>Seal : Manage Data Access Key</title>
	</head>
	<body>

		<style type="text/css">
			#outer-manage-key-container{
				text-align:center;
			}
			#manage-key-container{
				width:601px;
				margin:67px auto;
				text-align:center;
				border:solid 0px #ddd;
			}
			#manage-key-container p{
				margin-bottom:30px;
			}
			#key-container{
				margin:30px auto;
				display:block;
				border-radius:1px;
			}
			#key-container input[type="text"]{
				font-size:24px;
				display:block;
				height:49px !important;
				padding:10px 20px;
				text-align:center;
				background:#f8f8f8;
				border:solid 1px #ddd;
			}
		</style>
		<div id="outer-manage-key-container">	
			<div id="manage-key-container" class="content scaffold-create" role="main">
			
			
				<h2 style="margin-bottom:20px">Hilo Access Keys</h2>
			
				<g:if test="${flash.message}">
					<div class="alert alert-info" role="status">${flash.message}</div>
				</g:if>
				
				<p>Seal otherwise known as BDO CRM works closely with Hilo and will automatically import account data converting Hilo accounts to prospects in Seal on import</p>
				
				
				<g:form action="save_hilo_settings" method="post">
					
	
					<div class="form-row">
						<span class="form-label twohundred">Hilo URL</span>
						<span class="input-container">
							<input type="text" class="form-control" name="hiloUrl" value="${hiloUrl}" style="width:300px" placeholder="http://www.company.com/hilo" id="hilo-url"/>
						</span>
						<span class="glyphicon glyphicon-ban-circle" id="errored" style="display:none;float:left"></span>
						<span class="glyphicon glyphicon-ok" id="success" style="display:none; float:left"></span>
						<br class="clear"/>
					</div>
	
					<div class="form-row">
						<span class="form-label twohundred">Hilo Access Key</span>
						<span class="input-container">
							<input type="text" class="form-control" name="hiloPrivateKey" value="${hiloPrivateKey}" style="width:300px" id="hilo-private-key"/>
						</span>
						<br class="clear"/>
					</div>

					<br class="clear"/>

					<a href="javascript:" id="data-check" class="" style="margin-right:10px;" target="_blank">Test Data Retrieval</a>

					<input type="submit" value="Save Hilo Settings" class="btn btn-primary"/>
					
				</g:form>
				
			</div>
		</div>
		

		


		<script type="text/javascript">
		$(document).ready(function(){
			var $dataCheck = $("#data-check"),
				$hiloInput = $("#hilo-url"),
				$hiloPrivateKey = $("#hilo-private-key"),
				$error = $("#errored"),
				$success = $("#success");
				

			$hiloInput.keyup(function(event){
				var url = "/${applicationService.getContextName()}/data/hln?uri=" + $hiloInput.val() + "data/accounts?k="; 			
				var dataUrl = $hiloInput.val() + "/data/accounts?k=" + $hiloPrivateKey.val()
				
				$dataCheck.attr("href", dataUrl)
				
				console.log($dataCheck.attr("href"))
				
				$.ajax({
					url : dataUrl,
				    complete: function(xhr, textStatus) {
						if(xhr.responseJSON){
							hideShow($error, $success, "success")					
						}else{
							hideShow($success, $error, "errored")
						}
					}, 
					error: function(o, q){
						hideShow($success, $error, q)
					}
				});

			})	
			
				
			$hiloPrivateKey.keyup(function(event){
				var dataUrl = $hiloInput.val() + "/data/accounts?k=" + $hiloPrivateKey.val()
				$dataCheck.attr("href", dataUrl)
			});
			
			function hideShow($hide, $show, error){
				$hide.hide()
				$show.show()
			}
		
		})
		</script>
	</body>
</html>

						
	
	