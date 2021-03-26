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
<style type="text/css">
fieldset label.duple {
width: 203px;
}
</style>
<!-- InstanceEndEditable -->
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
function do_reboot()
{
	document.forms["rebootdummy"].next_page.value="index.asp";
	document.forms["rebootdummy"].act.value="do_reboot";
	document.forms["rebootdummy"].submit();
}


function get_webserver_ssi_uri() {
			return ("" !== "") ? "/Basic/Setup.asp" : "/Tools/Log_dnsquery.asp";
}
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
var productModel="<%getInfo("productModel")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = productModel;
SubnavigationLinks(WLAN_ENABLED, OP_MODE);
topnav_init(document.getElementById("topnav_container"));
page_load();
RenderWarnings();
}
//]]>
</script>
<script type="text/javascript">
//<![CDATA[
var mf;
	function page_load()
	{
			mf = document.forms.mainform;
			mf.enable_log_dnsquery.value = "<%getInfo("enableLogDnsquery");%>";
			mf.enable_log_opt.value = "<%getInfo("enableLogOpt");%>";
			mf.enable_log_user.value = "<%getInfo("enableLogUser");%>";
			mf.enable_log_fwup.value = "<%getInfo("enableLogFwup");%>";
			mf.enable_log_wire.value = "<%getInfo("enableLogWire");%>";
			mf.enable_trigger_event.value = "<%getInfo("enableTriggerEvent");%>";
	}

function page_submit()
{
	mf.curTime.value = new Date().getTime();

	if (!is_form_modified("mainform") && !confirm(sw("txtSaveAnyway"))) {
			return false;
	}

	if (is_form_modified("mainform")){  //something changed
		mf.settingsChanged.value = 1;
	}
		mf.submit();
}
function enable_log_dnsquery_selector(value)
{
	mf.enable_log_dnsquery.value = value;
	mf.enable_log_dnsquery_checkbox.checked = value;
}
function enable_log_opt_selector(value)
{
	mf.enable_log_opt.value = value;
	mf.enable_log_opt_checkbox.checked = value;

	mf.log_user_checkbox.disabled = (value == false);
	mf.log_fwup_checkbox.disabled = (value == false);
	mf.log_wire_checkbox.disabled = (value == false);

}
function log_opt_User_selector(value)
{
	mf.enable_log_user.value = value;
	mf.log_user_checkbox.checked = value;
}
function log_opt_Fwupgrade_selector(value)
{
	mf.enable_log_fwup.value = value;
	mf.log_fwup_checkbox.checked = value;
}
function log_opt_Wirelesswarn_selector(value)
{
	mf.enable_log_wire.value = value;
	mf.log_wire_checkbox.checked = value;
}
function enable_trigger_event_selector(value)
{
	mf.enable_trigger_event.value = value;
	mf.enable_trigger_event_checkbox.checked = value;
}
function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtTools")+'/'+sw("txtEventSettings");
	document.title = DOC_Title;	
	document.getElementById("DontSaveSettings").value=	sw("txtDontSaveSettings");		
	document.getElementById("SaveSettings").value=	sw("txtSaveSettings");
	get_by_id("RestartNow").value = sw("txtRebootNow");
	get_by_id("RestartLater").value = sw("txtRebootLater");
	enable_log_dnsquery_selector(mf.enable_log_dnsquery.value == "true");
	enable_log_opt_selector(mf.enable_log_opt.value == "true");
	log_opt_User_selector(mf.enable_log_user.value == "true");
	log_opt_Fwupgrade_selector(mf.enable_log_fwup.value == "true");
	log_opt_Wirelesswarn_selector(mf.enable_log_wire.value == "true");
	enable_trigger_event_selector(mf.enable_trigger_event.value == "true")
}
function page_cancel()
{
	page_load();
	init();
}

	//]]>
	</script>
	<!-- InstanceEndEditable -->
</head>
<body onload="template_load(); init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr><td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr><td id="sidenav_container">
<div id="sidenav"><SCRIPT >
DrawBasic_subnav();
DrawAdvanced_subnav();
DrawTools_subnav();
DrawStatus_subnav();
DrawHelp_subnav();
DrawEarth_onlineCheck(<%getWanConnection("");%>);
DrawRebootButton();
</SCRIPT></div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td>
<td id="maincontent_container">
<SCRIPT >
DrawRebootContent();
</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" >
<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div><!-- box warnings_section_content -->
</div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
<form id="mainform" name="mainform" action="/goform/formLogDnsquery" method="post">
	<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
	<input type="hidden" id="curTime" name="curTime" value=""/>
<div class="section">
<div class="section_head">
<h2><SCRIPT >ddw("txtEventSettings");</SCRIPT></h2>
<br>
<p></p>
<br>
<input class="button_submit" type="button" id="SaveSettings" name="SaveSettings" value="" onclick="page_submit()"/>
<input class="button_submit" type="button" id="DontSaveSettings"  name="DontSaveSettings" value="" onclick="page_cancel()"/>
</div></div>

<div class="box" id="remote_administration_box">
<h3><SCRIPT >ddw("txtLogdnsquery");</SCRIPT></h3>
<fieldset id="remote_administration_fieldset">
<p>
<label class="duple" >
<SCRIPT >ddw("txtEnable");</SCRIPT>
&nbsp;:</label>
<input type="hidden" id="enable_log_dnsquery" name="config.enable_log_dnsquery"  value="<%getInfo("enableLogDnsquery");%>" />
<input type="checkbox" id="enable_log_dnsquery_checkbox" onclick="enable_log_dnsquery_selector(this.checked)" />
</p>
</fieldset></div>

<div class="box">
<h3><SCRIPT >ddw("txtLogopts");</SCRIPT></h3>
<fieldset>
<p>
<label class="duple" >
<SCRIPT >ddw("txtEnable");</SCRIPT>
&nbsp;:</label>
<input type="hidden" id="enable_log_opt" name="config.enable_log_opt"  value="<%getInfo("enableLogOpt");%>" />
<input type="checkbox" id="enable_log_opt_checkbox" onclick="enable_log_opt_selector(this.checked)" />
</p>
</fieldset>
<table cellSpacing=1 cellPadding=2 width=525 align="center">
<tr>
	<td class=l_tb><input type="hidden" id="enable_log_user" name="config.enable_log_user" value="<%getInfo("enableLogUser");%>">
		<input type=checkbox id=log_user_checkbox onclick="log_opt_User_selector(this.checked);"></td>
	<td class=l_tb><SCRIPT >ddw("txtUserloginfo");</SCRIPT></td>
	<td class=l_tb><input type="hidden" id="enable_log_fwup" name="config.enable_log_fwup" value="<%getInfo("enableLogFwup");%>">
		<input type=checkbox id=log_fwup_checkbox onclick="log_opt_Fwupgrade_selector(this.checked);"></td>
	<td class=l_tb><SCRIPT >ddw("txtFwupgrade");</SCRIPT></td>
	<td class=l_tb><input type="hidden" id="enable_log_wire" name="config.enable_log_wire" value="<%getInfo("enableLogWire");%>">
		<input type=checkbox id=log_wire_checkbox onclick="log_opt_Wirelesswarn_selector(this.checked);"></td>
	<td class=l_tb><SCRIPT >ddw("txtWirelesswarn");</SCRIPT></td>
</tr>
</table>
</div>

<div class="box">
<h3><SCRIPT >ddw("txtTriggerEvent");</SCRIPT></h3>
<fieldset>
<p>
<label class="duple" >
<SCRIPT >ddw("txtEnable");</SCRIPT>
&nbsp;:</label>
<input type="hidden" id="enable_trigger_event" name="config.enable_trigger_event"  value="<%getInfo("enableTriggerEvent");%>" />
<input type="checkbox" id="enable_trigger_event_checkbox" onclick="enable_trigger_event_selector(this.checked)" />
</p>
</fieldset></div>
<!--@ENDOPTIONAL@-->
</form><!-- InstanceEndEditable --></div></td>
<td id="sidehelp_container">
<div id="help_text">
<!-- InstanceBeginEditable name="Help_Text" -->
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p class="more">
<!-- Link to more help -->
<a href="../Help/Tools.asp#Admin" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>										</p>
<!-- InstanceEndEditable -->
</div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
<SCRIPT >print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>

