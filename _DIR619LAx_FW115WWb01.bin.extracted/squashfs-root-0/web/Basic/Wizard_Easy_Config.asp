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
#wan_modes p {
	margin-bottom: 1px;
}
#wan_modes input {
	float: left;
	margin-right: 1em;
}
#wan_modes label.duple {
	float: none;
	width: auto;
	text-align: left;
}
#wan_modes .itemhelp {
	margin: 0 0 1em 2em;
}
#wz_buttons {
	margin-top: 1em;
	border: none;
}
#legend_show {
		border:solid;
        border-width:1px; 
        margin: 0;
        color:#CCCCCC;
}
legend{
		color:#000000;
		font-size: 12px;
		font-weight: bold;
}
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
var lan_ip_str = "<% getInfo("ip-rom"); %>";
var lan_mask_str = "<% getInfo("mask-rom"); %>";

var wan_type = "<%getInfo("wanType");%>";
var ssid = "<%getInfo("ssid");%>";
var wpa_enabled = "<%getIndexInfo("wpa_enabled");%>";
var wlan_key = "<%getInfo("pskValue");%>";

//<![CDATA[

function prev()
{
	document.write("<input type='button' name='prev' value=\""+sw("txtPrev")+"\" onClick=\"page_prev()\">&nbsp;");
}
function next()
{
	document.write("<input type='button' name='next' value=\""+sw("txtNext")+"\" onClick=\"page_submit()\">&nbsp;");
}

function on_change_wan_type(selectValue)
{	
	selectValue = selectValue *1;
	get_by_id("wan_type").value = selectValue;
	if(selectValue == 0)
	{
		get_by_id("static_setting").style.display = "";
		get_by_id("pppoe_setting").style.display = "none";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "none";
		get_by_id("dhcpplus_setting").style.display = "none";
	}
	else if(selectValue == 1)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "none";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "none";
		get_by_id("dhcpplus_setting").style.display = "none";
	}
	else if(selectValue == 2)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "none";
		get_by_id("dhcpplus_setting").style.display = "none";	
		if(LangCode == "SC")
		{
			get_by_id("tr_sniper").style.display = "";
			get_by_id("tr_xkjs").style.display = "none";
			get_by_id("tr_xkjs_select").style.display = "";
			get_by_id("tr_pppoeplus_select").style.display = "";
		}
		else if(LangCode == "TW")
		{
			get_by_id("tr_connect_mode").style.display = "";
		}
	}
	else if(selectValue == 3)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "none";
		get_by_id("pptp_setting").style.display = "";
		get_by_id("l2tp_setting").style.display = "none";
		get_by_id("dhcpplus_setting").style.display = "none";
	}
	else if(selectValue == 4)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "none";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "";
		get_by_id("dhcpplus_setting").style.display = "none";
	}
	else if(selectValue == 9)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "none";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "none";
		get_by_id("dhcpplus_setting").style.display = "";
	}
}
function wan_l2tp_use_dynamic_carrier_selector(mode){
	var form_handle = document.forms[0];
	form_handle.wan_l2tp_use_dynamic_carrier.value = mode;
	if(mode == "true") {
		form_handle.wan_l2tp_use_dynamic_carrier_radio_1.checked = true;
		form_handle.wan_l2tp_ip_address.disabled = true;
		form_handle.wan_l2tp_subnet_mask.disabled = true;
		form_handle.wan_l2tp_gateway.disabled = true;
		form_handle.wan_l2tp_primary_dns.disabled = true;
		form_handle.wan_l2tp_primary_dns2.disabled = true;
	} else {
		form_handle.wan_l2tp_use_dynamic_carrier_radio_0.checked = true;
		form_handle.wan_l2tp_ip_address.disabled = false;
		form_handle.wan_l2tp_subnet_mask.disabled = false;
		form_handle.wan_l2tp_gateway.disabled = false;
		form_handle.wan_l2tp_primary_dns.disabled = false;
		form_handle.wan_l2tp_primary_dns2.disabled = false;
	}
}
function pptp_clone_mac() {
	var form_handle = document.forms[0];
	form_handle.pptp_mac_cloning_address.value = pcmac;
	form_handle.pptp_mac_cloning_enabled.value = "true";
}
function l2tp_clone_mac() {
	var form_handle = document.forms[0];
	form_handle.l2tp_mac_cloning_address.value = pcmac;
	form_handle.l2tp_mac_cloning_enabled.value = "true";
}
function wan_pptp_use_dynamic_carrier_selector(mode)
{
	var form_handle = document.forms[0];
	form_handle.wan_pptp_use_dynamic_carrier.value = mode;
	if(mode == "true") {
		form_handle.wan_pptp_use_dynamic_carrier_radio_1.checked = true;
		form_handle.wan_pptp_ip_address.disabled = true;	
		form_handle.wan_pptp_subnet_mask.disabled = true;
		form_handle.wan_pptp_gateway.disabled = true;
		form_handle.wan_pptp_primary_dns.disabled = true;
		form_handle.wan_pptp_primary_dns2.disabled = true;
	} else {
		form_handle.wan_pptp_use_dynamic_carrier_radio_0.checked = true;
		form_handle.wan_pptp_ip_address.disabled = false;
		form_handle.wan_pptp_subnet_mask.disabled = false;
		form_handle.wan_pptp_gateway.disabled = false;
		form_handle.wan_pptp_primary_dns.disabled = false;
		form_handle.wan_pptp_primary_dns2.disabled = false;
	}
}
function on_click_sniper()
{
	get_by_id("h_pppoe_netsniper").value = get_by_id("pppoe_netsniper").checked === true ? true : false;

	if(get_by_id("pppoe_netsniper").checked) {

		get_by_id("h_pppoe_xkjs").value = false;
		get_by_id("xkjs_mode").value = "0";

		get_by_id("pppoe_xkjs").checked = false;
		get_by_id("pppoe_xkjs").disabled = true;

		get_by_id("pppoeplus").checked = false;
		get_by_id("pppoeplus").disabled = true;
	} else {
		get_by_id("pppoe_xkjs").disabled = false;
		get_by_id("pppoeplus").disabled = false;
	}
}
function on_click_xkjs()
{
        get_by_id("h_pppoe_xkjs").value = get_by_id("pppoe_xkjs").checked === true ? true : false;

	if(get_by_id("pppoe_xkjs").checked) {
		get_by_id("h_pppoe_netsniper").value = false;
		get_by_id("h_pppoe_xkjs").value = "true";
		get_by_id("xkjs_mode").value = "0";

		get_by_id("pppoe_netsniper").checked = false;
		get_by_id("pppoe_netsniper").disabled = true;

		get_by_id("pppoeplus").checked = false;
		get_by_id("pppoeplus").disabled = true;
	} else {
		get_by_id("pppoe_netsniper").disabled = false;
		get_by_id("pppoeplus").disabled = false;
	}
}
function on_click_pppoeplus()
{
	if(get_by_id("pppoeplus").checked){
        get_by_id("h_pppoe_netsniper").value = false;
        get_by_id("h_pppoe_xkjs").value = "false";
        get_by_id("xkjs_mode").value = "4";

        get_by_id("pppoe_netsniper").checked = false;
        get_by_id("pppoe_netsniper").disabled = true;

        get_by_id("pppoe_xkjs").checked = false;
        get_by_id("pppoe_xkjs").disabled = true;
	}else{
		get_by_id("pppoe_netsniper").disabled = false;
		get_by_id("pppoe_xkjs").disabled = false;

        get_by_id("h_pppoe_netsniper").value = false;
        get_by_id("h_pppoe_xkjs").value = "false";
        get_by_id("xkjs_mode").value = "0";
	}
}
function update_xkjs_mode_list(value)
{
	var xkjs_mode_select = get_by_id("xkjs_mode_select");
    xkjs_mode_select.length = 0;
    xkjs_mode_select[0] = new Option(sw("txtXkjs3"), "0", false, false);
    xkjs_mode_select[1] = new Option(sw("txtXkjs4") + "1", "1", false, false);
    xkjs_mode_select[2] = new Option(sw("txtXkjs4") + "2", "2", false, false);
    xkjs_mode_select[3] = new Option(sw("txtXkjs4") + "3", "3", false, false);
    xkjs_mode_select[4] = new Option(sw("txtXkjs4") + "4", "4", false, false);
    xkjs_mode_select[5] = new Option(sw("txtXkjs4") + "5", "5", false, false);
    xkjs_mode_select[6] = new Option(sw("txtXkjs4") + "6", "6", false, false);
    xkjs_mode_select.value  = value;
}
function xkjs_mode_selector(value)
{
            get_by_id("xkjs_mode").value = value;
}
function on_change_security_type(value)
{
	mf=document.forms.wz_form_pg_4;
	mf.security_type_radio.value=value;
	if(value==1)
	{
		mf.security_type_radio_1.checked=true;
		mf.wlan_password.disabled =false;
		mf.auto_passwd_select.disabled =false;
	}
	else
	{
		mf.security_type_radio_0.checked=true;
		mf.wlan_password.disabled =true;
		mf.auto_passwd_select.disabled =true;
	}
}

function wz_verify_4()
{
	var form_handle = document.forms[0];
	var wantype=get_by_id("wan_type").value;
	//PPPOE
	if(wantype == 2)
	{
		if(is_blank(form_handle.pppoe_username.value))
		{
			alert(sw("txtUserNameBlank"));
			form_handle.pppoe_username.focus();
			return false;
		}
		if(strchk_unicode(form_handle.pppoe_username.value) == true)
		{
			alert(sw("txtUserName")+sw("txtisInvalid"));
			form_handle.pppoe_username.focus();
			return false;
		}
		form_handle.pppoe_password.value = trim_string(form_handle.pppoe_password.value);
		if (form_handle.second_pppoe_password.value !== form_handle.pppoe_password.value)
		{
			alert(sw("txtTwoPasswordsNotSame"));
			form_handle.pppoe_password.select();
			form_handle.pppoe_password.focus();
			return false;
		}
	}
	else if(wantype == 9)
	{
		if (is_blank(form_handle.wan_dhcpplus_username.value))
		{
			alert(sw("txtUserNameBlank"));
			form_handle.wan_dhcpplus_username.focus();
			return false;
		}	
	}
	else if(wantype == 0)
	{
		//STATIC
		if (!is_ipv4_valid(form_handle.wan_ip_address.value) || form_handle.wan_ip_address.value=="0.0.0.0" || is_FF_IP(form_handle.wan_ip_address.value))
		{
			alert(sw("txtInvalidIPAddress"));
			form_handle.wan_ip_address.select();
			form_handle.wan_ip_address.focus();
			return false;
		}
		if (!is_ipv4_valid(form_handle.wan_subnet_mask.value) || !is_mask_valid(form_handle.wan_subnet_mask.value))
		{
			alert(sw("txtInvalidSubnetMask"));
			form_handle.wan_subnet_mask.select();
			form_handle.wan_subnet_mask.focus();
			return false;
		}
		if (!is_ipv4_valid(form_handle.wan_gateway.value) || form_handle.wan_gateway.value=="0.0.0.0" || is_FF_IP(form_handle.wan_gateway.value))
		{
			alert(sw("txtInvalidGatewayAddress"));
			form_handle.wan_gateway.select();
			form_handle.wan_gateway.focus();
			return false;
		}
		var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
		var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
		var wan_ip = ipv4_to_unsigned_integer(form_handle.wan_ip_address.value);
		var mask_ip = ipv4_to_unsigned_integer(form_handle.wan_subnet_mask.value);
		var gw_ip = ipv4_to_unsigned_integer(form_handle.wan_gateway.value);
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
		/*
		 * Allow blank as wel as 0.0.0.0 for primary and secondary
		 */
		form_handle.wan_primary_dns.value = form_handle.wan_primary_dns.value == "" ? "0.0.0.0" : form_handle.wan_primary_dns.value;
		form_handle.wan_secondary_dns.value = form_handle.wan_secondary_dns.value == "" ? "0.0.0.0" : form_handle.wan_secondary_dns.value;
		
		if (!is_ipv4_valid(form_handle.wan_primary_dns.value) || form_handle.wan_primary_dns.value=="0.0.0.0" || is_FF_IP(form_handle.wan_primary_dns.value) || ((ipv4_to_unsigned_integer(form_handle.wan_primary_dns.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(form_handle.wan_primary_dns.value) & 0x000000FF) == 0x00000000   ))
		{
			alert(sw("txtInvalidPrimaryDNSAddress"));
			form_handle.wan_primary_dns.select();
			form_handle.wan_primary_dns.focus();
			return false;
		}
		if (!is_ipv4_valid(form_handle.wan_secondary_dns.value) || is_FF_IP(form_handle.wan_secondary_dns.value) || ((ipv4_to_unsigned_integer(form_handle.wan_secondary_dns.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(form_handle.wan_secondary_dns.value) & 0x000000FF) == 0x00000000   ))
		{
			alert(sw("txtInvalidSecondaryDNSAddress"));
			form_handle.wan_secondary_dns.select();
			form_handle.wan_secondary_dns.focus();
			return false;
		}
	}
	else if(wantype == 3)//PPTP
	{
		if(is_blank(form_handle.wan_pptp_username.value))
		{
			alert(sw("txtUserNameBlank"));
			form_handle.wan_pptp_username.focus();
			return false;
		}
		if(form_handle.wan_pptp_use_dynamic_carrier_radio_0.checked == "true" ) 
		{
			var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
			var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");	
			var wan_ip = ipv4_to_unsigned_integer(form_handle.wan_pptp_ip_address.value);
			var mask_ip = ipv4_to_unsigned_integer(form_handle.wan_pptp_subnet_mask.value);
			var gw_ip = ipv4_to_unsigned_integer(form_handle.wan_pptp_gateway.value);
			var srv_ip = ipv4_to_unsigned_integer(form_handle.wan_pptp_server.value);
			var b255 = ipv4_to_unsigned_integer("255.255.255.255");
			b255 ^= mask_ip;
			
			if (!is_ipv4_valid(form_handle.wan_pptp_ip_address.value) || 
				form_handle.wan_pptp_ip_address.value=="0.0.0.0" || 
				is_FF_IP(form_handle.wan_pptp_ip_address.value) ||
				wan_ip == gw_ip || wan_ip == srv_ip ||
				0 == (wan_ip & b255) ||
				b255 == (b255 & wan_ip)){
				alert(sw("txtInvalidPPTPIPaddress") + form_handle.wan_pptp_ip_address.value);
					try	{
						form_handle.wan_pptp_ip_address.select();
						form_handle.wan_pptp_ip_address.focus();
					} catch (e) {
					}
					return;
			}

			if (!is_ipv4_valid(form_handle.wan_pptp_subnet_mask.value) || !is_mask_valid(form_handle.wan_pptp_subnet_mask.value)) 
			{
				alert(sw("txtInvalidPPTPsubnetMask") + form_handle.wan_pptp_subnet_mask.value);
				try	{
					form_handle.wan_pptp_subnet_mask.select();
					form_handle.wan_pptp_subnet_mask.focus();
				} catch (e) {
				}
				return;
			}

			//|| gw_ip == srv_ip	==> we accept the case when gw ip == server ip
			if (!is_ipv4_valid(form_handle.wan_pptp_gateway.value) || 
				form_handle.wan_pptp_gateway.value=="0.0.0.0" || 
				is_FF_IP(form_handle.wan_pptp_gateway.value) ||
				0 == (gw_ip & b255) ||
				b255 == ((gw_ip & b255)) ){
				alert(sw("txtInvalidPPTPgatewayIPaddress") + form_handle.wan_pptp_gateway.value);
				try	{
					form_handle.wan_pptp_gateway.select();
					form_handle.wan_pptp_gateway.focus();
				} catch (e) {
				}
				return;
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
		if(form_handle.wan_pptp_server.value == "0.0.0.0")
		{
            		alert(sw("txtInvalidPPTPserverIPaddress") + form_handle.wan_pptp_server.value);
			try {
				form_handle.wan_pptp_server.select();
				form_handle.wan_pptp_server.focus();
			} catch (e) {
			}
			return;
		}

		if(  form_handle.wan_pptp_use_dynamic_carrier_radio_0.checked == true
			&& (!is_valid_ip(form_handle.wan_pptp_server.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_pptp_server.value) 
			|| !is_valid_gateway(form_handle.wan_pptp_ip_address.value,form_handle.wan_pptp_subnet_mask.value,form_handle.wan_pptp_server.value)))	{ 
			alert(sw("txtInvalidPPTPserverIPaddress") + form_handle.wan_pptp_server.value);
			try	{
				form_handle.wan_pptp_server.select();
				form_handle.wan_pptp_server.focus();
			} catch (e) {
			}
			return;
		}

		if(  form_handle.wan_pptp_use_dynamic_carrier_radio_1.checked == true
			&& (!is_valid_ip(form_handle.wan_pptp_server.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_pptp_server.value)))	{
			alert(sw("txtInvalidPPTPserverIPaddress") + form_handle.wan_pptp_server.value);
			try	{
				form_handle.wan_pptp_server.select();
				form_handle.wan_pptp_server.focus();
			} catch (e) {
			}
			return;
		}

		form_handle.wan_pptp_primary_dns.value = trim_string(form_handle.wan_pptp_primary_dns.value);
		form_handle.wan_pptp_primary_dns.value = form_handle.wan_pptp_primary_dns.value == "" ? "0.0.0.0" : form_handle.wan_pptp_primary_dns.value;
		
		if(  form_handle.wan_pptp_primary_dns.value!="0.0.0.0" && form_handle.wan_pptp_use_dynamic_carrier_radio_0.checked == true
			&& (!is_valid_ip(form_handle.wan_pptp_primary_dns.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_pptp_primary_dns.value) 
			|| !is_valid_gateway(form_handle.wan_pptp_ip_address.value,form_handle.wan_pptp_subnet_mask.value,form_handle.wan_pptp_primary_dns.value))){ 
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  form_handle.wan_pptp_primary_dns.value);
			try {
				form_handle.wan_pptp_primary_dns.select();
				form_handle.wan_pptp_primary_dns.focus();
			} catch (e) {
			}
			return;
		}
				
		if(  form_handle.wan_pptp_primary_dns.value!="0.0.0.0" && form_handle.wan_pptp_use_dynamic_carrier_radio_1.checked == true
		     && (!is_valid_ip(form_handle.wan_pptp_primary_dns.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_pptp_primary_dns.value))){
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  form_handle.wan_pptp_primary_dns.value);
			try {
				form_handle.wan_pptp_primary_dns.select();
				form_handle.wan_pptp_primary_dns.focus();
			} catch (e) {
			}
			return;
		}
		
		form_handle.wan_pptp_primary_dns2.value = trim_string(form_handle.wan_pptp_primary_dns2.value);
		form_handle.wan_pptp_primary_dns2.value = form_handle.wan_pptp_primary_dns2.value == "" ? "0.0.0.0" : form_handle.wan_pptp_primary_dns2.value;
		
		if(  form_handle.wan_pptp_primary_dns2.value!="0.0.0.0" && form_handle.wan_pptp_use_dynamic_carrier_radio_0.checked == true
			&& (!is_valid_ip(form_handle.wan_pptp_primary_dns2.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_pptp_primary_dns2.value) 
			|| !is_valid_gateway(form_handle.wan_pptp_ip_address.value,form_handle.wan_pptp_subnet_mask.value,form_handle.wan_pptp_primary_dns2.value))){ 
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  form_handle.wan_pptp_primary_dns2.value);
			try {
				form_handle.wan_pptp_primary_dns2.select();
				form_handle.wan_pptp_primary_dns2.focus();
			} catch (e) {
			}
			return;
		}

		if(  form_handle.wan_pptp_primary_dns2.value!="0.0.0.0" && form_handle.wan_pptp_use_dynamic_carrier_radio_1.checked == true
		     && (!is_valid_ip(form_handle.wan_pptp_primary_dns2.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_pptp_primary_dns2.value))){
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  form_handle.wan_pptp_primary_dns2.value);
			try {
				form_handle.wan_pptp_primary_dns2.select();
				form_handle.wan_pptp_primary_dns2.focus();
			} catch (e) {
			}
			return;
		}

		if ((form_handle.wan_pptp_primary_dns.value != "0.0.0.0") || (form_handle.wan_pptp_primary_dns2.value != "0.0.0.0")) {
			form_handle.wan_force_static_dns_servers.value = "true";
		} else {
			form_handle.wan_force_static_dns_servers.value = "false";
		}

		form_handle.pptp_mac_cloning_address.value = trim_string(form_handle.pptp_mac_cloning_address.value);
		if(!is_mac_valid(form_handle.pptp_mac_cloning_address.value, true)) {
			alert (sw("txtInvalidMACAddress") + form_handle.pptp_mac_cloning_address.value + ".");
			return;
		}
		if(form_handle.pptp_mac_cloning_address.value == "00:00:00:00:00:00") {
			form_handle.pptp_mac_cloning_enabled.value = "false";
		}			
		else
		{
			var mac_addr = form_handle.pptp_mac_cloning_address.value.split(":");					
			form_handle.pptp_mac_cloning_enabled.value = "true";
			form_handle.pptp_mac_clone.value = "";	

			for(var i=0;i<mac_addr.length;i++)
			{
				form_handle.pptp_mac_clone.value += mac_addr[i];	
			}
		}

	}
	else if(wantype == 4)//L2TP
	{
		var mac_addr;
		
		if(is_blank(form_handle.wan_l2tp_username.value))
		{
			alert(sw("txtUserNameBlank"));
			form_handle.wan_l2tp_username.focus();
			return false;
		}
		
		if(form_handle.wan_l2tp_use_dynamic_carrier_radio_0.checked == "true" ) 
		{
			var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
			var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");		
			var wan_ip = ipv4_to_unsigned_integer(form_handle.wan_l2tp_ip_address.value);
			var mask_ip = ipv4_to_unsigned_integer(form_handle.wan_l2tp_subnet_mask.value);
			var gw_ip = ipv4_to_unsigned_integer(form_handle.wan_l2tp_gateway.value);
			var srv_ip = ipv4_to_unsigned_integer(form_handle.wan_l2tp_server.value);
			var b255 = ipv4_to_unsigned_integer("255.255.255.255");
			b255 ^= mask_ip;
			
			if (!is_ipv4_valid(form_handle.wan_l2tp_ip_address.value) || 
				form_handle.wan_l2tp_ip_address.value=="0.0.0.0" || 
				is_FF_IP(form_handle.wan_l2tp_ip_address.value) ||
				wan_ip == gw_ip || wan_ip == srv_ip ||
				0 == (wan_ip & b255) ||
				b255 == (b255 & wan_ip)){
					alert(sw("txtInvalidL2TPIP") + form_handle.wan_l2tp_ip_address.value);
					try	{
						form_handle.wan_l2tp_ip_address.select();
						form_handle.wan_l2tp_ip_address.focus();
					}	 
					catch (e) {
					}
				return;
			}
			if (!is_ipv4_valid(form_handle.wan_l2tp_subnet_mask.value) || !is_mask_valid(form_handle.wan_l2tp_subnet_mask.value)) {
				alert(sw("txtInvalidL2TPsubnetMask") + form_handle.wan_l2tp_subnet_mask.value);
				try	{
					form_handle.wan_l2tp_subnet_mask.select();
					form_handle.wan_l2tp_subnet_mask.focus();
				} catch (e) {
				}
				return;
			}
			//||gw_ip == srv_ip==>we accept the case when gw ip == server ip
			if (!is_ipv4_valid(form_handle.wan_l2tp_gateway.value) || 
				form_handle.wan_l2tp_gateway.value=="0.0.0.0" || 
				is_FF_IP(form_handle.wan_l2tp_gateway.value)  ||
				0 == (gw_ip & b255) ||
				b255 == (gw_ip & b255)){
					alert(sw("txtInvalidL2TPgatewayIP") + form_handle.wan_l2tp_gateway.value);
					try	{
						form_handle.wan_l2tp_gateway.select();
						form_handle.wan_l2tp_gateway.focus();
					}	 
					catch (e) {
					}
					return;
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
		
		if(form_handle.wan_l2tp_server.value == "0.0.0.0"){
			alert(sw("txtInvalidL2TPserver") + form_handle.wan_l2tp_server.value);
			try     {
				form_handle.wan_l2tp_server.select();
				form_handle.wan_l2tp_server.focus();
			} catch (e) {
			}
			return;
		}
		
		if(  form_handle.wan_l2tp_use_dynamic_carrier_radio_0.checked == true
	     && (!is_valid_ip(form_handle.wan_l2tp_server.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_l2tp_server.value)
	     || !is_valid_gateway(form_handle.wan_l2tp_ip_address.value,form_handle.wan_l2tp_subnet_mask.value,form_handle.wan_l2tp_server.value))){
			alert(sw("txtInvalidL2TPserver") + form_handle.wan_l2tp_server.value);
			try     {
				form_handle.wan_l2tp_server.select();
				form_handle.wan_l2tp_server.focus();
			} catch (e) {
			}
			return;
		}

		if(  form_handle.wan_l2tp_use_dynamic_carrier_radio_1.checked == true
		  && (!is_valid_ip(form_handle.wan_l2tp_server.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_l2tp_server.value))){
			alert(sw("txtInvalidL2TPserver") + form_handle.wan_l2tp_server.value);
			try     {
				form_handle.wan_l2tp_server.select();
				form_handle.wan_l2tp_server.focus();
			} catch (e) {
			}
			return;
		}
	
		form_handle.wan_l2tp_primary_dns.value = trim_string(form_handle.wan_l2tp_primary_dns.value);

		form_handle.wan_l2tp_primary_dns.value = form_handle.wan_l2tp_primary_dns.value == "" ? "0.0.0.0" : form_handle.wan_l2tp_primary_dns.value;

		//if (!is_ipv4_valid(form_handle.wan_l2tp_primary_dns.value) || is_FF_IP(form_handle.wan_l2tp_primary_dns.value) || ((ipv4_to_unsigned_integer(form_handle.wan_l2tp_primary_dns.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(form_handle.wan_primary_dns.value) & 0x000000FF) == 0x00000000   )) {
		if(  form_handle.wan_l2tp_primary_dns.value!="0.0.0.0" && form_handle.wan_l2tp_use_dynamic_carrier_radio_0.checked == true
		     && (!is_valid_ip(form_handle.wan_l2tp_primary_dns.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_l2tp_primary_dns.value)
		     || !is_valid_gateway(form_handle.wan_l2tp_ip_address.value,form_handle.wan_l2tp_subnet_mask.value,form_handle.wan_l2tp_primary_dns.value))){
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  form_handle.wan_l2tp_primary_dns.value);
			try {
				form_handle.wan_l2tp_primary_dns.select();
				form_handle.wan_l2tp_primary_dns.focus();
			} catch (e) {
			}
			return;
		}

		if(  form_handle.wan_l2tp_primary_dns.value!="0.0.0.0" && form_handle.wan_l2tp_use_dynamic_carrier_radio_1.checked == true
		     && (!is_valid_ip(form_handle.wan_l2tp_primary_dns.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_l2tp_primary_dns.value) )){
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  form_handle.wan_l2tp_primary_dns.value);
			try {
				form_handle.wan_l2tp_primary_dns.select();
				form_handle.wan_l2tp_primary_dns.focus();
			} catch (e) {
			}
			return;
		}

		if ((form_handle.wan_l2tp_primary_dns.value != "0.0.0.0")) {
		form_handle.wan_force_static_dns_servers.value = "true";
		} else {
		form_handle.wan_force_static_dns_servers.value = "false";
		}
		
		form_handle.wan_l2tp_primary_dns2.value = trim_string(mf.wan_l2tp_primary_dns2.value);

		form_handle.wan_l2tp_primary_dns2.value = form_handle.wan_l2tp_primary_dns2.value == "" ? "0.0.0.0" : form_handle.wan_l2tp_primary_dns2.value;

		//if (!is_ipv4_valid(form_handle.wan_l2tp_primary_dns2.value) || is_FF_IP(form_handle.wan_l2tp_primary_dns2.value) || ((ipv4_to_unsigned_integer(form_handle.wan_l2tp_primary_dns2.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(form_handle.wan_primary_dns2.value) & 0x000000FF) == 0x00000000   )) {
		if(  form_handle.wan_l2tp_primary_dns2.value!="0.0.0.0" && form_handle.wan_l2tp_use_dynamic_carrier_radio_0.checked == true
		     && (!is_valid_ip(form_handle.wan_l2tp_primary_dns2.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_l2tp_primary_dns2.value)
		     || !is_valid_gateway(form_handle.wan_l2tp_ip_address.value,form_handle.wan_l2tp_subnet_mask.value,form_handle.wan_l2tp_primary_dns2.value))){
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  form_handle.wan_l2tp_primary_dns2.value);
			try {
				form_handle.wan_l2tp_primary_dns2.select();
				form_handle.wan_l2tp_primary_dns2.focus();
			} catch (e) {
			}
			return;
		}

		if(  form_handle.wan_l2tp_primary_dns2.value!="0.0.0.0" && form_handle.wan_l2tp_use_dynamic_carrier_radio_1.checked == true
		     && (!is_valid_ip(form_handle.wan_l2tp_primary_dns2.value) || !is_valid_gateway(lan_ip_str,lan_mask_str,form_handle.wan_l2tp_primary_dns2.value) )){
			alert(sw("txtInvalidPPPoEPrimaryDNS") +  form_handle.wan_l2tp_primary_dns2.value);
			try {
				form_handle.wan_l2tp_primary_dns2.select();
				form_handle.wan_l2tp_primary_dns2.focus();
			} catch (e) {
			}
			return;
		}

		if ((form_handle.wan_l2tp_primary_dns2.value != "0.0.0.0")) {
		form_handle.wan_force_static_dns_servers.value = "true";
		} else {
		form_handle.wan_force_static_dns_servers.value = "false";
		}
		
		form_handle.l2tp_mac_cloning_address.value = trim_string(form_handle.l2tp_mac_cloning_address.value);
		if(!verify_mac(form_handle.l2tp_mac_cloning_address.value,form_handle.l2tp_mac_cloning_address))
		{
			alert (sw("txtInvalidMACAddress") + " "+form_handle.l2tp_mac_cloning_address.value + ".");
			return;
		}
		if(form_handle.l2tp_mac_cloning_address.value == "00:00:00:00:00:00") {
			form_handle.l2tp_mac_cloning_enabled.value = "false";
		}			
		else
		{
			form_handle.l2tp_mac_cloning_enabled.value = "true";	
		}
		mac_addr = form_handle.l2tp_mac_cloning_address.value.split(":");					
		form_handle.l2tp_mac_clone.value = "";
		for(var i=0;i<mac_addr.length;i++)
		{
			form_handle.l2tp_mac_clone.value += mac_addr[i];
		}	
	
	}

//check wireless setting
	form_handle.wireless_SSID.value = trim_string(form_handle.wireless_SSID.value);
	if (is_blank(form_handle.wireless_SSID.value))
	{
		alert(sw("txtSSIDBlank"));
		form_handle.wireless_SSID.select();
		form_handle.wireless_SSID.focus();
		return false;
	}
	if(form_handle.security_type_radio_1.checked)
	{
		var keyvalue = form_handle.wlan_password.value;
		var key_len = keyvalue.length;		
		var test_char, i;
		if (key_len < 8 || key_len > 64)
		{
			alert(sw("txtWizard_WlanStr1"));
			return false;
		}
		if(key_len >= 8 && key_len < 64)
		{
			if(keyvalue.charAt(0) == ' '|| keyvalue.charAt(key_len-1) == ' ')
			{
				alert(sw("txtheadtailnospeace"));
				return false;
			}
		} 	
		if(key_len == 64)
		{	
			for(i=0; i<key_len; i++)
			{
				test_char=keyvalue.charAt(i);
				if( (test_char >= '0' && test_char <= '9') ||
					(test_char >= 'a' && test_char <= 'f') ||
					(test_char >= 'A' && test_char <= 'F'))
					continue;
				alert(sw("txtWPAKeyHexadecimalDigits"));
				return false;
			}
		}
		else
		{
			if(strchk_unicode(keyvalue))
			{
				alert(sw("txtWizard_WlanStrerr"));
				return false;
			}		
		}	
	}
return true;
}
function page_prev() 
{
	self.location.href="Wizard_Easy_Welcome.asp?t="+new Date().getTime();
}
function page_next() 
{
	self.location.href="Wizard_Easy_SetPassword.asp?t="+new Date().getTime();
}
function pppoe_reconnect_selector(mode)
{
	mode = mode * 1;
    // 0 = Always on, 1 = On demand, 2 = Manual
    get_by_id("pppoe_reconnect_mode").value = mode;
    switch(mode)
    {
         case 0:
             get_by_id("pppoe_reconnect_mode_radio_0").checked = true;
			 get_by_id("ppp_schedule_control_0").value = "Always";
     	     break;
         case 1:
             get_by_id("pppoe_reconnect_mode_radio_1").checked = true;
             break;
    }
}
function page_load() 
{
	if(LangCode == "SC")
	{
		get_by_id("wan_type").options.add(new Option("DHCP+",9));
		get_by_id("pppoe_netsniper").checked = get_by_id("h_pppoe_netsniper").value === "true" ? true : false;
		get_by_id("pppoe_xkjs").checked = get_by_id("h_pppoe_xkjs").value === "true" ? true : false;
			if(get_by_id("pppoe_netsniper").checked) {
                	get_by_id("h_pppoe_xkjs").value = false;

					get_by_id("pppoe_netsniper").disabled = false;

                	get_by_id("pppoe_xkjs").checked = false;
                	get_by_id("pppoe_xkjs").disabled = true;
					
                	get_by_id("pppoeplus").checked = false;
                	get_by_id("pppoeplus").disabled = true;
        	} else if(get_by_id("pppoe_xkjs").checked){
					get_by_id("pppoe_netsniper").checked = false;
					get_by_id("pppoe_netsniper").disabled = true;
					
					get_by_id("pppoe_xkjs").disabled = false;

                	get_by_id("pppoeplus").checked = false;
                	get_by_id("pppoeplus").disabled = true;
        	}else if(get_by_id("h_pppoe_xkjs").value == "false" && get_by_id("xkjs_mode").value == "4")
			{
					get_by_id("pppoe_netsniper").checked = false;
					get_by_id("pppoe_netsniper").disabled = true;

                	get_by_id("pppoe_xkjs").checked = false;
                	get_by_id("pppoe_xkjs").disabled = true;

                	get_by_id("pppoeplus").checked = true;
                	get_by_id("pppoeplus").disabled = false;
					
			}else
			{
					get_by_id("pppoe_netsniper").checked = false;
					get_by_id("pppoe_netsniper").disabled = false;

                	get_by_id("pppoe_xkjs").checked = false;
                	get_by_id("pppoe_xkjs").disabled = false;

                	get_by_id("pppoeplus").checked = false;
                	get_by_id("pppoeplus").disabled = false;
			
			}

		update_xkjs_mode_list(get_by_id("xkjs_mode").value);
	}
	else if(LangCode == "TW")
	{
		if(get_by_id("pppoe_reconnect_mode").value == 0 && get_by_id("ppp_schedule_control_0").value == "Always")
		{
			get_by_id("pppoe_reconnect_mode").value = 0;
		}
		else
		{
			get_by_id("pppoe_reconnect_mode").value = 1;
		}
		pppoe_reconnect_selector(get_by_id("pppoe_reconnect_mode").value);
	}
	get_by_id("wlan_password").value = "<%getInfo("pskValue");%>";
	mf = document.forms[0];
	wan_pptp_use_dynamic_carrier_selector(mf.wan_pptp_use_dynamic_carrier.value);
	wan_l2tp_use_dynamic_carrier_selector(mf.wan_l2tp_use_dynamic_carrier.value);
	var str1 = self.location.href.split('&');
	if(str1[1]!=null)
	{
		var str2 = str1[1].substring(5,6);
			
		str2 = str2 *1;	
		if(str2== 1 ||str2== 2 ||str2== 0)
		{
			on_change_wan_type(str2);
		}
		else
		{
			on_change_wan_type(2);
		}
		get_by_id("auto_show").style.display = "";
		if(str2 == 1)
		{
			document.getElementById("auto_show_result").innerHTML = sw("txtDynamicIP");
		}
		else if(str2 == 0)
		{
			document.getElementById("auto_show_result").innerHTML = sw("txtStaticIP");
			document.getElementById("show_tip").innerHTML = sw("txtWizardEasyStepChooseBelow");
		}
		else
		{
			document.getElementById("auto_show_result").innerHTML = sw("txtPPPOE");
		}
	}
	else
	{
		on_change_wan_type(wan_type);
		get_by_id("auto_show").style.display = "none";
	}
	get_by_id("wireless_SSID").value == ssid;
	if(wpa_enabled == "true")
	{
		on_change_security_type(1);
		mf.wlan_password.value = wlan_key;
	}
	else
	{
		on_change_security_type(0);
	}
/*	var lan_mac_addr = "<% getInfo("lanMacAddr"); %>";

	if(get_by_id("wireless_SSID").value == "dlink")
	{
			get_by_id("wireless_SSID").value = "dlink-"+lan_mac_addr.substring(12,14)+lan_mac_addr.substring(15,17);
	}
*/

}
function save_network_selector(value) 
{
	var mf = document.forms.wz_form_pg_4;
	mf.save_network_enabled.value = value;
}
function page_submit()
{
	get_by_id("settingsChanged").value = 1;
	if(wz_verify_4() == true)
	{
		get_by_id("curTime").value = new Date().getTime();
//		var f = document.forms[0];	
//		var str1 = self.location.href.split('&');		
		document.wz_form_pg_4.submit();
	}
}

function page_cancel()
{
	if (is_form_modified("wz_form_pg_4") || get_by_id("settingsChanged").value == 1)
	{
		if (confirm (sw("txtAbandonAallChanges")))
		{
			top.location='../logout.asp?t='+new Date().getTime();
		}
	}
	else
	{
		top.location='../logout.asp?t='+new Date().getTime();
	}			
}

function print_keys()
{
	var mf = document.forms.wz_form_pg_4;
	if(mf.auto_passwd_select.checked == true)
	{
		mf.wlan_password.value = "<%getIndexInfo("autokey-15");%>"
	}
	else
	{
		mf.wlan_password.value = "";
	}
}

function auto_password_selector(value) 
{
	var mf = document.forms.wz_form_pg_4;
	mf.auto_password_enabled.value = (value == true) ? "true" : "false";
	mf.auto_passwd_select.checked = value;
	print_keys();
}

function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
	document.title = DOC_Title;
	get_by_id("l2tp_clone_mac_addr").value = sw("txtWizardEasyStepCopyMAC");
	get_by_id("pptp_clone_mac_addr").value = sw("txtWizardEasyStepCopyMAC");
	set_form_default_values("wz_form_pg_4");
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
var productModel="<%getInfo("productModel")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = productModel;
page_load();
RenderWarnings();
}			
//]]>
</script>
</head>
<body onload="template_load(); init();web_timeout();">
<div id="loader_container" onclick="return false;" style="display: none">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td>
<SCRIPT language=javascript type=text/javascript>
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td><td id="maincontent_container">
<div id="maincontent_1col" style="display: block">

<div id="wz_page_4" style="display:block">
<form id="wz_form_pg_4" name="wz_form_pg_4" action="http://<% getInfo("goformIpAddr"); %>/goform/formEasySetupWWConfig" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" name="config.wan_force_static_dns_servers" id="wan_force_static_dns_servers" value="false" />
<input type="hidden" name="config.wan_l2tp_use_dynamic_carrier" id="wan_l2tp_use_dynamic_carrier" value="<%getIndexInfo("l2tp_wan_ip_mode");%>" />
<input type="hidden" name="config.wan_pptp_use_dynamic_carrier" id="wan_pptp_use_dynamic_carrier" value="<%getIndexInfo("pptp_wan_ip_mode");%>" />
<input type="hidden" id="pptp_mac_cloning_enabled" name="config.pptp_mac_cloning_enabled" value="true"/>
<input type="hidden" id="l2tp_mac_cloning_enabled" name="config.l2tp_mac_cloning_enabled" value="true"/>
<input type="hidden" id="pptp_mac_clone" name="pptp_mac_clone" value=""/>
<input type="hidden" id="l2tp_mac_clone" name="l2tp_mac_clone" value=""/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="h_pppoe_netsniper" name="config.pppoe_netsniper" value="<% getInfo("pppNetSniper"); %>"/>
<input type="hidden" id="xkjs_mode" name="config.xkjs_mode" value="<% getInfo("pppXkjs"); %>" />
<input type="hidden" id="h_pppoe_xkjs" name="config.pppoe_xkjs" value="<% getInfo("pppXkjs_on-of"); %>"/>
<input type="hidden" name="config.pppoe_reconnect_mode" id="pppoe_reconnect_mode" value="<% getInfo("pppConnectType"); %>" />
<input id="ppp_schedule_control_0" name="ppp_schedule_control_0" value="<%getIndexInfo("wanPPPoESchSelectName");%>" type="hidden">
<input type="hidden" id="wireless_ieee8021x_enabled" name="config.wireless.ieee8021x_enabled" value="<%getIndexInfo("wpa_enterprise_enabled");%>" />
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasy113Step1");</SCRIPT></h1>
		<br>
	<fieldset id="legend_show">
		<legend><SCRIPT>ddw("txtInternetConnection");</SCRIPT></legend>
		<table align="center" width="600">
		<tr><td colspan="2" align="center"><font color="#0000FF"><B><span id="show_tip"></span></B></font></td></tr>
		<tr id=auto_show style="display:none">
			<td class=br_tb width="40%" height="25" valign="middle"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepResultOfDetect");</SCRIPT></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<font color="#000000"><span id="auto_show_result"></span></font>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtInternetConnection");</SCRIPT></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
			  <select id="wan_type" onchange="on_change_wan_type(this.value)" name="config.wan_type" style="width:120px">
                <option value = 0>
                  <script language=javascript type=text/javascript>ddw("txtStaticIP");</script>
                  </option>
                <option value = 1>
                  <script language=javascript type=text/javascript>ddw("txtDynamicIP");</script>
                  </option>
                <option value = 2>
                  <script language=javascript type=text/javascript>ddw("txtPPPOE");</script>
                  </option>
                <option value = 3>
                  <script language=javascript type=text/javascript>ddw("txtPPTP");</script>
                  </option>
                <option value = 4>
                  <script language=javascript type=text/javascript>ddw("txtL2TP");</script>
                  </option>
              </select>	
         <a href="../Help/What.asp" onclick="return jump_if();" style="color:#0000FF"><SCRIPT >ddw("txtWizardWhat");</SCRIPT></a>		 
			  </td>
		</tr>
		</table>
		
		<!--pppoe mode-->
		<div id=pppoe_setting style="DISPLAY:none ">
		<table align="center" width="600">
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtUserName");</SCRIPT></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type=text id="pppoe_username" name="config.pppoe_username" size=30 maxlength=255 value="<% getWizardInformation("pppUserName"); %>"><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type=password id="pppoe_password" name="config.pppoe_password" size=30 maxlength=255 value="<% getInfo("pppPassword_easysetup"); %>">
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtVerifyPassword");</SCRIPT></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type=password id="second_pppoe_password" size=30 maxlength=255 value="<% getInfo("pppPassword_easysetup"); %>">
			</td>
		</tr>
		<tr id="tr_connect_mode" style="display:none">
			<td class=br_tb width="40%"><font color="#000000"><B><script>ddw("txtReconnectMode");</script></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
			<input type="radio" name="pppoe_reconnect_mode_radio" id="pppoe_reconnect_mode_radio_0" value="0" onclick="pppoe_reconnect_selector(this.value);">
			<font color="#000000"><B><SCRIPT >ddw("txtWizardEasyStepAllwaysTW");</SCRIPT></B></font><br />
			&nbsp;&nbsp;
			<input type="radio" name="pppoe_reconnect_mode_radio" id="pppoe_reconnect_mode_radio_1" value="1" onclick="pppoe_reconnect_selector(this.value);">
			<font color="#000000"><B><SCRIPT >ddw("txtWizardEasyStepOnCammandTW");</SCRIPT></B></font>
			</td>
		</tr>
		<tr>
		</tr>
		<tr id="tr_sniper" style="display:none">
			<td class=br_tb width="40%"><input type="checkbox" id="pppoe_netsniper" onclick="on_click_sniper();"></td>
			<td ><font color="#000000"><B>:</B></font>&nbsp;
				<font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepSupportSniper");</SCRIPT></B></font>
			</td>
		</tr>
		<tr id="tr_xkjs" style="display:none">
			<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT >ddw("txtXkjs2");</SCRIPT></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<select id="xkjs_mode_select" onchange="xkjs_mode_selector(this.value);" />
			</td>
		</tr>
		<tr id="tr_xkjs_select" style="display:none">
			<td class=br_tb width="40%"><input type="checkbox" id="pppoe_xkjs" onclick="on_click_xkjs();"></td>
			<td ><font color="#000000"><B>:</B></font>&nbsp;
				<font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepSupportXKJS");</SCRIPT></B></font>
			</td>	
		</tr>
		<tr id="tr_pppoeplus_select" style="display:none">
			<td class=br_tb width="40%"><input type="checkbox" id="pppoeplus" onclick="on_click_pppoeplus();"></td>
			<td ><font color="#000000"><B>:&nbsp;
				PPPoE+</B></font>
			</td>	
		</tr>
		</table>
		</div>
		<!--static mode-->
	<div id=static_setting style="DISPLAY:none ">
			<table align="center" width="600">
			<tr>
				<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtIPAddress");</SCRIPT></B></font></td>
				<td><font color="#000000"><B>:</B></font>&nbsp;
					<input type=text id="wan_ip_address" name="config.wan_ip_address" size=30 maxlength=15 value="<% getWizardInformation("wan-ip-rom");%>"><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
				</td>
			</tr>
			<tr>
				<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtSubnetMask");</SCRIPT></B></font></td>
				<td><font color="#000000"><B>:</B></font>&nbsp;
					<input type=text id="wan_subnet_mask"  name="config.wan_subnet_mask" size=30 maxlength=15 value="<% getWizardInformation("wan-mask-rom");%>">
				</td>
			</tr>
			<tr>
				<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtGatewayAddress");</SCRIPT></B></font></td>
				<td><font color="#000000"><B>:</B></font>&nbsp;
					<input type=text id="wan_gateway" name="config.wan_gateway"  size=30 maxlength=15 value="<% getWizardInformation("wan-gateway-rom");%>">
				</td>
			</tr>
			<tr>
				<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtPrimaryDNSServer");</SCRIPT></B></font></td>
				<td><font color="#000000"><B>:</B></font>&nbsp;
					<input type=text id="wan_primary_dns" name="config.wan_primary_dns" size=30 maxlength=15 value="<% getWizardInformation("wan-dns1");%>">
				</td>
			</tr>
			<tr>
				<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtSecondaryDNSServer");</SCRIPT></B></font></td>
				<td><font color="#000000"><B>:</B></font>&nbsp;
					<input type=text id="wan_secondary_dns" name="config.wan_secondary_dns" size=30 maxlength=15 value="<% getWizardInformation("wan-dns2");%>">
				</td>
			</tr>
			</table>	
			</div>
		<!--pptp mode-->
		<div id=pptp_setting style="DISPLAY:none ">
		<table align="center" width="600">
		<tr>
			<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepAddressMode");</SCRIPT></B></font></td><!--show Address Mode-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input id="wan_pptp_use_dynamic_carrier_radio_1" type="radio" name="wan_pptp_use_dynamic_carrier_radio" value="true" onclick="wan_pptp_use_dynamic_carrier_selector(this.value);"/><label><font color="#000000"><SCRIPT >ddw("txtDynamicIP");</SCRIPT></font></label>
				<input id="wan_pptp_use_dynamic_carrier_radio_0" type="radio" name="wan_pptp_use_dynamic_carrier_radio" value="false" onclick="wan_pptp_use_dynamic_carrier_selector(this.value);"/><label><font color="#000000"><SCRIPT >ddw("txtStaticIP");</SCRIPT></font></label>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPPTPIPAddr");</SCRIPT></B></font></td><!--show PPTP IP Address-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_pptp_ip_address" size="30" maxlength="15" value="<% getInfo("pptpIp"); %>" name="config.wan_pptp_ip_address"/><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPPTPNetmask");</SCRIPT></B></font></td><!--show PPTP Subnet Mask-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_pptp_subnet_mask" size="30" maxlength="15" value="<% getInfo("pptpSubnet"); %>" name="config.wan_pptp_subnet_mask"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPPTPGateWay");</SCRIPT></B></font></td><!--show PPTP Gateway IP Address-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_pptp_gateway" size="30" maxlength="15" value="<% getInfo("pptp-wan-gateway-rom");%>" name="config.wan_pptp_gateway"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPPTPServerAddr");</SCRIPT></B></font></td><!--show PPTP Server IP Address-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_pptp_server" size="30" maxlength="15" value="<% getInfo("pptpServerIp"); %>" name="config.wan_pptp_server"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtUserName");</SCRIPT></B></font></td><!--show Username-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_pptp_username" size="30" maxlength="63" value="<% getInfo("pptpUserName"); %>" name="config.wan_pptp_username"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT></B></font></td><!--show Password-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="password" id="wan_pptp_password" size="30" maxlength="63" onfocus="select();" value="<% getInfo("pptpPassword"); %>" name="config.wan_pptp_password"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtPrimaryDNSServer");</SCRIPT></B></font></td><!--show Primary DNS Server-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_pptp_primary_dns" size="30" maxlength="15" value="<% getInfo("wan-dns1");%>" name="config.wan_pptp_primary_dns"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtSecondaryDNSServer");</SCRIPT></B></font></td><!--show Secondary DNS Server-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_pptp_primary_dns2" size="30" maxlength="15" value="<% getInfo("wan-dns2");%>" name="config.wan_pptp_primary_dns2"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtMACAddress");</SCRIPT></B></font></td><!--show MAC Address-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="pptp_mac_cloning_address" size="30" maxlength="17" value="<% getInfo("wanMac"); %>" name="config.pptp_mac_cloning_address" /> 
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%">&nbsp;</td><!--show MAC Address button-->
			<td>&nbsp;&nbsp;
				<input class="button_submit" type="button" id="pptp_clone_mac_addr" value="" onclick="pptp_clone_mac();" />
			</td>
		</tr>
		</table>
		</div>
		<!--l2tp mode-->
		<div id=l2tp_setting style="DISPLAY:none ">
		<table align="center" width="600">
		<tr>
			<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepAddressMode");</SCRIPT></B></font></td><!--show Address Mode-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input id="wan_l2tp_use_dynamic_carrier_radio_1" type="radio" name="wan_l2tp_use_dynamic_carrier_radio" value="true" onclick="wan_l2tp_use_dynamic_carrier_selector(this.value);"/>
				<label><font color="#000000"><SCRIPT >ddw("txtDynamicIP");</SCRIPT></font></label> 
				<input id="wan_l2tp_use_dynamic_carrier_radio_0" type="radio" name="wan_l2tp_use_dynamic_carrier_radio" value="false" onclick="wan_l2tp_use_dynamic_carrier_selector(this.value);"/>
				<label><font color="#000000"><SCRIPT >ddw("txtWizardEasyStepStaticIp");</SCRIPT></font></label> 
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepL2TPIp");</SCRIPT></B></font></td><!--Show L2TP IP Address-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_l2tp_ip_address" size="20" maxlength="15" value="<% getIndexInfo("l2tpIp"); %>" name="config.wan_l2tp_ip_address"/><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepL2tpmask");</SCRIPT></B></font></td><!--Show L2TP Subnet Mask-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_l2tp_subnet_mask" size="20" maxlength="15" value="<% getIndexInfo("l2tpSubnet"); %>" name="config.wan_l2tp_subnet_mask"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepL2tpGateway");</SCRIPT></B></font></td><!--Show L2TP Gateway IP Address-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_l2tp_gateway" size="20" maxlength="15" value="<% getInfo("l2tp-wan-gateway-rom");%>" name="config.wan_l2tp_gateway"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepL2tpServeraddr");</SCRIPT></B></font></td><!--Show L2TP Server IP Address-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_l2tp_server" size="20" maxlength="15" value="<% getIndexInfo("l2tpServerIp"); %>" name="config.wan_l2tp_server"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtL2TPUserName");</SCRIPT></B></font></td><!--Show Username-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_l2tp_username" size="20" maxlength="63" value="<% getIndexInfo("l2tpUserName"); %>" name="config.wan_l2tp_username"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtL2TPPassword");</SCRIPT></B></font></td><!--Show Password-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="password" id="wan_l2tp_password" size="20" maxlength="63" onfocus="select();" value="<% getIndexInfo("l2tpPassword"); %>" name="config.wan_l2tp_password"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtPrimaryDNSServer");</SCRIPT></B></font></td><!--Show Primary DNS Server-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_l2tp_primary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns1");%>" name="config.wan_l2tp_primary_dns"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtSecondaryDNSServer");</SCRIPT></B></font></td><!--Show Secondary DNS Server-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_l2tp_primary_dns2" size="20" maxlength="15" value="<% getInfo("wan-dns2");%>" name="config.wan_l2tp_primary_dns2"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtMACAddress");</SCRIPT></B></font></td><!--Show MAC Address-->
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="l2tp_mac_cloning_address" size="20" maxlength="17" value="<% getInfo("wanMac"); %>" name="config.l2tp_mac_cloning_address" />
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%">&nbsp;</td><!--Show MAC Address-->
			<td>&nbsp;&nbsp;
				<input class="button_submit" type="button" id="l2tp_clone_mac_addr" value="" onclick="l2tp_clone_mac();" />
			</td>
		</tr>
		</table>
		</div>
		<!--dhcpplus mode-->
		<div id=dhcpplus_setting style="DISPLAY:none ">
		<table align="center" width="600">
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtUserName");</SCRIPT></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="text" id="wan_dhcpplus_username" size="25" maxlength="39" value="<% getInfo("pppUserName"); %>" name="config.wan_dhcpplus_username"/><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>	
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><font color="#000000"><B><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT></B></font></td>
			<td><font color="#000000"><B>:</B></font>&nbsp;
				<input type="password" id="wan_dhcpplus_password" size="25" maxlength="39" value="<% getInfo("pppPassword"); %>" name="config.wan_dhcpplus_password"/>
			</td>
		</tr>	
		</table>
		</div>	
		</fieldset>	
		<br>	
		<fieldset id="legend_show">
		<legend><SCRIPT>ddw("txtWirelessSettings");</SCRIPT></legend>
		<div>
		<table align="center" width="600">
		<tr>
			<td class="r_tb" width=198><font color="#000000"><B><SCRIPT>ddw("txtWizardEasySSID");</SCRIPT></B></font>&nbsp;:&nbsp;</td>
			<td width="300" class="l_tb"><input type="text" id="wireless_SSID" name="config.wireless.SSID" size="20" maxlength="32" value="<%getInfo("ssid");%>"></td>
</tr>
		<tr>
			<td class="r_tb"><font color="#000000"><B><SCRIPT>ddw("txtSecurityMode");</SCRIPT></B></font>&nbsp;:&nbsp;</td>
			<td class="l_tb"><input id="security_type_radio_0" type="radio" name="security_type_radio" value="0" onclick="on_change_security_type(this.value);"><font color="#000000"><SCRIPT>ddw("txtWizardEasyStepCloseSecuity");</SCRIPT></font></td>
		</tr>
		<tr>
			<td class="r_tb"></td>
			<td class="l_tb"><input id="security_type_radio_1" type="radio" name="security_type_radio" value="1" onclick="on_change_security_type(this.value);"><font color="#000000"><SCRIPT>ddw("txtWizardEasyStepAutoWPA");</SCRIPT></font></td>
		</tr>
		<tr>
			<td class="r_tb" width=198><font color="#000000"><B><SCRIPT>ddw("txtPreSharedKey");</SCRIPT></B></font>&nbsp;:&nbsp;</td>
			<td width="300" class="l_tb"><input type=text id="wlan_password" name="config.wlan_password" size=63 maxlength=15 ></td>
		</tr>
		<tr>
			<td class="r_tb" width=198><input type="hidden" id="auto_password_enabled" name="config.auto_password_enabled" value="false"><input type="checkbox" id="auto_passwd_select" onclick="auto_password_selector(this.checked)">&nbsp;:&nbsp;</td>
			<td width="300" class="l_tb"><font color="#000000"><SCRIPT>ddw("txtWizardEasyStepProductKey");</SCRIPT></font></td>
		</tr>
		</table>
		</fieldset>			
		<br>
<!--		<table align="center" width="600">
		<tr><td align="right" width="40%" height=22><input type="hidden" id="save_network_enabled" name="config.save_network_enabled" value=""><input type="checkbox" id="saveNetwork_select" onclick="save_network_selector(this.checked)"></td><td>&nbsp;<font color="#000000"><B><SCRIPT>ddw("txtWizardEasyStepSaveMyconfig");</SCRIPT></B></font></td>
		</tr>
		</table>
-->		<br>
		<center><script>prev();next();</script></center>
		<br>
</div></form>
</div><!-- wz_page_2 --></div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
