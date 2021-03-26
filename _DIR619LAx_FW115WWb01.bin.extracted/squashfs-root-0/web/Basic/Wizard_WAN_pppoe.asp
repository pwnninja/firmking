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
#wan_modes p {
	margin-bottom: 1px;
}
#wan_modes input {
	float: left;
	margin-right: 1em;
}
#wan_modes label.duple {
	float: none;
	width: auto;
	text-align: left;
}
#wan_modes .itemhelp {
	margin: 0 0 1em 2em;
}
#wz_buttons {
	margin-top: 1em;
	border: none;
}
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[
function go_prev()
{
	if("<%getWizardInformation("wizardWanConnMode");%>" == "0")   
  	self.location.href = "Wizard_WAN_SelectMode.asp?t"+new Date().getTime();   
 	else 	
	self.location.href="Wizard_WAN_List.asp?t="+new Date().getTime();
}	
function prev(fn)
{
	if(fn=="") fn="go_prev();";
	document.write("<input type='button' name='prev' value=\""+sw("txtPrev")+"\" onClick='"+fn+"'>&nbsp;");
}
function next(fn)
{
	if(fn=="")
		document.write("<input type='submit' name='next' value=\""+sw("txtNext")+"\" onClick=\"\">&nbsp;");
	else
		document.write("<input type='button' name='next' value=\""+sw("txtNext")+"\" onClick='return "+fn+"'>&nbsp;");
}

function exit()
{
	document.write("<input type='button' name='exit' value=\""+sw("txtCancel")+"\" onClick=\"page_cancel()\">&nbsp;");
}
function wz_verify_5()
{
var form_handle = document.forms[0];
	if(is_blank(form_handle.pppoe_username.value))
	{
		alert(sw("txtUserNameBlank"));
		form_handle.pppoe_username.focus();
		return false;
	}
	if(strchk_unicode(form_handle.pppoe_username.value) == true)
	{
		alert(sw("txtUserName")+sw("txtisInvalid"));
		form_handle.pppoe_username.focus();
		return false;
	}
form_handle.pppoe_password.value = trim_string(form_handle.pppoe_password.value);
if(form_handle.pppoe_use_dynamic_address.value == "false" )
{	
	if (!is_ipv4_valid(form_handle.pppoe_ip_address.value) || form_handle.pppoe_ip_address.value=="0.0.0.0" || is_FF_IP(form_handle.pppoe_ip_address.value)) {
		alert(sw("txtInvalidIPAddress"));
		form_handle.pppoe_ip_address.select();
		form_handle.pppoe_ip_address.focus();
		return false;
	}

	var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
	var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
	var wan_ip = ipv4_to_unsigned_integer(form_handle.pppoe_ip_address.value);
	if ((LAN_IP & LAN_MASK) == (wan_ip & LAN_MASK))
	{
		alert(sw("txtWanSubConflitLanSub"));
		return false;
	}
}
if (form_handle.second_pppoe_password.value !== form_handle.pppoe_password.value) {
	alert(sw("txtTwoPasswordsNotSame"));
	form_handle.pppoe_password.select();
	form_handle.pppoe_password.focus();
	return false;
}
 var ppp_ser_len = utf8len(form_handle.pppoe_service_name.value);
  if(ppp_ser_len > 63)
  {
          alert(sw("txtpppseverlen"));
          form_handle.pppoe_service_name.focus();
          return false;
  }
	if(!strchk_hostname(form_handle.pppoe_service_name.value) == true)
	{
		alert(sw("txtServiceName")+sw("txtisInvalid"));
		form_handle.pppoe_service_name.focus();
		return false;
	}
return true;
}
function pppoe_use_dynamic_address_selector(mode)
{
var form_handle = document.forms[0];
set_radio(form_handle.pppoe_use_dynamic_address_radio, mode);
form_handle.pppoe_use_dynamic_address.value = mode;
if(mode == "true") {
		form_handle.pppoe_ip_address.disabled = true;
	} else {
		form_handle.pppoe_ip_address.disabled = false;
	}			
}
function page_load() 
{
var form_handle = document.forms[0];		
pppoe_use_dynamic_address_selector(form_handle.pppoe_use_dynamic_address.value);
}
function wz_prev()
{
	location.href = "Wizard_WAN_List.asp?t"+new Date().getTime();
}
function page_submit()
{
if (is_form_modified("wz_form_pg_5"))  //something changed
{
	get_by_id("settingsChanged").value = 1;
}
if(wz_verify_5() == true){
	get_by_id("curTime").value = new Date().getTime();
	//wz_form_pg_5.submit();
	document.wz_form_pg_5.submit();
	}
}

function page_cancel()
{
if (is_form_modified("wz_form_pg_5") || get_by_id("settingsChanged").value == 1) {
	if (confirm (sw("txtAbandonAallChanges"))) {
		top.location='Internet.asp?t='+new Date().getTime();
	}
} else {
		top.location='Internet.asp?t='+new Date().getTime();
}			
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
document.title = DOC_Title;
set_form_default_values("wz_form_pg_5");
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
page_load();
RenderWarnings();
}			
//]]>
</script>
</head>
<body onload="template_load(); init();web_timeout();">
<div id="loader_container" onclick="return false;" style="display: none">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td>
<SCRIPT language=javascript type=text/javascript>
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td><td id="maincontent_container">
<div id="maincontent_1col" style="display: block">

<div id="wz_page_5" style="display:block">
<form id="wz_form_pg_5" name="wz_form_pg_5" action="http://<% getInfo("goformIpAddr"); %>/goform/formSetWAN_Wizard534" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" id="pppoe_netsniper" name="config.pppoe_netsniper" value="false"/>
<input type="hidden" name="config.pppoe_use_dynamic_address" id="pppoe_use_dynamic_address" value="<%getWizardInformation("wzwan_pppoe_ip_mode");%>" />
<input type="hidden" id="curTime" name="curTime" value=""/>
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtSetUsernameAndPassword");</SCRIPT>(PPPOE)</h1>
<p><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr15");</SCRIPT></p>

		<table>
		<tr>
			<td class="r_tb" width="200"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtAddressMode");</SCRIPT> :</strong></td>
			<td class="l_tb" width="410">
				<input type=radio value="true" id="pppoe_use_dynamic_address_radio_1" name="pppoe_use_dynamic_address_radio" onclick=pppoe_use_dynamic_address_selector(this.value)><SCRIPT language=javascript type=text/javascript>ddw("txtDynamicIP");</SCRIPT>
				<input type=radio value="false" id="pppoe_use_dynamic_address_radio_0" name="pppoe_use_dynamic_address_radio" onclick=pppoe_use_dynamic_address_selector(this.value)><SCRIPT language=javascript type=text/javascript>ddw("txtStaticIP");</SCRIPT>
				
			</td>
		</tr>
		<tr>
			<td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtIPAddress");</SCRIPT> :</strong></td>
			<td class="l_tb">
				<input type=text id="pppoe_ip_address" name="config.pppoe_ip_address" size=16 maxlength=15 value="<% getWizardInformation("pppoe-ip");%>">
			</td>
		</tr>
		<tr>
			<td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtUserName");</SCRIPT> :</strong></td>
			<td class="l_tb">
				<input type=text id="pppoe_username" name="config.pppoe_username" size=30 maxlength=63 value="<% getWizardInformation("pppUserName"); %>">
			</td>
		</tr>
		<tr>
			<td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT> :</strong></td>
			<td class="l_tb">
				<input type=password id="pppoe_password" name="config.pppoe_password" onfocus="select();" size=30 maxlength=63 value="<% getWizardInformation("pppPassword"); %>">
			</td>
		</tr>
		<tr>
			<td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtVerifyPassword");</SCRIPT> :</strong></td>
			<td class="l_tb">
				<input type=password id="second_pppoe_password" onfocus="select();" size=30 maxlength=63 value="<% getWizardInformation("pppPassword"); %>">
			</td>
		</tr>
		<tr>
			<td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtServiceName");</SCRIPT> :</strong></td>
			<td class="l_tb">
				<input type=text id="pppoe_service_name" name="config.pppoe_service_name" size=30 maxlength=63 value="<% getWizardInformation("pppServiceName"); %>">&nbsp;<SCRIPT language=javascript type=text/javascript>ddw("txtOptional");</SCRIPT>
			</td>
		</tr>
		<tr>
			<td class="r_tb">&nbsp;</td>
			<td class="l_tb"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr16");</SCRIPT>
			</td>
		</tr>
		</table>
		<br>
		
		<center><script>prev("");next("page_submit();");exit();</script></center>
		<br>
		</div>
<!-- wan_ip_mode_box_2 --></form></div><!-- wz_page_5 -->
</div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
