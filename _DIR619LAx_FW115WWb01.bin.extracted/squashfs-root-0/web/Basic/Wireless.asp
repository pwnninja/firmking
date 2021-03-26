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
 fieldset label.duple {
	width: 200px;
 }
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

var __AjaxAsk = null;

function __createRequest()
{
	var request = null;
	try { request = new XMLHttpRequest(); }
	catch (trymicrosoft)
	{
		try { request = new ActiveXObject("Msxml2.XMLHTTP"); }
		catch (othermicrosoft)
 		{
 			try { request = new ActiveXObject("Microsoft.XMLHTTP"); }
			catch (failed)
			{
				request = null;
			}
		}
	}
	if (request == null) alert("Error creating request object !");
	return request;
}
var timeleft = 1
function waittime()
{
	//setTimeodut(get_by_id("final_form").submit(), 3000);
	if(timeleft == 0){
		get_by_id("final_form").submit();
		return;
	}
	timeleft--;
	setTimeout(waittime, 1000);
}
function doCheckSubmit()
{
	var f_wps =get_by_id("formWPS");
	var f =get_by_id("formWlan");
        if(get_by_id("wifisc_enable_select").checked == true){//aphidden
               if(f.aphidden.checked == true){
                       get_by_id("formWPS").settingsChanged.value = 1;
                       if (!confirm(sw("wps_aphidden"))) {
                               return false;
                       }
                        wifisc_enable_selector(false);//config.wifisc.enabled
               }

               if(f.security_type.value=="1"){
                       get_by_id("formWPS").settingsChanged.value = 1;
                       if (!confirm(sw("wps_wepmode"))) {
                               return false;
                       }
                        wifisc_enable_selector(false);//config.wifisc.enabled
               }

               if((f.cipher_type.value == 1) && (f.security_type.value>="2")){
                       get_by_id("formWPS").settingsChanged.value = 1;
                       if(!confirm(sw("wps_wapmode"))) {
                               return false;
                       }
                        wifisc_enable_selector(false);//config.wifisc.enabled
               }
                if(f.security_type.value=="2"){
                        get_by_id("formWPS").settingsChanged.value = 1;
                        if (!confirm(sw("wps_wpamode"))) {
                                return false;
                        }
                        wifisc_enable_selector(false);//config.wifisc.enabled
                }
        }
	var str;
	str = "settingsChanged=" + f_wps["settingsChanged"].value;
	str += "&webpage=" + f_wps["webpage"].value;
	str += "&wps_act=" + f_wps["wps_act"].value;
	str += "&config.wifisc.enabled=" + f_wps["wifisc_enable"].value;
	str += "&config.wifisc.pin=" + f_wps["wifisc_pin"].value;
	str += "&config.wifisc.ap_locked=" + f_wps["wifisc_ap_locked"].value;
	str += "&config.wifisc_pinlock.enabled=" + f_wps["wifisc_pinlock"].value;

	if (__AjaxAsk == null) __AjaxAsk = __createRequest();
        __AjaxAsk.open("POST", "/goform/formWPS", true);
	__AjaxAsk.setRequestHeader('Content-type','application/x-www-form-urlencoded');
	__AjaxAsk.send(str);
	waittime();
}
function no_reboot()
{
	document.forms["rebootdummy"].next_page.value="Basic/Wireless.asp";
	document.forms["rebootdummy"].submit();
}

function get_webserver_ssi_uri() {
			return ("" !== "") ? "/Basic/Setup.asp" : "/Basic/Wireless.asp";
}

var schedule_options = [
	<%virSevSchRuleList();%> 
];	
function do_add_new_schedule()
{
	var time_now=new Date().getTime();
	top.location = "../Tools/Schedules.asp?t="+time_now;
}	
function wan_schedule_name_selector(value)
{
	var f = get_by_id("formWlan");	
	f.poe_sch_name.value=value;
}
function wan_ptp_schedule_name_selector(value)
{
	var f = get_by_id("formWlan");	
	f.ptp_sch_name.value=value;
}
function wan_pl2_schedule_name_selector(value)
{
	var f = get_by_id("formWlan");	
	f.pl2_sch_name.value=value;
}

// ********************************* commjs start *****************************************************
function chk_wepkey(obj_name, key_type, key_len)
{
	var key_obj=get_by_id(obj_name);
	if(key_type==1)	//ascii
	{
		if(strchk_unicode(key_obj.value))
		{
			if(key_len==13)	alert(sw("txtInvalidKeyfor13char")+".");
			else			alert(sw("txtInvalidKeyfor5char"));
			key_obj.select();
			return false;
		}
	}
	else	//hex
	{
		var test_char, i;
		for(i=0; i<key_obj.value.length; i++)
		{
			test_char=key_obj.value.charAt(i);
			if( (test_char >= '0' && test_char <= '9') ||
				(test_char >= 'a' && test_char <= 'f') ||
				(test_char >= 'A' && test_char <= 'F'))
				continue;

			if(key_len==26)	alert(sw("txtInvalidKeyfor26Dec"));
			else			alert(sw("txtInvalidKeyfor10Dec"));
			key_obj.select();
			return false;
		}
	}
	return true;
}

// Get Object by ID.
function get_by_id(name)
{
	if (document.getElementById)	return document.getElementById(name);//.style;
	if (document.all)				return document.all[name].style;
	if (document.layers)			return document.layers[name];
}
// generate the radmon str by date.
function generate_random_str()
{
	var d = new Date();
	var str=d.getFullYear()+"."+(d.getMonth()+1)+"."+d.getDate()+"."+d.getHours()+"."+d.getMinutes()+"."+d.getSeconds();
	return str;
}
// this function is used to check if the inputted string is blank or not.
function is_blank(s)
{
	var i=0;
	for(i=0;i<s.length;i++)
	{
		c=s.charAt(i);
		if((c!=' ')&&(c!='\n')&&(c!='\t'))return false;
	}
	return true;
}

// this function is used to check if the string is blank or zero.
function is_blank_or_zero(s)
{
	if (is_blank(s)==true) return true;
	if (is_digit(s))
	{
		var i = parseInt(s, 10);
		if (i==0) return true;
	}
	return false;
}

// convert hex integer string
function hexstr2int(str)
{
	var i = 0;
	if (is_hexdigit(str)==true) i = parseInt(str, [16]);
	return i;
}

// if min <= value <= max, than return true,
// otherwise return false.
function is_in_range(str_val, min, max)
{
	var d = decstr2int(str_val);
	if ( d > max || d < min ) return false;
	return true;
}

// this function convert second to day/hour/min/sec
function second_to_daytime(str_second)
{
	var result = new Array();
	var t;

	result[0] = result[1] = result[2] = result[3] = 0;

	if (is_digit(str_second)==true)
	{
		t = parseInt(str_second, [10]);
		result[0] = parseInt(t/(60*60*24), [10]);	// day
		result[1] = parseInt(t/(60*60), [10]) % 24; // hr
		result[2] = parseInt(t/60, [10]) % 60;		// min
		result[3] = t % 60;							// sec
	}

	return result;
}

// construct xgi string for doSubmit()
function exe_str(str_shellPath)
{
	var str="";
	myShell = str_shellPath.split(";");
	for(i=0; i<myShell.length; i++)
	{
		if (!is_blank(myShell[i])) str+="&"+"exeshell="+myShell[i];
	}
	return str;
}

// return true is brower is IE.
function is_IE()
{
	if (navigator.userAgent.indexOf("MSIE")>-1) return true;
	return false
}

// make docuement.write shorter
function echo(str)
{
	document.write(str);
}

// same as echo() but replace special characters
function echosc(str)
{
	str=str.replace(/&/g,"&amp;");
	str=str.replace(/</g,"&lt;");
	str=str.replace(/>/g,"&gt;");
	str=str.replace(/"/g,"&quot;");
	str=str.replace(/'/g,"\'");
	str=str.replace(/ /g,"&nbsp;");
	document.write(str);
}

function replace_spec_chars(str)
{
//	alert("before Replace "+str);
	str=str.replace(/&/g,"&amp;");
	str=str.replace(/</g,"&lt;");
	str=str.replace(/>/g,"&gt;");
	str=str.replace(/"/g,"&quot;");
	//str=str.replace(/'/g,"&prime;");
	str=str.replace(/'/g,"&acute;");
	str=str.replace(/ /g,"&nbsp;");
//	alert("after Replace "+str);
	return str;
}


// return false if keybaord event is not decimal number.
function dec_num_only(evt)
{
	if (navigator.appName == 'Netscape')
	{
		if (evt.which == 8) return true;	/* TAB */
		if (evt.which == 0) return true;
		if (evt.which >= 48 && evt.which <= 57) return true;
	}
	else
	{
		if (evt.keyCode == 8) return true;
		if (evt.keyCode == 0) return true;
		if (evt.keyCode >= 48 && evt.keyCode <= 57) return true;
	}
	return false;
}

// return false if keyboard event is not hex number.
function hex_num_only(evt)
{
	if (navigator.appName == 'Netscape')
	{
		if (evt.which == 8) return true;	/* TAB */
		if (evt.which == 0) return true;
		if (evt.which >= 48 && evt.which <= 57) return true;
		if (evt.which > 64 && evt.which < 71) return true;
		if (evt.which > 96 && evt.which < 103) return true;
	}
	else
	{
		if (evt.keyCode == 8) return true;	/* TAB */
		if (evt.keyCode == 0) return true;
		if (evt.keyCode >= 48 && evt.keyCode <= 57) return true;
		if (evt.keyCode > 64 && evt.keyCode < 71) return true;
		if (evt.keyCode > 96 && evt.keyCode < 103) return true;
	}
	return false;
}

// return false if keyboard event is not readable character
function readable_char_only(evt)
{
	if (navigator.appName == 'Netscape')
	{
	if (evt.which == 8) return true;	/* TAB */
	if (evt.which == 0) return true;
	if (evt.which < 33 || evt.which > 126) return false;
	}
	else
	{
	if (evt.keyCode == 8) return true;	/* TAB */
	if (evt.keyCode == 0) return true;
	if (evt.keyCode < 33 || evt.keyCode > 126) return false;
	}
	return true;
}


// make the obj selected, if the value of obj is empty, 'def' will be set as value.
function field_select(obj, def)
{
	if (obj.value == '') obj.value = def;
	obj.select();
}

// make the object be focused, and set the value to 'val'.
function field_focus(obj, val)
{
	if (val != '**') obj.value = val;
	obj.focus();
	obj.select();
}

// make all fields which id is between star_name and end_name as disabled/enabled.
// "dis" will be true or false.
function fields_range_disabled(obj, start_name, end_name, dis)
{
	var i=0;
	for(i=0; i<obj.length; i++)
	{
		if (obj[i].id==start_name)
		{
			while(obj[i].id!=end_name && i<obj.length)
			{
				eval("obj["+i+"].disabled="+dis);
				i++;
			}
			get_by_id(end_name).disabled=dis;
		}
	}
}
// make all fields of the obj disabled/enabled. "dis" will be true or false.
function fields_disabled(obj, dis)
{
	var i=0;
	for(i=0; i<obj.length; i++)
	{
		if (obj[i].name!="never_disabled")
			eval("obj["+i+"].disabled="+dis);
	}
}

// for safari select loop
function select_index(obj, val)
{
	var i=0;
	for(i=0; i<obj.length;i++)
	{
		if(eval("obj["+i+"].value")==val)
		{
			obj.selectedIndex=i;
			break;
		}
	}
}



function createRequest()
{
	var request = null;
	try { request = new XMLHttpRequest(); }
	catch (trymicrosoft)
	{
		try { request = new ActiveXObject("Msxml2.XMLHTTP"); }
		catch (othermicrosoft)
		{
			try { request = new ActiveXObject("Microsoft.XMLHTTP"); }
			catch (failed) { request = null; }
		}
	}
	if (request == null) alert("Error creating request object !");
	return request;
}

// *********************************** commjs end *****************************************************

regDomain ="<%getIndexInfo("country")%>";
var init_wlan_security_select;
function init_show_wlan_security_type()
{
	var mf = document.forms.formWlan;
	var sec_type = get_by_id("security_type");
	var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtWirelessCONN");
		document.title = DOC_Title;	
		
		if(mf.wireless_wepon.value == "true")
		{
			sec_type.value = 1;		
		}
		else if(mf.wireless_wpa_enabled.value == "true")
		{
			if(mf.wireless_wpa_mode.value == 1)
			{
				sec_type.value = 2;
			}
			else if(mf.wireless_wpa_mode.value == 3)
			{
				sec_type.value = 4;
			}
			else
			{
				sec_type.value = 6;
		}
		}
		else
		{
			sec_type.value = 0;
		}
		on_change_security_type(sec_type.value);
}

function init_show_wps_status()
{
	wifisc_pin_retriever = new xmlDataObject(wifisc_pin_ready, null, null, "/wifisc_pin.asp");
	
	wifisc_enable_selector(get_by_id("wifisc_enable").value == "true");	
	wifisc_pinlock_selector(get_by_id("wifisc_pinlock").value == "true");
	
	var wps_status_str="";
	if( get_by_id("wifisc_enable").value == 'true')
		wps_status_str+=sw("txtEnable")+" /";
	else
		wps_status_str+=sw("txtDisabled")+" / ";
	
	if("<%getIndexInfo("wscConfig");%>" == "0")
	{
		disable_form_field(get_by_id("wifisc_reset_unconfig_btn"), true);
		disable_form_field(get_by_id("wifisc_pinlock_select"), true);
		wps_status_str+=sw("txtNotConfigured");
	}
	else
	{
		disable_form_field(get_by_id("wifisc_reset_unconfig_btn"), false);
		//disable_form_field(get_by_id("wifisc_pinlock_select"), false);
		wps_status_str+=sw("txtConfigured");
	}
		
	get_by_id("wps_status").innerHTML = wps_status_str;
	
	get_by_id("wifisc_current_pin").innerHTML = wifisc_current_pin;

	if(get_by_id("wifisc_er_lock_state").value == "true")
		disable_form_field(get_by_id("wifisc_er_unlock_button"), false);
	else
		disable_form_field(get_by_id("wifisc_er_unlock_button"), true);

}
function init_wisp_part(src)
{
	var f = get_by_id("formWlan");
	var oldmac;
	if(f.wisp_wan_ip_mode.value==0){
		 f.wan_type.selectedIndex=0;
		 oldmac = f.s_clonemac.value;
		 f.s_mac1.value=oldmac.substring(0,2);
		f.s_mac2.value=oldmac.substring(3,5);
		f.s_mac3.value=oldmac.substring(6,8);
		f.s_mac4.value=oldmac.substring(9,11);
		f.s_mac5.value=oldmac.substring(12,14);
		f.s_mac6.value=oldmac.substring(15,17);
		 
	}	 
	if(f.wisp_wan_ip_mode.value==1){
		f.wan_type.selectedIndex=1;
		oldmac = f.d_clonemac.value;
		 f.d_mac1.value=oldmac.substring(0,2);
		f.d_mac2.value=oldmac.substring(3,5);
		f.d_mac3.value=oldmac.substring(6,8);
		f.d_mac4.value=oldmac.substring(9,11);
		f.d_mac5.value=oldmac.substring(12,14);
		f.d_mac6.value=oldmac.substring(15,17);
	}	
	if(f.wisp_wan_ip_mode.value==2){
		f.wan_type.selectedIndex=2;
		oldmac = f.p_clonemac.value;
		 f.o_mac1.value=oldmac.substring(0,2);
		f.o_mac2.value=oldmac.substring(3,5);
		f.o_mac3.value=oldmac.substring(6,8);
		f.o_mac4.value=oldmac.substring(9,11);
		f.o_mac5.value=oldmac.substring(12,14);
		f.o_mac6.value=oldmac.substring(15,17);
		
	}	
	if(f.wisp_wan_ip_mode.value==3){//pptp
		f.wan_type.selectedIndex=3;
		oldmac = f.pt_clonemac.value;
		 f.p_mac1.value=oldmac.substring(0,2);
		f.p_mac2.value=oldmac.substring(3,5);
		f.p_mac3.value=oldmac.substring(6,8);
		f.p_mac4.value=oldmac.substring(9,11);
		f.p_mac5.value=oldmac.substring(12,14);
		f.p_mac6.value=oldmac.substring(15,17);
	}	
	if(f.wisp_wan_ip_mode.value==4){
		f.wan_type.selectedIndex=4;
		oldmac = f.l2_clonemac.value;
		 f.l_mac1.value=oldmac.substring(0,2);
		f.l_mac2.value=oldmac.substring(3,5);
		f.l_mac3.value=oldmac.substring(6,8);
		f.l_mac4.value=oldmac.substring(9,11);
		f.l_mac5.value=oldmac.substring(12,14);
		f.l_mac6.value=oldmac.substring(15,17);
	}	
	
	if(f.wisp_wan_ip_mode.value==2){
		onchangepppmode( get_by_id("poe_reconnect_mode").value);
		pppoe_use_dynamic_address_selector(f.poe_ip_mode.value);
		pppoe_use_dynamic_dns_selector(f.poe_dns_mode.value);
		schedule_populate_select(f["poe_sch_select"]);
		f.poe_sch_select.value = f.poe_sch_name.value;	
	}
	if(f.wisp_wan_ip_mode.value==3){	
		onchangepptpmode( get_by_id("ptp_reconnect_mode").value);
		ptp_use_dynamic_address_selector(f.ptp_ip_mode.value);
		schedule_populate_select(f["ptp_sch_select"]);
		f.ptp_sch_select.value = f.ptp_sch_name.value;
	}
	if(f.wisp_wan_ip_mode.value==4){	
		onchangel2tpmode( get_by_id("pl2_reconnect_mode").value);
		pl2_use_dynamic_address_selector(f.pl2_ip_mode.value);
		schedule_populate_select(f["pl2_sch_select"]);
		f.pl2_sch_select.value = f.pl2_sch_name.value;
	}
	get_by_id("d_clone").value = sw("txtCopyPCsMACAddress");
	get_by_id("s_clone").value = sw("txtCopyPCsMACAddress");
	get_by_id("o_clone").value = sw("txtCopyPCsMACAddress");
	get_by_id("p_clone").value = sw("txtCopyPCsMACAddress");
	get_by_id("l_clone").value = sw("txtCopyPCsMACAddress");
	get_by_id("add_new_schedule_poe").value = sw("txtAddNew");
	get_by_id("add_new_schedule_ptp").value = sw("txtAddNew");
	get_by_id("add_new_schedule_pl2").value = sw("txtAddNew");
}  


function show_wds_ap_info()
{

	var encrytptype=<%getIndexInfo("WDS_AP_Encrypt");%>;
	var wlan_band=<%getIndexInfo("band");%>;
	if(wlan_band == 0 && encrytptype == 4){
		get_by_id("encrypt0").selectedIndex=get_by_id("encryptMode").value - 3;	
	}else if(wlan_band == 0 && (encrytptype == 1 || encrytptype == 2 || encrytptype == 3)){
		get_by_id("encrypt0").selectedIndex = 0;
	}else{
		get_by_id("encrypt0").selectedIndex=get_by_id("encryptMode").value;
	}

	if(encrytptype==1||encrytptype==2)
	{
			get_by_id("wepKey0").value="<%getIndexInfo("WDS_wepKey");%>";
	}	

	if(encrytptype == 3 ||encrytptype == 4)
	{
		//get_by_id("wdspskValue0").value="<%getIndexInfo("WDS_pskKey");%>";

	}	
}

var page_start = 1;

function page_load()
{
	showChannel();
    var default_aphidden_enable = "<%getIndexInfo("hiddenssid");%>";//add by gold
	autoch_ap_wr = get_by_id("wireless_auto_channel").value;
    //changedHidden(get_by_id("aphidden").value);//del by gold
    changedHidden(default_aphidden_enable);	
	on_change_op_mode(get_by_id("wireless_mode").value);
	wireless_radio_control_selector(get_by_id("wireless_radio_control").value == "1");
	page_start = page_start + 1;
	get_by_id("wpapsk1").value = "<%getInfo("pskValue");%>";
	if(get_by_id("wireless_mode").value != 1 && get_by_id("wireless_mode").value !=5)
	{
		if(get_by_id("wireless_auto_channel").value == "true" )
		{
			get_by_id("channel_2").checked = true;
		}
		else
		{
			get_by_id("channel_2").checked = false;
		}
	
		if(get_by_id("wireless_channel").value != 'auto')
		{
			get_by_id("channel_1").value = get_by_id("wireless_channel").value;
		}
		else
		{
			get_by_id("channel_1").value = 1;
		}
		
		chan();
	}
	
	chg_wep_auth_type(get_by_id("wireless_wep_auth_type").value);
	chg_wep_type(get_by_id("wireless_wep_key_len").value);
	chg_wep_def_key(get_by_id("wireless_wep_def_key").value);
	chg_cipher_type(get_by_id("wireless_cipher_type").value);
	

	if(get_by_id("wifisc_enable").value == 'true')
	{
		get_by_id("auth_type").value = 1;
		get_by_id("auth_type").disabled = true;
	}	
	
	//wmm
    var default_wmm_enable = "<%getIndexInfo("wmm");%>";//add by gold
    //on_off_wmm(get_by_id("wmm").value == 1);
    on_off_wmm(default_wmm_enable == 1);//Add by gold

	var wlan_band=<%getIndexInfo("band");%>;
	if( wlan_band==0 || wlan_band==2){
		get_by_id("wmm").disabled=true;
	}
	
	// wps
		
	init_show_wps_status();
	
	if( <%getIndexInfo("wlanMode");%> == 2 || <%getIndexInfo("wlanMode");%> == 6) //2:WDS 6:WDS+Router
	{
		//get_by_id("wifisc_enable_select").disabled = true;
		Modify_WPS_Options();
		get_by_id("ssid").disabled=true;
	}
	if( <%getIndexInfo("wlanMode");%> == 1){ //1:Client
	 	disable_form_field(get_by_id("wifisc_reset_unconfig_btn"),true);
//		disable_form_field(get_by_id("wifisc_pinlock_select"), true);
	}
	
	if( <%getIndexInfo("wlanMode");%> == 2|| <%getIndexInfo("wlanMode");%> == 3 || <%getIndexInfo("wlanMode");%> == 6 || <%getIndexInfo("wlanMode");%> == 7){ //2:WDS 3:wds+ap 6:wds+Router 7:WDS+AP+Router
	 	show_wds_ap_info();
	}
	
	
	set_form_default_values("formWPS");
	set_form_default_values("formWlan");
	set_form_default_values("formWDS");
}

//function wifisc_get_pin_selector(cgi_name)
//{
//wifisc_pin_retriever.dataURL = cgi_name;
//wifisc_pin_retriever.retrieveData();
//}

// this function is used to check if the "str" is a decimal number or not.
function is_digit(str)
{
	if (str.length==0) return false;
	for (var i=0;i < str.length;i++)
	{
		if (str.charAt(i) < '0' || str.charAt(i) > '9') return false;
	}
	return true;
}

function showChannel()
{
	if (regDomain == 4 || regDomain == 9 || regDomain == 11 || regDomain == 12 || 
				regDomain == 13 || regDomain == 14) {
		start = 1;
		end = 11;
	}
	else {
		start = 1;
		end = 13;	
	}
	for (var idx=0, chan=start; chan<=end; chan++, idx++) {
		get_by_id("channel_1").options[idx] = new Option(chan, chan, false, false);
		if (chan == get_by_id("wireless_channel").value) {
			get_by_id("channel_1").selectedIndex = idx;
		}
	}
}

function chan(isclick)
{
	var f = get_by_id("formWlan");
	
	if(f.channel_2.checked)
	{
		f.channel_1.disabled	 = true;
		f.wireless_channel.value		= f.channel_1.value;
		get_by_id("wireless_auto_channel").value = true;
	}
	else
	{
		f.channel_1.disabled 	= false;
		f.wireless_channel.value		= f.channel_1.value;
		get_by_id("wireless_auto_channel").value = false;
	}
	if(typeof(isclick) == "undefined")
		return;
	if(isclick == "click")
	{
		var mode = get_by_id("mode").value;
		switch(mode * 1)
		{
			case 2:
			case 3:
				break;
			default:
				autoch_ap_wr = get_by_id("wireless_auto_channel").value;
		}
	}
}

// convert dec integer string
function decstr2int(str)
{
	var i = -1;
	if (is_digit(str)==true) i = parseInt(str, [10]);
	return i;
}

function do_scan()
{
	get_by_id("site_survey").src = "./scan.asp";
	//window.site_survey.document.forms[0].refresh.click();
}

function chg_wep_def_key(selectValue)
	{
	get_by_id("wep_def_key").value = selectValue;
	//chg_wep_type(get_by_id("wep_key_len").value);
}

function chg_cipher_type(selectValue)
{
	get_by_id("cipher_type").value = selectValue;
}

function chg_wep_auth_type(selectValue)
{
	get_by_id("wireless_wep_auth_type").value=selectValue;
	get_by_id("auth_type").value=selectValue;	
}

function chg_wep_type(selectValue)
	{
	get_by_id("wep_key_len").value = selectValue;
	get_by_id("wireless_wep_key_len").value = selectValue;
	var f=get_by_id("formWlan");
	get_by_id("wep_key_64").style.display		= "none";
	get_by_id("wep_key_128").style.display		= "none";
	
	if(f.wep_key_len.value==1)	
		get_by_id("wep_key_128").style.display	= "";
	else
		get_by_id("wep_key_64").style.display	= "";
}

function draw_cipher_type_11n_band(wpa_mode)
{
	get_by_id("cipher_type").length=0;
	get_by_id("cipher_type")[0] = new Option("AES", "2", false, false);
}
	
function on_change_security_type(selectValue)
{
	var mf = document.forms.formWlan;
	//-1:router; 0:ap; 1:client; 2:wds: 3:wds+ap; 5:wisp; 6:wds+router
	var opmode= get_by_id("mode");
	var CurrentWlanMode=(opmode.value*1);
	var wlan_band=<%getIndexInfo("band");%>;
	var sec_type = get_by_id("security_type");
	var default_cipher_value=get_by_id("cipher_type").selectValue;

	selectValue=sec_type.value;
	if(wlan_band==0){//11n band, remove tkip option
		if(selectValue==2 || selectValue==4 || selectValue==6)
			draw_cipher_type_11n_band(selectValue);
		else {
			if(CurrentWlanMode !=1 && CurrentWlanMode !=5){
				draw_cipher_type(3);
			}else{
				draw_cipher_type(2);
			}
		}
	}else{
		if(CurrentWlanMode !=1 && CurrentWlanMode !=5){
			draw_cipher_type(3);
		}else{
			draw_cipher_type(2);
		}
	}
	get_by_id("cipher_type").value=default_cipher_value;
	
	if(selectValue==2 || selectValue==4 || selectValue==6){
		if(get_by_id("cipher_type").length==1 && get_by_id("cipher_type").value != 2)
			get_by_id("cipher_type").selectedIndex=0; 
	}

	if(selectValue ==1)
	{
		mf.wireless_wepon.value = true;
		mf.wireless_wpa_enabled.value = false;
	}
	else if(selectValue ==2)
	{
		mf.wireless_wepon.value = false;
		mf.wireless_wpa_enabled.value = true;
		mf.wireless_wpa_mode.value = 1;
		}
	else if(selectValue ==4)
		{
		mf.wireless_wepon.value = false;
		mf.wireless_wpa_enabled.value = true;
		mf.wireless_wpa_mode.value = 3;
		}
	else if(selectValue ==6)
		{
		mf.wireless_wepon.value = false;
		mf.wireless_wpa_enabled.value = true;
		mf.wireless_wpa_mode.value = 2;
	}
	else
	{
		mf.wireless_wepon.value = false;
		mf.wireless_wpa_enabled.value = false;
	}
	
	get_by_id("show_wep").style.display = "none";
	get_by_id("show_wpa").style.display = "none";
	
	if (sec_type.value == 1)
	{
		get_by_id("show_wep").style.display = "";
	}
	else if(sec_type.value >= 2)
	{
		get_by_id("show_wpa").style.display = "";
		
		get_by_id("title_wpa").style.display			= "none";
		get_by_id("title_wpa2").style.display			= "none";
		get_by_id("title_wpa2_auto").style.display	= "none";
		if(sec_type.value == 2)		get_by_id("title_wpa").style.display		= "";
		if(sec_type.value == 4)		get_by_id("title_wpa2").style.display		= "";
		if(sec_type.value == 6)		get_by_id("title_wpa2_auto").style.display= "";
		
		if(get_by_id("wireless_ieee8021x_enabled").value == 'true')
			chg_psk_eap(1);
		else
			chg_psk_eap(2);
	}
	
	init_wlan_security_select=sec_type.selectedIndex;
}
function chg_psk_eap(selectValue)
{
//	if(get_by_id("wifisc_enable_select").checked == true && selectValue == 1)
//	{
//		alert(sw("txtWPSCantWorkAtWPAEAPMode"));
//		get_by_id("psk_eap").value = 2;
//		return false;
//	}
	if(selectValue == 2)
	{
		get_by_id("wireless_ieee8021x_enabled").value == 'true';
	}
	else
	{
		get_by_id("wireless_ieee8021x_enabled").value == 'false';
	}
	
	get_by_id("psk_eap").value = selectValue;
	
	var wpa_type = get_by_id("psk_eap");
	get_by_id("psk_setting").style.display = "none";
	get_by_id("eap_setting").style.display = "none";
	if(wpa_type.value==2)	{	get_by_id("psk_setting").style.display = "";	}
	else					{	get_by_id("eap_setting").style.display = "";	}
}
function changedHidden(checkValue)
{
	var f = get_by_id("formWlan");
	f.aphidden.value = checkValue;
	
	if(f.aphidden.value==1 || f.aphidden.value=='true' || f.aphidden.value== true)
		f.aphidden.checked = true;
	else
		f.aphidden.checked = false;
}

function on_change_wan_type()
{
	var frm = get_by_id("formWlan");
	var final_f= get_by_id("final_form");
	
	get_by_id("show_static").style.display = "none";
	get_by_id("show_dhcp").style.display = "none";
	get_by_id("show_pppoe").style.display = "none";
	get_by_id("show_pptp").style.display = "none";
	get_by_id("show_l2tp").style.display = "none";
	frm.wisp_wan_ip_mode.value=frm.wan_type.value;
	
	switch (frm.wan_type.value)
	{
	case "0":	
			get_by_id("show_static").style.display = ""; 
	            break;
	case "1":	
				get_by_id("show_dhcp").style.display = ""; 
 				break;
	case "2":
			get_by_id("show_pppoe").style.display = "";
	           	break;
	 case "3":
			get_by_id("show_pptp").style.display = "";
	           	break;
	 case "4":
			get_by_id("show_l2tp").style.display = "";
				break;
	}
	init_wisp_part("1");
	final_f.wisp_wan_ip_mode.value=frm.wan_type.value;
}

function pppoe_use_dynamic_address_selector(mode)
	{
	var frm=get_by_id("formWlan");
	frm.poe_ip_mode.value = mode;
	if(mode == "true") {
		frm.p_poe_ip_mode_0.checked = true;
		frm.p_poe_ip_address.disabled = true;
	} else {
		frm.p_poe_ip_mode_1.checked = true;
		frm.p_poe_ip_address.disabled = false;
	}
}


function ptp_use_dynamic_address_selector(mode)
{
	var frm=get_by_id("formWlan");
	frm.ptp_ip_mode.value = mode;
	if(mode == "true") {
		frm.p_ptp_ip_mode_0.checked = true;
		frm.p_ptp_ip_address.disabled = true;
		frm.p_ptp_netMask.disabled = true;
		frm.p_ptp_gw.disabled = true;
 
	} else {
		frm.p_ptp_ip_mode_1.checked = true;
		frm.p_ptp_ip_address.disabled = false;
		frm.p_ptp_netMask.disabled = false;
		frm.p_ptp_gw.disabled = false;
	}
}
function pl2_use_dynamic_address_selector(mode)
{
	var frm=get_by_id("formWlan");
	frm.pl2_ip_mode.value = mode;
	if(mode == "true") {
		frm.p_pl2_ip_mode_0.checked = true;
		frm.p_pl2_ip_address.disabled = true;
		frm.p_pl2_netMask.disabled = true;
		frm.p_pl2_gw.disabled = true;
  
	} else {
		frm.p_pl2_ip_mode_1.checked = true;
		frm.p_pl2_ip_address.disabled = false;
		frm.p_pl2_netMask.disabled = false;
		frm.p_pl2_gw.disabled = false;
	}
}

function pppoe_use_dynamic_dns_selector(mode){
	var frm=get_by_id("formWlan");	
			frm.poe_dns_mode.value = mode;
			if(mode == "0") {
				frm.p_poe_dns_mode_0.checked = true;
				frm.p_dns1.disabled = true;
				frm.p_dns2.disabled = true;
			} else {
				frm.p_poe_dns_mode_1.checked = true;
				frm.p_dns1.disabled = false;
				frm.p_dns2.disabled = false;
}
	
		}
    
function onchangepppmode(mode)
	{
	var frm=get_by_id("formWlan");
  	mode = mode * 1;
			// 0 = Always on, 1 = On demand, 2 = Manual
			frm.poe_reconnect_mode.value = mode;
			frm.p_idletime.disabled = mode == 1 ? false : true;
			if(mode != 0){
				frm.poe_sch_select.disabled=true;
			}else{
				frm.poe_sch_select.disabled=false;
	}
		switch(mode)
			{
				case 0:
					frm.p_ppp_conn_mode_0.checked = true;
				break;
				case 1:
					frm.p_ppp_conn_mode_2.checked = true;
				break;
				case 2:
					frm.p_ppp_conn_mode_1.checked = true;
				break;
			}
}
function onchangepptpmode(mode)
{
	var frm=get_by_id("formWlan");
  	mode = mode * 1;
			// 0 = Always on, 1 = On demand, 2 = Manual
			frm.ptp_reconnect_mode.value = mode;
			frm.pt_idletime.disabled = mode == 1 ? false : true;
			if(mode != 0){
				frm.ptp_sch_select.disabled=true;
			}else{
				frm.ptp_sch_select.disabled=false;
	}
		switch(mode)
			{
				case 0:
					frm.p_pt_conn_mode_0.checked = true;
				break;
				case 1:
					frm.p_pt_conn_mode_2.checked = true;
				break;
				case 2:
					frm.p_pt_conn_mode_1.checked = true;
				break;
  }
}
	   	

function onchangel2tpmode(mode)
{
	var frm=get_by_id("formWlan");
  	mode = mode * 1;
			// 0 = Always on, 1 = On demand, 2 = Manual
			frm.pl2_reconnect_mode.value = mode;
			frm.l2_idletime.disabled = mode == 1 ? false : true;
			if(mode != 0){
				frm.pl2_sch_select.disabled=true;
			}else{
				frm.pl2_sch_select.disabled=false;
}
		switch(mode)
	{
				case 0:
					frm.p_l2_conn_mode_0.checked = true;
				break;
				case 1:
					frm.p_l2_conn_mode_2.checked = true;
				break;
				case 2:
					frm.p_l2_conn_mode_1.checked = true;
				break;
	}
}

function WdsMacList()
{
    var wlanWdsNum = 0;
    var mode = get_by_id("mode0");
    var wdsMac1 = get_by_id("wdsMac10");
    var wdsMac2 = get_by_id("wdsMac20");
    var wdsMac3 = get_by_id("wdsMac30");
    var wdsMac4 = get_by_id("wdsMac40");
    var wdsMac5 = get_by_id("wdsMac50");
    var wdsMac6 = get_by_id("wdsMac60");
    var wdsMac7 = get_by_id("wdsMac70");
    var wdsMac8 = get_by_id("wdsMac80");
	
	if(wlanWdsNum==0) return 1;
    
    if((mode.selectedIndex == 2) || (mode.selectedIndex == 3))
	{
            var i=0;
            var str = "";
            str = str.toUpperCase();
            if(wlanWdsNum>=1) 
                wdsMac1.value = str.substring(12*i,12*i+12);
            i++;
            if(wlanWdsNum>=2) 
                wdsMac2.value = str.substring(12*i,12*i+12);
            i++;
            if(wlanWdsNum>=3) 
                wdsMac3.value = str.substring(12*i,12*i+12);
            i++;
            if(wlanWdsNum>=4) 
                wdsMac4.value = str.substring(12*i,12*i+12);
            i++;
            if(wlanWdsNum>=5) 
                wdsMac5.value = str.substring(12*i,12*i+12);
            i++;
            if(wlanWdsNum>=6) 
                wdsMac6.value = str.substring(12*i,12*i+12);
            i++;
            if(wlanWdsNum>=7) 
                wdsMac7.value = str.substring(12*i,12*i+12);
            i++;
            if(wlanWdsNum>=8) 
                wdsMac8.value = str.substring(12*i,12*i+12);
		i++;
	}
}
function setWDSDefaultKeyValue(selectMode)
{
    var format = get_by_id("wdsformatMode");
    var wepKey = get_by_id("wepKey0");
    var encrypt = get_by_id("encrypt0");
    var key_format = 0;
    var wep_format = 0;
	
    get_by_id("wdsformatMode").value = selectMode;
	
    if(encrypt.selectedIndex == 1) {
		get_by_id("wds_wep_hint").innerHTML = sw("txt5AOr10H");
		wepKey.maxLength = 10;

	}
	else {
get_by_id("wds_wep_hint").innerHTML = sw("txt13AOr26H");
		wepKey.maxLength = 26;

  }
}

function draw_cipher_type(index)
{
	var wlan_band=<%getIndexInfo("band");%>;
	if(wlan_band != 0){
		if(index == 3)
		{
			get_by_id("cipher_type").length=0;
			get_by_id("cipher_type")[0] = new Option(sw("txtTKIPandAES"), "3", false, false);
			get_by_id("cipher_type")[1] = new Option("TKIP", "1", false, false);
			get_by_id("cipher_type")[2] = new Option("AES", "2", false, false);
		}
		else
		{
			get_by_id("cipher_type").length=0;
			get_by_id("cipher_type")[0] = new Option("TKIP", "1", false, false);
			get_by_id("cipher_type")[1] = new Option("AES", "2", false, false);
		}
	}else{
		get_by_id("cipher_type").length=0;
		get_by_id("cipher_type")[0] = new Option("AES", "2", false, false);
	}

}

function Modify_Wlan_Security_Selection_Options(modeValue)
{
	var f = get_by_id("formWlan");
	var wlan_band=<%getIndexInfo("band");%>;
	var old_security = f.security_type.value;
	if(modeValue==1 || modeValue==5){
		if(wlan_band != 0){
			f.security_type.length=0;
			f.security_type.options[0]=new Option(sw("txtNONE"), 0, false, false);
			f.security_type.options[1]=new Option(sw("txtWEPSecurity"), 1, false, false);
			f.security_type.options[2]=new Option(sw("txtWPAPersonal"), 2, false, false);
			f.security_type.options[3]=new Option(sw("txtWPA2"), 4, false, false);
			f.security_type.length=4;
		}else{
			f.security_type.length=0;
			f.security_type.options[0]=new Option(sw("txtNONE"), 0, false, false);
			f.security_type.options[1]=new Option(sw("txtWPAPersonal"), 2, false, false);
			f.security_type.options[2]=new Option(sw("txtWPA2"), 4, false, false);
			f.security_type.length=3;
		}
	}else{
		if(wlan_band != 0){
			f.security_type.length=0;
			f.security_type.options[0]=new Option(sw("txtNONE"), 0, false, false);
			f.security_type.options[1]=new Option(sw("txtWEPSecurity"), 1, false, false);
			f.security_type.options[2]=new Option(sw("txtWPAPersonal"), 2, false, false);
			f.security_type.options[3]=new Option(sw("txtWPA2"), 4, false, false);
			f.security_type.options[4]=new Option(sw("txtWPA2Auto"), 6, false, false);
			f.security_type.length=5;
		}else{
			f.security_type.length=0;
			f.security_type.options[0]=new Option(sw("txtNONE"), 0, false, false);
			f.security_type.options[1]=new Option(sw("txtWPAPersonal"), 2, false, false);
			f.security_type.options[2]=new Option(sw("txtWPA2"), 4, false, false);
			f.security_type.options[3]=new Option(sw("txtWPA2Auto"), 6, false, false);
			f.security_type.length=4;
		}
	}
	if(init_wlan_security_select <= f.security_type.length){
		if(page_start == 1 && init_wlan_security_select != 0 && wlan_band == 0)
			f.security_type.selectedIndex=init_wlan_security_select - 1;
		else
			f.security_type.selectedIndex=init_wlan_security_select;
	}else{
		f.security_type.selectedIndex=0;
	}
	f.security_type.value = old_security;
}
function Modify_WPS_Options()
{
	var f_wps =get_by_id("formWPS");
		f_wps.wifisc_enable_select.disabled=true;
		f_wps.wifisc_pinlock_select.disabled=true;
		f_wps.wifisc_get_new_pin_button.disabled=true;
		f_wps.wifisc_reset_pin_button.disabled=true;
		f_wps.wifisc_reset_unconfig_btn.disabled=true;
		f_wps.wifisc_add_sta_start_button.disabled=true;
}




var autoch_ap_wr = false;
function on_change_op_mode(modeValue)
{
	get_by_id("wireless_mode").value = modeValue;
	var opmode = get_by_id("mode"); //-1:router; 0:ap; 1:client; 2:wds: 3:wds+ap; 5:wisp
	get_by_id("mode").value = modeValue;
	var opmode = get_by_id("mode"); //-1:router; 0:ap; 1:client; 2:wds: 3:wds+ap; 5:wisp; 7:wds+ap+router
	var wireless_radio_control_select = get_by_id("wireless_radio_control_select");
	var dis = false;
	var CurrentWlanMode=(opmode.value*1);
	get_by_id("show_site").style.display = "none";
	get_by_id("show_wisp").style.display = "none";
	get_by_id("show_wds").style.display= "none";	
	get_by_id("show_security").style.display	= "";
	get_by_id("show_wep").style.display = "";
	get_by_id("show_wpa").style.display = "";
	draw_cipher_type(3);
	
	if(opmode.value*1 != -1)
	{
		wireless_radio_control_selector(1); // other mode, force to turn on wlan
		wireless_radio_control_select.disabled = true;
	
	}
	get_by_id("psk_eap").disabled = false;
	get_by_id("wireless_auto_channel").value = autoch_ap_wr;
	get_by_id("channel_2").disabled = false;
	switch (opmode.value*1)
	{
		case -1:
		wireless_radio_control_select.disabled = false;
		get_by_id("ssid").disabled=false;
		  break;

		case 0: //AP
		get_by_id("ssid").disabled=false;
		  break;
		     
	 	case 1: //client
	   	     get_by_id("show_site").style.display	= "";
	   	     get_by_id("ssid").disabled=false;
	   	     //disable_form_field(get_by_id("wifisc_reset_unconfig_btn"),true);
		     dis	= true;
		  
		  draw_cipher_type(2);
		  if(get_by_id("cipher_type").selectValue == 3)
		  {
	   		get_by_id("cipher_type").selectValue = 2;
	   		get_by_id("cipher_type").value = 2;
	   		get_by_id("wireless_cipher_type").value = 2;
	   		}
	   	get_by_id("wireless_ieee8021x_enabled").value = 'false';
	   	get_by_id("psk_eap").disabled = true;
		     break;
	    
		case 2: //WDS
		case 6: //WDS+Router
			get_by_id("show_security").style.display	= "none";
	         get_by_id("show_wep").style.display = "none";
             get_by_id("show_wpa").style.display = "none";
			get_by_id("ssid").disabled=true;
			get_by_id("show_wds").style.display	= "";
			updateEncryptState(get_by_id("encryptMode").value);
			setWDSDefaultKeyValue(get_by_id("wdsformatMode").value);
			 get_by_id("wireless_auto_channel").value = "false";
			 get_by_id("channel_2").disabled = true;
			break;
			
		case 3: //WDS+AP
		case 7: //WDS+AP+Router
		     get_by_id("show_wds").style.display	= "";
		     updateEncryptState(get_by_id("encryptMode").value);
		     get_by_id("ssid").disabled=false;
		     setWDSDefaultKeyValue(get_by_id("wdsformatMode").value);
			 get_by_id("wireless_auto_channel").value = "false";
			 get_by_id("channel_2").disabled = true;
		     break;	
		  
		case 5://WISP
	  	     get_by_id("show_site").style.display	= "";
		     get_by_id("show_wisp").style.display	= "";
		     get_by_id("ssid").disabled=false;
		      init_wisp_part(0);	
		     on_change_wan_type();	
		     dis	= true;
		     draw_cipher_type(2);
			  if(get_by_id("cipher_type").selectValue == 3)
			  {
		   		get_by_id("cipher_type").selectValue = 2;
		   		get_by_id("cipher_type").value = 2;
		   		get_by_id("wireless_cipher_type").value = 2;
		   	}
get_by_id("wireless_ieee8021x_enabled").value = 'false';
		   	get_by_id("psk_eap").disabled = true;
		     break;
		}

 
//		get_by_id("wireless_channel").disabled = dis;
//		get_by_id("channel_1").disabled = dis;
//		get_by_id("channel_2").disabled = dis;

                if(get_by_id("wireless_auto_channel").value == "true" )
                {
                        get_by_id("channel_2").checked = true;
                }
                else
                {
                        get_by_id("channel_2").checked = false;
                }

                if(get_by_id("wireless_channel").value != 'auto')
                {
                        get_by_id("channel_1").value = get_by_id("wireless_channel").value;
                }
                else
                {
                        get_by_id("channel_1").value = 1;
                }

                chan();

		if(CurrentWlanMode==1 || CurrentWlanMode ==5 || CurrentWlanMode==2 || CurrentWlanMode==6){
			get_by_id("aphidden").disabled = true;
		}else
			get_by_id("aphidden").disabled = dis;
		get_by_id("wmm").disabled = dis;

		if(opmode.value*1 != 2 && opmode.value*1 != 6)//2:WDS 6:WDS + Router
		init_show_wlan_security_type();
		var wlan_band=<%getIndexInfo("band");%>;
		if( wlan_band==0 || wlan_band==2){
			get_by_id("wmm").disabled=true;
		}
		Modify_Wlan_Security_Selection_Options(opmode.value*1);
		
}

function wds_draw_cipher_type_11n_band(wpa_mode)
{
	get_by_id("encrypt0").length=0;
	if(wpa_mode==1){
		get_by_id("encrypt0")[0] = new Option(sw("txtNONE"), "0", false, false);
//		get_by_id("encrypt0")[1] = new Option(sw("txt64Bit10HexDigits"), "1", false, false);
//		get_by_id("encrypt0")[2] = new Option(sw("txt128Bit26HexDigits"), "2", false, false);
		get_by_id("encrypt0")[1] = new Option("WPA2-PSK (AES)", "4", false, false);
	}else{
		var wlan_band=<%getIndexInfo("band");%>;
		if(wlan_band != 0){
			get_by_id("encrypt0")[0] = new Option(sw("txtNONE"), "0", false, false);
			get_by_id("encrypt0")[1] = new Option(sw("txt64Bit10HexDigits"), "1", false, false);
			get_by_id("encrypt0")[2] = new Option(sw("txt128Bit26HexDigits"), "2", false, false);
			get_by_id("encrypt0")[3] = new Option("WPA2-PSK (TKIP)", "3", false, false);
			get_by_id("encrypt0")[4] = new Option("WPA2-PSK (AES)", "4", false, false);
		}else{
			get_by_id("encrypt0")[0] = new Option(sw("txtNONE"), "0", false, false);
			get_by_id("encrypt0")[1] = new Option(sw("txt64Bit10HexDigits"), "1", false, false);
			get_by_id("encrypt0")[2] = new Option(sw("txt128Bit26HexDigits"), "2", false, false);
			get_by_id("encrypt0")[3] = new Option("WPA2-PSK (AES)", "4", false, false);
		}
	}
	
}	

function updateEncryptState(selectMode)
{
    var default_encrypt_index;
    var default_encrypt_value;
    var format = get_by_id("wdsformatMode");
    var wepKey = get_by_id("wepKey0");
    var wdspskitem = get_by_id("wdspskValue0");
    var encrypt = get_by_id("encrypt0");
    //-1:router; 0:ap; 1:client; 2:wds: 3:wds+ap; 5:wisp
    var opmode= get_by_id("mode");
    var CurrentWlanMode=(opmode.value*1);
    var wlan_band=<%getIndexInfo("band");%>;
	
    get_by_id("encryptMode").value = selectMode;
    get_by_id("encrypt0").value = selectMode;

	default_encrypt_index=encrypt.selectedIndex;
	default_encrypt_value=get_by_id("encrypt0").value;
	 
	if( wlan_band==0){//11n band, remove tkip option
		wds_draw_cipher_type_11n_band(1);
	}else{
		wds_draw_cipher_type_11n_band(0);
	} 
	encrypt.selectedIndex = default_encrypt_index;
	
    if (encrypt.selectedIndex == 0) {
		format.disabled = true;
		wepKey.disabled = true;    
		wdspskitem.disabled = true;     
		wepKey.maxLength = 0;
		wepKey.value = "";
    }
    else if(((encrypt.selectedIndex == 1) || (encrypt.selectedIndex == 2)) && (wlan_band != 0)) {
		format.disabled = false;
		wepKey.disabled = false;    
        wdspskitem.disabled = true;		
        setWDSDefaultKeyValue(get_by_id("wdsformatMode").value);
    }
    else {   
		format.disabled = true;
		wepKey.disabled = true;    
        wdspskitem.disabled = false;
    }
    get_by_id("encryptMode").value = selectMode;
    get_by_id("encrypt0").value = selectMode;
    encrypt.selectedIndex = default_encrypt_index;
    if(get_by_id("encrypt0").length==2){
    	if(default_encrypt_value==4){
		encrypt.selectedIndex=1;
	}else{
		encrypt.selectedIndex=0;
		get_by_id("encryptMode").value = 0;
		get_by_id("encrypt0").value = 0;
	}
    }else if(get_by_id("encrypt0").length==5){
    	if(default_encrypt_value==4)
		encrypt.selectedIndex=4;
    }
    WdsMacList();
}


function wireless_radio_control_selector(checked)
{
	get_by_id("wireless_radio_control").value = checked ? "1" : "0";
	get_by_id("wireless_radio_control_select").checked = checked;
	
	on_check_enable();
	
	disable_form_field(get_by_id("wifisc_enable_select"), !checked);
	//disable_all_wps_buttons(!checked);
}

function on_check_enable()
{
	var f = get_by_id("formWlan");
	var wlan_band=<%getIndexInfo("band");%>;
	if (f.wireless_radio_control_select.checked)
	{
		f.wireless_radio_control_select.value=0;
		f.ssid.disabled = false;
		f.channel_2.disabled = false;
		if (f.channel_2.checked) f.wireless_channel.disabled = true;
		else f.wireless_channel.disabled = false;
		
		f.aphidden.disabled = false;
		f.security_type.disabled =false;
		if(wlan_band ==1)//wlan enable/disable donnot modify wmm flag when 11n mode
			f.wmm.disabled = false; 
//		select_index(f.security_type, "0");
//		on_change_security_type();//gold
	}
	else
	{
		f.wireless_radio_control_select.value=1;
		f.ssid.disabled = true;
		f.wireless_channel.disabled = true;
		f.channel_2.disabled = true;

		f.aphidden.disabled = true;
		f.security_type.disabled =true;
		if(wlan_band ==1)//wlan enable/disable donnot modify wmm flag when 11n mode
			f.wmm.disabled = true;
//		select_index(f.security_type,"0");
//		on_change_security_type();//gold
//		fields_disabled(f, true);
	}
}

function chk_wpakey()
{		
	var f=get_by_id("formWlan");
	var keyvalue = f.wpapsk1.value;
  var	key_len = keyvalue.length;		
	var test_char, i;
	if(key_len == 64)
	{	
		for(i=0; i<key_len; i++)
		{
				test_char=keyvalue.charAt(i);
				if( (test_char >= '0' && test_char <= '9') ||
					(test_char >= 'a' && test_char <= 'f') ||
					(test_char >= 'A' && test_char <= 'F'))
					continue;

				return -1;
		}
	
		get_by_id("wpa_key_type").value = 1;
	}
	else
	{
			if(strchk_unicode(keyvalue))
			{
				return -1;
			}
			
		get_by_id("wpa_key_type").value = 0;
	}
	
	return 0	
}

/* cancel function */
function do_cancel()
{
	self.location.href="bsc_wlan.asp?random_str="+generate_random_str();
}


function check_static()
{
	var f = get_by_id("formWlan");
	var final_f= get_by_id("final_form");
	if (!is_ipv4_valid(f.s_ipaddr.value) || f.s_ipaddr.value == "0.0.0.0")	
	{
		alert(sw("txtInvalidWANIPaddress") + f.s_ipaddr.value);
		field_focus(f.s_ipaddr, "**");
		return false;
	}
	if (!is_mask_valid(f.s_netmask.value) ||!is_ipv4_valid(f.s_netmask.value) )
	{
		alert(sw("txtInvalidWANsubnetMask") + f.s_netmask.value);
		field_focus(f.s_netmask, "**");
		return false;
	}
	if (!is_ipv4_valid(f.s_gateway.value))
	{
		alert(sw("txtInvalidGatewayIPAddress") + f.s_gateway.value);
		field_focus(f.s_gateway, "**");
		return false;
	}
	var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
	var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
	var wan_ip = ipv4_to_unsigned_integer(f.s_ipaddr.value);
	var mask_ip = ipv4_to_unsigned_integer(f.s_netmask.value);
	var gw_ip = ipv4_to_unsigned_integer(f.s_gateway.value);
	if ((wan_ip & mask_ip) !== (gw_ip & mask_ip))
	{
		alert(sw("txtWANGwIp")+" "+integer_to_ipv4(gw_ip)+" "+sw("txtWithinWanSubnet"));
		return false;
	}
	if ((LAN_IP & LAN_MASK) == (wan_ip & LAN_MASK))
	{
		alert(sw("txtWanSubConflitLanSub"));
		return false;
	}
	if(f.s_dns1.value=="0.0.0.0")
	{
		alert(sw("txtMustGiveDNS"));
		field_focus(f.s_dns1, "**");
		return false;
	}
	if (!is_ipv4_valid(f.s_dns1.value))
	{
		alert(sw("txtInvalidPPPoEPrimaryDNS") +  f.s_dns1.value);
		field_focus(f.s_dns1, "**");
		return false;
	}
	if(f.s_dns2.value !=""){
	if (!is_ipv4_valid(f.s_dns2.value))
	{
			alert(sw("txtInvalidPPPoESecondaryDNS") +  f.s_dns2.value);
		field_focus(f.s_dns2, "**");
		return false;
	}
	}
	if (!is_digit(f.s_mtu.value) || !is_in_range(f.s_mtu.value, 128, 1500))
	{
		alert(sw("txtInvalidMTUSize")+"("+sw("txtPermittedRange")+sw("txtMtuRng128to1500")+")");
		field_focus(f.s_mtu, "**");
		return false;
	}

	if (!is_ipv4_valid(f.s_dns1.value) || is_FF_IP(f.s_dns1.value) || ((ipv4_to_unsigned_integer(f.s_dns1.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(f.s_dns1.value) & 0x000000FF) == 0x00000000)) {
		alert(sw("txtInvalidPPPoEPrimaryDNS") +  f.s_dns1.value);
	try {
			f.s_dns1.select();
			f.s_dns1.focus();
		} catch (e) {
		}
		return false;
	}
	if(f.s_dns2.value !=""){
		if (!is_ipv4_valid(f.s_dns2.value) || is_FF_IP(f.s_dns2.value) || ((ipv4_to_unsigned_integer(f.s_dns2.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(f.s_dns2.value) & 0x000000FF) == 0x00000000)) {
			alert(sw("txtInvalidPPPoESecondaryDNS") +  f.s_dns1.value);
			try {
			f.s_dns2.select();
			f.s_dns2.focus();
			} catch (e) {
			}
		return false;
		}
	}
	final_f.f_s_wan_ip.value = f.s_ipaddr.value;
	final_f.f_s_wan_mask.value=f.s_netmask.value;
	final_f.f_s_wan_gw.value=f.s_gateway.value;
	final_f["config.wan_primary_dns"].value = f.s_dns1.value; 
	final_f["config.wan_secondary_dns"].value = f.s_dns2.value; 
	final_f["mac_clone"].value=get_by_id("wan_macAddr").value;
	final_f["f_mtu"].value = f.s_mtu.value;
	
	return true;
}

function check_dhcp()
{
	var f = get_by_id("formWlan");
	var final_f= get_by_id("final_form");
	
	if(f.d_dns1.value !=""){
		if (!is_ipv4_valid(f.d_dns1.value)){
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  f.d_dns1.value);
		field_focus(f.d_dns1, "**");
		return false;
	}
	}
	if (!strchk_hostname(f.d_hostname.value)){
		alert(sw("txtInvalidHostName"));
			return false;
	}
	if(f.d_dns2.value !=""){
		if (!is_ipv4_valid(f.d_dns2.value)){
			alert(sw("txtInvalidPPPoESecondaryDNS") +  f.d_dns2.value);
		field_focus(f.d_dns2, "**");
		return false;
	}
	}
	if (!is_digit(f.d_mtu.value) || !is_in_range(f.d_mtu.value, 128, 1500))
     {
     		alert(sw("txtInvalidMTUSize")+"("+sw("txtPermittedRange")+sw("txtMtuRng128to1500")+")");
		field_focus(f.d_mtu, "**");
		return false;
	}
	final_f["config.wan_primary_dns"].value = f.d_dns1.value; 
	final_f["config.wan_secondary_dns"].value = f.d_dns2.value; 
	final_f["mac_clone"].value=get_by_id("wan_macAddr").value;
	final_f["f_d_hostname"].value = f.d_hostname.value;
	final_f["f_mtu"].value = f.d_mtu.value;
	return true;
}

/*
function is_strvalid(str)
	{
		var c;
		var i;
		for (i=0; i<str.length; i++)
		{
			c = str.charCodeAt(i);
			if ( c==32 || c==39 || c==34 || c==92 || c==36 || c==60 || c==62 )
			{
				return false;
			}
			else
			{
				continue;
			}
		}
		return true;
	}
*/
function is_strvalid(str)
        {
                var c;
                var i;
                for (i=0; i<str.length; i++)
                {
                        c = str.charCodeAt(i);
			if (c==12298 || c== 12299) continue;
                        //alert(c);   
                        if ( c<33 || c>126 )
                        {
                                return false;
                        }
                        else
                        {
                                continue;
                        }
                }
                return true;
        }	
	
function check_pppoe()
{
	var f = get_by_id("formWlan");
	var final_f= get_by_id("final_form");
	if (is_blank(f.p_username.value))
	{
		alert(sw("txtInvalidUsername"));
		field_focus(f.p_username, "**");
		return false;
	}
	if (!is_strvalid(f.p_username.value))
		{
			alert(sw("txtInvalidUsername"));
			field_focus(f.p_username, "**");
			return false;
		}
		

	if (!strchk_hostname(f.p_svc_name.value)){
			alert(sw("txtInvalidServicename"));
			return false;			
	}
	

	if (!is_strvalid(f.tmp_password.value))
                {
                        alert(sw("txtInvalidPasswords"));
                        field_focus(f.tmp_password, "**");
                        return false;
                }

	
	if (f.tmp_password.value != f.p_password_v.value)
	{
		alert(sw("txtThePasswordsDontMatch"));
		field_focus(f.tmp_password, "**");
		return false;
	}
	
	if(f.poe_dns_mode.value == "1"){
		if(f.p_dns1.value !=""){
			if (!is_ipv4_valid(f.p_dns1.value) || is_FF_IP(f.p_dns1.value) || ((ipv4_to_unsigned_integer(f.p_dns1.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(f.p_dns1.value) & 0x000000FF) == 0x00000000   )) {
				alert(sw("txtInvalidPPPoEPrimaryDNS") +  f.p_dns1.value);
				try {
					f.p_dns1.select();
					f.p_dns1.focus();
				} catch (e) {
				}
				return false;
			}
		}
		if(f.p_dns2.value !=""){
			if (!is_ipv4_valid(f.p_dns2.value) || is_FF_IP(f.p_dns2.value) || ((ipv4_to_unsigned_integer(f.p_dns2.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(f.p_dns2.value) & 0x000000FF) == 0x00000000   )) {
				alert(sw("txtInvalidPPPoESecondaryDNS") +  mf.wan_secondary_dns.value);
				try {
					f.p_dns2.select();
					f.p_dns2.focus();
				} catch (e) {
				}
					return false;
			}
		}
	}
	
	if(f.poe_ip_mode.value == "false" ) {
		if (!is_ipv4_valid(f.p_poe_ip_address.value) || f.p_poe_ip_address.value=="0.0.0.0" || is_FF_IP(f.p_poe_ip_address.value)) {
				alert(sw("txtInvalidPPPoEIPaddress") + f.p_poe_ip_address.value);
					f.p_poe_ip_address.select();
					f.p_poe_ip_address.focus();
		return false;
	}
		var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
		var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
		var wan_ip = ipv4_to_unsigned_integer(f.p_poe_ip_address.value);
		if ((LAN_IP & LAN_MASK) == (wan_ip & LAN_MASK))
	{
			alert(sw("txtWanSubConflitLanSub"));
		return false;
	}
	}
	if (!is_digit(f.p_mtu.value) || !is_in_range(f.p_mtu.value, 128, 1492))
	{
		alert(sw("txtInvalidMTUSize")+"("+sw("txtPermittedRange")+sw("txtMtuRng128to1492")+")");
		field_focus(f.p_mtu, "**");
		return false;
	}
	if (f.p_ppp_conn_mode[0].checked)
	{
	}
	else if (f.p_ppp_conn_mode[1].checked)
	{
	}
	else
	{
		if (!is_digit(f.p_idletime.value))
		{
			alert(sw("txtInvalidIdleTime"));
			field_focus(f.p_idletime, "**");
			return false;
		}
		if (!is_number(f.p_idletime.value) || (f.p_idletime.value>600 || f.p_idletime.value<0)) {
			alert(sw("txtInvalidIdleTime")+"("+sw("txtPermittedRange")+sw("txtIdleRng0to600")+")");
		try	{
			f.p_idletime.select();
			f.p_idletime.focus();
			} catch (e) {
			}
			return false;
		}
	}
	
	
	final_f["config.pppoe_username"].value = f.p_username.value;
	final_f["config.pppoe_password"].value = f.tmp_password.value;
	final_f["config.pppoe_service_name"].value = f.p_svc_name.value;
	final_f["pppoe_reconnect_mode_radio"].value = f.poe_reconnect_mode.value;
	final_f["config.pppoe_max_idle_time"].value = f.p_idletime.value;
	final_f["config.pppoe_use_dynamic_address"].value = f.poe_ip_mode.value;
	final_f["config.pppoe_ip_address"].value = f.p_poe_ip_address.value;
	final_f["ppp_schedule_control_0"].value = f.poe_sch_name.value;
	if(f.poe_dns_mode.value=="0")
		final_f["pppoe_use_dynamic_dns_radio"].value = "true";
	else
		final_f["pppoe_use_dynamic_dns_radio"].value = "false";
	final_f["config.wan_mtu"].value = f.p_mtu.value;
	final_f["config.wan_primary_dns"].value = f.p_dns1.value; 
	final_f["config.wan_secondary_dns"].value = f.p_dns2.value; 
	final_f["mac_clone"].value=get_by_id("wan_macAddr").value;

	
	return true;
}

function check_pptp()
		{
	var f = get_by_id("formWlan");
	var final_f= get_by_id("final_form");
	if (is_blank(f.pt_username.value))
	{
		alert(sw("txtInvalidUsername"));
		field_focus(f.pt_username, "**");
		return false;
	}
	if (!is_strvalid(f.pt_username.value))
	{
			alert(sw("txtInvalidUsername"));
			field_focus(f.pt_username, "**");
			return false;
	}

	if (!is_strvalid(f.tmpt_password.value))
       {
                        alert(sw("txtInvalidPasswords"));
                        field_focus(f.tmpt_password, "**");
                        return false;
        }
	if (f.tmpt_password.value != f.pt_password_v.value)
	{
		alert(sw("txtThePasswordsDontMatch"));
		field_focus(f.tmpt_password, "**");
		return false;
	}
	if(f.pt_dns1.value !=""){
			if (!is_ipv4_valid(f.pt_dns1.value) || is_FF_IP(f.pt_dns1.value) || ((ipv4_to_unsigned_integer(f.pt_dns1.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(f.pt_dns1.value) & 0x000000FF) == 0x00000000   )) {
				alert(sw("txtInvalidPPPoEPrimaryDNS") +  f.pt_dns1.value);
				try {
					f.pt_dns1.select();
					f.pt_dns1.focus();
				} catch (e) {
				}
				return false;
			}
		}
	if(f.ptp_ip_mode.value == "false" ) {
		var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
		var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
		var wan_ip = ipv4_to_unsigned_integer(f.p_ptp_ip_address.value);
		var mask_ip = ipv4_to_unsigned_integer(f.p_ptp_netMask.value);
		var gw_ip = ipv4_to_unsigned_integer(f.p_ptp_gw.value);
		var srv_ip = ipv4_to_unsigned_integer(f.pt_server.value);
			
		if (!is_ipv4_valid(f.p_ptp_ip_address.value) || f.p_ptp_ip_address.value.value=="0.0.0.0" || 	is_FF_IP(f.p_ptp_ip_address.value) || wan_ip == gw_ip || wan_ip == srv_ip) 
		{
			alert(sw("txtInvalidPPTPIPaddress") + f.p_ptp_ip_address.value);
			try	{
					f.p_ptp_ip_address.select();
					f.p_ptp_ip_address.focus();
				} catch (e) {
				}
				return false;
		}
		if (!is_ipv4_valid(f.p_ptp_netMask.value) || !is_mask_valid(f.p_ptp_netMask.value)) {
				alert(sw("txtInvalidPPTPsubnetMask") + f.p_ptp_netMask.value);
				try	{
						f.p_ptp_netMask.select();
						f.p_ptp_netMask.focus();
					} catch (e) {
					}
					return false;
				}
			//|| gw_ip == srv_ip ==> we accept the case when gwip==server ip	
			if (!is_ipv4_valid(f.p_ptp_gw.value) || 
				f.p_ptp_gw.value=="0.0.0.0" || 
				is_FF_IP(f.p_ptp_gw.value))
			{
					alert(sw("txtInvalidPPTPgatewayIPaddress") + f.p_ptp_gw.value);
					try	{
						f.p_ptp_gw.select();
						f.p_ptp_gw.focus();
					} catch (e) {
					}
					return false;
			}
				
				if ((wan_ip & mask_ip) !== (gw_ip & mask_ip))
				{
					alert(sw("txtPPTPWANGwIp")+" "+integer_to_ipv4(gw_ip)+" "+sw("txtWithinWanSubnet"));
					return false;
				}
				if ((LAN_IP & LAN_MASK) == (wan_ip & LAN_MASK))
				{
					alert(sw("txtWanSubConflitLanSub"));
					return false;
				}
	}
	if (!is_ipv4_valid(f.pt_server.value)  || f.pt_server.value=="0.0.0.0" || is_FF_IP(f.pt_server.value)) {
			alert(sw("txtInvalidPPTPserverIPaddress") + f.pt_server.value);
			try	{
				f.pt_server.select();
				f.pt_server.focus();
			} catch (e) {
			}
				return false;
 	}	
		
		
	if (!is_digit(f.pt_mtu.value) || !is_in_range(f.pt_mtu.value, 128, 1400))
	{
		alert(sw("txtInvalidMTUSize")+"("+sw("txtPermittedRange")+sw("txtMtuRng128to1400")+")");
		field_focus(f.pt_mtu, "**");
		return false;
	}
	if (f.p_pt_conn_mode[0].checked)
	{
	}
	else if (f.p_pt_conn_mode[1].checked)
	{
	}
	else
	{
		if (!is_digit(f.pt_idletime.value))
		{
			alert(sw("txtInvalidIdleTime"));
			field_focus(f.pt_idletime, "**");
			return false;
		}
		if (!is_number(f.pt_idletime.value) || (f.pt_idletime.value>600 || f.pt_idletime.value<0)) {
			alert(sw("txtInvalidIdleTime")+"("+sw("txtPermittedRange")+sw("txtIdleRng0to600")+")");
		try	{
			f.pt_idletime.select();
			f.pt_idletime.focus();
			} catch (e) {
			}
			return false;
		}
	}
	
	
	final_f["ppp_schedule_control_0"].value = f.ptp_sch_name.value;
	final_f["config.wan_mtu"].value = f.pt_mtu.value;
	final_f["config.wan_primary_dns"].value = f.pt_dns1.value; 
	final_f["mac_clone"].value=get_by_id("wan_macAddr").value;
	final_f["wan_pptp_use_dynamic_carrier_radio"].value = f.ptp_ip_mode.value;
	final_f["config.wan_pptp_username"].value = f.pt_username.value;
	final_f["config.wan_pptp_password"].value = f.tmpt_password.value;
	final_f["pptp_reconnect_mode_radio"].value = f.ptp_reconnect_mode.value;
	final_f["config.wan_pptp_max_idle_time"].value = f.pt_idletime.value;
	final_f["config.wan_pptp_ip_address"].value = f.p_ptp_ip_address.value;
	final_f["config.wan_pptp_server"].value = f.pt_server.value;
	final_f["config.wan_pptp_subnet_mask"].value = f.p_ptp_netMask.value;
	final_f["config.wan_pptp_gateway"].value = f.p_ptp_gw.value;
	
	return true;
}

function check_l2tp()
	{
		var f		= get_by_id("formWlan");	
	var final_f= get_by_id("final_form");
	if (is_blank(f.l2_username.value))
	{
		alert(sw("txtInvalidUsername"));
		field_focus(f.l2_username, "**");
		return false;
		}
	if (!is_strvalid(f.l2_username.value))
	{
			alert(sw("txtInvalidUsername"));
			field_focus(f.l2_username, "**");
			return false;
		}

	if (!is_strvalid(f.tml2_password.value))
       {
                        alert(sw("txtInvalidPasswords"));
                        field_focus(f.tml2_password, "**");
                        return false;
        }
	if (f.tml2_password.value != f.l2_password_v.value)
	{
		alert(sw("txtThePasswordsDontMatch"));
		field_focus(f.tml2_password, "**");
		return false;
	}
	if(f.l2_dns1.value !=""){
			if (!is_ipv4_valid(f.l2_dns1.value) || is_FF_IP(f.l2_dns1.value) || ((ipv4_to_unsigned_integer(f.l2_dns1.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(f.l2_dns1.value) & 0x000000FF) == 0x00000000   )) {
				alert(sw("txtInvalidPPPoEPrimaryDNS") +  f.l2_dns1.value);
				try {
					f.l2_dns1.select();
					f.l2_dns1.focus();
				} catch (e) {
				}
				return false;
			}
		}
	if(f.pl2_ip_mode.value == "false" ) {
		var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
		var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
		var wan_ip = ipv4_to_unsigned_integer(f.p_pl2_ip_address.value);
		var mask_ip = ipv4_to_unsigned_integer(f.p_pl2_netMask.value);
		var gw_ip = ipv4_to_unsigned_integer(f.p_pl2_gw.value);
		var srv_ip = ipv4_to_unsigned_integer(f.l2_server.value);
			
		if (!is_ipv4_valid(f.p_pl2_ip_address.value) || f.p_pl2_ip_address.value.value=="0.0.0.0" || 	is_FF_IP(f.p_pl2_ip_address.value) || wan_ip == gw_ip || wan_ip == srv_ip) 
		{
			alert(sw("txtInvalidL2TPIP") + f.p_pl2_ip_address.value);
			try	{
					f.p_pl2_ip_address.select();
					f.p_pl2_ip_address.focus();
				} catch (e) {
				}
				return false;
		}
		if (!is_ipv4_valid(f.p_pl2_netMask.value) || !is_mask_valid(f.p_pl2_netMask.value)) {
				alert(sw("txtInvalidL2TPsubnetMask") + f.p_pl2_netMask.value);
				try	{
						f.p_pl2_netMask.select();
						f.p_pl2_netMask.focus();
					} catch (e) {
					}
					return false;
				}
		//||gw_ip == srv_ip ==> we accept the case when gw ip ==server ip		
			if (!is_ipv4_valid(f.p_pl2_gw.value) || 
				f.p_pl2_gw.value=="0.0.0.0" || 
				is_FF_IP(f.p_pl2_gw.value))
			{
					alert(sw("txtInvalidL2TPgatewayIP") + f.p_pl2_gw.value);
					try	{
						f.p_pl2_gw.select();
						f.p_pl2_gw.focus();
					} catch (e) {
					}
					return false;
			}
				
				if ((wan_ip & mask_ip) !== (gw_ip & mask_ip))
				{
					alert(sw("txtL2TPWANGwIp")+" "+integer_to_ipv4(gw_ip)+" "+sw("txtWithinWanSubnet"));
					return false;
				}
				if ((LAN_IP & LAN_MASK) == (wan_ip & LAN_MASK))
				{
					alert(sw("txtWanSubConflitLanSub"));
					return false;
				}
	}
	if (!is_ipv4_valid(f.l2_server.value)  || f.l2_server.value=="0.0.0.0" || is_FF_IP(f.l2_server.value)) {
			alert(sw("txtInvalidL2TPserver") + f.l2_server.value);
			try	{
				f.l2_server.select();
				f.l2_server.focus();
			} catch (e) {
			}
				return false;
 	}	
		
		
	if (!is_digit(f.l2_mtu.value) || !is_in_range(f.l2_mtu.value, 128, 1400))
	{
		alert(sw("txtInvalidMTUSize")+"("+sw("txtPermittedRange")+sw("txtMtuRng128to1400")+")");
		field_focus(f.l2_mtu, "**");
		return false;
	}
	if (f.p_l2_conn_mode[0].checked)
	{
	}
	else if (f.p_l2_conn_mode[1].checked)
	{
	}
	else
	{
		if (!is_digit(f.l2_idletime.value))
		{
			alert(sw("txtInvalidIdleTime"));
			field_focus(f.l2_idletime, "**");
			return false;
		}
		if (!is_number(f.l2_idletime.value) || (f.l2_idletime.value>600 || f.l2_idletime.value<0)) {
			alert(sw("txtInvalidIdleTime")+"("+sw("txtPermittedRange")+sw("txtIdleRng0to600")+")");
		try	{
			f.l2_idletime.select();
			f.l2_idletime.focus();
			} catch (e) {
			}
			return false;
		}
	}
	
	
	final_f["ppp_schedule_control_0"].value = f.pl2_sch_name.value;
	final_f["config.wan_mtu"].value = f.l2_mtu.value;
	final_f["config.wan_primary_dns"].value = f.l2_dns1.value; 
	final_f["mac_clone"].value=get_by_id("wan_macAddr").value;
	final_f["wan_l2tp_use_dynamic_carrier_radio"].value = f.pl2_ip_mode.value;
	final_f["config.wan_l2tp_username"].value = f.l2_username.value;
	final_f["config.wan_l2tp_password"].value = f.tml2_password.value;
	final_f["l2tp_reconnect_mode_radio"].value = f.pl2_reconnect_mode.value;
	final_f["config.wan_l2tp_max_idle_time"].value = f.l2_idletime.value;
	final_f["config.wan_l2tp_ip_address"].value = f.p_pl2_ip_address.value;
	final_f["config.wan_l2tp_server"].value = f.l2_server.value;
	final_f["config.wan_l2tp_subnet_mask"].value = f.p_pl2_netMask.value;
	final_f["config.wan_l2tp_gateway"].value = f.p_pl2_gw.value;
	
	return true;
}








function set_clone_mac(v) {
	var pcmac = "<% getInfo("host-hwaddr"); %>";
			
	get_by_id(v+"_mac"+1).value=pcmac.substring(0,2);
	get_by_id(v+"_mac"+2).value=pcmac.substring(3,5);
	get_by_id(v+"_mac"+3).value=pcmac.substring(6,8);
	get_by_id(v+"_mac"+4).value=pcmac.substring(9,11);
	get_by_id(v+"_mac"+5).value=pcmac.substring(12,14);
	get_by_id(v+"_mac"+6).value=pcmac.substring(15,17);
	
	}

function check_mac1(v){
		var tmp='';
		var blank = 0;
		var tmp_mac;		
		for(i=1; i<7; i++){
			if (is_blank(get_by_id(v+"_mac"+i).value)) blank++;
		}
		if (blank == 6) return true;
		
		tmp_mac=get_by_id(v+"_mac"+"1").value+':'+get_by_id(v+"_mac"+"2").value+':'+get_by_id(v+"_mac"+"3").value+':'+get_by_id(v+"_mac"+"4").value+':'+get_by_id(v+"_mac"+"5").value+':'+get_by_id(v+"_mac"+"6").value;		
		if(!is_mac_valid(tmp_mac, true)) {
			alert (sw("txtInvalidMACAddress") + tmp_mac + ".");
			return;
		}
		
		get_by_id("wan_macAddr").value='';
		for(i=1; i<7; i++){
			tmp = get_by_id(v+"_mac"+i).value;
			if (tmp.length==1) tmp="0"+tmp;		
			get_by_id("wan_macAddr").value+=tmp;
		}		
		return true;
	}
	
function check_wisp()
{
	var f=get_by_id("formWlan");
	var tmp = get_by_id("wan_type").value;
	var v='';
	
	if (tmp == "0") v="s";
	if (tmp == "1") v="d";
	if (tmp == "2") v="o";
	if (tmp == "3") v="p";
	if (tmp == "4") v="l";
		
	if (v=='') return false;
	if (!check_mac1(v)) return false;		


	switch (f.wan_type.value)
	{
		case "0":	return check_static();
		case "1":	return check_dhcp();
		case "2":	return check_pppoe();
		case "3":	return check_pptp();
		case "4": return check_l2tp();
	}
	return false;
}
function wds_saveChanges_mac()
{
  var wlanWdsGetNum = 0;
  var opmode = get_by_id("mode"); //-1:router; 0:ap; 1:client; 2:wds: 3:wds+ap; 5:wisp
  var num=0;

  if(opmode.value==3 || opmode.value==2 || opmode.value==6)
  {
  		get_by_id("wlanWdsEnabled").value='ON';
		get_by_id("addWdsMac").value='1';
        for (var i=0; i<=7; i++)
        {
            str_mac = "wdsMac"+i;
            str = get_by_id(str_mac).value;
            if(str.length == 0) continue;
            if(str.length != 12) 
            {
                get_by_id(str_mac).focus();
                alert(sw("txtInvalidMacLen"));
                return false;
            }
            for (var j=0; j<str.length; j++) {
                if ( (str.charAt(j) >= '0' && str.charAt(j) <= '9') ||
			        (str.charAt(j) >= 'a' && str.charAt(j) <= 'f') ||
			        (str.charAt(j) >= 'A' && str.charAt(j) <= 'F') )
			        continue;
                get_by_id(str_mac).focus();
	        alert(sw("txtInvalidMacAddr"));
	        return false;
            }
			num++;
        }
    }
	get_by_id("subsum").value=num;
	
    return true;
}
function check_wds_encrypt()
{
	var encrypt = get_by_id("encrypt0");
	var  wepKey= get_by_id("wepKey0");
	var  format= get_by_id("wdsformatMode");
	var  wdspskValue= get_by_id("wdspskValue0");
	
	if (encrypt.value ==1 || encrypt.value == 2)
	{
		if (wepKey.value=="*****" || wepKey.value=="")
		{
			alert(sw("txtWdsError1"));
			return 0;	
		}
	}

	if(wepKey.value.length == 10 || wepKey.value.length == 26)
	{
		format.value="1";
	}else{
		format.value="0";
	}
	
	if(encrypt.value == 1)//64 bit
	{
		if(format.value == 1)//Hex
		{
			if(is_hexdigit(wepKey.value) ==false)
			{
				alert(sw("txtWdsError2"));
				wepKey.focus();
				return 0;
			}	
			if(wepKey.value.length !=10 ){
				alert(sw("txtWdsError3"));
				wepKey.focus();
				return 0;
			}	
		}
		if(format.value == 0)//asc
		{
			if(wepKey.value.length !=5 )
			{
				alert(sw("txtWdsError4"));
				wepKey.focus();
				return 0;
			}
		}
	}
	if(encrypt.value == 2)//128 bit
	{
		if(format.value == 1)//Hex
		{
			if(is_hexdigit(wepKey.value) ==false)
			{
				alert(sw("txtWdsError2"));
				wepKey.focus();
				return 0;
			}	
			if(wepKey.value.length !=26){
				alert(sw("txtWdsError5"));
				wepKey.focus();
				return 0;
			}	
		}
		if(format.value == 0)//asc
		{
			if(wepKey.value.length !=13 )
			{
				alert(sw("txtWdsError6"));
				wepKey.focus();
				return 0;
			}
		}
	}
	if(encrypt.value >= 3)//3: wpa, 4: wpa2
	{
		if(wdspskValue.value.length <= 0)
		{
			alert(sw("txtWdsError1"));
			wdspskValue.focus();
			return 0;	
	
		}
		if(wdspskValue.value.length <8 || wdspskValue.value.length >64)
		{
			alert(sw("txtWdsError7"));
			wdspskValue.focus();
			return 0;
		}
		if(strchk_unicode(wdspskValue.value))
		{
			alert(sw("txtWdsError8"));
			wdspskValue.focus();
			return 0;
		}
		if(wdspskValue.value.length == 64)	
		{
			if(is_hexdigit(wdspskValue.value) == false)
			{
				alert(sw("txtWdsError2"));
				wdspskValue.focus();
				return 0;
			}
		}				
	}	
	return 1;					
}
/*disable item for each opmode*/
function dis_security_item()
{	
	var f = get_by_id("formWlan");
	f.security_type.disabled = true;
	f.auth_type.disabled = true;
	f.wep_key_len.disabled = true;
	f.wep_key_type.disabled = true;
	f.wep_def_key.disabled = true;
	for(i=1;i<5;i++)
		f["key_name_"+i].disabled = true;
	f.cipher_type.disabled = true;
	f.psk_eap.disabled = true;
	f.wpapsk1.disabled = true;
	f.wpa_key_type.disabled = true;
	f.srv_ip1.disabled = true;
	f.srv_port1.disabled = true;
}
function dis_wds_item()
{
	var f = get_by_id("formWlan");
	f.subsum.disabled = true;
	f.wlanWdsEnabled.disabled = true;
	f.addWdsMac.disabled = true;
	f.wdsMacStr.disabled = true;
	f.wdspskFormat0.disabled = true;
	for(i=0;i<8;i++)
	 	f["wdsMac"+i].disabled = true;
	f.encrypt0.disabled = true;
	f.wdsformatMode.disabled = true;
	f.wdswepKey0.disabled = true;
	f.wdspskValue0.disabled = true;
}

function WDS_verify()
{
	if(!check_wds_encrypt())
	{
		return 0;
	}
	for(var i=1;i<9;i++)
	{
		if(get_by_id("wdsMac"+i+"0").value=="")
		{
			continue;
		}
		for(var j=1; j<9 ;j++)
		{
			if(i==j || get_by_id("wdsMac"+j+"0").value=="")
			{
				continue;
			}
			if(get_by_id("wdsMac"+j+"0").value == get_by_id("wdsMac"+i+"0").value)
			{
				alert("Item "+i+" conflict with item "+j+".");
				get_by_id("wdsMac"+j+"0").select();
				get_by_id("wdsMac"+j+"0").focus();
				return false;
			}
		
		}
		if(!verify_mac(get_by_id("wdsMac"+i+"0").value,get_by_id("wdsMac"+i+"0")))
		{
			alert (sw("txtInvalidMACAddress") + get_by_id("wdsMac"+i+"0").value + ".");
			get_by_id("wdsMac"+i+"0").select();
			get_by_id("wdsMac"+i+"0").focus();
			return false;
		}
		else
		{
			get_by_id("wdsMac"+i+"0").value = get_by_id("wdsMac"+i+"0").value.toUpperCase();
			var mac_addr = get_by_id("wdsMac"+i+"0").value.split(":");
			get_by_id("wdsMac_"+i).value = "";
			for(var j=0;j<mac_addr.length;j++)
			{
				get_by_id("wdsMac_"+i).value += mac_addr[j];
			}
			
			document.forms["final_form"]["f_wdsMac_"+i].value = get_by_id("wdsMac_"+i).value;
			
		}
	}

	if(get_by_id("wdspskValue0").value.length==64){
               get_by_id("wdsPskFormat").value="1";
        }else{
		get_by_id("wdsPskFormat").value="0";
	}

	if(get_by_id("encryptMode").value==1 || get_by_id("encryptMode").value==2 ||
		get_by_id("encryptMode").value==3 || get_by_id("encryptMode").value==4) { 
		var key_type;
		if(get_by_id("encryptMode").value==2) 
		{
			test_wep_obj=get_by_id("wepKey0");
			if(test_wep_obj.value.length!=13 && test_wep_obj.value.length!=26)
			{
				alert(sw("txtInvalidKeyforwep128"));
				test_wep_obj.select();
				return false;
			}
				
			key_type=(test_wep_obj.value.length==13?1:2);
			if(chk_wepkey("wepKey0", key_type, test_wep_obj.value.length)==false)	return false;
						}
		else if(get_by_id("encryptMode").value == 1)
		{
			test_wep_obj=get_by_id("wepKey0");
			if(test_wep_obj.value.length!=5 && test_wep_obj.value.length!=10)
			{
				alert(sw("txtInvalidKeyforwep64"));
				test_wep_obj.select();
				return false;
					}
			key_type=(test_wep_obj.value.length==5?1:2);
			if(chk_wepkey("wepKey0", key_type, test_wep_obj.value.length)==false)	return false;
		}
	
		
		document.forms["final_form"]["f_wds_wds_formateMode"].value = key_type-1;
		document.forms["final_form"]["f_wds_wepKey"].value = get_by_id("wepKey0").value;
		document.forms["final_form"]["f_wds_pskFormat"].value = get_by_id("wdsPskFormat").value;
		document.forms["final_form"]["f_wds_wdspskValue"].value = get_by_id("wdspskValue0").value;
	}		
	document.forms["final_form"]["f_wds_encryptMode"].value = get_by_id("encryptMode").value;
	return true;
}
		
/*
 * is_wlan_settings_modified
 *	Check if a form's current values differ from saved values in custom attribute.
 *	Function skips elements with attribute: 'modified'= 'ignore'. 
 */
function is_wlan_settings_modified(form_id)
{
	var df = document.forms[form_id];
	if (!df) {
		return false;
	}
	if (df.getAttribute('modified') == "true") {
		return true;
	}
	if (df.getAttribute('saved') != "true") {
		return false;
	}

	for (var i = 0, k = df.elements.length; i < k; i++) {
		var obj = df.elements[i];
		if (obj.getAttribute('modified') == 'ignore') {
			continue;
		}
		var name = obj.tagName.toLowerCase();
		if (name == 'input') {
			var type = obj.type.toLowerCase();
			if (((type == 'text') || (type == 'textarea') || (type == 'password') || (type == 'hidden')) &&
					!are_values_equal(obj.getAttribute('default'), obj.value)) {

				return true;
			} else if (((type == 'checkbox') || (type == 'radio')) && !are_values_equal(obj.getAttribute('default'), obj.checked)) {
	
				return true;
			}
		} else if (name == 'select') {
			var opt = obj.options;
			for (var j = 0; j < opt.length; j++) {
				if (!are_values_equal(opt[j].getAttribute('default'), opt[j].selected)) {
			
					return true;
				}
			}
		}
	}
	return false;
}
function LanNetwork_Eq_WanNetwork()
{
    var wan_ip="0.0.0.0";
    var wan_mask="0.0.0.0";
    var wan_type="<%getInfo("wanType");%>";//0 static wan
	var lan_ip = '<% getInfo("ip-rom"); %>';
	var lan_mask = '<% getInfo("mask-rom"); %>';
    if(wan_type == "0")
    {
        wan_ip="<% getInfo("wan-ip-rom");%>";
        wan_mask="<% getInfo("wan-mask-rom");%>";
    }else if(wan_type == "2" && "false" == "<%getIndexInfo("pppoe_wan_ip_mode");%>")
    {
        wan_ip="<% getInfo("pppoe-wan-ip-rom");%>";
        wan_mask="255.255.255.255";
    }
    else if(wan_type == "3" && "false" == "<%getIndexInfo("pptp_wan_ip_mode");%>")
    {
        wan_ip="<% getInfo("pptpIp"); %>";
        wan_mask="<% getInfo("pptpSubnet"); %>";
    }else if(wan_type == "4" && "false" == "<%getIndexInfo("l2tp_wan_ip_mode");%>")
    {
        wan_ip="<% getIndexInfo("l2tpIp"); %>";
        wan_mask="<% getIndexInfo("l2tpSubnet"); %>"
    }
    if(wan_ip != "0.0.0.0" && wan_mask != "0.0.0.0" && lan_ip != "0.0.0.0" && lan_mask != "0.0.0.0")
    {
        var mask_tmp=lan_mask;
        if(ipv4_to_unsigned_integer(lan_mask) > ipv4_to_unsigned_integer(wan_mask))
        {
            mask_tmp=wan_mask;
        }
        if (is_valid_ip2(lan_ip, mask_tmp, wan_ip))
        {
            alert("WAN IP:" + wan_ip + "/" + wan_mask + ", LAN IP:" + lan_ip + "/" + lan_mask + "." + sw("txtWanSubConflitLanSub") + sw("txtChangeLanToAnotherNetwork"));
            return true;
        }
    }
	return false;
}
/* apply function */
function strchk_special(str)
{
        var strlen=str.length;
        if(strlen>0)
        {
        				var c = '';
                for(var i=0;i<strlen;i++)
                {   
                				c = escape(str.charAt(i));             
                  			if(c.charAt(0) == '%' && c.charAt(1)=='B' && c.charAt(2)=='7')
                          return true;
                }
        
        }
        return false;
}
function page_submit()
{
	if (is_wlan_settings_modified("formWPS"))
	{
		if(get_by_id("security_type").value >= 2 
			&& get_by_id("psk_eap").value == 1
				&& get_by_id("wifisc_enable_select").checked == true) {
			alert(sw("txtWPSCantWorkAtWPAEAPMode"));
			get_by_id("wifisc_enable_select").focus();				
			return false;
		}		
		get_by_id("formWPS").settingsChanged.value = 1;
	}
	
//	if (!is_wlan_settings_modified("formWlan") && !is_wlan_settings_modified("formWDS")) 
//	{
//	}
//	else
	{
		var f = get_by_id("formWlan");
		var opmode = get_by_id("mode"); //-1:router; 0:ap; 1:client; 2:wds: 3:wds+ap; 5:wisp
		var save_button = get_by_id("apply");
		var cancel_button = get_by_id("cancel");
		
//------------------- 605like check start-------------------------------->
		{
	var f =get_by_id("formWlan");
	var f_wps =get_by_id("formWPS");
	var f_final	=get_by_id("final_form");
	
	f_final.f_wireless_mode.value			="";
	f_final.f_enable.value			="";
	f_final.f_wps_enable.value		="";
	
	f_final.f_ssid.value			="";
	f_final.f_channel.value			="";
	f_final.f_auto_channel.value	="";
	f_final.f_ap_hidden.value		="";
	f_final.f_authentication.value	="";
	f_final.f_wep_auth_type.value	="";
	f_final.f_cipher.value			="";
	f_final.f_wep_len.value			="";
	f_final.f_wep_format.value		="";
	f_final.f_wep_def_key.value		="";
	f_final.f_wep.value				="";
	f_final.f_wpa_psk_type.value	="";
	f_final.f_wpa_psk.value			="";
	f_final.f_radius_ip1.value		="";
	f_final.f_radius_port1.value	="";
	f_final.f_radius_secret1.value	="";

//boer flag
        if(get_by_id("wifisc_enable_select").checked == true){//aphidden
               if(f.aphidden.checked == true){
                       get_by_id("formWPS").settingsChanged.value = 1;
                       if (!confirm(sw("wps_aphidden"))) {
                               return false;
                       }
			wifisc_enable_selector(false);//config.wifisc.enabled
               }

               if(f.security_type.value=="1"){
                       get_by_id("formWPS").settingsChanged.value = 1;
                       if (!confirm(sw("wps_wepmode"))) {
                               return false;
                       }
			wifisc_enable_selector(false);//config.wifisc.enabled
               }

               if((f.cipher_type.value == 1) && (f.security_type.value>="2")){
                       get_by_id("formWPS").settingsChanged.value = 1;
                       if(!confirm(sw("wps_wapmode"))) {
                               return false;
                       }
			wifisc_enable_selector(false);//config.wifisc.enabled
               }
		if(f.security_type.value=="2"){
			get_by_id("formWPS").settingsChanged.value = 1;
			if (!confirm(sw("wps_wpamode"))) {
				return false;
			}
			wifisc_enable_selector(false);//config.wifisc.enabled
		}
        }
	f_final.f_wireless_mode.value = f.mode.value;
	if((f.mode.value == 2 || f.mode.value == 3 || f.mode.value == 6 || f.mode.value == 7) && !WDS_verify()) //WDS or WDS+AP or WDS+Router or WDS+AP+Router
	{
				return false;
	}
	if(f.mode.value == 5)  //wisp
	{
		if (!check_wisp()) 
			return false;
	}else if(f.mode.value == -1)
	{
		if(LanNetwork_Eq_WanNetwork())	
		{
			return false;
		}
	}
	
	
	if(f.wireless_radio_control_select.checked)	
	{	
		f_final.f_enable.value="1";	
	}
	else
	{	
	
		f_final.f_enable.value="0";		
		//return f_final.submit();
	}

	f_final.f_wps_enable.value		=(f_wps.wifisc_enable.checked ? 1:0);


	if(get_by_id("security_type").value >= 2 
		&& get_by_id("psk_eap").value == 1
		&& get_by_id("wifisc_enable_select").checked == true)
	{
		alert(sw("txtWPSCantWorkAtWPAEAPMode"));
		get_by_id("security_type").focus();				
		return false;
	}
	
	if(is_blank(f.ssid.value))
	{
		alert(sw("txtSSIDBlank"));
		f.ssid.focus();
		return false;
	}
	
	if(strchk_unicode(f.ssid.value))
	{
		alert(sw("txtInvalidSSID"));
		f.ssid.select();
		return false;
	}

	if(strchk_special(f.ssid.value))
	{
		alert(sw("txtInvalidSSID"));
		f.ssid.select();
		return false;
	}
	
	// assign final post variables
	f_final.f_ssid.value			=f.ssid.value;
	f_final.f_channel.value			=f.channel_1.value;
	f_final.f_auto_channel.value	=(f.channel_2.checked ? "1":"0");
	f_final.f_wmm_enable.value		=(f.wmm.checked ? "1":"0");
	f_final.f_ap_hidden.value		=(f.aphidden.checked ? "1":"0");
	//open
	if(f.security_type.value=="0")
	{
		// assign final post variables
		f_final.f_authentication.value=0;
		f_final.f_cipher.value="0";
//boer flag
               if(get_by_id("wifisc_enable_select").checked == true && get_by_id("wireless_radio_control_select").disabled == false){
                       if (!confirm(sw("wps_nosecurity")))
                               return false;
               }
				}
	// open+wep / shared key
	else if(f.security_type.value=="1")
	{
		//kwest mark
		var wlanmode = "7";
		var test_len=10;
		var test_wep_obj;
		var key_type;

		if(wlanmode == "4")
		{
			alert(sw("txtCannotUseWEPfor11N"));
			page_load();
			return false;
						}
		if(f.wep_key_len.value==1) // 0:64 ; 1:128
		{
			test_wep_obj=get_by_id("wepkey_128");
			if(test_wep_obj.value.length!=13 && test_wep_obj.value.length!=26)
			{
				alert(sw("txtInvalidKeyforwep128"));
				test_wep_obj.select();
				return false;
					}
				
			key_type=(test_wep_obj.value.length==13?1:2);
			if(chk_wepkey("wepkey_128", key_type, test_wep_obj.value.length)==false)	return false;
						}
		else
		{
			test_wep_obj=get_by_id("wepkey_64");
			if(test_wep_obj.value.length!=5 && test_wep_obj.value.length!=10)
			{
				alert(sw("txtInvalidKeyforwep64"));
				test_wep_obj.select();
				return false;
					}
			key_type=(test_wep_obj.value.length==5?1:2);
			if(chk_wepkey("wepkey_64", key_type, test_wep_obj.value.length)==false)	return false;
		}
		f_final.f_wep.value=test_wep_obj.value;
		
		// assign final post variables
		f_final.f_authentication.value	= 1;
		f_final.f_wep_auth_type.value = f.auth_type.value;
		f_final.f_cipher.value			="1";
		f_final.f_wep_len.value			=f.wep_key_len.value;
		f_final.f_wep_format.value		=key_type;
		f_final.f_wep_def_key.value		=f.wep_def_key.value;
	}
	// wpa series 
	else if(f.security_type.value>="2")
	{
		var lan_ip_str = "<% getInfo("ip-rom"); %>";
		var lan_mask_str = "<% getInfo("mask-rom"); %>";

		f_final.f_authentication.value=f.security_type.value;
		if(f.psk_eap.value==1)
		{		
			if(!is_valid_ip(f.srv_ip1.value,0) || !is_valid_gateway(lan_ip_str,lan_mask_str,f.srv_ip1.value))
			{		
				alert(sw("txtInvalidRadiusIP"));
				f.srv_ip1.select();
				return false;
			}
			if(is_blank(f.srv_port1.value))
			{
				alert(sw("txtInvalidRadiusPort"));
				f.srv_port1.focus();
				return false;
			}
			if(!is_port_valid(f.srv_port1.value))
			{
				alert(sw("txtInvalidRadiusPort"));
				f.srv_port1.select();
				return false;
			}
			if(is_blank(f.srv_sec1.value))
			{
				alert(sw("txtRadiusSecretCannotEmpty"));
				f.srv_sec1.focus();
				return false;
			}
			if(strchk_unicode(f.srv_sec1.value))
			{
				alert(sw("txtRadiusSecretShouldbeAscii"));
				f.srv_sec1.select();
				return false;
			}
				
			// assign final post variables
			f_final.f_cipher.value			=f.cipher_type.value;
			f_final.f_radius_ip1.value		=f.srv_ip1.value;
			f_final.f_radius_port1.value	=f.srv_port1.value;
			f_final.f_radius_secret1.value	=f.srv_sec1.value;
			f_final.f_wpa_psk_type.value=1;
			}
			else
			{
				if(f.wpapsk1.value.length == 64)
				{
					var test_char,j;
					for(j=0; j<f.wpapsk1.value.length; j++)
					{
						test_char=f.wpapsk1.value.charAt(j);
						if( (test_char >= '0' && test_char <= '9') ||
								(test_char >= 'a' && test_char <= 'f') ||
								(test_char >= 'A' && test_char <= 'F'))
							continue;
					
						alert(sw("txtPSKShouldbeHex"));
						f.wpapsk1.select();
						return false;
					}
				}
				else if(f.wpapsk1.value.length >=8 && f.wpapsk1.value.length <64)
                               {
                             		if(f.wpapsk1.value.charAt(0) == ' '||f.wpapsk1.value.charAt(f.wpapsk1.value.length-1) ==' ')
                                                {
                                                        alert(sw("txtheadtailnospeace"));
                                                        f.wpapsk1.select();
                                                        return false;
                                                }
					if(strchk_unicode(f.wpapsk1.value))
		    			{
						alert(sw("txtPSKShouldbeAscii"));
						f.wpapsk1.select();
						return false;
					}
                                }
				else
				{
					if(f.wpapsk1.value.length <8 || f.wpapsk1.value.length > 63)
					{
						alert(sw("txtInvalidPSKLen"));
						f.wpapsk1.select();
						return false;
		    			}
					if(strchk_unicode(f.wpapsk1.value))
		    			{
						alert(sw("txtPSKShouldbeAscii"));
						f.wpapsk1.select();
						return false;
					}
					
	    	}	
		
			// assign final post variables
			
			f_final.f_cipher.value=f.cipher_type.value;
			f_final.f_wpa_psk.value=f.wpapsk1.value;
			f_final.f_wpa_psk_type.value=2;
	    }	
		}
	else
		{
		alert("Unknown Authentication Type.");
		return false;
	}
		
	
	
}
	f_final.settingsChanged.value = 1;
//<----------------------------605like check End-----------------------
		
	}
	//document.formWPS.submit();//boer
	doCheckSubmit();
	
	//if(get_by_id("final_form").settingsChanged.value == 1)
		//get_by_id("final_form").submit();
	
	return;
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
/** Enable or disable subnavigation links depending on feature options. */
SubnavigationLinks(WLAN_ENABLED, OP_MODE);
topnav_init(document.getElementById("topnav_container"));
RenderWarnings();
var WLAN_WARN="0";
document.getElementById("warnings_section").style.display = (WLAN_WARN  == "1") ? "block"  : "none";

get_by_id("wifisc_get_new_pin_button").value = sw("txtGenerateNewPIN");
get_by_id("wifisc_reset_pin_button").value = sw("txtResetPINtoDefault");
get_by_id("wifisc_reset_unconfig_btn").value = sw("txtResettoUnconfigured");
get_by_id("wifisc_add_sta_start_button").value = sw("txtAddWirelessDeviceWithWPS");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");
get_by_id("wifisc_er_unlock_button").value = "WPS-PIN UnLock";
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");

displayOnloadPage("<%getInfo("ok_msg")%>");


}


/*
* Selectors.
*/
function wifisc_pinlock_selector(checked)
{
	get_by_id("wifisc_pinlock").value = checked ? "true" : "false";
	get_by_id("wifisc_pinlock_select").checked = checked;
}
function wifisc_enable_selector(checked)
{

//if(get_by_id("security_type").value != 0 
//	&& get_by_id("security_type").value != 1 
//	&& get_by_id("wireless_ieee8021x_enabled").value == 'true'
//	&& checked == true)
//{
//	alert(sw("txtWPSCantWorkAtWPAEAPMode"));
//	get_by_id("wifisc_enable_select").checked = false;
//	return false;
//}
//boer flag
       if(checked == true){
//               if(get_by_id("mac_filter_mode").value == "1" || get_by_id("mac_filter_mode").value == "2"){
if(get_by_id("mac_filter_mode").value == "2"){
                       alert(sw("wps_wireless_aclfilter"));
                       get_by_id("wifisc_enable_select").checked = false;
                       return false;
               }

               if(get_by_id("aphidden").checked == true){
                       alert(sw("aphidden_wps"));
                       get_by_id("wifisc_enable_select").checked = false;
                       return false;
               }
               if((get_by_id("cipher_type").value == "1") && (get_by_id("security_type").value>="2")){
                       alert(sw("wapmode_wps"));
                       get_by_id("wifisc_enable_select").checked = false;
                       return false;
               }
               if(get_by_id("security_type").value=="1"){
                       alert(sw("wepmode_wps"));
                       get_by_id("wifisc_enable_select").checked = false;
                       return false;
               }
		if(get_by_id("security_type").value=="2"){
			alert(sw("wpamode_wps"));
			get_by_id("wifisc_enable_select").checked = false;
			return false;
		}
       }


var wep_auth = "<%getIndexInfo("wep_auth");%>";

if(wep_auth == 2 && checked == true && get_by_id("auth_type").value == 2 && get_by_id("security_type").value == 1)
{
	alert(sw("txtShareKeyCantWorkAtWPAEAPMode"));
	get_by_id("wifisc_enable_select").checked = false;
	return false;
}
					
get_by_id("wifisc_enable").value = checked ? "true" : "false";
get_by_id("wifisc_enable_select").checked = checked;

if(get_by_id("wifisc_enable").value == 'true')
{
	get_by_id("auth_type").value = 1; //open
	chg_wep_auth_type(get_by_id("auth_type").value);	
	get_by_id("auth_type").disabled = true;
}
else
{
	get_by_id("auth_type").disabled = false;
}
	
disable_all_wps_buttons(!checked);
}

/*
*  Get the PIN currently in use, we do not read directly from the config data structure
*  Because the PIN in use may be a newly generated one and have not been updated to config data structure yet.
*/
var wifisc_current_pin = "<%getInfo("wscLoocalPin");%>";

//var wifisc_pin_retriever = null;

function disable_all_wps_buttons(disabled)
{
disable_form_field(get_by_id("wifisc_get_new_pin_button"), disabled);
disable_form_field(get_by_id("wifisc_reset_pin_button"), disabled);
disable_form_field(get_by_id("wifisc_add_sta_start_button"), disabled);
	disable_form_field(get_by_id("wifisc_pinlock_select"), disabled);

	if(get_by_id("wireless_radio_control").value == 0){
		disable_form_field(get_by_id("wifisc_reset_unconfig_btn"), true);
	}else if(get_by_id("wifisc_enable_select").checked == false){
		disable_form_field(get_by_id("wifisc_reset_unconfig_btn"), true);
	}else{
		disable_form_field(get_by_id("wifisc_reset_unconfig_btn"), ("<%getIndexInfo("wscConfig");%>" == "0" || get_by_id("wireless_radio_control").value == 0));
	}
}

function do_wps_request(act)
{
	if (act == 1) {
		if (!confirm (sw("txtProtectedSetupStr1") 
			+ "\n" + 
			sw("txtProtectedSetupStr2"))) {
			return;
		}
	}
	else if (act == 2) {
		if (!confirm (sw("txtProtectedSetupStr8"))) {
			return;
		}	
	}
	else if (act == 3) {
		if (!confirm (sw("txtProtectedSetupStr9"))) {
			return;
		}	
	}	
	else if (act == 4) {
		var time_now=new Date().getTime();
		if (is_wlan_settings_modified("formWPS") || is_wlan_settings_modified("formWlan")) {
			alert(sw("txtWizardAddWlanDeviceStr17"));
			return;
		}
		top.location = "./Wizard_Add_Wireless_Device.asp?t="+time_now;
		return;
	}
	else if (act == 5) {
		
	}
	get_by_id("wps_act").value = act;
	get_by_id("formWPS").settingsChanged.value = 1;		
	//get_by_id("formWPS").submit();//boer
	doCheckSubmit();
	//get_by_id("final_form").submit();
}

function wifisc_pin_ready(dataInstance)
{
var pin = dataInstance.getElementData("pin");
wifisc_current_pin_selector(pin);


disable_all_wps_buttons(get_by_id("wifisc_enable").value == "false");
}

function wifisc_current_pin_selector(pin)
{

get_by_id("wifisc_current_pin").innerHTML =  pin;
get_by_id("wifisc_pin").value = pin;
}

function on_off_wmm(selectValue)
{
	get_by_id("wmm").checked = selectValue;
	if (selectValue == true)
		get_by_id("wmm").value = 1;
	else
		get_by_id("wmm").value = 0;	
}

function print_keys(key_name, max_length)
{
	var str="";
	var key_value="";
	var field_size=decstr2int(max_length)+5;
	var hint_wording;
	if(get_by_id("wireless_wep_key_len").value == 0 && max_length == "10") // 64
	{
		key_value = "<%getIndexInfo("wepDefKey");%>";
		if(key_value == "00000000000000000000000000" || key_value == "0000000000")
		{
			key_value="";
		}
	}
	else if(get_by_id("wireless_wep_key_len").value == 1 && max_length == "26") // 128
	{
		key_value = "<%getIndexInfo("wepDefKey");%>";
		if(key_value == "00000000000000000000000000" || key_value == "0000000000")
		{
			key_value="";
		}
	}
	if(max_length=="10")	{hint_wording=sw("txt5AOr10H");}
	else					{hint_wording=sw("txt13AOr26H");}
	str="<table>";
	str+="\t<tr>";
	str+="\t\t<td class='r_tb' width='200'>WEP"+sw("txtPassword")+"</td>";
	str+="\t\t<td class='l_tb'>:&nbsp;&nbsp;"
	str+="<input type='text' id='"+key_name+"' name='"+key_name+"' maxlength='"+max_length+"' size='"+field_size+"' value='"+ key_value +"'>&nbsp;"+hint_wording+"</td>";
	str+="\t</tr>";
	str+="</table>";
	document.write(str);
}
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load();page_load();web_timeout();" topmargin="1" leftmargin="0" rightmargin="0" bgcolor="#757575">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr><td>
<SCRIPT>
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr>	<td id="sidenav_container"><div id="sidenav">
<SCRIPT>
DrawBasic_subnav();
DrawAdvanced_subnav();
DrawTools_subnav();
DrawStatus_subnav();
DrawHelp_subnav();
DrawEarth_onlineCheck(<%getWanConnection("");%>);
DrawRebootButton();
</SCRIPT></div>
 <!-- 								
<SCRIPT>DrawLanguageList();</SCRIPT>
 --> 
</td>
<td id="maincontent_container">
<SCRIPT>DrawRebootContent("bridge");</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" >	<div class="section_head">
<h2><SCRIPT>ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
<p>
	<b><SCRIPT>ddw("txtCommWarnStr1");</SCRIPT></b>
</p>
<p>
	<SCRIPT>ddw("txtCommWarnStr2");</SCRIPT>
</p>
<UL><LI><p>
	<SCRIPT>ddw("txtWlanWarnStr1");</SCRIPT>
</p></LI></UL>
<p>
	<SCRIPT>ddw("txtCommWarnStr3");</SCRIPT>
</p></div><!-- box warnings_section_content --></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
		<form name="formWPS" id="formWPS" method="post" action="/goform/formWPS">		
			<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
			<input type="hidden" id="webpage" name="webpage" value="/Basic/Wireless.asp">
			<input type="hidden" id="wps_act"  name="wps_act" value="0"/>			
<!--			<input type="hidden" id="mac_filter_mode" name="macFltMode" value="<% getInfo("macFltMode");%>" /> -->
<input type="hidden" id="mac_filter_mode" name="macFltMode" value="<% getInfo("aclFltMode");%>" />

			<div class="section"><div class="section_head">
			<h2><SCRIPT>ddw("txtWireless");</SCRIPT></h2>
			<p>	<SCRIPT>ddw("txtWirelessStr2");</SCRIPT></p>
			<SCRIPT>DrawSaveButton();</SCRIPT>
			</div>
				<div class="box" id="wifisc_hidden">
			<h2><SCRIPT>ddw("txtWiFiProtectedSetup");</SCRIPT></h2>
			<table cellpadding="1" cellspacing="1" border="0" width="525">
			<tr>
				<td class='r_tb' width='200'><SCRIPT >ddw("txtEnable");</SCRIPT></td>
				<input type="hidden" id="wifisc_enable" name="config.wifisc.enabled" value="<%getIndexInfo("wsc_enabled");%>"/>			
				<td class='l_tb'> :&nbsp;				
				<input id="wifisc_enable_select" onclick="wifisc_enable_selector(this.checked);" type="checkbox" />
				</td>
			</tr>
			<tr>
				<input type="hidden" id="wifisc_pin" name="config.wifisc.pin" value="<%getInfo("wscLoocalPin");%>"/>
				<td class='r_tb' width='200'><SCRIPT >ddw("txtCurrentPIN");</SCRIPT></td>
				<td class='l_tb'> :&nbsp;<b><span id="wifisc_current_pin" class="output">&nbsp;</span></b>
				</td>
			</tr>
			<tr>
				<td class='r_tb' width='200'></td>
				<td class='l_tb'>
				<input type=button id="wifisc_get_new_pin_button" value="" onclick="do_wps_request(2);">
				&nbsp;
				<input type=button id="wifisc_reset_pin_button" value="Reset PIN to Default" onclick="do_wps_request(3);">
				</td>
			</tr>
			<tr>
				<td class='r_tb' width='200'><SCRIPT >ddw("txtWiFiProtectedStatus")</SCRIPT></td>
				<td class='l_tb'> &nbsp;<span id="wps_status"></span>					
				</td>
			</tr>
			<tr>
				<td class='r_tb' width='200'></td>
				<td class='l_tb'>
				<input type="hidden" id="wifisc_ap_locked" name="config.wifisc.ap_locked" value="<%getIndexInfo("wsc_locked");%>"/>
				<input type=button id="wifisc_reset_unconfig_btn" value="" onclick="do_wps_request(1)">
				</td>
			</tr>
			<tr style="display: none">
				<td class='r_tb' width='200'><SCRIPT >ddw("txtWiFiPinLock")</SCRIPT></td>
				<input type="hidden" id="wifisc_pinlock" name="config.wifisc_pinlock.enabled" value="<%getIndexInfo("wps_WebPinLock");%>"/>
				<td class='l_tb'> :&nbsp;<input id="wifisc_pinlock_select" onclick="wifisc_pinlock_selector(this.checked);" type="checkbox" /></td>
			</tr>
			<tr>
				<td class='r_tb' width='200'></td>
				<td class='l_tb'>
				<input type=button id="wifisc_add_sta_start_button" value="" onclick="return do_wps_request(4)">
				</td>
			</tr>
			<tr>
				<td class='r_tb' width='200'></td>
				<td class='l_tb'>
				<input type="hidden" id="wifisc_er_lock_state" value="<%getIndexInfo("lockdown_stat");%>"/>
				<input type="hidden" id="wifisc_er_unlock" name="config.wifisc.er_unlock" value="false"/>
				<input type=button id="wifisc_er_unlock_button" value="" onclick="return do_wps_request(5)">
				</td>
			</tr>

			</table>
		</div>
	</form>
	<form name="formWlan" id="formWlan" method="post" action="">
	   
      <DIV class=box>
      <H2><SCRIPT>ddw("txtWirelessNetworkSettings");</SCRIPT></H2>
      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0>
        <TBODY>
			<TR>

				<input id=op_mode type="hidden" name="op_mode" value=0>			
				 <input id=ap_gw type = "hidden" name="ap_gw" value =0>
				<TD class=r_tb width=200><SCRIPT>ddw("txtWirelessMode");</SCRIPT></TD>
				<TD class=l_tb>:&nbsp;
				<input type="hidden" id="wireless_mode" name="wireless_mode" value="<%getIndexInfo("wlanMode");%>" />
				<select id=mode name="mode0" onChange="on_change_op_mode(this .value)" >
				<option value=-1 >Wireless Router </option>
				<option value=0 selected>Access Point </option>
<!--			<option value=1 >Wireless Client </option>-->
				<option value=2 >WDS Only </option>
				<option value=3 >WDS+AP </option>

<option value=7 >WDS+AP+Router </option>

<!--		<option value=5 >WISP </option>-->
				</select>
				</TD>
			</TR>

        <TR>
        	<input type="hidden" id="wireless_radio_control" name="config.wireless.radio_control" value="<%getIndexInfo("wlanEnabled")%>"/>
          <TD class=r_tb width=200><SCRIPT>ddw("txtEnableWireless");</SCRIPT></TD>
          <TD class=l_tb>:&nbsp; 
		  <INPUT id=wireless_radio_control_select name="wireless_radio_control_select" value= 0  onclick=wireless_radio_control_selector(this.checked) type=checkbox> 
          </TD>
        <TR>
 	
          <TD class=r_tb width=200><SCRIPT>ddw("txtWirelessNetworkNameSSID");</SCRIPT></TD>
          <TD class=l_tb>:&nbsp;&nbsp; <INPUT id=ssid maxLength=32 name="ssid0"  value="<%getInfo("ssid");%>"> 
            &nbsp;<SCRIPT>ddw("txtAlsoCallSSID");</SCRIPT> </TD>

        </TR>
        <TR>
					<input type="hidden" id="wireless_auto_channel" name="config.wireless.auto_channel" value="<%getIndexInfo("autoChan");%>"/>
          <TD class=r_tb width=200><SCRIPT>ddw("txtEnableAutoChannelScan");</SCRIPT></TD>
          <TD class=l_tb>:&nbsp; 
				<input type="checkbox" id="channel_2" value="0"  onClick="chan('click');">
         </TR>
        <TR>
          <TD class=r_tb width=200><SCRIPT>ddw("txtWirelessChannel");</SCRIPT></TD>
 
          <TD class=l_tb>:&nbsp;
        <input type="hidden" id="wireless_channel" name="config.wireless.channel" value="<%getInfo("channel");%>"/>
				<select id="channel_1" onChange="chan()">
              </SELECT> </TD></TR>
        
        <tr>
				<td class='r_tb' width='200'><SCRIPT>ddw("txtTransmissionRate");</SCRIPT></td>
				<td class='l_tb'> :&nbsp;&nbsp;
				<select name="transmission_rate">
				<option value='0'><SCRIPT>ddw("txtBestAuto")</SCRIPT></option>
				</select>
				(Mbit/s)
				</td>
			</tr>
			
        </TBODY></TABLE>

      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0>
        <TBODY>
        

        <TR>
					<TD class=r_tb width=200>WMM <SCRIPT>ddw("txtEnable");</SCRIPT></TD>
					<TD class=l_tb>:&nbsp; 
					<input type="checkbox" id="wmm" name="wmm" value="<%getIndexInfo("wmm");%>" onclick="on_off_wmm(this.checked)">
	        <SCRIPT>ddw("txtWlanQos")</SCRIPT>                       
				</TR>
        <TR>					
          <TD class=r_tb width=200><SCRIPT>ddw("txtVisibilityStatus");</SCRIPT></TD>
          <TD class=l_tb>:&nbsp; 
		  <INPUT id=aphidden type=checkbox  name="config.wireless.invisibility"  value ="<%getIndexInfo("hiddenssid");%>"   onclick=changedHidden(this.checked) >&nbsp;
		  <SCRIPT>ddw("txtAlsoCallSsidBroadcast");</SCRIPT> 
        <TD></TD></TR></TBODY></TABLE></DIV>
		<!--   Wireless Site Survey   -->
		<div class="box" id="show_site" style="display:none">
			<H2>Site Survey</H2>
			<table cellpadding="1" cellspacing="1" border="0" width="525">

				<tr>
					<td class=r_tb></td>
					<td><input type="button" value="Scan" name="scan" onClick="do_scan()"></td>
				</tr>
				<tr>
					<td>
					<table border="1" cellspacing="3">
						<tr>
							<td width="23">&nbsp;</td>	
							<td width="50" id="TitleBar"><font id="SSTableFont">Type</font></td>								
							<td width="30" id="TitleBar"><font id="SSTableFont">CH</font></td>	
							<td width="50" id="TitleBar"><font id="SSTableFont">Signal</font></td>								
							<td width="100" id="TitleBar"><font id="SSTableFont">BSSID</font></td>

							<td width="70" id="TitleBar"><font id="SSTableFont">Security</font></td>	
							<td width="100" id="TitleBar"><font id="SSTableFont">SSID</font></td>	
						</tr>
					</table>	
					</td>
				</tr>	
				<tr>
					<td>
					<iframe src="" name="site_survey" id="site_survey" width="495" marginwidth="0" height="150" marginheight="0" align="middle" scrolling="auto">
					</iframe>

					</td>
				</tr>																																																				
			</table>
		</DIV>	  
      <DIV class=box id="show_security">
      <H2><SCRIPT>ddw("txtWirelessSecurityMode");</SCRIPT></H2>
      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0>
        <TBODY>
				<input type="hidden" id="wireless_wepon" name="config.wireless.wepon" value="<%getIndexInfo("wep_enabled");%>"/>				
				<input type="hidden" id="wireless_wpa_enabled" name="config.wireless.wpa_enabled" value="<%getIndexInfo("wpa_enabled");%>" />
				<input type="hidden" id="wireless_wpa_mode" name="config.wireless.wpa_mode" value="<%getIndexInfo("wpa_mode");%>"/>
        <TR>
          <TD class=r_tb width=200><SCRIPT>ddw("txtSecurityMode");</SCRIPT></TD>
          <TD class=l_tb>:&nbsp;
            <select id=security_type onChange=on_change_security_type() name="method0" >
              <option value=0  ><SCRIPT>ddw("txtNONE");</SCRIPT></option>
              <option value=1  ><SCRIPT>ddw("txtWEPSecurity");</SCRIPT></option>
              <option value=2  ><SCRIPT>ddw("txtWPAPersonal");</SCRIPT></option>
              <option value=4  ><SCRIPT>ddw("txtWPA2");</SCRIPT></option>
              <option value=6  ><SCRIPT>ddw("txtWPA2Auto");</SCRIPT></option>
            </select></TD>
      </TR>
      </TBODY>
      </TABLE>
      </DIV>

      <DIV class=box id=show_wep style="DISPLAY: none">
      <H2>WEP</H2>
      <p><SCRIPT>ddw("txtWirelessStr4");</SCRIPT></p>
<p>	<SCRIPT>ddw("txtWirelessStr5");</SCRIPT></p>
      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0>
        <TBODY>
        
        <TR>

          <TD class=r_tb width=200><SCRIPT>ddw("txtAuthentication");</SCRIPT></TD>
          <TD class=l_tb>:&nbsp;
        <input type="hidden" id="wireless_wep_auth_type" value="<%getIndexInfo("wep_auth");%>" />
		  	<SELECT id=auth_type name=authType value="<%getIndexInfo("wep_auth");%>" onChange="chg_wep_auth_type(this.value)">
          <OPTION value=1  ><SCRIPT>ddw("txtOpen");</SCRIPT></OPTION>
			 		<OPTION value=2  ><SCRIPT>ddw("txtSharedKey");</SCRIPT></OPTION></SELECT> </TD></TR>
        <TR>
          <TD class=r_tb width=200><SCRIPT>ddw("txtWepKeyLength");</SCRIPT></TD>

          <TD class=l_tb>:&nbsp; 
      <input type="hidden" id="wireless_wep_key_len" value="<%getIndexInfo("wep_mode");%>" />
		  <SELECT id=wep_key_len  size=1 name="wepKeyLen0" selectedValue=<%getIndexInfo("wep_mode");%> onChange="chg_wep_type(this.value)">
		   <OPTION value=0   >64Bit</OPTION> 
		   <OPTION value=1  >128Bit</OPTION></SELECT> 
          </TD></TR>

        <TR>
          <TD class=r_tb width=200><SCRIPT>ddw("txtDefaultWEPKey");</SCRIPT></TD>
          <TD class=l_tb>:&nbsp; 
     <input type="hidden" id="wireless_wep_def_key" value="<%getIndexInfo("defaultKeyId");%>" /> 
		 <SELECT id=wep_def_key name="wep_def_key0" selectedValue=<%getIndexInfo("defaultKeyId");%> onChange="chg_wep_def_key(this.value)">
        <OPTION value=1 >WEP Key 1</OPTION> 
			  <OPTION value=2 >WEP Key 2</OPTION> 
			  <OPTION value=3 >WEP Key 3</OPTION> 
			  <OPTION value=4 >WEP Key 4</OPTION>

			  </SELECT> </TD></TR></TBODY></TABLE>

	<table>
	</table>		
	<div id="wep_key_64"	style="display:none"><script>print_keys("wepkey_64","10");</script></div>
	<div id="wep_key_128" style="display:none"><script>print_keys("wepkey_128","26");</script></div>

      </DIV>

      <DIV class=box id=show_wpa style="DISPLAY: none">
      <DIV id=title_wpa style="DISPLAY: none">

      <H2>WPA-Personal</H2>
      <P><SCRIPT>ddw("txtWirelessStr7_1");</SCRIPT></P></DIV>
      	
      <DIV id=title_wpa2 style="DISPLAY: none">
      <H2>WPA2</H2>
      <P><SCRIPT>ddw("txtWirelessStr7_2");</SCRIPT></P></DIV>
      	
      <DIV id=title_wpa2_auto style="DISPLAY: none">
      <H2><SCRIPT>ddw("txtWPAWPA2");</SCRIPT></H2>

      <P><SCRIPT>ddw("txtWirelessStr7");</SCRIPT></P></DIV>
      <DIV>
      <TABLE>
        <TBODY>
        <TR>        	
          <TD class=r_tb width=200><SCRIPT>ddw("txtCipherType");</SCRIPT></TD>
          <TD class=l_tb>: 
      <input type="hidden" id="wireless_cipher_type" value="<%getIndexInfo("wpaCipher");%>" />
		  <SELECT id=cipher_type name="ciphersuite0" selectValue="<%getIndexInfo("wpaCipher");%>"> 
<option value=3><SCRIPT>ddw("txtTKIPandAES");</SCRIPT></option>
		  <OPTION value=1>TKIP</OPTION> 
		  <OPTION value=2>AES</OPTION>
		  
		  <!--<OPTION  value=4>Auto</OPTION>-->

		  </SELECT> </TD></TR>
        <TR>
        	<input type="hidden" id="wireless_ieee8021x_enabled" name="config.wireless.ieee8021x_enabled" value="<%getIndexInfo("wpa_enterprise_enabled");%>" />
          <TD class=r_tb width=200>PSK / EAP</TD>
          <TD class=l_tb>:&nbsp; 
		  <SELECT id=psk_eap onchange=chg_psk_eap(this.value) name="wpaAuth0"> 
		  <OPTION value=2  >PSK</OPTION>
			<OPTION value=1  >EAP</OPTION> 
			 </SELECT>
			</TD></TR></TBODY></TABLE></DIV>

      <DIV id=psk_setting style="DISPLAY: none">
      <TABLE>
        <TBODY>
        <TR>
          <TD class=r_tb width=200><SCRIPT>ddw("txtPreSharedKey");</SCRIPT></TD>
          <TD class=l_tb>:&nbsp;
		   <INPUT id=wpapsk1 type="text" maxLength=64 size=40 name="pskValue0"  id=wpapsk1 > </TD></TR>

        <INPUT type="hidden" id="wpa_key_type" name="pskFormat0">
        
		  <tr>
			  <td class="r_tb" width="200"></td>
				<td class="l_tb">&nbsp;&nbsp;<SCRIPT>ddw("txtWpaKeyType");</SCRIPT></td>
			</tr>
					
					</TBODY></TABLE></DIV>
      <DIV id=eap_setting style="DISPLAY: none">
      <TABLE>

        <TBODY>
        <TR>
          <TD class=l_tb>802.1X</TD></TR>
        <TR>
          <TD>
            <TABLE>
              <TBODY>
              <TR>

                <TD class=r_tb width=120><SCRIPT>ddw("txtRADIUSserverIPAddress");</SCRIPT>&nbsp;</TD>
                <TD class=l_tb><SCRIPT>ddw("txtIPAddress");</SCRIPT></TD>
                <TD class=l_tb>:&nbsp; 
				<INPUT id=srv_ip1 maxLength=15 size=15  name="srv_ip10" value="<%getInfo("rsIp1");%>" > </TD></TR>
              <TR>
                <TD class=r_tb width=120></TD>
                <TD class=l_tb><SCRIPT>ddw("txtPort");</SCRIPT></TD>

                <TD class=l_tb>:&nbsp; 
				<INPUT id=srv_port1 maxLength=5 size=8 name="srv_port10" value="<%getInfo("rsPort1");%>"> </TD></TR>
              <TR>
                <TD class=r_tb width=120></TD>
                <TD class=l_tb><SCRIPT>ddw("txtSharedSecret");</SCRIPT></TD>
                <TD class=l_tb>:&nbsp; 
				<INPUT id=srv_sec1 type="password" maxLength=64 size=50 name="srv_sec10" value="<%getInfo("rsPassword1");%>"> </TD></TR>

              </TBODY></TABLE></TD></TR></TBODY>
			  </TABLE>
			  </DIV>
			  </DIV>
			  
			  
			  
			  <input type="hidden" id=wan_macAddr name="wan_macAddr" value="00:00:00:00:00:00">

			  <input type="hidden" id=lan_ip value="192.168.0.1">
			  <input type="hidden" id=lan_mask name="lan_mask" value="255.255.255.0">	
                          <INPUT id=p_password type=hidden maxLength=63 size=30 value="" name=p_password>  
		    <DIV class="box" id="show_wisp" style="display:none">
            <DIV class="box">
			 <H2><SCRIPT >ddw("txtInternetConnectionType");</SCRIPT></H2>
             <P><SCRIPT >ddw("txtWANStr5");</SCRIPT></P>
             <TABLE cellSpacing=1 cellPadding=1 width=525 border=0>
             <TBODY>

             <TR>
             <TD class=r_tb width=150><SCRIPT >ddw("txtWANStr4");</SCRIPT>:</TD>
             <TD class=l_tb>&nbsp; 
             <input type="hidden" name="wisp_wan_ip_mode" id="wisp_wan_ip_mode" value="<%getInfo("wanType");%>" />
		       <SELECT id=wan_type  name=wan_type onchange=on_change_wan_type() > 
		       <OPTION value="0"><SCRIPT >ddw("txtStaticIP");</SCRIPT></OPTION> 
		       <OPTION value="1"><SCRIPT >ddw("txtDynamicIP");</SCRIPT></OPTION> 
               	<OPTION value="2">PPPoE <SCRIPT >ddw("txtUsernamePassword");</SCRIPT></OPTION>
			<OPTION value="3">PPTP <SCRIPT >ddw("txtUsernamePassword");</SCRIPT></OPTION>
			<OPTION value="4">L2TP <SCRIPT >ddw("txtUsernamePassword");</SCRIPT></OPTION>
		       </SELECT> 
			 </TD>

			 </TR>
			 </TBODY>
		     </TABLE>
               </DIV>   
      <DIV class=box id=show_static style="DISPLAY: none">
      <H2><SCRIPT >ddw("txtWANStr6");</SCRIPT></H2>
      <P><SCRIPT >ddw("txtWANStr7");</SCRIPT></P>

      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0 id=frm_static >
        <TBODY>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtIPAddress");</SCRIPT>:</TD>
          <TD class=t_tb>&nbsp; 
		  <INPUT id=s_ipaddr maxLength=15 size=16  value="<% getInfo("wan-ip-rom");%>" name=ipaddr> (ISP Assign)</TD></TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtSubnetMask");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=s_netmask maxLength=15 size=16 value="<% getInfo("wan-mask-rom");%>" name=netmask> </TD></TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtDefaultGateway");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=s_gateway maxLength=15 size=16 value="<% getInfo("wan-gateway-rom");%>" name=gateway> </TD></TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtMACAddress");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=s_mac1 maxLength=2 size=2 > - 
          <INPUT id=s_mac2 maxLength=2 size=2 > - 
		  <INPUT id=s_mac3 maxLength=2 size=2 > - 
		  <INPUT id=s_mac4 maxLength=2 size=2 > - 
		  <INPUT id=s_mac5 maxLength=2 size=2 > - 
		  <INPUT id=s_mac6 maxLength=2 size=2 ><br> (optional)&nbsp;&nbsp; 
		  <INPUT type=button value="" name=s_clone id=s_clone onclick='set_clone_mac("s")'> 
          </TD>

		  <INPUT id=s_clonemac type=hidden name=clonemac value="<% getInfo("wanMac"); %>"> </TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=s_dns1 maxLength=15 size=16 value="<% getInfo("wan-dns1");%>" name=s_dns1> </TD></TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=s_dns2 maxLength=15 size=16 value="<% getInfo("wan-dns2");%>" name=s_dns2>&nbsp;(optional)</TD></TR>
        <TR>
          <TD class=r_tb>MTU :</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=s_mtu maxLength=4 size=5 value="<%getInfo("fixedIpMtuSize");%>" name=s_mtu> <SCRIPT >ddw("txtMTUdefault");</SCRIPT></TD></TR></TBODY></TABLE>
		</DIV>
			 
			   

			   <DIV class=box id=show_dhcp style="DISPLAY: none">
      <H2><SCRIPT >ddw("txtWANStr8");</SCRIPT></H2>
      <P><SCRIPT >ddw("txtWANStr9");</SCRIPT></P>
      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0 id=frm_dhcp>
        <TBODY>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtHostName");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=d_hostname maxLength=30 size=30  value="<% getInfo("hostName"); %>"  name=d_hostname > </TD></TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtMACAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=d_mac1 maxLength=2 size=2 > - 
          <INPUT id=d_mac2 maxLength=2 size=2 > - 
		  <INPUT id=d_mac3 maxLength=2 size=2 > - 
		  <INPUT id=d_mac4 maxLength=2 size=2 > -
		  <INPUT id=d_mac5 maxLength=2 size=2 > - 
		  <INPUT id=d_mac6 maxLength=2 size=2 > <br>(optional)&nbsp;&nbsp; 
		   
		   <INPUT type=button value="" name=d_clone id=d_clone onclick='set_clone_mac("d")'> 
          	</TD>

		  	<INPUT id=d_clonemac type=hidden name=d_clonemac value="<% getInfo("wanMac"); %>"> </TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=d_dns1 maxLength=15 size=16 value="<% getInfo("wan-dns1");%>" name=d_dns1>&nbsp;(optional)</TD></TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=d_dns2 maxLength=15 size=16 value="<% getInfo("wan-dns2");%>" name=d_dns2>&nbsp;(optional)</TD></TR>
        <TR>
          <TD class=r_tb>MTU :</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=d_mtu maxLength=4 size=5 value="<%getInfo("dhcpMtuSize");%>"  name=d_mtu> <SCRIPT >ddw("txtMTUdefault");</SCRIPT> </TD></TR></TBODY></TABLE>
	</DIV>
			   

			<DIV class=box id=show_pppoe style="DISPLAY: none">
      <H2>PPPoE</H2>
      <P><SCRIPT >ddw("txtWANStr1");</SCRIPT></P>
      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0 id=frm_pppoe>
        <TBODY>
        
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtAddressMode");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_poe_ip_mode_0   onClick="pppoe_use_dynamic_address_selector(this.value);" type=radio value="true"  checked name=p_poe_ip_mode><SCRIPT >ddw("txtDynamicIP");</SCRIPT>
			 <INPUT id=p_poe_ip_mode_1  onClick="pppoe_use_dynamic_address_selector(this.value);"  type=radio value="false"  name=p_poe_ip_mode><SCRIPT >ddw("txtStaticIP");</SCRIPT>
			 <INPUT id=poe_ip_mode type=hidden name=poe_ip_mode value="<%getIndexInfo("pppoe_wan_ip_mode");%>"> 
		 </TD></TR>

        <TR>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtUserName");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_username maxLength=63 size=30  name=p_username value="<% getInfo("pppUserName"); %>" > </TD></TR>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtPassword");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp;
		  <INPUT type="password" id=tmp_password  maxLength=63 size=30 value="<% getInfo("pppPassword"); %>" name=tmp_password>				
	  </TD>
	</TR>
        <TR>

          <TD class=r_tb width=150><SCRIPT >ddw("txtVerifyPassword");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT type="password" id=p_password_v   maxLength=63 size=30 value="<% getInfo("pppPassword"); %>" name=p_password_v> 
	  </TD>
	</TR>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtServiceName");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_svc_name maxLength=40 size=30 name=p_svc_name value="<% getInfo("pppServiceName"); %>" >&nbsp;(optional) </TD></TR>
	<TR>
          <TD class=r_tb><SCRIPT >ddw("txtIPAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; <INPUT id=p_poe_ip_address maxLength=15 size=16 value="<% getInfo("pppoe-wan-ip-rom");%>" name=p_poe_ip_address>&nbsp;</TD></TR>

          <TD class=r_tb><SCRIPT >ddw("txtMACAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  	<INPUT id=o_mac1 maxLength=2 size=2 > - 
            <INPUT id=o_mac2 maxLength=2 size=2 > - 
			<INPUT id=o_mac3 maxLength=2 size=2 > - 
			<INPUT id=o_mac4 maxLength=2 size=2 > - 
			<INPUT id=o_mac5 maxLength=2 size=2 > - 
			<INPUT id=o_mac6 maxLength=2 size=2 ><br>(optional)&nbsp;&nbsp; 
			<INPUT type=button value="" name=o_clone id=o_clone onclick='set_clone_mac("o")'> 
          </TD>

		  <INPUT id=p_clonemac type=hidden name=clonemac value="<% getInfo("wanMac"); %>" > </TR>
        <TR>
          <TD class=r_tb width=150></TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_poe_dns_mode_0   onClick="pppoe_use_dynamic_dns_selector(this.value);" type=radio value="0"  checked name=p_poe_dns_mode><SCRIPT >ddw("txtDynGetDNS");</SCRIPT>
			 <INPUT id=p_poe_dns_mode_1  onClick="pppoe_use_dynamic_dns_selector(this.value);"  type=radio value="1"  name=p_poe_dns_mode><SCRIPT >ddw("txtStaticGetDNS");</SCRIPT>
			 <INPUT id=poe_dns_mode type=hidden name=poe_dns_mode value="<%getIndexInfo("wanpoedns_mode");%>"> 
		 </TD></TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_dns1 maxLength=15 size=16 value="<% getInfo("wan-dns1");%>" name=p_dns1>&nbsp;<SCRIPT >ddw("txtOptional");</SCRIPT></TD></TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_dns2 maxLength=15 size=16  value="<% getInfo("wan-dns2");%>" name=p_dns2>&nbsp;<SCRIPT >ddw("txtOptional");</SCRIPT></TD></TR>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtMaximumIdleTime");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_idletime maxLength=4 size=5 value="<% getInfo("wan-ppp-idle"); %>" name=p_idletime>&nbsp;<SCRIPT >ddw("txtMinutes");</SCRIPT></TD></TR>
        <TR>
          <TD class=r_tb>MTU :</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_mtu maxLength=4 size=5 value="<% getInfo("pppMtuSize"); %>" name=p_mtu><SCRIPT >ddw("txtMTUdefault");</SCRIPT></TD></TR>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtReconnectMode");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id="p_ppp_conn_mode_0"  onClick="onchangepppmode(this.value);" type=radio value=0  name=p_ppp_conn_mode><SCRIPT >ddw("txtAlwaysOn");</SCRIPT>
		  <input id="poe_sch_name" name="poe_sch_name" value="<%getIndexInfo("wanPPPoESchSelectName");%>" type="hidden">
		  <select id="poe_sch_select" name="poe_sch_select" onChange="wan_schedule_name_selector(this.value);">
			</select> &nbsp;<input class="button_submit" type="button" id="add_new_schedule_poe" value="" onclick="do_add_new_schedule(true)"><br>
			 &nbsp; <INPUT id="p_ppp_conn_mode_1"  onClick="onchangepppmode(this.value);" type=radio value=2   name=p_ppp_conn_mode><SCRIPT >ddw("txtManual");</SCRIPT>
			 <INPUT id="p_ppp_conn_mode_2"  onClick="onchangepppmode(this.value);"  type=radio value=1  name=p_ppp_conn_mode><SCRIPT >ddw("txtOnDemand");</SCRIPT>
			 <input type="hidden" name="poe_reconnect_mode" id="poe_reconnect_mode" value="<% getInfo("pppConnectType"); %>">
			 <!--<INPUT id=ppp_auto type=hidden name=ppp_auto> 
			 <INPUT id=ppp_ondemand type=hidden name=ppp_ondemand> --></TD></TR>
       </TBODY></TABLE>
		</DIV>
	<DIV class=box id=show_pptp style="DISPLAY: none">
      <H2>PPTP</H2>
      <P><SCRIPT >ddw("txtWANStr1");</SCRIPT></P>
      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0 id=frm_pptp>
        <TBODY>
        
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtAddressMode");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_ptp_ip_mode_0   onClick="ptp_use_dynamic_address_selector(this.value);" type=radio value="true" name=p_ptp_ip_mode><SCRIPT >ddw("txtDynamicIP");</SCRIPT>
			 <INPUT id=p_ptp_ip_mode_1  onClick="ptp_use_dynamic_address_selector(this.value);"  type=radio value="false"  name=p_ptp_ip_mode><SCRIPT >ddw("txtStaticIP");</SCRIPT>
			 <INPUT id=ptp_ip_mode type=hidden name=ptp_ip_mode value="<%getIndexInfo("pppoe_wan_ip_mode");%>"> 
		 </TD></TR>
	<TR>
          <TD class=r_tb><SCRIPT >ddw("txtIPAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; <INPUT id=p_ptp_ip_address maxLength=15 size=16 value="<% getInfo("pptpIp"); %>" name=p_ptp_ip_address>&nbsp;</TD>
		  </TR>
	<TR>
          <TD class=r_tb><SCRIPT >ddw("txtPPTPSubnetMask");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; <INPUT id=p_ptp_netMask maxLength=15 size=16 value="<% getInfo("pptpSubnet"); %>" name=p_ptp_netMask>&nbsp;</TD>
		  </TR>	  
		<TR>
          <TD class=r_tb><SCRIPT >ddw("txtGatewayIPAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; <INPUT id=p_ptp_gw maxLength=15 size=16 value="<% getInfo("pptp-wan-gateway-rom");%>" name=p_ptp_gw>&nbsp;</TD>
		  </TR>	
	 <TR>
          <TD class=r_tb><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=pt_dns1 maxLength=15 size=16 value="<% getInfo("wan-dns1");%>" name=pt_dns1>&nbsp;</TD>
		 </TR>
        <TR>
          <TD class=r_tb><SCRIPT >ddw("txtMACAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  	<INPUT id=p_mac1 maxLength=2 size=2 > - 
            <INPUT id=p_mac2 maxLength=2 size=2 > - 
			<INPUT id=p_mac3 maxLength=2 size=2 > - 
			<INPUT id=p_mac4 maxLength=2 size=2 > - 
			<INPUT id=p_mac5 maxLength=2 size=2 > - 
			<INPUT id=p_mac6 maxLength=2 size=2 ><br>(optional)&nbsp;&nbsp; 
			<INPUT type=button value="" name=p_clone id=p_clone onclick='set_clone_mac("p")'> 
          </TD>

		  <INPUT id=pt_clonemac type=hidden name=clonemac value="<% getInfo("wanMac"); %>" > 
		  </TR>
		  <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtServerIP");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=pt_server maxLength=63 size=30  name=pt_server value="<% getInfo("pptpServerIp"); %>" > </TD>
		  </TR>
		  
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtUserName");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=pt_username maxLength=63 size=30  name=pt_username value="<% getInfo("pptpUserName"); %>" > </TD>
		  </TR>
		  
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtPassword");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT type="password" id=tmpt_password  maxLength=63 size=30 value="<% getInfo("pptpPassword"); %>" name=tmpt_password>				
	  </TD>
	</TR>
        <TR>

          <TD class=r_tb width=150><SCRIPT >ddw("txtVerifyPassword");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT type="password" id=pt_password_v   maxLength=63 size=30 value="<% getInfo("pptpPassword"); %>" name=pt_password_v> 
	  </TD>
	</TR>
		
      
       
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtMaximumIdleTime");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=pt_idletime maxLength=4 size=5 value="<% getInfo("pptpIdleTime"); %>" name=pt_idletime>&nbsp;<SCRIPT >ddw("txtMinutes");</SCRIPT></TD></TR>
        <TR>
          <TD class=r_tb>MTU :</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=pt_mtu maxLength=4 size=5 value="<% getInfo("pptpMtuSize"); %>" name=pt_mtu><SCRIPT >ddw("txtMTUdefault");</SCRIPT></TD></TR>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtReconnectMode");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id="p_pt_conn_mode_0"  onClick="onchangepptpmode(this.value);" type=radio value=0  name=p_pt_conn_mode><SCRIPT >ddw("txtAlwaysOn");</SCRIPT>
		  <input id="ptp_sch_name" name="ptp_sch_name" value="<%getIndexInfo("wanPPTPSchSelectName");%>" type="hidden">
		  <select id="ptp_sch_select" name="ptp_sch_select" onChange="wan_ptp_schedule_name_selector(this.value);">
			</select> &nbsp;<input class="button_submit" type="button" id="add_new_schedule_ptp" value="" onclick="do_add_new_schedule(true)"><br>
			 &nbsp; <INPUT id="p_pt_conn_mode_1"  onClick="onchangepptpmode(this.value);" type=radio value=2   name=p_pt_conn_mode><SCRIPT >ddw("txtManual");</SCRIPT>
			 <INPUT id="p_pt_conn_mode_2"  onClick="onchangepptpmode(this.value);"  type=radio value=1  name=p_pt_conn_mode><SCRIPT >ddw("txtOnDemand");</SCRIPT>
			 <input type="hidden" name="ptp_reconnect_mode" id="ptp_reconnect_mode" value="<% getInfo("pptpConnectType"); %>">
			 </TD></TR>
       </TBODY></TABLE>
		</DIV>
			 
		<!-- L2TP -->	 
			 
		<DIV class=box id=show_l2tp style="DISPLAY: none">
      <H2>L2TP</H2>
      <P><SCRIPT >ddw("txtWANStr1");</SCRIPT></P>
      <TABLE cellSpacing=1 cellPadding=1 width=525 border=0 id=frm_l2tp>
        <TBODY>
        
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtAddressMode");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=p_pl2_ip_mode_0   onClick="pl2_use_dynamic_address_selector(this.value);" type=radio value="true"  name=p_pl2_ip_mode><SCRIPT >ddw("txtDynamicIP");</SCRIPT>
			 <INPUT id=p_pl2_ip_mode_1  onClick="pl2_use_dynamic_address_selector(this.value);"  type=radio value="false"  name=p_pl2_ip_mode><SCRIPT >ddw("txtStaticIP");</SCRIPT>
			 <INPUT id=pl2_ip_mode type=hidden name=pl2_ip_mode value="<%getIndexInfo("l2tp_wan_ip_mode");%>"> 
		 </TD></TR>
	<TR>
          <TD class=r_tb><SCRIPT >ddw("txtIPAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; <INPUT id=p_pl2_ip_address maxLength=15 size=16 value="<% getIndexInfo("l2tpIp"); %>" name=p_pl2_ip_address>&nbsp;</TD>
		  </TR>
	<TR>
          <TD class=r_tb><SCRIPT >ddw("txtPPTPSubnetMask");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; <INPUT id=p_pl2_netMask maxLength=15 size=16 value="<% getIndexInfo("l2tpSubnet"); %>" name=p_pl2_netMask>&nbsp;</TD>
		  </TR>	  
		<TR>
          <TD class=r_tb><SCRIPT >ddw("txtGatewayIPAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; <INPUT id=p_pl2_gw maxLength=15 size=16 value="<% getInfo("l2tp-wan-gateway-rom");%>" name=p_pl2_gw>&nbsp;</TD>
		  </TR>	
	 <TR>
          <TD class=r_tb><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=l2_dns1 maxLength=15 size=16 value="<% getInfo("wan-dns1");%>" name=l2_dns1>&nbsp;</TD>
		 </TR>
<TR>
          <TD class=r_tb><SCRIPT >ddw("txtMACAddress");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  	<INPUT id=l_mac1 maxLength=2 size=2 > - 
            <INPUT id=l_mac2 maxLength=2 size=2 > - 
			<INPUT id=l_mac3 maxLength=2 size=2 > - 
			<INPUT id=l_mac4 maxLength=2 size=2 > - 
			<INPUT id=l_mac5 maxLength=2 size=2 > - 
			<INPUT id=l_mac6 maxLength=2 size=2 ><br>(optional)&nbsp;&nbsp; 
			<INPUT type=button value="" name=l_clone id=l_clone onclick='set_clone_mac("p")'> 
          </TD>

		  <INPUT id=l2_clonemac type=hidden name=clonemac value="<% getInfo("wanMac"); %>" > 
		  </TR>
		  <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtServerIP");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=l2_server maxLength=63 size=30  name=l2_server value="<% getIndexInfo("l2tpServerIp"); %>" > </TD>
		  </TR>
		  
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtUserName");</SCRIPT>:</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=l2_username maxLength=63 size=30  name=l2_username value="<% getIndexInfo("l2tpUserName"); %>" > </TD>
		  </TR>
		  
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtPassword");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp;
		  <INPUT type="password" id=tml2_password  maxLength=63 size=30 value="<% getIndexInfo("l2tpPassword"); %>" name=tml2_password>				
	  </TD>
	</TR>
        <TR>

          <TD class=r_tb width=150><SCRIPT >ddw("txtVerifyPassword");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT type="password" id=l2_password_v   maxLength=63 size=30 value="<% getIndexInfo("l2tpPassword"); %>" name=l2_password_v> 
	  </TD>
	</TR>
		
      
       
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtMaximumIdleTime");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id=l2_idletime maxLength=4 size=5 value="<% getIndexInfo("l2tpIdleTime"); %>" name=l2_idletime>&nbsp;<SCRIPT >ddw("txtMinutes");</SCRIPT></TD></TR>
        <TR>
          <TD class=r_tb>MTU :</TD>

          <TD class=l_tb>&nbsp; 
		  <INPUT id=l2_mtu maxLength=4 size=5 value="<% getIndexInfo("l2tpMtuSize"); %>" name=l2_mtu><SCRIPT >ddw("txtMTUdefault");</SCRIPT></TD></TR>
        <TR>
          <TD class=r_tb width=150><SCRIPT >ddw("txtReconnectMode");</SCRIPT>:</TD>
          <TD class=l_tb>&nbsp; 
		  <INPUT id="p_l2_conn_mode_0"  onClick="onchangel2tpmode(this.value);" type=radio value=0  name=p_l2_conn_mode><SCRIPT >ddw("txtAlwaysOn");</SCRIPT>
		  <input id="pl2_sch_name" name="pl2_sch_name" value="<%getIndexInfo("wanL2TPSchSelectName");%>" type="hidden">
		  <select id="pl2_sch_select" name="pl2_sch_select" onChange="wan_pl2_schedule_name_selector(this.value);">
			</select> &nbsp;<input class="button_submit" type="button" id="add_new_schedule_pl2" value="" onclick="do_add_new_schedule(true)"><br>
			 &nbsp; <INPUT id="p_l2_conn_mode_1"  onClick="onchangel2tpmode(this.value);" type=radio value=2   name=p_l2_conn_mode><SCRIPT >ddw("txtManual");</SCRIPT>
			 <INPUT id="p_l2_conn_mode_2"  onClick="onchangel2tpmode(this.value);"  type=radio value=1  name=p_l2_conn_mode><SCRIPT >ddw("txtOnDemand");</SCRIPT>
			 <input type="hidden" name="pl2_reconnect_mode" id="pl2_reconnect_mode" value="<% getIndexInfo("l2tpConnectType"); %>">
			 </TD></TR>
       </TBODY></TABLE>
		</DIV>
			 
		    </DIV>	    
			  
			  </form>
<form id="formWDS" name="formWDS">
<input type="hidden" id="wdsMacOri_1" value="<% wlWdsList("wdsMac_1");%>" />
<input type="hidden" id="wdsMacOri_2" value="<% wlWdsList("wdsMac_2");%>" />
<input type="hidden" id="wdsMacOri_3" value="<% wlWdsList("wdsMac_3");%>" />
<input type="hidden" id="wdsMacOri_4" value="<% wlWdsList("wdsMac_4");%>" />
<input type="hidden" id="wdsMacOri_5" value="<% wlWdsList("wdsMac_5");%>" />
<input type="hidden" id="wdsMacOri_6" value="<% wlWdsList("wdsMac_6");%>" />
<input type="hidden" id="wdsMacOri_7" value="<% wlWdsList("wdsMac_7");%>" />
<input type="hidden" id="wdsMacOri_8" value="<% wlWdsList("wdsMac_8");%>" />
			  
<div class="box" id="show_wds" style="display:none"> 
						<h2><SCRIPT>ddw("txtBridgeSetting");</SCRIPT> </h2>
            <table cellpadding="1" cellspacing="1" border="0" width="525">
<script>
	var subject;

	var token= new Array(8);
	token[0]="<% wlWdsList("wdsMac_1");%>";
	token[1]="<% wlWdsList("wdsMac_2");%>";
	token[2]="<% wlWdsList("wdsMac_3");%>";
	token[3]="<% wlWdsList("wdsMac_4");%>";
	token[4]="<% wlWdsList("wdsMac_5");%>";
	token[5]="<% wlWdsList("wdsMac_6");%>";
	token[6]="<% wlWdsList("wdsMac_7");%>";
	token[7]="<% wlWdsList("wdsMac_8");%>";

	for(var i=1;i<9;i++)
	{
		if(i==1)
			subject = sw("txtRemoteApMac");
		else
			subject = "";

		document.write("<tr><td align='right' width='200' height='19'>"+subject+"</td>");
//		else
//			document.write("<tr><td align='right' width='200' height='19'></td>");
		document.write("<td width='325'><div align='left'>&nbsp;");
		document.write("<input type=\"hidden\" id='wdsMac_"+i+"' name='wdsMac_"+i+"' value=\"\"/>");
		document.write("&nbsp;"+i+".<input type='text' maxLength='17' size='18' id='wdsMac"+i+"0' name='wdsMac"+i+"0' value='"+token[i-1]+"'>&nbsp;");
		i++;
		document.write("<input type=\"hidden\" id='wdsMac_"+i+"' name='wdsMac_"+i+"' value=\"\"/>");
		document.write(i+".<input type='text' maxLength='17' size='18' id='wdsMac"+i+"0' name='wdsMac"+i+"0' value='"+token[i-1]+"'>&nbsp;");

	}
	document.write("<tr><td width=''><div align='left'>&nbsp;<td align='right' width='200' height='19'>("+sw("txtNote")+" 00:19:78:01:10:BB)</td></tr>");
</script>
	  <tr>
<td align=right "200" height="19"><SCRIPT >ddw("txtBridgeSecurity");</SCRIPT>:&nbsp;</td>
<td height=2 colspan="2"><input type="hidden" id="encryptModeOri" value="0" />
<input type="hidden" id="encryptMode" name="encryptMode" value="<%getIndexInfo("WDS_AP_Encrypt");%>"/>
                          <SELECT id="encrypt0" name="encrypt0"  selectedValue=<%getIndexInfo("WDS_AP_Encrypt");%>   ONCHANGE="updateEncryptState(this.value)"> <OPTION 
                          value=0 ><SCRIPT >ddw("txtNONE");</SCRIPT></OPTION> <OPTION 
                          value=1 ><SCRIPT >ddw("txt64Bit10HexDigits");</SCRIPT></OPTION> <OPTION 
                          value=2 ><SCRIPT >ddw("txt128Bit26HexDigits");</SCRIPT></OPTION> <OPTION 
                          value=3 >WPA-PSK (TKIP)</OPTION> <OPTION 
                          value=4 >WPA2-PSK (AES)</OPTION>
                          </SELECT>
                            </td>                           
                        </tr>

                        <tr>
<td align=right "200" height="19"><SCRIPT >ddw("txtWepKey");</SCRIPT>:&nbsp;</td>
<input type="hidden" id="wdsformatMode" name="wdsformateMode" value="0"/>
<input type="hidden" id="wepKey0Ori" value=""/>
<td height=2 colspan="2">
<input type="text" id="wepKey0" name="wepKey0" value="" size=26 maxlength=26 >&nbsp;<span id="wds_wep_hint"></span>
                            </td>                           
                        </tr>
                        <tr>
<input type="hidden" id="wdsPskFormat" name="wdsPskFormat" value="0"/>
                            <td align=right "200" height="19">
<SCRIPT >ddw("txtPreSharedKey");</SCRIPT>:&nbsp;</td>
<input type="hidden" id="wdspskValue0Ori" value=""/>
<td height=2 colspan="2">
<INPUT type="text" id="wdspskValue0" name="wdspskValue0" maxLength=64 size=26 value="<%getIndexInfo("WDS_pskKey");%>">&nbsp;<SCRIPT>ddw("txtWpaKeyType");</SCRIPT>
                            </td>                           
                        </tr>												
                    </table>
					</div></form><!-- show_wds END --> 

			  
			  
			  
			  

<form name="final_form" id="final_form" method="post" action="/goform/formWlanSetup">
	
<input type="hidden" name="ACTION_POST"			value="final">
<input type="hidden" name="f_wireless_mode"			value="">
<input type="hidden" name="f_enable"			value="">
<input type="hidden" name="f_wps_enable"		value="">
<input type="hidden" name="f_ssid"				value="">
<input type="hidden" name="f_channel"			value="">
<input type="hidden" name="f_auto_channel"		value="">
<input type="hidden" name="f_wmm_enable"		value="">
<input type="hidden" name="f_ap_hidden"			value="">
<input type="hidden" name="f_authentication"	value="">
<input type="hidden" name="f_wep_auth_type"	value="">
<input type="hidden" name="f_cipher"			value="">
<input type="hidden" name="f_wep_len"			value="">
<input type="hidden" name="f_wep_format"		value="">
<input type="hidden" name="f_wep_def_key"		value="">
<input type="hidden" name="f_wep"				value="">
<input type="hidden" name="f_wpa_psk_type"		value="">
<input type="hidden" name="f_wpa_psk"			value="">
<input type="hidden" name="f_radius_ip1"		value="">
<input type="hidden" name="f_radius_port1"		value="">
<input type="hidden" name="f_radius_secret1"	value="">

<input type="hidden" name="f_wdsMac_1"	value="">
<input type="hidden" name="f_wdsMac_2"	value="">
<input type="hidden" name="f_wdsMac_3"	value="">
<input type="hidden" name="f_wdsMac_4"	value="">
<input type="hidden" name="f_wdsMac_5"	value="">
<input type="hidden" name="f_wdsMac_6"	value="">
<input type="hidden" name="f_wdsMac_7"	value="">
<input type="hidden" name="f_wdsMac_8"	value="">
<input type="hidden" name="f_wds_encryptMode"	value="">
<input type="hidden" name="f_wds_wds_formateMode"	value="">
<input type="hidden" name="f_wds_wepKey"	value="">
<input type="hidden" name="f_wds_pskFormat"	value="">
<input type="hidden" name="f_wds_wdspskValue"	value="">

<input type="hidden" name="config.wan_secondary_dns" value="">
<input type="hidden" name="config.wan_primary_dns" value="">
<input type="hidden" name="mac_clone" value="">
<input type="hidden" name="wisp_wan_ip_mode" id="wisp_wan_ip_mode" value="" />
<input type="hidden" name="f_d_hostname" value="">
<input type="hidden" name="f_mtu" value="">
<input type="hidden" name="f_s_wan_ip" value="">
<input type="hidden" name="f_s_wan_mask" value="">
<input type="hidden" name="f_s_wan_gw" value="">
<!- for pppoe -->
<input type="hidden" name="config.pppoe_username" value="" >
<input type="hidden" name="config.pppoe_password" value="">	
<input type="hidden" name="config.pppoe_service_name" value="" >
<input type="hidden" name="pppoe_reconnect_mode_radio" value="">
<input type="hidden" name="config.pppoe_max_idle_time" value="">
<input type="hidden" name="config.pppoe_use_dynamic_address" value=""/>
<input type="hidden" name="config.pppoe_ip_address" value=""/>
<input type="hidden" name="ppp_schedule_control_0" value="">
<input type="hidden" name="config.wan_mtu" value="">
<input type="hidden" name="pppoe_use_dynamic_dns_radio" value="">
<!- for pptp -->
<input type="hidden" name="wan_pptp_use_dynamic_carrier_radio" value="">
<input type="hidden" name="config.wan_pptp_username" value="">
<input type="hidden" name="config.wan_pptp_password" value="">
<input type="hidden" name="pptp_reconnect_mode_radio" value="">
<input type="hidden" name="config.wan_pptp_max_idle_time" value="">
<input type="hidden" name="config.wan_pptp_ip_address" value="">
<input type="hidden" name="config.wan_pptp_server" value="">
<input type="hidden" name="config.wan_pptp_subnet_mask" value="">
<input type="hidden" name="config.wan_pptp_gateway" value="">
<!-- L2TP-->
<input type="hidden" name="wan_l2tp_use_dynamic_carrier_radio" value="">
<input type="hidden" name="config.wan_l2tp_username" value="">
<input type="hidden" name="config.wan_l2tp_password" value="">
<input type="hidden" name="l2tp_reconnect_mode_radio" value="">
<input type="hidden" name="config.wan_l2tp_max_idle_time" value="">
<input type="hidden" name="config.wan_l2tp_ip_address" value="">
<input type="hidden" name="config.wan_l2tp_server" value="">
<input type="hidden" name="config.wan_l2tp_subnet_mask" value="">
<input type="hidden" name="config.wan_l2tp_gateway" value="">




<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="webpage" name="webpage" value="/Basic/Wireless.asp">
</form>

<SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>

<!-- InstanceEndEditable --></div></td>
<td id="sidehelp_container">	<div id="help_text">
<!-- InstanceBeginEditable name="Help_Text" -->
<strong>	<SCRIPT>ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><span id="wifi_help"></span></p>
<p><SCRIPT>ddw("txtWirelessStr11");</SCRIPT></p>
<p>	<SCRIPT>ddw("txtWirelessStr12");</SCRIPT></p>
<p>	<SCRIPT>ddw("txtWirelessStr13");</SCRIPT></p>
<p class="more">
<!-- Link to more help -->
<a href="../Help/Basic.asp#Wireless" onclick="return jump_if();"><SCRIPT>ddw("txtMore");</SCRIPT>...</a>
</p><!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT>Write_footerContainer();</SCRIPT></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>

