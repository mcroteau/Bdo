<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<%@page import="io.seal.SalesAction"%>
<%@page import="io.seal.Account%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="prospect_action">
	<title>Add Sales Action</title>	
</head>
	
<body>
<div class="form-outer-container">
	
	<div class="form-container">
		
		<div class="messages">
		
			<g:if test="${flash.message}">
				<div class="alert alert-warning" role="status">${raw(flash.message)}</div>
			</g:if>
			
		</div>
		
		<h2>Add Sales Action</h2>
		

		<br class="clear"/>
		
		
		<g:form action="save" class="form-horizontal" role="form" method="post">

			
			<input type="hidden" name="id" value="${prospectInstance.id}"/>
			
			
			<div class="form-row">
			  	<label for="country" class="form-label half">Sales Action</label>
				<span class="input-container">
					<g:select name="salesAction.id"
							from="${SalesAction.list()}"
							value="${prospectSalesActionInstance?.salesAction?.id}"
							optionKey="id" 
							optionValue="name"
							class="form-control twofifty"
							id="salesActionSelect"
							style="width:225px;"/>
				</span>
				<br class="clear"/>
			</div>
			

			<div class="form-row">
				<span class="form-label half">Action Date</span>
				<span class="input-container">
					<input type="text" name="actionDate" value="${presetActionDate}" class="form-control" 
						id="action-date" placeholder="click to select date"/>
				</span>
				<br class="clear"/>
			</div>

			
			<div class="form-row">
				<span class="form-label half">Time</span>
				<span class="input-container">
					<input type="text" name="hours" value="" class="form-control" placeholder="0-23" 
							style="width:75px;float:left"/>

					<span style="float:left;display:inline-block;width:20px;text-align:center">:</span>
					<input type="text" name="minutes" value="" class="form-control" placeholder="0-59" style="width:75px;float:left"/>
				</span>
				<br class="clear"/>
			</div>

			
			<input type="hidden" name="reminder" value="false" id="reminder-input">
			
			<div class="form-row">
				<span class="form-label half">Reminder</span>
				<span class="input-container">
					<select name="reminderTime" class="form-control" id="reminder-time">
						<option value="0">No reminder</option>
						<option value="5">5 Mins</option>
						<option value="15">15 Mins</option>
						<option value="30">30 Mins</option>
						<option value="60">1 Hour</option>
						<option value="720">12 Hours</option>
						<option value="1440">24 Hours</option>
						<option value="2880">2 Days</option>
					</select>
				</span>
				<br class="clear"/>
			</div>
			
			
			<div class="form-row">
				<span class="form-label half hint">Notes
					<span class="information secondary" style="display:block"></span>	
				</span>
				
				<span class="input-container">
					<textarea  name="note" id="note" class="form-control" style="height:150px; width:380px;">${prospectSalesActionInstance?.note}</textarea>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			<div class="form-row" style="display:none" id="salesman-select">
			  	<label for="account" class="form-label half">Salesman</label>
				<span class="input-container">
					<g:select name="account.id"
							from="${io.seal.Account.list()}"
							value="${prospectSalesActionInstance?.account?.id}"
							optionKey="id" 
							optionValue="name"
							class="form-control fourhundred"
							id="salesmanSelect"
							style="width:225px;"
							noSelection="['':'All Salesman']"/>
				</span>
				<br class="clear"/>
			</div>
			
			
			
			<div class="buttons-container">	
				<a href="javascript:window.close()" style="display:inline-block;margin-right:10px;">Close</a>
				<g:submitButton name="create" class="btn btn-primary" value="Add Sales Action" />		
				<br class="clear"/>
			</div>
			
		</g:form>

	</div>

</div>	



<script type="text/javascript">
	$(document).ready(function(){
		var $actionDate = $("#action-date"),
			$reminder = $("#reminder-input"),
			$reminderTime = $("#reminder-time"),
			$salesmanSelect = $("#salesman-select");
		
		$actionDate.datepicker({autoclose: true});	
		
		$reminderTime.change(function(event){
			var value = $reminderTime.val()
			if(value > 0){
				$salesmanSelect.show()
				$reminder.val("true")
			}else{
				$salesmanSelect.hide()
				$reminder.val("false")
			}
		})	
	})
</script>

</body>
</html>
