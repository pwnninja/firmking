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
	
	
function get_webserver_ssi_uri() {
	return ("" !== "") ? "/Basic/Setup.asp" : "/Status/Statistics.asp";
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
//]]>
</script>
<script language="JavaScript" type="text/javascript">
//<![CDATA[

var mf;
var local_debug = false;

function clear_stats()
{
	mf.submit();
}
function onTimeout()
{
	alert(sw("txtCommfailed"));
}
function page_load() 
{
mf = document.forms["mainform"];
if (local_debug) {
	hide_all_ssi_tr();
		return;
}
var is_admin = "<% getIndexInfo("login_who"); %>" == "admin";
document.getElementById("clear_stats_button").disabled = !is_admin;
document.getElementById("user_only").style.display = is_admin ? "none" : "block";
}
function buttoninit()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtStatus")+'/'+sw("txtTrafficStatistics");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("refresh_stats_button").value = sw("txtRefreshStatistics");
get_by_id("clear_stats_button").value = sw("txtClearStatistics");
}	
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load();buttoninit();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr><td><SCRIPT>
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr><td id="sidenav_container"><div id="sidenav">
<SCRIPT>
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
<SCRIPT>DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td><td id="maincontent_container">
<SCRIPT>DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none"><div class="section" >
<div class="section_head"><h2><SCRIPT>ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div><!-- box warnings_section_content --></div></div>	</div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<form name="mainform" action="/goform/formResetStatistic" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section" id="interfaces_head"><div class="section_head">
<h2><SCRIPT>ddw("txtTrafficStatistics");</SCRIPT></h2>
<p><SCRIPT>ddw("txtTrafficStatisticsdisplay");</SCRIPT></p>
<p id="user_only" style="display:none"><SCRIPT>ddw("txtAdminClearStatistics");</SCRIPT></p>

</div></div>

</div></div>



		<div class="box">
			<h2>&nbsp</h2>
			<br><center>
<input id="refresh_stats_button"class="button_submit" type="button" value="" onclick="location.reload(true)"/>
<input id="clear_stats_button" class="button_submit" type="button" value="" onclick="clear_stats()"/>
			</center>
			<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>
			<tr id="box_header">
				<td class=bl_tb>&nbsp;</td>
				<td class=bl_tb><SCRIPT >ddw("txtReceived");</SCRIPT></td>
				<td class=bl_tb><SCRIPT >ddw("txtTransmit");</SCRIPT></td>
			</tr>

			<tr>
				<td width=111 height=20 class=bl_tb><SCRIPT>ddw("txtInternet2");</SCRIPT></td>
				<%getStatistic("wanRxTx")%>
			</tr>

			<tr>
				<td width=111 height=20 class=bl_tb><SCRIPT>ddw("txtLan2");</SCRIPT></td>
				<%getStatistic("lanRxTx")%>
			</tr>
			<tr>
				<td width=111 height=20 class=bl_tb><SCRIPT>ddw("txtWlan11N");</SCRIPT></td>
				<%getStatistic("wlanRxTx")%>
			</tr>
			</table>
		</div>







</form>
</div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT>ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT>ddw("txtSummaryPackets");</SCRIPT></p>
<p class="more"><!-- Link to more help -->
<a href="../Help/Status.asp#Statistics" onclick="return jump_if();"><SCRIPT>ddw("txtMore");</SCRIPT>...</a></p>
<!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT>Write_footerContainer();</SCRIPT>
</td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
