<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />
<META http-equiv=Pragma content=no-cache >
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
<link rel="stylesheet" rev="stylesheet" href="../style.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="../<% getInfo("substyle");%>" type="text/css" />
<script language="JavaScript" type="text/javascript">
<!--
var lang = "<% getLangInfo("lang");%>";
//-->
</script>

<style type="text/css">

#sidehelp_container {
display: none;
}
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
<% getLangInfo("LangPathHelp");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[


function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function template_load()
{
page_load();
RenderWarnings();
var wifisc_hidden="<%getIndexInfo("wsc_hidden");%>";
if(wifisc_hidden == 1)
{
	document.getElementById("basic_help").innerHTML = "";
}
else
{
	document.getElementById("basic_help").innerHTML = sw("txtBasicHp01_2");
	document.getElementById("basic_help_1").innerHTML = sw("txtBasicHp01_4");
	document.getElementById("basic_help_1").innerHTML = sw("txtBasicHp01_6");
}

}

function page_load() {
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternet");
document.title = DOC_Title;
}
//]]>
</script>
</head>
<body onload="template_load();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr>
<td>

<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr>	

<td id="maincontent_container">

<div id="maincontent" style="display: block">
<SCRIPT >ddw("txtBasicHp01");ddw("txtBasicHp01_3");</SCRIPT><span id="basic_help_1"></span><span id="basic_help"></span><SCRIPT >ddw("txtBasicHp01_5");</SCRIPT><span id="basic_help_2"></span><SCRIPT >ddw("txtBasicHp01_7");</SCRIPT>
</div>

</td>

<td id="sidehelp_container">
<div id="help_text">
</div>
</td>

</tr>
</table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr>
<td>
<img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td>
<td>&nbsp;

</td>
</tr>
</table>
</td>
</tr>
</table>

<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
</html>
