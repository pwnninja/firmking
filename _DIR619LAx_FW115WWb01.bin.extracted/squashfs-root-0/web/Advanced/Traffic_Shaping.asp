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
var MAXNUM_QOS = 5;

function get_webserver_ssi_uri() {
return ("" !== "") ? "/Basic/Setup.asp" : "/Advanced/Traffic_Shaping.asp";
}
var schedule_options = [
	<%virSevSchRuleList();%> 
];	
function do_add_new_schedule()
{
	top.location = "../Tools/Schedules.asp";
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

var nbrules = MAXNUM_QOS;

function disableQosTable(ischecked)
{
	var tmpStr;
	ischecked = !ischecked;
	
	for (var i = 0; i < MAXNUM_QOS; i++)
	{
		tmpStr = "qos_rules_enabled_select_"+i;
		get_by_id(tmpStr).disabled = ischecked;
		tmpStr = "qos_rules_local_ip_start_"+i;
		get_by_id(tmpStr).disabled = ischecked;
		tmpStr = "qos_rules_local_ip_end_"+i;
		get_by_id(tmpStr).disabled = ischecked;
		tmpStr = "qos_max_trans_rate_select_"+i;
		get_by_id(tmpStr).disabled = ischecked;
		tmpStr ="restrict_rate_"+i;
		get_by_id(tmpStr).disabled = ischecked;
		tmpStr ="schedule_"+i;
		get_by_id(tmpStr).disabled = ischecked;
	}
}

/*
 * qos_auto_trans_rate_selector()
 */
function qos_auto_trans_rate_selector(checked)
{
	mf.qos_auto_trans_rate.value = checked;
	mf.qos_auto_trans_rate_select.checked = checked;
	/* mf.qos_max_trans_rate.disabled = checked;
	mf.qos_max_trans_rate_select.disabled = checked; */
	if(checked)
		disableQosTable(false);
	else
		disableQosTable(true);
}

function qos_max_trans_rate_selector(i,value)
{
	mf["trans_rate_select_"+i].value = value;
	mf["qos_max_trans_rate_select_"+i].value = value;			
}

function sched_name_selector(index, value)
{
	mf["qos_schedule_control_"+index].value=value;
}


function table_form_enable(index, value)
{
	mf["qos_rules_enabled_" + index].value = value;
	mf["qos_rules_used_" + index].value = (value) ? 1 : 0;
	mf["qos_rules_enabled_select_" + index].checked = value;
}

function table_form_set()
{
	for (var i = 0; i < nbrules; i++) {
		if (mf["qos_rules_used_" + i].value == "1") {
			table_form_enable(i, mf["qos_rules_enabled_" + i].value == "1" || mf["qos_rules_enabled_" + i].value == "true");
		}
		schedule_populate_select(mf["schedule_"+i]);
		mf["schedule_"+i].value = mf["qos_schedule_control_"+i].value;

		var trans_rate_select = mf["trans_rate_select_"+i].value;
		qos_max_trans_rate_selector(i, trans_rate_select);				
	}
}

/*
* qos_max_trans_rate_selector()
*/
function manual_qos_max_trans_rate_selector(value)
{
	mf.qos_max_trans_rate.value = value;
	mf.qos_max_down_rate.value = "<% getInfo("qosManualDownSpeed");%>";
	mf.qos_max_trans_rate_select.value = 0;
}

 /*
  * qos_traffic_shaping_enabled_selector()
 */
function qos_traffic_shaping_enabled_selector(checked)
{
	mf.qos_traffic_shaping_enabled.value = checked ? "true" : "false";
	mf.qos_traffic_shaping_enabled_select.checked = checked;

	var disabled = !checked;
	mf.qos_auto_trans_rate_select.disabled = disabled;

	var disable_trans = !checked;
	mf.qos_max_trans_rate.disabled = disable_trans;
	mf.qos_max_down_rate.disabled = disable_trans; //by tsrites
	mf.qos_max_trans_rate_select.disabled = disable_trans;

	var enable_tc_rule = checked && (!mf.qos_auto_trans_rate_select.checked);
	if(enable_tc_rule)
		disableQosTable(true);
	else
		disableQosTable(false);

}

function page_load()
{
	var tc_checked = ("<% getInfo("wantrafficshapping");%>" == "true") ;
	var auto_rate_checked = ("<% getInfo("qosAutoRateSelect");%>" == "1") ;
	
	mf = document.forms.mainform;
	displayOnloadPage("<%getInfo("ok_msg")%>");
	table_form_set();
	qos_traffic_shaping_enabled_selector(tc_checked);
	qos_auto_trans_rate_selector(auto_rate_checked);
	manual_qos_max_trans_rate_selector(<% getInfo("qosManualSpeed");%>);

//	if (!tc_checked)
//		mf.qos_max_trans_rate.value = 0;

	if (tc_checked && !auto_rate_checked)
		disableQosTable(true);
	else
		disableQosTable(false);

	set_form_default_values("mainform");
	if (verify_failed != "") {
		set_form_always_modified("mainform");
		alert(verify_failed);
	}
}

function page_submit()
{
	var last_field;
	var all_down_bandwidth = 0;
	var last_focus = "";
	if (!is_form_modified("mainform"))  //nothing changed
	{
		if (!confirm(sw("txtSaveAnyway"))) 				
			return false;
	}
	else
	{
	if ((mf.qos_traffic_shaping_enabled.value == "true") && (mf.qos_max_trans_rate.value == "")) {
		alert(sw("txtManualdownSpeed")+" "+sw("txtIsEmpty"));		
		mf.qos_max_trans_rate.select();
		mf.qos_max_trans_rate.focus();				
		return false;
	}
	else if((((mf.qos_max_trans_rate.value * 1) < 100) || ((mf.qos_max_trans_rate.value * 1) > 102400) || (!is_number(mf.qos_max_trans_rate.value))) && (mf.qos_traffic_shaping_enabled.value == "true")) {
		alert(sw("txtManualdownSpeed")+" "+sw("txtisInvalid"));		
		mf.qos_max_trans_rate.select();
		mf.qos_max_trans_rate.focus();				
		return false;				
	}
	else if((((mf.qos_max_down_rate.value * 1) < 100) || ((mf.qos_max_down_rate.value * 1) > 102400) || (!is_number(mf.qos_max_down_rate.value))) && (mf.qos_traffic_shaping_enabled.value == "true")) {
		alert(sw("txtManualUplinkSpeed")+" "+sw("txtisInvalid"));		
		mf.qos_max_down_rate.select();
		mf.qos_max_down_rate.focus();				
		return false;				
	}
	if (mf.qos_auto_trans_rate.value != "true")
	for (var i = 0; i < nbrules; i++) {
		var j = i+1;
		var enabled = mf["qos_rules_enabled_" + i].value == "true";
		var bandwidth = mf["restrict_rate_" + i].value;
		var type = mf["qos_max_trans_rate_select_" + i].value;
		
		if (!enabled && (mf["qos_rules_local_ip_start_" + i].value == "") && (bandwidth == "")) {
			continue;
		}

		var s  = sw("txtRule")+" " + j + ": ";				 
		if (!is_ipv4_valid(mf["qos_rules_local_ip_start_" + i].value)) {
			s += sw("txtInvalidDestStartingIP");
			alert(s);
			return false;
		}
		if(mf["qos_rules_local_ip_start_" + i].value != '0.0.0.0'){
			last_field= get_ip(mf["qos_rules_local_ip_start_" + i].value);
			if ((is_valid_ip(mf["qos_rules_local_ip_start_" + i].value, 0)==false) ||(last_field[4]==255) || (mf["qos_rules_local_ip_start_" + i].value == '192.168.0.1'))
			{
				s += sw("txtInvalidDestStartingIP");
				alert(s);
				return false;
			}
		}
		
		if (mf["qos_rules_local_ip_end_" + i].value == "") {
			mf["qos_rules_local_ip_end_" + i].value = mf["qos_rules_local_ip_start_" + i].value;
		}					
		else if (!is_ipv4_valid(mf["qos_rules_local_ip_end_" + i].value)) {
			s += sw("txtInvalidDestEndIP");
			alert(s);
			return false;
		}			

		if(mf["qos_rules_local_ip_end_" + i].value != '0.0.0.0'){
			last_field= get_ip(mf["qos_rules_local_ip_end_" + i].value);
			if ((is_valid_ip(mf["qos_rules_local_ip_end_" + i].value, 0)==false) ||(last_field[4]==255) || (mf["qos_rules_local_ip_end_" + i].value == '192.168.0.1'))
			{
				s += sw("txtInvalidDestEndIP");
				alert(s);
				return false;
			}
		}
		
//		var ip1 = ipv4_to_unsigned_integer(mf["qos_rules_local_ip_start_" + i].value);
		var ip1 = mf["qos_rules_local_ip_start_" + i].value; //change by gold
	//	var ip2 = ipv4_to_unsigned_integer(mf["qos_rules_local_ip_end_" + i].value);				
		var ip2 = mf["qos_rules_local_ip_end_" + i].value;				

		if (ipv4_to_unsigned_integer(ip1) >ipv4_to_unsigned_integer(ip2)) {
			s += sw("txtFirewallStr17");
			alert(s);
			return false;
		}

		var LAN_IP = "<% getInfo("ip-rom"); %>";
		var LAN_MASK = "<% getInfo("mask-rom"); %>";

		if (!is_valid_ip2(ip1,LAN_MASK,LAN_IP))
		{
			s += sw("txtIPAddress");
			s += " ";
			s += sw("txtShouldWithinLanSubnet");
			alert(s);
			return false;
		}
		if (!is_valid_ip2(ip2,LAN_MASK,LAN_IP))
		{
			s += sw("txtIPAddress");
			s += " ";
			s += sw("txtShouldWithinLanSubnet");
			alert(s);
			return false;
		}

		if(bandwidth == "")
		{
			alert(s + sw("txtBandwidth")+" "+sw("txtIsEmpty"));
			mf["restrict_rate_" + i].select();
			mf["restrict_rate_" + i].focus();				
			return false;				
		}
		else 	if ((!is_number(bandwidth)) || (strchk_hostname(bandwidth)==false)||(strchk_unicode(bandwidth)==true) || ((bandwidth * 1) < 10) ||     ( (type==1||type==2) && ( (bandwidth * 1) > (mf.qos_max_trans_rate.value * 1)) ) || ( (type == 3) && ( (bandwidth * 1) > (mf.qos_max_down_rate.value * 1)) )   ) 
		{
			alert(s + sw("txtBandwidth")+" "+sw("txtisInvalid"));		
			mf["restrict_rate_" + i].select();
			mf["restrict_rate_" + i].focus();				
			return false;				
		}
		if(mf["qos_rules_enabled_select_" + i].checked && type == 1)
		{
			all_down_bandwidth += parseInt(bandwidth);
			last_focus = i;
		}
		
	}
	if(mf.qos_max_trans_rate.value < all_down_bandwidth)
	{
		//alert("\"" + sw("txtManualdownSpeed") + "\" < \"" + sw("txtRestrictedBw") + "\"" + sw("txtBandwidth"));
        var salert = sw("txtManualdownSpeed") + " < " + sw("txtRestrictedBw") + "1 + " + sw("txtRestrictedBw") + "2 + ...";
		alert(salert);
		mf["restrict_rate_" + last_focus].focus();
		mf["restrict_rate_" + last_focus].select();
		return false;
	}
	mf["settingsChanged"].value = 1;
	}

	mf.submit();
}

var token= new Array(MAXNUM_QOS);
var DataArray = new Array();
var space_padding;
function Lang_Check()
{
	if(LangCode == 'SC' || LangCode == 'TW'){
		space_padding='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
	}else{
		space_padding='&nbsp;&nbsp;';
	}
}
function QoSList(num)
{

token[0]="<% qosList("1");%>"
token[1]="<% qosList("2");%>"
token[2]="<% qosList("3");%>"
token[3]="<% qosList("4");%>"
token[4]="<% qosList("5");%>"
//token[5]="<% qosList("6");%>"
//token[6]="<% qosList("7");%>"
//token[7]="<% qosList("8");%>"
//token[8]="<% qosList("9");%>"
//token[9]="<% qosList("10");%>"
//token[10]="<% qosList("11");%>"
//token[11]="<% qosList("12");%>"
//token[12]="<% qosList("13");%>"
//token[13]="<% qosList("14");%>"
//token[14]="<% qosList("15");%>"
//token[15]="<% qosList("16");%>"

for (var i = 0; i < num; i++)
{	
DataArray = token[i].split("/"); //enabled_, name, restrict_type_, ipFrom_, ipTo_, macAddr_, trans_rate_select_, restrict_rate_

document.write("<tr>");
document.write("<td >");
document.write("<input type=\"hidden\" id=\"qos_rules_enabled_"+i+"\" name=\"enabled_"+i+"\" value=\""+DataArray[0]+"\" />");
document.write("<input type=\"hidden\" id=\"qos_rules_used_"+i+"\" name=\"used_"+i+"\" value=\""+DataArray[0]+"\" />");
document.write("<input type=\"checkbox\" id=\"qos_rules_enabled_select_"+i+"\" onclick=\"table_form_enable("+i+", this.checked);\" />");
document.write("</td>");
document.write("<td>");
document.write("<label class=\"duple\">"+sw("txtIPAddress")+"</label><br>");
document.write("<input type=\"text\" size=\"12\" maxlength=\"15\" id=\"qos_rules_local_ip_start_"+i+"\" name=\"ipFrom_"+i+"\" value=\""+DataArray[3]+"\" /><br>");
document.write("<label class=\"duple\">&nbsp;"+'~'+"&nbsp;</label><br>");
document.write("<input type=\"text\" size=\"12\" maxlength=\"15\" id=\"qos_rules_local_ip_end_"+i+"\" name=\"ipTo_"+i+"\" value=\""+DataArray[4]+"\" /><br>");
document.write("</td>");
document.write("<td>");
document.write("<input type=\"hidden\" id=\"trans_rate_select_"+i+"\" name=\"trans_rate_select_"+i+"\" value=\""+DataArray[6]+"\" />");
document.write("<select id=\"qos_max_trans_rate_select_"+i+"\" name=\"qos_max_trans_rate_select_"+i+"\" onchange=\"qos_max_trans_rate_selector("+i+",this.value);\" style=\"width: 120px;\">");
document.write("<option value=\"1\">"+sw("txtRestrictedBw")+"</option>");										
document.write("<option value=\"2\">"+sw("txtGuaraBw")+"</option>");
document.write("<option value=\"3\">"+sw("txtGuaraUpSpeed")+"</option>");																		
document.write("</select>");
document.write("</td>");
document.write("<td>");
document.write("<input type=\"text\" size=\"15\" maxlength=\"6\" id=\"restrict_rate_"+i+"\" name=\"restrict_rate_"+i+"\" value=\""+DataArray[7]+"\" />");
document.write("</td>");
document.write("<td><input id=\"qos_schedule_control_"+i+"\" name=\"qos_schedule_control_"+i+"\" value=\""+DataArray[1]+"\" type=\"hidden\">");
document.write("<select id=\"schedule_"+i+"\" onChange=\"sched_name_selector(&quot;"+i+"&quot;, this.value);\">");
document.write("</select>&nbsp;&nbsp;<br>");
document.write("<input type=\"button\" id=\"schedule_btn\" value=\""+sw("txtNewScheduler")+"\" onclick=\"do_add_new_schedule()\">");
document.write("</td>");																
document.write("</tr>");
}

}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtAdvanced")+'/'+sw("txtQoSEngine");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");	
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");
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
<form id="mainform" name="mainform" action="/goform/formSetQoS" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section">
<div class="section_head">
<h2><SCRIPT >ddw("txtQoSEngine");</SCRIPT></h2>
<p><SCRIPT >ddw("txtTrafficStr1");</SCRIPT></p>
<SCRIPT language=javascript>DrawSaveButton();</SCRIPT>
</div> <!-- section_head -->

<div class="box">
<h3><SCRIPT >ddw("txtWANTrafficShaping");</SCRIPT></h3>
<fieldset>
<div><p>
<input default="true" id="qos_traffic_shaping_enabled" name="config.qos_traffic_shaping_enabled" value="<% getInfo("wantrafficshapping");%>" type="hidden">
<label class="duple"><SCRIPT >ddw("txtEnableTrafficShaping");</SCRIPT>:</label>
<input default="true" id="qos_traffic_shaping_enabled_select" onclick="qos_traffic_shaping_enabled_selector(this.checked)" type="checkbox"></p>
<div id="traffic_shaping_box">
<p><input default="true" id="qos_auto_trans_rate" name="config.qos_auto_trans_rate" value="true" type="hidden">
<label class="duple"><SCRIPT >ddw("txtAutomaticUplinkSpeed");</SCRIPT>:</label>
<input default="true" id="qos_auto_trans_rate_select" onclick="qos_auto_trans_rate_selector(this.checked);" type="checkbox">
</p><p>
<label class="duple"><SCRIPT >ddw("txtManualdownSpeed");</SCRIPT>:</label>
<input autocomplete="off" default="128" disabled="disabled" maxlength="6" size="6" id="qos_max_trans_rate" name="config.qos_max_trans_rate" value="128" type="text">
kbps 

<span style="display:none">&nbsp;&lt;&lt;&nbsp;</span>
<select disabled="disabled" name="qos_max_trans_rate_select" onchange="manual_qos_max_trans_rate_selector(this.value);" style="display:none">
<option default="true" value="0">Select Transmission Rate</option>
<option default="false" value="128">128 kbps</option>
<option default="false" value="256">256 kbps</option>
<option default="false" value="384">384 kbps</option>
<option default="false" value="512">512 kbps</option>
<option default="false" value="1024">1024 kbps</option>
<option default="false" value="2048">2048 kbps</option>
</select></p>
<p>

<label class="duple"><SCRIPT >ddw("txtManualUplinkSpeed");</SCRIPT>:</label>
<input autocomplete="off" default="128" disabled="disabled" maxlength="6" size="6" id="qos_max_down_rate" name="config.qos_max_down_rate" value="128" type="text">
kbps


</p>

</div></div></fieldset></div>

<!-- box -->
<div class="box">
<h3>5-<SCRIPT >ddw("txtQoSEngineRules");</SCRIPT></h3>
<table border="0" cellpadding="0" cellspacing="1" class="formlisting" id="adv_macaddressfilter_list" summary="">
<tr class="form_label_row">
<td rowspan="1" colspan="1">&nbsp;</td>
<td rowspan="1" colspan="1">
	<SCRIPT >ddw("txtQoSLocalIPRange");</SCRIPT>
</td>
<td rowspan="1" colspan="1">
	<SCRIPT >ddw("txtMode");</SCRIPT>
</td>
<td rowspan="1" colspan="1">
	<SCRIPT >ddw("txtBandwidth");</SCRIPT>(kbps)
</td>
<td rowspan="1" colspan="1">
	<SCRIPT >ddw("txtSchedule");</SCRIPT>
</td>

</tr>
<SCRIPT>Lang_Check();QoSList(MAXNUM_QOS);</SCRIPT>	
</table>
</div></div></form><SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>
</div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtTrafficStr2");</SCRIPT></p>
<p class="more">
<a href="../Help/Advanced.asp#Traffic_Shaping" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>
</p></div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr><td><img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td><td>&nbsp;</td></tr></table></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body></html>
