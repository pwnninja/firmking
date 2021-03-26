<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />
<link rel="stylesheet" rev="stylesheet" href="../style.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="../<% getInfo("substyle");%>" type="text/css" />
<script language="JavaScript" type="text/javascript">
<!--
var lang = "<% getLangInfo("lang");%>";
//-->
</script>
<style type="text/css">
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[
var no_reboot_alt_location = "";

function do_reboot()
{
	document.forms["rebootdummy"].next_page.value="../index.asp";
	document.forms["rebootdummy"].act.value="do_reboot";
	document.forms["rebootdummy"].submit();
}
function no_reboot()
{
	document.forms["rebootdummy"].next_page.value="Tools/System.asp?t="+new Date().getTime();
	document.forms["rebootdummy"].submit();
}
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
document.getElementById("loader_container").style.display = "none";
}
//]]>
</script>
<script language="JavaScript" type="text/javascript">
//<![CDATA[

var timeleft = 5;

function do_back()
{
if (window.name.substr(0,4)=="55aa") {
location.replace(window.name.substr(4));
} else {
history.back();
}
}

function countdown()
{
if (timeleft) {
timeleft--;
setTimeout("countdown()", 1000);
return;
}
do_back();
}

function page_load() {

var DOC_Title= sw("txtTitle")+" : "+sw("txtRestoreStr2");
document.title = DOC_Title;	
document.getElementById("timeleft").innerHTML = timeleft;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
displayOnloadPage("<%getInfo("ok_msg")%>");
}
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td><td id="maincontent_container">
<SCRIPT >DrawRebootContent();</SCRIPT>
<div id="maincontent" style="display: block">
<form id="dummy" name="dummy" action="#" method="get">
<div class="section"><div class="section_head">
<h2>Restore Succeeded</h2>
<p>The restored configuration file has been uploaded successfully.</p>
<p>
Press the button below to continue configuring the router
if the previous page doesn't restore in <span id="timeleft"></span>&nbsp;seconds.
</p><p><!--<input type="button" class="button_submit" value="Continue" onclick="location.replace('~@~')"/>-->
<input type="button" class="button_submit" value="Continue" onclick="do_back()" />
</p></div></div></form>
<!-- InstanceEndEditable --></div>
</td><td id="sidehelp_container">&nbsp;</td>
</tr></table>	<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
