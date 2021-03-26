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
/*
 * Used by template.js.
 * You cannot put this function in a sourced file, because SSI will not process it.
 */
function get_webserver_ssi_uri() {
	return ("" !== "") ? "/Basic/Setup.asp" : "/Basic/Wizard_Wireless.asp";
}
/** Perform initialization for items that belong to the DWT when page is loaded.*/
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
/* * Render any warnings to the user */
RenderWarnings();
}
//]]>
</script>
<script type="text/javascript">
//<![CDATA[
function page_load()
{
	if ("" !== "") {
		hide_all_ssi_tr();
	}
	if (navigator.platform.toLowerCase() !== "win32") {
		if (document.getElementById('prn_wizard_box')) {
			document.getElementById('prn_wizard_box').style.display="none";
		}
		if (document.getElementById('wcn_wizard_box')) {
			document.getElementById('wcn_wizard_box').style.display="none";
		}
	}

}

function init()
{			
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtWirelessCONN");
document.title = DOC_Title;	
get_by_id("WirelessWizard").value = sw("txtWirelessConnectionWizard");
get_by_id("ManualWirelessSetup").value = sw("txtManualWirelessConnectionSetup");
}
//]]>
</script>
<!-- InstanceEndEditable -->
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
<tr>	<td id="sidenav_container">
<div id="sidenav">
<SCRIPT >
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
<div id="warnings_section" style="display:none">
<div class="section" >	<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
<!-- This division will be populated with configuration warning information -->
</div><!-- box warnings_section_content --></div></div>	</div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtWirelessCONN");</SCRIPT></h2>
<p><SCRIPT >ddw("txtWizardWirelessStr1");</SCRIPT></p>
<br><br>
<p id="admin_only" style="display:block"><b>
<SCRIPT >ddw("txtWizardWirelessStr3");</SCRIPT>
</b></p>
</div></div>
<div class="box">
<h3><SCRIPT >ddw("txtWirelessNetworkSetupWizard");</SCRIPT></h3>
<p>	<SCRIPT >ddw("txtWizardWirelessStr4");</SCRIPT></p>
<p class="centered">
<input id="WirelessWizard" type="button" name="WirelessWizard" class="button_submit" value="" onclick="top.location='/Basic/Wizard_WLAN.asp?t='+new Date().getTime();"/>
</p><p class="red">
<strong>	<SCRIPT >ddw("txtNote");</SCRIPT>:</strong> 
<SCRIPT >ddw("txtWizardWirelessStr5");</SCRIPT></p></div>
<div class="box">
<h3><SCRIPT >ddw("txtManualWirelessNetworkSetup");</SCRIPT></h3>
<p><SCRIPT >ddw("txtWizardWirelessStr8");</SCRIPT></p>
<p class="centered"><input id="ManualWirelessSetup" type="button" name="ManualWirelessSetup" class="button_submit" value="" onclick="top.location='/Basic/Wireless.asp?t='+new Date().getTime();"/>
</p></div><!-- InstanceEndEditable --></div></td>
<td id="sidehelp_container">	<div id="help_text">
<!-- InstanceBeginEditable name="Help_Text" -->
<strong>	<SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>

<p>	<SCRIPT >ddw("txtWizardWirelessStr10");</SCRIPT></p>
<p>	<SCRIPT >ddw("txtWizardWirelessStr11");</SCRIPT></p>
<p><!-- Link to more help -->
<a href="../Help/Basic.asp#Wireless" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a></p><!-- InstanceEndEditable -->
</div>	</td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->

</html>
