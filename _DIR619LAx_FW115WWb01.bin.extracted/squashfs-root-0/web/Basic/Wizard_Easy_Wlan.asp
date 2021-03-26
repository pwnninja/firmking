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
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript" src="../time_array.js"></script>
<script type="text/javascript">
//<![CDATA[
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

function next(fn)
{
	document.write("<input type='button' name='next' value=\""+sw("txtSave")+"\" onClick='return "+fn+"'>&nbsp;");
}
function wz_verify_3()
{
	mf=document.forms.wz_form_pg_3;
	/* SSID */
	mf.wireless_SSID.value = trim_string(mf.wireless_SSID.value);
	if (is_blank(mf.wireless_SSID.value)) {
		alert(sw("txtSSIDBlank"));
		mf.wireless_SSID.select();
		mf.wireless_SSID.focus();
		return false;
	}
	//var flag=trim_string(mf.security_type_radio.value);
	/* WPA Key */
	if(mf.security_type_radio_1.checked)
	{
		var keyvalue = mf.wlan_password.value;
		var key_len = keyvalue.length;		
		var test_char, i;
		if (key_len < 8 || key_len > 64) {
				alert(sw("txtWizard_WlanStr1"));
				return false;
		}
		if(key_len >= 8 && key_len < 64)
		{
			if(keyvalue.charAt(0) == ' '|| keyvalue.charAt(key_len-1) == ' ')
			{
				alert(sw("txtheadtailnospeace"));
				return false;
			}
		}	
		if(key_len == 64)
		{	
			for(i=0; i<key_len; i++)
			{
					test_char=keyvalue.charAt(i);
					if( (test_char >= '0' && test_char <= '9') ||
						(test_char >= 'a' && test_char <= 'f') ||
						(test_char >= 'A' && test_char <= 'F'))
						continue;
					alert(sw("txtWPAKeyHexadecimalDigits"));
					return false;
			}
		}
		else
		{
				if(strchk_unicode(keyvalue))
				{
					alert(sw("txtWizard_WlanStrerr"));
					return false;
				}		
		}	
	}

	return true;
}

function page_submit()
{
	var str1 = self.location.href.split('&');
	get_by_id("wan_connected").value = str1[2].substring(5,6);

	if (is_form_modified("wz_form_pg_3"))  //something changed
	{
		get_by_id("settingsChanged").value = 1;
	}
	if(wz_verify_3() == true){
		get_by_id("curTime").value = new Date().getTime();
		if(str1[1] == "current")
		{
			get_by_id("submitflag").value = "current";
		}
		if(str1[1] == "complete")
		{
			get_by_id("submitflag").value = "complete";
		}
		document.wz_form_pg_3.submit();
	}
}
function page_cancel()
{
	if (is_form_modified("wz_form_pg_3") || get_by_id("settingsChanged").value == 1) {
		if (confirm (sw("txtAbandonAallChanges"))) {
			top.location='../logout.asp?t='+new Date().getTime();
		}
	} else {
		top.location='../logout.asp?t='+new Date().getTime();
	}			
}
function on_change_security_type(value)
{
		mf=document.forms.wz_form_pg_3;
        mf.security_type_radio.value=value;
        if(value==1)
		{
                mf.security_type_radio_1.checked=true;
				mf.wlan_password.disabled =false;
				mf.auto_passwd_select.disabled =false;
		} 	
        else
		{
                mf.security_type_radio_0.checked=true;
				mf.wlan_password.disabled =true;	
				mf.auto_passwd_select.disabled =true;			
		}
}
function print_keys()
{
	var mf = document.forms.wz_form_pg_3;
	if(mf.auto_passwd_select.checked == true)
	{
		mf.wlan_password.value = "<%getIndexInfo("autokey-15");%>"
	}
	else
	{
		mf.wlan_password.value = "";
	}
}
function auto_password_selector(value) 
{
	var mf = document.forms.wz_form_pg_3;
	mf.auto_password_enabled.value = (value == true) ? "true" : "false";
	mf.auto_passwd_select.checked = value;
	print_keys();
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
document.title = DOC_Title;
get_by_id("wlan_password").value = "<%getInfo("pskValue");%>";
on_change_security_type(0);	

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
<tr><td id="sidenav_container">&nbsp;</td><td id="maincontent_container">
<div id="maincontent_1col" style="display: block">

<div id="wz_page_3" style="display:block">
<form id="wz_form_pg_3" name="wz_form_pg_3" action="http://<% getInfo("goformIpAddr"); %>/goform/formEasySetupWizard3" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" name="WEBSERVER_SSI_OPLOCK_ACTION" value="post"/>
<input type="hidden" name="WEBSERVER_SSI_OPLOCK_VALUE" value=""/>
<input type="hidden" name="wz_pg_prev" value=""/>
<input type="hidden" name="wz_pg_cur" value=""/>
<input type="hidden" name="wz_modified" value=""/>
<input type="hidden" id="wan_connected"  name="wan_connected" value="0"/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="submitflag" name="config.submitflag" value="">
<input type="hidden" id="wireless_ieee8021x_enabled" name="config.wireless.ieee8021x_enabled" value="<%getIndexInfo("wpa_enterprise_enabled");%>" />
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStep3");</SCRIPT></h1>
		<div>
		<table align="center">
		<tr>
			<td class="r_tb" width=198><SCRIPT>ddw("txtWizardEasySSID");</SCRIPT>&nbsp;:&nbsp;</td>
			<td width="300" class="l_tb"><input type="text" id="wireless_SSID" name="config.wireless.SSID" size="20" maxlength="32" value="<%getInfo("ssid");%>"></td>
		</tr>
		<tr>
			<td class="r_tb"><SCRIPT>ddw("txtSecurityMode");</SCRIPT>&nbsp;:&nbsp;</td>
			<td class="l_tb">
            <input id="security_type_radio_0" type="radio" name="security_type_radio" value="0" onclick="on_change_security_type(this.value);"> <SCRIPT>ddw("txtWizardEasyStepCloseSecuity");</SCRIPT></td>
		</tr>
		<tr>
			<td class="r_tb"></td>
			<td class="l_tb">
            <input id="security_type_radio_1" type="radio" name="security_type_radio" value="1" onclick="on_change_security_type(this.value);"> <SCRIPT>ddw("txtWizardEasyStepAutoWPA");</SCRIPT></td>
		</tr>
		<tr>
			<td class="r_tb" width=198><SCRIPT>ddw("txtPreSharedKey");</SCRIPT>&nbsp;:&nbsp;</td>
			<td width="300" class="l_tb"><input type=text id="wlan_password" name="config.wlan_password" size=63 maxlength=15 ></td>
		</tr>
		<tr>
			<td class="r_tb" width=198><input type="hidden" id="auto_password_enabled" name="config.auto_password_enabled" value="false"><input type="checkbox" id="auto_passwd_select" onclick="auto_password_selector(this.checked)">&nbsp;:&nbsp;</td>
			<td width="300" class="l_tb"><SCRIPT>ddw("txtWizardEasyStepProductKey");</SCRIPT></td>
		</tr>				
		</table>
		</div>
		<br>		
		<center><script>next("page_submit();");</script></center>
		<br>
		
</form></div><!-- wz_page_3 -->

</div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();	</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
