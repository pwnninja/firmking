<html>
<head>	
<!--<link rel="stylesheet" href="/router.css" type="text/css">-->
</head>
<script text="text/script">

function ClickMenu(num)
{
	var Ssid = parent.document.getElementById("ssid");
	var SSIDString = document.getElementById("ck_ssid"+num).value;
	var Select = parent.document.getElementById("select");
	var SelString = "sel"+num;	

	if(Ssid != null)
    {
        Ssid.value = SSIDString;
    }
    
	if(SelString != null)
    {
		Select.value = SelString;
    }    
}

function Submit()
{
	document.getElementById("formWlSiteSurvey").submit();
}

function send_ssid(sendValue)
{

parent.document.getElementById("formWlan").ssid.value = sendValue;

}

</script>
<body>
<form action=/goform/formWlSiteSurvey method=POST name="formWlSiteSurvey" id="formWlSiteSurvey" name="formWlSiteSurvey">
<input type="hidden" value="/wlsurvey.asp" name="submit-url">
<input type="submit" value="Refresh" name="refresh" style="display:none">
<table border="1">

<%wlSiteSurveyTbl();%>

</table>
</form>
</body>
</html>