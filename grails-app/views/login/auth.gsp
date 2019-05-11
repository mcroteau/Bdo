<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>


<!DOCTYPE html>
<html>
	<head>
		<title>
${applicationService.getCompanyName()} : Admin Login</title>
		<link rel="stylesheet" href="${resource(dir:'bootstrap/3.1.1/css', file:'bootstrap.min.css')}" />
		<link rel="stylesheet" href="${resource(dir:'css', file:'admin.css')}" />
	
	</head>
	<body>
		
<style type="text/css">
html,
	body{ 
		padding:0px;
		height:100%;
		text-align:center;
		background:#f0faf7;
		background:f8f8f8;
	}
	#outer-container{
		padding:50px 50px 50px 50px;
		width:430px;
		margin:50px auto;
		background:#fff;
		text-align:left !important;
		border-radius: 3px 3px 3px 3px;
		-moz-border-radius: 3px 3px 3px 3px;
		-webkit-border-radius: 3px 3px 3px 3px;
		border-radius: 1px 1px 1px 1px;
		-moz-border-radius: 1px 1px 1px 1px;
		-webkit-border-radius: 1px 1px 1px 1px;
		box-shadow: 0px 0px 5px 0px rgba(0,0,0,0);
		-moz-box-shadow: 0px 0px 5px 0px rgba(0,0,0,0);
		-webkit-box-shadow: 0px 0px 5px 0px rgba(0,0,0,0);
		border:solid 1px #ddd;
		border:solid 1px #bcddd3;/**TODO**/
		position:relative;
	}

	#container{
		position:relative;
	}
	#abc-reference{
		top:0px;
		left:0px;
		position:absolute;
		height:27px; 
		width:34px; 
		display:block; 
	}

	input:-webkit-autofill {
		background:#f8f8f8;
	}

</style>
	
	<div id="outer-container">
	
		<g:if test="${flash.message}">
			<div class="alert alert-info">${flash.message}</div>
		</g:if>
		
			<a href="http://openabc.xyz" target="_blank" id="abc-reference" 
				title="ABC: Simple Open Source SMB Software">
				<img src="${resource(dir:'images/seal-icon.png')}" style="height:inherit;width:inherit;outline:none;display:inline-block"/><span style="display:none">ABC.R</span></a>

			
			<h2>Login</h2>

			<form action="/${applicationService.getContextName()}/login/authenticate" method="POST" id="loginForm" autocomplete="off">
			
				<div class="form-group">
				  	<label for="username">Username</label>
				  	<input type="text" name="username" class="form-control" id="username" value="${username}">
				</div>
			
				<div class="form-group">
				  	<label for="password">Password</label>
				  	<input type="password" name="password" class="form-control" id="password" placeholder="******">
				</div>
				
				<div class="form-group">
					<input type="checkbox" class="chk" name="remember-me" id="remember_me" />
					<label for="remember_me">Remember me</label>
				</div>
				
				<div class="form-group">
				  	<label><g:link controller="abcrAccount" action="forgot">Forgot password?</g:link></label>
				</div>
				
				<button type="submit" class="btn btn-default btn-primary pull-right" id="login">Login</button>
				
				<br class="clear"/>
				
			</form>
		
	</div>
			
	</body>
</html>

