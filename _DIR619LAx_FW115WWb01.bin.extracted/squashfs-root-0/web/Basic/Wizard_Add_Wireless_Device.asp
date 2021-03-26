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
#wz_buttons {
	margin-top: 1em;
	border: none;
}
#add_sta_progress_bar {
	display: none;
	overflow: hidden;
	width:140px;
	height:15px;
	margin: 0 auto;
	border: 1px solid gray;
}
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[
/*
 * no_reboot_alt_location is for wizards, which want to return
 * to the "launch page", instead of the same page.
 */
var no_reboot_alt_location = "";
function do_reboot()
{
	top.location = "http://192.168.0.1/reboot.cgi?reset=false"
}
function no_reboot()
{
	if (no_reboot_alt_location) {
		top.location = no_reboot_alt_location;
		return;
	}
	document.getElementById("maincontent_1col").style.display = "block";
	document.getElementById("rebootcontent_1col").style.display = "none";
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
page_load();
//document.getElementById("loader_container").style.display = "none";
RenderWarnings();
}
//]]>
</script>
<!-- InstanceBeginEditable name="Scripts" -->
<script type="text/javascript" src="../md5.js"></script>
<script type="text/javascript">
//<![CDATA[
/** Set the no reboot location parameter to the wizard launch page*/
		no_reboot_alt_location = "Wizard_Wireless.asp";
		/*
		 * Handle for document.mainform.
		 */
		var mf;

		var wifisc_add_sta_retriever = null;
		var wifisc_add_sta_progress_retriever = null;
		var wifisc_cancel_add_sta_retriever = null;
		var wifisc_add_sta_progress_retriever_timer = 0;
		var wifisc_add_sta_countdown_timer = 0;

		var wifisc_current_pin = "<%getInfo("wscLoocalPin");%>";
		/*
		 * Configuration methods
		 * PIN = 0;
		 * PUSH_BUTTON = 1;
		 * MANUAL = 2;
		 */
		var MANUAL = 3;
		var config_method = 0;

		/*
		 * Are we in the process of adding a wireless device?
		 */
		var state_in_progress = false;

		/*
		 * Wizard pages.
		 */
		var wz_min = 2;
		var wz_cur = 2;
		var wz_method_list_page = 2; //This is the page that lists all the config methods
		var wz_max = 4;

		/*
		 * Show/Hide wizard pages and buttons.
		 */
		function wz_showhide()
		{
			for (var i = 1; i <= wz_max; i++) {
				document.getElementById("wz_page_" + i).style.display = wz_cur == i ? "block" : "none";
			}
			disable_form_field(document.getElementById("wz_prev_b"), (wz_cur == wz_min) || (wz_cur == wz_max) ? true : false);
			disable_form_field(document.getElementById("wz_next_b"), (wz_cur > wz_method_list_page) ? true : false);

			/*
			 * Grey out auto and push button methods if wifisc is disabled
			 */
			var wifisc_disabled = (("<%getIndexInfo("wps_alive");%>" == "0") 
								||("<%getIndexInfo("wlan_state");%>" == "Disabled"));
			if ((wz_cur == 2) && wifisc_disabled) {
				disable_form_field(mf.config_method_radio_0, true);
				disable_form_field(mf.config_method_radio_1, true);
				config_method_selector(MANUAL);
			}
/*
			var wifisc_pinlose = (("<%getIndexInfo("wps_WebPinLock");%>" == "true") && ("<%getIndexInfo("wscConfig");%>" == "1"));
			if(wifisc_pinlose){
				disable_form_field(mf.config_method_radio_0, true);
				mf.config_method_radio_1.checked = true;
				mf.config_method_radio_0.checked = false;
				mf.wireless_device_pin.disabled = true;
				config_method_selector(1);
			}
*/

			/*
			 * Manual config method selected, or we are at the page after adding wireless device finishes
			 */
			if ((config_method == MANUAL) || (wz_cur == wz_max)){
				document.getElementById("wz_save_b").value = sw("txtWirelessStatus");
			} else {
				document.getElementById("wz_save_b").value = sw("txtConnect");
			}
			disable_form_field(document.getElementById("wz_save_b"), (wz_cur > wz_method_list_page) && (wz_cur < wz_max) ? false : true);
			scroll(0, 0);
			
			if( wz_cur == 3) {
				if( mf.config_method_radio_auto.checked ) {
				
					document.getElementById("config_method_auto").style.display = 1 ? "block" : "none";
					document.getElementById("config_method_2").style.display = 0 ? "block" : "none";
				
				
				}
				else {
					document.getElementById("wz_save_b").value = sw("txtWirelessStatus");
					document.getElementById("config_method_auto").style.display = 0 ? "block" : "none";
					document.getElementById("config_method_2").style.display = 1 ? "block" : "none";
					// update wep key info
					//`config.wireless.keylen

					//					<span id="key_0">12345678902551234567890255</span>
					//					<span id="key_1">12345678902551234567890255</span>
					//					<span id="key_2">12345678902551234567890255</span>
					//					<span id="key_3">12345678902551234567890255</span>
				
					var keylen = "0";
					var key0 = "12345678902551234567890255";
					var key1 = "12345678902551234567890255";
					var key2 = "12345678902551234567890255";
					var key3 = "12345678902551234567890255";
					
					if(  keylen == "0") {
						key0 = key0.substring(0,10);
						key1 = key1.substring(0,10);
						key2 = key2.substring(0,10);
						key3 = key3.substring(0,10);
					
					}
				}
			
			}

		}

		/*
		 * Show next page.
		 */
		function wz_next()
		{
			wz_cur++;
			if (wz_cur == wz_method_list_page + 1) {
				display_config_page();
			}
			wz_showhide();
		}

		/*
		 * Show previous page.
		 */
		function wz_prev()
		{
			wz_cur--;
			wz_showhide();
		}

		/*
		 *  PIN method
		 */
		function start_wifisc_config_0()
		{
			if(get_by_id("wireless_mode").value == 1)//1:client
			{
				var pin = trim_string(wifisc_current_pin);
			}
			else
			{
				var pin = trim_string(mf.wireless_device_pin.value);
				if (!verify_wifisc_pin(pin)) {
					mf.wireless_device_pin.select();
					mf.wireless_device_pin.focus();
					return;
				}
				if(pin.length == 9){
					var i,c;
					var pinValue = "";
					for (i=0; i < pin.length; i++){
						c = pin.charAt(i);
						if(i == 4 && (c == '-' || c == ' ')) continue;
						pinValue += c;
					}
					pin = pinValue;
				}
			}
			
			wifisc_connect('/Basic/wifisc_add_sta.asp?method=pin&amp;pin=' + pin);
		}

		/*
		 *  Push button method
		 */
		function start_wifisc_config_1()
		{
			wifisc_connect('/Basic/wifisc_add_sta.asp?method=pbutton');
		}

		/*
		 *  Manual method
		 */
		function start_wifisc_config_2()
		{
			/*
			 *  Go to Wireless Status page
			 */
			top.location="../Status/Wireless.asp";
		}

		var start_wifisc_config = [ start_wifisc_config_0, start_wifisc_config_1, start_wifisc_config_2];

		/*
		 * For Manual configuration method, we need to get key in use for WEP
		 */
		function display_wep_key_in_use()
		{
			var node = document.getElementById("keylen");
			if (node) {
				var len = (node.innerHTML == 0) ? 10 : 26;
				for (var i = 0; i < 4; i++) {
					var key = document.getElementById("key_" + i);
					if (key) {
						key.innerHTML = key.innerHTML.substring(0, len);
					}
				}
				var key_in_use = parseInt("0", 10);
				document.getElementById("key_in_use").innerHTML = key_in_use + 1;
			}
		}

		function config_method_selector(method)
		{
			config_method = method;
			//set_radio(mf.config_method_radio, method);
		}

		function display_config_page()
		{
			/*
			 * For Manual configuration method, we need to get key in use for WEP
			 */
			if (config_method == 2) {
				display_wep_key_in_use();
			}
			for (var i = 0; i <= 2; i++) {
				document.getElementById("config_method_" + i).style.display = (config_method == i) ? "block" : "none";
			}
		}
//add by tsrites 2009.5.15 for PIN rule check
function verify_wps_pin(pin)
{
	var i, c, csum = 0;
	var j = 0;
	var pinValue = "";
	
	//if (pin.length != 8) return false;
	for (i=0; i < pin.length; i++)
	{
		c = pin.charAt(i);
		if(i == 4 && (c == '-' || c == ' ')) continue;
		if (c > '9' || c < '0') return false;
		pinValue += c;
		csum += parseInt(c,[10]) * (((j%2)==0) ? 3:1);
		j++;
	}
	//return ((csum % 10)==0) ? true : false;
	if(pinValue.length != 4 && pinValue.length != 8) return false;
	if(pinValue.length == 8 && ((csum % 10) != 0)) return false;
}

		function verify_wifisc_pin(pin)
		{	
			if (is_blank(pin)) {
				alert(sw("txtWirelessPINBlank"));
				return false;
			}
			//if (!is_number(pin) || (pin < 0)) {
			if (pin < 0) {
				alert(sw("txtWirelessPINValid"));
				return false;
			}
			//if (pin.length != 4 && pin.length != 8) {
			
			if(verify_wps_pin(pin) == false)
			{
						alert(sw("txtWirelessPINValid"));
						return false;
			}
			/*
			if (pin.length != 8) {
				alert(sw("txtInvalidPINnumber"));
				return false;
			}
			*/
			return true;
		}

		function wifisc_connect(url)
		{
			wifisc_add_sta_retriever.dataURL = url;
			wifisc_add_sta_retriever.retrieveData();
		}

		function clear_timers()
		{
			if (wifisc_add_sta_progress_retriever_timer != 0) {
				window.clearTimeout(wifisc_add_sta_progress_retriever_timer);
				wifisc_add_sta_progress_retriever_timer = 0;
			}

			if (wifisc_add_sta_countdown_timer != 0) {
				window.clearTimeout(wifisc_add_sta_countdown_timer);
				wifisc_add_sta_countdown_timer = 0;
			}
		}

		function update_progress_message(message)
		{
		  //20070723 add tag
		  	if(get_by_id("wireless_mode").value == 1) /* 1: ap client */
			{
				message = sw("txtJoiningWirelessDevice")+" "+message ;
			}
			else
			{
				message = sw("txtAddingWirelessDevice")+" "+message ;
			}
			
			document.getElementById("add_sta_progress_message_2").innerHTML = message;
			/*
			 * Display progress_message_1 and progress bar only when we are in the process of adding device.
			 */
			document.getElementById("add_sta_progress_message_1").style.display = state_in_progress ? "block" : "none";
			document.getElementById("add_sta_progress_bar").style.display = state_in_progress ? "block" : "none";
		}

		function wifisc_add_sta_ready(dataInstance)
		{
			/*
			 * Display the wizard progress page
			 */
			wz_next();
			var message ="";
			var status = dataInstance.getElementData("status");

			if (status == "succeeded") {
				message = (sw("txtStarted"));
				state_in_progress = true;
				update_progress_message(message);
				refresh_progress_bar(0);
				countdown();
				wifisc_add_sta_progress_retriever.retrieveData();
				return;
			}
			if (status == "session overlap") {
				message = (sw("txtSessionOverlapDetected"));
				update_progress_message(message);
				return;
			} 
			message = (sw("txtFailed"));
			update_progress_message(message);
		}

		function wifisc_cancel_add_sta_ready(dataInstance)
		{
			var message ="";
			var status = dataInstance.getElementData("status");

			if (status == "succeeded") {
				message = (sw("txtWizardAddWlanDeviceStr1"));
				state_in_progress = false;
				update_progress_message(message);
				return;
			} 
			message = (sw("txtCannotStopProcess"));
			update_progress_message(message);
		}

		/*
		 * We check the progress for about 120 seconds as the session times out in 2 minutes.
		 */
		var timeleft = 120;
		function countdown()
		{
			if (timeleft) {
				timeleft--;
				document.getElementById("add_sta_progress_message_1_timeleft").innerHTML = timeleft;
				wifisc_add_sta_countdown_timer = window.setTimeout("countdown()", 1000);
				return;
			}

			var message = (sw("txtSessionTimeOut"));

			clear_timers();
			state_in_progress = false;
			update_progress_message(message);
		}

		function clear_progress_bar()
		{
		    index =8;
			var bar_color = "white";
			var clear = "&nbsp;&nbsp;&nbsp;"
			for (i = 0; i <= index; i++) {
				var block = document.getElementById("block" + i);
				block.innerHTML = clear;
				block.style.backgroundColor = bar_color;
			}

		}

		function refresh_progress_bar(index)
		{
			//alert(index);
			var bar_color = "forestgreen";
			var clear = "&nbsp;&nbsp;&nbsp;"
			for (i = 0; i <= index; i++) {
				var block = document.getElementById("block" + i);
				block.innerHTML = clear;
				block.style.backgroundColor = bar_color;
			}
		}

		function wifisc_add_sta_progress_ready(dataInstance)
		{
			var code = dataInstance.getElementData("progress_code");
			var progress_message = sw("txtInProgress");
			// progress_message = progress_message + " code = " + code;

			/*
			 * If progress code is "99" or "0-7", continue retrieving the progress, otherwise we stop the retrieval by clearing the timer.
			 */
			switch (code) {
			case "99":
				wifisc_add_sta_progress_retriever_timer = window.setTimeout("wifisc_add_sta_progress_retriever.retrieveData();", 3000);
				return;
			case "0":
			case "1":
			case "2":
			case "3":
			case "4":
			case "5":
			case "6":
			case "7":
			case "8":
				refresh_progress_bar(code);
				update_progress_message(progress_message);
				wifisc_add_sta_progress_retriever_timer = window.setTimeout("wifisc_add_sta_progress_retriever.retrieveData();", 2000);
				return;
			case "9":
				progress_message = sw("txtWizardAddWlanDeviceStr2");
				disable_form_field(document.getElementById("wz_save_b"), false);
				break;
			case "10":
				progress_message = sw("txtSessionAborted");
				break;
			case "11":
				progress_message = sw("txtSessionOverlapDetected");
				break;
			case "12":  // Received Unexpected Message, continue retrieving until we got the Abort event.
			case "13":  // Received NACK, continue retrieving until we got the Abort event.
			case "14":  // Sent NACK, continue retrieving until we got the Abort event.
				wifisc_add_sta_progress_retriever_timer = window.setTimeout("wifisc_add_sta_progress_retriever.retrieveData();", 2000);
				return;
			case "15":
				progress_message = sw("txtSessionTimeOut");
				break;
			case "16":
				progress_message = sw("txtPIN1stMismatchDetected");
				break;
			case "17":
				progress_message = sw("txtPIN2ndMismatchDetected");
				break;
			case "18":
				progress_message = sw("txtSessionAborted");
				break;
			default:
				progress_message = sw("txtReceivedUnknownMessage");
				break;
			}

			clear_timers();
			state_in_progress = false;
			update_progress_message(progress_message);
		}

		function show_ssid()
		{
			var ssid="<%getInfo("ssid");%>";
			var new_ssid="";
			for(i=0;i<ssid.length;i++)
			{
				var char=ssid.substring(i,i+1);
				if(char==' ')
				{
					new_ssid+="&nbsp;";
				}
				else if(char=='&')
       	{
             new_ssid+="&amp;";
      	}
				else
				{
					new_ssid+=char;
				}
			}
			document.getElementById("ssid").innerHTML = new_ssid;
		}
		
		function page_load() 
		{
			mf = document.forms.mainform;

			show_ssid();
			/* 
			 * For debugging on a local client. 
			 */
			if ("" != "") {
				hide_all_ssi_tr();
				wz_showhide();
				return;
			}

			wz_showhide();
			/*
			 * Start adding wifisc device
			 */
			wifisc_add_sta_retriever = new xmlDataObject(wifisc_add_sta_ready, null, null, "/Basic/wifisc_add_sta_init.asp");
			/*
			 * Get wifisc device connecting progress
			 */
			wifisc_add_sta_progress_retriever = new xmlDataObject(wifisc_add_sta_progress_ready, null, 3000, "/Basic/wifisc_add_sta_progress.asp");
			/*
			 * Stop adding wifisc device
			 */
			wifisc_cancel_add_sta_retriever = new xmlDataObject(wifisc_cancel_add_sta_ready, null, null, "/Basic/wifisc_cancel_add_sta.asp");
			set_form_default_values("mainform");

			/* Check for validation errors. */
			var verify_failed = "<%getInfo("err_msg")%>";
			if (verify_failed != "") {
				wz_min = 2;
				wz_cur = 2;
				wz_showhide();
				alert(verify_failed);
				verify_failed = "";
			}

			var reboot_needed = "";
			var wz_complete = "";
			if ((wz_complete == "completed") && (reboot_needed == "false")) {
				do_back();
			}
		}

		function page_submit()
		{
			/*
			 * Go to the Wireless Status page directly at the end of adding wireless device
			 */
			if( wz_cur == 3) {
				if( mf.config_method_radio_auto.checked ) {

					//if( mf.config_method_radio_0.checked ) {
					//	start_wifisc_config_0();
					//}
					//else {
					//	start_wifisc_config_1();
					//}


					//if (typeof(start_wifisc_config[config_method]) == "function") {
					//	start_wifisc_config[config_method]();
					//}

				}
				else {
					top.location="../Status/Wireless.asp";
					return;
				
				}
			}
				 			 
			 
			 
			if (wz_cur == wz_max) {
				top.location="../Status/Wireless.asp";
				return;
			}

			if (typeof(start_wifisc_config[config_method]) == "function") {
			
				// 2007.05.23
				timeleft = 120;
				//refresh_progress_bar(0);
				clear_progress_bar();

				if( config_method == 0) {
					// PIN
					if(get_by_id("wireless_mode").value == 1)
					{
						var s = sw("txtWizardAddWlanDeviceStr15"); 
					}
					else
					{						
						var s = sw("txtWizardAddWlanDeviceStr3"); 				
					}
					document.getElementById("add_sta_progress_message_1_main").innerHTML = s;

				}
				else 
				{
					// PBC
					if(get_by_id("wireless_mode").value == 1)
					{
						var s = sw("txtWizardAddWlanDeviceStr16"); 
					}
					else
					{						
						var s = sw("txtWizardAddWlanDeviceStr4"); 				
					}			
					document.getElementById("add_sta_progress_message_1_main").innerHTML = s;
				}
			
				start_wifisc_config[config_method]();
			}
		}

		/*
		 * We have "Add Wireless Device" button on both Advanced/Protected_Setup.asp and Basic/Wizard_Add_Wireless_Device.asp. 
		 * For the Cancel command, we go back to the previous page.
		 */
		function do_back()
		{
			history.back();
		}

		function page_cancel()
		{
			/*
			 * Trigger the cgi function to stop the process if we are in the process of adding a wireless device  
			 */
			if (state_in_progress) {
				clear_timers();
				wifisc_cancel_add_sta_retriever.retrieveData();
				return;
			}

			//alert(wz_cur);
			if( wz_cur == wz_max) {
				wz_cur = 2;
				wz_showhide();
				return;
			}

			/*
			 * Go to the wizard page directly at the end of adding wireless device
			 */
			 if (wz_cur == wz_max) {
				do_back();
				return;
			}

			if( wz_cur == 3) {
				do_back();
				return;
			
			}
			
			if (is_form_modified("mainform")) {
				if (confirm (sw("txtAccessControlStr15"))) {
					do_back();
				}
			} else {
				do_back();
			}
		}

		function init()
		{
			var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtAddWPS");
			document.title = DOC_Title;	
			get_by_id("RestartNow").value = sw("txtRebootNow");
			get_by_id("RestartLater").value = sw("txtRebootLater");
			get_by_id("wz_prev_b").value = sw("txtPrev");
			get_by_id("wz_next_b").value = sw("txtNext");
			get_by_id("wz_cancel_b").value = sw("txtCancel");
			get_by_id("wz_save_b").value = sw("txtConnect");	
		}		
	//]]>
	</script>
	<!-- InstanceEndEditable -->
</head>
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();

</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">
<div id="rebootcontent_1col" style="display: none">
<div class="section"><div class="section_head">
<h2><SCRIPT >ddw("txtRebootNeeded");</SCRIPT></h2>
<p><SCRIPT >ddw("txtIndexStr5");</SCRIPT></p>
<input class="button_submit" id="RestartNow" type="button" value="" onclick="do_reboot()" />
<input class="button_submit" id="RestartLater" type="button" value="" onclick="no_reboot()" />
</div></div> <!-- reboot_warning --></div>
<div id="maincontent_1col" style="display: block">
<!-- InstanceBeginEditable name="Main_Content" -->
<form id="mainform" name="mainform" action="/Basic/Wizard_Add_Wireless_Device.asp" method="post">
<div class="box"><div id="wz_page_1">
<h3><SCRIPT >ddw("txtWizardAddWlanDeviceStr5");</SCRIPT></h3>
<p class="box_msg">
<SCRIPT >ddw("txtWizardAddWlanDeviceStr6");</SCRIPT>
</p><fieldset>
<ul><li>	<SCRIPT >ddw("txtWizardAddWlanDeviceStep1");</SCRIPT></li>
<li><SCRIPT >ddw("txtWizardAddWlanDeviceStep2");</SCRIPT></li>
</ul></fieldset></div><!-- wz_page_1 -->
<div id="wz_page_2" style="display:none">
<h3><SCRIPT >ddw("txtWizardAddWlanDeviceStep1");</SCRIPT></h3>
<p class="box_msg" style="display:block"><SCRIPT >ddw("txtWizardAddWlanDeviceStr7");</SCRIPT>
</p><fieldset>
<p><label for="config_method_radio_auto"><b>
<SCRIPT >ddw("txtAuto");</SCRIPT></b></label>
<input type="radio" id="config_method_radio_auto" name="config_method_radio_wz2" value="0" checked="checked"/>
<SCRIPT >ddw("txtWizardAddWlanDeviceStr8");</SCRIPT>
</p><p>
<label for="config_method_radio_2"><b>
<SCRIPT >ddw("txtManual");</SCRIPT>
</b></label>
<input type="radio" id="config_method_radio_2" name="config_method_radio_wz2" value="2"  />
<SCRIPT >ddw("txtWizardAddWlanDeviceStr9");</SCRIPT>
</p></fieldset></div><!-- wz_page_2 -->
<div id="wz_page_3" style="display:none">
<h3><SCRIPT >ddw("txtWizardAddWlanDeviceStep2");</SCRIPT></h3>
<input type="hidden" name="wz_complete" value="completed"/>
<div id="config_method_0"></div>
<div id="config_method_1"></div>
<div id="config_method_auto">
<fieldset>
<p><SCRIPT >ddw("txtSetup");</SCRIPT></p>
<p><SCRIPT >ddw("txtWPSPin");</SCRIPT></p>
<p><SCRIPT >ddw("txtWPSPBC");</SCRIPT></p>								
</fieldset><fieldset><p></p></fieldset>
<fieldset>
<input type="hidden" id="wireless_mode" name="wireless_mode" value="<%getIndexInfo("wlanMode");%>" />
<div id="box_pin_text" style="display:none">
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="radio" id="config_method_radio_0" name="config_method_radio" value="0" onclick="config_method_selector(this.value);" />
<B>PIN:</B>
<input type="text" size="20" maxlength="9" id="wireless_device_pin" name="config.wireless.device_pin"/>
</div>

<div id="box_pin_label" style="display:none">	
<p><label class="duple" for="config_method_radio_3"></label>
<input type="radio" id="config_method_radio_3" name="config_method_radio" value="0"  onclick="config_method_selector(this.value);" />
<B>PIN:</B>
<span id="pin_label"></span>
</div>

<br>
<SCRIPT >
if(get_by_id("wireless_mode").value == 1) /* 1: ap client */
{
ddw("txtWizardAddWlanDeviceStr14");
}
else
{
ddw("txtWizardAddWlanDeviceStr11");
}
</SCRIPT>
</p></fieldset><fieldset>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="radio" id="config_method_radio_1" name="config_method_radio" value="1" onclick="config_method_selector(this.value);" />
<B>PBC</B>
<br><SCRIPT >
ddw("txtWizardAddWlanDeviceStr12");
if(get_by_id("wireless_mode").value == 1) /* 1: ap client */
{
	document.getElementById("box_pin_text").style.display = "none";
	document.getElementById("box_pin_label").style.display = "block";
	document.getElementById("pin_label").innerHTML = wifisc_current_pin;
	get_by_id("config_method_radio_3").checked=true;
}
else
{
	document.getElementById("box_pin_text").style.display = "block";
	document.getElementById("box_pin_label").style.display = "none";
	document.getElementById("pin_label").innerHTML="";
	get_by_id("config_method_radio_0").checked=true;
}
</SCRIPT>
</p></fieldset></div>
<div id="config_method_2"><p class="box_msg">
<SCRIPT >ddw("txtWizardAddWlanDeviceStr13");</SCRIPT>
</p><fieldset><p>SSID&nbsp;:<span class="output" id="ssid"></span></p>
<p>	<SCRIPT >ddw("txtSecurityMode");</SCRIPT>	:
<SCRIPT >
	if ("<%getIndexInfo("wep_enabled");%>" == "true")
		document.write("WEP-");
	else if ("<%getIndexInfo("wpa_psk_enabled");%>" == "true")
		ddw("txtWPAPersonal");
	else if ("<%getIndexInfo("wpa_enterprise_enabled");%>" == "true")
		ddw("txtWPAEnterprise");
	else
		ddw("txtNONE");
</SCRIPT>

<SCRIPT >
	if ("<%getIndexInfo("wep_enabled");%>" == "true") 
	{
		wep_auth = "<%getIndexInfo("wep_auth");%>";
		if(wep_auth == 1)
			ddw("txtBoth");
		else
			ddw("txtSharedKey");

		document.write("<p>");

		defaultKey = "<%getIndexInfo("defaultKeyId");%>";

		ddw("txtWepKey");document.write("&nbsp;:&nbsp;");
		document.write("<%getIndexInfo("wepDefKey");%>");
/*		
		if(defaultKey == 0)
			document.write("<%getIndexInfo("wepkey1");%>");		
		else if(defaultKey == 1)
			document.write("<%getIndexInfo("wepkey2");%>");
		else if(defaultKey == 2)
			document.write("<%getIndexInfo("wepkey3");%>");
		else if(defaultKey == 3)
			document.write("<%getIndexInfo("wepkey4");%>");
*/			
		document.write("<p>");

		
		ddw("txtKeyInUse"); document.write("&nbsp;:&nbsp;");
		document.write("<%getIndexInfo("defaultKeyId");%>"*1);
		
		
 	}	
</SCRIPT>

<SCRIPT >
	if ("<%getIndexInfo("wpa_enabled");%>" == "true") {
		var wpa_mode = "<%getIndexInfo("wpa_mode");%>";
		if(wpa_mode == 2)
			document.write("(WPA/WPA2 Auto)");
		else if(wpa_mode == 3)
			document.write("(WPA2)");
		else if(wpa_mode == 1)
			document.write("(WPA)");

			
		document.write("<p>");		
		ddw("txtCipherType"); document.write("&nbsp;:");
		cipher = "<%getIndexInfo("wpaCipher");%>";
		if (cipher == "1")
			document.write("TKIP");
		else if (cipher == "2")
			document.write("AES");
		else
			ddw("txtTKIPandAES");
		document.write("</p>");

	 	if ("<%getIndexInfo("wpa_enterprise_enabled");%>" == "false") {		
			document.write("<p>");
			ddw("txtPreSharedKey"); document.write("&nbsp;:");
			document.write("<%getInfo("pskValue");%>");	
			document.write("</p>");			
	 	}
 	}	
</SCRIPT>

</p></fieldset></div></div><!-- wz_page_3 -->
<div id="wz_page_4" style="display:none">
<h3><SCRIPT >ddw("txtWizardAddWlanDeviceStep2");</SCRIPT></h3>
<input type="hidden" name="wz_complete" value="completed"/>
<div><fieldset>
<p id="add_sta_progress_message_1" style="display:none">								
<span id="add_sta_progress_message_1_main">&nbsp;</span>
<span id="add_sta_progress_message_1_timeleft">&nbsp;</span>
<SCRIPT >ddw("txtSeconds");</SCRIPT>
</p>
<p><span id="add_sta_progress_message_2">&nbsp;</span></p>
<div id="add_sta_progress_bar" style="display:none">
<span id="block0">&nbsp;</span>
<span id="block1">&nbsp;</span>
<span id="block2">&nbsp;</span>
<span id="block3">&nbsp;</span>
<span id="block4">&nbsp;</span>
<span id="block5">&nbsp;</span>
<span id="block6">&nbsp;</span>
<span id="block7">&nbsp;</span>
<span id="block8">&nbsp;</span>
</div></fieldset></div></div><!-- wz_page_4 -->
<fieldset id="wz_buttons">
<p>
<label class="duple"></label>
<input type="button" class="button_submit" id="wz_prev_b" value="" onclick="wz_prev();" disabled="disabled"/>
<input type="button" class="button_submit" id="wz_next_b" value="" onclick="wz_next();"/>
<input type="button" class="button_submit" id="wz_cancel_b" value="" onclick="page_cancel();"/>
<input type="button" class="button_submit" id="wz_save_b" value="" onclick="page_submit();" disabled="disabled"/>
</p></fieldset></div></form>
<!-- InstanceEndEditable -->
</div>
<!-- language selection functions -->
<% getFeatureMark("MultiLangSupport_Head"); %>								
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td>
<td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
<!-- InstanceEnd -->
</html>
