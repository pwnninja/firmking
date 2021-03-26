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

/*
* Used by template.js.
* You cannot put this function in a sourced file, because SSI will not process it.
*/
function get_webserver_ssi_uri() {
		return ("" !== "") ? "/Basic/Setup.asp" : "/Tools/SysLog.asp";
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
//]]>
</script>
<!-- InstanceBeginEditable name="Scripts" -->
<script language="JavaScript" type="text/javascript">
//<![CDATA[
/** Will be set to "true" if a reboot is needed after saving settings. */
/** Check for validation errors. */
		var verify_failed = "<%getInfo("err_msg")%>";
/** Handle for document.form["mainform"].*/
		var mf;
/** Used for Retrieving a list of computer information from an xml doc */
		var computer_list_xslt_processor;
		var computer_list_retriever;
		var is_computer_list_ready = false;
		var is_computer_list_xslt_ready = false;
		var computer_list_xml_data;
/** Disable or enable buttons, text fields */
function log_to_syslog_selector(value)
{
	mf.log_to_syslog_select.checked = (value == true);
	mf.log_to_syslog.value = value;
	mf.computer_list_ipaddr_select.disabled = (value == false);
	mf.log_syslog_addr.disabled = (value == false);
	document.getElementById("log_syslog_addr_section").style.display = (value == false) ? "none" : "block";
}
/* *  Set the syslog server IP address */
function log_syslog_addr_selector(value)
{
	mf.log_syslog_addr.value = value;
}
function computer_list_ipaddr_selector(value)
{
	if (value != -1) {
		log_syslog_addr_selector(value);
	}
		mf.computer_list_ipaddr_select.value = -1;
}
function populate_computer_list()
{
    if (!(is_computer_list_ready && is_computer_list_xslt_ready)) {
                     return;
     }
var parent = document.getElementById("xsl_span_computer_list_ipaddr_select");
/** Clear existing pulldown list*/
while (parent.firstChild != null) {
	parent.removeChild(parent.firstChild);
}
computer_list_xslt_processor.transform(computer_list_xml_data, window.document, parent);
copy_select_options(mf.computer_list_ip_address_pulldown, mf.computer_list_ipaddr_select);
/*
 *  Set attribute to the translated select element: "modified" = "ignore"
 *       We skip it when checking for changes on the form and for restoring form settings
 */
mf.computer_list_ipaddr_select.setAttribute("modified", "ignore");
}
function computer_list_xslt_ready(dataInstance)
{
    is_computer_list_xslt_ready = true;
    populate_computer_list();
}
function computer_list_ready(dataInstance)
{
/** Re-set the computer list dropdown with our latest computer information */
computer_list_xml_data = dataInstance.getDocument();
is_computer_list_ready = true;
populate_computer_list();
/** Restart the retrieval*/
	window.setTimeout("computer_list_retriever.retrieveData()", 20000);
}

function computer_list_timeout(dataInstance)
{
/** Keep trying, but less often*/
window.setTimeout("computer_list_retriever.retrieveData()", 60000);
}
function computer_list_xslt_timeout(dataInstance)
{
	window.setTimeout("computer_list_xslt_processor.retrieveData()", 20000);
}
function page_verify()
{
	if (mf.log_to_syslog.value == "true") {
		var lan_network_address = "<% getInfo("ip-rom"); %>";
		var syslog_ipaddr = mf.log_syslog_addr.value;
		if (!is_ipv4_valid(syslog_ipaddr)) {
			alert(sw("txtIPaddressInvalid"));
			return 0;
		}
		var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
		var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");
		var tarIp = ipv4_to_unsigned_integer(mf.log_syslog_addr.value);		
		if ((tarIp & LAN_MASK) !== (LAN_IP & LAN_MASK))
		{
		
			alert(sw("txtInvalidSysLogIpAddress"));
			return 0;
		}
	}
	return 1;
}
function page_load()
{
	/*
	 * For debuging the page on a local client.
	 *	This variable will be TRUE if this page is loaded locally in a browser,
	 *	and FALSE if this page is loaded from a live gateway,
	 */
	var local_debug = false ;
	mf = document.forms["mainform"];
	if (local_debug) {
		hide_all_ssi_tr();
		log_to_syslog_selector(false);
		log_syslog_addr_selector("0.0.0.0");
		return;
	}
	if (!computer_list_xslt_processor) {
		computer_list_xslt_processor = new xsltProcessingObject(computer_list_xslt_ready, computer_list_xslt_timeout, 6000, "../computer_ipaddr_list.xsl");
	}
	if (!computer_list_retriever) {
		computer_list_retriever = new xmlDataObject(computer_list_ready, computer_list_timeout, 20000, "../dhcp_clients.asp");
	}
	computer_list_retriever.retrieveData();
	computer_list_xslt_processor.retrieveData();
	log_to_syslog_selector(mf.log_to_syslog.value == "true");
	log_syslog_addr_selector(mf.log_syslog_addr.value);
/* Check for validation errors. */
	if (verify_failed != "") {
		set_form_always_modified("mainform");
		alert(verify_failed);
		return;
	}
	set_form_default_values("mainform");
}
/** Validate and submit the form.*/
function page_submit()
{
	mf.curTime.value = new Date().getTime();
	if (!is_form_modified("mainform") && !confirm(sw("txtSaveAnyway"))) {
		return false;
	}
	if (page_verify()) {
		mf.submit();
	}
}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtTools")+'/'+sw("txtSysLog");
document.title = DOC_Title;	
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");
}
//]]>
</script><!-- InstanceEndEditable --></head>
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside"><table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr>	<td><SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr><td id="sidenav_container"><div id="sidenav">
<SCRIPT >
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
</td><td id="maincontent_container">
<SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" ><div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
<!-- This division will be populated with configuration warning information -->
</div><!-- box warnings_section_content --></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
<form name="mainform" action="/goform/formSetSysLog" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
	<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
	<input type="hidden" id="curTime" name="curTime" value=""/>
<div class="section">
<div class="section_head"> 
<h2><SCRIPT >ddw("txtSysLog");</SCRIPT></h2>
<p><SCRIPT >ddw("txtSysLogStr1");</SCRIPT></p>
<input class="button_submit" type="button" id="SaveSettings" name="SaveSettings" value="" onclick="page_submit()"/>
<input class="button_submit" type="button" id="DontSaveSettings" name="DontSaveSettings" value="" onclick="page_cancel()"/>
</div>
<div class="box">
<h3><SCRIPT >ddw("txtSysLogSettings");</SCRIPT></h3>
<fieldset><p>	<label class="duple" for="log_to_syslog_select">
<SCRIPT >ddw("txtEnableLoggingToSyslogServer");</SCRIPT>
&nbsp;:</label>
<input type="checkbox" id="log_to_syslog_select" onclick="log_to_syslog_selector(this.checked);"/>
<input type="hidden" id="log_to_syslog" name="config.log_to_syslog" value="<% getIndexInfo("logserveren"); %>"/>
</p>
<p id="log_syslog_addr_section">
<label class="duple" for="log_syslog_addr">
<SCRIPT >ddw("txtSyslogServerIPAddress");</SCRIPT>
&nbsp;:</label>
<input type="text" id="log_syslog_addr" name="config.log_syslog_addr" size="20" maxlength="15" disabled="disabled" value="<% getIndexInfo("logserver"); %>" />&nbsp;&lt;&lt;&nbsp;
<span id="xsl_span_computer_list_ipaddr_select" style="display:none"></span>
<select name="computer_list_ipaddr_select" id="computer_list_ipaddr_select" style="width: 150px;" onChange="computer_list_ipaddr_selector(this.value);">
<option value="-1" selected="selected">
<SCRIPT >ddw("txtComputerName");</SCRIPT>
</option>
</select></p></fieldset></div></div></form><!-- InstanceEndEditable --></div>	</td>
<td id="sidehelp_container">
<div id="help_text">
<!-- InstanceBeginEditable name="Help_Text" --> 
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtSysLogStr2");</SCRIPT></p>
<p class="more"><!-- Link to more help -->
<a href="../Help/Tools.asp#SysLog" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>										</p>
<!-- InstanceEndEditable --></div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr>	<td><img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td><td>&nbsp;</td></tr></table></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
