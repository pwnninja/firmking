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
	self.location.href="Wizard_WAN_SelectMode.asp?t="+new Date().getTime();
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
var wan_ip_mode_default;

function page_submit()
{
if (is_form_modified("form1"))  //something changed
{
	get_by_id("settingsChanged").value = 1;
}
get_by_id("curTime").value = new Date().getTime();
//form1.submit();
document.form1.submit();
}
function page_cancel()
{
if (is_form_modified("form1") || get_by_id("settingsChanged").value == 1) {
	if (confirm (sw("txtAbandonAallChanges"))) {
		top.location='Internet.asp?t='+new Date().getTime();
	}
} else {
		top.location='Internet.asp?t='+new Date().getTime();
}			
}
function wan_mode_selector(mode)
{
var form_handle = document.forms[0];
form_handle.wan_ip_mode.value = (mode == BIGPOND)? DHCP : mode;
set_radio(form_handle.wan_ip_mode_radio, mode);
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
document.title = DOC_Title;	
var dF= document.forms[0];
var wan_proto = get_by_id("wan_ip_mode").value;
if(wan_proto == "")
		wan_proto = <%getInfo("wanType");%>;
				
	wan_ip_mode_default = dF.wan_ip_mode.value;
	
	if (wan_proto == PPPOE){
		dF.wan_ip_mode_radio[1].checked=true;
	}else if (wan_proto == PPTP){
		dF.wan_ip_mode_radio[2].checked=true;
}else if(wan_proto == DHCPPLUS && LangCode == "SC"){
		dF.wan_ip_mode_radio[5].checked=true;

	}else if(wan_proto == L2TP){
		dF.wan_ip_mode_radio[3].checked=true;
	}else if(wan_proto == STATIC){
		dF.wan_ip_mode_radio[4].checked=true;
	}else{
		dF.wan_ip_mode_radio[0].checked=true;
	}
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
if(LangCode == "SC")
	document.getElementById("tr_dhcpplus").style.display = "";
else
	document.getElementById("tr_dhcpplus").style.display = "none";

RenderWarnings();
}			
//]]>
</script>
</head>
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;" style="display: none">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td>
<SCRIPT language=javascript type=text/javascript>
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container"><div id="maincontent_1col" style="display: block">

<div id="wz_page_4" style="display:block">
<form id="form1" name="form1" action="http://<% getInfo("goformIpAddr"); %>/goform/formSetWANType_Wizard5" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="wan_ip_mode" name="config.wan_ip_mode" value="<%getWizardInformation("wzwanType");%>"/>												
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStep3");</SCRIPT></h1>
<br>

		<table>
		<tr>
			<td>&nbsp;</td>
			<td>
				<input name="wan_ip_mode_radio" id="wan_ip_mode_radio_1" type="radio" value="1" onchange="wan_mode_selector(this.value);">
				<STRONG><SCRIPT language=javascript type=text/javascript>ddw("txtDHCPConnection");</SCRIPT></STRONG>
				<div>     <SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr10");</SCRIPT></div>
			</td>
		</tr>
		<tr>
			<td class=form_label>&nbsp;</td>
			<td>
				<input name="wan_ip_mode_radio" id="wan_ip_mode_radio_2" type="radio" value="2" onchange="wan_mode_selector(this.value);">
				<STRONG><SCRIPT language=javascript type=text/javascript>ddw("txtUsernamePasswordConnection");</SCRIPT>(PPPoE)</STRONG>
				<div><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr11");</SCRIPT></div>
			</td>
		</tr>
		<tr>
			<td class=form_label>&nbsp;</td>
			<td>
				<input name="wan_ip_mode_radio" id="wan_ip_mode_radio_3" type="radio" value="3" onchange="wan_mode_selector(this.value);">
				<STRONG><SCRIPT language=javascript type=text/javascript>ddw("txtUsernamePasswordConnection");</SCRIPT>(PPTP)</STRONG>
				<div><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr11");</SCRIPT></div>
			</td>
		</tr>
		<tr>
			<td class=form_label>&nbsp;</td>
			<td>
				<input name="wan_ip_mode_radio" id="wan_ip_mode_radio_4" type="radio" value="4" onchange="wan_mode_selector(this.value);">
				<STRONG><SCRIPT language=javascript type=text/javascript>ddw("txtUsernamePasswordConnection");</SCRIPT>(L2TP)</STRONG>
				<div><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr11");</SCRIPT></div>
			</td>
		</tr>
		<tr>
			<td class=form_label>&nbsp;</td>
			<td><input name="wan_ip_mode_radio" id="wan_ip_mode_radio_0" type="radio" value="0" onchange="wan_mode_selector(this.value);">
				<STRONG><SCRIPT language=javascript type=text/javascript>ddw("txtStaticIPAddressConnection");</SCRIPT></STRONG>
				<div> <SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr12");</SCRIPT></div>
			</td>
		</tr>
		<tr id="tr_dhcpplus" style="display:none">
			<td>&nbsp;</td>
			<td>
				<input name="wan_ip_mode_radio" id="wan_ip_mode_radio_5" type="radio" value="9" onchange="wan_mode_selector(this.value);">
				<STRONG>DHCP+</STRONG>
				<div>     <SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr10");</SCRIPT></div>
			</td>
		</tr>
		
		</table>
		<br>
		<center><script>prev("");next("page_submit();");exit();</script></center>
		<br>
</div>								


</form></div><!-- wz_page_4 --></div>								
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
