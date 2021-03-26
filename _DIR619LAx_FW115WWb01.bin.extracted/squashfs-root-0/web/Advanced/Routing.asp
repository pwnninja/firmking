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
var MAXNUM_ROUTING = "<% getStaticRouteInfo("staticRouteNum");%>"*1;

function get_webserver_ssi_uri() {
return ("" !== "") ? "/Basic/Setup.asp" : "/Advanced/Routing.asp";
}

function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function template_load()
{
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

var verify_failed = "<%getInfo("err_msg")%>";

var mf;
var CurWanStatus="<% getIndexInfo("wanStatus");%>";
var CurWanPhyStatus="<% getIndexInfo("wanPhyStatus");%>";
var CurWanIp="<% getInfo("wan-ip");%>";
var CurWanphyIp="<% getIndexInfo("wanphy-ip");%>";
var CurWanMask="<% getInfo("wan-mask");%>";
var CurWanphyMask="<% getIndexInfo("wanphy-mask");%>";
var CurWanType="<%getInfo("wanType");%>";

var r_table_size = MAXNUM_ROUTING;

function r_dlink_selector(index, value)
{
mf["r_dlink_"+index].value = value;
}

function r_enabled_selector(index, value) {
mf["r_enabled_" + index].value = value;
mf["r_enabled_select_" + index].checked = value;
mf["r_used_" + index].value = 1;
}
function is_valid_dest_ip(ipaddr, optional)
{
	var ip = get_ip(ipaddr);
	if (optional!=0 && is_blank(ipaddr)) return true;
	if (is_in_range(ip[1], 1, 223)==false) return false;
	if (decstr2int(ip[1]) == 127) return false;
	if (is_in_range(ip[2], 0, 255)==false) return false;
	if (is_in_range(ip[3], 0, 255)==false) return false;
	if (is_in_range(ip[4], 0, 255)==false) return false;

	ip[0] = parseInt(ip[1],[10])+"."+parseInt(ip[2],[10])+"."+parseInt(ip[3],[10])+"."+parseInt(ip[4],[10]);
	if (ip[0] != ipaddr) return false;

	return true;
}
function page_verify()
{
for (var i = 0; i < r_table_size; i++) {
var r_enabled = mf["r_enabled_" + i].value;
var r_dest_ip = mf["r_dest_ip_" + i].value;
var r_subnet = mf["r_subnet_" + i].value;
var r_gw = mf["r_gw_" + i].value;
var r_dlink = mf["r_dlink_" + i].value;

if(!is_blank(r_dest_ip))
{
	if(!is_valid_dest_ip(r_dest_ip,0))
	{
		alert(sw("txtFirewallStr14"));
		mf["r_dest_ip_" + i].select();
		mf["r_dest_ip_" + i].focus();
		return 0;		
	}
}
if(!is_blank(r_subnet))
{
	if(!is_valid_mask(r_subnet,0))
	{
		alert(sw("txtInvalidSubnetMask"));
		mf["r_subnet_" + i].select();
		mf["r_subnet_" + i].focus();	
	}
}
if(!is_blank(r_dest_ip)&&!is_blank(r_subnet))
{
	if(!is_valid_network(r_dest_ip, r_subnet))
	{
		//alert(sw("txtInvalidRouteAddress")+ ".");	
		alert(sw("txtInvalidNetwork"));
		mf["r_dest_ip_" + i].select();
		mf["r_dest_ip_" + i].focus();
		return 0;
	}
}
if(!is_blank(r_gw))
{
	if(!is_valid_ip(r_gw,0))
	{
		alert(sw("txtInvalidRouteGateway")+ ".");
		mf["r_gw_" + i].select();
		mf["r_gw_" + i].focus();
		return 0;		
	}
}

////////////////////////////////////////20090508-patch-end////////////////////////////////////////////

if (!is_number(r_dlink)) {
alert(sw("txtInvalidRouteInterface")+ "'.");
return 0;
}

if( mf["r_enabled_select_" + i].checked ) {
for (var j = i+1; j < r_table_size; j++) {
if( mf["r_enabled_select_" + j].checked ) {
var j_r_dest_ip = mf["r_dest_ip_" + j].value;

if( trim_string(j_r_dest_ip) == trim_string(r_dest_ip) ) {
alert(sw("txtDestinationIPAddressAreSame")+", '" + i + "'" + " "+sw("txtAnd")+" '" + j + "'." );
return 0;
}				
}
}
}

if(r_enabled == "true")
{
if(r_subnet == "0.0.0.0" || is_blank(r_subnet))
{
alert(sw("txtRouteSubnet")+r_subnet+sw("txtisInvalid"));
return 0;
}
if(r_gw == "0.0.0.0" || is_blank(r_gw))
{
alert(sw("txtInvalidRouteGateway")+r_gw);
return 0;
}
if(r_dest_ip == "0.0.0.0" || (ipv4_to_unsigned_integer(r_dest_ip) & 0x000000FF) == 0x000000FF || is_blank(r_dest_ip))
{
alert(sw("txtRouteDestinationIP")+r_dest_ip+sw("txtisInvalid"));
return 0;
}

if( (ipv4_to_unsigned_integer(r_subnet) & 0x000000FF) == 0x00000000 && (ipv4_to_unsigned_integer(r_dest_ip) & 0x000000FF) != 0x00000000)
{
alert(sw("txtRouteDestinationIP")+r_dest_ip+sw("txtisInvalid"));
return 0;
}

if( (ipv4_to_unsigned_integer(r_subnet) & 0x000000FF) == 0x000000FF && (ipv4_to_unsigned_integer(r_dest_ip) & 0x000000FF) == 0x00000000)
{
alert(sw("txtRouteDestinationIP")+r_dest_ip+sw("txtisInvalid"));
return 0;
}

if(r_dlink == 3){
if(CurWanType != "3" && CurWanType != "4"){
alert(sw("txtInvalidRouteInterface"));
return 0;
}
}

if(CurWanType != "3" && CurWanType != "4"){
if(CurWanStatus == "Up" && r_gw != "0.0.0.0"){
var entry_gw= ipv4_to_unsigned_integer(r_gw);
var wanIp= ipv4_to_unsigned_integer(CurWanIp);
var wanMask=ipv4_to_unsigned_integer(CurWanMask);
if(CurWanType != 2){
if ((entry_gw & wanMask) != (wanIp & wanMask)){
alert(sw("txtInvalidRouteGateway")+ ".");
return 0;
}
}else{
var wanMask_wrap=wanMask & 0xFFFFFF00;
if ((entry_gw & wanMask_wrap) != (wanIp & wanMask_wrap)){
alert(sw("txtInvalidRouteGateway")+ ".");
return 0;
}
}
}
}else{
if(r_dlink == 3){
if(CurWanPhyStatus == "Up" && r_gw != "0.0.0.0"){
var entry_gw= ipv4_to_unsigned_integer(r_gw);
var wanphyIp= ipv4_to_unsigned_integer(CurWanphyIp);
var wanphyMask=ipv4_to_unsigned_integer(CurWanphyMask);

if ((entry_gw & wanphyMask) != (wanphyIp & wanphyMask)){
alert(sw("txtInvalidRouteGateway")+ ".");
return 0;
}
}
}else{
if(CurWanStatus == "Up" && r_gw != "0.0.0.0"){
var entry_gw= ipv4_to_unsigned_integer(r_gw);
var wanIp= ipv4_to_unsigned_integer(CurWanIp);
var wanMask=ipv4_to_unsigned_integer(CurWanMask);
var wanMask_wrap=wanMask & 0xFFFFFF00;
//alert(wanMask_wrap);
if ((entry_gw & wanMask_wrap) != (wanIp & wanMask_wrap)){
alert(sw("txtInvalidRouteGateway")+ ".");
return 0;
}
}
}
}
var LAN_IP = ipv4_to_unsigned_integer(r_dest_ip);
var LAN_MASK = ipv4_to_unsigned_integer(r_subnet);	
var tarIp = ipv4_to_unsigned_integer(r_gw);
if ((tarIp & LAN_MASK) == (LAN_IP & LAN_MASK))
{
alert(sw("txtRouteDest1")+integer_to_ipv4(LAN_IP & LAN_MASK));						
return 0;
}

for(var j=0; j<r_table_size; j++)
{
if((mf["r_enabled_" + j].value != "true") || i==j)
{
continue;
}

if(r_dest_ip == mf["r_dest_ip_" + j].value)
{
alert(sw("txtDestinationIPAddressAreSame")+" , '"+i+"' "+sw("txtAnd")+" '"+j+"'.");
return 0;
}
}
}
}
return 1;
}

function page_load()
{
mf = document.forms.mainform;

displayOnloadPage("<%getInfo("ok_msg")%>");

for (var index = 0; index < r_table_size; index++) {
mf["r_enabled_select_" + index].checked = mf["r_enabled_" + index].value == "true";
mf["r_dlink_select_" + index].value = mf["r_dlink_" + index].value;
}
set_form_default_values("mainform");

if (verify_failed != "") {
set_form_always_modified("mainform");
alert(verify_failed);
}
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
if (page_verify()) 
{
mf["settingsChanged"].value = 1;
}
else
{
return false;
}
}

mf.submit();
}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtAdvanced")+'/'+sw("txtRouting");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("SaveSettings").value = sw("txtSaveSettings");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");	
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");				
}

var token= new Array(MAXNUM_ROUTING);

token[0]='<% staticRouteList("sRoute_1");%>';
token[1]='<% staticRouteList("sRoute_2");%>';
token[2]='<% staticRouteList("sRoute_3");%>';
token[3]='<% staticRouteList("sRoute_4");%>';
token[4]='<% staticRouteList("sRoute_5");%>';
token[5]='<% staticRouteList("sRoute_6");%>';
token[6]='<% staticRouteList("sRoute_7");%>';
token[7]='<% staticRouteList("sRoute_8");%>';
token[8]='<% staticRouteList("sRoute_9");%>';
token[9]='<% staticRouteList("sRoute_10");%>';
token[10]='<% staticRouteList("sRoute_11");%>';
token[11]='<% staticRouteList("sRoute_12");%>';
token[12]='<% staticRouteList("sRoute_13");%>';
token[13]='<% staticRouteList("sRoute_14");%>';
token[14]='<% staticRouteList("sRoute_15");%>';
token[15]='<% staticRouteList("sRoute_16");%>';
token[16]='<% staticRouteList("sRoute_17");%>';
token[17]='<% staticRouteList("sRoute_18");%>';
token[18]='<% staticRouteList("sRoute_19");%>';
token[19]='<% staticRouteList("sRoute_20");%>';
token[20]='<% staticRouteList("sRoute_21");%>';
token[21]='<% staticRouteList("sRoute_22");%>';
token[22]='<% staticRouteList("sRoute_23");%>';
token[23]='<% staticRouteList("sRoute_24");%>';
token[24]='<% staticRouteList("sRoute_25");%>';
token[25]='<% staticRouteList("sRoute_26");%>';
token[26]='<% staticRouteList("sRoute_27");%>';
token[27]='<% staticRouteList("sRoute_28");%>';
token[28]='<% staticRouteList("sRoute_29");%>';
token[29]='<% staticRouteList("sRoute_30");%>';
token[30]='<% staticRouteList("sRoute_31");%>';
token[31]='<% staticRouteList("sRoute_32");%>';
var DataArray = new Array();

function routingList(num)
{
for (var i = 0; i < num; i++)
{		
DataArray = token[i].split("/"); //1/Route1/10.10.100.10/255.255.255.0/10.10.100.1/1/0

document.write("<tr>");
document.write("<td>");
document.write("<input type=\"checkbox\" id=\"r_enabled_select_"+i+"\" onclick=\"r_enabled_selector(&quot;"+i+"&quot;, this.checked );\" />");
document.write("<input type=\"hidden\" id=\"r_enabled_"+i+"\" name=\"enabled_"+i+"\" value=\""+DataArray[0]+"\" />");
document.write("<input type=\"hidden\" id=\"r_used_"+i+"\" name=\"used_"+i+"\" value=\""+DataArray[0]+"\" />");
document.write("</td>");
document.write("<td>");
document.write("<input type=\"hidden\" size=\"4\" maxlength=\"3\" id=\"r_dlink_"+i+"\" name=\"dlink_"+i+"\" value=\""+DataArray[6]+"\" />");
document.write("<select id=\"r_dlink_select_"+i+"\" onchange=\"r_dlink_selector(&quot;"+i+"&quot;, this.value);\" >");
document.write("<option value=\"1\">WAN</option>");
document.write("</select>");
document.write("</td>");
document.write("<td>");
document.write("<input type=\"text\" size=\"20\" maxlength=\"15\" id=\"r_dest_ip_"+i+"\"  name=\"dest_ip_"+i+"\" value=\""+DataArray[2]+"\" />");
document.write("</td>");
document.write("<td>");
document.write("<input type=\"text\" size=\"20\" maxlength=\"15\" id=\"r_subnet_"+i+"\" name=\"subnet_"+i+"\" value=\""+DataArray[3]+"\" />");
document.write("</td>");
document.write("<td>");
document.write("<input type=\"text\" size=\"20\" maxlength=\"15\" id=\"r_gw_"+i+"\" name=\"gw_"+i+"\" value=\""+DataArray[4]+"\" />");
document.write("</td>");
document.write("</tr>");
}
}		
//]]>
</script>
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
</div></div></div></div>
<div id="maincontent" style="display: block">
<form name="mainform" action="/goform/formSetRoute" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section">
<div class="section_head">
<h2><SCRIPT >ddw("txtRouting");</SCRIPT></h2>
<p><SCRIPT >ddw("txtRountingStr1");</SCRIPT></p>
<SCRIPT language=javascript>DrawSaveButton();</SCRIPT>
</div>
<div class="box">
<h3>32--<SCRIPT >ddw("txtRouteList");</SCRIPT></h3>
<table border="0" cellpadding="0" cellspacing="1" class="formlisting" id="adv_route_list" summary="">
	
<SCRIPT >ddw("txtRemainRulesCanbeCreated");</SCRIPT>
 : <font color=red>
<%getIndexInfo("reamin_rounting_num");%> 	
</font>
<br><br>

<tr class="form_label_row">
	<td>&nbsp;</td>
	<td><SCRIPT >ddw("txtStrInterface2");</SCRIPT></td>
	<td><SCRIPT >ddw("txtDestiIP");</SCRIPT></td>
	<td><SCRIPT >ddw("txtSubnetMask2");</SCRIPT></td>
	<td><SCRIPT >ddw("txtStrGateway");</SCRIPT></td>
</tr>
<SCRIPT >routingList(MAXNUM_ROUTING);</SCRIPT>
</table></div></div></form><SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>
</div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtRountingStr2");</SCRIPT></p>
<!--
<p><SCRIPT >ddw("txtRountingStr3");</SCRIPT></p>
-->
<p><SCRIPT >ddw("txtRountingStr4");</SCRIPT></p>
<p><SCRIPT >ddw("txtRountingStr5");</SCRIPT></p>
<p><SCRIPT >ddw("txtRountingStr6");</SCRIPT></p>
<p class="more">
<a href="../Help/Advanced.asp#Routing" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>
</p></div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr><td><img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td><td>&nbsp;</td></tr></table></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body></html>
