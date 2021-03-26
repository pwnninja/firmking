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


function get_webserver_ssi_uri() {
	return ("" !== "") ? "/Basic/Setup.asp" : "/Status/Device_Info.asp";
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
<script language="JavaScript" type="text/javascript">
//<![CDATA[
		
		var local_debug =false;
		var mf;
var global_fw_minor_version = "<%getInfo("fwVersion")%>";
		var current_time;
		var system_uptime_secs;
		var connection_state;
		var primary_connection_state;
		var secondary_connection_state;
		var wan_ip_mode;
		var wan_ip_address;
		var wan_mpppoe_primary_ip_address;
		var wan_mpppoe_secondary_ip_address;
		var wan_physical_state;
		var wan_mpppoe_primary_physical_state;
		var wan_mpppoe_secondary_physical_state;
		var wan_auth_sec_model;
		var wan_mpppoe_primary_auth_sec_model;	
		var wan_mpppoe_secondary_auth_sec_model;	
		var wan_subnet;
		var wan_mpppoe_primary_subnet;
		var wan_mpppoe_secondary_subnet;
		var wan_gateway;
		var wan_mpppoe_primary_gateway;
		var wan_mpppoe_secondary_gateway;
		var wan_primary_dns;
		var wan_mpppoe_primary_primary_dns;
		var wan_mpppoe_secondary_primary_dns;
		var wan_secondary_dns;
		var wan_mpppoe_primary_secondary_dns;
		var wan_mpppoe_secondary_secondary_dns;
		var wan_interface_up_time;
		var wan_interface_up_time_secs = 0;
		var wan_primary_interface_up_time;
		var wan_primary_interface_up_time_secs = 0;
		var wan_secondary_interface_up_time;
		var wan_secondary_interface_up_time_secs = 0;
		var wan_bigpond_state;
		var wan_state;
		var wan_primary_state;
		var wan_secondary_state;		
		var connection_status_retriever = null;
		var wlan_channel_num;
		var wlan_client_state;
		var Last_wan_connection_state;
		var ItvID=0;
		var check_wan_state_count=0;
		var start_check_wan_state=0;
		var STATIC = 0;
		var DHCP = 1;
		var PPPOE = 2;
		var PPTP = 3;
		var L2TP = 4;
		var BIGPOND = 5;
		var MultiPPPoE = 6;
		var RussiaPPTP = 7;
		var RussiaPPPoE = 8;
		var thetime = new Date();
		
		function wireless_selector()
		{
			
			var wep_on = "<%getIndexInfo("wep_enabled");%>";
			var wpa_on = ("<%getIndexInfo("wpa_psk_enabled");%>" == "true" || 
						 "<%getIndexInfo("wpa_enterprise_enabled");%>" == "true") ? "true" : "false";
			var wpa_mode = "<%getIndexInfo("wpa_mode");%>";
			var ieeex_on = "<%getIndexInfo("wpa_enterprise_enabled");%>";
			var phy_mode = "<%getIndexInfo("band");%>";
			var super_mode = "0";
			var info_security_type = sw("txtDisabled");
			var wlan_mac_addr = "<%getIndexInfo("wlan_mac_addr");%>";
			var wifisc_enabled = "<%getIndexInfo("wsc_enabled");%>";
			var wifisc_configured = "<%getIndexInfo("wsc_configured");%>";
			var wlan_operation_mode="<%getIndexInfo("wlanMode");%>";
			var wds_encrypt ="<%getInfo("wdsEncrypt");%>";
			if (wep_on == "true") {
				info_security_type = "WEP";
			}
			else if (wpa_on == "true") {
				if (wpa_mode == "1") {
					info_security_type = sw("txtWPAOnly");
				} else if (wpa_mode == "2") {
					info_security_type = sw("txtWPAWPA2");
				} else if (wpa_mode == "3") {
					info_security_type = sw("txtWPA2Only");
				}
				if (ieeex_on == "true") {
					info_security_type += " - "+sw("txtEnterprise");
				} else {
					info_security_type += " - "+sw("txtPersonal");
				}
			}

			if (WLAN_ENABLED != "1") {
				document.getElementById("wireless_radio").innerHTML = sw("txtOff");
			} else {
				if (wlan_mac_addr.toUpperCase() == "00:00:00:00:00:00") {
					document.getElementById("wireless_radio").innerHTML = sw("txtInitf");
					document.getElementById("wlan_mac_addr").style.visibility = "hidden";
					document.getElementById("ssid").style.visibility = "hidden";
					document.getElementById("security_type").style.visibility = "hidden";
					document.getElementById("wifisc_configured").style.visibility = "hidden";
					document.getElementById("wlan_mode").style.visibility = "hidden";
				} else {
						if (wifisc_enabled == "false") {
							document.getElementById("wifisc_configured").innerHTML = sw("txtDisabled");
						} else {
							if (wifisc_configured == "true") {
								document.getElementById("wifisc_configured").innerHTML = sw("txtEnConfigured");
							} else {
								document.getElementById("wifisc_configured").innerHTML = sw("txtEnNotConfigured");
							}
						}
					var ssid="<%getInfo("ssid");%>";
					var new_ssid="";
					for(i=0;i<ssid.length;i++)
					{
						var char=ssid.substring(i,i+1);
						if(char==' ')
						{
							new_ssid+="&nbsp;";
						}
						else
						{
							new_ssid+=char;
						}
					}
					document.getElementById("ssid").innerHTML = new_ssid;
					document.getElementById("security_type").innerHTML = info_security_type;
					document.getElementById("wireless_radio").innerHTML = sw("txtEnabled");
					document.getElementById("wlan_mac_addr").innerHTML = wlan_mac_addr.toUpperCase();
					if(wlan_operation_mode=="1"){
						document.getElementById("wlan_mode").innerHTML = "AP Client";
					}else if(wlan_operation_mode=="0"){
						document.getElementById("wlan_mode").innerHTML = "AP";
					}else if(wlan_operation_mode=="2"){
						var strEnc;
						document.getElementById("wlan_mode").innerHTML = "WDS";
						if(wds_encrypt=="0"){
							strEnc=sw("txtDisabled");
						}else if(wds_encrypt=="1" || wds_encrypt=="2"){
							strEnc="WEP";
						}else if(wds_encrypt=="3"){
							strEnc="WPA-PSK(TKIP)";
						}else if(wds_encrypt=="4"){
							strEnc="WPA2-PSK(AES)";
						}
						document.getElementById("security_type").innerHTML = strEnc;
						document.getElementById("ssid").innerHTML="None";
					}else if(wlan_operation_mode=="3"){
						var strEnc;
						document.getElementById("wlan_mode").innerHTML = "WDS with AP";
						if(wds_encrypt=="0"){
							strEnc=sw("txtDisabled");
						}else if(wds_encrypt=="1" || wds_encrypt=="2"){
							strEnc="WEP";
						}else if(wds_encrypt=="3"){
							strEnc="WPA-PSK(TKIP)";
						}else if(wds_encrypt=="4"){
							strEnc="WPA2-PSK(AES)";
						}
						document.getElementById("security_type").innerHTML = info_security_type+'(AP)'+' / '+strEnc+'(WDS)';
					} else if(wlan_operation_mode=="5"){
						document.getElementById("wlan_mode").innerHTML = "WISP";
					} else if(wlan_operation_mode=="-1"){
						document.getElementById("wlan_mode").innerHTML = "Wireless Router";
					}else if(wlan_operation_mode=="6" || wlan_operation_mode=="7")
					{
                        var strEnc;
						if(wlan_operation_mode=="6")
						{	document.getElementById("wlan_mode").innerHTML = "WDS with Router";}
						else
						{	document.getElementById("wlan_mode").innerHTML = "WDS +AP with Router";}
                        if(wds_encrypt=="0"){
                            strEnc=sw("txtDisabled");
                        }else if(wds_encrypt=="1" || wds_encrypt=="2"){
                            strEnc="WEP";
                        }else if(wds_encrypt=="3"){
                            strEnc="WPA-PSK(TKIP)";
                        }else if(wds_encrypt=="4"){
                            strEnc="WPA2-PSK(AES)";
                        }
                        document.getElementById("security_type").innerHTML = strEnc;
						if(wlan_operation_mode=="6")
                        	document.getElementById("ssid").innerHTML="None";
					}
				}
			}
		}

		function current_time_selector()
		{
			document.getElementById("current_time").innerHTML = current_time;
		}

		function nat_enabled_selector()
		{
			var nat_enabled = "";
			document.getElementById("nat_enabled").innerHTML = (nat_enabled == "true")?"Enable":"Disable";
		}

		function system_uptime_selector()
		{
			var system_uptime = '';
			var   uptime_secs = system_uptime_secs;
			var days = Math.floor(uptime_secs / 86400);
			uptime_secs %= 86400;
			var hours = Math.floor(uptime_secs / 3600);
			uptime_secs %= 3600;
			var mins = Math.floor(uptime_secs / 60);
			uptime_secs %= 60;

			system_uptime = days + " " + 
				((days == 1) 
					? sw("txtDay")
					: sw("txtDays"))
				+ ", ";
			system_uptime += hours + ":" + padout(mins) + ":" + padout(uptime_secs);
			document.getElementById("system_uptime").innerHTML = system_uptime;
		}


		function wan_primary_uptime_selector()
		{
			if (get_primary_connection_state() == 0) {
				document.getElementById("wan_primary_interface_up_time_str").innerHTML = "N/A";
				return;
			}

			if (get_primary_connection_state() != 2) {
				wan_primary_interface_up_time_secs = 0;
			}
				var wan_primary_uptime = '';
				var wan_primary_uptime_secs = wan_primary_interface_up_time_secs;
				var days = Math.floor(wan_primary_uptime_secs / 86400);
				wan_primary_uptime_secs %= 86400;
				var hours = Math.floor(wan_primary_uptime_secs / 3600);
				wan_primary_uptime_secs %= 3600;
				var mins = Math.floor(wan_primary_uptime_secs / 60);
				wan_primary_uptime_secs %= 60;
	
				wan_primary_uptime = days + " " + 
					((days == 1) 
						? sw("txtDay")
						: sw("txtDays"))
					+ ", ";
				wan_primary_uptime += hours + ":" + padout(mins) + ":" + padout(wan_primary_uptime_secs);			
				document.getElementById("wan_primary_interface_up_time_str").innerHTML = wan_primary_uptime;		
		}


		function wan_secondary_uptime_selector()
		{
			if (get_secondary_connection_state() == 0) {
				document.getElementById("wan_secondary_interface_up_time_str").innerHTML = "N/A";
				return;
			}
			
			if (get_secondary_connection_state() != 2) {
				wan_secondary_interface_up_time_secs = 0;
			}
			var wan_secondary_uptime = '';
			var wan_secondary_uptime_secs = wan_secondary_interface_up_time_secs;
			var days = Math.floor(wan_secondary_uptime_secs / 86400);
			wan_secondary_uptime_secs %= 86400;
			var hours = Math.floor(wan_secondary_uptime_secs / 3600);
			wan_secondary_uptime_secs %= 3600;
			var mins = Math.floor(wan_secondary_uptime_secs / 60);
			wan_secondary_uptime_secs %= 60;

			wan_secondary_uptime = days + " " + 
				((days == 1) 
					? sw("txtDay")
					: sw("txtDays"))
				+ ", ";
			wan_secondary_uptime += hours + ":" + padout(mins) + ":" + padout(wan_secondary_uptime_secs);
			document.getElementById("wan_secondary_interface_up_time_str").innerHTML = wan_secondary_uptime;				
		}

		function wan_uptime_selector()
		{
			if (get_connection_state() == 0) {
				document.getElementById("wan_interface_up_time_str").innerHTML = "N/A";
				return;
			}

			if (get_connection_state() != 2) {
				wan_interface_up_time_secs = 0;
			}

			var wan_uptime = '';
			var wan_uptime_secs = wan_interface_up_time_secs;
			var days = Math.floor(wan_uptime_secs / 86400);
			wan_uptime_secs %= 86400;
			var hours = Math.floor(wan_uptime_secs / 3600);
			wan_uptime_secs %= 3600;
			var mins = Math.floor(wan_uptime_secs / 60);
			wan_uptime_secs %= 60;

			wan_uptime = days + " " + 
				((days == 1) 
					? sw("txtDay")
					: sw("txtDays"))
				+ ", ";
			wan_uptime += hours + ":" + padout(mins) + ":" + padout(wan_uptime_secs);
			document.getElementById("wan_interface_up_time_str").innerHTML = wan_uptime;
		}

		/*
		 * wan_ip_mode_selector()
		 *	show WAN settings according to selected WAN mode.
		 */
		function wan_ip_mode_selector()
		{
			connection_types = new Array (sw("txtStaticIP"),sw("txtDHCPClient"),sw("txtPPPOE"),sw("txtPPTP"),sw("txtL2TP"),sw("txtBigPondClient"),sw("txtMultiPPPoE"),sw("txtPPTP"),sw("txtPPPOE"));
			
			var wanType =<%getInfo("wanType");%>;
			var Wan_Conn_state = '<%getWanConnection("wanConnInfo");%>';
			wan_ip_mode =wanType ;
			
			if(wanType==9)
			wan_ip_mode =1;
			var bigpond_enable = "false";

			if ((bigpond_enable == "true")&&(wan_ip_mode == DHCP)) {
				wan_ip_mode = BIGPOND;
			}
			document.getElementById("wan_ip_mode").innerHTML = connection_types[wan_ip_mode];
			if(Wan_Conn_state=='disconnected')
				document.getElementById("connstate").value = connection_types[wan_ip_mode]+' '+sw("txtDisconnected");
			if(Wan_Conn_state=='connected')
				document.getElementById("connstate").value = connection_types[wan_ip_mode]+' '+sw("txtConnected");
			if(wan_ip_mode == DHCP){
				get_by_id("bt_connect").value = sw("txtRenew");
				get_by_id("bt_connect").disabled = true;
				get_by_id("bt_disconnect").value = sw("txtRelease");
				get_by_id("bt_disconnect").disabled = true;
			}else if(wan_ip_mode != STATIC){
				get_by_id("bt_connect").value = sw("txtConnect");
				get_by_id("bt_connect").disabled = true;
				get_by_id("bt_disconnect").value = sw("txtDisconnect");
				get_by_id("bt_disconnect").disabled = true;
			}else{
				document.getElementById("bt_connect").style.display="none";
				document.getElementById("bt_disconnect").style.display="none";
			}
			if(wan_ip_mode == MultiPPPoE)
			{
				document.getElementById("wan_box").style.display = "none";
				document.getElementById("wan_mpppoe_primary_button").style.display = "block";
				document.getElementById("wan_mpppoe_secondary_button").style.display = "block";
				document.getElementById("wan_mpppoe_primary").innerHTML = sw("txtMultiPPPoE1");
				document.getElementById("wan_mpppoe_secondary").innerHTML = sw("txtMultiPPPoE1");
			}

		}

		function getBigPondStatusString()
		{
			status_array = new Array (
				sw("txtUninitalized"),
				sw("txtDNSLookupAuthServer"),
				sw("txtDNSLookupLoginServer"),
				sw("txtRestartduringDNSquery"),
				sw("txtSendReceiveauth"),
				sw("txtSendReceivelogin"),
				sw("txtSendReceiveheartbeat"),
				sw("txtUserloggingout"),
				sw("txtUserloggedout"),
				sw("txtSendReceiveinstancefailure"));
			var bp_st = wan_bigpond_state*1;
			return status_array[bp_st];
		}

		function getWANNetworkStatusString()
		{
			if (get_connection_state() == -1) return (sw("txtIncorrectlyconfigured"));
			if (get_connection_state() != 2) {
				wan_interface_up_time_secs = 0;
			}
			if (get_connection_state() == 0) {
				return (sw("txtDisconnected"));
			}
			if (get_connection_state() == 1) return (sw("txtEstablishing"));
			if (get_connection_state() == 2) {
				if (wan_state == "1") {
					return (sw("txtEstablishedRateEstimate"));
				} else {
					return (sw("txtEstablished"));
				}
			}
			if (get_connection_state() == 3) return (sw("txtDisconnecting"));
			return (sw("txtUnknown"));			
		}

		function getWANPrimaryNetworkStatusString()
		{	
			if (get_primary_connection_state() == -1) return (sw("txtIncorrectlyconfigured"));
			if (get_primary_connection_state() != 2) {
				wan_primary_interface_up_time_secs = 0;
			}
			if (get_primary_connection_state() == 0) {
				return (sw("txtDisconnected"));
			}
			if (get_primary_connection_state() == 1) return (sw("txtEstablishing"));
			if (get_primary_connection_state() == 2) {
				if (wan_primary_state == "1") {
					return (sw("txtEstablishedRateEstimate"));
				} else {
					return (sw("txtEstablished"));
				}
			}
			if (get_primary_connection_state() == 3) return (sw("txtDisconnecting"));
			return (sw("txtUnknown"));		
		}
		function getWANSecondaryNetworkStatusString()
		{				
			if (get_secondary_connection_state() == -1) return (sw("txtIncorrectlyconfigured"));
			if (get_secondary_connection_state() != 2) {
				wan_secondary_interface_up_time_secs = 0;
			}
			if (get_secondary_connection_state() == 0) {
				return (sw("txtDisconnected"));
			}
			if (get_secondary_connection_state() == 1) return (sw("txtEstablishing"));
			if (get_secondary_connection_state() == 2) {
				if (wan_secondary_state == "1") {
					return (sw("txtEstablishedRateEstimate"));
				} else {
					return (sw("txtEstablished"));
				}
			}
			if (get_secondary_connection_state() == 3) return (sw("txtDisconnecting"));
			return (sw("txtUnknown"));
		}
		/*
		 * wan_connection_status_selector()
		 *	show WAN settings according to selected WAN mode.
		 */
		function wan_connection_status_selector()
		{
			var wan_dns1_value_st;
			var wan_dns2_value_st;
			
			if (wan_ip_mode == MultiPPPoE){
				wan_primary_uptime_selector();
				wan_secondary_uptime_selector();
			}else{
			wan_uptime_selector();
			}		
			document.getElementById("wan_network_status").innerHTML = getWANNetworkStatusString();
			if(wan_physical_state == "0"){
				document.getElementById("wan_physical_state").innerHTML = sw("txtDisconnect");
			}else{
				document.getElementById("wan_physical_state").innerHTML = sw("txtConnected");
			}
			if(wan_ip_mode == MultiPPPoE){
				document.getElementById("wan_mpppoe_primary_network_status").innerHTML = getWANPrimaryNetworkStatusString();
				document.getElementById("wan_mpppoe_secondary_network_status").innerHTML = getWANSecondaryNetworkStatusString();
				document.getElementById("wan_mpppoe_primary_physical_state").innerHTML = wan_physical_state;
				document.getElementById("wan_mpppoe_secondary_physical_state").innerHTML = wan_physical_state;
				document.getElementById("wan_mpppoe_primary_ip_address").innerHTML = wan_mpppoe_primary_ip_address;
				document.getElementById("wan_mpppoe_secondary_ip_address").innerHTML = wan_mpppoe_secondary_ip_address;
				document.getElementById("wan_mpppoe_primary_subnet").innerHTML = wan_mpppoe_primary_subnet;	
				document.getElementById("wan_mpppoe_secondary_subnet").innerHTML = wan_mpppoe_secondary_subnet;	
				document.getElementById("wan_mpppoe_primary_gateway").innerHTML = wan_mpppoe_primary_gateway;
				document.getElementById("wan_mpppoe_secondary_gateway").innerHTML = wan_mpppoe_secondary_gateway;
				document.getElementById("wan_mpppoe_primary_primary_dns").innerHTML = wan_mpppoe_primary_primary_dns;
				document.getElementById("wan_mpppoe_secondary_primary_dns").innerHTML = wan_mpppoe_secondary_primary_dns;
				document.getElementById("wan_mpppoe_primary_secondary_dns").innerHTML = wan_mpppoe_primary_secondary_dns;
				document.getElementById("wan_mpppoe_secondary_secondary_dns").innerHTML = wan_mpppoe_secondary_secondary_dns;
			}else{

				document.getElementById("wan_network_status").innerHTML = getWANNetworkStatusString();
				document.getElementById("wan_ip_address").innerHTML = wan_ip_address;
				document.getElementById("wan_subnet").innerHTML = wan_subnet;
				document.getElementById("wan_gateway").innerHTML = wan_gateway;
				document.getElementById("wan_primary_dns").innerHTML = wan_primary_dns;
				document.getElementById("wan_secondary_dns").innerHTML = wan_secondary_dns;
				
				document.getElementById("display_wanipaddr").innerHTML=wan_ip_address;
				document.getElementById("display_wansubnet").innerHTML=wan_subnet;
				document.getElementById("display_wangateway").innerHTML=wan_gateway;
				wan_dns1_value_st = wan_primary_dns;
				if(wan_secondary_dns != '0.0.0.0')
					wan_dns1_value_st = wan_dns1_value_st+'<br>'+wan_secondary_dns;
				document.getElementById("display_wandns").innerHTML=wan_dns1_value_st;
					if(get_connection_state() == 2)
						document.getElementById("connstate").value = connection_types[wan_ip_mode]+' '+sw("txtConnected");
					else	
						document.getElementById("connstate").value = connection_types[wan_ip_mode]+' '+sw("txtDisconnected");
				
			}
			if (wan_ip_mode == BIGPOND) {
				document.getElementById("box_bigpond_status").style.display = "block";
				document.getElementById("bigpond_server").innerHTML = "";
				document.getElementById("bigpond_currstatus").innerHTML = getBigPondStatusString();
			} else {
				document.getElementById("box_bigpond_status").style.display = "none";
			}

			if ( wan_auth_sec_model ) {
				var auth_sec_display = "none";
				if ( wan_auth_sec_model != "N/A" ) {
					document.getElementById("wan_auth_sec_model").innerHTML = wan_auth_sec_model;
					auth_sec_display = "block"
				}
				document.getElementById("box_authsecmodel_status").style.display = auth_sec_display;
			}

			if ( wan_mpppoe_primary_auth_sec_model ) {
				var auth_sec_display = "none";
				if ( wan_mpppoe_primary_auth_sec_model != "N/A" ) {
					document.getElementById("wan_mpppoe_primary_auth_sec_model").innerHTML = wan_mpppoe_primary_auth_sec_model;
					auth_sec_display = "block"
				}
				document.getElementById("mpppoe_primary_box_authsecmodel_status").style.display = auth_sec_display;
			}
			if ( wan_mpppoe_secondary_auth_sec_model ) {
				var auth_sec_display = "none";
				if ( wan_mpppoe_secondary_auth_sec_model != "N/A" ) {
					document.getElementById("wan_mpppoe_secondary_auth_sec_model").innerHTML = wan_mpppoe_secondary_auth_sec_model;
					auth_sec_display = "block"
				}
				document.getElementById("mpppoe_secondary_box_authsecmodel_status").style.display = auth_sec_display;
			}

			var dhcp_cur="<% getInfo("dhcp-current"); %>";
			var dhcp_server_mode;
			if(dhcp_cur =="2" || dhcp_cur =="10" && OP_MODE=="0")
			//if(dhcp_cur =="2" || dhcp_cur =="10" && OP_MODE==1)//add by gold
					dhcp_server_mode = "1";
			else
					dhcp_server_mode = "0";
			var dhcp_server_enabled = parseInt(dhcp_server_mode,10);
			if (dhcp_server_enabled == 1) {
				document.getElementById("info_dhcp_server_status").innerHTML = sw("txtEnabled");
			} else {
				document.getElementById("info_dhcp_server_status").innerHTML = sw("txtDisabled");
			}
		}

		/*
		 * wan_mac_addr_selector()
		 *	show WAN mac address in uppercase
		 */
		function wan_mac_addr_selector(){
			var wan_mac_addr = "<% getInfo("wan-hwaddr"); %>";
			document.getElementById("wan_mac_addr").innerHTML = wan_mac_addr.toUpperCase();
			document.getElementById("display_wanmacaddr").innerHTML = wan_mac_addr.toUpperCase();
		}

		/*
		 * lan_mac_addr_selector()
		 *	show LAN mac address in uppercase
		 */
		function lan_mac_addr_selector()
		{
			var lan_mac_addr = "<% getInfo("lanMacAddr"); %>";
			document.getElementById("lan_mac_addr").innerHTML = lan_mac_addr.toUpperCase();
		}

		function padout(number)
		{
			return (number < 10) ? '0' + number : number;
		}

		/*
		 * update_clock()
		 *	update current time and system up time
		 */
		function update_clock()
		{
			/** update current time*/
			thetime.setTime (thetime.getTime()+1000);
			current_time = thetime.toLocaleString();
			current_time_selector();

			if (wan_ip_mode == MultiPPPoE)
			{
				if ((get_primary_connection_state() == 2) && (wan_primary_interface_up_time_secs > 0)) {
					wan_primary_interface_up_time_secs += 1;
					wan_primary_uptime_selector();
				}
				if ((get_secondary_connection_state() == 2) && (wan_secondary_interface_up_time_secs > 0)) {
					wan_secondary_interface_up_time_secs += 1;
					wan_secondary_uptime_selector();
				}
			}else{
			if ((get_connection_state() == 2) && (wan_interface_up_time_secs > 0)) {
				wan_interface_up_time_secs += 1;
				wan_uptime_selector();

				}			

			}
			/** update system up time*/
			system_uptime_secs += 1;
			//system_uptime_selector();
			window.setTimeout ("update_clock()", 1000);
		}
		/** Number of days in each month of the year.*/
		
		/** DST start and end Date objects.*/
		var dst_start_d, dst_end_d;
		/** Return an initialized Date object.*/
		function compute_date(year, month, week, day, hour, min)
		{
			/* Get first day of week in the specified month and year. */
			var tentative_d = new Date(year, month, 1, hour - 1, min + 59, 59);
			var exact_date = tentative_d.getDate() - tentative_d.getDay() + day;
			if (exact_date <= 0) {
				exact_date += 7;
			}

			/* Get day of week for the specified week. */
			exact_date += (week - 1) * 7;

			/* We may have gone beyond the number of days in the month. */
			if (exact_date > days_in_month[month]) {
				exact_date -= 7;
			}

			return new Date(year, month, exact_date, hour - 1, min + 59, 59);
		}

		/*
		 * in_dst_now()
		 *	Returns true if the Date argument is within the DST start and end times.
		 */
		function in_dst_now(date)
		{
			var localtime = date.getTime();
			if (dst_start_d.getTime() < dst_end_d.getTime()) {
				return localtime >= dst_start_d.getTime() && localtime <= dst_end_d.getTime();
			} else {
				return !(localtime < dst_start_d.getTime() && localtime > dst_end_d.getTime());
			}
		}


var tz_offTime;
function calcu_tzOffTime()
{	
	var tz = new Array();
	var time_zone = "<% getInfo("ntpTimeZone"); %>";
tz = time_zone.split(" ");
	if(tz[0] == 3 && tz[1] == 1)
		tz_offTime = tz[0]*10+5;
	else if(tz[0] == 3 && tz[1] == 1)
		tz_offTime = tz[0]*10+5;
	else if(tz[0] == -3 && tz[1] == 4)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -4 && tz[1] == 3)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -5 && tz[1] == 3)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -9 && tz[1] == 4)
		tz_offTime = tz[0]*10-5;
	else if(tz[0] == -9 && tz[1] == 5)
		tz_offTime = tz[0]*10-5;
	else
		tz_offTime = tz[0]*10;
		
	tz_offTime = -360*parseInt(tz_offTime, 10);
		
}


		/* 
		 * get_current_time()    
		 * 	The server maintains an internal time reference by storing three values,
		 * 	the UTC (or 'epoch time') in seconds, the timezone (UTC offset in seconds)
		 * 	which refers to a geographic time zone, and a daylight savings offset
		 * 	which is used to adjust the timezone. note that PCs usually incorporate
		 * 	the daylight savings offset into the timezone, for instance you have
		 * 	PST and PDT used at different times of the year on the US pacific coast.
		 * 	all this information needs to be plugged into the date object, but the
		 * 	date object does not allow the current timezone to be set (only gotten).
		 * 	thus, we'll adjust the UTC time to compensate for any differences between
		 *	the date object's timezone and the server's timezone+offset.
		 */
		function get_current_time()
		{
			var epoch_seconds= parseInt(<% getInfo("currTimeSec");%>, 10);
			calcu_tzOffTime();
			var tz_timezone = tz_offTime;
			var tz_daylight_flag ="<% getInfo("ntpdst"); %>";
			var tz_daylight_offset = <% getIndexInfo("dlend_offset"); %>;
			var ntp_enabled="<%getInfo("ntpenabled");%>";
			if(ntp_enabled == "true"){
			epoch_seconds += tz_timezone;
			}
			thetime.setTime(epoch_seconds * 1000);
			epoch_seconds += thetime.getTimezoneOffset()*60;
			thetime.setTime(epoch_seconds * 1000);
			if (tz_daylight_flag == "true" && ntp_enabled == "true") {/* Manual time setting NO NEED to do any recalculation. Keith */
				/* Calculate number of days in the month for the current year. Account for leap years. */
				var year = thetime.getYear();
				if (year < 1900) {
					year += 1900;
				}

				if ((year % 4 === 0 && year % 100 != 0) || year % 400 === 0) {
					days_in_month[1] = 29;
				}
				/* Calculate the DST start time. */
				var month = parseInt("<%getIndexInfo("dlstart_month");%>", 10);
				var week  = parseInt("<%getIndexInfo("dlstart_week");%>", 10);
				var day   = parseInt("<%getIndexInfo("dlstart_day");%>", 10);
				var hour  = parseInt("<%getIndexInfo("dlstart_hour");%>", 10);
				dst_start_d = compute_date(year, month, week, day, hour, 0);
				/* Calculate the DST end time. */
				month = parseInt("<%getIndexInfo("dlend_month");%>", 10);
				week  = parseInt("<%getIndexInfo("dlend_week");%>", 10);
				day   = parseInt("<%getIndexInfo("dlend_day");%>", 10);
				hour  = parseInt("<%getIndexInfo("dlend_hour");%>", 10);
				dst_end_d = compute_date(year, month, week, day, hour, 0);
				/* Are we in DST now? */
				if (in_dst_now(thetime)) {
					epoch_seconds += (tz_daylight_offset);
				}
			}
			thetime.setTime(epoch_seconds * 1000);
			current_time = thetime.toLocaleString();
		}

function button_disabled()
{
	get_by_id("bt_connect").disabled = true;
	get_by_id("bt_disconnect").disabled = true;
	
}


		function connection_status_ready(dataInstance)
		{
			var isGatewayMode = OP_MODE == "0";
			
			/*
			* Extract the connection status from the document retrieved
			* NOTE: * 1 converts to a number.
			*/
			do {
				
						if(isGatewayMode){ //Router Mode
							wan_physical_state = dataInstance.getElementData("wan_physical_state");
							if (wan_physical_state == null) {
								break;
							}
		
						if (wan_ip_mode == MultiPPPoE) {
							wan_mpppoe_primary_ip_address = dataInstance.getElementData("wan_pri_ip_address"); 
							if (wan_mpppoe_primary_ip_address == null) {
								break;
							}
							wan_mpppoe_secondary_ip_address = dataInstance.getElementData("wan_sec_ip_address"); 
							if (wan_mpppoe_secondary_ip_address == null) {
								break;
							}	
							wan_mpppoe_primary_subnet = dataInstance.getElementData("wan_pri_subnet");
							if (wan_mpppoe_primary_subnet == null) {
								break;
							}
							wan_mpppoe_secondary_subnet = dataInstance.getElementData("wan_sec_subnet");
							if (wan_mpppoe_secondary_subnet == null) {
								break;
							}	
							wan_mpppoe_primary_gateway = dataInstance.getElementData("wan_pri_gateway");
							if (wan_mpppoe_primary_gateway == null) {
								break;
							}
							wan_mpppoe_secondary_gateway = dataInstance.getElementData("wan_sec_gateway");
							if (wan_mpppoe_secondary_gateway == null) {
								break;
							}
							wan_mpppoe_primary_primary_dns = dataInstance.getElementData("wan_primary_dns");
							if (wan_mpppoe_primary_primary_dns == null) {
								break;
							}
							wan_mpppoe_primary_secondary_dns = dataInstance.getElementData("wan_secondary_dns");
							if (wan_mpppoe_primary_secondary_dns == null) {
								break;
							}
							wan_mpppoe_secondary_primary_dns = dataInstance.getElementData("sec_dns1");
							if (wan_mpppoe_secondary_primary_dns == null) {
								break;
							}
							wan_mpppoe_secondary_secondary_dns = dataInstance.getElementData("dns2");
							if (wan_mpppoe_secondary_secondary_dns == null) {
								break;
							}	
							wan_mpppoe_primary_auth_sec_model = dataInstance.getElementData("primary_auth_sec_model");
							if (wan_mpppoe_primary_auth_sec_model == null) {
								break;
							}
							wan_mpppoe_secondary_auth_sec_model = dataInstance.getElementData("secondary_auth_sec_model");
							if (wan_mpppoe_secondary_auth_sec_model == null) {
								break;
							}
							primary_connection_state = dataInstance.getElementData("primary_connection_state");
							if (primary_connection_state == null) {
								break;
							}
							secondary_connection_state = dataInstance.getElementData("secondary_connection_state");
							if (secondary_connection_state == null) {
								break;
							}	
							wan_primary_state = dataInstance.getElementData("wan_primary_state");
							if (wan_primary_state == null) {
								break;
							}	
							wan_secondary_state = dataInstance.getElementData("wan_secondary_state");
							if (wan_secondary_state == null) {
								break;
							}
							wan_primary_interface_up_time = dataInstance.getElementData("wan_primary_interface_up_time");
							if (wan_primary_interface_up_time == null) {
								break;
							}
							wan_primary_interface_up_time_secs = wan_primary_interface_up_time*1;
								
							wan_secondary_interface_up_time = dataInstance.getElementData("wan_secondary_interface_up_time");
							if (wan_secondary_interface_up_time == null) {
								break;
							}
							wan_secondary_interface_up_time_secs = wan_secondary_interface_up_time*1;	
						}else{
		
						wan_auth_sec_model = dataInstance.getElementData("auth_sec_model");
						if (wan_auth_sec_model == null) {
							break;
						}
						connection_state = dataInstance.getElementData("connection_state");
						if (connection_state == null) {
							break;
						}
						
						wan_ip_address = dataInstance.getElementData("wan_ip_address"); 
						if (wan_ip_address == null) {
							break;
						}
						wan_subnet = dataInstance.getElementData("wan_subnet");
						if (wan_subnet == null) {
							break;
						}
						wan_gateway = dataInstance.getElementData("wan_gateway");
						if (wan_gateway == null) {
							break;
						}
						wan_primary_dns = dataInstance.getElementData("wan_primary_dns");
						if (wan_primary_dns == null) {
							break;
						}
						wan_secondary_dns = dataInstance.getElementData("wan_secondary_dns");
						if (wan_secondary_dns == null) {
							break;
						}
						wan_interface_up_time = dataInstance.getElementData("wan_interface_up_time");
						if (wan_interface_up_time == null) {
							break;
						}
						wan_interface_up_time_secs = wan_interface_up_time*1;
		
						wan_state = dataInstance.getElementData("wan_state");
						if (wan_state == null) {
							break;
						}
		
						}
		
						if (wan_ip_mode == BIGPOND) {
							wan_bigpond_state = dataInstance.getElementData("wan_bigpond_state");
							if (wan_bigpond_state == null) {
								break;
							}
						}
						
						wan_connection_status_selector();
						if(check_wan_state_count > 2){
							start_check_wan_state=0;
							check_wan_state_count=0;
						}
						if(start_check_wan_state==0){
							wan_action_buttons_selector();
						}else if(start_check_wan_state==1){
							//disable both button for disconnect and connect
							if(Last_wan_connection_state != connection_state){
								start_check_wan_state=0;
								check_wan_state_count=0;
								wan_action_buttons_selector();
							}else{
								button_disabled();
							}
						}
						
						if (wan_ip_mode == MultiPPPoE) 
						{
							if (wan_primary_state == "1" || wan_secondary_state == "1") {
								window.location.reload();
								return;
							}
						}else{
		
							if (wan_state == "1") {
								window.location.reload();
								return;
							}				
						}
						
						var w_schedule = dataInstance.getElementData("wirless_schedule");
						if (wan_state == null) {
							//break;
								}else {
								if( w_schedule == "Enabled" ) {
								
										document.getElementById("wireless_radio").innerHTML = sw("txtEnabled");
										document.getElementById("wirless_status").style.display =  "block";
											/*get wlan channel num*/
										wlan_channel_num = dataInstance.getElementData("wirless_channel");
										if (wlan_channel_num == null) {
											break;
										}
										document.getElementById("wlan_channel").innerHTML = wlan_channel_num;
										//wlan_client_state = dataInstance.getElementData("wirless_client_state");
										//if (wlan_client_state == null) {
										//	break;
										//}
										//document.getElementById("wlan_clinet_state").innerHTML = wlan_client_state;
										
										}else {
												document.getElementById("wireless_radio").innerHTML = sw("txtOff");
												document.getElementById("wirless_status").style.display =  "none";
											}
							
									}
									}else{ //Bridge Mode
										var w_schedule = dataInstance.getElementData("wirless_schedule");
										//if (wan_state == null) {
													//break;
										//}else {
									//
												if( w_schedule == "Enabled" ) {
													
													document.getElementById("wireless_radio").innerHTML = sw("txtEnabled");
													document.getElementById("wirless_status").style.display =  "block";
													/*get wlan channel num*/
													wlan_channel_num = dataInstance.getElementData("wirless_channel");
													if (wlan_channel_num == null) {
														break;
													}
													document.getElementById("wlan_channel").innerHTML = wlan_channel_num;
													
													//wlan_client_state = dataInstance.getElementData("wirless_client_state");
													//if (wlan_client_state == null) {
													//	break;
													//}
													//document.getElementById("wlan_clinet_state").innerHTML = wlan_client_state;
												}else {
													document.getElementById("wireless_radio").innerHTML = sw("txtOff");
													document.getElementById("wirless_status").style.display =  "none";
												}				
												
										//}
								
												
								}
				ItvID=window.setTimeout("connection_status_retriever.retrieveData()", 5000);
				check_wan_state_count++;
				Last_wan_connection_state = connection_state;
				return;
			} while (false);

			window.setTimeout("window.location.reload()", 5000);
		}
		function get_connection_state()
		{
			return connection_state;
		}

		function get_primary_connection_state()
		{
			return primary_connection_state;
		}

		function get_secondary_connection_state()
		{
			return secondary_connection_state;
		}
		function wan_action_buttons_selector()
		{
			
			if (wan_ip_mode == DHCP) {
				document.getElementById("wan_dhcp_button1").style.display = "inline";
				document.getElementById("wan_dhcp_button2").style.display = "inline";
				document.getElementById("bt_connect").style.display = "inline";
				document.getElementById("bt_disconnect").style.display = "inline";
				if("<% getIndexInfo("login_who"); %>" == "admin")
				{
					mf.wan_dhcp_button1.disabled = (get_connection_state() != 0);
					mf.wan_dhcp_button2.disabled = (get_connection_state() != 2);
					mf.bt_connect.disabled = (get_connection_state() != 0);
					mf.bt_disconnect.disabled = (get_connection_state() != 2);
					
				}
			} else if (wan_ip_mode == PPPOE || wan_ip_mode == RussiaPPPoE) {				
				document.getElementById("wan_pppoe_button1").style.display = "inline";
				document.getElementById("wan_pppoe_button2").style.display = "inline";
				document.getElementById("bt_connect").style.display = "inline";
				document.getElementById("bt_disconnect").style.display = "inline";
				if("<% getIndexInfo("login_who"); %>" == "admin")
				{
					mf.wan_pppoe_button1.disabled = (get_connection_state() != 0);
					mf.wan_pppoe_button2.disabled = (get_connection_state() != 2);
					mf.bt_connect.disabled = (get_connection_state() != 0);
					mf.bt_disconnect.disabled = (get_connection_state() != 2);
				}
			} else if (wan_ip_mode == PPTP || wan_ip_mode == RussiaPPTP) {				
				document.getElementById("wan_pptp_button1").style.display = "inline";
				document.getElementById("wan_pptp_button2").style.display = "inline";
				document.getElementById("bt_connect").style.display = "inline";
				document.getElementById("bt_disconnect").style.display = "inline";
				if("<% getIndexInfo("login_who"); %>" == "admin")
				{
					mf.wan_pptp_button1.disabled = (get_connection_state() != 0);
					mf.wan_pptp_button2.disabled = (get_connection_state() != 2);
					mf.bt_connect.disabled = (get_connection_state() != 0);
					mf.bt_disconnect.disabled = (get_connection_state() != 2);
				}
			} else if (wan_ip_mode == L2TP) {				
				document.getElementById("wan_l2tp_button1").style.display = "inline";
				document.getElementById("wan_l2tp_button2").style.display = "inline";
				document.getElementById("bt_connect").style.display = "inline";
				document.getElementById("bt_disconnect").style.display = "inline";
				if("<% getIndexInfo("login_who"); %>" == "admin")
				{
					mf.wan_l2tp_button1.disabled = (get_connection_state() != 0);
					mf.wan_l2tp_button2.disabled = (get_connection_state() != 2);
					mf.bt_connect.disabled = (get_connection_state() != 0);
					mf.bt_disconnect.disabled = (get_connection_state() != 2);
				}
			} else if (wan_ip_mode == BIGPOND) {				
				document.getElementById("wan_bigpond_button1").style.display = "inline";
				document.getElementById("wan_bigpond_button2").style.display = "inline";
				document.getElementById("bt_connect").style.display = "inline";
				document.getElementById("bt_disconnect").style.display = "inline";
				if("<% getIndexInfo("login_who"); %>" == "admin")
				{
					mf.wan_bigpond_button1.disabled = (get_connection_state() != 0);
					mf.wan_bigpond_button2.disabled = (get_connection_state() != 2);
					mf.bt_connect.disabled = (get_connection_state() != 0);
					mf.bt_disconnect.disabled = (get_connection_state() != 2);
				}

			} else if (wan_ip_mode == MultiPPPoE) {
				document.getElementById("wan_mpppoe_primary_button1").style.display = "inline";
				document.getElementById("wan_mpppoe_primary_button2").style.display = "inline";
				document.getElementById("wan_mpppoe_secondary_button1").style.display = "inline";
				document.getElementById("wan_mpppoe_secondary_button2").style.display = "inline";
				document.getElementById("bt_connect").style.display = "inline";
				document.getElementById("bt_disconnect").style.display = "inline";
				if("<% getIndexInfo("login_who"); %>" == "admin")
				{
					mf.wan_mpppoe_primary_button1.disabled = (get_primary_connection_state() != 0);
					mf.wan_mpppoe_primary_button2.disabled = (get_primary_connection_state() != 2);
					mf.wan_mpppoe_secondary_button1.disabled = (get_secondary_connection_state() != 0);
					mf.wan_mpppoe_secondary_button2.disabled = (get_secondary_connection_state() != 2);
					mf.bt_connect.disabled = (get_connection_state() != 0);
					mf.bt_disconnect.disabled = (get_connection_state() != 2);
				}

			}
		}

		function connection_status_timeout(xmlDataInstance)
		{		

			if (wan_ip_mode == MultiPPPoE)
			{
				if ((get_primary_connection_state() == 0) || (get_primary_connection_state() == 1)) {
					window.setTimeout("connection_status_retriever.retrieveData()", 2000);
					return;
				}	
				if ((get_secondary_connection_state() == 0) || (get_secondary_connection_state() == 1)) {
					window.setTimeout("connection_status_retriever.retrieveData()", 2000);
					return;
				}			
			}
			else
			{ 
				if ((get_connection_state() == 0) || (get_connection_state() == 1)) {
					window.setTimeout("connection_status_retriever.retrieveData()", 2000);
					return;
				}
			}
			window.setTimeout("connection_status_retriever.retrieveData()", 20000);
		}

		function wan_action_status_ready(dataInstance)
		{
			var wan_action_status = dataInstance.getElementData("status");
			if (wan_action_status == "Done") {
				wan_action_buttons_selector();
				return;
			}  

		}
		function wan_action_status_timeout(xmlDataInstance)
		{		
			window.setTimeout("wan_action_status_retriever.retrieveData()", 20000);
		}

		function wan_button_action (cgi_name)
		{

			if(cgi_name == "http://<% getInfo("ip-rom"); %>/sec_pppoe.cgi?connect=true")
			{
				if(get_primary_connection_state() != 2)
				{
					alert("Please connect primary session first.");
					return;
				}
			}

			wan_action_status_retriever.dataURL = cgi_name;
			wan_action_status_retriever.retrieveData();
			check_wan_state_count=0;
			start_check_wan_state=1;
			if(ItvID !=0 ){ 
				clearInterval(ItvID);
				ItvID=window.setTimeout("connection_status_retriever.retrieveData()", 1500);
			}
			button_disabled();
		}

		var dataIsReady = false;
		var xsltIsReady = false;
		var xmlData; // This will be an XMLDocument

		function xsltReady(xmlDoc)
		{
			xsltIsReady = true;
			refreshTable();
		}

		function dataReady(xmlDoc)
		{
			xmlData = xmlDoc.getDocument();
			dataIsReady = true;
			refreshTable();
		}

		function refreshTable()
		{
			if (!(dataIsReady && xsltIsReady)) {
				return;
			}

			var parent = document.getElementById("lan_computers_container");
			while (parent.childNodes[0]) {
				parent.removeChild(parent.childNodes[0]);
			}
			dataIsReady = false;

			xsltProcessor.transform(xmlData, window.document, parent);
			window.setTimeout("xmlDataFetcher.retrieveData()", 10000);
		}

		var igmpDataIsReady = false;
		var igmpXsltIsReady = false;
		var igmpXmlData;

		function igmpXsltReady(xmlDoc)
		{
			igmpXsltIsReady = true;
			igmpRefreshTable();
		}

		function igmpDataReady(xmlDoc)
		{
			igmpXmlData = xmlDoc.getDocument();
			igmpDataIsReady = true;
			igmpRefreshTable();
		}

		function igmpRefreshTable()
		{
			if (!(igmpDataIsReady && igmpXsltIsReady)) {
				return;
			}

			var parent = document.getElementById("igmp_membership_container");
			while (parent.childNodes[0]) {
				parent.removeChild(parent.childNodes[0]);
			}
			dataIsReady = false;

			igmpXsltProcessor.transform(igmpXmlData, window.document, parent);
			window.setTimeout("igmpDataFetcher.retrieveData()", 10000);
		}

		function xsltProcessorTimeout(xmlDataInstance)
		{		
			if (wan_ip_mode == MultiPPPoE)
			{			
				if ((get_primary_connection_state() == 0) || (get_primary_connection_state() == 1)) {
					window.setTimeout("xsltProcessor.retrieveData()", 2000);
					return;
				}
				if ((get_secondary_connection_state() == 0) || (get_secondary_connection_state() == 1)) {
					window.setTimeout("xsltProcessor.retrieveData()", 2000);
					return;
				}
			}
			else
			{
				if ((get_connection_state() == 0) || (get_connection_state() == 1)) {
					window.setTimeout("xsltProcessor.retrieveData()", 2000);
					return;
				}			
			}
			window.setTimeout("xsltProcessor.retrieveData()", 20000);
		}

		function xmlDataFetcherTimeout(xmlDataInstance)
		{		
			if (wan_ip_mode == MultiPPPoE)
			{
				if ((get_primary_connection_state() == 0) || (get_primary_connection_state() == 1)) {
					window.setTimeout("xmlDataFetcher.retrieveData()", 2000);
					return;
				}
				if ((get_secondary_connection_state() == 0) || (get_secondary_connection_state() == 1)) {
					window.setTimeout("xmlDataFetcher.retrieveData()", 2000);
					return;
				}
			}
			else
			{

			if ((get_connection_state() == 0) || (get_connection_state() == 1)) {
				window.setTimeout("xmlDataFetcher.retrieveData()", 2000);
				return;

				}

			}
			window.setTimeout("xmlDataFetcher.retrieveData()", 20000);
		}

		function igmpXsltProcessorTimeout(xmlDataInstance)
		{		
			if (wan_ip_mode == MultiPPPoE)
			{
				if ((get_primary_connection_state() == 0) || (get_primary_connection_state() == 1)) {
					window.setTimeout("igmpXsltProcessor.retrieveData()", 2000);
					return;
				}	
				if ((get_secondary_connection_state() == 0) || (get_secondary_connection_state() == 1)) {
					window.setTimeout("igmpXsltProcessor.retrieveData()", 2000);
					return;
				}			
			}
			else
			{
			if ((get_connection_state() == 0) || (get_connection_state() == 1)) {
				window.setTimeout("igmpXsltProcessor.retrieveData()", 2000);
				return;
				}
			}
			window.setTimeout("igmpXsltProcessor.retrieveData()", 20000);
		}

		function igmpDataFetcherTimeout(xmlDataInstance)
		{	
			if (wan_ip_mode == MultiPPPoE)
			{
				if ((get_primary_connection_state() == 0) || (get_primary_connection_state() == 1)) {
					window.setTimeout("igmpDataFetcher.retrieveData()", 2000);
					return;
				}
				if ((get_secondary_connection_state() == 0) || (get_secondary_connection_state() == 1)) {
					window.setTimeout("igmpDataFetcher.retrieveData()", 2000);
					return;
				}
			}else{

			if ((get_connection_state() == 0) || (get_connection_state() == 1)) {
				window.setTimeout("igmpDataFetcher.retrieveData()", 2000);
				return;

				}			
			}
			window.setTimeout("igmpDataFetcher.retrieveData()", 20000);
		}
	
		function page_load()
		{
			mf = document.forms["mainform"];
			var wan_dns1_value="<%getInfo("wan_primary_dns");%>";
			var wan_dns2_value="<%getInfo("wan_secondary_dns");%>";
			if(local_debug) {
				hide_all_ssi_tr();
				document.getElementById("firmware_version").innerHTML="1.9,  2006/04/15";
//				nat_enabled_selector();
				document.getElementById("current_time").innerHTML="Saturday, April 15, 2006 2:25:33 PM";
//				document.getElementById("system_uptime").innerHTML="0 Day 8 Hour 1 Min 15 Sec";
				document.getElementById("wan_ip_mode").innerHTML="DHCP";
				document.getElementById("wan_ip_address").innerHTML="192.168.1.100";
				document.getElementById("wan_subnet").innerHTML="255.255.255.0";
				document.getElementById("wan_gateway").innerHTML="192.168.1.1";
				document.getElementById("wan_primary_dns").innerHTML="0.0.0.0";
				document.getElementById("wan_mac_addr").innerHTML="00:00:00:00:00:00";
				wan_ip_mode = DHCP;
				connection_state = 0;
				secondary_connection_state = 0;
				wan_action_buttons_selector();
				return;
			} 
			document.getElementById("wan_ip_mode").innerHTML="DHCP";
			document.getElementById("connstate").value="DHCP"+' '+sw("txtDisconnected");
			if("<% getInfo("wantrafficshapping");%>" == "true")
			{
				document.getElementById("wan_qos_engine").innerHTML=sw("txtActive");
			}
			else
			{
				document.getElementById("wan_qos_engine").innerHTML=sw("txtInactive");
			}
			document.getElementById("wan_ip_address").innerHTML="<% getInfo("wan-ip");%>";
			document.getElementById("wan_subnet").innerHTML="<% getInfo("wan-mask");%>";
			document.getElementById("wan_gateway").innerHTML="<% getInfo("wan-gateway");%>";
			document.getElementById("wan_primary_dns").innerHTML="<%getInfo("wan_primary_dns");%>";
			document.getElementById("wan_secondary_dns").innerHTML="<%getInfo("wan_secondary_dns");%>";
			
			if("<% getIndexInfo("wan_phylink");%>" == "0"){
				document.getElementById("wan_physical_state").innerHTML=sw("txtDisconnect");
			}else{
				document.getElementById("wan_physical_state").innerHTML=sw("txtConnected");
			}
			
			document.getElementById("display_wanipaddr").innerHTML="<% getInfo("wan-ip");%>";
			document.getElementById("display_wansubnet").innerHTML="<% getInfo("wan-mask");%>";
			document.getElementById("display_wangateway").innerHTML="<% getInfo("wan-gateway");%>";
			if(wan_dns2_value !='0.0.0.0')
				wan_dns1_value = wan_dns1_value+'<br>'+wan_dns2_value;
			document.getElementById("display_wandns").innerHTML=wan_dns1_value;
			
			get_current_time();
			system_uptime_secs = "3072" * 1;
			update_clock();
			lan_mac_addr_selector();
			wireless_selector();
			
			document.getElementById("fw_minor_current").innerHTML = global_fw_minor_version;

			var is_router_mode = OP_MODE == "0";

			document.getElementById("bridge_mode_only_lan_settings").style.display = is_router_mode ? "none" : "block";
			document.getElementById("router_mode_only_lan_settings").style.display = is_router_mode ? "block" : "none";

			
			if (!is_router_mode) {
				document.getElementById("wan_box").style.display = "none";
				document.getElementById("display_wan_box").style.display = "none";
				
				document.getElementById("lan_computers_box").style.display = "none";
				document.getElementById("multicast_memberships_div").style.display = "none";
				//return; //Brad modify we allow polling when bridge mode.
			}
			if( lang =="0"){
			xsltProcessor = new xsltProcessingObject(xsltReady, xsltProcessorTimeout, 6000, "lan_computers_table.sxsl");
		}else{
			xsltProcessor = new xsltProcessingObject(xsltReady, xsltProcessorTimeout, 6000, "lan_computers_table_pack.sxsl");
		}
			xmlDataFetcher = new xmlDataObject(dataReady, xmlDataFetcherTimeout, 6000, "../dhcp_clients.asp");

			xsltProcessor.retrieveData();
			xmlDataFetcher.retrieveData();

			var igmp_proxy_enabled = "<%getIndexInfo("igmpProxyEnabled");%>" * 1;
			if (igmp_proxy_enabled == 0) {
				document.getElementById("multicast_memberships_div").style.display = "none";
			} else {
				if( lang =="0"){
				igmpXsltProcessor = new xsltProcessingObject(igmpXsltReady, igmpXsltProcessorTimeout, 6000, "igmp_group_memberships.sxsl");
			}else{
				igmpXsltProcessor = new xsltProcessingObject(igmpXsltReady, igmpXsltProcessorTimeout, 6000, "igmp_group_memberships_pack.sxsl");
			}
				igmpDataFetcher = new xmlDataObject(igmpDataReady, igmpDataFetcherTimeout, 6000, "cgi_ssi_igmp_group_memberships.asp");

				igmpXsltProcessor.retrieveData();
				igmpDataFetcher.retrieveData();
			}

			wan_ip_mode_selector();
			wan_mac_addr_selector();

			
			connection_status_retriever = new xmlDataObject(connection_status_ready, connection_status_timeout, 10000, "wan_connection_status.asp");
			if ( connection_status_retriever == null ) {
				return;
			}
			connection_status_retriever.retrieveData();
			wan_action_buttons_selector();

			wan_action_status_retriever = new xmlDataObject(wan_action_status_ready, wan_action_status_timeout, 10000, "wan_button_action.asp");
		}
		function buttoninit()
		{
		var DOC_Title= sw("txtTitle")+" : "+sw("txtStatus")+'/'+sw("txtDeviceInfo");
		document.title = DOC_Title;	
			get_by_id("wan_dhcp_button1").value = sw("txtRenew");
			get_by_id("wan_dhcp_button1").disabled = true;
			get_by_id("wan_dhcp_button2").value = sw("txtRelease");
			get_by_id("wan_dhcp_button2").disabled = true;
			get_by_id("wan_pppoe_button1").value = sw("txtConnect");
			get_by_id("wan_pppoe_button1").disabled = true;
			get_by_id("wan_pppoe_button2").value = sw("txtDisconnect");
			get_by_id("wan_pppoe_button2").disabled = true;
			get_by_id("wan_pptp_button1").value = sw("txtConnect");
			get_by_id("wan_pptp_button1").disabled = true;
			get_by_id("wan_pptp_button2").value = sw("txtDisconnect");
			get_by_id("wan_pptp_button2").disabled = true;
			get_by_id("wan_l2tp_button1").value = sw("txtConnect");
			get_by_id("wan_l2tp_button1").disabled = true;
			get_by_id("wan_l2tp_button2").value = sw("txtDisconnect");
			get_by_id("wan_l2tp_button2").disabled = true;
			get_by_id("wan_bigpond_button1").value = sw("txtLogin");
			get_by_id("wan_bigpond_button1").disabled = true;
			get_by_id("wan_bigpond_button2").value = sw("txtLogout");
			get_by_id("wan_bigpond_button2").disabled = true;
			get_by_id("wan_mpppoe_primary_button1").value = sw("txtConnect");
			get_by_id("wan_mpppoe_primary_button1").disabled = true;
			get_by_id("wan_mpppoe_primary_button2").value = sw("txtDisconnect");
			get_by_id("wan_mpppoe_primary_button2").disabled = true;
			get_by_id("wan_mpppoe_secondary_button1").value = sw("txtConnect");
			get_by_id("wan_mpppoe_secondary_button1").disabled = true;
			get_by_id("wan_mpppoe_secondary_button2").value = sw("txtDisconnect");
			get_by_id("wan_mpppoe_secondary_button2").disabled = true;
			
		}
	//]]>
	</script>
	<!-- InstanceEndEditable -->
</head>
<body onload="template_load();buttoninit();web_timeout();">
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
</SCRIPT></div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td>					
<td id="maincontent_container"><SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" >	<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div><!-- box warnings_section_content --></div></div>	</div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<!-- InstanceBeginEditable name="Main Content" -->
<!--@OPTIONAL:this_file ~= 'Tools_Firmware.html' and this_file ~= 'Tools_System.html'@-->
<form id="mainform" name="mainform" action="/goform/formSetWanStatus" method="post" enctype="application/x-www-form-urlencoded">
<!--@ENDOPTIONAL@-->
<!--@UNIQUE:maincontent@-->
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtDeviceInfoFull");</SCRIPT></h2>
<p><SCRIPT >ddw("txtAlldisplayedhere");</SCRIPT></p><br>
<fieldset><p><label class="duple_Dev_info"><strong><SCRIPT>ddw("txtFirmwareVersion");</SCRIPT>&nbsp;:</strong></label>
<strong id="firmware_version" class="output"><span id="fw_minor_current"></span>,&nbsp;&nbsp;<%getInfo("fwBuiltDate")%></strong>
</p></fieldset>
</div><div class="box"style="display:none">
<h3><SCRIPT >ddw("txtGeneral");</SCRIPT></h3>
<p class="box_msg">	</p><fieldset><p><label class="duple_Dev_info">
<SCRIPT >ddw("txtTime");</SCRIPT>&nbsp;:</label>
<span id="current_time" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtFirmwareVersion");</SCRIPT>&nbsp;:</label>
<strong id="firmware_version" class="output"><span id="fw_minor_current"></span>,&nbsp;&nbsp;<%getInfo("fwBuiltDate")%></strong>
</p></fieldset></div>

<div class="box"><h3>LAN</h3>
<fieldset><p><label class="duple_Dev_info"><SCRIPT >ddw("txtMACAddress");</SCRIPT>&nbsp;:</label>
<span id="lan_mac_addr" class="output"><% getInfo("lanMacAddr"); %>&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtIPAddress");</SCRIPT>&nbsp;:</label>
<span id="lan_ip_address" class="output"><% getInfo("ip"); %></span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtSubnetMask2");</SCRIPT>&nbsp;:</label>
<span id="lan_subnet" class="output"><% getInfo("mask"); %></span></p>
<div id="bridge_mode_only_lan_settings"><p><label class="duple_Dev_info">
<SCRIPT >ddw("txtDefaultGateway2");</SCRIPT>&nbsp;:</label>
<span id="lan_gateway" class="output"><% getInfo("gateway-rom");%></span></p>	<p>
<label class="duple_Dev_info"><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>&nbsp;:</label>
<span id="lan_primary_dns" class="output"><% getInfo("wan-dns1");%></span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>&nbsp;:</label>
<span id="lan_secondary_dns" class="output"><% getInfo("wan-dns2");%></span></p></div>
<div id="router_mode_only_lan_settings"><p><label class="duple_Dev_info">
<SCRIPT >ddw("txtDHCPServer");</SCRIPT>&nbsp;:</label>
<span id="info_dhcp_server_status" class="output"><% getInfo("dhcp_server");%>&nbsp;</span></p></div></fieldset></div>

<div class="box"  id="display_wan_box">
<h3>Internet</h3>
<table cellpadding="1" cellspacing="1" border="0" width="525">
<tr>
<td class="r_tb" width="258"><SCRIPT>ddw("txtMACAddress");</SCRIPT>&nbsp;:</td>
<td class="l_tb" width="267"><div id="display_wanmacaddr">&nbsp;</div></td>
</tr>
<tr>
<td class="r_tb"><SCRIPT>ddw("txtConnection");</SCRIPT>&nbsp;:</td>
<td class="l_tb">
<input class="l_tb" type="text" size=40 readOnly id="connstate" value="" style="BORDER-TOP-WIDTH: 0px; BORDER-LEFT-WIDTH: 0px; BORDER-BOTTOM-WIDTH: 0px; BORDER-RIGHT-WIDTH: 0px" >
<%getInfo("wan_Type_check")%>
<input type=button onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?connect=true');" name=bt_connect id=bt_connect value="">&nbsp;
<input type=button onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?connect=false');" name=bt_disconnect id=bt_disconnect value="">
</td></tr>
<tr>
<td class="r_tb"><SCRIPT >ddw("txtIPAddress");</SCRIPT>&nbsp;:</td>
<td class="l_tb"><div id="display_wanipaddr">&nbsp;</div></td>
</tr>
<tr>
<td class="r_tb"><SCRIPT >ddw("txtSubnetMask2");</SCRIPT>&nbsp;:</td>
<td class="l_tb"><div id="display_wansubnet">&nbsp;</div></td>
</tr>
<tr>
<td class="r_tb"><SCRIPT >ddw("txtDefaultGateway2");</SCRIPT>&nbsp;:</td>
<td class="l_tb"><div id="display_wangateway">&nbsp;</div></td>
</tr>
<tr>
<td class="r_tb"><SCRIPT >ddw("txtDNS");</SCRIPT>&nbsp;:</td>
<td class="l_tb"><div id="display_wandns">&nbsp;</div></td>
</tr>
</table>
</div>

<div class="box" id="wan_box" style="display:none"><h3><SCRIPT >ddw("txtInternet");</SCRIPT></h3>
<fieldset>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtConnectionType");</SCRIPT>&nbsp;:</label><span id="wan_ip_mode" class="output">&nbsp;</span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtQoSEngine");</SCRIPT>:</label><span id="wan_qos_engine" class="output"><SCRIPT >ddw("txtActive");</SCRIPT></span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtCableStatus");</SCRIPT>&nbsp;:</label><span id="wan_physical_state" class="output">&nbsp;</span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtNetworkStatus");</SCRIPT>&nbsp;:</label><span id="wan_network_status" class="output">&nbsp;</span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtConnectionUpTime");</SCRIPT>&nbsp;:	</label><span id="wan_interface_up_time_str" class="output">&nbsp;</span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtMACAddress");</SCRIPT>&nbsp;:</label><span id="wan_mac_addr" class="output">&nbsp;</span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtConnectionType");</SCRIPT>&nbsp;:</label>
<input id="wan_dhcp_button1" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?renew=true');" style="display:none" />
<input id="wan_dhcp_button2" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?renew=false');" style="display:none" />
<input id="wan_pppoe_button1" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?connect=true');" style="display:none" />
<input id="wan_pppoe_button2" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?connect=false');" style="display:none" />
<input id="wan_pptp_button1" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?connect=true');" style="display:none" />
<input id="wan_pptp_button2" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?connect=false');" style="display:none" />
<input id="wan_l2tp_button1" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?connect=true');" style="display:none" />
<input id="wan_l2tp_button2" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?connect=false');" style="display:none" />
<input id="wan_bigpond_button1" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?login=true');" style="display:none" />
<input id="wan_bigpond_button2" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/Status/wan_button_action.asp?login=false');" style="display:none" />
</p>
<div id="box_authsecmodel_status" style="display:none">
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtAuthentication");</SCRIPT>&amp;<SCRIPT >ddw("txtSecurity");</SCRIPT>&nbsp;:</label><span id="wan_auth_sec_model" class="output">&nbsp;</span></p>
</div>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtIPAddress");</SCRIPT>&nbsp;:</label><span id="wan_ip_address" class="output">&nbsp;</span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtSubnetMask2");</SCRIPT>&nbsp;:</label><span id="wan_subnet" class="output">&nbsp;</span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtDefaultGateway2");</SCRIPT>&nbsp;:</label>
<span id="wan_gateway" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>&nbsp;:</label><span id="wan_primary_dns" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>&nbsp;:</label><span id="wan_secondary_dns" class="output">&nbsp;</span></p>
<div id="box_bigpond_status" style="display:none"><p><label class="duple_Dev_info"><SCRIPT >ddw("txtBigPondServerName");</SCRIPT>&nbsp;:</label><span id="bigpond_server" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtBigPondStatus");</SCRIPT>&nbsp;:</label><span id="bigpond_currstatus" class="output">&nbsp;</span></p></div></fieldset></div>
<div class="box" id="wan_mpppoe_primary_button" style="display:none">
<h3>WAN</h3><p class="box_msg"></p><fieldset>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtConnectionType");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_primary" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtCableStatus");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_primary_physical_state" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info">	<SCRIPT >ddw("txtNetworkStatus");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_primary_network_status" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtConnectionUpTime");</SCRIPT>&nbsp;:</label><span id="wan_primary_interface_up_time_str" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info">&nbsp;</label><input id="wan_mpppoe_primary_button1" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/wan_pppoe.cgi?connect=true');" style="display:none" />
<input id="wan_mpppoe_primary_button2" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/wan_pppoe.cgi?connect=false');" style="display:none" /></p>

<div id="mpppoe_primary_box_authsecmodel_status" style="display:none">
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtAuthentication");</SCRIPT>&amp;<SCRIPT >ddw("txtSecurity");</SCRIPT>&nbsp;:</label>
<span id="wan_mpppoe_primary_auth_sec_model" class="output">&nbsp;</span></p></div>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtIPAddress");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_primary_ip_address" class="output">&nbsp;</span></p>
<p>	<label class="duple_Dev_info"><SCRIPT >ddw("txtSubnetMask2");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_primary_subnet" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtDefaultGateway2");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_primary_gateway" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_primary_primary_dns" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_primary_secondary_dns" class="output">&nbsp;</span></p>
</fieldset></div>

<div class="box" id="wan_mpppoe_secondary_button" style="display:none">
<h3>WAN</h3><p class="box_msg"></p>
<fieldset><p>
<label class="duple_Dev_info"><SCRIPT >ddw("txtConnectionType");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_secondary" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtCableStatus");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_secondary_physical_state" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtNetworkStatus");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_secondary_network_status" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtConnectionUpTime");</SCRIPT>&nbsp;:</label><span id="wan_secondary_interface_up_time_str" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info">&nbsp;</label>
<input id="wan_mpppoe_secondary_button1" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/sec_pppoe.cgi?connect=true');" style="display:none" />
<input id="wan_mpppoe_secondary_button2" type="button" value="" onclick="wan_button_action('http://<% getInfo("goformIpAddr"); %>/sec_pppoe.cgi?connect=false');" style="display:none" />
</p>
<div id="mpppoe_secondary_box_authsecmodel_status" style="display:none">
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtAuthentication");</SCRIPT>&amp;<SCRIPT >ddw("txtSecurity");</SCRIPT>&nbsp;:</label>
<span id="wan_mpppoe_secondary_auth_sec_model" class="output">&nbsp;</span></p></div>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtIPAddress");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_secondary_ip_address" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtSubnetMask2");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_secondary_subnet" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtDefaultGateway2");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_secondary_gateway" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>&nbsp;:	</label><span id="wan_mpppoe_secondary_primary_dns" class="output">&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>&nbsp;:</label><span id="wan_mpppoe_secondary_secondary_dns" class="output">&nbsp;</span></p></fieldset>
</div>
<!--@ENDOPTIONAL@-->


<div class="box"><h3><SCRIPT >ddw("txtWirelessLAN");</SCRIPT></h3>
<fieldset><p style="display:none">
<label class="duple_Dev_info"><SCRIPT >ddw("txtWirelessRadio");</SCRIPT>&nbsp;:</label>
<span class="output" id="wireless_radio"><%getIndexInfo("wlanDisabled");%>&nbsp;</span></p>
<div id="wirless_status">
<!--<p><label class="duple_Dev_info"><SCRIPT >ddw("txtWISH");</SCRIPT> : </label>
<span id="wlan_qos_engine" class="output"><SCRIPT >ddw("txtActive");</SCRIPT></span></p>
-->
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtWirelessMode");</SCRIPT>&nbsp;:</label><span class="output" id="wlan_mode"></span></p>
<p style="display:none"><label class="duple_Dev_info"><SCRIPT >ddw("txtMACAddress");</SCRIPT>&nbsp;:</label>
<span class="output" id="wlan_mac_addr"></span></p><p><label class="duple_Dev_info">SSID&nbsp;:</label>
<span class="output" id="ssid"></span>	</p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtChannel");</SCRIPT>&nbsp;:</label>
<span class="output" id="wlan_channel"><% getInfo("channel_drv");%>&nbsp;</span></p>
<p><label class="duple_Dev_info"><SCRIPT >ddw("txtEncryption");</SCRIPT>&nbsp;:</label>
<span class="output" id="security_type">&nbsp;</span></p><p style="display:none">
<label class="duple_Dev_info"><SCRIPT >ddw("txtWiFiProtectedSetup");</SCRIPT>&nbsp;:</label>
<span class="output" id="wifisc_configured">&nbsp;</span></p>
<!--	
	<p><label class="duple_Dev_info"><SCRIPT >ddw("txtState");</SCRIPT>&nbsp;:</label><span class="output" id="wlan_clinet_state"></span></p>
-->	
</div></fieldset></div><div class="box" id="lan_computers_box" style="display:none">
<h3><SCRIPT >ddw("txtLANComputers");</SCRIPT></h3>
<p class="box_msg"></p>
<div id="lan_computers_container"></div></div>
<!--@OPTIONAL:not the_lpj_output.APP_TYPE_ACCESS_POINT@--><div class="box" id="multicast_memberships_div" style="display:none">
<h3><SCRIPT >ddw("txtIGMPMulticastmember");</SCRIPT></h3>
<p class="box_msg"/><div id="igmp_membership_container"></div></div></div><!--@ENDOPTIONAL@-->
</form><!--@ENDOPTIONAL@--><!-- InstanceEndEditable --></div></td><td id="sidehelp_container">
<div id="help_text"><!-- InstanceBeginEditable name="Help_Text" --> <strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtAllWANLANdisplayed");</SCRIPT></p>
<p class="more"><!-- Link to more help --><a href="../Help/Status.asp#Device_Info" onclick="return jump_if();"><SCRIPT >ddw("txtMore");</SCRIPT>...</a></p>
<!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside --></body>
<!-- InstanceEnd -->
</html>
