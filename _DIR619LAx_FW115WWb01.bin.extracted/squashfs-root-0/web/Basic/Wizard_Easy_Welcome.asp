<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />
<link rel="stylesheet" rev="stylesheet" href="../networkmap.css" type="text/css" />
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
var no_reboot_alt_location = "";

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
	
function prev()
{
	document.write("<input type='button' name='prev' value=\""+sw("txtPrev")+"\" disabled>&nbsp;");
}
function next()
{
		document.write("<input type='button' name='next' value=\""+sw("txtNext")+"\" onClick=\"page_next()\">&nbsp;");
}
var detmode = "0";
function config_setup_mode_selector(mode)
{
	detmode = mode;
/*	if(mode == "1")
	{
		self.location.href="Wizard_Easy_WanDetect.asp?t="+new Date().getTime();
	}
*/
}
function page_load()
{
	var f = document.forms.wz_form_pg_2;
	set_radio(f.config_setup_mode, 0);
}
function page_next()
{
	if(detmode == "0")
	{
		self.location.href="Wizard_Easy_Config.asp?t="+new Date().getTime();
	}
	else
	{
		self.location.href="Wizard_Easy_WanDetect.asp?t="+new Date().getTime();
	}
}
function page_cancel()
{
	if (is_form_modified("wz_form_pg_1") || get_by_id("settingsChanged").value == 1) {
		if (confirm (sw("txtAbandonAallChanges"))) {
			top.location='../logout.asp?t='+new Date().getTime();
		}
	} else {
		top.location='../logout.asp?t='+new Date().getTime();
	}			
}

function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
	document.title = DOC_Title;
	page_load();
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
<div id="wz_page_2" style="display:block">
<form id="wz_form_pg_2" name="wz_form_pg_2" action="http://<% getInfo("goformIpAddr"); %>/goform/formEasySetupWizard" method="post">
<input type="hidden" id="curTime" name="curTime" value=""/>
<div id="box_header">
<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStep1");</SCRIPT></h1>
<p class="box_msg" style="display:block"><SCRIPT >ddw("txtWizardEasyStep1Str1");</SCRIPT></p>
<table align="center">
	<tr>
		<td><input type="radio" id="config_easy_setup_0" name="config_setup_mode" value="0" onclick="config_setup_mode_selector(this.value);"><SCRIPT >ddw("txtWizardEasyManualStr");</SCRIPT>
		</td>
	</tr>
	<tr>
		<td><input type="radio" id="config_easy_setup_1" name="config_setup_mode" value="1" onclick="config_setup_mode_selector(this.value);"><SCRIPT >ddw("txtWizardEasyAutoConfig");</SCRIPT>
		</td>
	</tr>
</table>
<br>
<center><script>next();</script></center>
<br>
</div><!-- -->
</form>
</div><!-- wz_page_2 -->

</div>
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
