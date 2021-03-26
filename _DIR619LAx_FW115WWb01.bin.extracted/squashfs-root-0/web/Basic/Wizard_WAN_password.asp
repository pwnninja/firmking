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
var old_admin_pwd = "<%getInfo("adminpasswd");%>";
function go_prev()
{
	self.location.href="Wizard_WAN.asp?t="+new Date().getTime();
}	
function prev(fn)
{
	if(fn=="") fn="go_prev();";
	document.write("<input type='button' name='prev' value=\""+sw("txtPrev")+"\" onClick='"+fn+"'>&nbsp;");
}
function next(fn)
{
	if(fn=="")
		document.write("<input type='button' name='next' value=\""+sw("txtNext")+"\" onClick=\"\">&nbsp;");
	else
		document.write("<input type='button' name='next' value=\""+sw("txtNext")+"\" onClick='return "+fn+"'>&nbsp;");
}

function exit()
{
	document.write("<input type='button' name='exit' value=\""+sw("txtCancel")+"\" onClick=\"page_cancel()\">&nbsp;");
}
function wz_verify_pg_2()
{
	var form_handle = document.forms["wz_form_pg_2"];
	if(strchk_unicode(form_handle.password.value)==true)
	{
		alert(sw("txtUserInvalid3"));
		form_handle.password.selected = true;
		return false;
	}
	if (form_handle.second_password.value !== form_handle.password.value) {
		alert(sw("txtTwoPasswordsNotSame"));
		return false;
	}
	var pwd1= get_by_id("second_password").value;
	var pwd2 =get_by_id("password").value;
	if((pwd1 != old_admin_pwd) && (pwd2 != old_admin_pwd)){
				get_by_id("second_password").value= encode_base64(pwd1);
				get_by_id("password").value = encode_base64(pwd2);
	}else{
				get_by_id("second_password").value = old_admin_pwd;
				get_by_id("password").value = old_admin_pwd;
	}
	return true;
}
function page_submit()
{
if (is_form_modified("wz_form_pg_2"))  //something changed
{
	get_by_id("settingsChanged").value = 1;
}
if(wz_verify_pg_2() == true){
	get_by_id("curTime").value = new Date().getTime();
	//wz_form_pg_2.submit();
	document.wz_form_pg_2.submit();
}else
	return false;
}
function page_cancel()
{
	if (is_form_modified("wz_form_pg_2") || get_by_id("settingsChanged").value == 1) {
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

set_form_default_values("wz_form_pg_2");	
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

<div id="wz_page_2" style="display:block">
<form id="wz_form_pg_2" name="wz_form_pg_2" action="http://<% getInfo("goformIpAddr"); %>/goform/formSetWizard1" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" name="WEBSERVER_SSI_OPLOCK_ACTION" value="post"/>
<input type="hidden" name="WEBSERVER_SSI_OPLOCK_VALUE" value=""/>
<input type="hidden" name="wz_modified" value=""/>
<input type="hidden" id="curTime" name="curTime" value=""/>
	<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStep1");</SCRIPT></h1>
<p>	<SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr6");</SCRIPT>:</p>
		<table align="center">
		<tr>
			<td class="r_tb" width="92"><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT> :</td>
			<td class="l_tb" width="173">
				<input type=password id="password" name="config.password" size=20 maxlength=15 value="<%getInfo("adminpasswd");%>">
			</td>
		</tr>
		<tr>
			<td class="r_tb" nowrap><SCRIPT language=javascript type=text/javascript>ddw("txtVerifyPassword");</SCRIPT>:</td>
			<td class="l_tb">
				<input type=password id=second_password name=second_password size=20 maxlength=15 value="<%getInfo("adminpasswd");%>">
			</td>
		</tr>
		</table>
		<br>
		<center><script>prev("");next("page_submit();");exit();</script></center>
		<br>
		</div>
</form></div><!-- wz_page_2 -->

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
