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
page_load();
RenderWarnings();
}
function go_prev()
{
	self.location.href="Wizard_WAN_password.asp?t="+new Date().getTime();
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
timezone_init();
}
function page_submit()
{
if (is_form_modified("wz_form_pg_3"))  //something changed
{
	get_by_id("settingsChanged").value = 1;
}
	get_by_id("curTime").value = new Date().getTime();
	//wz_form_pg_3.submit();
	document.wz_form_pg_3.submit();
}
function page_cancel()
{
	if (is_form_modified("wz_form_pg_3") || get_by_id("settingsChanged").value == 1) {
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

set_form_default_values("wz_form_pg_3");		
}	
function tzselect_selector()
{
var tz_sel = document.getElementById("select_timezone");		
document.getElementById("tz_timezone_index").value = tz_sel.selectedIndex;
document.getElementById("tz_timezone").value = tz_sel.value;
}

function ntpSrv_selector(selectValue)
{
document.getElementById("config_ntpSrv").value = selectValue;
document.getElementById("select_ntpSrv").value = selectValue;
}

add_onload_listener(timezone_init);

function timezone_init()
{
		
var tzselect = document.getElementById("select_timezone");
var tzform = tzselect.form;
var dF=document.forms[0];
//		setSelectedIndex(dF.select_timezone, tzform.tz_timezone.value);
tzselect.selectedIndex = tzform.tz_timezone_index.value;
ntpSrv_selector(document.getElementById("config_ntpSrv").value);
set_form_default_values(tzform.id);
if (typeof(tzselect.addEventListener) != "undefined") {
	tzselect.addEventListener("change", tzselect_selector, false);
} else if (typeof(tzselect.attachEvent) != "undefined") {
	tzselect.attachEvent("onchange", tzselect_selector);
} else {
	tzselect.onchange = tzselect_selector;
}
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
<form id="wz_form_pg_3" name="wz_form_pg_3" action="http://<% getInfo("goformIpAddr"); %>/goform/formSetWizard2" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" name="config.tz_timezone_index" id="tz_timezone_index" value="<% getWizardInformation("ntpTimeZoneIdx"); %>" />
<input type="hidden" name="config.tz_timezone" id="tz_timezone" value="<% getWizardInformation("ntpTimeZone"); %>" />
<input type="hidden" name="config_ntpSrv" id="config_ntpSrv" value="<% getWizardInformation("ntpSrv"); %>" />
<input type="hidden" name="WEBSERVER_SSI_OPLOCK_ACTION" value="post"/>
<input type="hidden" name="WEBSERVER_SSI_OPLOCK_VALUE" value=""/>
<input type="hidden" name="wz_pg_prev" value=""/>
<input type="hidden" name="wz_pg_cur" value=""/>
<input type="hidden" name="wz_modified" value=""/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStep2");</SCRIPT></h1>
<p><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr7");</SCRIPT></p>

		<table align="center">
		<tr>
			<td align=right><SCRIPT >ddw("txtTimeZone");</SCRIPT>&nbsp;:&nbsp;</td>
			<td>
			
<select id="select_timezone" name="select_timezone"><SCRIPT>
var i;
if(LangCode=="SC"){
for(i=0;i<ntp_zone_array_sc.length;i++){
	if (i == ntp_zone_index)
			document.write('<option value="',ntp_zone_array_sc[i].value,'" selected>',ntp_zone_array_sc[i].name,'</option>');
	else
			document.write('<option value="',ntp_zone_array_sc[i].value,'">',ntp_zone_array_sc[i].name,'</option>');
}
}else if(LangCode=="TW")
{
for(i=0;i<ntp_zone_array_tw.length;i++){
    if (i == ntp_zone_index)
            document.write('<option value="',ntp_zone_array_tw[i].value,'" selected>',ntp_zone_array_tw[i].name,'</option>');
    else
            document.write('<option value="',ntp_zone_array_tw[i].value,'">',ntp_zone_array_tw[i].name,'</option>');
}
}else{
 	for(i=0;i<ntp_zone_array.length;i++){
	if (i == ntp_zone_index)
			document.write('<option value="',ntp_zone_array[i].value,'" selected>',ntp_zone_array[i].name,'</option>');
	else
			document.write('<option value="',ntp_zone_array[i].value,'">',ntp_zone_array[i].name,'</option>');
	}
}
</SCRIPT></select>
			</td>
		</tr>
		<tr><td><SCRIPT >ddw("txtNTPServerUsed");</SCRIPT>&nbsp;:&nbsp;</td>
			<td>
		<select id="select_ntpSrv" onchange="ntpSrv_selector(this.value);">
<option value="ntp1.dlink.com">ntp1.dlink.com</option>
<option value="ntp.dlink.com.tw">ntp.dlink.com.tw</option>
</select>
</td></tr>

		</table>
		<br>
		<center><script>prev("");next("page_submit();");exit();</script></center>
		<br>
		</div>
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
