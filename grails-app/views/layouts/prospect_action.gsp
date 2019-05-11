<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
	<title>ABC.R : <g:layoutTitle default="ABC.R : ${message(code: "administration")}" /></title>


	<link rel="stylesheet" href="${resource(dir:'bootstrap/3.1.1/css', file:'bootstrap.min.css')}" />
	<script type="text/javascript" src="${resource(dir:'js/lib/jquery/1.11.0/jquery.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'bootstrap/3.1.1/js/bootstrap.js')}"></script>
	<script type="text/javascript" src="${resource(dir:'js/lib/datepicker/datepicker.js')}"></script>
	
	<script type="text/javascript" src="${resource(dir:'js/lib/datepicker/bootstrap-datepicker.js')}"></script>
	<link rel="stylesheet" href="${resource(dir:'js/lib/datepicker', file:'datepicker.css')}" />
	
	<script type="text/javascript" src="${resource(dir:'js/lib/dygraphs/1.1.0/dygraph-combined.min.js')}"></script>
	
	<link rel="stylesheet" href="${resource(dir:'css', file:'admin.css')}" />

	
	<g:layoutHead/>
	
	
<style type="text/css">	
	html,
	body{
		background:#F0FAF7;
		background:#f7fbfd;
	}
	#prospect-action-container{
		padding:30px;
	}
</style>	

</head>
<body>

	<div id="prospect-action-container">
		<g:layoutBody/>
	</div>
	
</body>
</html>
