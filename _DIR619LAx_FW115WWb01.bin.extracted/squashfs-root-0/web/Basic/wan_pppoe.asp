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
	mf["ppp_schedule_control_0"].value=value;
}
function clone_mac() {
	var copy_mac;
			mf.mac_cloning_address.value = pcmac;
			mf.mac_cloning_enabled.value = "true";
			copy_mac=mf.mac_cloning_address.value; 
	mf.mac1.value=copy_mac.substring(0,2);
	mf.mac2.value=copy_mac.substring(3,5);
	mf.mac3.value=copy_mac.substring(6,8);
	mf.mac4.value=copy_mac.substring(9,11);
	mf.mac5.value=copy_mac.substring(12,14);
	mf.mac6.value=copy_mac.substring(15,17);
}
		function update_wan_ip_mode_list()
		{
			mf.wan_ip_mode_select.length = 0;
			mf.wan_ip_mode_select[0] = new Option(sw("txtStaticIP"), "0", false, false);
	    	mf.wan_ip_mode_select[1] = new Option(sw("txtDynamicIP"), "1", false, false);
			mf.wan_ip_mode_select[2] = new Option("PPPoE("+sw("txtUsernamePassword")+")", "2", false, false);
			mf.wan_ip_mode_select[3] = new Option("PPTP("+sw("txtUsernamePassword")+")", "3", false, false);
			mf.wan_ip_mode_select[4] = new Option("L2TP("+sw("txtUsernamePassword")+")", "4", false, false);
			//mf.wan_ip_mode_select[5] = new Option("BigPond+("+sw("txtAustralia")+")", "5", false, false);		
if(LangCode == "SC")
				mf.wan_ip_mode_select[5] = new Option("DHCP+("+sw("txtDynamicIP")+")", "9", false, false);

		}
		function get_webserver_ssi_uri() {
			return ("" !== "") ? "/Basic/Setup.asp" : "/Basic/WAN.asp";
		}

function update_xkjs_mode_list(value)
{
	mf.xkjs_mode_select.length = 0;
	mf.xkjs_mode_select[0] = new Option(sw("txtXkjs3"), "0", false, false);
	mf.xkjs_mode_select[1] = new Option(sw("txtXkjs4") + "1", "1", false, false);
	mf.xkjs_mode_select[2] = new Option(sw("txtXkjs4") + "2", "2", false, false);
	mf.xkjs_mode_select[3] = new Option(sw("txtXkjs4") + "3", "3", false, false);
	mf.xkjs_mode_select[4] = new Option(sw("txtXkjs4") + "4", "4", false, false);
	mf.xkjs_mode_select[5] = new Option(sw("txtXkjs4") + "5", "5", false, false);
	mf.xkjs_mode_select[6] = new Option(sw("txtXkjs4") + "6", "6", false, false);
	mf.xkjs_mode_select.value  = value;
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
Lang_Check();		
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
		var local_debug =false ;
		var verify_failed = "<%getInfo("err_msg")%>";
		var mf;

		var pcmac;
		var remote_login;
		var default_idle_time = parseInt("5",10);


		function wan_ip_mode_selector(mode)
		{
			var html_file="";
			mode = mode * 1;

			switch(mode)
			{	
				case STATIC:
					html_file = "wan_static.asp";
					break;

				case DHCP:
					html_file = "wan_dhcp.asp";
					break;

				case PPPOE:
					html_file = "wan_pppoe.asp";
					break;

				case PPTP:
					html_file = "wan_pptp.asp";
					break;

				case L2TP:
					html_file = "wan_l2tp.asp";
					break;

				case BIGPOND:
					html_file = "wan_bigpond.asp";
					break;
					
				case DHCPPLUS:
					html_file = "wan_dhcpplus.asp";		
					break;
		}
			reset_form("mainform");

			 
			if(mode != mf.wan_ip_mode.value) 
			{
				window.location.href=html_file+"?t="+new Date().getTime();
				mf.wan_mtu.value = mtu_default_values[mode];

			}
			

			//document.getElementById("box_wan_static").style.display = mode == STATIC ? "block" : "none";

		}
		
		function pppoe_netsniper_selector(value){
			//mf.pppoe_netsniper.value = value;
			if(value == "true")
				mf.pppoe_netsniper_select.checked = value;

			if(mf.pppoe_netsniper_select.checked) {
				mf.pppoe_xkjs_select.disabled = true;
				mf.pppoe_xkjs_select.checked = false;
			//	mf.pppoe_xkjs.value = false;
				mf.pppoeplus_select.disabled = true;
				mf.pppoe_netsniper_select.disabled = false;
			} else {
				mf.pppoe_xkjs_select.disabled = false;
				mf.pppoeplus_select.disabled = false;
			}
		}

		function pppoe_xkjs_selector(value){
			//mf.pppoe_xkjs.value = value;
			if(value == "true") 
				mf.pppoe_xkjs_select.checked = value;

			if(mf.pppoe_xkjs_select.checked) {
				mf.pppoe_netsniper_select.disabled = true;
				mf.pppoe_netsniper_select.checked = false;
			//	mf.pppoe_netsniper.value = false;

				mf.pppoeplus_select.disabled = true;
				mf.pppoe_xkjs_select.disabled = false;
			} else {
				mf.pppoe_netsniper_select.disabled = false;
				mf.pppoeplus_select.disabled = false;
			}
		}	

		function xkjs_mode_selector(value){
			mf.xkjs_mode.value = value;
		}
		function pppoeplus_selector(value){
			mf.pppoeplus_select.checked = value;
			if(value){
				mf.pppoe_xkjs_select.disabled = true;
				mf.pppoe_xkjs_select.checked = false;
			//	mf.pppoe_xkjs.value = false;

				mf.pppoe_netsniper_select.disabled = true;
				mf.pppoe_netsniper_select.checked = false;
				//mf.pppoe_netsniper.value = false;
				mf.pppoeplus_select.disabled = false;

				//xkjs_mode_selector(4);
			}else{
				mf.pppoe_xkjs_select.disabled = false;
				mf.pppoe_netsniper_select.disabled = false;
				//mf.pppoe_xkjs.value = false;
				//xkjs_mode_selector(0);
			}
		}

		function pppoe_use_dynamic_address_selector(mode){
			mf.pppoe_use_dynamic_address.value = mode;
			if(mode == "true") {
				mf.pppoe_use_dynamic_address_radio_1.checked = true;
				mf.pppoe_ip_address.disabled = true;
			} else {
				mf.pppoe_use_dynamic_address_radio_0.checked = true;
				mf.pppoe_ip_address.disabled = false;
			}
		}

		function pppoe_use_dynamic_dns_selector(mode){
		
			mf.pppoe_use_dynamic_dns.value = mode;
			if(mode == "true") {
				mf.pppoe_use_dynamic_dns_radio_1.checked = true;
				mf.wan_primary_dns.disabled = true;
				mf.wan_secondary_dns.disabled = true;
			} else {
				mf.pppoe_use_dynamic_dns_radio_0.checked = true;
				mf.wan_primary_dns.disabled = false;
				mf.wan_secondary_dns.disabled = false;
			}
			
		}
		
		function pppoe_reconnect_selector(mode)
		{
			mode = mode * 1;
			// 0 = Always on, 1 = On demand, 2 = Manual
			mf.pppoe_reconnect_mode.value = mode;
			mf.pppoe_max_idle_time.disabled = mode == 1 ? false : true;
	if(mode != 0){
		mf.wan_sch_select.disabled=true;
	}else{
		mf.wan_sch_select.disabled=false;
	}
			switch(mode)
			{
				case 0:
					mf.pppoe_reconnect_mode_radio_0.checked = true;
				break;
				case 1:
			mf.pppoe_reconnect_mode_radio_2.checked = true;
				break;
				case 2:
			mf.pppoe_reconnect_mode_radio_1.checked = true;
				break;
			}
		}


		function page_load() 
		{
			var oldmac;
			var dns_mode ="<%getIndexInfo("wanpoedns_mode");%>";
			displayOnloadPage("<%getInfo("ok_msg")%>");
			mf = document.forms["mainform"];

			remote_login = false;
			
			update_wan_ip_mode_list();
     
			update_xkjs_mode_list(mf.xkjs_mode.value);
 
			pcmac = "<% getInfo("host-hwaddr"); %>";
			remote_login = (pcmac == "00:00:00:00:00:00") ? true : false;
			oldmac=mf.mac_cloning_address.value; 
			mf.mac1.value=oldmac.substring(0,2);
			mf.mac2.value=oldmac.substring(3,5);
			mf.mac3.value=oldmac.substring(6,8);
			mf.mac4.value=oldmac.substring(9,11);
			mf.mac5.value=oldmac.substring(12,14);
			mf.mac6.value=oldmac.substring(15,17);
			if(dns_mode=="0"){
				pppoe_use_dynamic_dns_selector("true");
			}else{
				pppoe_use_dynamic_dns_selector("false");
			}

			mf.pppoe_netsniper_select.disabled = false;
			mf.pppoeplus_select.disabled = false;
			mf.pppoe_xkjs_select.disabled = false;
			if(mf.pppoe_netsniper.value == "true")	
				pppoe_netsniper_selector(mf.pppoe_netsniper.value);
			else if(mf.pppoe_xkjs.value == "true")
				pppoe_xkjs_selector(mf.pppoe_xkjs.value);
			else if(mf.pppoe_xkjs.value == "false" && mf.xkjs_mode.value == "4")
				pppoeplus_selector(1);
			else
				pppoeplus_selector(0);

			mf.wan_ip_mode.value = PPPOE;
			mf.wan_ip_mode_select.value = PPPOE;

			 

			pppoe_use_dynamic_address_selector(mf.pppoe_use_dynamic_address.value);

			pppoe_reconnect_selector(mf.pppoe_reconnect_mode.value);
			
			mf["dsl_mode"].value = 2;
			schedule_populate_select(mf["wan_sch_select"]);
			mf.wan_sch_select.value = mf.ppp_schedule_control_0.value;
			set_form_default_values("mainform");


			if (verify_failed != "") {
				set_form_always_modified("mainform");
				alert(verify_failed);
			}
			
			
		}

		//function clone_mac() {
		//	mf.mac_cloning_address.value = pcmac;
		//	mf.mac_cloning_enabled.value = "true";
		//}


		function page_submit(mode)
		{
			mf.curTime.value = new Date().getTime();	
			var mac_addr;
			if (!is_form_modified("mainform"))
			{
				if(!confirm(sw("txtSaveAnyway"))) 
					return false;
			}
			else
			{
				mode = mode * 1;

				if(is_blank(mf.pppoe_username.value)){
					alert(sw("txtUserNameBlank"));
					mf.pppoe_username.focus();
					return false;
				}

				if(strchk_unicode(mf.pppoe_service_name.value) && !is_blank(mf.pppoe_service_name.value))
				{
					alert(sw("txtServiceName")+sw("txtisInvalid"));
					mf.pppoe_service_name.focus();
					return false;
				}

				if(strchk_unicode(mf.pppoe_username.value) == true)
				{
					alert(sw("txtUserName")+sw("txtisInvalid"));
					mf.pppoe_username.focus();
					return false;
				}
					
				if (mf.pppoe_password.value != mf.confirm_pppoe_password.value) {
					alert(sw("txtThePasswordsDontMatch"));
					try	{
						mf.pppoe_password.select();
						mf.confirm_pppoe_password.select();
						mf.pppoe_password.focus();
					} catch (e) {
					}
					return;
				}


                               var ppp_ser_len = utf8len(mf.pppoe_service_name.value);
                                if(ppp_ser_len > 63)
                                {
                                        alert(sw("txtpppseverlen"));
                                        mf.pppoe_service_name.focus();
                                        return false;
                                }

				var lan_ip_str = "<% getInfo("ip-rom"); %>";
				var lan_mask_str = "<% getInfo("mask-rom"); %>";
				if(mf.pppoe_use_dynamic_address.value == "false" ) {
					if (!is_ipv4_valid(mf.pppoe_ip_address.value) || mf.pppoe_ip_address.value=="0.0.0.0" || is_FF_IP(mf.pppoe_ip_address.value)) {
						alert(sw("txtInvalidPPPoEIPaddress") + mf.pppoe_ip_address.value);
							mf.wan_pptp_ip_address.select();
							mf.wan_pptp_ip_address.focus();
						
						return;
					}

					var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
					var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
					var wan_ip = ipv4_to_unsigned_integer(mf.pppoe_ip_address.value);
					if ((LAN_IP & LAN_MASK) == (wan_ip & LAN_MASK))
					{
						alert(sw("txtWanSubConflitLanSub"));
						return false;
					}
				}
				if (!is_number(mf.pppoe_max_idle_time.value) || (mf.pppoe_max_idle_time.value>600 || mf.pppoe_max_idle_time.value<0)) {
					alert(sw("txtInvalidIdleTime")+"("+sw("txtPermittedRange")+sw("txtIdleRng0to600")+")");
					try	{
						mf.pppoe_max_idle_time.select();
						mf.pppoe_max_idle_time.focus();
					} catch (e) {
					}
					return;
				}
	
				mf.wan_primary_dns.value = trim_string(mf.wan_primary_dns.value);
				mf.wan_secondary_dns.value = trim_string(mf.wan_secondary_dns.value);
	
				mf.wan_primary_dns.value = mf.wan_primary_dns.value == "" ? "0.0.0.0" : mf.wan_primary_dns.value;
				mf.wan_secondary_dns.value = mf.wan_secondary_dns.value == "" ? "0.0.0.0" : mf.wan_secondary_dns.value;
				if(mf.wan_primary_dns.disabled == false){
					if(!is_valid_ip(mf.wan_primary_dns.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,mf.wan_primary_dns.value)){
						alert(sw("txtInvalidPPPoEPrimaryDNS") +  mf.wan_primary_dns.value);
						try {
							mf.wan_primary_dns.select();
							mf.wan_primary_dns.focus();
						} catch (e) {
						}
						return;
					} 
				}
				if(mf.wan_secondary_dns.disabled == false){
					if(mf.wan_secondary_dns.value != "0.0.0.0" && (!(is_valid_ip(mf.wan_secondary_dns.value) && is_valid_gateway(lan_ip_str,lan_mask_str,mf.wan_secondary_dns.value)))){
						alert(sw("txtInvalidPPPoESecondaryDNS") +  mf.wan_secondary_dns.value);
						try {
							mf.wan_secondary_dns.select();
							mf.wan_secondary_dns.focus();
						} catch (e) {
						}
						return;
					}
				}
				if((mf.wan_primary_dns.value != "0.0.0.0") && mf.wan_primary_dns.value == mf.wan_secondary_dns.value)
				{
        				alert(sw("txtSameDNS"));
        				mf.wan_secondary_dns.select();
        				mf.wan_secondary_dns.focus();
        				return 0;
				}
				if ((mf.wan_primary_dns.value != "0.0.0.0") || (mf.wan_secondary_dns.value != "0.0.0.0")) {
					mf.wan_force_static_dns_servers.value = "true";
				} else {
					mf.wan_force_static_dns_servers.value = "false";
				}
				if (!is_number(mf.wan_mtu.value)) {
					alert(sw("txtInvalidMTUSize"));
					try {
						mf.wan_mtu.select();
						mf.wan_mtu.focus();
					} catch (e) {
					}
					return;
				}
				if(mf.wan_mtu.value > 1500 || mf.wan_mtu.value < 576)
				{
					alert(sw("txtInvalidMTUSize")+"("+sw("txtPermittedRange")+sw("txtMtuRng576to1500")+")");
					return false;
				}	

				 mf.mac_cloning_address.value=mf.mac1.value+':'+mf.mac2.value+':'+mf.mac3.value+':'+mf.mac4.value+':'+mf.mac5.value+':'+mf.mac6.value;		
				mf.mac_cloning_address.value = trim_string(mf.mac_cloning_address.value);
				if(!verify_mac(mf.mac_cloning_address.value,mf.mac_cloning_address))
				{
					alert (sw("txtInvalidMACAddress") + " "+mf.mac_cloning_address.value + ".");
					return;
				}
				if(mf.mac_cloning_address.value == "00:00:00:00:00:00") {
					mf.mac_cloning_enabled.value = "false";
				}			
				else
				{
					mf.mac_cloning_enabled.value = "true";
				}
				mac_addr = mf.mac_cloning_address.value.split(":");					
				mf.mac_clone.value = "";
				for(var i=0;i<mac_addr.length;i++){
						mf.mac_clone.value += mac_addr[i];
				}	
						
				switch (mode) {
				case PPPOE:			
					mf.pppoe_max_idle_time.disabled = false;
					break;
				case PPTP:
					mf.wan_pptp_max_idle_time.disabled = false;
					break;			
				case L2TP:
					mf.wan_l2tp_max_idle_time.disabled = false;
					break;
				
				}
				
				mf["settingsChanged"].value = 1;
			}
			
			if(mf["dsl_mode"].value != <%getInfo("wanType");%>)
				mf["settingsChanged"].value = 1;
			if(mf.pppoe_netsniper_select.checked)
			{
				mf.pppoe_netsniper.value = "true";
				mf.pppoe_xkjs.value = "false";
				mf.xkjs_mode.value = "0";
			}else if(mf.pppoe_xkjs_select.checked)
			{
				mf.pppoe_netsniper.value = "false";
				mf.pppoe_xkjs.value = "true";
				mf.xkjs_mode.value = "0";
			}else if(mf.pppoeplus_select.checked)
			{
				mf.pppoe_netsniper.value = "false";
				mf.pppoe_xkjs.value = "false";
				mf.xkjs_mode.value = "4";
			}else
			{
				mf.pppoe_netsniper.value = "false";
				mf.pppoe_xkjs.value = "false";
				mf.xkjs_mode.value = "0";
			}
			mf.submit();
		}
function Lang_Check()
{
	if(LangCode == "SC"){
			get_by_id("show_info").style.display = "";
	}
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtWAN");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");			
get_by_id("clone_mac_addr").value = sw("txtCopyMACAddress");
get_by_id("add_new_schedule").value = sw("txtAddNew");
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");		
}
//]]>
</script>
</head>
<body onload="template_load(); init();web_timeout();">
<div id="loader_container" onclick="return false;">¡¡</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
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
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td><td id="maincontent_container"><SCRIPT >DrawRebootContent("wan");</SCRIPT>
<div id="warnings_section" style="display:none"><div class="section" >	<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">

</div></div></div>	</div> 
<div id="maincontent" style="display: block">
<form name="mainform" action="/goform/formSetWanPPPoE" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="dsl_mode" name="dsl_mode" value="<%getInfo("wanType");%>"/>
<input type="hidden" name="config.wan_force_static_dns_servers" id="wan_force_static_dns_servers" value="false" />
<input type="hidden" name="config.wan_ip_mode" id="wan_ip_mode" value="<%getInfo("wanType");%>" />
<input type="hidden" name="config.pppoe_use_dynamic_address" id="pppoe_use_dynamic_address" value="<%getIndexInfo("pppoe_wan_ip_mode");%>" />
<input type="hidden" name="config.pppoe_reconnect_mode" id="pppoe_reconnect_mode" value="<% getInfo("pppConnectType"); %>" />
<input type="hidden" name="config.wan_mtu_use_default" id="wan_mtu_use_default" value="true" />
<input type="hidden" id="mac_cloning_enabled" name="config.mac_cloning_enabled" value="true"/>
<input type="hidden" id="mac_cloning_address" size="20" maxlength="17" value="<% getInfo("wanMac"); %>" name="config.mac_cloning_address" /> 
<input type="hidden" id="mac_clone" name="mac_clone" value=""/>
<input type="hidden" id="pppoe_use_dynamic_dns" name="pppoe_use_dynamic_dns" value=""/>
<input type="hidden" id="pppoe_netsniper" name="config.pppoe_netsniper" value="<% getInfo("pppNetSniper"); %>"/>
<input type="hidden" id="pppoe_xkjs" name="config.pppoe_xkjs" value="<% getInfo("pppXkjs_on-of"); %>" />
<input type="hidden" id="xkjs_mode" name="config.xkjs_mode" value="<% getInfo("pppXkjs"); %>" />
<input type="hidden" id="webpage" name="webpage" value="/Basic/wan_pppoe.asp">
<div class="section"><div class="section_head">
<h2><SCRIPT >ddw("txtWAN");</SCRIPT></h2>
<p>	<SCRIPT >ddw("txtWANStr2");</SCRIPT></p> 
<p>	<b><SCRIPT >ddw("txtNote");</SCRIPT>&nbsp;:</b> 
<SCRIPT >ddw("txtWANStr3");</SCRIPT></p> 
<input class="button_submit" type="button" id="SaveSettings" name="SaveSettings" value="" onclick="page_submit();"/>
<input class="button_submit" type="button" id="DontSaveSettings" name="DontSaveSettings" value="" onclick="page_cancel();"/>
</div></div><div class="box"><h3><SCRIPT >ddw("txtInternetConnectionType");</SCRIPT></h3>
<p class="box_msg"> <SCRIPT >ddw("txtWANStr5");</SCRIPT></p>
<fieldset><p> <label class="duple"><SCRIPT >ddw("txtWANStr4");</SCRIPT>&nbsp;:</label>
<select id="wan_ip_mode_select" onchange="wan_ip_mode_selector(this.value);">
</select></p></fieldset></div><div class="box">	<div id="box_wan_pppoe" style="display:block">
<h3>PPPOE</h3><p class="box_msg"><SCRIPT >ddw("txtWANStr1");</SCRIPT>
</p></div><fieldset><div id="box_wan_pppoe_body" style="display:block"> 
<p> <label class="duple" for="address_mode">&nbsp;</label>
<input id="pppoe_use_dynamic_address_radio_1" type="radio" name="pppoe_use_dynamic_address_radio" value="true" onclick="pppoe_use_dynamic_address_selector(this.value);"/>
<label>
<SCRIPT >ddw("txtDynamicPPPoE");</SCRIPT>									
</label><input id="pppoe_use_dynamic_address_radio_0" type="radio" name="pppoe_use_dynamic_address_radio" value="false" onclick="pppoe_use_dynamic_address_selector(this.value);"/>
<label>
<SCRIPT >ddw("txtStaticPPPoE");</SCRIPT> </label></p>
<p> <label class="duple" for="pppoe_username">
<SCRIPT >ddw("txtUserName");</SCRIPT>
&nbsp;:</label><input type="text" id="pppoe_username" size="20" maxlength="63" value="<% getInfo("pppUserName"); %>" name="config.pppoe_username"/>
</p><p><label class="duple" for="pppoe_password">
<SCRIPT >ddw("txtPassword");</SCRIPT>
&nbsp;:</label><input type="password" id="pppoe_password" size="20" maxlength="63" onfocus="select();" value="<% getInfo("pppPassword"); %>" name="config.pppoe_password"/>
</p><p> <label class="duple" for="confirm_pppoe_password">
<SCRIPT >ddw("txtVerifyPassword");</SCRIPT>
&nbsp;:</label><input type="password" id="confirm_pppoe_password" size="20" maxlength="63" onfocus="select();" value="<% getInfo("pppPassword"); %>"/>
</p><p> <label class="duple" for="pppoe_service_name">
<SCRIPT >ddw("txtServiceName");</SCRIPT>									
&nbsp;:</label><input type="text" id="pppoe_service_name" size="30" maxlength="39" value="<% getInfo("pppServiceName"); %>" name="config.pppoe_service_name"/>
<SCRIPT >ddw("txtOptional");</SCRIPT> </p>
<p><label class="duple" for="pppoe_ip_address"><SCRIPT >ddw("txtIPAddress");</SCRIPT>
&nbsp;:</label><input type="text" id="pppoe_ip_address" size="20" maxlength="15" value="<% getInfo("pppoe-wan-ip-rom");%>" name="config.pppoe_ip_address"/>
</p>
<p>	<label class="duple" for="mac_cloning_address"><SCRIPT >ddw("txtMACAddress");</SCRIPT>&nbsp;:</label>
<input type=text id=mac1 name=mac1 size=2 maxlength=2 value=""> -
<input type=text id=mac2 name=mac2 size=2 maxlength=2 value=""> -
<input type=text id=mac3 name=mac3 size=2 maxlength=2 value=""> -
<input type=text id=mac4 name=mac4 size=2 maxlength=2 value=""> -
<input type=text id=mac5 name=mac5 size=2 maxlength=2 value=""> -
<input type=text id=mac6 name=mac6 size=2 maxlength=2 value=""> <SCRIPT >ddw("txtOptional");</SCRIPT>&nbsp;&nbsp;
</p>
<p><label class="duple">&nbsp;</label>
<input class="button_submit" type="button" id="clone_mac_addr" value="" onclick="clone_mac();" />
</p>
</div>
<div id="box_wan_general_body_dns" style="display:block">
<p> <label class="duple">&nbsp;</label>
<input id="pppoe_use_dynamic_dns_radio_1" type="radio" name="pppoe_use_dynamic_dns_radio" value="true" onclick="pppoe_use_dynamic_dns_selector(this.value);"/>
<label><SCRIPT >ddw("txtDynGetDNS");</SCRIPT></label>
<input id="pppoe_use_dynamic_dns_radio_0" type="radio" name="pppoe_use_dynamic_dns_radio" value="false" onclick="pppoe_use_dynamic_dns_selector(this.value);"/>
<label><SCRIPT >ddw("txtStaticGetDNS");</SCRIPT> </label></p>	
<p> 
<label class="duple" for="wan_primary_dns"><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>&nbsp;:</label>
<input type="text" id="wan_primary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns1");%>" name="config.wan_primary_dns"/>
<label for="wan_primary_dns" id="wan_primary_dns_optional" style="display: none;"><SCRIPT >ddw("txtOptional");</SCRIPT></label>
</p><p> <label class="duple" for="wan_secondary_dns"><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>&nbsp;:</label>
<input type="text" id="wan_secondary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns2");%>" name="config.wan_secondary_dns" />
<SCRIPT >ddw("txtOptional");</SCRIPT>
</p></div><div id="box_wan_general_body" style="display:block">
<p><label class="duple" for="pppoe_max_idle_time">
<SCRIPT >ddw("txtMaximumIdleTime");</SCRIPT>									
&nbsp;:</label>
<input type="text" id="pppoe_max_idle_time" size="10" maxlength="5" value="<% getInfo("wan-ppp-idle"); %>" name="config.pppoe_max_idle_time"/>
<SCRIPT >ddw("txtMinutesInfinite");</SCRIPT>												 
</p>	
 <p> 
<label class="duple" for="wan_mtu">MTU&nbsp;:</label>
<input type="text" id="wan_mtu" size="10" maxlength="5" value="<% getInfo("pppMtuSize"); %>" name="config.wan_mtu" />
<SCRIPT >ddw("txtBytes");</SCRIPT>
<SCRIPT >ddw("txtMTUdefault");</SCRIPT>
<SCRIPT >ddw("txtPPPoEMTUdefault");</SCRIPT>
</p>
<div id="box_wan_reconnect" style="display:block">
<p><label class="duple" for="wan_pptp_reconnect_mode"><SCRIPT >ddw("txtReconnectMode");</SCRIPT>&nbsp;:</label>
<input type=radio name=pppoe_reconnect_mode_radio id=pppoe_reconnect_mode_radio_0 value=0 onclick="pppoe_reconnect_selector(this.value);">
<input id="ppp_schedule_control_0" name="ppp_schedule_control_0" value="<%getIndexInfo("wanPPPoESchSelectName");%>" type="hidden">
<select id='wan_sch_select' name='wan_sch_select' onChange="wan_schedule_name_selector(this.value);">
</select> &nbsp;<input class="button_submit" type="button" id="add_new_schedule" value="" onclick="do_add_new_schedule(true)">
</p>
<p>
<label class="duple">&nbsp;</label>
<input type=radio name=pppoe_reconnect_mode_radio id=pppoe_reconnect_mode_radio_1 value=2 onclick="pppoe_reconnect_selector(this.value);"><SCRIPT >ddw("txtManual");</SCRIPT>
<input type=radio name=pppoe_reconnect_mode_radio id=pppoe_reconnect_mode_radio_2 value=1 onclick="pppoe_reconnect_selector(this.value);"><SCRIPT >ddw("txtOnDemand");</SCRIPT>
</p>
</div>
<!--Boer add for netfilter start-->
<div id="show_info" style="display:none">
<p>
	<table width="100%">
		<tr><td align="right" width="183"><input type="checkbox" id="pppoe_netsniper_select" onclick="pppoe_netsniper_selector(this.checked)" />:</td>
		    <td align="left">&nbsp;&nbsp;<SCRIPT >ddw("txtNetSniper");</SCRIPT></td></tr>
	</table>
	<table width="100%">
		<tr><td align="right" width="183"><input type="checkbox" id="pppoe_xkjs_select" onclick="pppoe_xkjs_selector(this.checked)" />:</td>
		<td align="left">&nbsp;&nbsp;<SCRIPT >ddw("txtWizardEasyStepSupportXKJS");</SCRIPT></td></tr>
	</table>
	<table width="100%">
		<tr><td align="right" width="183"><input type="checkbox" id="pppoeplus_select" onclick="pppoeplus_selector(this.checked)" />:</td>
		    <td align="left">&nbsp;&nbsp;PPPoE+</td></tr>
	</table>
</p>
</div>

<div id="show_xkjs" style="display:none">
<p>
	<table width="100%">
		    <td align="left" width="100%"><SCRIPT >ddw("txtXkjs1");</SCRIPT>&nbsp;:</td></tr>
	</table>
	<table width="100%">
		<tr><td align="right" width="183"><SCRIPT >ddw("txtXkjs2");</SCRIPT>&nbsp;:</td>
		    <td align="left">&nbsp;&nbsp;<select id="xkjs_mode_select" onchange="xkjs_mode_selector(this.value);" /></td></tr>
	</table>
</p>
</div>

<!--Boer add for netfilter end-->
</div></fieldset></div></form><SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>
</div></td>
<td id="sidehelp_container">	<div id="help_text">

<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtWANStr10");</SCRIPT></p>
<p><SCRIPT >ddw("txtWANStr11");</SCRIPT></p>
<p class="more"><a href="../Help/Basic.asp#WAN" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...
</a></p></div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>

</html>



