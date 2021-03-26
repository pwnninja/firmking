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
#legend_show {
		border:solid;
        border-width:1px; 
        margin: 0;
        color:#CCCCCC;
}
legend{
		color:#000000;
		font-size: 12px;
		font-weight: bold;
}
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[
var connect;
function GoToWlan()
{
	self.location.href="Wizard_Easy_Wlan.asp?t="+new Date().getTime()+"&complete&mode="+connect;
}

function GoToSign()
{
	if(connect==1)
	{
		self.location.href="Wizard_Mydlink_Sign.asp?t="+new Date().getTime()+"&err=0&sign_in&complete";
	}
	else
	{
		document.getElementById("show_mydlink_info").innerHTML = sw("txtWizardMydlinkWanIsNotOK");
	}
}

var __AjaxAsk = null;
function __createRequest()
{
	var request = null;
	try { request = new XMLHttpRequest(); }
	catch (trymicrosoft)
	{
		try { request = new ActiveXObject("Msxml2.XMLHTTP"); }
		catch (othermicrosoft)
		{
			try { request = new ActiveXObject("Microsoft.XMLHTTP"); }
			catch (failed)
			{
				request = null;
			}
		}
	}
	if (request == null) alert("Error creating request object !");
	return request;
}
function doCheckSubmit(actionUrl)
{
	var mf = document.forms.wz_form_pg_6;
	if (__AjaxAsk == null) __AjaxAsk = __createRequest();
	__AjaxAsk.open("POST", actionUrl, true);
	__AjaxAsk.setRequestHeader('Content-type','application/x-www-form-urlencoded');  
	__AjaxAsk.send("config.password="+mf.password.value);
	
}

/*
function dumptxt()
{
	doCheckSubmit("/goform/formdumpeasysetup");
}
*/
function page_submit()
{
	var mf = document.forms.wz_form_pg_6;
	
	get_by_id("curTime").value = new Date().getTime();
	mf.submit();

}
function save_network_selector(value)
{
        var mf = document.forms.wz_form_pg_6;
        mf.save_network_enabled.value = value;
        mf.saveNetwork_select.checked = value;
}
function save_device_selector(value) 
{
	var mf = document.forms.wz_form_pg_6;
	var oldpassword = "<%getIndexInfo("adminPass");%>";
	if(value == true)
	{	
		if(mf.wireless_wpa_enabled.value == "true")
		{
			var adpassword = "<%getInfo("pskValue");%>";
			adpassword = adpassword.substring(0,15);
		}
		if(mf.wireless_wpa_enabled.value == "false" && mf.wireless_wepon.value == "false")
		{
			var adpassword = "";
		}		
		document.getElementById("admin_password").innerHTML = adpassword;
		mf.password.value=encode_base64(adpassword);
	}
	else
	{
		document.getElementById("admin_password").innerHTML = oldpassword;
		mf.password.value= encode_base64(oldpassword);;
	}
	
	doCheckSubmit("/goform/formSetEasy_Wizard");
}
function init_show_wan_connect_mode()
{
	var mf = document.forms.wz_form_pg_6;
			
		if(mf.wan_ip_mode.value == "1")
		{
			document.getElementById("wan_connect_mode").innerHTML = sw("txtDynamicIP");
		}
		else if(mf.wan_ip_mode.value == "2")
		{
			document.getElementById("wan_connect_mode").innerHTML = sw("txtPPPOE");
		}
		else if(mf.wan_ip_mode.value == "3")
		{
			document.getElementById("wan_connect_mode").innerHTML = sw("txtPPTP");
		}
		else if(mf.wan_ip_mode.value == "4")
		{
			document.getElementById("wan_connect_mode").innerHTML = sw("txtL2TP");
		}
		else if(mf.wan_ip_mode.value == "9")
		{
			document.getElementById("wan_connect_mode").innerHTML = "DHCP +";
		}
		else if(mf.wan_ip_mode.value == "0")
		{
			document.getElementById("wan_connect_mode").innerHTML = sw("txtStaticIP");
		}
}

function init_show_wan_connect_status()
{
	var str1 = self.location.href.split('&');
	var str2 = str1[1].substring(5,6);
	
	var register_status = "<%getInfo("mydlink_register_status");%>";
	connect = str2 *1;
	
	if(connect==1)
	{
		document.getElementById("wan_connect_status").innerHTML = "<font color=#33ff00>" + sw("txtWizardEasyStepWanIsOK")+ "</font>";
		if(register_status==1)
		{
			document.getElementById("show_mydlink_info").innerHTML = sw("txtWizardMydlinkSignIsOK");
			document.getElementById("mydlink_sign_status").innerHTML = "<font color=#33ff00>" + sw("txtMydlinkRegisterOn")+ "</font>";
			get_by_id("mydlink_configure").disabled = true;	
		}
		else
		{
			if(str1[2] != null)
			{
				document.getElementById("show_mydlink_info").innerHTML = sw("txtWizardMydlinkSignupRight") + str1[2] +sw("txtWizardMydlinkSignupRight2");
			}
			else
			{
				document.getElementById("show_mydlink_info").innerHTML = sw("txtWizardMydlinkSignIsNotOK");
			}
			document.getElementById("mydlink_sign_status").innerHTML = "<font color=red>" + sw("txtMydlinkegisterOff")+ "</font>";
			if(LangCode == "SC")
			{
				get_by_id("mydlink_string1").style.display = "";
				get_by_id("mydlink_string2").style.display = "";
				get_by_id("mydlink_string3").style.display = "";
			}

			get_by_id("mydlink_configure").disabled = false;
		}
	}
	else
	{
		document.getElementById("wan_connect_status").innerHTML = "<font color=red>" +sw("txtWizardEasyStepWanIsNotOK")+ "</font>";
		document.getElementById("show_mydlink_info").innerHTML = sw("txtWizardMydlinkSignIsNotOK");	
		document.getElementById("mydlink_sign_status").innerHTML = "<font color=red>" + sw("txtMydlinkegisterOff")+ "</font>";
		if(LangCode == "SC")
		{
				get_by_id("mydlink_string1").style.display = "";
				get_by_id("mydlink_string2").style.display = "";
				get_by_id("mydlink_string3").style.display = "";
		}
		get_by_id("mydlink_configure").disabled = false;	
	}
	if(str1[3] != null)
	{
		document.getElementById("admin_password").innerHTML = str1[3];	
		get_by_id("password").value = encode_base64(str1[3]);			
	}
	else
	{
                document.getElementById("admin_password").innerHTML = "<%getIndexInfo("adminPass");%>";
                var oldpassword = "<%getIndexInfo("adminPass");%>";
                get_by_id("password").value = encode_base64(oldpassword);	
	}
}
function init_show_wlan_security_type()
{
	var mf = document.forms.wz_form_pg_6;			
	
	if(mf.wireless_wepon.value == "true")
	{
		get_by_id("network_key_show").style.display = "none";
		document.getElementById("wlan_security").innerHTML = "WEP";
		document.getElementById("wan_wlan_status").innerHTML = "<font color=#33ff00>" +sw("txtEncryption")+ "</font>";
	}
	else if(mf.wireless_wpa_enabled.value == "true")
	{
		if(mf.wireless_wpa_mode.value == 1)
		{
			get_by_id("network_key_show").style.display = "none";
			document.getElementById("wlan_security").innerHTML = "WPA Only";
		}
		else if(mf.wireless_wpa_mode.value == 3)
		{
			get_by_id("network_key_show").style.display = "none";
			document.getElementById("wlan_security").innerHTML = "WPA2 Only";
		}
		else
		{
			get_by_id("network_key_show").style.display = "";
			document.getElementById("wlan_security").innerHTML = sw("txtAutoWPAorWPA2Personal");
		}
		document.getElementById("wan_wlan_status").innerHTML = "<font color=#33ff00>" +sw("txtEncryption")+ "</font>";
	}
	else
	{
		get_by_id("network_key_show").style.display = "none";
		document.getElementById("wlan_security").innerHTML = sw("txtDisabled");
		document.getElementById("wan_wlan_status").innerHTML = "<font color=red>" +sw("txtWizardEasyStepNotSafe")+ "</font>";
		document.getElementById("show_tip").innerHTML = sw("txtWizardEasyStepNotSafeReconfig");
	}	
}
function Lang_Check()
{
	if(LangCode =='TW'){
		
			document.getElementById("show_info").innerHTML = sw("txtWizardEasyStep4Str3");
	}
}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
document.title = DOC_Title;	
get_by_id("wz_save_b").value = sw("txtSave");	
get_by_id("configure").value = sw("txtWizardEasyStepConfig");
get_by_id("mydlink_configure").value = sw("txtWizardEasyStepConfig");	
set_form_default_values("wz_form_pg_6");	
var mf = document.forms.wz_form_pg_6;
init_show_wan_connect_mode();
init_show_wan_connect_status();
//save_network_selector(mf.save_network_enabled.value == "true");
//save_device_selector(mf.save_device_enabled.value == "true");
//var adpassword = "<%getIndexInfo("adminPass");%>";
var ssid="<%getInfo("ssid");%>";
var new_ssid="";
for(i=0;i<ssid.length;i++)
{
    var char=ssid.substring(i,i+1);
    if(char==' ')
    {
        new_ssid+="&nbsp;";
    }
    else if(char=='&')
    {
        new_ssid+="&amp;";
    }
    else
    {
        new_ssid+=char;
    }
}
//document.getElementById("admin_password").innerHTML = adpassword;
document.getElementById("wlan_network_name").innerHTML = new_ssid;
init_show_wlan_security_type();
document.getElementById("wlan_network_key").innerHTML = "<%getInfo("pskValue");%>";

Lang_Check();
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
RenderWarnings();
}		
//]]>
</script>
</head>
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;" style="display: none">&nbsp;</div>
<div id="outside_1col"><table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td><SCRIPT language=javascript type=text/javascript>
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr><td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">
<SCRIPT language=javascript type=text/javascript>DrawRebootContent();</SCRIPT>
<div id="maincontent" style="display: block">
<div id="wz_page_6" style="display:block">
<form id="wz_form_pg_6" name="wz_form_pg_6" action="http://<% getInfo("goformIpAddr"); %>/goform/formdumpeasysetup" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="wan_ip_mode" name="config.wan_ip_mode" value="<%getInfo("wanType");%>">
<input type="hidden" id="password" name="config.password" value="">
<input type="hidden" id="submitflag" name="config.submitflag" value="complete">
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepEasySetupOK");</SCRIPT>	</h1>
<p class="box_msg" style="display:block"><font color="#0000FF"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPressStore");</SCRIPT></font></p>
		<fieldset id="legend_show">
		<legend><SCRIPT>ddw("txtWizardEasyStep4Str2");</SCRIPT></legend>
		<table align="center" width="600">
		<tr><td align="right" width="35%" height=22><font color="#000000"><B><SCRIPT>ddw("txtInternetConnection");</SCRIPT></B></font></td>
		<td align="left" width="30%" height=22>&nbsp;<font color="#000000"><B>:</B></font>&nbsp;&nbsp;<font color="#000000"><span id="wan_connect_mode">&nbsp;</span></font>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" width="35%" height=22><font color="#000000"><B><SCRIPT>ddw("txtStatus");</SCRIPT>&nbsp;:&nbsp;</B></font><span id="wan_connect_status"></span></td>
		</tr>
		<tr><td align="left" height=30 colspan="3"><font color="#0000FF"><B><span id="show_internet_tip"></span></B></font></td>
		</tr>
		</table>
		</fieldset>
		<br>
		<fieldset id="legend_show">
		<legend><SCRIPT>ddw("txtWirelessSettings");</SCRIPT></legend>
		<table align="center" width="600">
		<input type="hidden" id="wireless_wepon" name="config.wireless.wepon" value="<%getIndexInfo("wep_enabled");%>">
		<input type="hidden" id="wireless_wpa_enabled" name="config.wireless.wpa_enabled" value="<%getIndexInfo("wpa_enabled");%>">
		<input type="hidden" id="wireless_wpa_mode" name="config.wireless.wpa_mode" value="<%getIndexInfo("wpa_mode");%>">
		<tr><td align="right" width="40%" height=22><font color="#000000"><B><SCRIPT>ddw("txtNetworkNameSSID");</SCRIPT></B></font></td>
		<td align="left" width="25%" height=22>&nbsp;<font color="#000000"><B>:</B></font>&nbsp;&nbsp;<font color="#000000"><span id="wlan_network_name">&nbsp;</span></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" width="35%" height=22><font color="#000000"><B><SCRIPT>ddw("txtStatus");</SCRIPT>&nbsp;:&nbsp;</B></font><span id="wan_wlan_status"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" id="configure" name="configure" value="" onclick="GoToWlan()"></td></tr>
		<tr><td align="right" height=22><font color="#000000"><B><SCRIPT>ddw("txtSecurity");</SCRIPT></B></font></td><td colspan="2">&nbsp;<font color="#000000"><B>:</B></font>&nbsp;&nbsp;<font color="#000000"><span id="wlan_security">&nbsp;</span></font></td></tr>
		<tr id="network_key_show" style="DISPLAY: none"><td align="right" height=22><font color="#000000"><B><SCRIPT>ddw("txtPreSharedKey");</SCRIPT></B></font></td><td colspan="2">&nbsp;<font color="#000000"><B>:</B></font>&nbsp;&nbsp;<font color="#000000"><span id="wlan_network_key">&nbsp;</span></font></td></tr>
		<tr><td colspan="3" align="center"><font color="#0000FF"><B><span id="show_tip"></span></B></font></td></tr>
		</table>
		</fieldset>		
		<br>
		<fieldset id="legend_show">
		<legend><SCRIPT>ddw("txtDeviceInfo");</SCRIPT></legend>
		<table align="center" width="600">
		<tr><td align="right" width="40%" height=22><font color="#000000"><B><SCRIPT>ddw("txtUserName");</SCRIPT></B></font></td><td>&nbsp;<font color="#000000"><B>:</B></font>&nbsp;&nbsp;<font color="#000000">&nbsp;<%getIndexInfo("adminName");%></font></td>
		</tr>
		<tr><td align="right" width="40%" height=22><font color="#000000"><B><SCRIPT>ddw("txtPassword");</SCRIPT></B></font></td><td>&nbsp;<font color="#000000"><B>:</B></font>&nbsp;&nbsp;<font color="#000000">&nbsp;<span id="admin_password"></span></font></td>
		</tr>
		</table>
		</fieldset>
		<br>
		<fieldset id="legend_show">
		<legend><SCRIPT>ddw("txtMydlinkInfo");</SCRIPT></legend>
		<table align="center" width="600">
		<tr><td align="center" width="65%" height=22><font color="#0000FF"><B><span id="show_mydlink_info"></span></B></font></td>
		<td align="left" height=22><font color="#000000"><B><SCRIPT>ddw("txtState");</SCRIPT>&nbsp;:&nbsp;</B></font><font color="#33FF00"><span id="mydlink_sign_status"></span></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" id="mydlink_configure" name="mydlink_configure" value="" onclick="GoToSign()"></td></tr>
		</table>
		<table width="300" align="center">
		<tr id="mydlink_string1" style="display:none"><td colSpan=3 align=left height="57"><font color="#000000"><B><SCRIPT>ddw("txtMydlinkstring1");</SCRIPT></B></font></td></tr>
		<tr id="mydlink_string2" style="display:none"><td colSpan=3 align=left height="51"><font color="#000000"><B><SCRIPT>ddw("txtMydlinkstring2");</SCRIPT></B></font></td></tr>
		<tr id="mydlink_string3" style="display:none"><td colSpan=3 align=left><font color="#000000"><B><SCRIPT>ddw("txtMydlinkstring3");</SCRIPT></B></font></td></tr>
		</table>
		</fieldset>		
		<br>
		<table align="center" width="600">
		<tr><td align="right" width="50%" height=22><input type="hidden" id="save_network_enabled" name="config.save_network_enabled" value=""><input type="checkbox" id="saveNetwork_select" onclick="save_network_selector(this.checked)"></td><td>&nbsp;<font color="#000000"><B><SCRIPT>ddw("txtWizardEasyStepSaveMyconfig");</SCRIPT></B></font></td>
		</tr>
		</table>
		<font color="#0000FF"><B><span id="show_info"></span></B></font>
		<center>
		<script>
		document.write("<input type='button' id='wz_save_b' name='wz_save_b' value=\"\" onClick='page_submit();'>&nbsp;");
		</script>
		</center>
		</div>
</form></div><!-- wz_page_6 --><!-- wizard_box --></div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();	</SCRIPT><% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td>
</tr></table><SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
