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
var pcmac;
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
	/*user name and password*/
	if(LangCode == "SC" && "<%getWizardInformation("wzwanType");%>" == "9"){ /*DHCPPLUS*/
		if (form_handle.pppoe_password.value != form_handle.second_pppoe_password.value) {
			alert(sw("txtThePasswordsDontMatch"));
			try {
				form_handle.pppoe_password.select();
				form_handle.pppoe_password.focus();
			} catch (e) {
			}
			return;
		}
		if (is_blank(form_handle.pppoe_username.value))
		{
		   alert(sw("txtUserNameBlank"));
		   form_handle.pppoe_username.focus();
		   return false;
		}
		if(utf8len(form_handle.pppoe_username.value) > 63)
		{
			alert(sw("txtUserName") + sw("txtIsInvalid"));
		   	form_handle.pppoe_username.focus();
		   	return false;

		}
	}
	form_handle.mac_cloning_address.value=form_handle.mac1.value+':'+form_handle.mac2.value+':'+form_handle.mac3.value+':'+form_handle.mac4.value+':'+form_handle.mac5.value+':'+form_handle.mac6.value;		
	form_handle.mac_cloning_address.value = trim_string(form_handle.mac_cloning_address.value);

	if (is_blank(form_handle.wan_dhcp_gw_name.value) || !strchk_hostname(form_handle.wan_dhcp_gw_name.value)) {
		alert(sw("txtInvalidHostName"));
		return false;
	}

	if (!form_handle.mac_cloning_address.value) {
			form_handle.mac_cloning_enabled.value = "false";
		}
	if (form_handle.mac_cloning_enabled.value == "true" && !verify_mac(form_handle.mac_cloning_address.value, form_handle.mac_cloning_address)) {
			alert(sw("txtInvalidMACAddress"));
			form_handle.mac_cloning_address.select();
			form_handle.mac_cloning_address.focus();
			return false;
	}else	{
	var mac_addr = form_handle.mac_cloning_address.value.split(":");					
	form_handle.mac_cloning_enabled.value = "true";
	form_handle.mac_clone.value = "";
	for(var i=0;i<mac_addr.length;i++)
	{
		form_handle.mac_clone.value += mac_addr[i];
	}
	}
	return true;
}
function clone_mac_selector()
{
var form_handle = document.forms[0];
form_handle.mac_cloning_address.value = trim_string(form_handle.mac_cloning_address.value);
form_handle.mac_cloning_enabled.value = form_handle.mac_cloning_address.value ? "true" : "false";
}
function clone_mac()
{
var copy_mac;
var form_handle = document.forms[0];
form_handle.mac_cloning_enabled.value = "true";

form_handle.mac_cloning_address.value = pcmac;
copy_mac=form_handle.mac_cloning_address.value; 
form_handle.mac1.value=copy_mac.substring(0,2);
form_handle.mac2.value=copy_mac.substring(3,5);
form_handle.mac3.value=copy_mac.substring(6,8);
form_handle.mac4.value=copy_mac.substring(9,11);
form_handle.mac5.value=copy_mac.substring(12,14);
form_handle.mac6.value=copy_mac.substring(15,17);
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
	get_by_id("settingsChanged").value = 1;
	document.wz_form_pg_5.submit();
}
}
function page_cancel()
{
	var form_handle = document.forms[0];
	if (is_form_modified(form_handle) || get_by_id("settingsChanged").value == 1) {
		if (confirm (sw("txtAbandonAallChanges"))) {
		top.location='Internet.asp?t='+new Date().getTime();
	}
	} else {
			top.location='Internet.asp?t='+new Date().getTime();
	}			
}
function init()
{
var oldmac;
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
document.title = DOC_Title;
mf = document.forms["wz_form_pg_5"];
get_by_id("CloneMACAddress").value = sw("txtCopyMACAddress");	
pcmac = "<% getInfo("host-hwaddr"); %>";
oldmac=mf.mac_cloning_address.value; 
mf.mac1.value=oldmac.substring(0,2);
mf.mac2.value=oldmac.substring(3,5);
mf.mac3.value=oldmac.substring(6,8);
mf.mac4.value=oldmac.substring(9,11);
mf.mac5.value=oldmac.substring(12,14);
mf.mac6.value=oldmac.substring(15,17);	
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
if(LangCode == "SC" && "<%getWizardInformation("wzwanType");%>" == "9"){ /*DHCPPLUS*/
	document.getElementById("tr_dhcpplus_user").style.display = ""
	document.getElementById("tr_dhcpplus_passwd").style.display = ""
	document.getElementById("tr_dhcpplus_passwdv").style.display = ""
}
else{
	document.getElementById("tr_dhcpplus_user").style.display = "none"
	document.getElementById("tr_dhcpplus_passwd").style.display = "none"
	document.getElementById("tr_dhcpplus_passwdv").style.display = "none"
}
RenderWarnings();
}
//]]>
</script>
</head>
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;" style="display: none">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td><SCRIPT language=javascript type=text/javascript>
DrawHeaderContainer();DrawMastheadContainer();</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">
<div id="maincontent_1col" style="display: block">
<div id="wz_page_5" style="display:block">
<form id="wz_form_pg_5" name="wz_form_pg_5" action="http://<% getInfo("goformIpAddr"); %>/goform/formSetWAN_Wizard51" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" id="mac_clone" name="mac_clone" value=""/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtDHCPConnection");</SCRIPT></h1>
<p><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr13");</SCRIPT></p>

		<table align="center">
        <tr id="tr_dhcpplus_user" style="display:none">
            <td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtUserName");</SCRIPT> :</strong></td>
            <td class="l_tb">
                <input type=text id="pppoe_username" name="config.pppoe_username" size=30 maxlength=63 value="<% getWizardInformation("pppUserName"); %>">
            </td>
        </tr>
        <tr id="tr_dhcpplus_passwd" style="display:none">
            <td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT> :</strong></td>
            <td class="l_tb">
                <input type=password id="pppoe_password" name="config.pppoe_password" onfocus="select();" size=30 maxlength=63 value="<% getWizardInformation("pppPassword"); %>">
            </td>
        </tr>
        <tr id="tr_dhcpplus_passwdv" style="display:none">
            <td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtVerifyPassword");</SCRIPT> :</strong></td>
            <td class="l_tb">
                <input type=password id="second_pppoe_password" onfocus="select();" size=30 maxlength=63 value="<% getWizardInformation("pppPassword"); %>">
            </td>
        </tr>
		<tr>
			<td class="r_tb" width="137"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtMACAddress");</SCRIPT> :</strong></td>
			<td class="l_tb" width="473">
				<input type=text id=mac1 name=mac1 size=2 maxlength=2 value=""> -
				<input type=text id=mac2 name=mac2 size=2 maxlength=2 value=""> -
				<input type=text id=mac3 name=mac3 size=2 maxlength=2 value=""> -
				<input type=text id=mac4 name=mac4 size=2 maxlength=2 value=""> -
				<input type=text id=mac5 name=mac5 size=2 maxlength=2 value=""> -
				<input type=text id=mac6 name=mac6 size=2 maxlength=2 value=""> <SCRIPT language=javascript type=text/javascript>ddw("txtOptional");</SCRIPT>
				<input type=hidden id=mac_cloning_address name=mac_cloning_address value="<% getWizardInformation("wanMac"); %>">
<input type="hidden" id="mac_cloning_enabled" name="config.mac_cloning_enabled" value="true"/>
			</td>
		</tr>
		<tr>
			<td class="r_tb">&nbsp;</td>
			<td class="l_tb">
				<input type=button id="CloneMACAddress" name="CloneMACAddress" value="" onclick='clone_mac()'>
			</td>
		</tr>
		<tr>
			<td class="r_tb"><strong><SCRIPT language=javascript type=text/javascript>ddw("txtHostName");</SCRIPT> :</strong></td>
			<td class="l_tb"><input type=text id="wan_dhcp_gw_name" name="config.wan_dhcp_gw_name" size=40 maxlength=39 value="<% getWizardInformation("hostName"); %>"></td>
		</tr>
		<tr>
			<td class="r_tb">&nbsp;</td>
			<td class="l_tb"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr14");</SCRIPT></td>
		</tr>
		</table>
		<br>
		<center><script>prev("");next("page_submit();");exit();</script></center>
		<br>
		</div>

</form>	</div>
 <!-- wizard_box --></div>								
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
