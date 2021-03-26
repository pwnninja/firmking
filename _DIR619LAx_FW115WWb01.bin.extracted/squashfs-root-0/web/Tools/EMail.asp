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
var test= "<% getIndexInfo("smtp_port");%>";

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
dataLists=[
<%dumplog()%>

["",""]
];
function get_webserver_ssi_uri() {
		return ("" !== "") ? "/Basic/Setup.asp" : "/Tools/EMail.asp";
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
<script type="text/javascript">
//<![CDATA[


var schedule_options = [
	<%virSevSchRuleList();%>
];

		var mf;
		var verify_failed = "<%getInfo("err_msg")%>";
function smtp_email_enabled_selector(value)
{
	mf.smtp_email_enabled.value = value;
	mf.smtp_email_enabled_select.checked = value;
	mf.smtp_email_from_email_addr.disabled = !value;
	mf.smtp_email_addr.disabled = !value;
	mf.smtp_email_server_addr.disabled = !value;
var auth_enable = (value && mf.smtp_email_enable_smtp_auth_select.checked);			
	mf.smtp_email_enable_smtp_auth_select.disabled = !value;
	mf.smtp_email_acc_name.disabled = !auth_enable;
	mf.smtp_email_pass.disabled = !auth_enable;
	mf.smtp_email_pass_verify.disabled = !auth_enable;
mf.smtp_email_secret_select.disabled = !auth_enable;

	mf.log_when_log_full_select.disabled = !value;
var sched_enable = (value && mf.log_when_sched_select.checked);						
	mf.log_when_sched_select.disabled = !value;
	mf.log_sched_name_select.disabled = !sched_enable;
	mf.schtext.disabled = !sched_enable;
}

function smtp_email_enable_smtp_auth_selector(value)
{
	mf.smtp_email_enable_smtp_auth.value = value;
	mf.smtp_email_enable_smtp_auth_select.checked = value;
	var auth_enable = (value && mf.smtp_email_enabled_select.checked);	
	mf.smtp_email_acc_name.disabled = !auth_enable;
	mf.smtp_email_pass.disabled = !auth_enable;
	mf.smtp_email_pass_verify.disabled = !auth_enable;
mf.smtp_email_secret_select.disabled = !auth_enable;

}
function log_when_log_full_selector(value)
{
	mf.log_when_log_full.value = value;
	mf.log_when_log_full_select.checked = value;
}
function log_when_sched_selector(value)
{
	mf.log_when_sched.value = value;
	mf.log_when_sched_select.checked = value;
var email_enable = (value && mf.smtp_email_enabled_select.checked);
	mf.log_sched_name_select.disabled = !email_enable;
	mf.schtext.disabled = !email_enable;			
}
function log_sched_name_selector(value)
{
	mf.log_sched_name.value = value;
	mf.log_sched_name_select.value = value;
	mf.schtext.value = schedule_details(mf.log_sched_name_select, true,sw("txtEveryDay"),sw("txtAllDay"), sw("txtAM"), sw("txtPM"), days, schedule_options);
}
function is_ascii_string(str)
{
    var c, l = str.length;
    while(l) {
        c = str.charCodeAt(--l);
        if(c > 128) return false;
    };
    return true;
}
function verify_password()
{
	if ((mf.smtp_email_pass.value != mf.smtp_email_pass_verify.value) || (mf.smtp_email_pass.value == "") || !is_ascii_string(mf.smtp_email_pass.value)) {
		alert(sw("txtPasswordsNotMatchReEnter"));
		mf.smtp_email_pass.value = "";
		mf.smtp_email_pass_verify.value = "";
		mf.smtp_email_pass.selected = true;
		return false;
	}
		return true;
}
function trim_string_and_set(field){
		field.value = trim_string(field.value);
}
function mail_addr_test(str)
{
	var rlt = 0;	
	var tmp = str.split("@");
	try{
        if(tmp.length == 2 && /^([+]?)*([a-zA-Z0-9]*[_|\-|\.|\+|\%|\*|\?|\!|\\]?)*[a-zA-Z0-9]*([+]?)+$/.test(tmp[0]) && /^([a-zA-Z0-9]*[_|\-|\.|\+|\%|\*|\?|\!|\\]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,6}$/.test(tmp[1])){
            rlt = 1
        }

//		rlt = /^([a-zA-Z0-9]+[_|\-|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\-|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,6}$/.test(str);
	}catch(e){}
	return rlt;
}
function page_submit()
{
	mf.curTime.value = new Date().getTime();
	if (!is_form_modified("mainform") && 
		!confirm(sw("txtSaveAnyway"))) {
		return false;
	}
  	var smtp_email_len = utf8len(mf.smtp_email_subject.value);
	if(smtp_email_len > 39)
  	{
    	alert(sw("txtsmtpemaillen"));
        mf.smtp_email_subject.focus();
        return false;
  	}
	if(!is_blank(mf.smtp_email_addr.value))
	{
		if(!mail_addr_test(mf.smtp_email_addr.value))
		{
			alert(sw("txtGiveToAddress")+"("+ mf.smtp_email_addr.value +")"+sw("txtIsInvalid"));
			return false;
		}
	}
	if(!is_blank(mf.smtp_email_from_email_addr.value))
	{
		if(!mail_addr_test(mf.smtp_email_from_email_addr.value))
		{
			alert(sw("txtGiveFromAddress")+" ("+ mf.smtp_email_from_email_addr.value +")"+sw("txtIsInvalid"));
			return false;
		}
	
	}
//boer add
	if (!is_valid_port_str(mf.smtp_email_port.value) && is_blank(mf.smtp_email_port.value))
	{
		alert(sw("txtEmailPortErr"));
		return false;
	}


        if (mf.smtp_email_acc_name.value == "" && mf.smtp_email_enable_smtp_auth_select.checked){
                alert(sw("txtEmailAccName"));
                return false;
        }

	if(utf8len(mf.smtp_email_acc_name.value) > 128)
	{
		alert(sw("txtUserName") + sw("txtisInvalid"));
		return false;
	}
	if(!is_blank(mf.smtp_email_acc_name.value))
	{	
		if (!strchk_emailname(mf.smtp_email_acc_name.value))
		{
			alert(sw("txtUserName")+sw("txtIsInvalid"));
			return false;		
		}	
	}
	if(utf8len(mf.smtp_email_server_addr.value)> 35)
	{
		alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
		return false;		
	}
	if(!is_blank(mf.smtp_email_server_addr.value))
	{	
		if (!strchk_hostname(mf.smtp_email_server_addr.value))
		{
			alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
			return false;		
		}	
	}
	if(!is_blank(mf.smtp_email_server_addr.value))
	{		
        if(fucCheckNumDot(mf.smtp_email_server_addr.value)){
                if(!is_valid_ip(mf.smtp_email_server_addr.value)||(is_FF_IP(mf.smtp_email_server_addr.value))){
                        alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
                        return false;
                }
        }
  }
	/*
	if(utf8len(mf.smtp_email_pass.value) > 15 || utf8len(mf.smtp_email_pass.value) > 15)
	{
		alert(sw("txtPassword") + sw("txtIsInvalid"));
		return false;
	}
*/
	/*

	if (mf.smtp_email_addr.value == "") {
		alert(sw("txtEmailAddressNotSet"));
		return;
	}

	if (mf.smtp_email_acc_name.value == ""){
		alert(sw("txtEmailAccName"));
		return false;
	}

	if(!chkEmailAdd(mf.smtp_email_from_email_addr.value))
	{
		alert(sw("txtGiveFromAddress")+" ("+ mf.smtp_email_from_email_addr.value +")"+sw("txtIsInvalid"));
		return false;
	}

	if(!chkEmailAdd(mf.smtp_email_addr.value))
	{
		alert(sw("txtGiveToAddress")+"("+ mf.smtp_email_addr.value +")"+sw("txtIsInvalid"));

		return false;
	}

        if(mf.smtp_email_server_addr.value==""){
                alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
                return false;
        }



		var lan_ip_address = "<% getInfo("ip"); %>";
		if( mf.smtp_email_server_addr.value == lan_ip_address ){
			alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
			return false;
		}
        }
		if(!verify_password()) {
			return;
		}
	*/
	if (mf.log_to_syslog.value == "true") {
		var lan_network_address = "<% getInfo("ip-rom"); %>";
		var syslog_ipaddr = mf.log_syslog_addr.value;
		if (!is_ipv4_valid(syslog_ipaddr)) {
			alert(sw("txtInvalidSysLogIpAddress"));
			return 0;
		}
		var LAN_IP = "<% getInfo("ip-rom"); %>";
		var LAN_MASK = "<% getInfo("mask-rom"); %>";
		var tarIp = mf.log_syslog_addr.value;		
		if (!is_valid_ip2(tarIp,LAN_MASK,LAN_IP))
		{
		
			alert(sw("txtInvalidSysLogIpAddress"));
			return 0;
		}


		var lan_ip_address = "<% getInfo("ip"); %>";
		if( mf.log_syslog_addr.value == lan_ip_address ){
			alert(sw("txtInvalidSysLogIpAddress"));
			return false;
		}
		
	        if(fucCheckNumDot(mf.log_syslog_addr.value)){
	                if(!is_valid_ip(mf.log_syslog_addr.value) || (is_FF_IP(mf.log_syslog_addr.value))){
	                        alert(sw("txtInvalidSysLogIpAddress"));
	                        return false;
	                }
	        }
		
	}
	if(!is_ascii_string(mf.smtp_email_pass.value) || !is_ascii_string(mf.smtp_email_pass_verify.value)){
        	alert(sw("txtPasswordsNotMatchReEnter"));
	        mf.smtp_email_pass.value = "";
	        mf.smtp_email_pass_verify.value = "";
	        mf.smtp_email_pass.selected = true;
	        return false;
    	}
	mf["email_action"].value="apply";
	mf.submit();
}
var computer_list_xslt_processor;
var computer_list_retriever;
var is_computer_list_ready = false;
var is_computer_list_xslt_ready = false;
var computer_list_xml_data;
function log_to_syslog_selector(value)
{
	mf.log_to_syslog_select.checked = (value == true);
	mf.log_to_syslog.value = value;
	mf.computer_list_ipaddr_select.disabled = (value == false);
	mf.log_syslog_addr.disabled = (value == false);
	//document.getElementById("log_syslog_addr_section").style.display = (value == false) ? "none" : "block";
}
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
if (parent.firstChild != null) {
	parent.removeChild(parent.firstChild);
}
computer_list_xslt_processor.transform(computer_list_xml_data, window.document, parent);
copy_select_options(mf.computer_list_ip_address_pulldown, mf.computer_list_ipaddr_select);

mf.computer_list_ipaddr_select.setAttribute("modified", "ignore");
}
function computer_list_xslt_ready(dataInstance)
{
    is_computer_list_xslt_ready = true;
    populate_computer_list();
}
function computer_list_ready(dataInstance)
{
computer_list_xml_data = dataInstance.getDocument();
is_computer_list_ready = true;
populate_computer_list();
	window.setTimeout("computer_list_retriever.retrieveData()", 20000);
}

function computer_list_timeout(dataInstance)
{
window.setTimeout("computer_list_retriever.retrieveData()", 60000);
}
function computer_list_xslt_timeout(dataInstance)
{
	window.setTimeout("computer_list_xslt_processor.retrieveData()", 20000);
}
function log_opt_RouterStatus_selector(mode)
{
	log_opt_SysActivity_selector(mode);
	log_opt_notics_selector(mode);
	mf.log_ntc.checked = mode;
}
function log_opt_Firewall_selector(mode)
{
	log_opt_attack_selector(mode);
	log_opt_dropPackets_selector(mode);
	mf.log_attdrp.checked = mode;
}
function smtp_email_secret_selector(mode)
{
	mf.smtp_email_secret_select.checked = mode;
	mf.smtp_email_secret.value = mode;
}

function log_opt_System_selector(mode)
{
	mf.log_opt_system.value = mode;
	mf.log_sys.checked = mode;
}
function log_opt_SysActivity_selector(mode)
{
mf.log_opt_SysActivity.value = mode;
mf.log_opt_SysActivity_select.checked = mode;
}
function log_opt_debugInfo_selector(mode)
{
mf.log_opt_debugInfo.value = mode;
mf.log_opt_debugInfo_select.checked = mode;
}
function log_opt_attack_selector(mode)
{
mf.log_opt_attack.value = mode;
mf.log_opt_attack_select.checked = mode;
}
function log_opt_dropPackets_selector(mode)
{
mf.log_opt_dropPackets.value = mode;
mf.log_opt_dropPackets_select.checked = mode;
}
function log_opt_notics_selector(mode)
{
mf.log_opt_notics.value = mode;
mf.log_opt_notics_select.checked = mode;
}
var smtp_email_addr_to_value = "<%getIndexInfo("log_to");%>";
function email_log()
{
smtp_email_addr_to_value=mf.smtp_email_addr.value;
if (smtp_email_addr_to_value == "") {
	alert(sw("txtEmailAddressNotSet"));
	return;
}

	if(mf.smtp_email_enabled.value == "true")
	{
		//if(!chkEmailAdd(mf.smtp_email_from_email_addr.value))
		if(!mail_addr_test(mf.smtp_email_from_email_addr.value))
		{
			alert(sw("txtGiveFromAddress")+" ("+ mf.smtp_email_from_email_addr.value +")"+sw("txtIsInvalid"));
			
			return false;
		}
		//if(!chkEmailAdd(mf.smtp_email_addr.value))
		if(!mail_addr_test(mf.smtp_email_addr.value))
		{
			alert(sw("txtGiveToAddress")+"("+ mf.smtp_email_addr.value +")"+sw("txtIsInvalid"));
			
			return false;
		}
	}
  var smtp_email_len = utf8len(mf.smtp_email_subject.value);
  if(smtp_email_len > 39)
  {
          alert(sw("txtsmtpemaillen"));
          mf.smtp_email_subject.focus();
          return false;
  }
//boer add
	if (!is_valid_port_str(mf.smtp_email_port.value) && is_blank(mf.smtp_email_port.value) )
	{
		alert(sw("txtEmailPortErr"));
		return false;
	}

	if (mf.smtp_email_acc_name.value == "" && mf.smtp_email_enable_smtp_auth_select.checked){
		alert(sw("txtEmailAccName"));
		return false;
	}
		if(utf8len(mf.smtp_email_acc_name.value) > 128)
	{
		alert(sw("txtUserName") + sw("txtisInvalid"));
		return false;
	}
		if (!strchk_emailname(mf.smtp_email_acc_name.value))
		{
			alert(sw("txtUserName")+sw("txtIsInvalid"));
			return false;		
		}		
	if(mf.smtp_email_server_addr.value==""){
		alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
		return false;
	}
	if (!strchk_hostname(mf.smtp_email_server_addr.value))
	{
		alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
		return false;		
	}
	if(fucCheckNumDot(mf.smtp_email_server_addr.value)){
		if(!is_valid_ip(mf.smtp_email_server_addr.value)||(is_FF_IP(mf.smtp_email_server_addr.value))){
			alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
			return false;
		}

		var lan_ip_address = "<% getInfo("ip-rom"); %>";
		var lan_mask = "<% getInfo("mask-rom"); %>";
		//var lan_network_id = get_network_id(lan_ip_address,lan_mask);
		//var lan_broadcast = get_broadcast_ip(lan_ip_address,lan_mask);
		//if( mf.smtp_email_server_addr.value == lan_ip_address || lan_network_id[0] == mf.smtp_email_server_addr.value || 
		//lan_broadcast[0] == mf.smtp_email_server_addr.value){
		if( mf.smtp_email_server_addr.value == lan_ip_address || !is_valid_gateway(lan_ip_address,lan_mask,mf.smtp_email_server_addr.value)){
			alert(sw("txtSMTPServerAddress")+sw("txtIsInvalid"));
			return false;
		}
	}

	
	if(!verify_password()) {
			return;
		}

alert(sw("txtSendLogTo") +" "+smtp_email_addr_to_value);
mf["settingsChanged"].value = 1;
mf["email_action"].value="sendLog";
mf.submit();
}
function page_load() 
{
displayOnloadPage("<%getInfo("ok_msg")%>");

var local_debug = false;
	mf = document.forms["mainform"];
	if (local_debug) {
			hide_all_ssi_tr();
			smtp_email_enabled_selector(true);
			smtp_email_enable_smtp_auth_selector(true);
			log_when_log_full_selector(true);
			log_when_sched_selector(true);
			log_sched_name_selector("Never");
			return;
	}
//////////////////////////////////////
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
	
	smtp_email_enabled_selector(mf.smtp_email_enabled.value == "true");
	smtp_email_enable_smtp_auth_selector(mf.smtp_email_enable_smtp_auth.value == "true");
	//log_when_log_full_selector(mf.log_when_log_full.value == "true");
	//log_when_sched_selector(mf.log_when_sched.value == "true");
	//schedule_populate_select_without_always(mf.log_sched_name_select, schedule_options);
	//if (mf.log_sched_name.value == "Always") {
	//		mf.log_sched_name.value = "Never";
	//}
	//log_sched_name_selector(mf.log_sched_name.value);
	log_opt_RouterStatus_selector(mf.log_opt_SysActivity.value == "true" || mf.log_opt_notics.value == "true")
	log_opt_Firewall_selector(mf.log_opt_attack.value == "true" || mf.log_opt_dropPackets.value == "true")
	log_opt_System_selector(mf.log_opt_system.value == "true");
	log_opt_SysActivity_selector(mf.log_opt_SysActivity.value == "true");
smtp_email_secret_selector(mf.smtp_email_secret.value == "true");
	get_by_id("mail_auth").style.display = "";

	log_opt_debugInfo_selector(mf.log_opt_debugInfo.value == "true");
	log_opt_attack_selector(mf.log_opt_attack.value == "true");
	log_opt_dropPackets_selector(mf.log_opt_dropPackets.value == "true");
	log_opt_notics_selector(mf.log_opt_notics.value == "true");
	mf.smtp_email_pass_verify.value = mf.smtp_email_pass.value;
	set_form_default_values("mainform");
	/* Check for validation errors. */
	if (verify_failed != "") {
		set_form_always_modified("mainform");
		alert(verify_failed);
	}		
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtTools")+'/'+sw("txtLogSettings");
document.title = DOC_Title;	
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");
get_by_id("SaveLog").value = sw("txtSave");	
get_by_id("EmaiNow").value = sw("txtEmaiNow");		
}
//]]>
</script><!-- InstanceEndEditable --></head>
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr><td><SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr>	<td id="sidenav_container"><div id="sidenav">
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
</td>								
<td id="maincontent_container">
<SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" >	<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div><!-- box warnings_section_content --></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
<form id="mainform" name="mainform" action="/goform/formSetEmail" method="post">
	<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
	<input type="hidden" id="curTime" name="curTime" value=""/>
	<input type="hidden" id="email_action" name="email_action" value=""/>
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtLogSettings");</SCRIPT></h2>
<br>
<p><SCRIPT >ddw("txtEmailStr1");</SCRIPT></p>
<br>
<input class="button_submit" type="button" id="SaveSettings" name="SaveSettings" value="" onclick="page_submit()"/>
<input class="button_submit" type="button" id="DontSaveSettings"  name="DontSaveSettings" value="" onclick="page_cancel()"/>
</div> <!-- section_head -->
<div class="box" id="email_notify" style='display:none'>
<h3><SCRIPT >ddw("txtEnable");</SCRIPT></h3>
<fieldset><p>
<label class="duple" for="smtp_email_enabled_select">
<SCRIPT >ddw("txtEnableEmailNotification");</SCRIPT>
&nbsp;:</label>
<input type="hidden" id="smtp_email_enabled" name="config.smtp_email_enabled" value="<%getIndexInfo("emailN");%>"/>
<input type="checkbox" id="smtp_email_enabled_select" 	onclick="smtp_email_enabled_selector(this.checked);"/>
</p></fieldset></div>
<!---------------------------->
<div class="box">
<h3><SCRIPT >ddw("txtLogDetails");</SCRIPT></h3>
<fieldset><p><label class="duple" for="log_syslog_addr">
<SCRIPT >ddw("txtSaveLogToLocalHardDrive");</SCRIPT>
</label> 
<input type="button" id="SaveLog" name="SaveLog" class="button_submit" value="" onClick="window.location.href='../Gatewaylog.txt'"/>
</p></fieldset></div>
<!---------------------------->
<div class="box">
<h3><SCRIPT >ddw("txtSysLogSettings");</SCRIPT></h3>
<fieldset><p><label class="duple">
<SCRIPT >ddw("txtEnableLoggingToSyslogServer");</SCRIPT>:</label>
<input type="checkbox" id="log_to_syslog_select" onclick="log_to_syslog_selector(this.checked);"/>
<input type="hidden" id="log_to_syslog" name="config.log_to_syslog" value="<% getIndexInfo("logserveren"); %>"/>
</p>
<p id="log_syslog_addr_section">
<label class="duple" for="log_syslog_addr">
<SCRIPT >ddw("txtSyslogServerIPAddress");</SCRIPT>
:</label><input type="text" id="log_syslog_addr" name="config.log_syslog_addr" size="20" maxlength="15" disabled="disabled" value="<% getIndexInfo("logserver"); %>" />&nbsp;&lt;&lt;&nbsp;

<span id="xsl_span_computer_list_ipaddr_select" style="display:none"></span>
<select name="computer_list_ipaddr_select" id="computer_list_ipaddr_select" style="width: 150px;" onChange="computer_list_ipaddr_selector(this.value);">
<option value="-1" selected="selected">
<SCRIPT >ddw("txtComputerName");</SCRIPT>
</option>
</select></p></fieldset></div>

<!---------------------------->

<div class="box">
	<h2><SCRIPT >ddw("txtLogOptions");</SCRIPT></h2>
	<table cellSpacing=1 cellPadding=2 width=525>
	<tr>
		<td class=r_tb><SCRIPT >ddw("txtWhattoView");</SCRIPT>:</td>
		<input type="hidden" id="log_opt_system" name="log_opt_system" value="<%getIndexInfo("logtype_system")%>"/>
		<td class=l_tb><input type=checkbox id=log_sys value="1" onclick="log_opt_System_selector(this.checked);"><SCRIPT >ddw("txtSystem");</SCRIPT></td>
		<td class=l_tb><input type=checkbox id=log_attdrp value="1" onclick="log_opt_Firewall_selector(this.checked);"><SCRIPT >ddw("txtFirewallSecurity");</SCRIPT></td>
		<td class=l_tb><input type=checkbox id=log_ntc value="1" onclick="log_opt_RouterStatus_selector(this.checked);"><SCRIPT >ddw("txtRouterStatus");</SCRIPT></td>
	</tr>
	<tr>
		<td colspan=2></td>
	</tr>
	<tr>
		<td class=r_tb disabled><SCRIPT >ddw("txtLogLevel");</SCRIPT>:</td>
		<td class=l_tb disabled><input type=checkbox name=log_level_1 value="1" disabled><SCRIPT >ddw("txtCritical");</SCRIPT></td>
		<td class=l_tb disabled><input type=checkbox name=log_level_2 value="1" disabled><SCRIPT >ddw("txtWarning");</SCRIPT></td>
		<td class=l_tb disabled><input type=checkbox name=log_level_3 value="1" disabled><SCRIPT >ddw("txtInformation");</SCRIPT></td>
	</tr>
	</table>
</div>
<div class="box" style="display:none">
<h3><SCRIPT >ddw("txtLogOptions");</SCRIPT></h3>
<fieldset><table border="0" cellpadding="0" cellspacing="4" class="formarea" id="status_logs_options" summary="">
<tr>	
	<td class="form_label"><SCRIPT >ddw("txtWhattoView");</SCRIPT>&nbsp;:</td>

<td id="log_opt_SysActivity_cell">
<input type="hidden" id="log_opt_SysActivity" name="log_opt_SysActivity" value="<%getIndexInfo("logtype1")%>"/>
<input type="checkbox" id="log_opt_SysActivity_select" onclick="log_opt_SysActivity_selector(this.checked);"/>
<label for="log_opt_SysActivity_select"><SCRIPT >ddw("txtSystemActivity");</SCRIPT></label></td>

<td><input type="hidden" id="log_opt_debugInfo" name="log_opt_debugInfo" value="<%getIndexInfo("logtype2")%>"/>
<input type="checkbox" id="log_opt_debugInfo_select" onclick="log_opt_debugInfo_selector(this.checked);"/>
<label for="log_opt_debugInfo_select"><SCRIPT >ddw("txtDebugInfo");</SCRIPT></label>
</td>

<td><input type="hidden" id="log_opt_attack" name="log_opt_attack" value="<%getIndexInfo("logtype3")%>"/>
<input type="checkbox" id="log_opt_attack_select" onclick="log_opt_attack_selector(this.checked);"/>
<label for="log_opt_attack_select"><SCRIPT >ddw("txtAttacks");</SCRIPT></label>
</td></tr>

<tr>
<td class="form_label">&nbsp;</td>
<td><input type="hidden" id="log_opt_dropPackets" name="log_opt_dropPackets" value="<%getIndexInfo("logtype4")%>"/>
<input type="checkbox" id="log_opt_dropPackets_select" onclick="log_opt_dropPackets_selector(this.checked);"/>
<label for="log_opt_dropPackets_select"><SCRIPT >ddw("txtDropPackets");</SCRIPT></label>
</td>

<td><input type="hidden" id="log_opt_notics" name="log_opt_notics" value="<%getIndexInfo("logtype5")%>"/>
<input type="checkbox" id="log_opt_notics_select" onclick="log_opt_notics_selector(this.checked);"/>
<label for="log_opt_notics_select"><SCRIPT >ddw("txtNotice");</SCRIPT></label>
</td>
</tr>
</table>
<!--
<div class="centered"><input type="button" id="ApplyLogSettings" name="ApplyLogSettings" class="button_submit" value="" onclick="page_submit()"/></div>
-->
</fieldset>
</div>
<div class="box">
<h3><SCRIPT >ddw("txtSendByMail");</SCRIPT></h3>
<p class="box_msg">	</p>
<fieldset><p><label class="duple" for="smtp_email_addr">
<SCRIPT >ddw("txtToEmailAddress");</SCRIPT>
:</label>	<input type="text" id="smtp_email_addr" size="20" maxlength="128" value="<%getIndexInfo("log_to");%>" name="config.smtp_email_addr" onchange="trim_string_and_set(this);"/>
</p>
<p><label class="duple" for="smtp_email_subject">
<SCRIPT >ddw("txtEmailStrsub");</SCRIPT>
:</label>	<input type="text" id="smtp_email_subject" size="20" maxlength="39" value="<%getIndexInfo("log_sub");%>" name="config.smtp_email_subject" onchange="trim_string_and_set(this);"/>
</p>
<p>
<label class="duple" for="smtp_email_from_email_addr">
<SCRIPT >ddw("txtFromEmailAddress");</SCRIPT>
:</label>	<input type="text" id="smtp_email_from_email_addr" size="20" maxlength="128" 	value="<%getIndexInfo("log_from");%>" name="config.smtp_email_from_email_addr" onchange="trim_string_and_set(this);"/>
</p>
<p><label class="duple" for="smtp_email_server_addr">
<SCRIPT >ddw("txtSMTPServerAddress");</SCRIPT>
:</label><input type="text" id="smtp_email_server_addr" size="20" maxlength="35" value="<%getIndexInfo("smtp_server");%>" name="config.smtp_email_server_addr" onchange="trim_string_and_set(this);"/>

</p><p id="mail_auth" style='display:none'><label class="duple" for="smtp_email_enable_smtp_auth_select">
<SCRIPT >ddw("txtEnableAuthentication");</SCRIPT>
:</label><input type="hidden" id="smtp_email_enable_smtp_auth" name="config.smtp_email_enable_smtp_auth" value="<%getIndexInfo("smtp_auth");%>"/>
<input type="checkbox" id="smtp_email_enable_smtp_auth_select" onclick="smtp_email_enable_smtp_auth_selector(this.checked);"/>
</p>

<p ><label class="duple" for="smtp_email_acc_name">
<SCRIPT >ddw("txtUserName");</SCRIPT>
:</label><input type="text" id="smtp_email_acc_name" size="20" maxlength="128" value="<%getIndexInfo("smtp_user");%>" name="config.smtp_email_acc_name"/>
</p>

<p><label class="duple" for="smtp_email_pass">
<SCRIPT >ddw("txtPassword");</SCRIPT>
:</label>	<input type="password" id="smtp_email_pass" maxlength="128" size="20" onfocus="select();" value="<%getIndexInfo("smtp_pwd");%>" name="config.smtp_email_pass"/></p>
<p><label class="duple" for="smtp_email_pass_verify"><SCRIPT >ddw("txtVerifyPassword");</SCRIPT>
:</label><input type="password" id="smtp_email_pass_verify" maxlength="128" size="20" onfocus="select();"/>
</p>

<p>
<label class="duple"><SCRIPT >ddw("txtEmailSecret");</SCRIPT>
:</label><input type="checkbox" id="smtp_email_secret_select" onclick="smtp_email_secret_selector(this.checked);"/>
<input type="hidden" id="smtp_email_secret" name="config.smtp_email_secret" value="<% getIndexInfo("smtp_secret"); %>"/>
</p>

<p>
<label class="duple" for="smtp_email_port"><SCRIPT >ddw("txtEmailPort");</SCRIPT>
:</label><input type="text" id="smtp_email_port" maxlength="5" size="20" value="<% getIndexInfo("smtp_port"); %>" name="config.smtp_email_port"/>

<input type="button" id="EmaiNow" name="EmaiNow" class="button_submit" value="" onclick="email_log()"/>
</p>
</fieldset></div><!-- box -->

<div class="box" id="email_notify_sch" style='display:none'>
<h3><SCRIPT >ddw("txtEmailLogWhen");</SCRIPT></h3>
<p class="box_msg"></p>
<fieldset><p>	<label class="duple" for="log_when_log_full_select">
<SCRIPT >ddw("txtOnLogFull");</SCRIPT>
:</label><input type="hidden" id="log_when_log_full" name="config.log_when_log_full" value="<%getIndexInfo("log_full");%>"/>
<input type="checkbox" id="log_when_log_full_select" onclick="log_when_log_full_selector(this.checked);"/></p>
<p><label class="duple" for="log_when_sched_select">
<SCRIPT >ddw("txtOnSchedule");</SCRIPT>
:</label><input type="hidden" id="log_when_sched" name="config.log_when_sched" value="<%getIndexInfo("log_sch");%>"/>
<input type="checkbox" id="log_when_sched_select" onclick="log_when_sched_selector(this.checked);"/>
</p><p>
<label class="duple">
<a href="Schedules.asp" onclick="return jump_if();">
<SCRIPT >ddw("txtSchedules");</SCRIPT>
</a>&nbsp;:</label>
<input type="hidden" id="log_sched_name" name="config.log_sched_name" value="<%getIndexInfo("log_sch_name");%>"/>
<select name="log_sched_name_select" id="log_sched_name_select" onchange="log_sched_name_selector(this.value);">
</select></p>
<p><label class="duple"><SCRIPT >ddw("txtDetails");</SCRIPT>
&nbsp;:</label><input id="schtext" name="schtext" type="text" class="rule_details" size="48" 	maxlength="48" readonly="readonly" value=""/>
</p></fieldset></div></div></form><!-- InstanceEndEditable --></div></td>
<td id="sidehelp_container"><div id="help_text">
<!-- InstanceBeginEditable name="Help_Text" --> 
<strong>	<SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtEmailStr2");</SCRIPT></p>
<p class="more"><!-- Link to more help --><a href="../Help/Tools.asp#EMail" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a></p>
<!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>

