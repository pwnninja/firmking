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
<script type="text/javascript">
//<![CDATA[
var admin_pwd = "<%getInfo("adminpasswd");%>";
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
RenderWarnings();
}

function verify_password()
{
	var f = document.forms["wz_form_pg_5"];
	if(f.password.value == "")
	{
		alert(sw("txtNewPassword")+sw("txtIsBlank"));
		f.password.selected = true;
		return false;
	}
	var password = f.password.value;
	if(password.length < "6")
	{
		alert(sw("txtPasswordCheckLength"));
		f.password.selected = true;
		return false;
	}
	if(strchk_unicode(f.password.value)==true)
	{
		alert(sw("txtUserInvalid3"));
		f.password.selected = true;
		return false;
	}
        if (f.password_verify.value !== f.password.value)
	{
		alert(sw("txtTwoPasswordsNotSame"));
		return false;
	}
	var pwd1 = get_by_id("password").value;
	var pwd2 = get_by_id("password_verify").value;
	if((pwd1 != admin_pwd) && (pwd2 != admin_pwd))
	{
		get_by_id("password").value = encode_base64(pwd1);
		get_by_id("password_verify").value= encode_base64(pwd2);
	}
	else
	{
		get_by_id("password").value = admin_pwd;
		get_by_id("password_verify").value = admin_pwd;
	}
	return true;
}
	
function prev()
{
	document.write("<input type='button' id='prev' name='prev' value=\""+sw("txtPrev")+"\" onClick=\"page_prev()\">&nbsp;");
}
function next()
{
	document.write("<input type='button' id='next' name='next' value=\""+sw("txtNext")+"\" onClick=\"page_next()\">&nbsp;");
}

function page_load() 
{
	get_by_id("password").value = admin_pwd;
	get_by_id("password_verify").value = admin_pwd;
}

function page_prev()
{
	self.location.href="Wizard_Easy_Config.asp?t="+new Date().getTime();
}

function page_next()
{
	if(verify_password() == true)
	{
		if(LangCode == "SC" || LangCode == "TW")
		{
			get_by_id("prev").disabled = true;
			get_by_id("next").disabled = true;
		}
		get_by_id("curTime").value = new Date().getTime();
		document.wz_form_pg_5.submit();
	}
}

function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
	document.title = DOC_Title;
	get_by_id("language").value = LangCode;
	page_load();
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
<tr><td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">

<div id="maincontent_1col" style="display: block">
<form id="wz_form_pg_5" name="wz_form_pg_5" action="http://<% getInfo("goformIpAddr"); %>/goform/formEasySetPassword" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="language" name="language" value=""/>
<div id="box_header">
<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasy113Step2");</SCRIPT></h1>
<p class="box_msg" style="display:block"><SCRIPT >ddw("txtWizardWanStr6");</SCRIPT>
</p>

<table align="center">
	<tr>
		<td class="r_tb" width="200"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtNewPassword");</SCRIPT></B></font></td>
		<td class="l_tb" width="300"><font color="#000000"><b>:</b></font>&nbsp;
		<input type=password id="password" name="config.password" size="20" maxlength="15" value="">
		</td>
	</tr>
	<tr>
		<td class="r_tb" width="200"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtVerifyPassword");</SCRIPT></B></font></td>
		<td class="l_tb" width="300"><font color="#000000"><b>:</b></font>&nbsp;
		<input type=password id="password_verify" name="config.password_verify" size="20" maxlength="15" value="">
		</td>
	</tr>
</table>
<br>
	<center><script>prev();next();</script></center>
<br>

</div><!--box_header-->
</form>
</div><!--maincontent_1col-->

<% getFeatureMark("MultiLangSupport_Head"); %>								
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td>
<td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
</html>
