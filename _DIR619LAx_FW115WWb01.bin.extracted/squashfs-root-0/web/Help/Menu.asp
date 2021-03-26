
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
<!-- InstanceBeginEditable name="Local Styles" -->
<style type="text/css">
#sidehelp_container {
display: block;
}
.section_head {
padding-bottom: 3px;
margin-bottom: 13px;
}
.box {
margin-top: 0;
padding-bottom: 3px;
}
</style>
<!-- InstanceEndEditable -->

	<script type="text/javascript" src="../ubicom.js"></script>
	<script type="text/javascript" src="../xml_data.js"></script>
	<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
<% getLangInfo("LangPathHelp");%>
<script type="text/javascript" src="../utility.js"></script>
	<script type="text/javascript">
	//<![CDATA[
var WLAN_ENABLED; 
var OP_MODE;
if('<%getInfo("opmode");%>' =='Disabled')
	OP_MODE='1';
else
	OP_MODE='0';
if('<%getIndexInfo("wlanDisabled");%>'=='Disabled')
	WLAN_ENABLED='0';
else
	WLAN_ENABLED='1';

/*
* Used by template.js.
* You cannot put this function in a sourced file, because SSI will not process it.
*/
function get_webserver_ssi_uri() {
return ("" !== "") ? "/Basic/Setup.asp" : "/Help/Menu.asp";
}
/** Perform initialization for items that belong to the DWT when page is loaded.*/
function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function template_load()
{
<% getFeatureMark("MultiLangSupport_Head_script");%>
lang_form = document.forms.lang_form;
if ("" === "") {
assign_i18n();
lang_form.i18n_language.value = "<%getLangInfo("langSelect")%>";
}
<% getFeatureMark("MultiLangSupport_Tail_script");%>
var global_fw_minor_version = "<%getInfo("fwVersion")%>";
var fw_extend_ver = "";			
var fw_minor;
assign_firmware_version(global_fw_minor_version,fw_extend_ver,fw_minor);
var hw_version="<%getInfo("hwVersion")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = modelname;
SubnavigationLinks(WLAN_ENABLED, OP_MODE);
topnav_init(document.getElementById("topnav_container"));
page_load();
RenderWarnings();
}

function page_load() {
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternet");
document.title = DOC_Title;
}
function buttoninit()
{
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");

}
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load();buttoninit();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr>
<td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>



<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr>

<td id="sidenav_container">
<div id="sidenav">
<SCRIPT >
DrawBasic_subnav();
DrawAdvanced_subnav();
DrawTools_subnav();
DrawStatus_subnav();
DrawHelp_subnav();
DrawEarth_onlineCheck(<%getWanConnection("");%>);
DrawRebootButton();
</SCRIPT>
</div>

<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >
DrawLanguageList();
</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td>

<td id="maincontent_container">
<SCRIPT >
DrawRebootContent();
</SCRIPT>

<div id="warnings_section" style="display:none">
<div class="section" >
<div class="section_head">
<h2>
<SCRIPT>ddw("txtConfigurationWarnings");</SCRIPT>
</h2>
<div style="display:block" id="warnings_section_content">
<!-- This division will be populated with configuration warning information -->
</div><!-- box warnings_section_content -->
</div>
</div>
</div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<div id="box_header">
<h1><SCRIPT>ddw("txtSupportMenu");</SCRIPT></h1>
<table width=75% border=0 cellspacing=0 cellpadding=0>
<tr><td><span class="style6"><SCRIPT>ddw("txtSetup");</SCRIPT></span></td></tr>
<tr><td width=600>
	<ul>
	<li><a href=Basic.asp#Internet target=_blank><font color=#000000><SCRIPT>ddw("txtInternetSetup1");</SCRIPT></font></a></li>
	<li><a href=Basic.asp#Wireless target=_blank><font color=#000000><SCRIPT>ddw("txtWirelessCONN");</SCRIPT></font></a></li>
	<li><a href=Basic.asp#Network target=_blank><font color=#000000><SCRIPT>ddw("txtLanSetting");</SCRIPT></font></a></li>
	<li><a href=Basic.asp#Time target=_blank><font color=#000000><SCRIPT >ddw("txtTime");</SCRIPT></font></a></li>
	<li><a href=Basic.asp#Web_Filter target=_blank><font color=#000000><SCRIPT>ddw("txtWebsiteFilteringRules");</SCRIPT></font></a></li>
	</ul>
</td></tr>
<tr><td><span class="style6"><SCRIPT>ddw("txtAdvanced");</SCRIPT></span></td></tr>
<tr><td>
	<ul>
	<li><a href=Advanced.asp#Advanced_Port target=_blank><font color=#000000><SCRIPT>ddw("txtVirtualServer");</SCRIPT></font></a></li>
	<li><a href=Advanced.asp#Special_Applications target=_blank><font color=#000000><SCRIPT>ddw("txtApplicationRules");</SCRIPT></font></a></li>
	<li><a href=Advanced.asp#MAC_Address_Filter target=_blank><font color=#000000><SCRIPT>ddw("txtMACAddressFilter");</SCRIPT></font></a></li>
	<li><a href=Advanced.asp#Traffic_Shaping target=_blank><font color=#000000><SCRIPT>ddw("txtQoSEngine");</SCRIPT></font></a></li>
	<li><a href=Advanced.asp#Firewall target=_blank><font color=#000000><SCRIPT>ddw("txtFirewall2");</SCRIPT></font></a></li>
	<li><a href=Advanced.asp#Advanced_Wireless target=_blank><font color=#000000><SCRIPT>ddw("txtAdvancedWirelessSettings");</SCRIPT></font></a></li>
	<li><a href=Advanced.asp#Network target=_blank><font color=#000000><SCRIPT>ddw("txtAdvancedNetworkSettings");</SCRIPT></font></a></li>
	<li><a href=Advanced.asp#Routing target=_blank><font color=#000000><SCRIPT>ddw("txtRouting");</SCRIPT></font></a></li>

	</ul>
</td></tr>
<tr><td><span class="style6"><SCRIPT>ddw("txtTools");</SCRIPT></span></td></tr>
<tr><td>
	<ul>
	<li><a href=Tools.asp#Admin target=_blank><font color=#000000><SCRIPT>ddw("txtDeviceAdmin1");</SCRIPT></font></a></li>
	<li><a href=Tools.asp#System target=_blank><font color=#000000><SCRIPT>ddw("txtSystemSettings");</SCRIPT></font></a></li>
	<li><a href=Tools.asp#Firmware target=_blank><font color=#000000><SCRIPT>ddw("txtFirmware");</SCRIPT></font></a></li>
	<li><a href=Tools.asp#Dynamic_DNS target=_blank><font color=#000000><SCRIPT>ddw("txtDDNS");</SCRIPT></font></a></li>
	<li><a href=Tools.asp#System_Check target=_blank><font color=#000000><SCRIPT>ddw("txtSystemCheck");</SCRIPT></font></a></li>
	<li><a href=Tools.asp#Schedules target=_blank><font color=#000000><SCRIPT>ddw("txtSchedules");</SCRIPT></font></a></li>
	<li><a href=Tools.asp#Log target=_blank><font color=#000000><SCRIPT>ddw("txtLogSettings");</SCRIPT></font></a></li>
	</ul>
</td></tr>
<tr><td><span class="style6"><SCRIPT>ddw("txtState");</SCRIPT></span></td></tr>
<tr><td>
	<ul>
	<li><a href=Status.asp#Device_Info target=_blank><font color=#000000><SCRIPT>ddw("txtDeviceInfo");</SCRIPT></font></a></li>
	<li><a href=Status.asp#Logs target=_blank><font color=#000000><SCRIPT>ddw("txtViewLogs");</SCRIPT></font></a></li>
	<li><a href=Status.asp#Statistics target=_blank><font color=#000000><SCRIPT>ddw("txtTrafficStatistics");</SCRIPT></font></a></li>
	<li><a href=Status.asp#Internet_Sessions target=_blank><font color=#000000><SCRIPT>ddw("txtInternetSessions2");</SCRIPT></font></a></li>
	<li><a href=Status.asp#Wireless target=_blank><font color=#000000><SCRIPT>ddw("txtWireless");</SCRIPT></font></a></li>
	</ul>
</td></tr>
</table>
</div>
<!-- InstanceBeginEditable name="Main Content" -->

<!-- InstanceEndEditable -->
</div>
</td>

<td id="sidehelp_container" height="580">
<div id="help_text">
	<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<!-- InstanceBeginEditable name="Help_Text" --> 
<!-- InstanceEndEditable -->
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
</div><!-- outside -->
</body>
<!-- InstanceEnd -->

</html>
