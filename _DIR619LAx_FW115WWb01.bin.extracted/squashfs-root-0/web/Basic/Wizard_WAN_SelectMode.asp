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
#add_sta_progress_bar {
	display: none;
	overflow: hidden;
	width:140px;
	height:15px;
	margin: 0 auto;
	border: 1px solid gray;
}
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
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
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = modelname;
page_load();
//document.getElementById("loader_container").style.display = "none";
RenderWarnings();
}

function go_prev()
{
	self.location.href="Wizard_WAN_time.asp?t="+new Date().getTime();
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

function page_load() 
{
	mf = document.forms.mainform;
	wizardWanConnModeSelector(mf.wizardWanConnMode.value);
}
function wizardWanConnModeSelector(mode)
{
var form_handle = document.forms.mainform;
set_radio(form_handle.config_wan_connect_mode, mode);
form_handle.wizardWanConnMode.value = mode;
}
function page_submit()
{
	if (is_form_modified("mainform"))  //something changed
	{
		get_by_id("settingsChanged").value = 1;
	}
	get_by_id("curTime").value = new Date().getTime();
	//mainform.submit();
	mf.submit();
}

function page_cancel()
{
	if (is_form_modified("mainform") || get_by_id("settingsChanged").value == 1) {
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

}		
	//]]>
	</script>
</head>
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();

</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">

<div id="maincontent_1col" style="display: block">
<form id="mainform" name="mainform" action="http://<% getInfo("goformIpAddr"); %>/goform/formSetWizardSelectMode" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" id="curTime" name="curTime" value=""/>

<div id="box_header">



<div id="wz_page_2" style="display:block">

<h1><SCRIPT >ddw("txtWizardWanStep2_5");</SCRIPT></h1>
<p class="box_msg" style="display:block"><SCRIPT >ddw("txtWizardWanAutoManual");</SCRIPT>
</p>


<table align="center">
		<tr>
			<td>
<p><label for="config_method_radio_auto"><b>
<input type="hidden" id="wizardWanConnMode" name="wizardWanConnMode" value="<%getWizardInformation("wizardWanConnMode");%>"/>
</b></label>
<input type="radio" id="config_wan_connect_mode_0" name="config_wan_connect_mode" value="0" onClick="wizardWanConnModeSelector(this.value)" />
<SCRIPT >ddw("txtWizardWanDetectStr");</SCRIPT>
</p>
</td>
</tr>
<tr>
	<td>
<p>
<label for="config_method_radio_2"><b>

</b></label>
<input type="radio" id="config_wan_connect_mode_1" name="config_wan_connect_mode" value="1" onClick="wizardWanConnModeSelector(this.value)" />
<SCRIPT >ddw("txtWizardWanManualStr");</SCRIPT>
</p>
</td>
</tr>
</table>
</div><!-- wz_page_2 -->


<br>
		<center><script>prev("");next("page_submit();");exit();</script></center>
		<br>
</div><!-- wz_page_4 -->

</div>



		

</form>
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
