<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
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
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
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

/* Used by template.js.You cannot put this function in a sourced file, because SSI will not process it.*/
function get_webserver_ssi_uri() 
{
return ("" !== "") ? "/Basic/Setup.asp" : "/Advanced/Network.asp";
}

/* Perform initialization for items that belong to the DWT when page is loaded.*/
function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function template_load()
{
<% getFeatureMark("MultiLangSupport_Head_script");%>
lang_form = document.forms.lang_form;
if ("" === ""){
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

/* This script is to be SSI included in an HTML page. It defines ingress filter options to be added to a select list, provides a function to populate <select>'s and a function that return a filter's details. */
var ingress_filter_options = [
<%dumpInboundFilterList();%>
];

/* ingress_filter_details()	Return a string describing the currently selected ingress filter in a specified <select>.*/
function ingress_filter_details(select_id)
{
var str = "";
var idx = select_id.selectedIndex;

if (idx === 0 || idx === 1) {
return select_id.options[idx].text;
}

/* 0=Allow, 1=Deny */
if (ingress_filter_options[idx].action === "0") {
str = sw("txtAllow");
} else {
str = sw("txtDeny");
}

for (var i = 0; i < ingress_filter_options[idx].ipranges.length; i++) {
/* Overrun may occurs in an array if there is a comma but no ending elements. */
if (!ingress_filter_options[idx].ipranges[i]) {
break;
}

ipstart = ingress_filter_options[idx].ipranges[i].ipstart;
ipend = ingress_filter_options[idx].ipranges[i].ipend;

if (i > 0) {
str += ", ";
}

if (ipstart == "0.0.0.0" && ipend == "255.255.255.255") {
str += "All";
} else if (ipstart == ipend) {
str += ipstart;
} else {
str += ingress_filter_options[idx].ipranges[i].ipstart + "-" + ingress_filter_options[idx].ipranges[i].ipend;
}

}

return str;
}

/* For debuging the page on a local client. This variable will be TRUE if this page is loaded locally in a browser, and FALSE if this page is loaded from a live gateway,*/
var local_debug = ("" == "") ? false : true;

/* Will be set to "true" if a reboot is needed after saving settings.*/
var verify_failed = "<%getInfo("err_msg")%>";

/* Handle for document.form["mainform"]. */
var mf;

function upnp_enabled_selector(value)
{
if(value==true)	
	mf.upnp_enabled.value = "1";
else
	mf.upnp_enabled.value = "0";
mf.upnp_enabled_select.checked = value;
}

function allow_ipv6Passthru_selector(value)
{
	if(value==-1)
	{
		mf.ipv6Passthru_select.value = 0;
		mf.ipv6Passthru.checked = false;
		mf.ipv6Passthru.disabled=true;
		return;
	}
	if(value==true || value==1)
	{
		mf.ipv6Passthru.checked = true;
		mf.ipv6Passthru_select.value = 1;
	}
	else
	{
		mf.ipv6Passthru.checked = false;
		mf.ipv6Passthru_select.value = 0;
	}
}

function allow_wan_ping_selector(value)
{
if(value==true)
	mf.allow_wan_ping.value = "1";
else
	mf.allow_wan_ping.value = "0";
mf.allow_wan_ping_select.checked = value;
}

function wan_ping_ingress_filter_name_selector(value)
{
if(value==true)	
	mf.wan_ping_ingress_filter_name.value = "1";
else
	mf.wan_ping_ingress_filter_name.value = "0";
mf.wan_ping_ingress_filter_name_select.value = value;
}

function wan_link_speed_select_selector(value)
{
	
mf.wan_link_speed_select.value = value;
mf.wan_link_speed_select_select.value = value;
}

function lan_use_igmp_proxy_selector(value)
{
if(value==true)	
	mf.lan_use_igmp_proxy.value = "1";
else
	mf.lan_use_igmp_proxy.value = "0";
mf.lan_use_igmp_proxy_select.checked = value;
}
function wlan_use_M2U_selector(value)
{
if(value==true)
	mf.wlan_use_M2U.value = "1";
else
	mf.wlan_use_M2U.value = "0";
mf.wlan_use_M2U_select.checked = value;
}
function page_load() {

displayOnloadPage("<%getInfo("ok_msg")%>");

mf = document.forms["mainform"];
if (local_debug) {
hide_all_ssi_tr();
upnp_enabled_selector(true);
allow_wan_ping_selector(false);
lan_use_igmp_proxy_selector(true);
wan_link_speed_select_selector("100");
return;
}

wan_link_speed_select_selector(mf.wan_link_speed_select.value);
allow_ipv6Passthru_selector(mf.ipv6Passthru_select.value);

upnp_enabled_selector(mf.upnp_enabled.value == "1");
allow_wan_ping_selector(mf.allow_wan_ping.value == "1");
lan_use_igmp_proxy_selector(mf.lan_use_igmp_proxy.value == "1");
wlan_use_M2U_selector(mf.wlan_use_M2U.value=="1");

set_form_default_values("mainform");


/* Check for validation errors. */
if (verify_failed != "") {
alert(verify_failed);
verify_failed = "";
}
}

function page_submit(){
if (!is_form_modified("mainform"))  //nothing changed
{
if (!confirm(sw("txtSaveAnyway"))) 				
return false;
}
else
{
mf["settingsChanged"].value = 1;				
}

mf.submit();
}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtAdvanced")+'/'+sw("txtAdvancedNetworkSettings");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");	
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");			

}
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load(); init();web_timeout();">
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
<SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT>
</h2>
<div style="display:block" id="warnings_section_content">
</div><!-- box warnings_section_content -->
</div>
</div>
</div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<form name="mainform" action="/goform/formAdvNetwork" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section">
<div class="section_head"> 
<h2><SCRIPT >ddw("txtAdvancedNetworkSettings");</SCRIPT></h2>
<p><SCRIPT >ddw("txtAdvNetworkStr1");</SCRIPT></p>
<SCRIPT language=javascript>DrawSaveButton();</SCRIPT>
</div>
<div class="box" id="upnp_box">
<h3>UPnP</h3>
<p class="box_msg"><SCRIPT >ddw("txtAdvNetworkStr2");</SCRIPT></p>
<fieldset>
<p> 
<label class="duple">
<SCRIPT >ddw("txtEnableUPnP");</SCRIPT>
&nbsp;:</label>
<input type="hidden" id="upnp_enabled" name="upnp_enabled" value="<%getIndexInfo("upnpEnabled");%>"/>
<input type="checkbox" id="upnp_enabled_select" onclick="upnp_enabled_selector(this.checked);"/>
</p>
</fieldset>
</div>
<div class="box" id="wan_ping_box">
<h3>WAN Ping</h3>
<p class="box_msg"><SCRIPT >ddw("txtAdvNetworkStr3");</SCRIPT></p>
<fieldset id="allow_wan_ping_fieldset">
<p> 
<label class="duple">
<SCRIPT >ddw("txtEnableWANPingRespond");</SCRIPT>
&nbsp;:</label>
<input type="hidden" id="allow_wan_ping" name="allow_wan_ping" value="<%getIndexInfo("pingWanAccess");%>"/>
<input type="checkbox" id="allow_wan_ping_select" onclick="allow_wan_ping_selector(this.checked);"/>
</p>

</fieldset>
</div>
<div class="box">
<h3><SCRIPT >ddw("txtWANPortSpeed");</SCRIPT></h3>
<fieldset>
<p>
<input type="hidden" id="wan_link_speed_select" name="wan_link_speed_select" value="<%getInfo("wanForceSpeed");%>"/>
<select id="wan_link_speed_select_select" onchange="wan_link_speed_select_selector(this.value);">
<option value="10">10Mbps </option>
<option value="100">100Mbps</option>
<%getInfo("gigaLanSupport_Head");%>
<option value="101">1000Mbps</option>
<%getInfo("gigaLanSupport_Tail");%>
<option value="0">
10/100<%getInfo("gigaLanSupport_Head");%>/1000<%getInfo("gigaLanSupport_Tail");%>Mbps&nbsp;<SCRIPT >ddw("txtAuto");</SCRIPT></option>
</select>
</p>
</fieldset>
</div>

<div class="box" style="display:none">
<h3><SCRIPT >ddw("txtIPv6Passthru");</SCRIPT></h3>
<fieldset>
<p>
<label class="duple" for="upnp_enabled_select">
<SCRIPT >ddw("txtEnable");</SCRIPT>
&nbsp;IPv6 Passthrough:</label>
<input type="hidden" id="ipv6Passthru_select" name="ipv6Passthru_select" value="<%getInfo("ipv6Passthru");%>"*1/>
<input type="checkbox" id="ipv6Passthru" onclick="allow_ipv6Passthru_selector(this.checked);"/>
</p>
</fieldset>
</div>

<div class="box" id="multicast_streams_box"> 
<h3><SCRIPT >ddw("txtMulticastStreams");</SCRIPT></h3>
<fieldset>
<p><label class="duple"><SCRIPT >ddw("txtEnableMulticastStreams");</SCRIPT>&nbsp;:</label>
<input type="hidden" id="lan_use_igmp_proxy" name="lan_use_igmp_proxy" value="<%getIndexInfo("igmpProxyEnabled");%>"/>
<input type="checkbox" id="lan_use_igmp_proxy_select" onclick="lan_use_igmp_proxy_selector(this.checked);"/>
</p>
</fieldset>
<fieldset>
<p>
<input type="hidden" id="wlan_use_M2U" name="wlan_use_M2U" value="<%getIndexInfo("wlanEnhanceEnabled");%>"/>	
<label class="duple"><SCRIPT >ddw("txtEnableWlanEnhance");</SCRIPT>&nbsp;:</label>
<input type="checkbox" id="wlan_use_M2U_select" onclick="wlan_use_M2U_selector(this.checked);"/>
</p>
</fieldset>
</div>

</form><SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>
</div>
</td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtAdvNetworkStr4");</SCRIPT></p>
<p><SCRIPT >ddw("txtAdvNetworkStr5");</SCRIPT></p>
<p><SCRIPT >ddw("txtAdvNetworkStr6");</SCRIPT></p>
<p><SCRIPT >ddw("txtAdvNetworkStr7");</SCRIPT></p>										<p class="more">
<p><SCRIPT >ddw("txtStpDisc_hints");</SCRIPT></p>										<p class="more">
<a href="../Help/Advanced.asp#Network" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a></p>
</div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr>
<td><img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" /></td>
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
