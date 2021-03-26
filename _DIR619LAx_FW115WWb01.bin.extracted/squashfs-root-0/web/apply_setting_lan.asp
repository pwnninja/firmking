<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />
<link rel="stylesheet" rev="stylesheet" href="style.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="/<% getInfo("substyle");%>" type="text/css" />
<script language="JavaScript" type="text/javascript">
<!--
str=location.search;
str=str.substring(1,str.length);

var lang = "<% getLangInfo("lang");%>";
if(str != "" && str*1>=0 && str*1<=100)
{
	lang=str;
}
//-->
</script>
<script type="text/javascript" src="ubicom.js"></script>
<script type="text/javascript" src="xml_data.js"></script>
<script type="text/javascript" src="navigation.js"></script>
<% getLangInfo("LangPath");%>
<script type="text/javascript" src="utility.js"></script>
<script type="text/javascript">
//<![CDATA[

var no_reboot_alt_location = "";

function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function template_load()
{
var global_fw_minor_version = "<%getInfo("fwVersion")%>";
var fw_extend_ver = "";			
var fw_minor;
assign_firmware_version(global_fw_minor_version,fw_extend_ver,fw_minor);
var hw_version="<%getInfo("hwVersion")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = modelname;
page_load();
RenderWarnings();
}
var timeleft = 40;
function countdown()
{

document.getElementById("timeleft").innerHTML = timeleft;
if (timeleft === 0) {
top.location = '<%getInfo("last_url");%>?t='+new Date().getTime();
return;
}
timeleft--;
setTimeout(countdown, 1000);
}

function page_load() 
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtRebooting");
document.title = DOC_Title;				
countdown();
}
//]]>
</script>
</head>
<body onload="template_load();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody>
<tr>
<td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>
<td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">
<div id="maincontent_1col" style="display: block">
<div id="box_header">
<h1><SCRIPT >ddw("txtRebooting");</SCRIPT>...</h1>
<p class="centered">
<SCRIPT >ddw("txtPleaseWait");</SCRIPT>
<span id="timeleft"></span>&nbsp; 
<SCRIPT >ddw("txtSeconds");</SCRIPT>
</p>
<p><SCRIPT >ddw("txtRebootWarning");</SCRIPT></p>
</div>
</div>
</td>
<td id="sidehelp_container">&nbsp;</td>
</tr>
</table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr>
<td>
<img src="Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td>
<td>&nbsp;</td>
</tr>
</table>
</td>
</tr>
</tbody>
</table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
</html>
