<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml" lang="en-US"><head>
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
var MAXNUM_QOS = "<% getInfo("maxQosNum");%>"*1;
var guest_num;
var WLAN_MODE="<%getIndexInfo("wlanMode");%>";  //-1:router; 0:ap; 1:client; 2:wds: 3:wds+ap; 5:wisp

function get_webserver_ssi_uri() {
return ("" !== "") ? "/Basic/Setup.asp" : "/Advanced/Guest_Zone.asp";
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
if(WLAN_ENABLED=='0'){
	document.getElementById("guest_includeWireless").disabled=true;
	document.getElementById("wireless_SSID_0").disabled=true;
	document.getElementById("box_security_0").disabled=true;
	document.getElementById("guest_includeWireless").disabled=true;
}
//-1:router; 0:ap; 1:client; 2:wds: 3:wds+ap; 5:wisp
if(WLAN_MODE == "5" || WLAN_MODE == "2" || WLAN_MODE == "1"){
	document.getElementById("guest_includeWireless").disabled=true;
	document.getElementById("wireless_SSID_0").disabled=true;
	document.getElementById("box_security_0").disabled=true;
	document.getElementById("guest_includeWireless").disabled=true;
}
RenderWarnings();
}
        var is_admin = "true" == "true";
        var radio_count = 1;
        var radio_name = ["2.4GHz Band", "5GHz Band"];


    //]]>
    </script>

<script type="text/javascript">
//<![CDATA[
        var mf;


var schedule_options = [
	<%virSevSchRuleList();%> 
];

var dhcpClientXSLTIsReady = false;

function onDHCPClientDataReady(xmlDoc)
{
	
	if (!(dhcpClientXSLTIsReady)) {
		return;
	}
	var dhcpClientXMLData = xmlDoc.getDocument();
	
	var computer_list = document.getElementById("dhcp_client_list");

	computer_list.innerHTML = "";
	
	dhcpClientXSLTProcessor.transform(dhcpClientXMLData, window.document, computer_list);

	

	guest_client_num_retriever.retrieveData();        
	
}
function onDHCPClientDataTimeout()
{
dhcpClientXMLDataFetcher.retrieveData();
}
function dhcpClientXSLTReady(xmlDoc)
{
dhcpClientXSLTIsReady = true;
dhcpClientXMLDataFetcher = new xmlDataObject(onDHCPClientDataReady, onDHCPClientDataTimeout, 6000, "../guest_dhcp_clients.asp");
dhcpClientXMLDataFetcher.retrieveData();
}

function onDHCPClientXSLTProcessorTimeout()
{
dhcpClientXSLTProcessor.retrieveData();
}

        function guest_zone_checkbox_control_selector(inst_num, checked)
        { 
            mf["guest_zone_used_" + inst_num].value = checked;                                                                    
            mf["guest_zone_enabled_" + inst_num].value = checked;                                                               
            mf["guest_zone_checkbox_control_select_" + inst_num].checked = checked;                                                                 
            var disabled = !checked;
           	disable_form_field(mf["guest_zone_schedule_control_select_" + inst_num], disabled);  
           
		if((WLAN_ENABLED=='0') ||(WLAN_MODE == "5" || WLAN_MODE == "2" || WLAN_MODE == "1")){
				document.getElementById("guest_includeWireless").disabled=true;
				document.getElementById("wireless_SSID_"+inst_num).disabled=true;
				document.getElementById("box_security_"+inst_num).disabled=true;
				document.getElementById("box_wireless_security_" + inst_num).style.display="none";
				document.getElementById("box_security_" + inst_num).style.display = "none";
				disable_form_field(mf["wireless_SSID_" + inst_num], true);
				disable_form_field(mf["guest_includeWireless"], true);
		}else{
		            if (mf["wireless_checkbox_control_" + inst_num].value == "0") {
		                disabled = true;
		                disable_form_field(mf["guest_zone_checkbox_control_select_" + inst_num], disabled);  
		                document.getElementById("box_wireless_security_" + inst_num).style.display = "none";
		                document.getElementById("box_security_" + inst_num).style.display = "none";
		            }
		            else
		            {
		                document.getElementById("box_wireless_security_" + inst_num).style.display = checked ? "block" : "none";
		                document.getElementById("box_security_" + inst_num).style.display = checked ? "block" : "none";
		            }
		            
		            disable_form_field(mf["wireless_SSID_" + inst_num], disabled); 
		            			disable_form_field(mf["guest_includeWireless"], disabled);
		            if( get_by_id("guestWlanEnable").value == 0 || get_by_id("guestWlanEnable").value == 'false')
		            {
		            	document.getElementById("box_wireless_security_" + inst_num).style.display = "none";
		              document.getElementById("box_security_" + inst_num).style.display = "none";
		            	disable_form_field(mf["wireless_SSID_" + inst_num], true);             	
		            }
		}
            
            					for(i=0; i<4 ; i++)
						{							
							disable_form_field(mf["guest_lanPortList_" + (i+1)], disabled);
						}
						
						get_by_id("isolation_enable").disabled = disabled;
						get_by_id("rounting_enable").disabled = disabled;
						if (!(!disabled && !get_by_id("lockClientList_enable").checked && guest_num == 0))
							get_by_id("lockClientList_enable").disabled = disabled;						
        }
           
        function wireless_checkbox_control_selector(inst_num, checked)
        {  
            mf["wireless_checkbox_control_" + inst_num].value = checked ? "1" : "0";
            mf["wireless_checkbox_control_select_" + inst_num].checked = checked;
           
            var disabled = !checked;
            //disable_form_field(mf["wireless_SSID_" + inst_num], disabled);
           
        }  

        function GZCIsolation_checkbox_control_selector(checked)
        {
            mf["GZCIsolation_checkbox_control"].value = checked ? "1" : "0";
            mf["GZCIsolation_checkbox_control_select"].checked = checked;

        }

        function routing_between_zones_checkbox_control_selector(checked)
        {
            mf["routing_between_zones_checkbox_control"].value = checked ? "1" : "0";
            mf["routing_between_zones_checkbox_control_select"].checked = checked;
        }

        function dhcp_server_checkbox_control_selector(checked)
        {
            mf["dhcp_server_checkbox_control"].value = checked ? "1" : "0";
            mf["dhcp_server_checkbox_control_select"].checked = checked;
        }

        function lock_client_list_checkbox_control_selector(checked)
        {
            mf["lock_client_list_checkbox_control"].value = checked ? "1" : "0";
            mf["lock_client_list_checkbox_control_select"].checked = checked;
        }

        /*
         * Check for validation errors.
         */
       var verify_failed = "<%getInfo("err_msg")%>";

        /*
         * Security modes.
         */
        var WEPON = 1;
        var WPA_ENABLED = 2;
        var WPA2_ENABLED = 3;
        var WPA2WPA_ENABLED=4
        var IEEE8021X_ENABLED = 4;
        var WPA_PERSONAL = WPA_ENABLED;
        var WPA_ENTERPRISE = WPA_ENABLED | IEEE8021X_ENABLED;



	var wep_key_num=1;



        /*
         * add_option()
         * Add value if it's not found in options.
         */
        function add_option(select, name, value)
        {
            for (var i = select.options.length - 1; i >= 0 ; i--) {
                if (select.options[i].value == value) {
                    return;
                }
            }
            select.options.add(new Option(name, value));
        }

        /*
         * remove_option()
         * Remove value if it's found in options.
         */
        function remove_option(select, value)
        {
            for (var i = select.options.length - 1; i >= 0 ; i--) {
                if (select.options[i].value == value) {
                    select.remove(i);
                }
            }
        }



        /*
         * wireless_security_mode_selector()
         */
        function wireless_security_mode_selector(inst_num, mode)
        {
            mf["wireless_security_mode_select_" + inst_num].value = mode;
            mf["wireless_wepon_" + inst_num].value = (mode == WEPON) ? "true" : "false";
			if(mode==WEPON){
			get_by_id("box_wireless_wepon_" + inst_num).style.display = "block";
			get_by_id("show_wpa").style.display = "none";
			}else if(mode==WPA_ENABLED){
			get_by_id("box_wireless_wepon_" + inst_num).style.display = "none";
			get_by_id("show_wpa").style.display = "block";
			get_by_id("wpa_note").innerHTML ="WPA Only";
			get_by_id("wpa_comment").innerHTML=sw("txtWirelessStr7_1");
			}else if(mode==WPA2_ENABLED){
			get_by_id("box_wireless_wepon_" + inst_num).style.display = "none";
			get_by_id("show_wpa").style.display = "block";
			get_by_id("wpa_note").innerHTML ="WPA2 Only";
			get_by_id("wpa_comment").innerHTML=sw("txtWirelessStr7_2");
			}else if(mode==WPA2WPA_ENABLED){
			get_by_id("box_wireless_wepon_" + inst_num).style.display = "none";
			get_by_id("show_wpa").style.display = "block";
			get_by_id("wpa_note").innerHTML ="WPA/WPA2";
			get_by_id("wpa_comment").innerHTML=sw("txtWirelessStr7");
			}else{
				document.getElementById("box_wireless_wepon_" + inst_num).style.display = "none";
				document.getElementById("show_wpa").style.display = "none";
			}
            
        }

		function wireless_guest_wpa_auth_selector(value)
        {
			var auth_type;
			if(mf["guest_wpa_auth_type"].selectedIndex==0){
				mf["wireless_guest_wpa_auth_0"].value = "psk";
				auth_type="psk";
			}else{
				mf["wireless_guest_wpa_auth_0"].value = "eap";
				auth_type="eap";
			}
			
			if(auth_type=="eap"){
			get_by_id("eap_setting").style.display = "block";
			get_by_id("guest_psk_setting").style.display = "none";
			}else{
			get_by_id("eap_setting").style.display = "none";
			get_by_id("guest_psk_setting").style.display = "block";
			}
        }

		function wireless_guest_cipher_type_selector(value)
        {
			get_by_id("wireless_guest_cipher_0").value = value;
        }

        function validate_wpa_psk(inst_num, value_str)
        {
            if(value_str.length==64)
				{
					var test_char,j;
					for(j=0; j<(value_str.length); j++)
					{
						test_char=value_str.charAt(j);
						if( (test_char >= '0' && test_char <= '9') ||
								(test_char >= 'a' && test_char <= 'f') ||
								(test_char >= 'A' && test_char <= 'F'))
							continue;
					
						alert(sw("txtPSKShouldbeHex"));
						return false;
					}
				}
				else
				{
					if(value_str.length <8 || value_str.length > 63)
					{
						alert(sw("txtInvalidPSKLen"));
						return false;
		    		}	
					if(strchk_unicode(value_str))
		    		{
						alert(sw("txtPSKShouldbeAscii"));
						return false;
					}
	    		}	
            return true;
        }


       
        function validate_port(value)
        {
            if (!is_port_valid(value)) {
                alert(sw("txtInvalidPortNumber"));
                return false;
            }
            return true;
        }

       
        function validate_ip(ip)
        {
            if (!is_ipv4_valid(ip) || ip == "0.0.0.0" || !is_valid_ip(ip)) {
                alert(sw("txtInvalidIPAddress") + ": " + ip);
                return false;
            }
            return true;
        }


        /*
         * pad_wep_keys()
         */
        function pad_wep_keys(inst_num)
        {
            /*
             * No need to pad WEP keys if it's 128 bits.
             */
            if (mf["wireless_keylen_" + inst_num].value == 1) {
                return;
            }
            for (var i = 0; i < 4; i++) {
                mf["wep_" + inst_num + "_key" + i].maxLength = 26;
                var s = mf["wep_" + inst_num + "_key" + i].value;
                s = s.substring (0,10);
                while (s.length < 26) {
                    s += '0';
                }
                mf["wep_key_value"].value = s;
            }
        }

        /*
         * truncate_wep_keys()
         */
        function truncate_wep_keys(inst_num)
        {
            
                var got = mf["wep_key_value"].value.match (/^\s*([0-9a-fA-F]+)\s*$/);
                if (got) {
                    var s = got[1];
                    var n = (mf["wireless_keylen_" + inst_num].value == 1) ? 13*2 : 5*2;
                    if (mf["wireless_keylen_" + inst_num].value == "0") {
                            s = s.substring (0,10);
                    }
                    else {
                            while (s.length < n) {
                                    s += '0';
                            }
                    }
                    mf["wep_key_value"].value = s;
            }
        }

        /*
         * wireless_keylen_selector()
         */
        function wireless_keylen_selector(inst_num, value)
        {
                mf["wireless_keylen_" + inst_num].value = value;
                mf["wireless_keylen_select_" + inst_num].value = value;
            /*
             * Set the maxlength fields of all wep keys appropriately.
             */
                var len = (mf["wireless_keylen_" + inst_num].value == 1) ? 26 : 10;
                mf["wep_key_value"].maxLength = len;
            truncate_wep_keys(inst_num);
				
        }
	function wlan_wep_default_key_select(	inst_num, value)
	{
		 mf["wlan_wep_default_key_" + inst_num].value = value;
		 mf["wep_default_key_select_" + inst_num].value = value;
        }

        /*
         * validate_wep_keys()
         */
        function validate_wep_keys(inst_num)
	{
		var wep_error_msg = "";
            	var got;
            	var i, j, k;

            	var key = mf["wep_key_value"].value;
            	
            	alert(mf["wireless_keylen_" + inst_num].value); 
            	alert(key.length);  
            	alert(key); 	           	                    	
            	
                if (((key.length == 5) && (mf["wireless_keylen_" + inst_num].value == 0)) || ((key.length == 13) && (mf["wireless_keylen_" + inst_num].value == 1))) 
                {//ascii
	 		if(strchk_unicode(key))
			{
				if(key.length==13)	alert(sw("txtInvalidKeyfor13char")+".");
				else			alert(sw("txtInvalidKeyfor5char"));
				wep_key_value.select();
				return false;
			}               	
                	mf["guest_wep_default_key_" + inst_num].value = key;
                }
                else if (((key.length == 10) && (mf["wireless_keylen_" + inst_num].value == 0)) || ((key.length == 26) && (mf["wireless_keylen_" + inst_num].value == 1))) 
                {//hex
			got = mf["wep_key_value" ].value.match (/^\s*([0-9a-fA-F]+)\s*$/);
                    	if (!got) 
                    	{ //check Hex format key
				if(key.length==26)	alert(sw("txtInvalidKeyfor26Dec"));
				else			alert(sw("txtInvalidKeyfor10Dec"));
				wep_key_value.select();
				return false;
                        } 
                        else 
                        {
                    		mf["guest_wep_default_key_" + inst_num].value = key;
                    	}
                } 
                else 
                {
               		if(mf["wireless_keylen_" + inst_num].value == 0)
               		{
               			alert(sw("txtInvalidKeyforwep64"));
                        	return false;
                        }
                   	if(mf["wireless_keylen_" + inst_num].value == 1)
                   	{
                   		alert(sw("txtInvalidKeyforwep128"));
                   		return false;
                   	}
		}

            /*
             * Pad 0 to maxLength.
             */
           // pad_wep_keys(inst_num);
            return true;
        }

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
      
        function wireless_use_key_selector(inst_num, value)
        {
            mf["wep_key_value"].value = value;
            mf["guest_wep_default_key_"+inst_num].value=value;
        }

       
        function wireless_auth_selector(inst_num, value)
        {
//            var wps_enable = "true";
//
//            if ((wps_enable == "true") && (value == "1")) {
//                alert(sw("txtWPSCantWorkAtWPAEAPMode"));
//                mf["wireless_auth_select_" + inst_num].value = "1";
//                return;
//            }

            mf["wireless_auth_" + inst_num].value = value;
            mf["wireless_auth_select_" + inst_num].value = value;
        }

       
        function guest_zone_schedule_control_selector(inst_num, value)
        {
            mf["guest_zone_schedule_control_" + inst_num].value = value;
        }

       
        function add_new_schedule()
        {
            top.location = "/Tools/Schedules.html";
        }



        function init_guest_selector(inst_num, value)
        {
            document.getElementById("guest_select_" + inst_num).checked = !value;
        }

       
        function guest_selector(inst_num, value)
        {
            document.getElementById("guest_" + inst_num).value = !value;
        }

    
       
        function do_add_new_schedule()
        {
        	var time_now=new Date().getTime();
			top.location = "../Tools/Schedules.asp?t="+time_now;
        }

	function guest_client_num_ready(dataInstance)
	{
		guest_num = dataInstance.getElementData("num");
		var f = get_by_id("lockClientList_enable");

		if (guest_num == 0 && !f.checked)
			f.disabled = 1;	
	}

	function guest_client_num_timeout()
	{		
		guest_client_num_retriever.retrieveData();	
	}

      
        function page_load()
        {
        	displayOnloadPage("<%getInfo("ok_msg")%>");
            mf = document.forms.mainform;

            var guest_wlan_sec_mode=<%getIndexInfo("guest_sec_mode");%>;
            mf["wireless_security_mode_select_0"].selectedIndex=guest_wlan_sec_mode;
            wireless_security_mode_selector(0,guest_wlan_sec_mode);

            if(mf["wireless_guest_wpa_auth_0"].value=="psk")
            	mf["guest_wpa_auth_type"].selectedIndex=0;
            else
            	mf["guest_wpa_auth_type"].selectedIndex=1;
            	wireless_guest_wpa_auth_selector(guest_wlan_sec_mode);
            	if(mf["wireless_guest_cipher_0"].value==1)
            	mf["guest_cipher_type"].selectedIndex=0
            	if(mf["wireless_guest_cipher_0"].value==2)
            	mf["guest_cipher_type"].selectedIndex=1
            	if(mf["wireless_guest_cipher_0"].value==3)
            	mf["guest_cipher_type"].selectedIndex=2
          
            radio_count = parseInt(document.getElementById("radio_count").value, 10);
            for (var inst_num=0 ;inst_num < radio_count; inst_num++) {
               // radio[inst_num] = new Radio(inst_num + 1);
                // 2007.07.02
                schedule_populate_select(mf["guest_zone_schedule_control_select_" + inst_num]);
                mf["guest_zone_schedule_control_select_" + inst_num].value = mf["guest_zone_schedule_control_" + inst_num].value;
               
                guest_zone_checkbox_control_selector(inst_num, mf["guest_zone_enabled_" + inst_num].value == "true");



                wireless_keylen_selector(inst_num, mf["wireless_keylen_" + inst_num].value);
                wireless_use_key_selector(inst_num, mf["guest_wep_default_key_" + inst_num].value);
                wireless_auth_selector(inst_num, mf["wireless_auth_" + inst_num].value);
                wlan_wep_default_key_select(inst_num, mf["wlan_wep_default_key_" + inst_num].value);
            }
            if (!is_admin) {
                do_block_enable(mf, false);
                document.getElementById("user_only").style.display = "block";
                return;
            }
            	initLanList();

					chg_wep_type(get_by_id("wireless_keylen_0").value);
					chg_wep_def_key(get_by_id("wlan_wep_default_key_0").value);
                //save_form_default_values("mainform");
		set_form_default_values("mainform");			
               
                if (verify_failed != "") {
                    set_form_always_modified("mainform");
                    alert(verify_failed);
                }
		if(lang== "1"){
			dhcpClientXSLTProcessor = new xsltProcessingObject(dhcpClientXSLTReady, onDHCPClientXSLTProcessorTimeout, 6000, "../guest_dhcp_clients_pack.sxsl");
		}else{
			dhcpClientXSLTProcessor = new xsltProcessingObject(dhcpClientXSLTReady, onDHCPClientXSLTProcessorTimeout, 6000, "../guest_dhcp_clients.sxsl");
		}      
		dhcpClientXSLTProcessor.retrieveData();        
		guest_client_num_retriever = new xmlDataObject(guest_client_num_ready, guest_client_num_timeout, 6000, "./guest_client_num.asp");
	}
        function page_submit()
        {
           // if (!is_form_modified("mainform") && !confirm("Nothing has changed. Save anyway?")) {
           //         return;
           // }
		if (!is_form_modified("mainform")) 
		{
			if (!confirm(sw("txtSaveAnyway"))) 				
				return false;
		}
		else
		{
			updateLanList();
            		for (var inst_num=0 ;inst_num < radio_count; inst_num++) 
            		{
				if (mf["guest_zone_enabled_" + inst_num].value && get_by_id("guest_includeWireless").checked == true) 
				{
               
                 			//mf["wireless_SSID_" + inst_num].value = trim_string(mf["wireless_SSID_" + inst_num].value);
                 			if (is_blank(mf["wireless_SSID_" + inst_num].value)) 
                 			{	
		                 		alert(sw("txtSSIDBlank"));
		       	          		mf["wireless_SSID_" + inst_num].focus();
		              	   		return;
                 			}
              				if(strchk_unicode(mf["wireless_SSID_" + inst_num].value))
					{
						alert(sw("txtInvalidSSID"));
						mf["wireless_SSID_" + inst_num].focus();
						return;
					}
					var test_wep_obj;
					var key_type;
					if (mf["wireless_security_mode_select_" + inst_num].value =="1")
					{//WEP
						if(mf["wireless_keylen_select_"+inst_num].value == 1) // 0:64 ; 1:128
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
						mf["f_wep_format_"+inst_num].value = key_type;
						mf["wep_key_value"].value=test_wep_obj.value;
					}
					
		               		if( mf["wireless_security_mode_select_" + inst_num].value !="1" && mf["wireless_security_mode_select_" + inst_num].value !="0")
		               		{ //WPA
		
		               			var auth_type;
						if(mf["guest_wpa_auth_type"].selectedIndex==0)
						{
							mf["wireless_guest_wpa_auth_0"].value = "psk";
							auth_type="psk";
						}
						else
						{
							mf["wireless_guest_wpa_auth_0"].value = "eap";
							auth_type="eap";
		                    		}
				               	if(mf["wireless_guest_wpa_auth_0"].value == "psk")
				               	{
				               		if(!(validate_wpa_psk(inst_num, mf["guest_wpa_psk"].value)))
				               		{
				               			mf["guest_wpa_psk"].select();
				                		mf["guest_wpa_psk"].focus();
		                        			return;
		                    			}
		               			}
		               			else
		               			{
		               		 		if (trim_string(mf["guest_radius_server_ip_0"].value) == "") 
		               		 		{
		                        			mf["wireless_radius_server_address_"].value = "0.0.0.0";
		                			}
		                    			if (!validate_ip(mf["guest_radius_server_ip_0"].value)) 
		                    			{
		                        			mf["guest_radius_server_ip_0"].select();
		                        			mf["guest_radius_server_ip_0"].focus();
		                        			return;
		                    			}
			                   		 if (!validate_port(mf["guest_radius_server_port_0"].value)) 
			                   		 {
				                       		 mf["guest_radius_server_port_0"].select();
				                       		 mf["guest_radius_server_port_0"].focus();
		                        			return;
		                    			}
		
							if(is_blank(mf["guest_radius_server_psk_0"].value))
							{
								alert(sw("txtRadiusSecretCannotEmpty"));
				             		 	mf["guest_radius_server_psk_0"].select();
				             			mf["guest_radius_server_psk_0"].focus();
								return;
							}
							if(strchk_unicode(mf["guest_radius_server_psk_0"].value))
							{
								alert(sw("txtRadiusSecretShouldbeAscii"));
				             		 	mf["guest_radius_server_psk_0"].select();
				             			mf["guest_radius_server_psk_0"].focus();
								return;
							}          
		          			} //else       
	          			}//WPA
          			}//if
	        	}//for
			mf["settingsChanged"].value = 1;        
			mf.curTime.value = new Date().getTime();
		       mf.submit();
	        }//else
	}
      
         /*
         * page_cancel()
         */
/*         
        function page_cancel()
        {
            if (is_form_modified("mainform") && confirm ("Do you want to abandon all changes you made to this page?")) {
                if (verify_failed != "") {
                    top.location = "/Advanced/Guest_Zone.asp";
                } else {
                    reset_form("mainform");
                  
                    page_load();
                }
            }
        }
*/        
function updateLanList()
{
	var lanList;
	
	for(i=0; i<4 ; i++)
	{
		var name="guest_lanPortList_"+(i+1);
		
		if(get_by_id(name).checked == true)
			lanList |= (1<<i)
	}
	get_by_id("lanPortList").value = lanList;

	if(get_by_id("guest_includeWireless").checked == true)
			get_by_id("guestWlanEnable").value = 1;
	else
			get_by_id("guestWlanEnable").value = 0;
			
	if(get_by_id("isolation_enable").checked == true)
			get_by_id("guestIsolation").value = 1;
	else
			get_by_id("guestIsolation").value = 0;
			
	if(get_by_id("rounting_enable").checked == true)
			get_by_id("guestRounting").value = 1;
	else
			get_by_id("guestRounting").value = 0;
			
	if(get_by_id("lockClientList_enable").checked == true)
			get_by_id("lockClientList").value = 1;
	else
			get_by_id("lockClientList").value = 0;

}

function initLanList()
{
	var lanList = get_by_id("lanPortList").value;
	
	for(i=0; i<4 ; i++)
	{
		var name="guest_lanPortList_"+(i+1);
		
		if(lanList & 1<<i)
			get_by_id(name).checked = true;
		else
			get_by_id(name).checked = false;
	}
	
	if(get_by_id("guestWlanEnable").value == 1)
		get_by_id("guest_includeWireless").checked = true;
	else
		get_by_id("guest_includeWireless").checked = false;
		
	if(get_by_id("guestIsolation").value == 1)
		get_by_id("isolation_enable").checked = true;
	else
		get_by_id("isolation_enable").checked = false;
		
	if(get_by_id("guestRounting").value == 1)
		get_by_id("rounting_enable").checked = true;
	else
		get_by_id("rounting_enable").checked = false;
		
	if(get_by_id("lockClientList").value == 1)
		get_by_id("lockClientList_enable").checked = true;
	else
		get_by_id("lockClientList_enable").checked = false;
}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtWirelessSettings");
document.title = DOC_Title;	
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("add_new_schedule_0").value = sw("txtAddNew");
}

function on_off_include_wlan(checkValue)
{
	get_by_id("guestWlanEnable").value = checkValue;
	get_by_id("guest_includeWireless").checked = checkValue;
	
	var display = !checkValue;
	
	
 
get_by_id("box_wireless_security_0").style.display =checkValue ? "block" : "none";    
 	get_by_id("box_security_0").style.display =checkValue ? "block" : "none";
							
	get_by_id("wireless_SSID_0").disabled = display;
}

function chg_wep_def_key(selectValue)
{
	get_by_id("wlan_wep_default_key_0").value = selectValue;
	//chg_wep_type(get_by_id("wireless_keylen_0").value);
}

function chg_wep_type(selectValue)
{
	get_by_id("wireless_keylen_0").value = selectValue;
	var f=get_by_id("mainform");
	get_by_id("wep_key_64").style.display		= "none";
	get_by_id("wep_key_128").style.display		= "none";

	if(f.wireless_keylen_0.value==1)	
		get_by_id("wep_key_128").style.display	= "";
	else
		get_by_id("wep_key_64").style.display	= "";
		
	
}

function print_keys(key_name, max_length)
{
	var str="";
	var key_value="";
	var field_size=decstr2int(max_length)+5;
	var hint_wording;
	if(get_by_id("wireless_keylen_0").value == 0 && max_length == "10") // 64
	{
		key_value = "<%getIndexInfo("guestWepDefKey");%>";
		if(key_value == "00000000000000000000000000" || key_value == "0000000000")
		{
			key_value="";
		}
	}
	else if(get_by_id("wireless_keylen_0").value == 1 && max_length == "26") // 128
	{
		key_value = "<%getIndexInfo("guestWepDefKey");%>";
		if(key_value == "00000000000000000000000000" || key_value == "0000000000")
		{
			key_value="";
		}
	}
	
	if(max_length=="10")	{hint_wording=sw("txt5AOr10H");}
	else					{hint_wording=sw("txt13AOr26H");}
	str="<table>";
	str+="\t<tr>";
	str+="\t\t<td class='r_tb' width='175'>WEP"+sw("txtPassword")+"</td>";
	str+="\t\t<td class='l_tb'>:&nbsp;&nbsp;"
	str+="<input type='text' id='"+key_name+"' name='"+key_name+"' maxlength='"+max_length+"' size='"+field_size+"' value='"+ key_value +"'>&nbsp;"+hint_wording+"</td>";
	str+="\t</tr>";
	str+="</table>";
	document.write(str);
}

function change_wep_key_value(changeValue)
{
	get_by_id("wep_key_value").value = changeValue;
	//alert(get_by_id("wep_key_value").value)
}

    //]]>
    </script>
    <!-- InstanceEndEditable -->
</head><body onload="template_load();init();web_timeout();">
<div style="display: none;" id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" summary="" cellspacing="0"><col span="1">
<tr><td>
<SCRIPT >
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
<% getFeatureMark("MultiLangSupport_Head"); %>								
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td>
<input id="radio_count" value="1" type="hidden">
<td id="maincontent_container">
<SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" >	<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
<p>	<b><SCRIPT >ddw("txtCommWarnStr1");</SCRIPT></b></p>
<p>	<SCRIPT >ddw("txtCommWarnStr2");</SCRIPT></p>
<UL><LI><p><SCRIPT >ddw("txtWlanWarnStr1");</SCRIPT></p></LI></UL>
<p>	<SCRIPT >ddw("txtCommWarnStr3");</SCRIPT>
</p></div><!-- box warnings_section_content --></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block;">
<!-- InstanceBeginEditable name="Main Content" -->
<form saved="true" id="mainform" name="mainform" action="/goform/formWlanGuestSetup" method="post">
	<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
	<input type="hidden" id="webpage" name="webpage" value="/Advanced/Guest_Zone.asp">
	<input type="hidden" id="curTime" name="curTime" value=""/>
	
<div class="section"><div class="section_head">
<h2><SCRIPT >ddw("txtGuestZone");</SCRIPT></h2>
<p><SCRIPT >ddw("txtGuestZoneComment");</SCRIPT></p>
<p id="user_only" style="display: none;"><SCRIPT >ddw("txtGuestZoneComment1");</SCRIPT></p>
<input class="button_submit" type="button" id="SaveSettings" value="" onclick="page_submit();"/>
<input class="button_submit" type="button" id="DontSaveSettings" value="" onclick="page_cancel();"/>
</div><div class="box">
<h3><SCRIPT >ddw("txtGuestZoneSelection");</SCRIPT></h3>
<p class="box_msg"> </p>
<fieldset><p>
<input default="false" id="guest_zone_used_0" name="used" value="false" type="hidden">
<input default="false" id="guest_zone_enabled_0" name="enabled" value="<%getIndexInfo("GuestEnabled")%>" type="hidden">
<label class="duple"><SCRIPT >ddw("txtGuestZoneEnable");</SCRIPT>&nbsp;:</label>
<input default="false" id="guest_zone_checkbox_control_select_0" onclick="guest_zone_checkbox_control_selector(0, this.checked);" type="checkbox">
<input default="Always" id="guest_zone_schedule_control_0" name="schedule_name" value="<%getIndexInfo("wlanGuestSchSelectName");%>" type="hidden">
<select disabled="disabled" class="disabled" id="guest_zone_schedule_control_select_0" onchange="guest_zone_schedule_control_selector(0, this.value);">
</select>
<input class="button_submit" id="add_new_schedule_0" value="New Schedule" onclick="do_add_new_schedule(true)" type="button">
</p>
<!--
<p style="display: none;">
<input default="" id="lan_port_checkbox_control_1" name=" " value="" type="hidden">
<input default="" id="lan_port_checkbox_control_2" name=" " value="" type="hidden">
<input default="" id="lan_port_checkbox_control_3" name=" " value="" type="hidden">
<input default="" id="lan_port_checkbox_control_4" name=" " value="" type="hidden">
<label class="duple">Include LAN Port&nbsp;:</label>
<input default="false" id="lan_port_checkbox_control_select_1" onclick="lan_port_checkbox_control_selector(1, this.checked);" type="checkbox"> 1&nbsp;
<input default="false" id="lan_port_checkbox_control_select_2" onclick="lan_port_checkbox_control_selector(2, this.checked);" type="checkbox"> 2&nbsp;
<input default="false" id="lan_port_checkbox_control_select_3" onclick="lan_port_checkbox_control_selector(3, this.checked);" type="checkbox"> 3&nbsp;
<input default="false" id="lan_port_checkbox_control_select_4" onclick="lan_port_checkbox_control_selector(4, this.checked);" type="checkbox"> 4&nbsp;
</p>
-->
<p style="display: block;">
<input id="lanPortList" name="lanPortList" value="<%getIndexInfo("guestZonePortList")%>" type="hidden">
<label class="duple" for="guest_select_0">
<SCRIPT >ddw("txtLanPortList");</SCRIPT>:</label>
<input type="checkbox" id="guest_lanPortList_1">1
<input type="checkbox" id="guest_lanPortList_2">2
<input type="checkbox" id="guest_lanPortList_3">3
<input type="checkbox" id="guest_lanPortList_4">4
</p>
<p style="display: block">
<input id="guestWlanEnable" name="guestWlanEnable" value="<%getIndexInfo("guestZoneWlanEnable")%>" type="hidden">
<label class="duple" for="guest_select_0">
<SCRIPT >ddw("txtIncludeWireless");</SCRIPT>:</label>
<input type="checkbox" id="guest_includeWireless" onclick="on_off_include_wlan(this.checked)">
</p>
<p>
<label class="duple"><SCRIPT >ddw("txtWlanBand");</SCRIPT>&nbsp;:</label>
<b><span id="radio_name_0">2.4GHz Band</span></b></p>
<p style="display: none;">
<input default="1" id="wireless_checkbox_control_0" name="radio_control" value="1" type="hidden">
<label class="duple">
<SCRIPT >ddw("txtIncludeWLAN");</SCRIPT>
&nbsp;:</label>
<input default="true" id="wireless_checkbox_control_select_0" onclick="wireless_checkbox_control_selector(0, this.checked);" type="checkbox">
</p><p>
<label class="duple"><SCRIPT >ddw("txtGuestZoneSSID");</SCRIPT>&nbsp;</label>
<input autocomplete="off" default="dlink_guest" disabled="disabled" class="disabled" id="wireless_SSID_0" size="20" maxlength="32" value="<%getIndexInfo("wlanGuestSSID");%>" name="ssid" type="text">
<SCRIPT >ddw("txtAlsoCallSSID");</SCRIPT></p>


<p></p><div style="display: none;" id="box_security_0">
<input default="false" id="wireless_wepon_0" name="wepon" value="<%getIndexInfo("guest_wep_enabled");%>" type="hidden">
<input default="false" id="wireless_ieee8021x_enabled_0" name="ieee8021x_enabled" value="<%getIndexInfo("guest_wpa_enterprise_enabled");%>" type="hidden">
<input default="false" id="wireless_wpa_enabled_0" name="wpa_enabled" value="<%getIndexInfo("guest_wpa_enabled");%>" type="hidden">
<label class="duple"><SCRIPT >ddw("txtSecurityMode");</SCRIPT>&nbsp;:</label>

<select id="wireless_security_mode_select_0" name="wireless_security_mode_select_0" onchange="wireless_security_mode_selector(0, this.value);">
<option default="true" value="0" selected="selected"><SCRIPT>ddw("txtNONE");</SCRIPT></option>
<option default="false" value="1"><SCRIPT>ddw("txtWEPSecurity");</SCRIPT></option>
<option default="false" value="2"><SCRIPT>ddw("txtWPAPersonal");</SCRIPT></option>
<option default="false" value="3"><SCRIPT>ddw("txtWPA2");</SCRIPT></option>
<option default="false" value="4"><SCRIPT>ddw("txtWPA2Auto");</SCRIPT></option>
</select></div></fieldset>
</div><div style="display: none;" id="box_wireless_security_0">
<div id="box_wireless_wepon_0" class="box" style="display: none;">
<h3>WEP</h3>
<p><SCRIPT >ddw("txtWirelessStr4");</SCRIPT></p>
<p>	<SCRIPT >ddw("txtWirelessStr5");</SCRIPT></p>
<fieldset>
<p>
<input default="1" id="wireless_auth_0" name="wepauth" value="<%getIndexInfo("guest_wep_auth");%>" type="hidden">
<label class="duple"><SCRIPT >ddw("txtAuthentication");</SCRIPT>&nbsp;:</label>
<select id="wireless_auth_select_0" onchange="wireless_auth_selector(0, this.value);">
<option default="true" value="0"><SCRIPT >ddw("txtOpen");</SCRIPT></option>
<option default="false" value="1"><SCRIPT >ddw("txtSharedKey");</SCRIPT></option>
</select></p>

<p>
<input default="0" id="wireless_keylen_0" name="keylen" value="<%getIndexInfo("guest_web_key_max_length");%>" type="hidden">
<label class="duple"><SCRIPT >ddw("txtWepKeyLength");</SCRIPT>&nbsp;:</label>
<select id="wireless_keylen_select_0" onchange="wireless_keylen_selector(0, this.value); chg_wep_type(this.value)">
<option default="true" value="0"><SCRIPT >ddw("txt64Bit10HexDigits");</SCRIPT></option>
<option default="false" value="1"><SCRIPT >ddw("txt128Bit26HexDigits");</SCRIPT></option>
</select></p>
<p>
<p>
<input default="1" id="wlan_wep_default_key_0" name="wlan_wep_default_key_0" value="<%getIndexInfo("guestwepkey_default");%>" type="hidden">
<label class="duple"><SCRIPT >ddw("txtDefaultWEPKey");</SCRIPT>&nbsp;:</label>
<select id="wep_default_key_select_0" onchange="wlan_wep_default_key_select(0, this.value);chg_wep_def_key(this.value);">
<option default="true" value="0"><SCRIPT >ddw("txtWepKey");</SCRIPT> 1</option>
<option default="false" value="1"><SCRIPT >ddw("txtWepKey");</SCRIPT> 2</option>
<option default="false" value="2"><SCRIPT >ddw("txtWepKey");</SCRIPT> 3</option>
<option default="false" value="3"><SCRIPT >ddw("txtWepKey");</SCRIPT> 4</option>
</select></p>

<p style="display: block;">
	<input default="" id="guest_wep_default_key_0" name="guest_wep_default_key_0" value="<%getIndexInfo("guestwepkey_value");%>" type="hidden">
<p style="display: none">
<label class="duple"><SCRIPT>ddw("txtWepKey");</SCRIPT>&nbsp;:</label>
<input id="wep_key_value" name="wep_key_value" size="30" maxlength="10" value="" type="text">
<input id="f_wep_format_0" name="f_wep_format_0" value="" type="hidden">
</p>

<div id="wep_key_64"	style="display:none"><script>print_keys("wepkey_64","10");</script></div>
<div id="wep_key_128" style="display:none"><script>print_keys("wepkey_128","26");</script></div>

</p>
</fieldset></div>
<div class="box" id="show_wpa" style="display:none">
<h3><span id="wpa_note"></span></h3>
<p><span id="wpa_comment"></span></p>
<fieldset>
<div>
<p>
<input default="0" id="wireless_guest_cipher_0" name="wireless_guest_cipher_0" value="<%getIndexInfo("guest_cipher");%>" type="hidden">
<label class="duple"><SCRIPT >ddw("txtCipherType");</SCRIPT>&nbsp;:</label>
<select id="guest_cipher_type" onchange="wireless_guest_cipher_type_selector(this.value);">
<option value="1">TKIP</option>
<option value="2">AES</option>
<option value="3"><SCRIPT>ddw("txtTKIPandAES");</SCRIPT></option>
</select>
</p>
<p>
<input id="wireless_guest_wpa_auth_0" name="wireless_guest_wpa_auth_0" value="<%getIndexInfo("guest_wpa_auth");%>" type="hidden">
<label class="duple">PSK / EAP&nbsp;:</label>
<select id="guest_wpa_auth_type" name="guest_wpa_auth_type" onchange="wireless_guest_wpa_auth_selector(this.value);">
<option value="psk">PSK</option>
<option value="eap">EAP</option>
</select>
</p>				
</div>
<div id="guest_psk_setting" style="display:none">
<p style="display: block;">
<input default="" id="guest_wpa_psk_0" name="guest_wpa_psk_0" value="<%getIndexInfo("guest_psk");%>" type="hidden">
<label class="duple"><SCRIPT>ddw("txtPreSharedKey");</SCRIPT>&nbsp;:</label>
<input id="guest_wpa_psk" name="guest_wpa_psk" size="30" maxlength="64" value="<%getIndexInfo("guest_psk");%>" type="text">
<SCRIPT>ddw("txtWpaKeyType");</SCRIPT>
</p>	
</div>
<div id="eap_setting" style="display:none">
<p style="display: block;">
<label class="duple">802.1X&nbsp;</label>
</p>		
	
<p style="display: block;">
<input default="" id="guest_radius_server_ip" name="guest_radius_server_ip" value="<%getIndexInfo("guest_rs_ip");%>" type="hidden">
<label class="duple"><SCRIPT>ddw("txtIPAddress");</SCRIPT>&nbsp;:</label>
<input id="guest_radius_server_ip_0" name="guest_radius_server_ip_0" size="15" maxlength="15" value="<%getIndexInfo("guest_rs_ip");%>" type="text">
</p>
<p style="display: block;">
<input default="" id="guest_radius_server_port" name="guest_radius_server_port" value="<%getIndexInfo("guest_rs_port");%>" type="hidden">
<label class="duple"><SCRIPT>ddw("txtPort");</SCRIPT>&nbsp;:</label>
<input id="guest_radius_server_port_0" name="guest_radius_server_port_0" size="8" maxlength="5" value="<%getIndexInfo("guest_rs_port");%>" type="text">
</p>
<p style="display: block;">
<input default="" id="guest_radius_server_psk" name="guest_radius_server_psk" value="<%getIndexInfo("guest_rs_key");%>" type="hidden">
<label class="duple"><SCRIPT>ddw("txtSharedSecret");</SCRIPT>&nbsp;:</label>
<input id="guest_radius_server_psk_0" name="guest_radius_server_psk_0" size="50" maxlength="64" value="<%getIndexInfo("guest_rs_key");%>" type="password">
</p>

</div>
<fieldset>
</div>
</div><!-- box_wireless_security -->
<!--
<div class="box" style="display: none;">
<h3>ROUTER SETTING FOR Guest Zone</h3>
<p>Use this section to configure the quest zone settings of your router.
The quest zone provide a separate network zone for guest to access
Internet.</p><fieldset>
<p><label class="duple">Router IP Address&nbsp;:</label>
<input autocomplete="off" default="" id="router_ip_address" size="20" maxlength="15" value="" name="" type="text"></p>
<p><label class="duple">Default Subnet Mask&nbsp;:</label>
<input autocomplete="off" default="" id="default_subnet_mask" size="20" maxlength="15" value="" name="" type="text">
</p></fieldset></div><div class="box" style="display: none;">
<h3>Guest Zone Client Isolation</h3><p>
Enable the function to prevent one guest client to access other clients
in the Guest Zone. The guest client can access to the Internet only.</p>
<fieldset><p>
<input default="" id="GZCIsolation_checkbox_control" name="" type="hidden">
<label class="duple">Enable Client Isolation :</label>
<input default="false" id="GZCIsolation_checkbox_control_select" onclick="GZCIsolation_checkbox_control_selector(this.checked);" type="checkbox">
</p></fieldset></div>
<div class="box" style="display: none;">
<h3>ROUTING BETWEEN HOST ZONE AND GUEST ZONE</h3>
<p>Use this section to enable routing between Host Zone and Guest Zone,
Guest clients can not access Host clients' data without enable the
function.</p>
<fieldset><p>
<input default="" id="routing_between_zones_checkbox_control" name="" type="hidden">
<label class="duple"><SCRIPT >ddw("txtRoutZone");</SCRIPT> :</label>
<input default="false" id="routing_between_zones_checkbox_control_select" onclick="routing_between_zones_checkbox_control_selector(this.checked);" type="checkbox">
</p></fieldset></div>
<div class="box" style="display: none;">
<h3>DHCP SERVER SETTINGS FOR GUEST ZONE</h3>
<p> Use this section to configure the built-in DHCP server to assign IP address to the computers on your network.</p>
<fieldset><p>
<input default="" id="dhcp_server_checkbox_control" name="" type="hidden">
<label class="duple">Enable DHCP Server :</label>
<input default="false" id="dhcp_server_checkbox_control_select" onclick="dhcp_server_checkbox_control_selector(this.checked);" type="checkbox">
</p><p>
<label class="duple">DHCP IP Address Range&nbsp;:</label>
<input autocomplete="off" default="" id="dhcp_ip_address_start" size="4" maxlength="3" value="" name="" type="text"> to&nbsp;
<input autocomplete="off" default="" id="dhcp_ip_address_end" size="4" maxlength="3" value="" name="" type="text"> (addresses within the LAN subnet)
</p><p>
<label class="duple">DHCP Lease Time&nbsp;:</label>
<input autocomplete="off" default="" id="dhcp_lease_time" size="7" maxlength="6" value="" name="" type="text"> (minutes)
</p></fieldset></div>
<div class="box" id="dhcp_client_list" style="display: none;">
</div><div class="box" style="display: none;">
<h3>LOCK CLIENT LIST FOR GUEST ZONE</h3>
<p>Use this section to lock all PC clients which are on network to an IP/MAC
address bundle list, only PCs on the list can access the network after
enable the function. It makes sure that no unauthorized client can
access Guest Zone network.</p>
<fieldset><p>
<input default="" id="lock_client_list_checkbox_control" name="" type="hidden">
<label class="duple">Enable Lock Client List :</label>
<input default="false" id="lock_client_list_checkbox_control_select" onclick="lock_client_list_checkbox_control_selector(this.checked);" type="checkbox">
</p></fieldset></div>
</div>
--><!-- section -->

<div class="box" style="display:block">
<h3><SCRIPT >ddw("txtGuestZoneIsolation");</SCRIPT></h3>
<p><SCRIPT >ddw("txtGuestZoneStr1");</SCRIPT></p>
<input id="guestIsolation" name="guestIsolation" value="<%getIndexInfo("guestZoneIsolation")%>" type="hidden">
<label class="duple">
<SCRIPT >ddw("txtEnableIsolation");</SCRIPT>
&nbsp;:</label>
<input id="isolation_enable" type="checkbox">
</div>

<div class="box" style="display:block">
<h3><SCRIPT >ddw("txtGuestZoneRounting");</SCRIPT></h3>
<p><SCRIPT >ddw("txtGuestZoneStr2");</SCRIPT></p>
<input id="guestRounting" name="guestRounting" value="<%getIndexInfo("wlanGuestRouteZone")%>" type="hidden">
<label class="duple" for="gw_name">
<SCRIPT >ddw("txtEnableRountiog");</SCRIPT>
&nbsp;:</label>
<input id="rounting_enable" type="checkbox">
</div>

<div class="box" id="dhcp_client_list"></div>

<div class="box" style="display:block">
<h3><SCRIPT >ddw("txtGuestZoneLockClientList");</SCRIPT></h3>
<p><SCRIPT >ddw("txtGuestZoneStr3");</SCRIPT></p>
<input id="lockClientList" name="lockClientList" value="<%getIndexInfo("guestZoneLockClientList")%>" type="hidden">
<label class="duple" for="gw_name">
<SCRIPT >ddw("txtLockClientList");</SCRIPT>
&nbsp;:</label>
<input id="lockClientList_enable" type="checkbox">
</div>

</form><!-- InstanceEndEditable --></div>

</td>
<td id="sidehelp_container">
<div id="help_text"><!-- InstanceBeginEditable name="Help_Text" -->
<strong>	<SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtGuestZoneComment");</SCRIPT></p>
<p class="more">
<!-- Link to more help -->
<a href="../Help/Advanced.asp#GuestZone" onclick="return jump_if();"><SCRIPT>ddw("txtMore");</SCRIPT>...</a>
</p><!-- InstanceEndEditable --></div></td></tr></tbody></table>
<table id="footer_container" summary="" border="0" cellspacing="0">
<tbody><tr>
<td><img src="../Images/img_wireless_bottom.gif" alt="" width="114" height="35"></td>
<td>&nbsp;</td>
</tr></tbody></table></td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
<!-- InstanceEnd --></body></html>
