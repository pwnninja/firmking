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
#url_list {
background-color: #DFDFDF;
text-align: center;
}
#url_list input {
background-color: #FFF;
padding: 0;
margin: 2px;
}
#url_list h4 {
padding: 6px 0 0px 0;
}
</style>
<!-- InstanceEndEditable -->
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
var MAXNUM_WEBFTER = "<% getInfo("maxWebFltNum");%>"*1;

function get_webserver_ssi_uri() {
return ("" !== "") ? "/Basic/Setup.asp" : "/Basic/Web_Filter.asp";
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

var mf;

var verify_failed = "<%getInfo("err_msg")%>";
var size = MAXNUM_WEBFTER;

var schedule_options = [
	<%virSevSchRuleList();%>
];

function filtering_mode_selector(val)
{
switch(val) {
case "0":
mf.web_filter_allow.value = 0;
break;

case "1":
mf.web_filter_allow.value = 1;	
break;

case "2":
mf.web_filter_allow.value = 2;	
break;

}
}

function page_load()
{
displayOnloadPage("<%getInfo("ok_msg")%>");

mf = document.forms.mainform;

for (var index = 0; index < MAXNUM_WEBFTER; index++) {
schedule_populate_select(mf["schedule_" + index]);
mf["schedule_" + index].value = mf["sched_name_" + index].value;
if(mf["entry_enable_" + index].value == 1)
	mf["entry_enable_" + index].checked=true;
else
	mf["entry_enable_" + index].checked=false;
}

set_form_default_values("mainform");

if (verify_failed != "") {
set_form_always_modified("mainform");
alert(verify_failed);
}

mf.mode.value = mf.web_filter_allow.value;
mf.mode.setAttribute("modified", "ignore");

}

function page_submit()
{
if (!is_form_modified("mainform"))  //nothing changed
{
if (!confirm(sw("txtSaveAnyway"))) 				
return false;
}
else
{
for (var i = 0; i < size; i++) 
{
	
if(mf["entry_enable_" + i].checked==true)
	mf["entry_enable_" + i].value = 1;
else
	mf["entry_enable_" + i].value = 0;
	
mf["url_" + i].value = trim_string(mf["url_" + i].value);

var webUrl = mf["url_"+i].value;

if(!is_blank(webUrl)){
	if(strchk_url(webUrl)==false){
		alert(sw("txtWebUrlInvalid"));
		return false;
	}
}else if(mf["entry_enable_" + i].value == 1)
{
	alert("URL"+sw("txtisInvalid"));
	return false;
}

if(webUrl != "" && mf["entry_enable_" + i].value == 1)
{
for (var j = 0; j < size; j++) 
{
if(i==j || mf["url_"+j].value =="" || mf["entry_enable_" + j].value == 0)
continue;

if(webUrl == mf["url_"+j].value)
{
alert(sw("txtWebSiteAddress") +" '"+webUrl+"' "+sw("txtIsAlreadyUsed"));
return false;
}
}
}						
}

mf["settingsChanged"].value = 1;
}

mf.submit();
}
function remain_rules()
{
    
    document.write("Remaining number of rules that can be created: <font color=red>10</font>");
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtWebsiteFilteringRules");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");
for (var i = 0; i < MAXNUM_WEBFTER; i++)
{
	get_by_id("schedule_btn_"+i).value = sw("txtAddNew");
}
}

var token= new Array(MAXNUM_WEBFTER);		
var DataArray = new Array();

function webFilterList(num)
{
token[0]="<% DOMAINFilter_List("webFtrList_1");%>"
token[1]="<% DOMAINFilter_List("webFtrList_2");%>"
token[2]="<% DOMAINFilter_List("webFtrList_3");%>"
token[3]="<% DOMAINFilter_List("webFtrList_4");%>"
token[4]="<% DOMAINFilter_List("webFtrList_5");%>"
token[5]="<% DOMAINFilter_List("webFtrList_6");%>"
token[6]="<% DOMAINFilter_List("webFtrList_7");%>"
token[7]="<% DOMAINFilter_List("webFtrList_8");%>"
token[8]="<% DOMAINFilter_List("webFtrList_9");%>"
token[9]="<% DOMAINFilter_List("webFtrList_10");%>"
token[10]="<% DOMAINFilter_List("webFtrList_11");%>"
token[11]="<% DOMAINFilter_List("webFtrList_12");%>"
token[12]="<% DOMAINFilter_List("webFtrList_13");%>"
token[13]="<% DOMAINFilter_List("webFtrList_14");%>"
token[14]="<% DOMAINFilter_List("webFtrList_15");%>"
token[15]="<% DOMAINFilter_List("webFtrList_16");%>"
token[16]="<% DOMAINFilter_List("webFtrList_17");%>"
token[17]="<% DOMAINFilter_List("webFtrList_18");%>"
token[18]="<% DOMAINFilter_List("webFtrList_19");%>"
token[19]="<% DOMAINFilter_List("webFtrList_20");%>"
token[20]="<% DOMAINFilter_List("webFtrList_21");%>"
token[21]="<% DOMAINFilter_List("webFtrList_22");%>"
token[22]="<% DOMAINFilter_List("webFtrList_23");%>"
token[23]="<% DOMAINFilter_List("webFtrList_24");%>"


for (var i = 0; i < num; i++)
{
DataArray = token[i].split("^_^"); /* web domain/url */

document.write("<tr><td align=middle><input type=checkbox id=\"entry_enable_"+i+"\" name=\"entry_enable_"+i+"\" value=\""+DataArray[0]+"\" ></td>");
document.write("<td valign=\"bottom\"><input type=\"text\" id=\"url_"+i+"\" name=\"url_"+i+"\" size=\"41\" maxlength=\"40\" value=\""+DataArray[1]+"\"></td>");
document.write("<input type=\"hidden\" id=\"sched_name_"+i+"\" name=\"sched_name_"+i+"\" value=\""+DataArray[2]+"\" />");
document.write("<td align=middle><select id=\"schedule_"+i+"\" onChange=\"sched_name_selector(&quot;"+i+"&quot;, this.value);\">");
document.write("</select>&nbsp;&nbsp;");
document.write("<input type=\"button\" id=\"schedule_btn_"+i+"\" style=\"width:65px;height:25px\" value=\"\" onclick=\"do_add_new_schedule()\">");
document.write("</td></tr>");
		
}
}

function sched_name_selector(index, value)
{
mf["sched_name_"+index].value = value;
mf["schedule_"+index].value = value;
}

function do_add_new_schedule()
{
	top.location = "../Tools/Schedules.asp";
}
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load(); init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr>
<td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr>

<td id="sidenav_container">
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
<SCRIPT >
DrawLanguageList();
</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td>	
<td id="maincontent_container">
<SCRIPT >
DrawRebootContent("wan");
</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" >
<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div>
</div>
</div>
</div>
<div id="maincontent" style="display: block">
<form id="mainform" name="mainform" action="/goform/formSetDomainFilter" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section">
<div class="section_head">
<h2><SCRIPT >ddw("txtWebsiteFilteringRules");</SCRIPT></h2>
<p><SCRIPT >ddw("txtWebFilterStr1");</SCRIPT></p>
<SCRIPT language=javascript>DrawSaveButton();</SCRIPT>
</div>
<div class="box">
<h3>10 -- <SCRIPT >ddw("txtWebsiteFilteringRules");</SCRIPT></h3>
<table summary="">
<tr><td rowspan="1" colspan="1">
<SCRIPT >ddw("txtConfigureWebsiteFilte");</SCRIPT>
</td>
</tr><tr>
<td rowspan="1" colspan="1">
<input type="hidden" id="web_filter_allow" name="allow" value="<% getInfo("webFltMode");%>" />
<select name="mode" onchange="filtering_mode_selector(this.value)" style="width: 220px;">
<option value="0">
<SCRIPT >ddw("txtWebFilterOff");</SCRIPT>
</option>
<option value="1">
<SCRIPT >ddw("txtWebFilterStr2");</SCRIPT>
</option>
<option value="2">
<SCRIPT >ddw("txtWebFilterStr3");</SCRIPT>
</option></select></td></tr></table>
<SCRIPT >ddw("txtRemainRulesCanbeCreated");</SCRIPT>
 : <font color=red>
<%getIndexInfo("reamin_urlfilter_num");%> 	
</font>
<br><br>
<div id="url_list">
<table border="0" cellpadding="0" cellspacing="1" class="formlisting" id="adv_macaddressfilter_list" summary="">
<tr class="form_label_row">
<td  rowspan="1" colspan="1">&nbsp;</td>
<td  rowspan="1" colspan="1">
	<SCRIPT >ddw("txtWebsiteURL");</SCRIPT>
</td>
<td  rowspan="1" colspan="1">
	<SCRIPT >ddw("txtSchedule");</SCRIPT>
</td>

</tr>
<SCRIPT >webFilterList(MAXNUM_WEBFTER);</SCRIPT>
</table>
</div></div></div></form>
</div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtWebFilterStr4");</SCRIPT></p>
<p>
<SCRIPT >ddw("txtWebFilterStr5");</SCRIPT>
</p>
<p class="more">
<a href="../Help/Basic.asp#Web_Filter" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>	
</p></div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr><td>
<img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td>
<td>&nbsp;
</td></tr></table></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body></html>
