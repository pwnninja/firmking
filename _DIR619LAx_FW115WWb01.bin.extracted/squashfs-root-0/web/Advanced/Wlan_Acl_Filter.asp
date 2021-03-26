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

var MAXNUM_ACLFILTER = "<% getInfo("wlanAclFltNum");%>"*1;
		
function get_webserver_ssi_uri() {
return ("" !== "") ? "/Basic/Setup.asp" : "/Advanced/Wlan_Acl_Filter.asp";
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
var productModel="<%getInfo("productModel")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = productModel;
SubnavigationLinks(WLAN_ENABLED, OP_MODE);
topnav_init(document.getElementById("topnav_container"));
page_load();
RenderWarnings();
}

var mf;

var verify_failed = '<%getInfo("err_msg")%>';

function disable_mac_fiter_table(val){
var mac_table_size = MAXNUM_ACLFILTER;
for (var i = 0; i < mac_table_size; i++) {
mf["mac_addr_" + i].disabled = val;
}
}

function filtering_mode_selector(val)
{

switch(val) {
case "0":
mf["mac_filter_mode"].value = 0;
disable_mac_fiter_table(true);
break;

case "2":
mf["mac_filter_mode"].value = 2;
disable_mac_fiter_table(false);
break;
}
}

function set_filtering_mode()
{
if (mf["mac_filter_mode"].value == 0) {
mf["mode"].value = "0";
disable_mac_fiter_table(true);
return;
}

if (mf["mac_filter_mode"].value == 2) {
mf["mode"].value = "2";
return;
}
}

function clear_mac(i)
{
mf["mac_addr_" + i].value = "";
}

function set_mac_addresses()
{
var val = MAXNUM_ACLFILTER;
for (i = 0; i < val; i++) {
if(mf["mac_addr_" + i].value == "00:00:00:00:00:00") {
mf["mac_addr_" + i].value = "";
}
}
}

function validate_mac_addresses()
{
var val = MAXNUM_ACLFILTER;
var mac_value;
for (i = 0; i < val; i++) {
mac = mf["mac_addr_" + i].value;
mac = trim_string(mac);
if(mf["entry_enable_" + i].checked==true){
	mf["entry_enable_" + i].value = 1;
}else{
	mf["entry_enable_" + i].value = 0;
	continue;
}
	
if (mac == "") {
mf["used_" + i].value = 0;
mf["enabled_" + i].value = false;
alert (sw("txtInvalidMACAddress"));
mf["mac_addr_" + i].select();
mf["mac_addr_" + i].focus();
return false;
}

if(!verify_mac(mac,mf["mac_addr_" + i]))
{
	mf["used_" + i].value = 0;
	mf["enabled_" + i].value = false;
	alert (sw("txtInvalidMACAddress") + " "+mac + ".");
	mf["mac_addr_" + i].select();
	mf["mac_addr_" + i].focus();
	return false;
}

if(mf["mac_addr_" + i].value == "00:00:00:00:00:00")	
{
	mf["used_" + i].value = 0;
	mf["enabled_" + i].value = false;
	alert (sw("txtInvalidMACAddress") + " "+mac + ".");
	mf["mac_addr_" + i].select();
	mf["mac_addr_" + i].focus();
	return false;
}

mf["used_" + i].value = 1;
mf["enabled_" + i].value = true;

if (mf["mac_filter_mode"].value != 0)
{
var mac = mf["mac_addr_" + i].value;
if(mac == "")
continue;

for(var j=0;j<MAXNUM_ACLFILTER;j++)
{
if(i==j || mf["mac_addr_" + j].value == "")
continue;

if(mac == mf["mac_addr_" + j].value)
{
alert(sw("txtMACAddress")+" "+sw("txtIsAlreadyUsed")+":"+mac);
return false;

}
}
}
var mac_array = mf["mac_addr_" + i].value.split(":");
get_by_id("mac_"+i).value = "";
for(var j=0;j<mac_array.length;j++)
{
get_by_id("mac_"+i).value += mac_array[j];					
}												
}			
if(mf["mac_filter_mode"].value == 1)
{
for(var j=0;j<MAXNUM_ACLFILTER;j++)
{
	if(mf["enabled_" + j].value == "true")
		break;
}
if(j==MAXNUM_ACLFILTER)
{
	alert(sw("txtInvalidMacFilterSettings"));
	return false;
}
}

return true;
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
if(!validate_mac_addresses()){
return false;
}else if((mf["mode"].value = "2") && (mf["wifisc_enable"].value == "true")){
alert(sw("wps_aclfilter"));
return false;
}else{
mf["settingsChanged"].value = 1;
}
}
mf.submit();
}

function page_load() 
{
mf = document.forms.mainform;

displayOnloadPage("<%getInfo("ok_msg")%>");

mf = document.forms["mainform"];

set_mac_addresses();

for (var index = 0; index < MAXNUM_ACLFILTER; index++) {
if(mf["entry_enable_" + index].value == 1)
	mf["entry_enable_" + index].checked=true;
else
	mf["entry_enable_" + index].checked=false;
}

/* Check for validation errors. */
if (verify_failed != "") {
set_form_always_modified("mainform");
alert(verify_failed);
}

set_filtering_mode();
set_form_default_values("mainform");
}

		
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtAdvanced")+'/'+sw("txtACLAddressFilter");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");			
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");	
}


var token= new Array(MAXNUM_ACLFILTER);
var DataArray = new Array();

function macFilteringRulesList(num)
{

token[0]="<% ACLFilter_List("macFtrList_1");%>";
token[1]="<% ACLFilter_List("macFtrList_2");%>";
token[2]="<% ACLFilter_List("macFtrList_3");%>";
token[3]="<% ACLFilter_List("macFtrList_4");%>";
token[4]="<% ACLFilter_List("macFtrList_5");%>";
token[5]="<% ACLFilter_List("macFtrList_6");%>";
token[6]="<% ACLFilter_List("macFtrList_7");%>";
token[7]="<% ACLFilter_List("macFtrList_8");%>";
token[8]="<% ACLFilter_List("macFtrList_9");%>";
token[9]="<% ACLFilter_List("macFtrList_10");%>";
token[10]="<% ACLFilter_List("macFtrList_11");%>";
token[11]="<% ACLFilter_List("macFtrList_12");%>";
token[12]="<% ACLFilter_List("macFtrList_13");%>";
token[13]="<% ACLFilter_List("macFtrList_14");%>";
token[14]="<% ACLFilter_List("macFtrList_15");%>";
token[15]="<% ACLFilter_List("macFtrList_16");%>";
token[16]="<% ACLFilter_List("macFtrList_17");%>";
token[17]="<% ACLFilter_List("macFtrList_18");%>";
token[18]="<% ACLFilter_List("macFtrList_19");%>";
token[19]="<% ACLFilter_List("macFtrList_20");%>";
token[20]="<% ACLFilter_List("macFtrList_21");%>";
token[21]="<% ACLFilter_List("macFtrList_22");%>";
token[22]="<% ACLFilter_List("macFtrList_23");%>";
token[23]="<% ACLFilter_List("macFtrList_24");%>";			
token[24]="<% ACLFilter_List("macFtrList_25");%>";

for (var i = 0; i < num; i++)
{								
DataArray = token[i].split("/"); /* Mac address */
				
document.write("<tr>");
document.write("<td rowspan=\"1\" colspan=\"1\"><input type=checkbox id=\"entry_enable_"+i+"\" name=\"entry_enable_"+i+"\" value=\""+DataArray[1]+"\" ></td>");
document.write("<td rowspan=\"1\" colspan=\"1\">");
document.write("<input type=\"hidden\" id=\"used_"+i+"\" name=\"used_"+i+"\" value=\"0\" />");
document.write("<input type=\"hidden\" id=\"enabled_"+i+"\" name=\"enabled_"+i+"\" value=\"false\" />");
document.write("<input type=\"hidden\" id=\"mac_"+i+"\" name=\"mac_"+i+"\" value=\"\" />");
document.write("<input type=\"text\" size=\"20\" maxlength=\"17\" id=\"mac_addr_"+i+"\" name=\"mac_addr_"+i+"\" value=\""+DataArray[0]+"\"/>");
document.write("</td>");
document.write("</tr>");
}
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
DrawRebootContent("bridge");
</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" >
<div class="section_head">
<h2>
<SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT>
</h2>
<div style="display:block" id="warnings_section_content">
</div><!-- box warnings_section_content -->
</div>
</div>
</div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<form name="mainform" action="/goform/formSetACLFilter" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section">
<div class="section_head"> 
<h2>
<SCRIPT >ddw("txtACLAddressFilter");</SCRIPT>
</h2>
<p>
<SCRIPT >ddw("txtMacAddFilterStr1");</SCRIPT>
</p>
<SCRIPT language=javascript>DrawSaveButton();</SCRIPT>
</div>
<div class="box">
<h3>
25
--
<SCRIPT >ddw("txtACLFilteringRules");</SCRIPT>
</h3>
<table summary="">
<tr>
<td rowspan="1" colspan="1">
<SCRIPT >ddw("txtConfigureACLFiltering");</SCRIPT>:
</td>
</tr>
<tr>
<td rowspan="1" colspan="1">
<input type="hidden" id="mac_filter_mode" name="macFltMode" value="<% getInfo("aclFltMode");%>" />
<input type="hidden" id="wifisc_enable" name="config.wifisc.enabled" value="<%getIndexInfo("wsc_enabled");%>"/>
<select name="mode" onchange="filtering_mode_selector(this.value)" style="width: 180px;">
<option value="0">
<SCRIPT >ddw("txtTurnACLFilteringOFF");</SCRIPT>
</option>
<option value="2">
<SCRIPT >ddw("txtAclAddFilterStr3");</SCRIPT>
</option>
</select>
</td>
</tr>
</table>
<p id="select_mac_container" style="display:none"> </p>
<table border="0" cellpadding="0" cellspacing="1" class="formlisting" style="width:180px">
	
<SCRIPT >ddw("txtRemainRulesCanbeCreated");</SCRIPT>
 : <font color=red>
<%getIndexInfo("reamin_aclfilter_num");%> 	
</font>
<br><br>

<tr class="form_label_row">
<td class="formlist_col4" rowspan="1" colspan="1">&nbsp;</td>
<td class="formlist_col2" rowspan="1" colspan="1">
<SCRIPT >ddw("txtMACAddress");</SCRIPT>
</td>
</tr>
<SCRIPT >macFilteringRulesList(MAXNUM_ACLFILTER);</SCRIPT>
</table>
</div>
</div>
</form>

<SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>

</div>
</td>
<td id="sidehelp_container">
<div id="help_text">
<strong>
<SCRIPT >ddw("txtHelpfulHints");</SCRIPT>
...</strong>
<p><SCRIPT >ddw("txtMacAddFilterStr4");</SCRIPT></p>
<p><SCRIPT >ddw("txtMacAddFilterStr5");</SCRIPT></p>
<!--
<p><SCRIPT >ddw("txtMacAddFilterStr6");</SCRIPT></p>
-->
<p class="more">
<a href="../Help/Advanced.asp#MAC_Address_Filter" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...
</a></p></div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr><td><img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" /></td><td>&nbsp;</td>
</tr></table></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body></html>
