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
.ifile {position:absolute;opacity:0;filter:alpha(opacity=0);}
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

//davis : chrome compatibility

function selectfile()
{
    var evt = document.createEvent("MouseEvents");
    evt.initEvent("click",false,true);
    document.forms["loadform"].load_settings.dispatchEvent(evt);
}
function seturl()
{
    document.forms["loadform"].url.value = document.forms["loadform"].load_settings.value;
}
function initinput()
{
    var br = navigator.userAgent.toLowerCase();
    chrome = "";
    nonechrome = "";
    chrome = '<div id="chrome"> \
                                <div style="z-index:2"> \
                                        <input style="visibility:hidden" type="file" value="" id="load_settings" name="upfile" onChange="seturl()" />   \
                                </div>  \
                                <div style="position:relative;top:-10px;left:0;z-index:1">      \
                                        <input type="text" vlaue="" id="url" size="30" onClick="selectfile()" />        \
                                        <input type="button" value="Browser" id="select" onClick="selectfile()" />      \
                                </div>  \
                        </div>';
    nonechrome = '<input type="file" value="" id="load_settings" name="upfile" size="30" />';
    if( br.search("chrome") >= 0)
    {
        document.write(chrome);
    }
    else
    {
        document.write(nonechrome);
    }
}

//davis : end of chrome compatibility

function get_webserver_ssi_uri() {
		return ("" !== "") ? "/Basic/Setup.asp" : "/Tools/System.asp";
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
SubnavigationLinks(WLAN_ENABLED, OP_MODE);
topnav_init(document.getElementById("topnav_container"));
page_load();
RenderWarnings();
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtTools")+'/'+sw("txtSystemSettings");
var br = navigator.userAgent.toLowerCase();
document.title = DOC_Title;	
get_by_id("save_settings").value = sw("txtSave");
get_by_id("restore_settings").value = sw("txtRestoreFactoryDefaults");
get_by_id("clear_pack").value = sw("txtClear");
get_by_id("btn_reboot").value = sw("txtRebooting");

get_by_id("button1").value = sw("txtRestoreConfigurationFromFile");
get_by_id("button3").value = sw("txtCancel");		
//if(br.search("chrome") >= 0)
get_by_id("select").value = sw("txtBrowser");
}		
//]]>
</script>
<script language="JavaScript" type="text/javascript">
//<![CDATA[

var local_debug = false;
function do_rebootFactory(reset)
{
	if (!reset && !confirm (sw("txtClearLangPackConfirm"))) {
		return;
	}
	if (reset && !confirm (sw("txtFactoryDefaultSettings") 
		+ "\n" + 
		sw("txtAllCurrentSettingsLost"))) {
		return;
	}
	if (local_debug) {
		top.location = "Tools/System.asp";
	} else {
		if(reset ==true){
			document.Reset_DUT.Target.value= "resetFactory";
		}else{
			document.Reset_DUT.Target.value= "clearpackonly";
		}
		document.Reset_DUT.submit();
	}
}
function do_reboot()
{
	if (!confirm(sw("txtRebootNow") + "?")){
		return;
	}

	if (local_debug) {
		top.location = "Tools/System.asp";
	}else{
		document.Reset_DUT.Target.value= "doReboot";
		document.Reset_DUT.submit();
	}
}
function do_restore()
{
	var btn_restore = document.getElementById("button1");
	if (btn_restore.disabled) {
		alert (sw("txtRestoreInProgress"));
		return;
	}
	if (document.forms.loadform.upfile.value == "") {
		alert(sw("txtEnterConfigurationName"));
		return;
	}
	btn_restore.disabled = true;
	//var inf = document.getElementById("restore_info");
	//inf.innerHTML = sw("txtUploadingConfigurationFile")+"...";
	window.name = "55aa" + window.location;
	if (local_debug) {
		switch (Math.round(Math.random()*4)) {
			case 0:  top.location = "restore_invalid.html";   return;
			case 1:  top.location = "restore_failed.html";    return;
			case 2:  top.location = "restore_succeeded.html"; return;
			default: top.location = "restore_reboot.html";    return;
		}
	}
	try {
		document.forms.loadform.submit();
	} catch (e) {
		alert(sw("txtError")+": " + e.message);
		inf.innerHTML = "&nbsp;";
		btn_restore.disabled = false;
	}
}
function page_load()
{
	document.getElementById("button3").style.display = "none";
	if (local_debug) {
		hide_all_ssi_tr();
		document.forms.saveform.action = "System.asp";
		}
/* Check for validation errors. */
var verify_failed = sw("<%getInfo("err_msg")%>");
if (verify_failed != "") {
		alert(verify_failed);
		verify_failed = "";
	}

}
	
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="init(); template_load();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr><td><SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr>	<td id="sidenav_container"><div id="sidenav">
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
</td>
<td id="maincontent_container">
<div id="warnings_section" style="display:none">
<div class="section" ><div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div><!-- box warnings_section_content --></div></div>	</div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
<div class="section"><div class="section_head">
<h2><SCRIPT >ddw("txtSystemSettings");</SCRIPT></h2>
<p><SCRIPT >ddw("txtToolsSystemStr1");</SCRIPT></p>
</div>

<div class="box">
	
<h3><SCRIPT >ddw("txtSystemSettings2");</SCRIPT></h3>
<p class="box_msg"></p>
<table width=95%>
<form id="saveform" name="saveform" method="get" action="">
<tr>
	<td class=r_tb width=45%><SCRIPT >ddw("txtSaveToLocalHardDrive");</SCRIPT>&nbsp;:&nbsp;</td>
	<td><input class="button_submit" id="save_settings" type="button" onClick="window.location.href='/<%getInfo("cfg_file");%>'" /></td>
</tr>
</form>

<form id="loadform" name="loadform" method="post" enctype="multipart/form-data" action="/goform/formSetRestorePrev">
<tr>
				<td class=r_tb><SCRIPT >ddw("txtLoadFromLocalHardDrive");</SCRIPT>&nbsp;:&nbsp;</td>
				<td>
<!--					<input id="load_settings" type="file" name="upfile" size="35" />  -->
<!--					<script>initinput();</script> -->
<input type="file" id="load_settings" name="upfile" onchange="seturl()" size="30" class="ifile">
<input type="text" vlaue="" id="url" size="30" onclick="this.form.load_settings.click();" readonly>
<input type="button" value="" id="select" onclick="this.form.load_settings.click();">

<input class="button_submit" type="button" value="" onclick="do_restore()" id="button1"/>
<input class="button_submit" onclick="cancel_restore()" type="button" value="" id="button3"/>
					<span class="msg_inprogress" id="restore_info">&nbsp;</span>
				</td>
</tr>

</form>

<form id="Reset_DUT" name="Reset_DUT" action="/goform/formSetFactory" method="post">	
<input type="hidden" id="Target" name="Target" value=""/>
<tr>
	<td class=r_tb><SCRIPT >ddw("txtRestoreToFactoryDefault");</SCRIPT>&nbsp;:&nbsp;</td>
	<td><input class="button_submit" id="restore_settings" type="button" value="" onclick="do_rebootFactory(true)" /></td>
</tr>

<tr>
				<td class=r_tb><SCRIPT >ddw("txtClearLangPack");</SCRIPT>&nbsp;:&nbsp;</td>
				<td><input class="button_submit" id="clear_pack" type="button" value="" onclick="do_rebootFactory(false)"/></td>
</tr>
<tr>
				<td class=r_tb><SCRIPT >ddw("txtRebootDevice");</SCRIPT> &nbsp;:&nbsp;</td>
				<td><input class="button_submit" id="btn_reboot" type="button" value="" onclick="do_reboot()"/></td>
</tr>

</form>
</table>



</div></div><!-- InstanceEndEditable --></div></td>
<td id="sidehelp_container"><div id="help_text">
<!-- InstanceBeginEditable name="Help_Text" -->
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtToolsSystemStr3");</SCRIPT></p>
<p><SCRIPT >ddw("txtToolsSystemStr4");</SCRIPT></p>
<p><SCRIPT >ddw("txtToolsSystemStr5");</SCRIPT></p>
<p class="more"><!-- Link to more help -->
<a href="../Help/Tools.asp#System" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>
</p><!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
