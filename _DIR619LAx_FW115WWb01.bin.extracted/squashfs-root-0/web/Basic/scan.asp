<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=gb2312" />
<link rel="STYLESHEET" type="text/css" href="../style.css">
<script language="JavaScript" type="text/javascript">
<!--
var lang = "0";
//-->
</script>	
<% getLangInfo("LangPath");%>
<script language="JavaScript">
	//<![CDATA[  
function run_sitesurvey()
{
	mf = document.forms["mainform"];
	mf.curTime.value = new Date().getTime();
	document.forms[0].submit();
}

//]]>
</script>
</head>
<body onload="run_sitesurvey();">
<form id="mainform" action="/goform/formWlSiteSurvey"  method="post" name="mainform">
<input type="hidden" value="refresh" name="refresh">
<input type="hidden" value="SiteSurveytbl.asp" name="submit-url">
<input type="hidden" id="curTime" name="curTime" value=""/>
Scanning available network...
</form>
</body>
</html>
