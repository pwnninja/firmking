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
.hour_box {width: 40px;}
.min_box {width: 40px;}
.ampm_box {width: 50px;}
#day_select  {margin-bottom: 10px;}
#day_select input {margin: 0 1px 0 0;padding: 0;	}
#day_select label {margin: 0 4px 0 1px;padding: 0;}
fieldset label.duple {width: 135px;}
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
var update_flag = document.URL.indexOf("update");
if('<%getInfo("opmode");%>' =='Disabled')
	OP_MODE='1';
else
	OP_MODE='0';
if('<%getIndexInfo("wlanDisabled");%>'=='Disabled')
	WLAN_ENABLED='0';
else
	WLAN_ENABLED='1';
var MAX_SCHEDULE_RULE_NUM = "<% getInfo("maxScheduleRule");%>"*1;
var CUR_SCHEDULE_RULE_NUM = "<% getInfo("curScheduleRule");%>"*1;

function get_webserver_ssi_uri() {
		return ("" !== "") ? "/Basic/Setup.asp" : "/Tools/Schedules.asp";
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
<!-- InstanceBeginEditable name="Scripts" -->
<script language="JavaScript" type="text/javascript">
//<![CDATA[
var mf;
var rf;
var verify_failed = "<%getInfo("err_msg")%>";
function is_sched_valid()
{
	if (!is_number(mf["start_time_hour"].value)
			|| (mf["start_time_hour"].value < 0) 
			|| (mf["start_time_hour"].value > 23)) {
		mf["start_time_hour"].select();
		mf["start_time_hour"].focus();
		return false;
	}
	if (!is_number(mf["end_time_hour"].value)
			|| (mf["end_time_hour"].value < 0) 
			|| (mf["end_time_hour"].value > 24) || (mf["end_time_hour"].value == 24 && mf["end_time_min"].value != 0)) {
		mf["end_time_hour"].select();
		mf["end_time_hour"].focus();
		return false;
	}
	if (!is_number(mf["start_time_min"].value)
			|| (mf["start_time_min"].value < 0) 
			|| (mf["start_time_min"].value >59)) {
		mf["start_time_min"].select();
		mf["start_time_min"].focus();
		return false;
	}
	if (!is_number(mf["end_time_min"].value)
			|| (mf["end_time_min"].value < 0) 
			|| (mf["end_time_min"].value > 59)) {
		mf["end_time_min"].select();
		mf["end_time_min"].focus();
		return false;
	}
		return true;
	}
function padout(number)
{ 
	return (number < 10) ? '0' + number : number; 
}
function sec_to_string(sec)
{
	var min = (sec % 3600) / 60;
	var hr = (sec - min * 60) / 3600;

		return(padout(hr) + ":" + padout(min) + " ");
}
/*
 * Convert start and end time into time format such as "09:30AM-03:25PM".
 *	Return "24 Hours" if start==0 and end==86400.
 *	Return "--" if (start == 0) and (end == 0)
 */
function time_to_string(start, end)
{
	if ((start == 0) && (end == 86400)) {
		return(sw("txtAllDay"));
	}
	return(sec_to_string(start) + "-" + sec_to_string(end));
}		
function days_to_string(val)
{
	if (val == 127) {
		return (sw("txtEveryDay"));
	}
	s = "";			
	for (var i = 0; i < 7; i++) {
		if (val & (1 << i)) {
			s += days[i] + " ";
		}
	}
		return s;
}
function sched_weekdays_selector(checked, val)
{
	if (checked) {
		mf["sel_days"].checked = true;
		mf["weekdays"].value |= val;	// set the bit
	} else {
		mf["weekdays"].value &= ~val;	// clear the bit
	}
	if (mf["weekdays"].value == 127) {
		all_week_radio_selector(true, false);
	}
}
function is_day_set(val, saved_val)
{	
	if ((saved_val.value == 0x7f) && (saved_val.value != val)) {
			return false;
	} else {
			return(((saved_val & val) == val) ? true : false);
	}
}
function all_week_radio_selector(val, clear_flag)
{
	if (val) {
		mf["all_week"].checked = true;
		mf["weekdays"].value = 127;
	} else {
		mf["sel_days"].checked = true;
		if (clear_flag) {
			mf["weekdays"].value = 0;
		}
	}
/* Enable/disable weekdays checkbox. */
	mf["Sun_select"].disabled = val;
	mf["Mon_select"].disabled = val;
	mf["Tue_select"].disabled = val;
	mf["Wed_select"].disabled = val;
	mf["Thu_select"].disabled = val;
	mf["Fri_select"].disabled = val;
	mf["Sat_select"].disabled = val;
/* Set weekdays checkbox. */
var saved_val = mf["weekdays"].value;
	mf["Sun_select"].checked = is_day_set(0x01, saved_val);
	mf["Mon_select"].checked = is_day_set(0x02, saved_val);
	mf["Tue_select"].checked = is_day_set(0x04, saved_val);
	mf["Wed_select"].checked = is_day_set(0x08, saved_val);
	mf["Thu_select"].checked = is_day_set(0x10, saved_val);
	mf["Fri_select"].checked = is_day_set(0x20, saved_val);
	mf["Sat_select"].checked = is_day_set(0x40, saved_val);			
}
function all_day_selector(val)
{
	if (val) {
		mf["start_time"].value = 0;
		mf["end_time"].value = 86400;
	}
/* Set display value */
	mf["start_time_hour"].value = time_retriever(mf["start_time"].value, 1);
	mf["start_time_min"].value = time_retriever(mf["start_time"].value, 2);
	//mf["start_time_ampm"].value = time_retriever(mf["start_time"].value, 3);
	mf["end_time_hour"].value = time_retriever(mf["end_time"].value, 1);
	mf["end_time_min"].value = time_retriever(mf["end_time"].value, 2);
	//mf["end_time_ampm"].value = time_retriever(mf["end_time"].value, 3);
/* Set enabled/disabled */
	mf["start_time_hour"].disabled = val;
	mf["start_time_min"].disabled = val;
	//mf["start_time_ampm"].disabled = val;
	mf["end_time_hour"].disabled = val;
	mf["end_time_min"].disabled = val;
	//mf["end_time_ampm"].disabled = val;			
}
function time_retriever(time, id)
{
	var min = (time % 3600) / 60;
	var hr = (time - min*60) / 3600;
	var pm = (hr >= 12 && hr != 24) ? 1 : 0;
	switch(id) {
	case 1:
		return (hr);
	case 2:
		return(min);
	case 3:
		return(pm);
	}
}
/** Convert from hh:mm:pm to seconds.*/
function sched_time_to_sec(hr, min, pm)
{
	//hr = (hr == 12) ? 0 : hr;
	return (hr * 3600 + min * 60 + pm * 12 * 3600);			
}
function table_form_set_display_if_table_is_full(val)
{
	if (val == true) {
		document.getElementById("mainform_box").style.display = "none";
		document.getElementById("fullform_box").style.display = "block";
	} else {
		document.getElementById("mainform_box").style.display = "block";
		document.getElementById("fullform_box").style.display = "none";
	}	
}
function table_form_set_action_title(val)
{
	if (val == "1") {	// Add
		//document.getElementById("Action").value = sw("txtAdd");
		document.getElementById("Action").onclick = table_form_add;
		document.getElementById("sched_title").innerHTML = sw("txtAdd");	
	} else if (val == "2") {	// Update			
		//document.getElementById("Action").value = sw("txtUpdate");
		document.getElementById("Action").onclick = table_form_update;
		document.getElementById("sched_title").innerHTML = sw("txtUpdate");
	}
}
function table_form_delete(val)
{
	mf.curTime.value = new Date().getTime();
	var name = document.getElementById("sched_name_" + val).value;
	if (!confirm(sw("txtSureToDelete")+": " + name)) {
		return;
	}
if( name == "Always") {
		var s,s2;
		s = sw("txtSchedules");
		s2 =  s;
		s = sw("txtCantDeleteOrRenamedUsed");
		s2 = s2 + " '" + name + "' " + s;
		alert(s2);
		return;
}
	mf["index"].value = val;
	mf["act"].value = "3";	// 3: delete an entry
	mf["used"].value = "0";
	mf["used"].name = "used";
	mf["enabled"].value = "false";
	mf["enabled"].name = "enabled";
	mf["sched_name"].name = "sched_name";
	mf["sched_name"].value = name;
	mf.submit();
}
function table_form_edit(val)
{
	table_form_set_display_if_table_is_full(false);
	table_form_set_action_title("2");
	if(update_flag == -1)
	{
		mf.curTime.value = new Date().getTime();
		mf["act"].value = "4";  // 4: weather the action object that i edit is in use.
	}
	mf["index"].value = val;
	mf["used"].value = rf["used_" + val].value;
	mf["enabled"].value = rf["enabled_" + val].value;
	mf["sched_name"].value = rf["sched_name_" + val].value;
	mf["weekdays"].value = rf["weekdays_" + val].value;
	mf["start_time"].value = rf["start_time_" + val].value;
	mf["end_time"].value = rf["end_time_" + val].value;
	all_week_radio_selector(mf["weekdays"].value == 127, false);
	if (mf["start_time"].value == 0 && mf["end_time"].value == 86400) {
			mf["all_day"].checked = true;
		} else {
			mf["all_day"].checked = false;
		}			
		all_day_selector(mf["all_day"].checked);
	if(update_flag == -1)
	{
		mf.submit();
	}
}
function edit_form_submit(idx)
{
	mf.curTime.value = new Date().getTime();
	if (!mf["all_day"].checked){
		if (!is_sched_valid()) {
			alert(sw("txtInvalidSchedule"));
			return;
		}
	}
		
/* Calculate start time and end time if all_day is not set. */
	if (!mf["all_day"].checked) {
	mf["start_time"].value = sched_time_to_sec(mf["start_time_hour"].value, mf["start_time_min"].value, 0);
	mf["end_time"].value = sched_time_to_sec(mf["end_time_hour"].value, mf["end_time_min"].value, 0);
	}
/* Set submit elements' name */
	mf["used"].name = "used";
	mf["used"].value = "1";
	mf["enabled"].name = "enabled";
	mf["enabled"].value = (mf["used"].value == "1") ? true : false;
	mf["sched_name"].name = "sched_name";
	mf["weekdays"].name = "weekdays";
	mf["start_time"].name = "start_time";
	mf["end_time"].name = "end_time";
		mf.submit();
}
function utf8len(str)
{
    var c, b = 0, l = str.length;
    while(l) {
        c = str.charCodeAt(--l);
        b += (c < 128) ? 1 : ((c < 2048) ? 2 : ((c < 65536) ? 3 : 4));
    };
    return b;
}
function table_form_update()
{
	var idx = mf["index"].value;
	var name = document.getElementById("sched_name_" + idx).value;
	
	if(mf["all_week"].checked || mf["Sun_select"].checked || mf["Mon_select"].checked || mf["Tue_select"].checked || mf["Wed_select"].checked || mf["Thu_select"].checked || mf["Fri_select"].checked || mf["Sat_select"].checked)
	{
        var sched_name_len = utf8len(mf["sched_name"].value);
        if(sched_name_len == 0)
        {
            alert(sw("txtNameBlank"));
            return false;
        }
        else if(sched_name_len > 19)
        {
            alert(sw("txtNameLen")+sw("txtCurrentLen")+sched_name_len+sw("txtChar"));
            return false;
        }

	}
	if(mf["sel_days"].checked)
	{
		if(!mf["Sun_select"].checked && !mf["Mon_select"].checked && ! mf["Tue_select"].checked && ! mf["Wed_select"].checked && ! mf["Thu_select"].checked && ! mf["Fri_select"].checked && ! mf["Sat_select"].checked)
		{
			alert(sw("txtNoDayIsSelected"));					
			return false;	
		}
	}
	if (!confirm(sw("txtSureToUpdate")+": " + name)) {
		return;
	}			
/* Check already exist */
    for(var i=0; i<MAX_SCHEDULE_RULE_NUM ;i++)
    {
            var tmp="sched_name_"+i;
			if(i == idx)
				continue;
            if(get_by_id(tmp) != null)
            {
                if(get_by_id(tmp).value == get_by_id("sched_name").value)
                {
                    alert(sw("txtName")+" '"+get_by_id("sched_name").value+"' "+sw("txtIsAlreadyUsed"));
                    return false;
                }
            }


    }
	if( name == "Always") {
		if( name != mf["sched_name"].value) {
			var s,s2;
			s = sw("txtSchedules");
			s2 =  s;
			s = sw("txtCantDeleteOrRenamedUsed");
			s2 = s2 + " '" + name + "' " + s;
			alert(s2);
			return;
		}
	}
	
       if (!mf["all_day"].checked) {
	mf["start_time"].value = sched_time_to_sec(mf["start_time_hour"].value, mf["start_time_min"].value, 0);
	mf["end_time"].value = sched_time_to_sec(mf["end_time_hour"].value, mf["end_time_min"].value, 0);
	}
	if(mf["start_time"].value*1 >= mf["end_time"].value*1)
	{
		alert(sw("txtScheError"));
		return false;
	}
	mf["act"].value = "2";	// 2: update an entry
	edit_form_submit(idx);	
}
function table_form_add()
{
	var idx = rf["free"].value;
	if(mf["all_week"].checked || mf["Sun_select"].checked || mf["Mon_select"].checked || mf["Tue_select"].checked || mf["Wed_select"].checked || mf["Thu_select"].checked || mf["Fri_select"].checked || mf["Sat_select"].checked)
	{
        var sched_name_len = utf8len(mf["sched_name"].value);
        if(sched_name_len == 0)
        {
            alert(sw("txtNameBlank"));
            return false;
        }
        else if(sched_name_len > 19)
        {
            alert(sw("txtNameLen")+sw("txtCurrentLen")+sched_name_len+sw("txtChar"));
            return false;
        }
	}
	if(mf["sel_days"].checked)
	{
		if(!mf["Sun_select"].checked && !mf["Mon_select"].checked && ! mf["Tue_select"].checked && ! mf["Wed_select"].checked && ! mf["Thu_select"].checked && ! mf["Fri_select"].checked && ! mf["Sat_select"].checked)
		{
			alert(sw("txtNoDayIsSelected"));					
			return false;	
		}
	}
/* Check already exist */
	for(var i=0; i<MAX_SCHEDULE_RULE_NUM ;i++)
	{
			var tmp="sched_name_"+i;
			if(get_by_id(tmp) != null)
			{
				if(get_by_id(tmp).value == get_by_id("sched_name").value)
				{
					alert(sw("txtName")+" '"+get_by_id("sched_name").value+"' "+sw("txtIsAlreadyUsed"));
					return false;
				}
			}

			
	}
	if (!mf["all_day"].checked) {
	mf["start_time"].value = sched_time_to_sec(mf["start_time_hour"].value, mf["start_time_min"].value, 0);
	mf["end_time"].value = sched_time_to_sec(mf["end_time_hour"].value, mf["end_time_min"].value, 0);
	}
	if(mf["start_time"].value*1 >= mf["end_time"].value*1)
	{
		alert(sw("txtScheError"));
		return false;
	}
	mf["index"].value = idx;
	mf["act"].value = "1";	// 1: add an entry
	edit_form_submit(idx);
}
function table_form_recover()
{
	var idx = "";
	var act = "";
	if (idx != "") {
		table_form_set_display_if_table_is_full(false);
		table_form_set_action_title(act);				
		mf["sched_name"].value = "";
		mf["weekdays"].value = "";
		mf["start_time"].value = "";
		mf["end_time"].value = "";
/* Set weekdays display and checkboxes */
		all_week_radio_selector(mf["weekdays"].value == 127, false);
/* Set time display and checkboxes */
		if (mf["start_time"].value == 0 && mf["end_time"].value == 86400) {
			mf["all_day"].checked = true;
		} else {
			mf["all_day"].checked = false;
		}			
		all_day_selector(mf["all_day"].checked);
	}
}
/** Update the rules list.*/
function update_rulesform()
{
    var cnt = MAX_SCHEDULE_RULE_NUM;
    for (var i = 0; i < cnt; i++) {
		if (typeof(rf["used_" + i]) != "undefined") {					
			document.getElementById("sched_name_str_" + i).innerHTML = rf["sched_name_" + i].value.replace(/ /g, "&#160;");
			document.getElementById("weekdays_str_" + i).innerHTML = days_to_string(rf["weekdays_" + i].value);
			document.getElementById("time_str_" + i).innerHTML = time_to_string(rf["start_time_" + i].value, rf["end_time_" + i].value);
		}
    }
}
/** Set start and end time in mainform. */
function set_time(sh, sm, sampm, eh, em, eampm)
{
	mf["start_time_hour"].value = sh;
	mf["start_time_min"].value = sm;
	mf["end_time_hour"].value = eh;
	mf["end_time_min"].value = em;
}
/** Clear and reset changes to the page. */
function page_clear()
{
	if (is_form_modified("mainform")) {
		if (verify_failed !== "") {
			top.location = "Schedules.asp";
		} else {					
			reset_form("mainform");
			reset_form("rulesform");
			table_form_set_action_title("1");
			page_load();
	}
	}
}
function page_load() 
{
		displayOnloadPage("<%getInfo("ok_msg")%>");
var local_debug = false;
var str = document.URL;
var string = str.split("&");

eval(string[1]);

mf = document.forms["mainform"];
rf = document.forms["rulesform"];
if (local_debug) {
		hide_all_ssi_tr();
		rf["free"].value = 0;
		mf["sel_days"].checked = true;
		table_form_set_display_if_table_is_full(false);
		return;
}
table_form_set_display_if_table_is_full(MAX_SCHEDULE_RULE_NUM == CUR_SCHEDULE_RULE_NUM);
/* Update the rules list. */
update_rulesform();
/* Initialize array editor and set default. */
mf["sched_name"].value = "";
mf["weekdays"].value = 0;
all_week_radio_selector(mf["weekdays"].value == 127, true);
set_time(0, 0, 0, 0, 0, 0);
mf["all_day"].checked = false;
all_day_selector(mf["all_day"].checked);
set_form_default_values("mainform");
set_form_default_values("ruleform");
/* Check for validation errors. */
if (verify_failed != "") {
		table_form_recover();
		alert(sw("txtSchedule")+" '"+verify_failed+"' "+sw("txtCantDelOrRename"));
	}			
if(update_flag != -1)
{
	table_form_edit(index);
}
}
function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtTools")+'/'+sw("txtSchedules");
	document.title = DOC_Title;	
	get_by_id("RestartNow").value = sw("txtRebootNow");
	get_by_id("RestartLater").value = sw("txtRebootLater");
	get_by_id("Action").value = sw("txtSaveSettings");
	get_by_id("Clear").value = sw("txtDontSaveSettings");			
}
//]]>
</script><!-- InstanceEndEditable --></head>
<body onload="template_load(); init();web_timeout();">
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
</SCRIPT></div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >DrawLanguageList();	</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td>
<td id="maincontent_container"><SCRIPT >DrawRebootContent("none");</SCRIPT>
<div id="warnings_section" style="display:none"><div class="section" >	<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
<!-- This division will be populated with configuration warning information -->
</div><!-- box warnings_section_content --></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
<form id="mainform" name="mainform" action="/goform/formSchedule" method="post">
	<input type="hidden" id="curTime" name="curTime" value=""/>
	<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtSchedule");</SCRIPT></h2>
<p>	<SCRIPT >ddw("txtSchedulesStr1");</SCRIPT></p>
<input type="button" class="button_submit" id="Action" value="" onclick="table_form_add();" />
<input type="button" class="button_submit" id="Clear" value="" onclick="page_clear();" />
</div>
<div id="fullform_box" class="box" style="display:none">
<h3>33 - <span id="sched_title0"><SCRIPT >ddw("txtAdd");</SCRIPT></span>
<SCRIPT >ddw("txtScheduleRule");</SCRIPT></h3>
<SCRIPT >ddw("txtScheduleRuleFull");</SCRIPT>
</div>
<div id="mainform_box" class="box">
<h3>33 - <span id="sched_title"><SCRIPT >ddw("txtAdd");</SCRIPT></span>
<SCRIPT >ddw("txtScheduleRule");</SCRIPT></h3>
<fieldset>
<input type="hidden" name="index" />
<input type="hidden" name="act" />
<input type="hidden" name="used" id="used" />
<input type="hidden" name="enabled" id="enabled" />
<input type="hidden" name="weekdays" id="weekdays" />
<input type="hidden" name="start_time" id="start_time" />
<input type="hidden" name="end_time" id="end_time" />
<p><label class="duple"><SCRIPT >ddw("txtName");</SCRIPT>&nbsp;:</label>
<input type="text" id="sched_name" size="20" maxlength="19" value="" /></p>
<p><label class="duple"><SCRIPT >ddw("txtDay");</SCRIPT>&nbsp;:</label>
<input type="radio" id="all_week" name="set_days" value="1" onclick="all_week_radio_selector(true, true);"/> 
<label><SCRIPT >ddw("txtAllWeek");</SCRIPT></label>
<input type="radio" id="sel_days" name="set_days" value="0" onclick="all_week_radio_selector(false, true)"/> 
<label><SCRIPT >ddw("txtSelectDay");</SCRIPT></label></p>
<p><label class="duple"></label><span id="day_select">
<input type="checkbox" id="Sun_select" onclick="sched_weekdays_selector(this.checked, 0x01);" /><label><SCRIPT >ddw("txtSun");</SCRIPT></label>
<input type="checkbox" id="Mon_select" onclick="sched_weekdays_selector(this.checked, 0x02);" /><label><SCRIPT >ddw("txtMon");</SCRIPT></label>
<input type="checkbox" id="Tue_select" onclick="sched_weekdays_selector(this.checked, 0x04);" /><label><SCRIPT >ddw("txtTue");</SCRIPT></label>
<input type="checkbox" id="Wed_select" onclick="sched_weekdays_selector(this.checked, 0x08);" /><label><SCRIPT >ddw("txtWed");</SCRIPT></label>
<input type="checkbox" id="Thu_select" onclick="sched_weekdays_selector(this.checked, 0x10);" /><label><SCRIPT >ddw("txtThu");</SCRIPT></label>
<input type="checkbox" id="Fri_select" onclick="sched_weekdays_selector(this.checked, 0x20);" /><label><SCRIPT >ddw("txtFri");</SCRIPT></label>
<input type="checkbox" id="Sat_select" onclick="sched_weekdays_selector(this.checked, 0x40);" /><label><SCRIPT >ddw("txtSat");</SCRIPT></label>
</span>
</p>
<p><label class="duple"><SCRIPT >ddw("txtAllDay24hrs");</SCRIPT>
&nbsp;:</label>
<input type="checkbox" id="all_day" onclick="all_day_selector(this.checked);" /></p>
<p><label class="duple">
<SCRIPT >ddw("txtStartTime");</SCRIPT>&nbsp;:</label>
<input type="text" id="start_time_hour" maxlength="2" class="hour_box" /> :
<input type="text" id="start_time_min"  maxlength="2" class="min_box" />
&nbsp;&nbsp;
<SCRIPT >ddw("txtHourMinute12HourTime");</SCRIPT>
</p><p><label class="duple">
<SCRIPT >ddw("txtEndTime");</SCRIPT>&nbsp;:</label>
<input type="text" id="end_time_hour" maxlength="2" class="hour_box" /> :
<input type="text" id="end_time_min"  maxlength="2" class="min_box" />
&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtHourMinute12HourTime");</SCRIPT></p>
<p><label class="duple"></label>

</p></fieldset></div>
</div>	</form>
<form id="rulesform" name="rulesform" action="">
<div class="section"><div id ="rulesform_box" class="box">
<h3><SCRIPT >ddw("txtScheduleRulesList");</SCRIPT></h3>
<table border="0" cellpadding="0" cellspacing="1" class="formlisting" id="tools_schedules_ruleslist" summary="">
<tr class="form_label_row"><th class="formlist_col1" rowspan="1" colspan="1">
<SCRIPT >ddw("txtName");</SCRIPT></th>
<th class="formlist_col2" rowspan="1" colspan="1">
<SCRIPT >ddw("txtDays");</SCRIPT></th>
<th class="formlist_col3" rowspan="1" colspan="1">
<SCRIPT >ddw("txtTimeFrame");</SCRIPT></th>
<th class="formlist_img" rowspan="1" colspan="1">&nbsp;</th>
<th class="formlist_img" rowspan="1" colspan="1">&nbsp;	</th></tr>
<%scheduleRuleList();%>
</table><input type="hidden" id="free" value="0" /></div><!-- box --></div><!-- section --></form><!-- InstanceEndEditable -->
</div>	</td>
<td id="sidehelp_container">
<div id="help_text">
<!-- InstanceBeginEditable name="Help_Text" --> 
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtSchedulesStr2");</SCRIPT></p>
<p><SCRIPT >ddw("txtSchedulesStr3");</SCRIPT></p>
<!--
<p><SCRIPT >ddw("txtSchedulesStr4");</SCRIPT></p>
<p><SCRIPT >ddw("txtSchedulesStr5");</SCRIPT></p>
<p><SCRIPT >ddw("txtSchedulesStr6");</SCRIPT></p>
-->
<p class="more"><!-- Link to more help -->
<a href="../Help/Tools.asp#Schedules" onclick="return jump_if();"><SCRIPT >ddw("txtMore");</SCRIPT>	...</a>
</p><!-- InstanceEndEditable --></div></td>
</tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
