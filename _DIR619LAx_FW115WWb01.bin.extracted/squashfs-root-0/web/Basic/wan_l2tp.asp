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
var schedule_options = [
	<%virSevSchRuleList();%> 
];	
function do_add_new_schedule()
{
	var time_now=new Date().getTime();
	top.location = "../Tools/Schedules.asp?t="+time_now;
}	
	
function update_wan_ip_mode_list()
{
mf.wan_ip_mode_select.length = 0;
mf.wan_ip_mode_select[0] = new Option(sw("txtStaticIP"), "0", false, false);
mf.wan_ip_mode_select[1] = new Option(sw("txtDynamicIP"), "1", false, false);
mf.wan_ip_mode_select[2] = new Option("PPPoE("+sw("txtUsernamePassword")+")", "2", false, false);
mf.wan_ip_mode_select[3] = new Option("PPTP("+sw("txtUsernamePassword")+")", "3", false, false);
mf.wan_ip_mode_select[4] = new Option("L2TP("+sw("txtUsernamePassword")+")", "4", false, false);
//mf.wan_ip_mode_select[5] = new Option("BigPond "+sw("txtAustralia"), "5", false, false);
if(LangCode == "SC")
mf.wan_ip_mode_select[5] = new Option("DHCP+("+sw("txtDynamicIP")+")", "9", false, false);

}

function get_webserver_ssi_uri() {
	return ("" !== "") ? "/Basic/Setup.asp" : "/Basic/WAN.asp";
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
<script language="JavaScript" type="text/javascript">
//<![CDATA[

var local_debug = false;
var verify_failed = "<%getInfo("err_msg")%>";
var mf;
var pcmac;
var remote_login;
var default_idle_time = parseInt("5",10);
function wan_schedule_name_selector(value)
{
	mf["ppp_schedule_control_0"].value=value;
}

function wan_ip_mode_selector(mode)
{
var html_file="";
mode = mode * 1;
switch(mode)
{	
	case STATIC:
	html_file = "wan_static.asp";
	break;
	case DHCP:
	html_file = "wan_dhcp.asp";
	break;
	case PPPOE:
	html_file = "wan_pppoe.asp";
	break;
	case PPTP:
	html_file = "wan_pptp.asp";
	break;
	case L2TP:
	html_file = "wan_l2tp.asp";
	break;
	case BIGPOND:
	html_file = "wan_bigpond.asp";
	break;
	case DHCPPLUS:
	html_file = "wan_dhcpplus.asp";			
	break;
	
}
reset_form("mainform");
if(mode != mf.wan_ip_mode.value) 
{
	window.location.href=html_file+"?t="+new Date().getTime();
	mf.wan_mtu.value = mtu_default_values[mode];
	}
	//document.getElementById("box_wan_static").style.display = mode == STATIC ? "block" : "none";
}
function wan_l2tp_use_dynamic_carrier_selector(mode){
mf.wan_l2tp_use_dynamic_carrier.value = mode;
if(mode == "true") {
	mf.wan_l2tp_use_dynamic_carrier_radio_1.checked = true;
	mf.wan_l2tp_ip_address.disabled = true;
	mf.wan_l2tp_subnet_mask.disabled = true;
	mf.wan_l2tp_gateway.disabled = true;
	mf.wan_primary_dns.disabled = true;
} else {
	mf.wan_l2tp_use_dynamic_carrier_radio_0.checked = true;
	mf.wan_l2tp_ip_address.disabled = false;
	mf.wan_l2tp_subnet_mask.disabled = false;
	mf.wan_l2tp_gateway.disabled = false;
	mf.wan_primary_dns.disabled = false;
}
}
function l2tp_reconnect_selector(mode)
{
	mode = mode * 1;
	// 0 = Always on, 1 = On demand, 2 = Manual
	mf.l2tp_reconnect_mode_radio.value = mode;
	mf.wan_l2tp_max_idle_time.disabled = mode == 1 ?  false : true;
	if(mode != 0){
		mf.wan_sch_select.disabled=true;
	}else{
		mf.wan_sch_select.disabled=false;
	}
	switch(mode)
	{
		case 0:
			mf.l2tp_reconnect_mode_radio_0.checked = true;
			break;
		case 1:
			mf.l2tp_reconnect_mode_radio_2.checked = true;
		break;
		case 2:
			mf.l2tp_reconnect_mode_radio_1.checked = true;
		break;
	}
}




function page_load() 
{
var oldmac;	
displayOnloadPage("<%getInfo("ok_msg")%>");
mf = document.forms["mainform"];
remote_login = false;
update_wan_ip_mode_list();
pcmac = "<% getInfo("host-hwaddr"); %>";
remote_login = (pcmac == "00:00:00:00:00:00") ? true : false;
oldmac=mf.mac_cloning_address.value; 
mf.mac1.value=oldmac.substring(0,2);
mf.mac2.value=oldmac.substring(3,5);
mf.mac3.value=oldmac.substring(6,8);
mf.mac4.value=oldmac.substring(9,11);
mf.mac5.value=oldmac.substring(12,14);
mf.mac6.value=oldmac.substring(15,17);
mf.wan_ip_mode.value = L2TP;
mf.wan_ip_mode_select.value = L2TP;

wan_l2tp_use_dynamic_carrier_selector(mf.wan_l2tp_use_dynamic_carrier.value);
l2tp_reconnect_selector(mf.wan_l2tp_reconnect_mode.value);

mf["dsl_mode"].value = 4;
schedule_populate_select(mf["wan_sch_select"]);
mf.wan_sch_select.value = mf.ppp_schedule_control_0.value;

set_form_default_values("mainform");
if (verify_failed != "") {
set_form_always_modified("mainform");
alert(verify_failed);
}

}
function clone_mac() {
	var copy_mac;
			mf.mac_cloning_address.value = pcmac;
			mf.mac_cloning_enabled.value = "true";
			copy_mac=mf.mac_cloning_address.value; 
	mf.mac1.value=copy_mac.substring(0,2);
	mf.mac2.value=copy_mac.substring(3,5);
	mf.mac3.value=copy_mac.substring(6,8);
	mf.mac4.value=copy_mac.substring(9,11);
	mf.mac5.value=copy_mac.substring(12,14);
	mf.mac6.value=copy_mac.substring(15,17);
}
function page_submit(mode)
{
var mac_addr;
var lan_ip_str = "<% getInfo("ip-rom"); %>";
var lan_mask_str = "<% getInfo("mask-rom"); %>";
mf.curTime.value = new Date().getTime();	
if (!is_form_modified("mainform"))
{
if(!confirm(sw("txtSaveAnyway"))) 
	return false;
}
else{
mode = mode * 1;
if (mf.wan_l2tp_password.value != mf.confirm_wan_l2tp_password.value) {
alert(sw("txtThePasswordsDontMatch"));
try	{
	mf.wan_l2tp_password.select();
	mf.confirm_wan_l2tp_password.select();
	mf.wan_l2tp_password.focus();
} catch (e) {
	}
return;
}
if( strchk_unicode(mf.wan_l2tp_username.value) == true){
        mf.wan_l2tp_username.select();
        mf.wan_l2tp_username.focus();
        alert(sw("txtL2TPUserName")+sw("txtisInvalid"));
        return false;
}
if(mf.wan_l2tp_use_dynamic_carrier.value == "false" ) 
{
	var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
	var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
	var wan_ip = ipv4_to_unsigned_integer(mf.wan_l2tp_ip_address.value);
	var mask_ip = ipv4_to_unsigned_integer(mf.wan_l2tp_subnet_mask.value);
	var gw_ip = ipv4_to_unsigned_integer(mf.wan_l2tp_gateway.value);
	var srv_ip = ipv4_to_unsigned_integer(mf.wan_l2tp_server.value);
	var b255 = ipv4_to_unsigned_integer("255.255.255.255");
	b255 ^= mask_ip;
	
	if (!is_ipv4_valid(mf.wan_l2tp_ip_address.value) || 
		mf.wan_l2tp_ip_address.value=="0.0.0.0" || 
		is_FF_IP(mf.wan_l2tp_ip_address.value) ||
		wan_ip == gw_ip || wan_ip == srv_ip ||
		0 == (wan_ip & b255) ||
		b255 == (b255 & wan_ip)){
		alert(sw("txtInvalidL2TPIP") + mf.wan_l2tp_ip_address.value);
		try	{
			mf.wan_l2tp_ip_address.select();
			mf.wan_l2tp_ip_address.focus();
		}	 
		catch (e) {
		}
	return;
	}
	if (!is_ipv4_valid(mf.wan_l2tp_subnet_mask.value) || !is_mask_valid(mf.wan_l2tp_subnet_mask.value)) {
	alert(sw("txtInvalidL2TPsubnetMask") + mf.wan_l2tp_subnet_mask.value);
	try	{
	mf.wan_l2tp_subnet_mask.select();
	mf.wan_l2tp_subnet_mask.focus();
	} catch (e) {
	}
	return;
	}
	//||gw_ip == srv_ip==>we accept the case when gw ip == server ip
	if (!is_ipv4_valid(mf.wan_l2tp_gateway.value) || 
		mf.wan_l2tp_gateway.value=="0.0.0.0" || 
		is_FF_IP(mf.wan_l2tp_gateway.value)  ||
		0 == (gw_ip & b255) ||
		b255 == (gw_ip & b255)){
		alert(sw("txtInvalidL2TPgatewayIP") + mf.wan_l2tp_gateway.value);
		try	{
			mf.wan_l2tp_gateway.select();
			mf.wan_l2tp_gateway.focus();
		}	 
		catch (e) {
		}
		return;
	}
	
	if ((wan_ip & mask_ip) !== (gw_ip & mask_ip))
	{
		alert(sw("txtL2TPWANGwIp")+" "+integer_to_ipv4(gw_ip)+" "+sw("txtWithinWanSubnet"));
		return false;
	}
	if ((LAN_IP & LAN_MASK) == (wan_ip & LAN_MASK))
	{
		alert(sw("txtWanSubConflitLanSub"));
		return false;
	}
}
/*if (!is_ipv4_valid(mf.wan_l2tp_server.value) || mf.wan_l2tp_server.value=="0.0.0.0" || is_FF_IP(mf.wan_l2tp_server.value)) {
alert(sw("txtInvalidL2TPserver") + mf.wan_l2tp_server.value);
try	{
mf.wan_l2tp_server.select();
mf.wan_l2tp_server.focus();
} catch (e) {
}
return;
}*/

if(mf.wan_l2tp_server.value == "0.0.0.0" || mf.wan_l2tp_server.value == lan_ip_str){
alert(sw("txtInvalidL2TPserver") + mf.wan_l2tp_server.value);
try     {
mf.wan_l2tp_server.select();
mf.wan_l2tp_server.focus();
} catch (e) {
}
return;
}

if(  mf.wan_l2tp_use_dynamic_carrier_radio_0.checked == true
     && (!is_valid_ip(mf.wan_l2tp_server.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,mf.wan_l2tp_server.value)
     || !is_valid_gateway(mf.wan_l2tp_ip_address.value,mf.wan_l2tp_subnet_mask.value,mf.wan_l2tp_server.value))){
alert(sw("txtInvalidL2TPserver") + mf.wan_l2tp_server.value);
try     {
mf.wan_l2tp_server.select();
mf.wan_l2tp_server.focus();
} catch (e) {
}
return;
}

if(  mf.wan_l2tp_use_dynamic_carrier_radio_1.checked == true
     && (!is_valid_ip(mf.wan_l2tp_server.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,mf.wan_l2tp_server.value))){
alert(sw("txtInvalidL2TPserver") + mf.wan_l2tp_server.value);
try     {
mf.wan_l2tp_server.select();
mf.wan_l2tp_server.focus();
} catch (e) {
}
return;
}

var LAN_IP_ADDRESS = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
var LAN_MASK_ADDRESS = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");
var wan_ip_address = ipv4_to_unsigned_integer(mf.wan_l2tp_server.value);
if ((LAN_IP_ADDRESS & LAN_MASK_ADDRESS) == (wan_ip_address & LAN_MASK_ADDRESS)) {
	alert(sw("txtWanSubConflitLanSub"));
	try     {
		mf.wan_l2tp_server.select();
		mf.wan_l2tp_server.focus();
	} catch (e) {
	}
	return;
}

if ((mf.l2tp_reconnect_mode_radio.value != 0) && !is_number(mf.wan_l2tp_max_idle_time.value) ) {
alert(sw("txtInvalidIdleTime"));
try	{
mf.wan_l2tp_max_idle_time.select();
mf.wan_l2tp_max_idle_time.focus();
} catch (e) {
}
return;
}

mf.wan_l2tp_reconnect_mode.value =mf.l2tp_reconnect_mode_radio.value;
if(mf.wan_l2tp_max_idle_time.value>600 || mf.wan_l2tp_max_idle_time.value<0)
{
alert(sw("txtInvalidIdleTime")+"("+sw("txtPermittedRange")+sw("txtIdleRng0to600")+")");
return;
}
mf.wan_primary_dns.value = trim_string(mf.wan_primary_dns.value);

mf.wan_primary_dns.value = mf.wan_primary_dns.value == "" ? "0.0.0.0" : mf.wan_primary_dns.value;

//if (!is_ipv4_valid(mf.wan_primary_dns.value) || is_FF_IP(mf.wan_primary_dns.value) || ((ipv4_to_unsigned_integer(mf.wan_primary_dns.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(mf.wan_primary_dns.value) & 0x000000FF) == 0x00000000   )) {
if(  mf.wan_primary_dns.value!="0.0.0.0" && mf.wan_l2tp_use_dynamic_carrier_radio_0.checked == true
     && (!is_valid_ip(mf.wan_primary_dns.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,mf.wan_primary_dns.value)
     || !is_valid_gateway(mf.wan_l2tp_ip_address.value,mf.wan_l2tp_subnet_mask.value,mf.wan_primary_dns.value))){
	alert(sw("txtInvalidPPPoEPrimaryDNS") +  mf.wan_primary_dns.value);
	try {
		mf.wan_primary_dns.select();
		mf.wan_primary_dns.focus();
	} catch (e) {
	}
	return;
}

if(  mf.wan_primary_dns.value!="0.0.0.0" && mf.wan_l2tp_use_dynamic_carrier_radio_1.checked == true
     && (!is_valid_ip(mf.wan_primary_dns.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,mf.wan_primary_dns.value) )){
	alert(sw("txtInvalidPPPoEPrimaryDNS") +  mf.wan_primary_dns.value);
	try {
		mf.wan_primary_dns.select();
		mf.wan_primary_dns.focus();
	} catch (e) {
	}
	return;
}

if ((mf.wan_primary_dns.value != "0.0.0.0")) {
mf.wan_force_static_dns_servers.value = "true";
} else {
mf.wan_force_static_dns_servers.value = "false";
}
if (!is_number(mf.wan_mtu.value)) {
alert(sw("txtInvalidMTUSize"));
try {
mf.wan_mtu.select();
mf.wan_mtu.focus();
} catch (e) {
}
return;
}
if(mf.wan_mtu.value > 1500 || mf.wan_mtu.value < 576)
{
	alert(sw("txtInvalidMTUSize")+"("+sw("txtPermittedRange")+sw("txtMtuRng576to1500")+")");
	return false;
}
mf.mac_cloning_address.value=mf.mac1.value+':'+mf.mac2.value+':'+mf.mac3.value+':'+mf.mac4.value+':'+mf.mac5.value+':'+mf.mac6.value;		
mf.mac_cloning_address.value = trim_string(mf.mac_cloning_address.value);
if(!verify_mac(mf.mac_cloning_address.value,mf.mac_cloning_address))
{
alert (sw("txtInvalidMACAddress") + " "+mf.mac_cloning_address.value + ".");
return;
}
if(mf.mac_cloning_address.value == "00:00:00:00:00:00") {
mf.mac_cloning_enabled.value = "false";
}			
else
{
mf.mac_cloning_enabled.value = "true";	
}
mac_addr = mf.mac_cloning_address.value.split(":");					
mf.mac_clone.value = "";
for(var i=0;i<mac_addr.length;i++)
{
	mf.mac_clone.value += mac_addr[i];
}		
switch (mode) {
	case PPPOE:			
	mf.pppoe_max_idle_time.disabled = false;
	break;
	case PPTP:
	mf.wan_pptp_max_idle_time.disabled = false;
	break;			
	case L2TP:
	mf.wan_l2tp_max_idle_time.disabled = false;
	break;
	}
	mf["settingsChanged"].value = 1;
}	
if(mf["dsl_mode"].value != <%getInfo("wanType");%>)
mf["settingsChanged"].value = 1;
mf.submit();
}


function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtWAN");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");			
get_by_id("clone_mac_addr").value = sw("txtCopyMACAddress");
get_by_id("add_new_schedule").value = sw("txtAddNew");
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");		
}
//]]>
</script>
</head>
<body onload="template_load(); init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside"><table id="table_shell" cellspacing="0" summary=""><col span="1"/>
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
</SCRIPT>
</div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td><td id="maincontent_container">
<SCRIPT >DrawRebootContent("wan");</SCRIPT>
<div id="warnings_section" style="display:none"><div class="section" >	<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div></div></div>	</div>
<div id="maincontent" style="display: block">
<form name="mainform" action="/goform/formSetWanL2TP" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="dsl_mode" name="dsl_mode" value="<%getInfo("wanType");%>"/>
<input type="hidden" name="config.wan_force_static_dns_servers" id="wan_force_static_dns_servers" value="false" />
<input type="hidden" name="config.wan_ip_mode" id="wan_ip_mode" value="<%getInfo("wanType");%>" />
<input type="hidden" name="config.wan_mtu_use_default" id="wan_mtu_use_default" value="true" />
<input type="hidden" id="mac_cloning_enabled" name="config.mac_cloning_enabled" value="true"/>
<input type="hidden" id="mac_clone" name="mac_clone" value=""/>
<input type="hidden" name="config.wan_l2tp_use_dynamic_carrier" id="wan_l2tp_use_dynamic_carrier" value="<%getIndexInfo("l2tp_wan_ip_mode");%>" />
<input type="hidden" name="config.wan_l2tp_reconnect_mode" id="wan_l2tp_reconnect_mode" value="<% getIndexInfo("l2tpConnectType"); %>" />
<input type="hidden" id="mac_cloning_address" size="20" maxlength="17" value="<% getInfo("wanMac"); %>" name="config.mac_cloning_address" />
<input type="hidden" id="webpage" name="webpage" value="/Basic/wan_l2tp.asp">
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtWAN");</SCRIPT></h2><p><SCRIPT >ddw("txtWANStr2");</SCRIPT></p> 
<p><b><SCRIPT >ddw("txtNote");</SCRIPT>&nbsp;:</b> 
<SCRIPT >ddw("txtWANStr3");</SCRIPT></p> 
<input class="button_submit" type="button" id="SaveSettings"  name="SaveSettings" value="" onclick="page_submit();"/>
<input class="button_submit" type="button" id="DontSaveSettings" name="DontSaveSettings" value="" onclick="page_cancel();"/>
</div></div>
<div class="box"> 
<h3><SCRIPT >ddw("txtInternetConnectionType");</SCRIPT></h3>
<p class="box_msg"><SCRIPT >ddw("txtWANStr5");</SCRIPT></p>
<fieldset><p> <label class="duple">
<SCRIPT >ddw("txtWANStr4");</SCRIPT>&nbsp;:</label>
<select id="wan_ip_mode_select" onchange="wan_ip_mode_selector(this.value);">
</select>	</p></fieldset></div>
<div class="box"><div id="box_wan_l2tp" style="display:block"> 
<h3>L2TP&nbsp;<SCRIPT >ddw("txtInternetConnectionType");</SCRIPT>&nbsp;:</h3>
<p class="box_msg"> <SCRIPT >ddw("txtWANStr1");</SCRIPT></p></div>
<fieldset><div id="box_wan_l2tp_body" style="display:block"><p> 
<label class="duple">&nbsp;</label>
<input id="wan_l2tp_use_dynamic_carrier_radio_1" type="radio" name="wan_l2tp_use_dynamic_carrier_radio" value="true" onclick="wan_l2tp_use_dynamic_carrier_selector(this.value);"/>
<label><SCRIPT >ddw("txtDynamicIP");</SCRIPT></label> 
<input id="wan_l2tp_use_dynamic_carrier_radio_0" type="radio" name="wan_l2tp_use_dynamic_carrier_radio" value="false" onclick="wan_l2tp_use_dynamic_carrier_selector(this.value);"/>
<label><SCRIPT >ddw("txtStaticIP");</SCRIPT></label> 
</p><p> 
<label class="duple" for="wan_l2tp_ip_address"><SCRIPT >ddw("txtL2TPIPAddress");</SCRIPT> &nbsp;:</label>
<input type="text" id="wan_l2tp_ip_address" size="20" maxlength="15" value="<% getIndexInfo("l2tpIp"); %>" name="config.wan_l2tp_ip_address"/>
</p><p> 
<label class="duple" for="wan_l2tp_subnet_mask"><SCRIPT >ddw("txtL2TPSubnetMask");</SCRIPT>&nbsp;:</label>
<input type="text" id="wan_l2tp_subnet_mask" size="20" maxlength="15" value="<% getIndexInfo("l2tpSubnet"); %>" name="config.wan_l2tp_subnet_mask"/>
</p><p> 
<label class="duple" for="wan_l2tp_gateway"><SCRIPT >ddw("txtL2TPGatewayIPAddress");</SCRIPT>&nbsp;:</label>
<input type="text" id="wan_l2tp_gateway" size="20" maxlength="15" value="<% getInfo("l2tp-wan-gateway-rom");%>" name="config.wan_l2tp_gateway"/>
</p>


<p><label class="duple" for="wan_primary_dns"><SCRIPT >ddw("txtPPTPPrimaryDNSServer");</SCRIPT>&nbsp;:</label>
<input type="text" id="wan_primary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns1");%>" name="config.wan_primary_dns"/><script>ddw("txtOptional");</script>
</p>

<p>	<label class="duple" for="mac_cloning_address"><SCRIPT >ddw("txtMACAddress");</SCRIPT>&nbsp;:</label>
<input type=text id=mac1 name=mac1 size=2 maxlength=2 value=""> -
<input type=text id=mac2 name=mac2 size=2 maxlength=2 value=""> -
<input type=text id=mac3 name=mac3 size=2 maxlength=2 value=""> -
<input type=text id=mac4 name=mac4 size=2 maxlength=2 value=""> -
<input type=text id=mac5 name=mac5 size=2 maxlength=2 value=""> -
<input type=text id=mac6 name=mac6 size=2 maxlength=2 value=""> <SCRIPT >ddw("txtOptional");</SCRIPT>&nbsp;&nbsp;
</p>
<p><label class="duple">&nbsp;</label>
<input class="button_submit" type="button" id="clone_mac_addr" value="" onclick="clone_mac();" />
</p>

<p> 
<label class="duple" for="wan_l2tp_server"><SCRIPT >ddw("txtL2TPServerIP");</SCRIPT>&nbsp;:</label>
<input type="text" id="wan_l2tp_server" size="20" maxlength="15" value="<% getIndexInfo("l2tpServerIp"); %>" name="config.wan_l2tp_server"/>
</p><p> 
<label class="duple" for="wan_l2tp_username"><SCRIPT >ddw("txtL2TPUserName");</SCRIPT>&nbsp;:</label>
<input type="text" id="wan_l2tp_username" size="20" maxlength="63" value="<% getIndexInfo("l2tpUserName"); %>" name="config.wan_l2tp_username"/>
</p><p> 
<label class="duple" for="wan_l2tp_password"><SCRIPT >ddw("txtL2TPPassword");</SCRIPT>&nbsp;:</label>
<input type="password" id="wan_l2tp_password" size="20" maxlength="63" onfocus="select();" value="<% getIndexInfo("l2tpPassword"); %>" name="config.wan_l2tp_password"/>
</p><p> 
<label class="duple" for="confirm_wan_l2tp_password"><SCRIPT >ddw("txtL2TPVerifyPassword");</SCRIPT>&nbsp;:</label>
<input type="password" id="confirm_wan_l2tp_password" size="20" maxlength="63" onfocus="select();" value="<% getIndexInfo("l2tpPassword"); %>"/>
</p><p> 
<label class="duple" for="wan_l2tp_max_idle_time"><SCRIPT >ddw("txtMaximumIdleTime");</SCRIPT>&nbsp;:</label>
<input type="text" id="wan_l2tp_max_idle_time" maxlength="5" size="10" value="<% getIndexInfo("l2tpIdleTime"); %>" name="config.wan_l2tp_max_idle_time"/>
<SCRIPT >ddw("txtMinutesInfinite");</SCRIPT> 
</p></div>

<div id="box_wan_general_body" style="display:block"> 
<p><label class="duple" for="wan_mtu">MTU&nbsp;:</label>
<input type="text" id="wan_mtu" size="10" maxlength="5" value="<% getIndexInfo("l2tpMtuSize"); %>" name="config.wan_mtu" />
<SCRIPT >ddw("txtBytes");</SCRIPT>
</p>
<div id="box_wan_reconnect" style="display:block">
<p><label class="duple" for="wan_l2tp_reconnect_mode"><SCRIPT >ddw("txtReconnectMode");</SCRIPT>&nbsp;:</label>
<input type=radio name=l2tp_reconnect_mode_radio id=l2tp_reconnect_mode_radio_0 value=0 onclick="l2tp_reconnect_selector(this.value);">
<input id="ppp_schedule_control_0" name="ppp_schedule_control_0" value="<%getIndexInfo("wanL2TPSchSelectName");%>" type="hidden">
<select id='wan_sch_select' name='wan_sch_select' onChange="wan_schedule_name_selector(this.value);">
</select> &nbsp;<input class="button_submit" type="button" id="add_new_schedule" value="" onclick="do_add_new_schedule(true)">
</p>
<p>
<label class="duple">&nbsp;</label>
<input type=radio name=l2tp_reconnect_mode_radio id=l2tp_reconnect_mode_radio_1 value=2 onclick="l2tp_reconnect_selector(this.value);"><SCRIPT >ddw("txtManual");</SCRIPT>
<input type=radio name=l2tp_reconnect_mode_radio id=l2tp_reconnect_mode_radio_2 value=1 onclick="l2tp_reconnect_selector(this.value);"><SCRIPT >ddw("txtOnDemand");</SCRIPT>
</p>
</div>



</div></fieldset></div></form><SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>
</div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p>	<SCRIPT >ddw("txtWANStr10");</SCRIPT>	</p>
<p>	<SCRIPT >ddw("txtWANStr11");</SCRIPT></p>
<p class="more"><!-- Link to more help -->
<a href="../Help/Basic.asp#WAN" onclick="return jump_if();"><SCRIPT >ddw("txtMore");</SCRIPT>...</a>
</p>
</div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
</html>
