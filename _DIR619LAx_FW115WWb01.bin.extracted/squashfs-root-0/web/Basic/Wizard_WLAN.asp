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
	document.forms["rebootdummy"].act.value="do_reboot";
	document.forms["rebootdummy"].next_page.value="Basic/Wizard_Wireless.asp";	
	document.forms["rebootdummy"].submit();
}
function no_reboot()
{
	document.forms["rebootdummy"].next_page.value="Basic/Wizard_Wireless.asp";
	document.forms["rebootdummy"].submit();
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
/* * Render any warnings to the user */
RenderWarnings();
}
//]]>
</script>
<script type="text/javascript" src="../md5.js"></script>
<script type="text/javascript">
//<![CDATA[
/*
* Set the no reboot location parameter to the wizard launch page
*/
		no_reboot_alt_location = "Wizard_Wireless.asp";

		/*
		 * Handle for document.mainform.
		 */
		var mf;

		/*
		 * WLAN security mode and key.
		 */
		var security_mode;
		var security_key;

		/*
		 * Wi-Fi Protected Setup network settings
		 */
		var wifisc_ssid;
		var wifisc_security_mode;
		var wifisc_cipher_type;
		var wifisc_psk;

		/*
		 * Wizard pages.
		 */
		var wz_min = 1;
		var wz_cur = 1;
		var wz_max = 5;
		var wz_sec = 3;

		/*
		 * Show/Hide wizard pages and buttons.
		 */
		function wz_showhide()
		{
			for (var i = 0; i <= wz_max; i++) {
				document.getElementById("wz_page_" + i).style.display = wz_cur == i ? "block" : "none";
			}
			disable_form_field(document.getElementById("wz_prev_b"), wz_cur == wz_min ? true : false);
			disable_form_field(document.getElementById("wz_next_b"), wz_cur == wz_max ? true : false);
			disable_form_field(document.getElementById("wz_save_b"), wz_cur == wz_max ? false : true);

			/*
			 * Grey out auto and push button methods if wifisc is disabled
			 */
			var wifisc_disabled = "true" == "false";
			if ((wz_cur == wz_min) && wifisc_disabled) {
				disable_form_field(mf.config_method_radio_auto, true);
				mf.config_method_radio_manual.checked = true;
			}
			scroll(0, 0);
		}
		var RUN_auto_wpapsk=0; // spcial
		/*
		 * Validate current page and then show next page.
		 */
		function wz_next()
		{
			/*
			  * Manual Setup selected, verify/display user configurations.
			  */
			if (typeof(wz_verify[wz_cur - 1]) == "function" && !wz_verify[wz_cur - 1]()) {
				return;
			}

			if( wz_cur == 3) {
				if( (mf.wl_key_assign.checked) &&  (mf.wl_wpa_enable.checked) ) {
					mf.config_method_radio_auto.checked = true;		
					RUN_auto_wpapsk = 1;		
					security_mode_selector(2);					
					wifisc_ap_auto_setup();					
					return;
				}
				else {
					mf.config_method_radio_auto.checked = false;
					
					if(mf.wl_no_encription.checked) {
						// no encription 	
						security_mode_selector(0);					
					}
					else if( (!mf.wl_key_assign.checked) &&  (mf.wl_wpa_enable.checked) ) {
						// manual WPA/WPA PSK 	
						security_mode_selector(2);					
					}
					else if( (!mf.wl_key_assign.checked) &&  (!mf.wl_wpa_enable.checked) ) {
						// manual WEP Key 
						security_mode_selector(1);						
					}
					else {
						// Auto WEP Key
						// manual WEP Key 
						
						// force WEP 128
						change_wep_key_info(1);
						
						mf.config_method_radio_auto.checked = true;
						security_mode_selector(1);						
						get_auto_wepkey_setup();
						return;
					}

					
				}
			
			}
			/*
			  * Auto Setup selected, generate/display Wi-Fi Protected Setup network settings.
			  */
			if (mf.config_method_radio_auto.checked == true) {
				
				if (wz_cur == 0) {
					/*
					 * Generate settings
					 */
					wifisc_ap_auto_setup();
				} else if (wz_cur == wz_max) {
					/*
					 * Display  settings
					 */
					update_summary();
					wz_showhide();
				}
				return;
			}


			/* 
			 * Skip password page if no security.
			 */		 
			if (security_mode === 0 && wz_cur == wz_sec) {
				wz_cur = wz_max;
			} else {
				wz_cur++;
			}

			if (wz_cur == wz_max) {
				update_summary();
			}
			
			if(wz_cur == 2)//skip page 2
				wz_cur++;
			wz_showhide();
		}

		/*
		 * Show previous page.
		 */
		function wz_prev()
		{
			/*
			  * Auto Setup selected, skip all pages not related to auto setup.
			  */
			if (mf.config_method_radio_auto.checked == true) {

				if(wz_cur == wz_max)
				{
					wz_cur = wz_sec;
				}
				//wz_cur = wz_min;
				mf.config_method_radio_auto.checked = false;
				wz_showhide();
				return;
			}

			/*
			  * Manual Setup selected, skip password page if no security. 
			  */
			if (security_mode === 0 && wz_cur == wz_max) {
				wz_cur = wz_sec;
			} else {
				wz_cur--;
			}
			if(wz_cur == 2)//skip page 2
				wz_cur--;
			wz_showhide();
		}

		/*
		 * Wizard page verifier functions.
		 *	There must be one verifier per wizard page.
		 *	The array wz_verify contains pointers to these functions.
		 */
		function wz_verify_3()
		{
			/* SSID page. */
			mf.wireless_SSID.value = trim_string(mf.wireless_SSID.value);
			if (is_blank(mf.wireless_SSID.value)) {
				alert(sw("txtSSIDBlank"));
				mf.wireless_SSID.select();
				mf.wireless_SSID.focus();
				return false;
			}
			if (strchk_unicode(mf.wireless_SSID.value)) {
				alert(sw("txtInvalidSSID"));
				mf.wireless_SSID.select();
				mf.wireless_SSID.focus();
				return false;
			}
			return true;
		}

		function wz_verify_4()
		{
			var phrase = trim_string(mf.wlan_passwd.value);

			if(strchk_unicode(mf.wlan_passwd.value)==true)
			{
				alert(sw("txtWizard_WlanStrerr"));
				return false;
			}

			if (security_mode == 2 || security_mode == 3) {
				if (phrase.length < 8 || phrase.length > 64) {
						alert(sw("txtWizard_WlanStr1"));
						return false;
				}
				if(phrase.length >= 8 && phrase.length < 64)
				{
					if(mf.wlan_passwd.value.charAt(0)== ' ' || mf.wlan_passwd.value.charAt(phrase.length) == ' ')
					{
						alert(sw("txtheadtailnospeace"));
						mf.wlan_passwd.select();
                                        	mf.wlan_passwd.focus();
                                	     	return false;
					}
				}
				if(phrase.length == 64 && !phrase.match(/^[a-fA-F0-9]+$/))
				{
					alert(sw("txtWPAKeyHexadecimalDigits"));
					mf.wlan_passwd.select();
					mf.wlan_passwd.focus();
					return false;
				}

				mf.wireless_wpa_psk.value = phrase;
				security_key = phrase;
			} else if (security_mode == 1) {
				if ((phrase.length != 13) && (phrase.length != 26) && (phrase.length != 5) && (phrase.length != 10) ) {
					alert(sw("txtWizard_WlanStr2") + phrase.length + ".");
					return false;
				}

				if (phrase.length == 13) {
					// force WEP 128
					change_wep_key_info(1);

					var got = phrase.match(/^[a-zA-Z0-9]+$/);
					// 2007.04.25
					got = 1;
					if (!got) {
						alert(sw("txtWEPPassword13AlphanumericCharacters"));
						return false;
					} else {
						var newkey = '';
						for (var i = 0; i < 13; i++) {
							if (i < phrase.length) {
								var c = phrase.charCodeAt(i);
								var s = c.toString(16);
								if (s.length < 2) {
									s = '0' + s;
								}
								newkey += s;
							} else {
								newkey += '00';
							}
						}
						mf.wireless_wep_key.value = newkey;
						security_key = phrase;
						mf.f_wep_format.value = 1 ;
					}
					
				} else if (phrase.length == 26) { // 26 hex digits
					// force WEP 128
					change_wep_key_info(1);
				
					var got = phrase.match(/^\s*([0-9a-fA-F]+)\s*$/);
					if (!got) {
						alert(sw("txtWEPKey26HexadecimalDigits"));
						return false;
					}
					mf.wireless_wep_key.value = phrase;
					security_key = phrase;
					mf.f_wep_format.value = 2 ;
				}
				else if (phrase.length == 5) {
					// force WEP 64
					change_wep_key_info(0);

					var got = phrase.match(/^[a-zA-Z0-9]+$/);
					// 2007.04.25
					got = 1;
					if (!got) {
						alert(sw("txtWEPPassword5AlphanumericCharacters"));
						return false;
					} else {
						var newkey = '';
						for (var i = 0; i < 5; i++) {
							if (i < phrase.length) {
								var c = phrase.charCodeAt(i);
								var s = c.toString(16);
								if (s.length < 2) {
									s = '0' + s;
								}
								newkey += s;
							} else {
								newkey += '00';
							}
						}
						mf.wireless_wep_key.value = newkey;
						security_key = phrase;
						mf.f_wep_format.value = 1 ;
					}
				} else { // 10 hex digits
					// force WEP 64
					change_wep_key_info(0);

					var got = phrase.match(/^\s*([0-9a-fA-F]+)\s*$/);
					if (!got) {
						alert(sw("txtWEPKey10HexadecimalDigits"));
						return false;
					}
					mf.wireless_wep_key.value = phrase;
					security_key = phrase;
					mf.f_wep_format.value = 2 ;
				}
				
			}
			return true;
		}

		var wz_verify = [ null, null,wz_verify_3, wz_verify_4 ];

		function security_mode_selector(mode)
		{

			security_mode = mode * 1;
			mf.wireless_wepon.value = (mode == 1)? "true" : "false";
			mf.wireless_wpa_enabled.value = (mode == 2 || mode == 3)? "true" : "false";
			//mf.wireless_wpa_mode.value = (mode == 2)? "1" : "3";	// WPA Only or WPA2 Only
			//mf.wireless_wpa_cipher.value = (mode == 2)? "1" : "2";	// WPA->TKIP, WPA2->AES
			mf.wireless_wpa_mode.value = "2" ; //(mode == 2)? "1" : "3";	// WPA Only or WPA2 Only
			mf.wireless_wpa_cipher.value = "3" ; //(mode == 2)? "1" : "2";	// WPA->TKIP, WPA2->AES
			if (mode == 1) {
				print_wlan_passwd_wep_wpa(1);
				document.getElementById("wlan_passwd_wep").style.display = "";
				document.getElementById("wlan_passwd_wpa").style.display = "none";
				document.getElementById("wlan_passwd").size = "26";
				document.getElementById("wlan_passwd").maxLength = "26";
			} else if (mode == 2 || mode == 3) {
				print_wlan_passwd_wep_wpa(0);			
				document.getElementById("wlan_passwd_wep").style.display = "none";
				document.getElementById("wlan_passwd_wpa").style.display = "";
				document.getElementById("wlan_passwd").size = "64";
				document.getElementById("wlan_passwd").maxLength = "64";
			} else if(mode == 0) {
				document.getElementById("wlan_passwd_wep").style.display = "none";
				document.getElementById("wlan_passwd_wpa").style.display = "none";
			}
			
			for (var i = 0; i < mf.security_mode_radio.length; i++) {
				if (mf.security_mode_radio[i].value == mode) {
					mf.security_mode_radio[i].checked = true;
				}
			}
			
			// force show 
			if( mode == 2 ||mode == 3) {
				document.getElementById("wifisc_cipher_type").innerHTML = sw("txtTKIPandAES");
				document.getElementById("wifisc_security_mode").innerHTML = sw("txtAutoWPAorWPA2Personal");			
			}
			
		}

		/*
		 * Update Wi-Fi Protected Setup network settings.
		 */
		function wifisc_summary_selector()
		{
			for (var i = 0; i <= 2; i++) 
			{
				var wifi_ssid = new String("");
				wifi_ssid=show_ssid(wifisc_ssid);
				document.getElementById("wlan_summary_ssid_"+i).innerHTML = wifi_ssid;
			}

			if (wifisc_security_mode == "1") {
				document.getElementById("wifisc_security_mode").innerHTML = sw("txtWPAOnly");
			} else if (wifisc_security_mode == "2") {
				document.getElementById("wifisc_security_mode").innerHTML = sw("txtAutoWPAorWPA2Personal");
			} else {
				document.getElementById("wifisc_security_mode").innerHTML = sw("txtWPA2Only");
			}

			if (wifisc_cipher_type == "1") {
				document.getElementById("wifisc_cipher_type").innerHTML = "TKIP";
			} else if (wifisc_cipher_type == "2") {
				document.getElementById("wifisc_cipher_type").innerHTML = "AES";
			} else {
				document.getElementById("wifisc_cipher_type").innerHTML = sw("txtTKIPandAES");
			}

			document.getElementById("wifisc_psk").innerHTML = wifisc_psk;
			
			
			// 2007.05.25 update again

			for (var i = 0; i <= 3; i++) 
			{
				var wifi_ssid = new String("");
				wifi_ssid=show_ssid(mf.wireless_SSID.value);
				document.getElementById("wlan_summary_ssid_"+i).innerHTML = wifi_ssid;
			}
			
			// 2007.08.16 update information
			document.getElementById("wifisc_security_mode").innerHTML = sw("txtAutoWPAorWPA2Personal");
			document.getElementById("wifisc_cipher_type").innerHTML = sw("txtTKIPandAES");
			
			
			
		}

		function print_wlan_passwd_wep_wpa(key)
		{
			if(key==1)//wep
			{
				get_by_id("wlan_passwd_wep_1").innerHTML=sw("txtWizard_WlanStr22");
				get_by_id("wlan_passwd_wep_2").innerHTML=sw("txtWizard_WlanStr23");
				get_by_id("wlan_passwd_wep_3").innerHTML=sw("txtWizard_WlanStr24");
				get_by_id("wlan_passwd_wep_4").innerHTML=sw("txtWizard_WlanStr25");
				get_by_id("wlan_passwd_wpa_1").innerHTML="";
				get_by_id("wlan_passwd_wpa_2").innerHTML="";
				get_by_id("wlan_passwd_wpa_3").innerHTML="";
			}
			else //wpa
			{
				get_by_id("wlan_passwd_wep_1").innerHTML="";
				get_by_id("wlan_passwd_wep_2").innerHTML="";
				get_by_id("wlan_passwd_wep_3").innerHTML="";
				get_by_id("wlan_passwd_wep_3").innerHTML="";
				get_by_id("wlan_passwd_wep_4").innerHTML="";
				get_by_id("wlan_passwd_wpa_1").innerHTML=sw("txtWizard_WlanStr26");
				get_by_id("wlan_passwd_wpa_2").innerHTML=sw("txtWizard_WlanStr27");
				get_by_id("wlan_passwd_wpa_3").innerHTML=sw("txtWizard_WlanStr28");
			
			}
		
		
		}
		function update_summary()
		{
			/*
			  * Auto Setup selected, update Wi-Fi Protected Setup network settings.
			  */
			if (mf.config_method_radio_auto.checked == true) {
				if( RUN_auto_wpapsk) {
					for (var i = 0; i <= 3; i++) {
						document.getElementById("wlan_summary_" + i).style.display = "none";
					}
					document.getElementById("wifisc_wlan_summary").style.display = "block";
					return;
				}
				else {
					for (var i = 0; i <= 3; i++) {
						document.getElementById("wlan_summary_" + i).style.display = "none";
					}
					document.getElementById("wifisc_wlan_summary").style.display = "none";

					i = 1;
					document.getElementById("wlan_summary_" + i).style.display = "block";

					return;
				
				}
			}

			/*
			  * Manual Setup selected, update user configured network settings.
			  */

			for (var i = 0; i <= 3; i++) 
			{
				document.getElementById("wlan_summary_" + i).style.display = security_mode == i ? "block" : "none";
			}
			for (var i = 0; i <= 3; i++) 
			{
				var wifi_ssid = new String("");
				wifi_ssid=show_ssid(mf.wireless_SSID.value);
				document.getElementById("wlan_summary_ssid_"+i).innerHTML = wifi_ssid;
			}
			document.getElementById("wifisc_wlan_summary").style.display = "none";

			if (security_mode != 0) 
			{
				var key_str = security_key;
				if(security_mode == 1)
				{
					for(var i=mf.wireless_wep_key.value.length; i<26 ; i++)
					{
						key_str +="&nbsp;&nbsp;";
						
					}
				}
				document.getElementById("wlan_summary_key_" + security_mode).innerHTML = key_str;
			}
		}

		/*
		 *  Start Wi-Fi Protected Setup and retrieve the generated network settings
		 */
		function wifisc_ap_auto_setup()
		{
			wifisc_ap_get_wpa_settings_retriever.retrieveData();
		}


		function get_auto_wepkey_setup()
		{
			RUN_auto_wpapsk = 0;				
			get_auto_wepkey_retriever.retrieveData();
		}

		function get_auto_wepkey_ready(dataInstance)
		{
			do {
				NewKey = dataInstance.getElementData("NewKey"); 
				if (NewKey == null) {
					break;
				}
				
				//mf.wlan_passwd.value = NewKey;
				mf.wlan_summary_key_1 = NewKey;
				mf.wireless_wep_key.value = NewKey;
				mf.f_wep_format.value = 2 ;
				
				// show information
				document.getElementById("wlan_summary_key_1").innerHTML = NewKey;

				for (var i = 0; i <= 3; i++) 
				{
					var wifi_ssid = new String("");
					wifi_ssid=show_ssid(mf.wireless_SSID.value);
					document.getElementById("wlan_summary_ssid_"+i).innerHTML = wifi_ssid;
				}
			
			
				wz_cur = wz_max;
//alert("wz_cur="+wz_cur +"__521");
				wz_next();
				return;
			} while (false);

			window.setTimeout("window.location.reload()", 5000);
		
		}

		function change_wep_key_info(value)
		{
			mf.wireless_keylen.value = value;
			var wep128 = sw("txt128Bits");
			var wep64 = sw("txt64Bits");
			var s;
			
			s = wep64;
			if( value == 1) {
				s = wep128;
			}
			
			document.getElementById("wepkey_info").innerHTML = s;
					
		}
		/*
		 *  Get Wi-Fi Protected Setup network settings
		 */
		function wifisc_ap_get_wpa_settings_ready(dataInstance)
		{
			/*
			 * Extract the settings from the document retrieved
			 */
			do {
				wifisc_ssid = dataInstance.getElementData("ssid"); 
				if (wifisc_ssid == null) {
					break;
				}
				wifisc_security_mode = dataInstance.getElementData("wpa_mode"); 
				if (wifisc_security_mode == null) {
					break;
				}
				wifisc_cipher_type = dataInstance.getElementData("wpa_cipher");
				if (wifisc_cipher_type == null) {
					break;
				}
				wifisc_psk = dataInstance.getElementData("wpa_psk");
				if (wifisc_psk == null) {
					break;
				}

				/*
				 * Update Wi-Fi Protected Setup network settings.
				 */
				wifisc_summary_selector();

				/*
				 * Display Wi-Fi Protected Setup network settings.
				 */
				wz_cur = wz_max;
				wz_next();
				return;
			} while (false);

			/*
			* Force a page refresh after a delay (we may have been logged out).
			*/
			window.setTimeout("window.location.reload()", 5000);
		}

		function wifisc_ap_save_wpa_settings_ready(dataInstance)
		{
			var status = dataInstance.getElementData("status");
			/*
			 * Note: If WiFiSC feature becomes a  no-reboot one as expected, we do not need to redirect to the reboot page.
			 */
			if (status == "succeeded") {
				top.location = "wifisc_gwws_reboot.asp";
				return;
			} else {
				top.location = "wifisc_gwws_failed.asp";
			}
		}
		function show_ssid(com_ssid)
		{
					var ssid=com_ssid;
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
					return new_ssid;
		}	
		function page_load() {

			mf = document.forms.mainform;

			/* For debugging on a local client. */
			if ("" != "") {
				hide_all_ssi_tr();
				wz_showhide();
				security_mode_selector("1");
				return;
			}

			wz_showhide();

			/*
			 * Create and start an XML retrieval object that we will use to get Wi-Fi Protected Setup network settings
			 */
			wifisc_ap_get_wpa_settings_retriever = new xmlDataObject(wifisc_ap_get_wpa_settings_ready, null, null, "/Basic/wifisc_ap_get_wpa_settings.asp");


			/*
			 *  get_auto_wepkey.xml
			 */
			get_auto_wepkey_retriever = new xmlDataObject(get_auto_wepkey_ready, null, null, "/Basic/get_auto_wepkey.asp");



			/*
			 * Create and start an XML retrieval object that we will use to save Wi-Fi Protected Setup network settings
			 */
//			wifisc_ap_save_wpa_settings_retriever = new xmlDataObject(wifisc_ap_save_wpa_settings_ready, null, null, "/Basic/wifisc_ap_save_wpa_settings.asp");

			security_mode = mf.wireless_wepon.value == "true" ? 1 : (mf.wireless_wpa_enabled.value == "true" && (mf.wireless_wpa_mode.value == "1" || mf.wireless_wpa_mode.value == "2"))? 2 : (mf.wireless_wpa_enabled.value == "true" && mf.wireless_wpa_mode.value == "3")? 3 : 0;

			security_mode_selector(security_mode);

			set_form_default_values("mainform");

			/* Check for validation errors. */
			var verify_failed = "<%getInfo("err_msg")%>";

			var wlan_band="<%getIndexInfo("band");%>";
			if (wlan_band == 0){
				mf.wl_wpa_enable.checked = true
			}

			if (verify_failed != "") {
				wz_min = 2;
				wz_cur = 2;
				wz_showhide();
				alert(verify_failed);
				verify_failed = "";
			}

			var reboot_needed = "";
			var wz_complete = "";

                        // 2007.04.25 fix "" should false
                        if( reboot_needed == "") {
                             reboot_needed = "false";
                        }
			
			if ((wz_complete == "completed") && (reboot_needed == "false")) {
				no_reboot();
			}


			mf.config_method_radio_manual.checked = true;
			
			
			mf.wl_no_encription.checked = true;
			wl_key_assign_radio_click(0);

		}

		function page_submit()
		{
			/*
			  * Auto Setup selected, save Wi-Fi Protected Setup network settings.
			  */
			if (mf.config_method_radio_auto.checked == true) {
				if( RUN_auto_wpapsk) { 
				
				//wifisc_ap_save_wpa_settings_retriever.retrieveData();
				//return;
				
				// update key
				// update ssid
				mf.wireless_wpa_psk.value = wifisc_psk;
				//mf.wireless_ssid.value = 

				}
			}

			/*
			  * Manual Setup selected, submit user configurations.
			  */
			if (!is_form_modified("mainform") && !confirm(sw("txtSaveAnyway"))) {
				no_reboot();
			} else {
				mf["settingsChanged"].value = 1;							
				mf.submit();
			}
		}

		function page_cancel()
		{
			if (is_form_modified("mainform")) {
				if (confirm (sw("txtAccessControlStr15"))) {
					no_reboot();
				}
			} else {
				no_reboot();
			}
		}
		
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtWirelessNetworkSetupWizard");
document.title = DOC_Title;	
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("wz_prev_b").value = sw("txtPrev");
get_by_id("wz_next_b").value = sw("txtNext");
get_by_id("wz_cancel_b").value = sw("txtCancel");
get_by_id("wz_save_b").value = sw("txtSave");

for(var i=1; i <= 5; i++)
{
	if(get_by_id("wz_prev_b_"+i))	get_by_id("wz_prev_b_"+i).value = sw("txtPrev");
	if(get_by_id("wz_next_b_"+i))	get_by_id("wz_next_b_"+i).value = sw("txtNext");
	if(get_by_id("wz_cancel_b_"+i))	get_by_id("wz_cancel_b_"+i).value = sw("txtCancel");
	if(get_by_id("wz_save_b_"+i)) get_by_id("wz_save_b_"+i).value = sw("txtSave");
}
		
}		

function wl_key_assign_radio_click(clickValue)
{
	var wlan_band="<%getIndexInfo("band");%>";
	if(clickValue == 0 || wlan_band == 0)
	{
		get_by_id("wl_wpa_enable").disabled=true;
	}
	else
	{
		get_by_id("wl_wpa_enable").disabled=false;
	}

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
				<SCRIPT>
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">
<SCRIPT>DrawRebootContent();</SCRIPT>
<div id="rebootcontent_1col" style="display: none">
	<div class="section">
		<div class="section_head">
<h2><SCRIPT>ddw("txtRebootNeeded");</SCRIPT></h2>
<p><SCRIPT>ddw("txtIndexStr5");</SCRIPT></p>
<input class="button_submit" id="RestartNow" type="button" value="" onclick="do_reboot()" />
<input class="button_submit" id="RestartLater" type="button" value="" onclick="no_reboot()" />
		</div>
	</div> <!-- reboot_warning -->
</div>
<div id="maincontent_1col" style="display: block">
<!-- InstanceBeginEditable name="Main_Content" -->
<form name="mainform" action="/goform/formWlanWizardSetup" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="webpage" name="webpage" value="/Basic/Wizard_Wireless.asp">

	<div id="wz_page_0" style="display:block">
<h3><SCRIPT>ddw("txtWizard_WlanStr3");</SCRIPT></h3>
<fieldset><p>	<label class="duple" for="config_method_radio_auto">
<SCRIPT>ddw("txtAuto");</SCRIPT></label>
<input type="radio" id="config_method_radio_auto" name="config_method_radio" value="0" checked="checked"/>
<SCRIPT>ddw("txtWizard_WlanStr4");</SCRIPT>
</p><p><label class="duple" for="config_method_radio_manual">
<SCRIPT>ddw("txtManual");</SCRIPT></label>
<input type="radio" id="config_method_radio_manual" name="config_method_radio" value="1" />
<SCRIPT>ddw("txtWizard_WlanStr5");</SCRIPT>
</p></fieldset></div><!-- wz_page_0 -->

<div id="wz_page_1" style="display:none">

<table border="0" cellpadding="2" cellspacing="1" width="838" align="center" bgcolor="#FFFFFF" bordercolordark="#FFFFFF">
<tr valign=top>
	<td width=10%></td>
	<td id="maincontent" width=80%>
		<br>
		<div id="box_header">
		<h1 align="left"><SCRIPT>ddw("txtWizard_WlanStr6");</SCRIPT></h1>
<p><SCRIPT>ddw("txtWizard_WlanStr7");</SCRIPT></p>
<br>
<center>
<table>
<tr>
	<td align=left>
		<UL>
		<LI><SCRIPT>ddw("txtWizardWlanStep1");</SCRIPT>
		<LI><SCRIPT>ddw("txtWizardWlanStep3");</SCRIPT>
	</td>
</tr>
</table>
</center>
<br><br>
<br>
<center>
<input type="button" class="button_submit" id="wz_next_b_1" value="" onclick="wz_next();"/>
<input type="button" class="button_submit" id="wz_cancel_b_1" value="" onclick="page_cancel();"/>
</center>
		<br>
		</div>
		<br>
	</td>
	<td width=10%></td>
</tr>
</table>


</div><!-- wz_page_1 -->

<div id="wz_page_2" style="display:none">
<h3><SCRIPT>ddw("txtWizardWlanStep1");</SCRIPT></h3>
<p class="box_msg">	<SCRIPT>ddw("txtWizard_WlanStr8");</SCRIPT>
</p><fieldset></fieldset></div><!-- wz_page_2 -->
	

<div id="wz_page_3" style="display:none">
	
<table border="0" cellpadding="2" cellspacing="1" width="838" align="center" bgcolor="#FFFFFF" bordercolordark="#FFFFFF">
<tr valign=top>
	<td width=10%></td>
	<td id="maincontent" width=80%>
		<br>
		<div id="box_header">
		<h1><SCRIPT>ddw("txtWizard_WlanStr9");</SCRIPT> </h1>
<p><SCRIPT>ddw("txtNetworkName32characters");</SCRIPT> </p>

			<table>
			<tr>
				<td width=10>&nbsp;</td>
				<td>
					<table>
						<tr>
						<td width=40% class=r_tb><SCRIPT>ddw("txtNetworkNameSSID");</SCRIPT></td>						     
						<td ><input type="text" id="wireless_SSID" name="config.wireless.SSID" size="20" maxlength="32" value="<%getInfo("ssid");%>"/>&nbsp;<SCRIPT>ddw("txtAlsoCallSSID");</SCRIPT></td>
<input type="hidden" id="wireless_wepon" name="config.wireless.wepon" value="false"/>
<input type="hidden" id="wireless_wep_key" name="config.wireless.wep_key0" value="12345678902551234567890255"/>
<input type="hidden" name="config.wireless.use_key" value="0"/>
<input type="hidden" id="wireless_keylen" name="config.wireless.keylen" value="1"/>
<input type="hidden" name="config.wireless.auth" value="1"/>
<input type="hidden" id="wireless_wpa_enabled" name="config.wireless.wpa_enabled" value="false"/>
<input type="hidden" id="wireless_wpa_mode" name="config.wireless.wpa_mode" value="2"/>
<input type="hidden" id="wireless_wpa_psk" name="config.wireless.wpa_psk" value="12345678"/>
<input type="hidden" id="wireless_wpa_cipher" name="config.wireless.wpa_cipher" value="3"/>
<input type="hidden" name="config.wireless.wpa_rekey_time" value="3600"/>
<input type="hidden" name="config.wireless.ieee8021x_enabled" value="0"/>
<input type="hidden" name="f_wep_format"		value="">
						</tr>
					</table>
				</td>
			</tr>

			<tr>
				
				<td width=10>									
<input type="radio" id="wl_no_encription" name="wl_key_assign_radio" value="0" onclick="wl_key_assign_radio_click(this.value)"/></td>
<td class="l_tb"><SCRIPT>ddw("txtNoEncription");</SCRIPT>
</td>

			</tr>
			<tr>
				
				<td width=10>									
<input type="radio" id="wl_key_assign" name="wl_key_assign_radio" value="2" onclick="wl_key_assign_radio_click(this.value)"/></td>
<td class="l_tb"><SCRIPT>ddw("txtWizard_WlanStr15");</SCRIPT>
</td>

			</tr>
			<tr>
				<td width=10>&nbsp;</td>
				<td class="l_tb"><SCRIPT>ddw("txtWizard_WlanStr16");</SCRIPT> </td>
			</tr>
			<tr>
				<td width=10>
<input type="radio" id="wl_key_manual" name="wl_key_assign_radio" value="1" onclick="wl_key_assign_radio_click(this.value)"/>
</td><td class="l_tb">
<SCRIPT>ddw("txtManuallyNetworkKey");</SCRIPT>
</td>


			</tr>
			<tr>
				<td width=10>&nbsp;</td>
				<td class="l_tb"><SCRIPT>ddw("txtCreateOwnKey");</SCRIPT> </td>
			</tr>
			<tr>
				<td width=10>
<input type="checkbox" id="wl_wpa_enable" name="wl_wpa_enable_check" value="1" />
</td><td class="l_tb">
<SCRIPT>ddw("txtWizard_WlanStr17");</SCRIPT>
</td>
				
			</tr>
			</table>
		<br>
		<center>
<input type="button" class="button_submit" id="wz_prev_b_3" value="" onclick="wz_prev();" />
<input type="button" class="button_submit" id="wz_next_b_3" value="" onclick="wz_next();"/>
<input type="button" class="button_submit" id="wz_cancel_b_3" value="" onclick="page_cancel();"/>
			
			</center>
		<br>
		</div>
		<br>
	</td>
	<td width=10%></td>
</tr>
</table>

<p class="box_msg" style="display:none">
<SCRIPT>ddw("txtWizard_WlanStr18");</SCRIPT>
</p><p class="box_msg" style="display:none">
<SCRIPT>ddw("txtWizard_WlanStr19");</SCRIPT>
</p></div><!-- wz_page_3 -->


<div id="wz_page_nodisplay" style="display:none">
<p>	<label class="duple" for="security_mode_radio_3">
<SCRIPT>ddw("txtWizard_WlanStr10");</SCRIPT>
 </label>
<input type="radio" id="security_mode_radio_3" name="security_mode_radio" value="3" onchange="security_mode_selector(this.value)"/>
<SCRIPT>ddw("txtWizard_WlanStr11");</SCRIPT>
</p><p>
<label class="duple" for="security_mode_radio_2">
<SCRIPT>ddw("txtBETTER");</SCRIPT>
</label><input type="radio" id="security_mode_radio_2" name="security_mode_radio" value="2" onchange="security_mode_selector(this.value)"/>
<SCRIPT>ddw("txtWizard_WlanStr12");</SCRIPT>
</p><p><label class="duple" for="security_mode_radio_1">
<SCRIPT>ddw("txtGOOD");</SCRIPT>
</label><input type="radio" id="security_mode_radio_1" name="security_mode_radio" value="1" onchange="security_mode_selector(this.value)"/>
<SCRIPT>ddw("txtWizard_WlanStr13");</SCRIPT>
</p><p><label class="duple" for="security_mode_radio_0">
<SCRIPT>ddw("txtNONE");</SCRIPT>
</label>
<input type="radio" id="security_mode_radio_0" name="security_mode_radio" value="0" onchange="security_mode_selector(this.value)"/>
<SCRIPT>ddw("txtWizard_WlanStr14");</SCRIPT>
</p></div>



<div id="wz_page_4" style="display:none">
	
<table border="0" cellpadding="2" cellspacing="1" width="838" align="center" bgcolor="#FFFFFF" bordercolordark="#FFFFFF">
<tr valign=top>
	<td width=10%></td>
	<td id="maincontent" width=80%>
		<br>
		<div id="box_header">
		<h1><SCRIPT>ddw("txtWizard_WlanStr20");</SCRIPT></h1>

			<table>
			<tr>
				<td class=l_tb><SCRIPT>ddw("txtWizard_WlanStr21");</SCRIPT></td>
			</tr>
<span class="itemhelp" id="wlan_passwd_wep">
			
			<tr>
				<td class=l_tb><span id="wlan_passwd_wep_1"></td>
			</tr>
			<tr>
				<td class=l_tb><span id="wlan_passwd_wep_2"></td>
			</tr>
			<tr>
				<td class=l_tb><span id="wlan_passwd_wep_3"></td>
			</tr>
			<tr>
				<td class=l_tb><span id="wlan_passwd_wep_4"></td>
			</tr>
			

</span>			
<span class="itemhelp" id="wlan_passwd_wpa">
			
			<tr>
				<td class=l_tb><span id="wlan_passwd_wpa_1"></td>
			</tr>
			<tr>
				<td class=l_tb><span id="wlan_passwd_wpa_2"></td>
			</tr>
			<tr>
				<td class=l_tb><span id="wlan_passwd_wpa_3"></td>
			</tr>
</span>

			
			
			<tr>
				<td>
					<table>
			<tr>
			<td width=40% class=r_tb><SCRIPT>ddw("txtWirelessSecurityPassword");</SCRIPT></td>
						<td ><input type=text id="wlan_passwd" size="20" maxlength="64" value=""></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class=l_tb><SCRIPT>ddw("txtWizard_WlanStr29");</SCRIPT></td>
			</tr>
			</table>
		<br>
		<center>
			<input type="button" class="button_submit" id="wz_prev_b_4" value="" onclick="wz_prev();" >
<input type="button" class="button_submit" id="wz_next_b_4" value="" onclick="wz_next();"/>
<input type="button" class="button_submit" id="wz_cancel_b_4" value="" onclick="page_cancel();"/>			


			</center>
		<br>
		</div>
		<br>
	</td>
	<td width=10%></td>
</tr>
</table>
</div><!-- wz_page_4 -->


<div id="wz_page_5" style="display:none">
<table border="0" cellpadding="2" cellspacing="1" width="838" align="center" bgcolor="#FFFFFF" bordercolordark="#FFFFFF">
<tr valign=top>
	<td width=10%></td>
	<td id="maincontent" width=80%>
		<br>
		<div id="box_header">
		<h1><SCRIPT>ddw("txtSetupComplete");</SCRIPT></h1>
		<br>
<SCRIPT>ddw("txtWizard_WlanStr30");</SCRIPT> </p>

<div id="wlan_summary_0">	<fieldset class="invisible">
		<table width=80%>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtWirelessNetworkNameSSID");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wlan_summary_ssid_0">&nbsp;</span></td></tr>			
<tr><td class=br_tb height=22><SCRIPT>ddw("txtSecurityMode");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<SCRIPT>ddw("txtNoEncription");</SCRIPT></td></tr>


		</table>
		
		
		
</fieldset>
		</div>
	
<div id="wlan_summary_1">	<fieldset class="invisible">
		<table width=80%>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtWirelessNetworkNameSSID");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wlan_summary_ssid_1">&nbsp;</span></td></tr>			
<tr><td class=br_tb height=22><SCRIPT>ddw("txtWepKeyLength");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wepkey_info">&nbsp;</span></td></tr>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtDefaultWEPKey");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;1</td></tr>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtAuthentication");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<SCRIPT>ddw("txtOpen");</SCRIPT></td></tr>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtWepKey");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wlan_summary_key_1">&nbsp;</span></td></tr>

		</table>
		
		
		
</fieldset>
		</div>
	
	
	
<div id="wlan_summary_2"><fieldset class="invisible">
	
<table width=80%>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtWirelessNetworkNameSSID");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wlan_summary_ssid_2">&nbsp;</span></td></tr>	
<tr><td class=br_tb height=22><SCRIPT>ddw("txtSecurityMode");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<SCRIPT>ddw("txtAutoWPAorWPA2Personal");</SCRIPT></td></tr>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtCipherType");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<SCRIPT>ddw("txtTKIPandAES");</SCRIPT></td></tr>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtPreSharedKey");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wlan_summary_key_2">&nbsp;</span></td></tr>
</table>
		
			
</fieldset></div>


<div id="wlan_summary_3"><fieldset class="invisible">
<p><label class="duple">
<SCRIPT>ddw("txtEncryption");</SCRIPT>
:</label>
<SCRIPT>ddw("txtWPA2PSKAES");</SCRIPT>
</p><p><label class="duple"><SCRIPT>ddw("txtPreSharedKey");</SCRIPT>
 :</label>
<span id="wlan_summary_key_3">&nbsp;</span></p></fieldset></div>
	
	
<div id="wifisc_wlan_summary">
	
<fieldset class="invisible">
	
<table width=100%>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtWirelessNetworkNameSSID");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wlan_summary_ssid_3">&nbsp;</span></td></tr>	
<tr><td class=br_tb height=22><SCRIPT>ddw("txtSecurityMode");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wifisc_security_mode">&nbsp;</span></td></tr>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtCipherType");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wifisc_cipher_type">&nbsp;</span></td></tr>
<tr><td class=br_tb height=22><SCRIPT>ddw("txtPreSharedKey");</SCRIPT></td><td></td><td>:&nbsp;&nbsp;<span id="wifisc_psk">&nbsp;</span></td></tr>
</table>
		
			
</fieldset>

</div>
	
<br>
<table>
			<tr>
			<td><SCRIPT>ddw("txtWizard_WlanStr31");</SCRIPT></td>
			</tr>
		</table>
<br>		
		<center>
<input type="button" class="button_submit disabled" id="wz_prev_b_5" value="" onclick="wz_prev();" />
<input type="button" class="button_submit disabled" id="wz_save_b_5" value="" onclick="page_submit();"/>
<input type="button" class="button_submit" id="wz_cancel_b_5" value="" onclick="page_cancel();"/>
	
		
		</center>
		<br>
	
</div>



<br>
	</td>
	<td width=10%></td>
</tr>
</table>

</div>
<!-- wz_page_5 -->
	
	
	
	
	
<fieldset id="wz_buttons">
<p style="display:none"><label class="duple"></label>
<input type="button" class="button_submit disabled" id="wz_prev_b" value="" onclick="wz_prev();" disabled="disabled"/>
<input type="button" class="button_submit" id="wz_next_b" value="" onclick="wz_next();"/>
<input type="button" class="button_submit" id="wz_cancel_b" value="" onclick="page_cancel();"/>
<input type="button" class="button_submit disabled" id="wz_save_b" value="" onclick="page_submit();" disabled="disabled"/>
</p></fieldset></form><!-- InstanceEndEditable --></div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT>DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>			
</td><td id="sidehelp_container">&nbsp;</td>
</tr></table>
<SCRIPT>Write_footerContainer();</SCRIPT>
</td>
</tr>
</tbody>
</table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
	</div>
</body>
<!-- InstanceEnd -->

</html>
