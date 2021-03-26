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
#tools_time_set select {
width: 50px;
}
fieldset label.duple {
width: 153px;
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
	return ("" !== "") ? "/Basic/Setup.asp" : "/Basic/Time.asp";
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
<script type="text/javascript">
//<![CDATA[
var mf;

function tz_daylight_on_off(checkValue)
{
	//alert("tz_daylight_on_off="+checkValue);
	if(checkValue == true)
	{
		mf.tz_daylight_select.disabled = false;
	}
	else
	{
		mf.tz_daylight.value = false;
		mf.tz_daylight_select.disabled = true;
	}
	
}

function tz_daylight_start_end_date_get(dateValue)
{
	var start_end_date = dateValue.split(',');
	start_end_date[0] = start_end_date[0].substring(1,start_end_date[0].length);
	start_end_date[1] = start_end_date[1].substring(1,start_end_date[1].length);
	
	//get start date
	var start_date_time = start_end_date[0].split('/');
	var start_m_w_d=start_date_time[0].split('.');
	mf.tz_daylight_start_month.value = start_m_w_d[0];
	mf.tz_daylight_start_week.value = start_m_w_d[1];
	mf.tz_daylight_start_day.value = start_m_w_d[2];
	var start_t=start_date_time[1].split(':');
	mf.tz_daylight_start_time.value = parseInt(start_t[0], 10);

	//get end date
	var end_date_time = start_end_date[1].split('/');
	var end_m_w_d=end_date_time[0].split('.');
	mf.tz_daylight_end_month.value = end_m_w_d[0];
	mf.tz_daylight_end_week.value = end_m_w_d[1];
	mf.tz_daylight_end_day.value = end_m_w_d[2];
	var end_t=end_date_time[1].split(':');
	mf.tz_daylight_start_time.value = parseInt(end_t[0], 10);
/*	
	alert(mf.tz_daylight_start_month.value);
	alert(mf.tz_daylight_start_week.value);
	alert(mf.tz_daylight_start_day.value);
	alert(mf.tz_daylight_start_time.value);
	alert(mf.tz_daylight_end_month.value);
	alert(mf.tz_daylight_end_week.value);
	alert(mf.tz_daylight_end_day.value);
	alert(mf.tz_daylight_start_time.value);
*/
}
function tz_daylight_selector(checked)
{
	mf.tz_daylight.value = checked;
	mf.tz_daylight_select.checked = checked;
	var disabled = !checked;
	mf.tz_daylight_offset_select.disabled = disabled;
	mf.tz_daylight_start_month_select.disabled = disabled;
	mf.tz_daylight_start_week_select.disabled = disabled;
	mf.tz_daylight_start_day_select.disabled = disabled;
	mf.tz_daylight_start_time_select.disabled = disabled;
	mf.tz_daylight_end_month_select.disabled = disabled;
	mf.tz_daylight_end_week_select.disabled = disabled;
	mf.tz_daylight_end_day_select.disabled = disabled;
	mf.tz_daylight_end_time_select.disabled = disabled;
/* Update the manual date/time fields. */
	if (mf.tz_enable_ntp_select.checked) {
		return;
	}
	var d = get_manual_date();
	var localtime = Math.floor(d.getTime() / 1000);
	var dst_offset = parseInt(mf.tz_daylight_offset.value, 10);
	if (!checked) {
		dst_offset = -dst_offset;
	}
	compute_dst_toggle_times();
	if (in_dst_now(d)) {
		localtime += dst_offset;
		d.setTime (localtime * 1000);
		extract_time(d);
	}
}
var tz_daylight_previous_offset = "3600";
function tz_daylight_offset_selector(value)
{
	mf.tz_daylight_offset.value = value;
	mf.tz_daylight_offset_select.value = value;
	/* Update the manual date/time fields. */
	if (mf.tz_enable_ntp_select.checked) {
		return;
	}
	var d = get_manual_date();
	var localtime = Math.floor(d.getTime() / 1000);
	var dst_offset = parseInt(mf.tz_daylight_offset.value, 10) - parseInt(tz_daylight_previous_offset, 10);
	compute_dst_toggle_times();
	if (in_dst_now(d)) {
		localtime += dst_offset;
		d.setTime (localtime * 1000);
		extract_time(d);
	}
	tz_daylight_previous_offset = value;
}
var tz_daylight_previous_zone ="";
function tz_timezone_selector()
{
	if(LangCode=="SC")
		daylightOffset = ntp_zone_array_sc[get_by_id("select_timezone").selectedIndex].daylightOffset;
	else if(LangCode=="TW")
		daylightOffset = ntp_zone_array_tw[get_by_id("select_timezone").selectedIndex].daylightOffset;
	else
		daylightOffset = ntp_zone_array[get_by_id("select_timezone").selectedIndex].daylightOffset;
		
tz_daylight_on_off(daylightOffset-7200 != 0);
	if(LangCode=="SC")
		daylightStartEndDate= ntp_zone_array_sc[get_by_id("select_timezone").selectedIndex].daylightStartEndDate;
	else if(LangCode=="TW")
		daylightStartEndDate= ntp_zone_array_tw[get_by_id("select_timezone").selectedIndex].daylightStartEndDate;
	else
		daylightStartEndDate= ntp_zone_array[get_by_id("select_timezone").selectedIndex].daylightStartEndDate;
tz_daylight_start_end_date_get(daylightStartEndDate);
	
	var d = get_manual_date();
	var localtime = Math.floor(d.getTime() / 1000);

	
	calcu_tzOffTime();
	var tz_offset = parseInt(tz_offTime, 10) - parseInt(tz_daylight_previous_zone, 10);
	localtime += tz_offset;
	d.setTime (localtime * 1000);
	extract_time(d);
	tz_daylight_previous_zone = tz_offTime;
	
}
function tz_daylight_start_month_selector(value)
{
	mf.tz_daylight_start_month.value = value;
	mf.tz_daylight_start_month_select.value = value;
}
function tz_daylight_start_week_selector(value)
{
	mf.tz_daylight_start_week.value = value;
	mf.tz_daylight_start_week_select.value = value;
}
function tz_daylight_start_day_selector(value)
{
	mf.tz_daylight_start_day.value = value;
	mf.tz_daylight_start_day_select.value = value;
}
function tz_daylight_start_time_selector(value)
{
	mf.tz_daylight_start_time.value = value;
	mf.tz_daylight_start_time_select.value = value;
}
function tz_daylight_end_month_selector(value)
{
	mf.tz_daylight_end_month.value = value;
	mf.tz_daylight_end_month_select.value = value;
}
function tz_daylight_end_week_selector(value)
{
	mf.tz_daylight_end_week.value = value;
	mf.tz_daylight_end_week_select.value = value;
}
function tz_daylight_end_day_selector(value)
{
	mf.tz_daylight_end_day.value = value;
	mf.tz_daylight_end_day_select.value = value;
}
function tz_daylight_end_time_selector(value)
{
	mf.tz_daylight_end_time.value = value;
	mf.tz_daylight_end_time_select.value = value;
}
function tz_enable_ntp_selector(checked)
{
	mf.tz_enable_ntp.value = checked;
	mf.tz_enable_ntp_select.checked = checked;
	mf.tz_ntp_addr_select.disabled = !checked;
	mf.ntp_syn.disabled = !checked;
	mf.manual_sync.disabled = checked;
	mf.manual_year_select.disabled = checked;
	mf.manual_month_select.disabled = checked;
	mf.manual_day_select.disabled = checked;
	mf.manual_hour_select.disabled = checked;
	mf.manual_min_select.disabled = checked;
	mf.manual_sec_select.disabled = checked;
}
function tz_ntp_addr_selector(value)
{
	mf.tz_ntp_addr.value = value;
	mf.tz_ntp_addr_select.value = value;

}

function validate_ntp_server()
{
	if ((mf.tz_enable_ntp.value == "true") && mf.tz_ntp_addr_select.value == 0) {
		alert(sw("txtNTPServerNotConfigured"));
		return false;
	}
	return true;
}
var rgw_time;

var dst_start_d, dst_end_d;

var clock_timeout;
var router_dst_start_d = new Date();
var router_dst_end_d = new Date();
var router_tz_daylight_offset=0;
//var ttt = new Date();
var mydaylight = "false";
var mydayadd=0;
var mydebug="";
var ttt = new Date();
function router_in_dst_now(date)
{
	var localtime = date.getTime();
	if (router_dst_start_d.getTime() < router_dst_end_d.getTime()) {
		return localtime >= router_dst_start_d.getTime() && localtime <= router_dst_end_d.getTime();
	} else {
		return !(localtime < router_dst_start_d.getTime() && localtime > router_dst_end_d.getTime());
	}
}
function update_wall_clock()
{
	var weekday=new Array(7)
	weekday[0]=sw("txtSun")
	weekday[1]=sw("txtMon")
	weekday[2]=sw("txtTue")
	weekday[3]=sw("txtWed")
	weekday[4]=sw("txtThu")
	weekday[5]=sw("txtFri")
	weekday[6]=sw("txtSat")
	var tmp_time;
	if (clock_timeout) {
		clearTimeout(clock_timeout);
	}
	rgw_time.setTime(rgw_time.getTime() + 1000);
	if( mydaylight == "true") {
	var z;
	z = rgw_time.getTime();
	if( mydayadd ) {
		z -= router_tz_daylight_offset * 1000;
	}
	ttt.setTime(z);
	if( router_in_dst_now(ttt) ) {
		z = router_tz_daylight_offset * 1000;
		ttt.setTime( ttt.getTime() + z);					
	}else {
		// pass				
	}
	//document.getElementById("display_time").innerHTML = ttt.toLocaleString();
	var ttt_str=new String("");
	ttt_str+=ttt.getFullYear();
	if(LangCode == "EN")
	{
		ttt_str+="/";
		ttt_str+=ttt.getMonth()+1;
		ttt_str+="/";
		tmp_time=ttt.getDate()+"";
		if(tmp_time.length < 2)
			tmp_time = "0"+tmp_time;
		ttt_str+=tmp_time;		
	}
	else
	{

		ttt_str+=sw("txtYear");
		ttt_str+=ttt.getMonth()+1;
		ttt_str+="Month";
		ttt_str+=ttt.getDate();
		ttt_str+=sw("txtDay");
		ttt_str+=" ";
		ttt_str+=weekday[ttt.getDay()];
	}
		ttt_str+=" ";
		tmp_time=ttt.getHours()+"";
		if(tmp_time.length < 2)
			tmp_time = "0"+tmp_time;
		ttt_str+=tmp_time;
		ttt_str+=":";
		tmp_time=ttt.getMinutes()+"";
		if(tmp_time.length < 2)
			tmp_time = "0"+tmp_time;
		ttt_str+=tmp_time;
		ttt_str+=":";
		tmp_time=ttt.getSeconds()+"";
		if(tmp_time.length < 2)
			tmp_time = "0"+tmp_time;
		ttt_str+=tmp_time;

		document.getElementById("display_time").innerHTML = ttt_str;
	}else {
	//document.getElementById("display_time").innerHTML = rgw_time.toLocaleString();
	var rgw_time_str=new String("");
	rgw_time_str+=rgw_time.getFullYear();
	if(LangCode == "EN")
	{
		rgw_time_str+="/";
		rgw_time_str+=rgw_time.getMonth()+1;
		rgw_time_str+="/";
		tmp_time=rgw_time.getDate()+"";
		if(tmp_time.length < 2)
			tmp_time = "0"+tmp_time;
		rgw_time_str+=tmp_time;					
	}
	else
	{
		rgw_time_str+=sw("txtYear");
		rgw_time_str+=rgw_time.getMonth()+1;
		rgw_time_str+=sw("txtMonth");
		rgw_time_str+=rgw_time.getDate();
		rgw_time_str+=sw("txtDay");
		rgw_time_str+=" ";
		rgw_time_str+=weekday[rgw_time.getDay()];
	}
		rgw_time_str+=" ";
		tmp_time=rgw_time.getHours()+"";
		if(tmp_time.length < 2)
			tmp_time = "0"+tmp_time;
		rgw_time_str+=tmp_time;
		rgw_time_str+=":";
		tmp_time=rgw_time.getMinutes()+"";
		if(tmp_time.length < 2)
			tmp_time = "0"+tmp_time;
		rgw_time_str+=tmp_time;
		rgw_time_str+=":";
		tmp_time=rgw_time.getSeconds()+"";
		if(tmp_time.length < 2)
			tmp_time = "0"+tmp_time;
		rgw_time_str+=tmp_time;
		document.getElementById("display_time").innerHTML = rgw_time_str;
	}
	clock_timeout = window.setTimeout("update_wall_clock()", 1000);
}
function get_manual_date()
{
	var hour = parseInt(mf.manual_hour_select.value, 10);

	var d = new Date();
	d.setYear(mf.manual_year_select.value);
	d.setMonth(mf.manual_month_select.value);
	d.setDate(mf.manual_day_select.value);
	d.setHours(hour);
	d.setMinutes(mf.manual_min_select.value);
	d.setSeconds(mf.manual_sec_select.value);
	return d;
}
function extract_time(date)
{
	var year = date.getYear();
	if (year < 1900) {
		year += 1900;
	}

	mf.manual_year_select.value = year;
	mf.manual_month_select.value = date.getMonth();
	mf.manual_day_select.value = date.getDate();
	mf.manual_hour_select.value = date.getHours();
	mf.manual_min_select.value = date.getMinutes();
	mf.manual_sec_select.value = date.getSeconds();
}
function compute_date(year, month, week, day, hour, min)
{
	var tentative_d = new Date(year, month, 1, hour - 1, min + 59, 59);
	var exact_date = tentative_d.getDate() - tentative_d.getDay() + day;
	exact_date += (week - 1) * 7;
	return new Date(year, month, exact_date, hour - 1, min + 59, 59);
}

var dst_start_month;
var dst_start_date;
var dst_end_month;
var dst_end_date;
function compute_dst_toggle_times()
{
	var year = parseInt(mf.manual_year_select.value, 10);
	if ((year % 4 === 0 && year % 100 != 0) || year % 400 === 0) {
	days_in_month[1] = 29;
	}
	var start_month = parseInt(mf.tz_daylight_start_month.value, 10);
	var start_week  = parseInt(mf.tz_daylight_start_week.value, 10);
	var start_day   = parseInt(mf.tz_daylight_start_day.value, 10);
	var start_hour  = parseInt(mf.tz_daylight_start_time.value, 10);
	dst_start_d     = compute_date(year, start_month, start_week, start_day, start_hour, 0);
	dst_start_month = dst_start_d.getMonth();
	dst_start_date = dst_start_d.getDate();
	/* Calculate the DST end time as specified by the user. */
	var end_month = parseInt(mf.tz_daylight_end_month.value, 10);
	var end_week  = parseInt(mf.tz_daylight_end_week.value, 10);
	var end_day   = parseInt(mf.tz_daylight_end_day.value, 10);
	var end_hour  = parseInt(mf.tz_daylight_end_time.value, 10);
	dst_end_d     = compute_date(year, end_month, end_week, end_day, end_hour, 0);
	dst_end_month = dst_end_d.getMonth();
	dst_end_date = dst_end_d.getDate();
	
	mf["dst_start_mon"].value = dst_start_month+1;
 	mf["dst_start_date"].value = dst_start_date;
 	mf["dst_end_mon"].value = dst_end_month+1;
 	mf["dst_end_date"].value= dst_end_date;
}

function in_dst_now(date)
{
	var localtime = date.getTime();
	if (dst_start_d.getTime() <= dst_end_d.getTime()) {
		return localtime >= dst_start_d.getTime() && localtime <= dst_end_d.getTime();
	} else {
		return !(localtime < dst_start_d.getTime() && localtime > dst_end_d.getTime());
	}
}

var tz_offTime;
function calcu_tzOffTime()
{	
	var tz = new Array();
	tz = mf.tz_timezone.value.split(" ");
	if(tz[0] == 3 && tz[1] == 1)
		tz_offTime = tz[0]*10+5;
	else if(tz[0] == 4 && tz[1] == 3)
		tz_offTime = tz[0]*10+5;
	else if(tz[0] == -3 && tz[1] == 4)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -4 && tz[1] == 3)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -5 && tz[1] == 3)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -5 && tz[1] == 2)
		tz_offTime = tz[0]*10-7.5;
	else if(tz[0] == -6 && tz[1] == 2)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -9 && tz[1] == 4)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -9 && tz[1] == 5)
		tz_offTime = tz[0]*10-5;
	else
		tz_offTime = tz[0]*10;

	if(tz[0] == -5 && tz[1] == 2)
	{
		tz_offTime = -360*tz_offTime;
	}
	else
	{
		tz_offTime = -360*parseInt(tz_offTime, 10);
	}			
}
/**	The RGW maintains an internal time reference by storing three values,
*	the UTC (or 'epoch time') in seconds, the timezone (UTC offset in seconds)
*	which refers to a geographic time zone, and a daylight savings offset
*	which is used to adjust the timezone. note that PCs usually incorporate
*	the daylight savings offset into the timezone, for instance you have
*	PST and PDT used at different times of the year on the US pacific coast.
* 	all this information needs to be plugged into the date object, but the
*	date object does not allow the current timezone to be set (only gotten).
*	thus, we'll adjust the UTC time to compensate for any differences between
*	the date object's timezone and the server's timezone+offset.
*/
function get_rgw_time() {
	if (rgw_time) {
		return;
	}
	rgw_time = new Date();
	
	calcu_tzOffTime();
		
	var epoch_seconds = parseInt(<% getInfo("currTimeSec");%>, 10);
	
	if (mf.tz_enable_ntp.value == "true")
	{
		epoch_seconds += parseInt(tz_offTime, 10);
		rgw_time.setTime(epoch_seconds * 1000);
	}
	
	epoch_seconds += rgw_time.getTimezoneOffset() * 60;
	rgw_time.setTime(epoch_seconds * 1000);
	
	
	if (mf.tz_enable_ntp.value == "true" && mf.tz_daylight.value == "true") {
		extract_time(rgw_time);		/* Needed to update the current year. */
		compute_dst_toggle_times();
		if (in_dst_now(rgw_time)) {
			epoch_seconds += parseInt(mf.tz_daylight_offset.value, 10);
			mydayadd = 1;
		}
	}
	
	rgw_time.setTime(epoch_seconds * 1000);
	extract_time(rgw_time);
}
function copy_computer_time()
{
	var date = new Date();
	var year_length=mf.manual_year_select.length;
	var i,isValid=0;
	var current_pc_year=date.getFullYear();

	for(i=0;i<year_length;i++){
		if(	mf.manual_year_select.options[i].value ==current_pc_year){
			isValid=1;
			break;
		}
	}
	if(isValid==1)
		mf.manual_year_select.selectedIndex=i;
	else{
		alert(sw("txtInvalidDateOrTime"));
		return false;
	}	
	//mf.manual_year_select.value = date.getFullYear();
	mf.manual_month_select.selectedIndex = date.getMonth();
	mf.manual_day_select.selectedIndex = date.getDate() - 1;
	mf.manual_hour_select.selectedIndex = date.getHours();
	mf.manual_min_select.selectedIndex = date.getMinutes();
	mf.manual_sec_select.selectedIndex = date.getSeconds();
	if(confirm(sw("txtUpdateNow") + "?"))
		page_submit();
}
/*
 * is_date_valid()
 *	Validate date by setting a Date object with the function's arguments,
 *	get the date and time from this Date object and compare with the
 *	function's arguments to tell if the date is valid or not.
 */
function is_date_valid(day,month,year,hour,min,sec)
{

	var test = new Date(year, month, day, hour, min, sec);
	var tempyear = test.getYear();
	if (tempyear < 1900) {
		tempyear += 1900;
	}
	if (tempyear == year &&
			month == test.getMonth() &&
			day == test.getDate() &&
			hour == test.getHours() &&
			min == test.getMinutes() &&
			sec == test.getSeconds()) {
		return true;
	}
	return false;
}
function save_manual_time()
{
	if (mf.tz_enable_ntp_select.checked) {
		alert(sw("txtToolsTimeStr1"));
		return 0;
	}
	if (!is_date_valid(mf.manual_day_select.value, mf.manual_month_select.value, mf.manual_year_select.value, mf.manual_hour_select.value, mf.manual_min_select.value, mf.manual_sec_select.value)) {
		alert(sw("txtInvalidDateOrTime"));
		return 0;
	}
	if (mf.tz_daylight_select.checked) {
		if (mf.tz_daylight_start_month.value == mf.tz_daylight_end_month.value) {
		}
		compute_dst_toggle_times();
	}
	var d = get_manual_date();
	rgw_time = d;
	var utc_time = Math.floor(d.getTime() / 1000);
	utc_time -= d.getTimezoneOffset() * 60;
	calcu_tzOffTime();
	
	//utc_time -= parseInt(mf.tz_timezone.value, 10);
	utc_time -= parseInt(tz_offTime, 10);
	if (mf.tz_daylight_select.checked) {
		if (in_dst_now(rgw_time)) {
			utc_time -= parseInt(mf.tz_daylight_offset.value, 10);
		}
	}
	mf.tz_time.value = utc_time;
}
function refresh()
{
	top.location = "Time.asp";
}
function page_load()
{
	displayOnloadPage("<%getInfo("ok_msg")%>");
	mf = document.forms.mainform;
	if ("" !== "") {
		hide_all_ssi_tr();
		update_wall_clock();
		return;
	}
	
	document.getElementById("select_timezone").selectedIndex = document.getElementById("tz_timezone_index").value;

	if(LangCode=="SC")
		daylightOffset = ntp_zone_array_sc[document.getElementById("select_timezone").selectedIndex].daylightOffset;
	else if(LangCode=="TW")
		daylightOffset = ntp_zone_array_tw[document.getElementById("select_timezone").selectedIndex].daylightOffset;
	else
		daylightOffset = ntp_zone_array[document.getElementById("select_timezone").selectedIndex].daylightOffset;

	tz_daylight_selector(mf.tz_daylight.value == "true");
	
	tz_daylight_on_off(daylightOffset-7200 != 0);
	
	tz_daylight_offset_selector(mf.tz_daylight_offset.value);
	
	if(LangCode=="SC")
		daylightStartEndDate= ntp_zone_array_sc[document.getElementById("select_timezone").selectedIndex].daylightStartEndDate;
	else if(LangCode=="TW")
		daylightStartEndDate= ntp_zone_array_tw[document.getElementById("select_timezone").selectedIndex].daylightStartEndDate;
	else
		daylightStartEndDate= ntp_zone_array[document.getElementById("select_timezone").selectedIndex].daylightStartEndDate;
		
	tz_daylight_start_end_date_get(daylightStartEndDate);

	tz_daylight_start_month_selector(mf.tz_daylight_start_month.value);
	tz_daylight_start_week_selector(mf.tz_daylight_start_week.value);
	tz_daylight_start_day_selector(mf.tz_daylight_start_day.value);
	tz_daylight_start_time_selector(mf.tz_daylight_start_time.value);
	tz_daylight_end_month_selector(mf.tz_daylight_end_month.value);
	tz_daylight_end_week_selector(mf.tz_daylight_end_week.value);
	tz_daylight_end_day_selector(mf.tz_daylight_end_day.value);
	tz_daylight_end_time_selector(mf.tz_daylight_end_time.value);
	tz_enable_ntp_selector(mf.tz_enable_ntp.value == "true");
	tz_ntp_addr_selector(mf.tz_ntp_addr.value);
	get_rgw_time();
	if( mydaylight == "true") {
		// record pre-load  value
		router_dst_start_d.setTime( dst_start_d.getTime() + 1000);
		router_dst_end_d.setTime( dst_end_d.getTime() + 1000);
		router_tz_daylight_offset = mf.tz_daylight_offset.value;							
	}
	update_wall_clock();
	var tz_timezone_handle = document.getElementById("select_timezone");
		if (typeof(tz_timezone_handle.addEventListener) != "undefined") {
			tz_timezone_handle.addEventListener("change", tz_timezone_selector, false);
		} else if (typeof(tz_timezone_handle.attachEvent) != "undefined") {
			tz_timezone_handle.attachEvent("onchange", tz_timezone_selector);
		} else {
			tz_timezone_handle.onchange = tz_timezone_selector;
		}
		
		
		

		calcu_tzOffTime();

		tz_daylight_previous_zone = tz_offTime;
	
		set_form_default_values("mainform");
		var verify_failed = "<%getInfo("err_msg")%>";
		if (verify_failed !== "") {
			set_form_always_modified("mainform");
			alert(verify_failed);
			verify_failed = "";
		}
	if(!mf.manual_year_select.value) {
		mf.manual_year_select.value = 2009;
		mf.manual_month_select.value = 8;
		mf.manual_min_select.value = 9;
		mf.manual_sec_select.value = 9;
		mf.manual_hour_select.value = 9;
		mf.manual_day_select.value = 9;
	}
}
function page_submit()
{
	get_by_id("sync_msg").innerHTML = "";
	if (!is_form_modified("mainform"))  //nothing changed
	{
		if (!confirm(sw("txtSaveAnyway"))) 				
			return false;
	}
	else
	{
		if(!mf.tz_enable_ntp_select.checked) {
			if(save_manual_time()==0)
				return false;
		}
		else {
			if (mf.tz_daylight_select.checked) {
				compute_dst_toggle_times();
			}
		}
		
		if (mf.tz_daylight_select.checked) {
			// check same value issue
			if( (mf.tz_daylight_start_month_select.value == mf.tz_daylight_end_month_select.value) &&
			    (mf.tz_daylight_start_week_select.value  == mf.tz_daylight_end_week_select.value) &&
			    (mf.tz_daylight_start_day_select.value   == mf.tz_daylight_end_day_select.value) &&
			    (mf.tz_daylight_start_time_select.value  == mf.tz_daylight_end_time_select.value) ) {
				alert(sw("txtInvalidDateOrTime"));
				return false;
			}
		}			
		if (!validate_ntp_server()) {
				return false;
		}
		mf.form_submitted.value = "1";
		mf["settingsChanged"].value = 1;
	}
	mf.submit();
}

function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtTime");
	document.title = DOC_Title;	
	get_by_id("RestartNow").value = sw("txtRebootNow");
	get_by_id("RestartLater").value = sw("txtRebootLater");
	get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
	get_by_id("SaveSettings").value = sw("txtSaveSettings");
	get_by_id("manual_sync").value = sw("txtCopyComputerTimeSettings");
	get_by_id("ntp_syn").value = sw("txtUpdateNow");
	get_by_id("Save_1").value = sw("txtSaveSettings");
	get_by_id("Clear_1").value = sw("txtDontSaveSettings");
}

function on_click_manual_sync()
{
		get_by_id("sync_msg").innerHTML = sw("txtSyn");
		setTimeout('page_submit()',2000);

}

//]]>
</script>
</head>
<body onload="init();template_load();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside"><table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr><td><SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr><td id="sidenav_container"><div id="sidenav">
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
<SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none"><div class="section" ><div class="section_head"><h2>
<SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content"></div></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
<form id="mainform" name="mainform" action="/goform/formSetNTP" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>	
<input type="hidden" id="dst_start_mon" name="dst_start_mon" value="">
<input type="hidden" id="dst_start_date" name="dst_start_date" value="">
<input type="hidden" id="dst_end_mon" name="dst_end_mon" value="">
<input type="hidden" id="dst_end_date" name="dst_end_date" value="">
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtTime");</SCRIPT></h2>
<p><SCRIPT >ddw("txtToolsTimeStr2");</SCRIPT></p>
<input class="button_submit" type="button" id="SaveSettings" name="SaveSettings" value="" onclick="page_submit()"/>
<input class="button_submit" type="button" id="DontSaveSettings" name="DontSaveSettings" value="" onclick="location.reload(true)"/>
</div>
<div class="box"><h3><SCRIPT >ddw("txtTimeConfiguration");</SCRIPT></h3>
<fieldset><p>	<input type="hidden" name="form_submitted" value="0"/>
<label class="duple"><SCRIPT >ddw("txtCurrentRouterTime");</SCRIPT>
&nbsp;:</label><span id="display_time" class="output">&nbsp;</span></p>
<input type="hidden" name="config.tz_timezone_index" id="tz_timezone_index" value="<%getInfo("ntpTimeZoneIdx");%>" />
<input type="hidden" name="config.tz_timezone" id="tz_timezone" value="<% getInfo("ntpTimeZone"); %>" />
</fieldset>
<SCRIPT>
	if(LangCode=="SC" || LangCode=="TW")
	{
		document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
	}
	else
	{
		document.write('<fieldset>');
	}
</SCRIPT>	
		<label class="duple" id="label_select_timezone"><SCRIPT >ddw("txtTimeZone");</SCRIPT>&nbsp;:</label>
<select id="select_timezone" name="select_timezone">
<SCRIPT>
	if(LangCode=="SC")
	{
       	for(var i=0;i<ntp_zone_array_sc.length;i++){
		document.write('<option value="',ntp_zone_array_sc[i].value,'">',ntp_zone_array_sc[i].name,'</option>');}
	}
	else if(LangCode=="TW")
	{
       	for(var i=0;i<ntp_zone_array_tw.length;i++){
		document.write('<option value="',ntp_zone_array_tw[i].value,'">',ntp_zone_array_tw[i].name,'</option>');}
	}
	else
	{
       	for(var i=0;i<ntp_zone_array.length;i++){
		document.write('<option value="',ntp_zone_array[i].value,'">',ntp_zone_array[i].name,'</option>');}
	}
</SCRIPT>
</select>
<script type="text/javascript">
//<![CDATA[
function tzselect_selector()
{
	var tz_sel = document.getElementById("select_timezone");
	document.getElementById("tz_timezone_index").value = tz_sel.selectedIndex;
	document.getElementById("tz_timezone").value = tz_sel.value;
}
add_onload_listener(timezone_init);
function timezone_init()
{
var tzselect = document.getElementById("select_timezone");
var tzform = tzselect.form;
//setSelectedIndex(tzselect, "<% getInfo("ntpTimeZone"); %>");
tzselect.selectedIndex = tzform.tz_timezone_index.value;
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
if(lang!=4)
	{
	document.write('</fieldset>');
	}
</script>
<fieldset><p>
<input type="hidden" id="tz_daylight" name="config.tz_daylight" value="<% getInfo("ntpdst"); %>"/>
<label class="duple">
<SCRIPT >ddw("txtEnableDaylightSaving");</SCRIPT>
&nbsp;:</label>
<input type="checkbox" id="tz_daylight_select" onclick="tz_daylight_selector(this.checked);"/>
<input type="button" id="manual_sync" value="" onclick="copy_computer_time();"/>
</p>
</div>

<p style="display: none">
<input type="hidden" id="tz_daylight_offset" name="config.tz_daylight_offset" value="<% getIndexInfo("dlend_offset"); %>"/>
<label class="duple">
<SCRIPT >ddw("txtDaylightSavingOffset");</SCRIPT>
&nbsp;:</label>
<select id="tz_daylight_offset_select" onchange="tz_daylight_offset_selector(this.value);">
<option value="-7200">-2:00</option>
<option value="-5400">-1:30</option>
<option value="-3600">-1:00</option>
<option value="-1800">-0:30</option>
<option value="1800">+0:30</option>
<option value="3600">+1:00</option>
<option value="5400">+1:30</option>
<option value="7200">+2:00</option>
</select></p>



<div style="display: none">
<p><!-- This empty paragraph is required --></p>
<label class="duple">
<SCRIPT >ddw("txtDaylightSavingDates");</SCRIPT>
&nbsp;:</label>
<table id="tools_daylight" cellspacing="2" cellpadding="2" border="0" summary="">
<tr><td></td><td><SCRIPT >ddw("txtMonth");</SCRIPT></td>
<td><SCRIPT >ddw("txtWeek");</SCRIPT></td>
<td><SCRIPT >ddw("txtDayOfWeek");</SCRIPT></td>
<td><SCRIPT >ddw("txtTime");</SCRIPT></td>
</tr><tr><td><SCRIPT >ddw("txtDSTStart");</SCRIPT>
&nbsp;</td><td>
<input type="hidden" id="tz_daylight_start_month" name="config.tz_daylight_start_month" value="<%getIndexInfo("dlstart_month");%>"/>
<select id="tz_daylight_start_month_select" onchange="tz_daylight_start_month_selector(this.value);">
<script> 
 var i;
 if(LangCode=="SC")
 {
     for(i=0;i<month_array_sc.length;i++){
				document.write('<option value="',month_array_sc[i].value,'">',month_array_sc[i].name,'</option>');
      }
 }else if(LangCode=="TW")
 {
     for(i=0;i<month_array_tw.length;i++){
				document.write('<option value="',month_array_tw[i].value,'">',month_array_tw[i].name,'</option>');
      }
 }
 else
 {
     for(i=0;i<month_array.length;i++){
				document.write('<option value="',month_array[i].value,'">',month_array[i].name,'</option>');
      }
 	
	}
 </script>
</select></td><td>
<input type="hidden" id="tz_daylight_start_week" name="config.tz_daylight_start_week" value="<%getIndexInfo("dlstart_week");%>"/>
<select id="tz_daylight_start_week_select" onchange="tz_daylight_start_week_selector(this.value);">
<option value="1"><SCRIPT >ddw("txt1st");</SCRIPT></option>
<option value="2"><SCRIPT >ddw("txt2nd");</SCRIPT></option>
<option value="3"><SCRIPT >ddw("txt3rd");</SCRIPT></option>
<option value="4"><SCRIPT >ddw("txt4th");</SCRIPT></option>
<option value="5"><SCRIPT >ddw("txt5th");</SCRIPT></option>
<option value="6"><SCRIPT >ddw("txt6th");</SCRIPT></option>
</select></td>
<td><input type="hidden" id="tz_daylight_start_day" name="config.tz_daylight_start_day" value="<%getIndexInfo("dlstart_day");%>"/>
<select id="tz_daylight_start_day_select" onchange="tz_daylight_start_day_selector(this.value);">
<option value="0"><SCRIPT >ddw("txtSun");</SCRIPT></option>
<option value="1"><SCRIPT >ddw("txtMon");</SCRIPT></option>
<option value="2"><SCRIPT >ddw("txtTue");</SCRIPT></option>
<option value="3"><SCRIPT >ddw("txtWed");</SCRIPT></option>
<option value="4"><SCRIPT >ddw("txtThu");</SCRIPT></option>
<option value="5"><SCRIPT >ddw("txtFri");</SCRIPT></option>
<option value="6"><SCRIPT >ddw("txtSat");</SCRIPT></option>
</select></td>
<td><input type="hidden" id="tz_daylight_start_time" name="config.tz_daylight_start_time" value="<%getIndexInfo("dlstart_hour");%>"/>
<select id="tz_daylight_start_time_select" onchange="tz_daylight_start_time_selector(this.value);">
<option value="0">00 am</option><option value="1">1 am</option>
<option value="2">2 am</option><option value="3">3 am</option>
<option value="4">4 am</option><option value="5">5 am</option>
<option value="6">6 am</option><option value="7">7 am</option>
<option value="8">8 am</option><option value="9">9 am</option>
<option value="10">10 am</option><option value="11">11 am</option>
<option value="12">12 pm</option><option value="13">1pm</option>
<option value="14">2 pm</option><option value="15">3 pm</option>
<option value="16">4 pm</option><option value="17">5 pm</option>
<option value="18">6 pm</option><option value="19">7 pm</option>
<option value="20">8 pm</option><option value="21">9 pm</option>
<option value="22">10 pm</option><option value="23">11 pm</option>
</select></td></tr>
<tr><td><SCRIPT >ddw("txtDSTEnd");</SCRIPT>
&nbsp;</td><td><input type="hidden" id="tz_daylight_end_month" name="config.tz_daylight_end_month" value="<%getIndexInfo("dlend_month");%>"/>
<select id="tz_daylight_end_month_select" onchange="tz_daylight_end_month_selector(this.value);">
<script> 
 var i;
 if(LangCode=="SC")
 {
 	
 	for(i=0;i<month_array_sc.length;i++){
		document.write('<option value="',month_array_sc[i].value,'">',month_array_sc[i].name,'</option>');
      }
} else if(LangCode=="TW")
 {
 	
 	for(i=0;i<month_array_tw.length;i++){
		document.write('<option value="',month_array_tw[i].value,'">',month_array_tw[i].name,'</option>');
      }
}
else
{
     for(i=0;i<month_array.length;i++){
		document.write('<option value="',month_array[i].value,'">',month_array[i].name,'</option>');
      }
 }
 </script>
</select>
</td><td>
<input type="hidden" id="tz_daylight_end_week" name="config.tz_daylight_end_week" value="<%getIndexInfo("dlend_week");%>"/>
<select id="tz_daylight_end_week_select" onchange="tz_daylight_end_week_selector(this.value);">
<option value="1"><SCRIPT >ddw("txt1st");</SCRIPT></option>
<option value="2"><SCRIPT >ddw("txt2nd");</SCRIPT></option>
<option value="3"><SCRIPT >ddw("txt3rd");</SCRIPT></option>
<option value="4"><SCRIPT >ddw("txt4th");</SCRIPT></option>
<option value="5"><SCRIPT >ddw("txt5th");</SCRIPT></option>
<option value="6"><SCRIPT >ddw("txt6th");</SCRIPT></option>
</select></td>
<td><input type="hidden" id="tz_daylight_end_day" name="config.tz_daylight_end_day" value="<%getIndexInfo("dlend_day");%>"/>
<select id="tz_daylight_end_day_select" onchange="tz_daylight_end_day_selector(this.value);">
<option value="0"><SCRIPT >ddw("txtSun");</SCRIPT></option>
<option value="1"><SCRIPT >ddw("txtMon");</SCRIPT></option>
<option value="2"><SCRIPT >ddw("txtTue");</SCRIPT></option>
<option value="3"><SCRIPT >ddw("txtWed");</SCRIPT></option>
<option value="4"><SCRIPT >ddw("txtThu");</SCRIPT></option>
<option value="5"><SCRIPT >ddw("txtFri");</SCRIPT></option>
<option value="6"><SCRIPT >ddw("txtSat");</SCRIPT></option>
</select></td>
<td><input type="hidden" id="tz_daylight_end_time" name="config.tz_daylight_end_time" value="<%getIndexInfo("dlend_hour");%>"/>
<select id="tz_daylight_end_time_select" onchange="tz_daylight_end_time_selector(this.value);">
<option value="0">12 am</option><option value="1">1 am</option>
<option value="2">2 am</option><option value="3">3 am</option>
<option value="4">4 am</option><option value="5">5 am</option>
<option value="6">6 am</option><option value="7">7 am</option>
<option value="8">8 am</option><option value="9">9 am</option>
<option value="10">10 am</option><option value="11">11 am</option>
<option value="12">12 pm</option><option value="13">1pm</option>
<option value="14">2 pm</option><option value="15">3 pm</option>
<option value="16">4 pm</option><option value="17">5 pm</option>
<option value="18">6 pm</option><option value="19">7 pm</option>
<option value="20">8 pm</option><option value="21">9 pm</option>
<option value="22">10 pm</option><option value="23">11 pm</option>
</select></td></tr></table>



<p><!-- This empty paragraph is required --></p></fieldset>
</div>
<div class="box">
<h3><SCRIPT >ddw("txtAutomaticTimeConfiguration");</SCRIPT></h3>
<p class="box_msg"></p>
<p>
<input type="hidden" id="tz_enable_ntp" name="config.tz_enable_ntp" value="<%getInfo("ntpenabled");%>"/>
<input type="checkbox" id="tz_enable_ntp_select" onclick="tz_enable_ntp_selector(this.checked);"/>
<label class="duple">
<b><SCRIPT >ddw("txtEnableNTPServer");</SCRIPT>&nbsp;</b>
</label>
</p>
<p><label class="duple" for="tz_ntp">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><SCRIPT >ddw("txtNTPServerUsed");</SCRIPT>&nbsp;:</b></label>
<input type="hidden" id="tz_ntp_addr" name="config.tz_ntp_addr" value="<%getInfo("ntpServerIp1");%>"/>
<select id="tz_ntp_addr_select" onchange="tz_ntp_addr_selector(this.value);">
<option value="0"><SCRIPT >ddw("txtSelectNTPServer");</SCRIPT>
</option>
<option value="ntp1.dlink.com">ntp1.dlink.com</option>
<option value="ntp.dlink.com.tw">ntp.dlink.com.tw</option>
</select>
<input type="button" id="ntp_syn" value="" onclick="on_click_manual_sync();">
</p>
<div id="sync_msg"><br>
</div>
</div>

<div class="box"><h3><SCRIPT >ddw("txtSettheDateandTimeManually");</SCRIPT></h3>
<p class="box_msg"></p><p><!-- This empty paragraph is required --></p>
<input type="hidden" id="tz_time" name="config.tz_time" value="1075574058"/>
<table id="tools_time_set" width="525" border=0 cellpadding=2 cellspacing=0>
	
<tr><td><SCRIPT >ddw("txtYear");</SCRIPT></td>
<td><select id="manual_year_select" name="year" style="WIDTH: 60px">
<option value="2004">2004</option><option value="2005">2005</option>
<option value="2006">2006</option><option value="2007">2007</option>
<option value="2008">2008</option><option value="2009">2009</option>
<option value="2010">2010</option><option value="2011">2011</option>
<option value="2012">2012</option><option value="2013">2013</option>
<option value="2014">2014</option><option value="2015">2015</option>
<option value="2016">2016</option><option value="2017">2017</option>
<option value="2018">2018</option><option value="2019">2019</option>
</select></td>
<td><SCRIPT >ddw("txtMonth");</SCRIPT></td>
<td><select id="manual_month_select" name="mon">
<script> 
 var i;
if(LangCode=="SC")
 {
     for(i=0;i<month_array_sc.length;i++){
				document.write('<option value="',month_array_sc[i].value,'">',month_array_sc[i].name,'</option>');
      }
 }else if(LangCode=="TW")
 {
     for(i=0;i<month_array_tw.length;i++){
				document.write('<option value="',month_array_tw[i].value,'">',month_array_tw[i].name,'</option>');
      }
 }
 else
 {
     for(i=0;i<month_array.length;i++){
				document.write('<option value="',month_array[i].value,'">',month_array[i].name,'</option>');
      }
 	
	}
 </script>
</select>
</td><td><SCRIPT >ddw("txtDay");</SCRIPT></td>
<td><select id="manual_day_select" name="day">
<script> 
 		var i;
            	for(i=0;i<day_array.length;i++){
			document.write('<option value="',day_array[i].value,'">',day_array[i].name,'</option>');
            	}
 </script></select></td></tr>
<tr>	<td><SCRIPT >ddw("txtHour");</SCRIPT></td>
<td><select id="manual_hour_select" name="hour">
<script> 
	var i;
       	for(i=0;i<hour_array.length;i++){
		document.write('<option value="',hour_array[i].value,'">',hour_array[i].name,'</option>');
       	}
 </script></select></td>
 <td><SCRIPT >ddw("txtMinute");</SCRIPT></td>
<td><select id="manual_min_select" name="min">
<script> 
 var i;
 for(i=0;i<min_array.length;i++){
		document.write('<option value="',min_array[i].value,'">',min_array[i].name,'</option>');
        }
 </script></select>	</td>
<td><SCRIPT >ddw("txtSecond2");</SCRIPT></td>
<td><select id="manual_sec_select" name="sec">
<script> 
 	var i;
       for(i=0;i<sec_array.length;i++){
					document.write('<option value="',sec_array[i].value,'">',sec_array[i].name,'</option>');
        }
</script></select>	</td>

</tr></table>
</div>
</form>
<div>
	<br>&nbsp;
	<input class="button_submit" type="button" id="Save_1" value="" onclick="page_submit()" />
	<input class="button_submit" type="button" id="Clear_1" value="" onclick="location.reload(true)" />
	<br><br>
</div>


</div></td>
<td id="sidehelp_container">
<div id="help_text"> 
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtToolsTimeStr3");</SCRIPT></p>
<p class="more"><!-- Link to more help --><a href="../Help/Basic.asp#Time" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>										</p>
</div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
</html>
