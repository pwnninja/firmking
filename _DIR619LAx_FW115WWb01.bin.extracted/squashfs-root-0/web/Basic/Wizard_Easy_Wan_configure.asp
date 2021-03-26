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
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
var pcmac;
var remote_login;
var lan_ip_str = "<% getInfo("ip-rom"); %>";
var lan_mask_str = "<% getInfo("mask-rom"); %>";
//<![CDATA[

function next(fn)
{
	document.write("<input type='button' name='next' value=\""+sw("txtConnect")+"\" onClick='return "+fn+"'>&nbsp;");
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
		document.getElementById("show_error").innerHTML = sw("txtWizardEasyStepChooseBelow");
	}
	else if(selectValue == 1)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "none";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "none";
		get_by_id("dhcpplus_setting").style.display = "none";
		document.getElementById("show_error").innerHTML = "";
	}
	else if(selectValue == 2)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "none";
		get_by_id("dhcpplus_setting").style.display = "none";	
		document.getElementById("show_error").innerHTML = sw("txtWizardEasyStepFillAndPressButton");
		if(LangCode == "SC")
		{
			get_by_id("tr_sniper").style.display = "";
			get_by_id("tr_xkjs").style.display = "none";
			get_by_id("tr_xkjs_select").style.display = "";
			get_by_id("tr_pppoeplus_select").style.display = "";
			document.getElementById("show_error").innerHTML = sw("txtWizardEasyStepUseSniper");
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
		document.getElementById("show_error").innerHTML = sw("txtWizardEasyStepChooseBelow");
	}
	else if(selectValue == 4)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "none";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "";
		get_by_id("dhcpplus_setting").style.display = "none";
		document.getElementById("show_error").innerHTML = sw("txtWizardEasyStepChooseBelow");
	}
	else if(selectValue == 9)
	{
		get_by_id("static_setting").style.display = "none";
		get_by_id("pppoe_setting").style.display = "none";
		get_by_id("pptp_setting").style.display = "none";
		get_by_id("l2tp_setting").style.display = "none";
		get_by_id("dhcpplus_setting").style.display = "";
		document.getElementById("show_error").innerHTML = sw("txtWizardEasyStepUseSniper");
	}
}
function wan_l2tp_use_dynamic_carrier_selector(mode){
	var mf = document.forms.wz_form_pg_5;
	mf.wan_l2tp_use_dynamic_carrier.value = mode;
	if(mode == "true") {
		mf.wan_l2tp_use_dynamic_carrier_radio_1.checked = true;
		mf.wan_l2tp_ip_address.disabled = true;
		mf.wan_l2tp_subnet_mask.disabled = true;
		mf.wan_l2tp_gateway.disabled = true;
		mf.wan_l2tp_primary_dns.disabled = true;
		mf.wan_l2tp_primary_dns2.disabled = true;
	} else {
		mf.wan_l2tp_use_dynamic_carrier_radio_0.checked = true;
		mf.wan_l2tp_ip_address.disabled = false;
		mf.wan_l2tp_subnet_mask.disabled = false;
		mf.wan_l2tp_gateway.disabled = false;
		mf.wan_l2tp_primary_dns.disabled = false;
		mf.wan_l2tp_primary_dns2.disabled = false;
	}
}
function pptp_clone_mac() {
	var mf = document.forms.wz_form_pg_5;
	mf.pptp_mac_cloning_address.value = pcmac;
	mf.pptp_mac_cloning_enabled.value = "true";
}
function l2tp_clone_mac() {
	var mf = document.forms.wz_form_pg_5;
	mf.l2tp_mac_cloning_address.value = pcmac;
	mf.l2tp_mac_cloning_enabled.value = "true";
}
function wan_pptp_use_dynamic_carrier_selector(mode)
{
	var mf = document.forms.wz_form_pg_5;
	mf.wan_pptp_use_dynamic_carrier.value = mode;
	if(mode == "true") {
		mf.wan_pptp_use_dynamic_carrier_radio_1.checked = true;
		mf.wan_pptp_ip_address.disabled = true;	
		mf.wan_pptp_subnet_mask.disabled = true;
		mf.wan_pptp_gateway.disabled = true;
		mf.wan_pptp_primary_dns.disabled = true;
		mf.wan_pptp_primary_dns2.disabled = true;
	} else {
		mf.wan_pptp_use_dynamic_carrier_radio_0.checked = true;
		mf.wan_pptp_ip_address.disabled = false;
		mf.wan_pptp_subnet_mask.disabled = false;
		mf.wan_pptp_gateway.disabled = false;
		mf.wan_pptp_primary_dns.disabled = false;
		mf.wan_pptp_primary_dns2.disabled = false;
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
function wz_verify_5()
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
	if (form_handle.second_pppoe_password.value !== form_handle.pppoe_password.value) {
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
	if (!is_ipv4_valid(form_handle.wan_ip_address.value) || form_handle.wan_ip_address.value=="0.0.0.0" || is_FF_IP(form_handle.wan_ip_address.value)) {
		alert(sw("txtInvalidIPAddress"));
		form_handle.wan_ip_address.select();
		form_handle.wan_ip_address.focus();
		return false;
	}
	if (!is_ipv4_valid(form_handle.wan_subnet_mask.value) || !is_mask_valid(form_handle.wan_subnet_mask.value)) {
		alert(sw("txtInvalidSubnetMask"));
		form_handle.wan_subnet_mask.select();
		form_handle.wan_subnet_mask.focus();
		return false;
	}
	if (!is_ipv4_valid(form_handle.wan_gateway.value) || form_handle.wan_gateway.value=="0.0.0.0" || is_FF_IP(form_handle.wan_gateway.value)) {
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
		
	if (!is_ipv4_valid(form_handle.wan_primary_dns.value) || form_handle.wan_primary_dns.value=="0.0.0.0" || is_FF_IP(form_handle.wan_primary_dns.value) || ((ipv4_to_unsigned_integer(form_handle.wan_primary_dns.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(form_handle.wan_primary_dns.value) & 0x000000FF) == 0x00000000   )) {
		alert(sw("txtInvalidPrimaryDNSAddress"));
		form_handle.wan_primary_dns.select();
		form_handle.wan_primary_dns.focus();
		return false;
	}
	if (!is_ipv4_valid(form_handle.wan_secondary_dns.value) || is_FF_IP(form_handle.wan_secondary_dns.value) || ((ipv4_to_unsigned_integer(form_handle.wan_secondary_dns.value) & 0xFF000000) != 0x00000000 && (ipv4_to_unsigned_integer(form_handle.wan_secondary_dns.value) & 0x000000FF) == 0x00000000   )) {
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
return true;
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

	
	var str1 = self.location.href.split('&');
	var str2 = str1[1].substring(5,6);
	var oldmac;
	
	mf = document.forms[0];	
	
	remote_login = false;
	pcmac = "<% getInfo("host-hwaddr"); %>";
	remote_login = (pcmac == "00:00:00:00:00:00") ? true : false;
	wan_pptp_use_dynamic_carrier_selector(mf.wan_pptp_use_dynamic_carrier.value);
	wan_l2tp_use_dynamic_carrier_selector(mf.wan_l2tp_use_dynamic_carrier.value);
	on_change_wan_type(str2);
	str2 = str2 *1;	
	mf.wan_type.value = str2;
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

	if(str1[2] != null)
	{
		if(str2 == '0'||str2 == '3'||str2 == '4')
		{
			document.getElementById("show_error").innerHTML = sw("txtWizardEasyStepCannotPushBelow");
		}
		if(str2 == '2'||str2 == '9')
		{
			document.getElementById("show_error").innerHTML = sw("txtWizardEasyStepNameIncorrect");
		}
	}

}
function page_submit()
{

if (is_form_modified("wz_form_pg_5"))  //something changed
{
	get_by_id("settingsChanged").value = 1;
}
if(wz_verify_5() == true){
	get_by_id("curTime").value = new Date().getTime();
	//wz_form_pg_5.submit();
	var f = document.forms[0];	
	var str1 = self.location.href.split('&');
	if(str1[2] != null)
	{
		var str3 = str1[2].substring(5,6);
		f.tryTime.value = str3;
	}		
	document.wz_form_pg_5.submit();
	}
}

function page_cancel()
{
if (is_form_modified("wz_form_pg_5") || get_by_id("settingsChanged").value == 1) {
	if (confirm (sw("txtAbandonAallChanges"))) {
		top.location='../logout.asp?t='+new Date().getTime();
	}
} else {
		top.location='../logout.asp?t='+new Date().getTime();
}			
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
document.title = DOC_Title;
get_by_id("l2tp_clone_mac_addr").value = sw("txtWizardEasyStepCopyMAC");
get_by_id("pptp_clone_mac_addr").value = sw("txtWizardEasyStepCopyMAC");
set_form_default_values("wz_form_pg_5");
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

<div id="wz_page_5" style="display:block">
<form id="wz_form_pg_5" name="wz_form_pg_5" action="http://<% getInfo("goformIpAddr"); %>/goform/formEasySetupWizard2" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" name="config.wan_force_static_dns_servers" id="wan_force_static_dns_servers" value="false" />
<input type="hidden" name="config.wan_l2tp_use_dynamic_carrier" id="wan_l2tp_use_dynamic_carrier" value="<%getIndexInfo("l2tp_wan_ip_mode");%>" />
<input type="hidden" name="config.wan_pptp_use_dynamic_carrier" id="wan_pptp_use_dynamic_carrier" value="<%getIndexInfo("pptp_wan_ip_mode");%>" />
<input type="hidden" id="pptp_mac_cloning_enabled" name="config.pptp_mac_cloning_enabled" value="true"/>
<input type="hidden" id="l2tp_mac_cloning_enabled" name="config.l2tp_mac_cloning_enabled" value="true"/>
<input type="hidden" id="pptp_mac_clone" name="pptp_mac_clone" value=""/>
<input type="hidden" id="l2tp_mac_clone" name="l2tp_mac_clone" value=""/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="tryTime" name="tryTime" value="1"/>
<input type="hidden" id="h_pppoe_netsniper" name="config.pppoe_netsniper" value="<% getInfo("pppNetSniper"); %>"/>
<input type="hidden" id="xkjs_mode" name="config.xkjs_mode" value="<% getInfo("pppXkjs"); %>" />
<input type="hidden" id="h_pppoe_xkjs" name="config.pppoe_xkjs" value="<% getInfo("pppXkjs_on-of"); %>"/>
<input type="hidden" name="config.pppoe_reconnect_mode" id="pppoe_reconnect_mode" value="<% getInfo("pppConnectType"); %>" />
<input id="ppp_schedule_control_0" name="ppp_schedule_control_0" value="<%getIndexInfo("wanPPPoESchSelectName");%>" type="hidden">
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStep2");</SCRIPT></h1>
		<br>
		<font color="#0000FF"><div id="show_error" align="center"></div></font>
		<br>
		<div>
		<table width="100%">
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtInternetConnection");</SCRIPT></td>
			<td>:&nbsp;
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
		</div>
		
		<div id=pppoe_setting style="DISPLAY: none">
		<table width="100%">
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtUserName");</SCRIPT></td>
			<td>:&nbsp;
				<input type=text id="pppoe_username" name="config.pppoe_username" size=25 maxlength=255 value="<% getWizardInformation("pppUserName"); %>"><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT></td>
			<td>:&nbsp;
				<input type=password id="pppoe_password" name="config.pppoe_password" size=25 maxlength=255 value="<% getInfo("pppPassword_easysetup"); %>">
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtVerifyPassword");</SCRIPT></td>
			<td>:&nbsp;
				<input type=password id="second_pppoe_password" size=25 maxlength=255 value="<% getInfo("pppPassword_easysetup"); %>">
			</td>
		</tr>
		<tr id="tr_connect_mode" style="display:none">
			<td class=br_tb width="40%"><script>ddw("txtReconnectMode");</script></td>
			<td>:&nbsp;
			<input type="radio" name="pppoe_reconnect_mode_radio" id="pppoe_reconnect_mode_radio_0" value="0" onclick="pppoe_reconnect_selector(this.value);">
			<SCRIPT >ddw("txtWizardEasyStepAllwaysTW");</SCRIPT><br />
			&nbsp;&nbsp;
			<input type="radio" name="pppoe_reconnect_mode_radio" id="pppoe_reconnect_mode_radio_1" value="1" onclick="pppoe_reconnect_selector(this.value);">
			<SCRIPT >ddw("txtWizardEasyStepOnCammandTW");</SCRIPT>
			</td>
		</tr>
		<tr>
		</tr>
		<tr id="tr_sniper" style="display:none">
			<td class=br_tb width="40%"><input type="checkbox" id="pppoe_netsniper" onclick="on_click_sniper();"></td>
			<td >:&nbsp;
				<SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepSupportSniper");</SCRIPT>
			</td>
		</tr>
		<tr id="tr_xkjs" style="display:none">
			<td class=br_tb width="40%"><SCRIPT >ddw("txtXkjs2");</SCRIPT></td>
			<td>:&nbsp;
				<select id="xkjs_mode_select" onchange="xkjs_mode_selector(this.value);" />
			</td>
		</tr>
		<tr id="tr_xkjs_select" style="display:none">
			<td class=br_tb width="40%"><input type="checkbox" id="pppoe_xkjs" onclick="on_click_xkjs();"></td>
			<td >:&nbsp;
				<SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepSupportXKJS");</SCRIPT>
			</td>	
		</tr>
		<tr id="tr_pppoeplus_select" style="display:none">
			<td class=br_tb width="40%"><input type="checkbox" id="pppoeplus" onclick="on_click_pppoeplus();"></td>
			<td >:&nbsp;
				PPPoE+
			</td>	
		</tr>
		</table>
		</div>
		
		<div id=static_setting style="DISPLAY:none">
		<table width="100%">
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtIPAddress");</SCRIPT></td>
			<td>:&nbsp;
				<input type=text id="wan_ip_address" name="config.wan_ip_address" size=16 maxlength=15 value="<% getWizardInformation("wan-ip-rom");%>"><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtSubnetMask");</SCRIPT></td>
			<td>:&nbsp;
				<input type=text id="wan_subnet_mask"  name="config.wan_subnet_mask" size=16 maxlength=15 value="<% getWizardInformation("wan-mask-rom");%>">
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtGatewayAddress");</SCRIPT></td>
			<td>:&nbsp;
				<input type=text id="wan_gateway" name="config.wan_gateway"  size=16 maxlength=15 value="<% getWizardInformation("wan-gateway-rom");%>">
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtPrimaryDNSServer");</SCRIPT></td>
			<td>:&nbsp;
				<input type=text id="wan_primary_dns" name="config.wan_primary_dns" size=16 maxlength=15 value="<% getWizardInformation("wan-dns1");%>">
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtSecondaryDNSServer");</SCRIPT></td>
			<td>:&nbsp;
				<input type=text id="wan_secondary_dns" name="config.wan_secondary_dns" size=16 maxlength=15 value="<% getWizardInformation("wan-dns2");%>">
			</td>
		</tr>
		</table>	
		</div>	
		
		<!--pptp mode-->
		<div id=pptp_setting style="DISPLAY:none">
		<table width="100%">
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepAddressMode");</SCRIPT></td><!--show Address Mode-->
			<td>:&nbsp;
				<input id="wan_pptp_use_dynamic_carrier_radio_1" type="radio" name="wan_pptp_use_dynamic_carrier_radio" value="true" onclick="wan_pptp_use_dynamic_carrier_selector(this.value);"/><label><SCRIPT >ddw("txtDynamicIP");</SCRIPT></label>
				<input id="wan_pptp_use_dynamic_carrier_radio_0" type="radio" name="wan_pptp_use_dynamic_carrier_radio" value="false" onclick="wan_pptp_use_dynamic_carrier_selector(this.value);"/><label><SCRIPT >ddw("txtStaticIP");</SCRIPT></label>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPPTPIPAddr");</SCRIPT></td><!--show PPTP IP Address-->
			<td>:&nbsp;
				<input type="text" id="wan_pptp_ip_address" size="20" maxlength="15" value="<% getInfo("pptpIp"); %>" name="config.wan_pptp_ip_address"/><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPPTPNetmask");</SCRIPT></td><!--show PPTP Subnet Mask-->
			<td>:&nbsp;
				<input type="text" id="wan_pptp_subnet_mask" size="20" maxlength="15" value="<% getInfo("pptpSubnet"); %>" name="config.wan_pptp_subnet_mask"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPPTPGateWay");</SCRIPT></td><!--show PPTP Gateway IP Address-->
			<td>:&nbsp;
				<input type="text" id="wan_pptp_gateway" size="20" maxlength="15" value="<% getInfo("pptp-wan-gateway-rom");%>" name="config.wan_pptp_gateway"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepPPTPServerAddr");</SCRIPT></td><!--show PPTP Server IP Address-->
			<td>:&nbsp;
				<input type="text" id="wan_pptp_server" size="20" maxlength="15" value="<% getInfo("pptpServerIp"); %>" name="config.wan_pptp_server"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtUserName");</SCRIPT></td><!--show Username-->
			<td>:&nbsp;
				<input type="text" id="wan_pptp_username" size="20" maxlength="63" value="<% getInfo("pptpUserName"); %>" name="config.wan_pptp_username"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT></td><!--show Password-->
			<td>:&nbsp;
				<input type="password" id="wan_pptp_password" size="20" maxlength="63" onfocus="select();" value="<% getInfo("pptpPassword"); %>" name="config.wan_pptp_password"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtPrimaryDNSServer");</SCRIPT></td><!--show Primary DNS Server-->
			<td>:&nbsp;
				<input type="text" id="wan_pptp_primary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns1");%>" name="config.wan_pptp_primary_dns"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtSecondaryDNSServer");</SCRIPT></td><!--show Secondary DNS Server-->
			<td>:&nbsp;
				<input type="text" id="wan_pptp_primary_dns2" size="20" maxlength="15" value="<% getInfo("wan-dns2");%>" name="config.wan_pptp_primary_dns2"/><SCRIPT language=javascript type=text/javascript>ddw("txtOptional");</SCRIPT>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtMACAddress");</SCRIPT></td><!--show MAC Address-->
			<td>:&nbsp;
				<input type="text" id="pptp_mac_cloning_address" size="20" maxlength="17" value="<% getInfo("wanMac"); %>" name="config.pptp_mac_cloning_address" /> 
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
		<div id=l2tp_setting style="DISPLAY:none">
		<table width="100%">
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepAddressMode");</SCRIPT></td><!--show Address Mode-->
			<td>:&nbsp;
				<input id="wan_l2tp_use_dynamic_carrier_radio_1" type="radio" name="wan_l2tp_use_dynamic_carrier_radio" value="true" onclick="wan_l2tp_use_dynamic_carrier_selector(this.value);"/>
				<label><SCRIPT >ddw("txtDynamicIP");</SCRIPT></label> 
				<input id="wan_l2tp_use_dynamic_carrier_radio_0" type="radio" name="wan_l2tp_use_dynamic_carrier_radio" value="false" onclick="wan_l2tp_use_dynamic_carrier_selector(this.value);"/>
				<label><SCRIPT >ddw("txtWizardEasyStepStaticIp");</SCRIPT></label> 
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepL2TPIp");</SCRIPT></td><!--Show L2TP IP Address-->
			<td>:&nbsp;
				<input type="text" id="wan_l2tp_ip_address" size="20" maxlength="15" value="<% getIndexInfo("l2tpIp"); %>" name="config.wan_l2tp_ip_address"/><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepL2tpmask");</SCRIPT></td><!--Show L2TP Subnet Mask-->
			<td>:&nbsp;
				<input type="text" id="wan_l2tp_subnet_mask" size="20" maxlength="15" value="<% getIndexInfo("l2tpSubnet"); %>" name="config.wan_l2tp_subnet_mask"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepL2tpGateway");</SCRIPT></td><!--Show L2TP Gateway IP Address-->
			<td>:&nbsp;
				<input type="text" id="wan_l2tp_gateway" size="20" maxlength="15" value="<% getInfo("l2tp-wan-gateway-rom");%>" name="config.wan_l2tp_gateway"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepL2tpServeraddr");</SCRIPT></td><!--Show L2TP Server IP Address-->
			<td>:&nbsp;
				<input type="text" id="wan_l2tp_server" size="20" maxlength="15" value="<% getIndexInfo("l2tpServerIp"); %>" name="config.wan_l2tp_server"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtL2TPUserName");</SCRIPT></td><!--Show Username-->
			<td>:&nbsp;
				<input type="text" id="wan_l2tp_username" size="20" maxlength="63" value="<% getIndexInfo("l2tpUserName"); %>" name="config.wan_l2tp_username"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtL2TPPassword");</SCRIPT></td><!--Show Password-->
			<td>:&nbsp;
				<input type="password" id="wan_l2tp_password" size="20" maxlength="63" onfocus="select();" value="<% getIndexInfo("l2tpPassword"); %>" name="config.wan_l2tp_password"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtPrimaryDNSServer");</SCRIPT></td><!--Show Primary DNS Server-->
			<td>:&nbsp;
				<input type="text" id="wan_l2tp_primary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns1");%>" name="config.wan_l2tp_primary_dns"/>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtSecondaryDNSServer");</SCRIPT></td><!--Show Secondary DNS Server-->
			<td>:&nbsp;
				<input type="text" id="wan_l2tp_primary_dns2" size="20" maxlength="15" value="<% getInfo("wan-dns2");%>" name="config.wan_l2tp_primary_dns2"/><SCRIPT language=javascript type=text/javascript>ddw("txtOptional");</SCRIPT>
			</td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtMACAddress");</SCRIPT></td><!--Show MAC Address-->
			<td>:&nbsp;
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
		<div id=dhcpplus_setting style="DISPLAY:none">
		<table width="100%">
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtUserName");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="wan_dhcpplus_username" size="25" maxlength="39" value="<% getInfo("pppUserName"); %>" name="config.wan_dhcpplus_username"/><font color="#0000FF"><SCRIPT>ddw("txtWizardEasyStepSMustFill");</SCRIPT></font>
			</td>
		</tr>	
		<tr>
			<td class=br_tb width="40%"><font color="#0000FF">*</font><SCRIPT language=javascript type=text/javascript>ddw("txtPassword");</SCRIPT></td>
			<td>:&nbsp;
				<input type="password" id="wan_dhcpplus_password" size="25" maxlength="39" value="<% getInfo("pppPassword"); %>" name="config.wan_dhcpplus_password"/>
			</td>
		</tr>	
		</table>
		</div>	
		<br>
		<center><script>next("page_submit();");</script></center>
		<br>

<!-- wan_ip_mode_box_2 --></div></form><!-- wz_page_5 -->
</div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
