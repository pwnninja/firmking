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
	return ("" !== "") ? "/Basic/Setup.asp" : "/Basic/Network.asp";
}
//boer add for rsf submit
var __AjaxAsk = null;
var timeleft = 1
function waittime()
{
        //setTimeodut(get_by_id("final_form").submit(), 3000);
        if(timeleft == 0){
		get_by_id("curTime").value = new Date().getTime();
		get_by_id("mainform").submit();
                return;
        }
        timeleft--;
        setTimeout(waittime, 1000);
}

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
function doCheckSubmit()
{
	var str;
	str = "settingsChanged=" + rsf["settingsChanged"].value;

	for(var i=0; i<24; i++){
		if(rsf["host_enabled_" + i].value == "1"){
			str += "&host_enabled_" + i + "=1";
		}
		str += "&hostName_" + i + "=" + rsf["host_name_" + i].value;
		str += "&host_ip_" + i + "=" + rsf["host_ip_" + i].value;
		var mac_addr = rsf["host_mac_"+i].value.split(":");
		rsf["mac_"+i].value = "";
		for(var j=0;j<mac_addr.length;j++){
			rsf["mac_"+i].value += mac_addr[j];
		}
		str += "&mac_" + i + "=" + rsf["mac_" + i].value;
		str += "&computer_list_ipaddr_select_" + i + "=" + rsf["computer_list_ipaddr_select_" + i].value;
	}

        if (__AjaxAsk == null) __AjaxAsk = __createRequest();
        __AjaxAsk.open("POST", "/goform/formSetDHCPResrvRule", true);
        __AjaxAsk.setRequestHeader('Content-type','application/x-www-form-urlencoded');
        __AjaxAsk.send(str);
	waittime();
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
/*
 * doPopulateDHCP()
 *	Populate the edit form with the selected option
 */
 
var MAXNUM_RESERVED_DHCP = "<%getIndexInfo("mac_static_num");%>"*1;

function doPopulateDHCP(index)
{
	if (ef.dhcp_leases_pulldown.options[ef.dhcp_leases_pulldown.selectedIndex].value != "-1") { 
		var index = rf.free.value;
		if (index == "") {
			alert(sw("txtNoMoreReservationsMayBeCreated"));
			return;
		}
		ef.used.value = "true";
		ef.enabled_select.checked = 1;
		ef.mac_ip.value = ef.dhcp_leases_pulldown.options[ef.dhcp_leases_pulldown.selectedIndex].getAttribute("ip_address");
		ef.mac_addr.value = ef.dhcp_leases_pulldown.options[ef.dhcp_leases_pulldown.selectedIndex].getAttribute("mac");
		ef.comp_name.value = ef.dhcp_leases_pulldown.options[ef.dhcp_leases_pulldown.selectedIndex].getAttribute("host_name");
		ef.dhcp_leases_pulldown.value = -1 ;
		//ef.Save.value = ef.Save.defaultValue;
		ef.Save.onclick = edit_form_add;

		if(index !=0)
		{
			ef["comp_name_" + index].value=ef.comp_name.value;
			ef["mac_ip_" + index].value=ef.mac_ip.value;
			ef["mac_addr_" + index].value=ef.mac_addr.value;
		}
		
	}
		
}
function revokeLease(ip_address)
{
	rf.revoke_ip.value = ip_address;
	rf.Action.value="revoke";
	//window.location.replace("/dhcp_lease_revoke.cgi" + "?ip_address=" + ip_address + "&response_resource=/Basic/Network.asp");
	rf.submit();
}
function reserveLease(ip_address, mac, host_name)
{
	var index = rf.free.value;
	if (index == "") {
		alert(sw("txtNoMoreReservationsMayBeCreated"));
		return;
	}
	ef.used.value = "true";
	ef.enabled_select.checked = 1;
	ef.comp_name.value = host_name;
	ef.mac_ip.value = ip_address;
	ef.mac_addr.value = mac;
	//ef.Save.value = ef.Save.defaultValue;
	ef.Save.onclick = edit_form_add;
}
var mf;			/* mainform */
var ef;			/* editform (reservation editing form) */
var rf;			/* rulesform (reservation listing) */
var pcmac;		/* Browsewr client MAC */
var entry_count=0;

var LanSettingChanged=0;
var xmac=new Array("aa","bb","cc","dd","ee","11");
/** Check for validation errors, if live.*/
var verify_failed = "<%getInfo("err_msg")%>";
function clone_mac() {
	ef.mac_addr.value = pcmac;
}
function edit_form_submit(index, act)
{
	var hostmac;
	var i;
	var checkmac_value;
	var check_result=1;
	var check_result1=1;
	var xmac1=new Array("aa","bb","cc","dd","ee","11");
	if (!is_ipv4_valid(ef.mac_ip.value)) {
		alert(sw("txtInvalidReservationIPAddress"));
		ef.mac_ip.select();
		ef.mac_ip.focus();
		return;
	}
	check_result = validateStartEndIp(ef.mac_ip.value, mf.dhcp_server_range_ip_start.value, mf.dhcp_server_range_ip_end.value, mf.lan_subnet_mask.value, 1);
	if(check_result !=1){
		alert(sw("txtInvalidReservationIPAddress1")+ef.mac_ip.value+sw("txtInvalidReservationIPAddress2"));
		ef.mac_ip.select();
		ef.mac_ip.focus();
		return;
	}	

	for (var i = 0; i < parseInt("32", 10); ++i) 
	{
		if(ef.edit_row.value == i)
			continue;
			
		var ipaddr_field = document.getElementById("mac_ip_" + i);
		var ipaddr_value;
		if (ipaddr_field == null) {
			continue;
		}
		ipaddr_value = document.getElementById("mac_ip_" + i).innerHTML;
		if(ipaddr_value == ef.mac_ip.value)
		{
			alert(sw("txtInvalidReservationIPAddress3")+ef.mac_ip.value+sw("txtInvalidReservationIPAddress4"));
			return; 
		}
	}	
	
	if (!is_mac_valid(ef.mac_addr.value, false)) {
		alert(sw("txtInvalidReservationMACAddress"));
		ef.mac_addr.select();
		ef.mac_addr.focus();
		return;
	}
	
	for (var i = 0; i < parseInt("32", 10); ++i) 
	{
		if(ef.edit_row.value == i)
			continue;
			
		var macaddr_field = document.getElementById("mac_addr_" + i);
		var macaddr_value;
		if (macaddr_field == null) {
			continue;
		}
		macaddr_value = document.getElementById("mac_addr_" + i).innerHTML;
		if(macaddr_value == ef.mac_addr.value)
		{
			alert(sw("txtInvalidReservationMACAddress1")+ef.mac_addr.value+sw("txtInvalidReservationMACAddress2"));
			return; 
		}
	}
	ef.entry_id.value = index;
	ef.used.name =  "entry" + index + ".used";
	ef.used.value = "true";
	ef.enabled.name =  "entry" + index + ".enabled";
	ef.enabled.value = ef.enabled_select.checked;
	ef.comp_name.name =  "entry" + index + ".comp_name";
	ef.mac_ip.name =  "entry" + index + ".mac_ip";
	ef.mac_addr.name =  "entry" + index + ".mac_addr";
	hostmac =ef.mac_addr.value; 
	checkmac_value=hostmac.indexOf(':');
	if(checkmac_value !=-1){
		xmac1[0]=hostmac.substring(0,2);
		xmac1[1]=hostmac.substring(3,5);
		xmac1[2]=hostmac.substring(6,8);
		xmac1[3]=hostmac.substring(9,11);
		xmac1[4]=hostmac.substring(12,14);
		xmac1[5]=hostmac.substring(15,17);
		ef.mac_addr.value=xmac1[0]+xmac1[1]+xmac1[2]+xmac1[3]+xmac1[4]+xmac1[5];
	}
	ef.curTime.value = new Date().getTime();
	ef.submit();
}
function edit_form_add()
{
	var index = rf.free.value;
	if (index == "") {
		alert(sw("txtNoMoreReservationsMayBeCreated"));
		return;
	}
	ef.Action.value = "add";
	index = entry_count+1;
	edit_form_submit(index, 1);
}
function edit_form_update()
{
	//ef.Save.value = ef.Save.defaultValue;
	ef.Save.onclick = edit_form_add;
	var index = rf.index.value;
	ef.Action.value = "update";
	edit_form_submit(index, 2);
}
/** edit_form_cancel() */
function edit_form_cancel()
{
reset_form("editform");
ef.Save.onclick = edit_form_add;
set_form_default_values("editform");
}
function rule_entry_enable(index)
{
	reset_form("editform");
	var name = document.getElementById("mac_ip_" + index).innerHTML;
	var tick = rf["enabled_select_" + index];
	var confirmed = true;
	if (tick.checked) {
		confirmed = confirm(sw("txtNetworkStr1") + name);
	} else {
		confirmed = confirm(sw("txtNetworkStr2") + name);
	}
	if (!confirmed) {
		tick.checked = !tick.checked;
		return;
	}
	ef.entry_id.value = index;
	//ef.enabled.name = "config.dhcp_server_reservation_table[" + index + "].enabled";
	ef.enabled.name =  "entry" + index + ".enabled";
	ef.enabled.value = tick.checked;
	ef.Action.value = "enable";
	ef.submit();
}
function rule_entry_delete(index)
{
	if (is_form_modified("editform") && 
			!confirm(sw("txtAbandonChanges"))) {
		return;
	}
	reset_form("editform");
	var name = document.getElementById("mac_ip_" + index).innerHTML;
	if (!confirm(sw("txtDeleteConfirm") + name)) {
		return;
	}
	ef.entry_id.value = index;
	ef.used.value = "false";
	//ef.used.name = "config.dhcp_server_reservation_table[" + index + "].used";
	ef.used.name =  "entry" + index + ".used";
	ef.Action.value = "delete";
	ef.submit();
}
function rule_entry_edit(index)
{
	ef.edit_row.value = index;
	ef.edit_row.setAttribute("modified", "ignore");
	if (is_form_modified("editform") && 
			!confirm(sw("txtAbandonChanges"))) {
		return;
	}
	rf.index.value = index;		
	ef.used.value = "true";
	ef.enabled_select.checked = document.getElementById("enabled_select_" + index).checked;
	ef.comp_name.value = document.getElementById("comp_name_" + index).innerHTML;
	ef.mac_ip.value = document.getElementById("mac_ip_" + index).innerHTML;
	ef.mac_addr.value = document.getElementById("mac_addr_" + index).innerHTML;
	ef.Save.onclick = edit_form_update;
	//set_form_default_values("editform");
}

/*
 * DHCP client list.
 * Note that one data document is fetched and then translated via two different translators.
 * We fetch the translators first (as this is a once-only operation) and then repeatedly fetch the data
 * processing it via the translators as the data arrives.
 */
var dhcpClientXSLTIsReady = false;
var dhcpClientPulldownXSLTIsReady = false;
function onLanClientDataReady(xmlDoc)
{
	
	if (!(dhcpClientXSLTIsReady && dhcpClientPulldownXSLTIsReady)) {
		return;
	}
	var LanClientXMLData = xmlDoc.getDocument();
	
	var computer_pulldown_parent =  document.getElementById("xsl_span_computer_list_ipaddr_select");
	
	
	while (computer_pulldown_parent.firstChild != null) {
		computer_pulldown_parent.removeChild(computer_pulldown_parent.firstChild);
	}
	dhcpClientPulldownXSLTProcessor.transform(LanClientXMLData, window.document, computer_pulldown_parent);
	
	for(i=0; i<MAXNUM_RESERVED_DHCP; i++){
		copy_select_options(rsf.dhcp_leases_pulldown, rsf["computer_list_ipaddr_select_" + i]);
		rsf["computer_list_ipaddr_select_" + i].setAttribute("modified", "ignore");
	}
	setTimeout("LanClientXMLDataFetcher.retrieveData();", 10000);
}

function onDHCPClientDataReady(xmlDoc)
{
	
	if (!(dhcpClientXSLTIsReady && dhcpClientPulldownXSLTIsReady)) {
		return;
	}
	var dhcpClientXMLData = xmlDoc.getDocument();
	var computer_list = document.getElementById("dhcp_client_list");
	
	computer_list.innerHTML = "";
	
	dhcpClientXSLTProcessor.transform(dhcpClientXMLData, window.document, computer_list);
	
	setTimeout("dhcpClientXMLDataFetcher.retrieveData();", 10000);
}
function onDHCPClientDataTimeout()
{
dhcpClientXMLDataFetcher.retrieveData();
}

function onLanClientDataTimeout()
{
LanClientXMLDataFetcher.retrieveData();
}

function dhcpClientXSLTReady(xmlDoc)
{
dhcpClientXSLTIsReady = true;

dhcpClientXMLDataFetcher = new xmlDataObject(onDHCPClientDataReady, onDHCPClientDataTimeout, 6000,"../dyn_clients_only.asp");
dhcpClientXMLDataFetcher.retrieveData();

LanClientXMLDataFetcher = new xmlDataObject(onLanClientDataReady, onLanClientDataTimeout, 6000," ../dhcp_clients.asp");
LanClientXMLDataFetcher.retrieveData();

}
function dhcpClientPulldownXSLTReady(xmlDoc)
{
	dhcpClientPulldownXSLTIsReady = true;
//	dhcpClientPulldownXSLTProcessor.addParameter("onchange_spec", "doPopulateDHCP(0);");
	dhcpClientPulldownXSLTProcessor.addParameter("id_spec", "dhcp_leases_pulldown");
}
function onDHCPClientXSLTProcessorTimeout()
{
dhcpClientXSLTProcessor.retrieveData();
}
function onDHCPClientPulldownXSLTProcessorTimeout()
{
dhcpClientPulldownXSLTProcessor.retrieveData();
}

function cp_computer_info(i)
{
	if(get_by_id("computer_list_ipaddr_select_"+i).value=='-1')
	{		
		get_by_id("host_name_"+i).value	="";
		get_by_id("host_ip_"+i).value	="";
		get_by_id("host_mac_"+i).value	="";
	}
	else
	{
		get_by_id("host_ip_"+i).value = rsf.dhcp_leases_pulldown.options[get_by_id("computer_list_ipaddr_select_"+i).selectedIndex].getAttribute("ip_address");
		get_by_id("host_mac_"+i).value = rsf.dhcp_leases_pulldown.options[get_by_id("computer_list_ipaddr_select_"+i).selectedIndex].getAttribute("mac");
		get_by_id("host_name_"+i).value = rsf.dhcp_leases_pulldown.options[get_by_id("computer_list_ipaddr_select_"+i).selectedIndex].getAttribute("host_name");
	}
	get_by_id("computer_list_ipaddr_select_"+i).selectedIndex=0;
}

function wan_port_mode_selector(mode)
{
	mf.wan_port_mode.value = mode;
	set_radio(mf.wan_port_mode_radio, mode)
	var router_mode = (mode == "0");
	
	
	disable_form_field(mf.lan_gateway, router_mode);
	disable_form_field(mf.lan_primary_dns, router_mode);
	disable_form_field(mf.lan_secondary_dns, router_mode);
	disable_form_field(mf.local_domain_name, !router_mode);
	disable_form_field(mf.dns_relay_enabled, !router_mode);
	disable_form_field(mf.dns_relay_enabled_select, !router_mode);
	document.getElementById("bridge_mode_only_settings").style.display = router_mode ? "none" : "block";
	document.getElementById("router_mode_only_settings").style.display = router_mode ? "block" : "none";
	
	//dhcp_server_enabled_selector(router_mode && (dhcp_server_enabled_init == "1"));
	dhcp_server_enabled_selector((dhcp_server_enabled_init == "1")); //Brad without dependence with op mode
	//disable_form_field(mf.dhcp_server_enabled, !router_mode); 
	//disable_form_field(mf.dhcp_server_enabled_select, !router_mode);
	//document.getElementById("dhcp_server_enabled_section").style.display = router_mode ? "block" : "none";
	
	//lan_netbios_learn_from_wan_enabled_selector(mf.lan_netbios_learn_from_wan_enabled.value, !router_mode);
}
function dns_relay_enabled_selector(value)
{
	mf.dns_relay_enabled.value = (value == true) ? "true" : "false";
	mf.dns_relay_enabled_select.checked = value;
}
function lan_netbios_registration_type_selector(mode)
{
	mf.lan_netbios_registration_type.value = mode;
	set_radio(mf.lan_netbios_registration_type_radio, mode);
}
function lan_netbios_learn_from_wan_enabled_selector(parent_enabled, value)
{
	mf.lan_netbios_learn_from_wan_enabled.value = (value == true) ? "true" : "false";
	mf.lan_netbios_learn_from_wan_enabled_select.checked = value;
	lan_netbios_registration_type_selector(mf.lan_netbios_registration_type.value);
	do_block_enable(document.getElementById("lan_wins_settings_1"), parent_enabled && !value);
 }
function lan_netbios_advertisement_enabled_selector(parent_enabled, value)
{
	mf.lan_netbios_advertisement_enabled.value = (value == true) ? "true" : "false";
	mf.lan_netbios_advertisement_enabled_select.checked = value;
	if(mf.opMode[0].checked == true){
		var enabled = parent_enabled && value;
		disable_form_field(mf.lan_netbios_learn_from_wan_enabled_select, !enabled);
		lan_netbios_learn_from_wan_enabled_selector(enabled, mf.lan_netbios_learn_from_wan_enabled.value == "true");
	}else{
		var enabled = parent_enabled && value;
		disable_form_field(mf.lan_netbios_learn_from_wan_enabled_select, true);
		lan_netbios_learn_from_wan_enabled_selector(enabled, false);
	}
	
}
function dhcp_server_enabled_selector(value)
{
	mf.dhcp_server_enabled.value = (value == true) ? "1" : "0";
	mf.dhcp_server_enabled_select.checked = value;
	var disabled = !value;
	disable_form_field(mf.dhcp_ip_start, disabled);
	disable_form_field(mf.dhcp_ip_end, disabled);
	disable_form_field(mf.dhcp_server_lease_time_max, disabled);
	disable_form_field(mf.dhcp_server_always_broadcast_select, disabled);
	disable_form_field(mf.lan_netbios_advertisement_enabled_select, disabled);
	lan_netbios_advertisement_enabled_selector(value, mf.lan_netbios_advertisement_enabled.value == "true");
	var form_display = (value == true) ? "block" : "none";			
	document.getElementById("editform").style.display = form_display;
	document.getElementById("rulesform").style.display = form_display;
	document.getElementById("RsvdIPform").style.display = form_display;
	document.getElementById("dhcp_client_list").style.display = form_display;
 }		

function dhcp_server_always_broadcast_selector(value)
{
	mf.dhcp_server_always_broadcast.value = (value == true) ? "1" : "0";
	mf.dhcp_server_always_broadcast_select.checked = value;
}
function page_submit()
{
	var dhcp_range_ip = new Array();
	var dhcp_min;
	var router_ip;
	var dhcp_max;
	var wan_ip="<% getInfo("wan-ip");%>";
	var wan_mask="<% getInfo("wan-mask");%>";
	var wlan_mode="<%getIndexInfo("wlanMode");%>";//-1 Router mode
	var wan_type="<%getInfo("wanType");%>";//0 static wan
	if(wlan_mode == "-1")
	{
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

	}
	if (!is_form_modified("mainform") && 
		!confirm(sw("txtSaveAnyway"))) {
		return;
	}
	
	var ip_start = mf.lan_network_address.value.split(".");
	mf.dhcp_server_range_ip_start.value = "";
	mf.dhcp_server_range_ip_end.value = "";
	for(var i=0 ; i<3 ; i++)
	{
		mf.dhcp_server_range_ip_start.value += ip_start[i];
		mf.dhcp_server_range_ip_start.value += '.';
		mf.dhcp_server_range_ip_end.value += ip_start[i];
		mf.dhcp_server_range_ip_end.value += '.';
	}
	mf.dhcp_server_range_ip_start.value += mf.dhcp_ip_start.value;
	
	mf.dhcp_server_range_ip_end.value += mf.dhcp_ip_end.value;
	
	
	if (is_valid_ip(mf.lan_network_address.value, 0)==false)
	{
		alert(sw("txtInvalidLANIPAddress"));
		mf.lan_network_address.select();
		mf.lan_network_address.focus();
		return;
	}
	if (is_valid_mask(mf.lan_subnet_mask.value)==false)
	{
		alert(sw("txtInvalidLANSubnetMask"));
		mf.lan_subnet_mask.select();
		mf.lan_subnet_mask.focus();
		return;
	}
	if (!is_valid_ip2(mf.lan_network_address.value, mf.lan_subnet_mask.value))
	{
		alert(sw("txtInvalidLANIPAddress"));
		mf.lan_network_address.select();
		mf.lan_network_address.focus();
		return;
	}
	if(wan_ip != "0.0.0.0" && wan_mask != "0.0.0.0")
	{
		var mask_tmp=mf.lan_subnet_mask.value;
		if(ipv4_to_unsigned_integer(mf.lan_subnet_mask.value) > ipv4_to_unsigned_integer(wan_mask))
		{
			mask_tmp=wan_mask;
		}
		if (is_valid_ip2(mf.lan_network_address.value, mask_tmp, wan_ip))
		{
			alert(sw("txtWanSubConflitLanSub"));
			mf.lan_network_address.select();
			mf.lan_network_address.focus();
			return;
		}
	}
	
	if(is_blank(mf.local_domain_name.value))
		mf.local_domain_name.value = "";
	if (!is_blank(mf.local_domain_name.value) && strchk_hostname(mf.local_domain_name.value)==false)
	{
		alert(sw("txtDomainNameInvalid"));
		mf.local_domain_name.select();
		mf.local_domain_name.focus();
		return;
	}
	
/*	
	if (mf.lan_netbios_name.value == "") {
		alert(sw("txtDeviceName")+" "+sw("txtIsEmpty"));
		mf.lan_netbios_name.select();
		mf.lan_netbios_name.focus();
		return;
	}
	
	if (mf.local_domain_name.value == "") {
		alert(sw("txtLocalDomainName")+" "+sw("txtIsEmpty"));
		mf.local_domain_name.select();
		mf.local_domain_name.focus();
		return;
	}
*/
	if(mf.opMode[1].checked == true){ //check the parameter when bridge mode
	
	
		if(mf.lan_gateway.value == "")
			mf.lan_gateway.value = "0.0.0.0";
		if (!is_ipv4_valid(mf.lan_gateway.value)) {
			alert(sw("txtInvalidGatewayIPAddress") + mf.lan_gateway.value);
			mf.lan_gateway.select();
			mf.lan_gateway.focus();
			return;
		}
		if(mf.lan_gateway.value != "0.0.0.0"){
			var lan_ip = ipv4_to_unsigned_integer(mf.lan_network_address.value);
			var mask_ip = ipv4_to_unsigned_integer(mf.lan_subnet_mask.value);
			var gw_ip = ipv4_to_unsigned_integer(mf.lan_gateway.value);
			
			if(lan_ip == gw_ip){
				alert(sw("txtInvalidGatewayIPAddress") + mf.lan_gateway.value);
				mf.lan_gateway.select();
				mf.lan_gateway.focus();
				return;
			}
			if ((lan_ip & mask_ip) !== (gw_ip & mask_ip))
			{
				alert(sw("txtGwIp")+" "+integer_to_ipv4(gw_ip)+" "+sw("txtWithinLanSubnet"));
				return false;
			}
		}
		mf.lan_primary_dns.value = mf.lan_primary_dns.value == "" ? "0.0.0.0" : mf.lan_primary_dns.value;
		mf.lan_secondary_dns.value = mf.lan_secondary_dns.value == "" ? "0.0.0.0" : mf.lan_secondary_dns.value;
		if (!is_ipv4_valid(mf.lan_primary_dns.value)) {
			alert(sw("txtInvalidPPPoEPrimaryDNS") + mf.lan_primary_dns.value);
			mf.lan_primary_dns.select();
			mf.lan_primary_dns.focus();
			return;
		}
		if ((mf.lan_primary_dns.value!="0.0.0.0") && (mf.lan_primary_dns.value == mf.lan_secondary_dns.value) && (mf.lan_primary_dns.value!="")) {
			alert(sw("txtSameDNS"));
			mf.lan_secondary_dns.select();
			mf.lan_secondary_dns.focus();
			return;
		}
		if (!is_ipv4_valid(mf.lan_secondary_dns.value)) {
			alert(sw("txtInvalidPPPoESecondaryDNS") + mf.lan_secondary_dns.value);
			mf.lan_secondary_dns.select();
			mf.lan_secondary_dns.focus();
			return;
		}
	}
	if(mf.dhcp_server_enabled.value != "1") {
		mf.dhcp_server_range_ip_start.value = "<% getInfo("dhcpRangeStart");%>";
		mf.dhcp_server_range_ip_end.value = "<% getInfo("dhcpRangeEnd");%>";
		mf.dhcp_server_lease_time_max.value = "1440";
	} else {
		//dhcp server enabled
		router_ip = get_ip(mf.lan_network_address.value);
		dhcp_range_ip = get_host_range_ip(mf.lan_network_address.value, mf.lan_subnet_mask.value);
		dhcp_min = parseInt(mf.dhcp_ip_start.value, [10]);
		dhcp_max = parseInt(mf.dhcp_ip_end.value, [10]);

		if (!is_digit(mf.dhcp_ip_start.value))
		{
			alert(sw("txtInvalidDHCPStartIPRange"));
			mf.dhcp_ip_start.select();
			mf.dhcp_ip_start.focus();
			return;
		}
		if(!is_digit(mf.dhcp_ip_end.value))
		{
			alert(sw("txtInvalidDHCPEndIPRange"));
			mf.dhcp_ip_end.select();
			mf.dhcp_ip_end.focus();
			return;
		}
	
		if( !is_in_range(dhcp_min, 1, 254) || !is_in_range(dhcp_max, 1, 254) || dhcp_min > dhcp_max ||
		    dhcp_min < dhcp_range_ip[0] || dhcp_max > dhcp_range_ip[1] || is_in_range(router_ip[4], dhcp_min, dhcp_max))
		{
			alert(sw("txtDHCPRangeInvalid"));
			mf.dhcp_ip_start.select();
			mf.dhcp_ip_start.focus();
			return;
		}
		
		if( ((ip_start[3] * 1) >= (mf.dhcp_ip_start.value * 1)) && ((ip_start[3] * 1) <= (mf.dhcp_ip_end.value * 1)) ) {
			alert(sw("txtIpInDhcpServerrange"));
			mf.lan_network_address.select();
			mf.lan_network_address.focus();
			return;
		}

		if (!is_number(mf.dhcp_server_lease_time_max.value) || (mf.dhcp_server_lease_time_max.value <= 0)  || (mf.dhcp_server_lease_time_max.value > 65535)) {
		alert(sw("txtInvalidDHCPLeaseTime")+"(1-65535)");
		mf.dhcp_server_lease_time_max.select();
		mf.dhcp_server_lease_time_max.focus();
		return;
		}
	}

	if (is_form_modified("mainform")){  //something changed
		mf.settingsChanged.value = 1;
	}
	
	if(rsfCheck() == 0)
	{
		return;
	}
	
	//rsf.submit();//boer modify
	doCheckSubmit();
//	mf.curTime.value = new Date().getTime();
//	mf.submit();
}
function strchk_pcname(str)
{
	if (__is_str_in_allow_chars(str, 1, "-_")) return true;
	return false;
}
function rsfCheck()
{
    	var LAN_IP = ipv4_to_unsigned_integer(mf.lan_network_address.value);
	var LAN_MASK = ipv4_to_unsigned_integer(mf.lan_subnet_mask.value);
	var ip_s_value = ipv4_to_unsigned_integer(mf.dhcp_server_range_ip_start.value);
	var ip_e_value = ipv4_to_unsigned_integer(mf.dhcp_server_range_ip_end.value);

	for(i=0; i<MAXNUM_RESERVED_DHCP; i++)
	{
		var rsf_name = rsf["host_name_" + i].value;
		var rsf_ipaddr = rsf["host_ip_" + i].value;
		var rsf_mac = rsf["host_mac_" + i].value;
		var emptyCheck=0;
		
		
/*		
		if(rsf["host_enabled_"+i].checked == false)
		{
			continue;
		}
*/		
		if(rsf_name == "")
		{
			emptyCheck++;
		}
		
		if(rsf_ipaddr == "")
		{
			emptyCheck++;
		}
		
		if(rsf_mac == "")
		{
			emptyCheck++;
		}
		
		if(emptyCheck == 3 || emptyCheck == 0)
		{
			if(emptyCheck == 3)
			{
				rsf["host_enabled_"+i].checked = false;
				continue;
			}

		}
		else
		{
			alert(sw("txtEmptyDHCPList"));
			return 0;
		}
		//host
			if(is_blank(rsf_name) || strchk_pcname(rsf_name)==false)
			{
				alert(sw("txtCompName"));
				rsf["host_name_" + i].select();
				rsf["host_name_" + i].focus();
				return false;
			}
		
		if(rsf_ipaddr==mf.lan_network_address.value)
		{
				alert(sw("txtInvalidLanIP"));
				rsf["host_ip_" + i].select();
				rsf["host_ip_" + i].focus();
				return false;
		}
		if(is_blank(rsf_ipaddr) || is_valid_ip(rsf_ipaddr,0)==false || is_valid_ip2(rsf_ipaddr, mf.lan_subnet_mask.value)==false )
			{
				alert(sw("txtInvalidIPAddress")+": " + rsf_ipaddr + ".");
				rsf["host_ip_" + i].select();
				rsf["host_ip_" + i].focus();
				return false;
			}
		if( mf.dhcp_server_enabled.value == "1")
		{
		var tarIp = ipv4_to_unsigned_integer(rsf_ipaddr);
		if ((tarIp & LAN_MASK) !== (LAN_IP & LAN_MASK))
		{
			alert(sw("txtIPAddrFor")+rsf_name+"' "+sw("txtShouldWithinLanSubnet")+"("+integer_to_ipv4(LAN_IP & LAN_MASK)+")");
			rsf["host_ip_" + i].select();
			rsf["host_ip_" + i].focus();
			return 0;
		}
		}
		if( mf.dhcp_server_enabled.value == "1")
		{
			if ((tarIp < ip_s_value) || (tarIp > ip_e_value))
			{
				alert(sw("txtIPAddrFor")+rsf_name+"' "+sw("txtShouldInDHCPRange"));
				rsf["host_ip_" + i].select();
				rsf["host_ip_" + i].focus();
				return 0;
			}
		}

		if(!verify_mac(rsf_mac,rsf["host_mac_" + i]))
		{
			alert (sw("txtInvalidMACAddress") + " "+rsf_mac + ".");
			rsf["host_mac_" + i].select();
			rsf["host_mac_" + i].focus();
			return false;
		}		
		
		for(j=0; j<MAXNUM_RESERVED_DHCP; j++)
		{
			if(i==j)
			{
				continue;
			}
			
			if(rsf_name == rsf["host_name_" + j].value)
			{
				alert(sw("txtDuplicateDHCPEntry"));
				rsf["host_name_" + j].select();
				rsf["host_name_" + j].focus();
				return 0;
			}
			
			if(rsf_ipaddr == rsf["host_ip_" + j].value)
			{
				alert(sw("txtDuplicateDHCPEntry"));
				rsf["host_ip_" + j].select();
				rsf["host_ip_" + j].focus();
				return 0;
			}
			
			if(rsf_mac == rsf["host_mac_" + j].value)
			{
				alert(sw("txtDuplicateDHCPEntry"));
				rsf["host_mac_" + j].select();
				rsf["host_mac_" + j].focus();
				return 0;
			}
		
		}
	}
		
	for(i=0; i<MAXNUM_RESERVED_DHCP; i++)
	{
		var mac_addr = rsf["host_mac_"+i].value.split(":");					
		rsf["mac_"+i].value = "";
		for(var j=0;j<mac_addr.length;j++)
		{
			rsf["mac_"+i].value += mac_addr[j];
		}
		
		if(rsf["host_enabled_"+i].checked == true)
		{
			rsf["host_enabled_"+i].value = 1;
		}
		else
		{
			rsf["host_enabled_"+i].value = 0;
		}
	}
}

function page_load() {

displayOnloadPage("<%getInfo("ok_msg")%>");
mf = document.forms["mainform"];
ef = document.forms["editform"];
rf = document.forms["rulesform"];
rsf = document.forms["RsvdIPform"];
imb = document.forms["ipMacBindingform"];
var newmac='<% getInfo("host-hwaddr"); %>';
xmac[0]=newmac.substring(0,2);
xmac[1]=newmac.substring(3,5);
xmac[2]=newmac.substring(6,8);
xmac[3]=newmac.substring(9,11);
xmac[4]=newmac.substring(12,14);
xmac[5]=newmac.substring(15,17);
pcmac = newmac;

mf.opModeSelect.value="<%getInfo("opmode");%>";
 var current_value='<% getInfo("dhcp-current"); %>';
    if(current_value =='2' || (current_value == '10' && mf.opModeSelect.value == "Enabled"))
		mf.dhcp_server_enabled.value = '1';
	else
		mf.dhcp_server_enabled.value = '0';
		
if(mf.opModeSelect.value == "Enabled")
{
	opMode_selector(0);
}
else
{
	opMode_selector(1);
}
mf.wan_port_mode.value = OP_MODE;
mf.lan_network_address.value = '<% getInfo("ip-rom"); %>';

mf.lan_subnet_mask.value = '<% getInfo("mask-rom"); %>';


mf.lan_netbios_name.value = '<% getInfo("lan_netbios_name"); %>';


mf.local_domain_name.value='<% getInfo("domainName");%>';

mf.dhcp_server_range_ip_start.value='<% getInfo("dhcpRangeStart");%>';
var ip_start = mf.dhcp_server_range_ip_start.value.split(".");
mf.dhcp_ip_start.value=ip_start[3];

mf.dhcp_server_range_ip_end.value='<% getInfo("dhcpRangeEnd");%>';
var ip_end = mf.dhcp_server_range_ip_end.value.split(".");
mf.dhcp_ip_end.value=ip_end[3];

mf.dhcp_server_lease_time_max.value= '<% getInfo("dhcp-lease"); %>';

mf.dhcp_server_always_broadcast.value='<%getIndexInfo("dhcpd_broadcast");%>';

var dnsRelay= '<%getIndexInfo("dnrd_enabled");%>';
if(dnsRelay == '1')
mf.dns_relay_enabled.value = "true";
else
mf.dns_relay_enabled.value = "false";	

var netBiosann= '<%getIndexInfo("netbios_announce");%>';
if(netBiosann == '1')
mf.lan_netbios_advertisement_enabled.value = "true";
else
mf.lan_netbios_advertisement_enabled.value = "false";
lan_netbios_advertisement_enabled_old = mf.lan_netbios_advertisement_enabled.value;

var netBios_src='<%getIndexInfo("netbios_src");%>';
if(netBios_src == '1')
mf.lan_netbios_learn_from_wan_enabled.value = "true";
else
mf.lan_netbios_learn_from_wan_enabled.value = "false";

var netBios_scope='<%getIndexInfo("netbios_scope");%>';
mf.lan_netbios_scope.value = netBios_scope;

var netBios_NodeType='<%getIndexInfo("netbios_node");%>';
mf.lan_netbios_registration_type.value=netBios_NodeType;


mf.lan_netbios_primary_wins_ip.value = '<%getIndexInfo("wins-ip1");%>';


/** We save the value as we want to display the init values when the user switch back from bridge mode to router mode*/
dhcp_server_enabled_init = mf.dhcp_server_enabled.value;
wan_port_mode = mf.wan_port_mode.value;
wan_port_mode_selector(wan_port_mode);
/** Populate the main form check boxes for router mode*/
//if (wan_port_mode == "0") {   //Brad without dependence with op mode
/** Populate the main form check boxes */
dhcp_server_always_broadcast_selector(mf.dhcp_server_always_broadcast.value == "1");
dns_relay_enabled_selector(mf.dns_relay_enabled.value == "true");
/** Get the XSLT objects we need*/
if(lang=="1"){
dhcpClientXSLTProcessor = new xsltProcessingObject(dhcpClientXSLTReady, onDHCPClientXSLTProcessorTimeout, 6000, "../dhcp_clients_pack.sxsl");
}else{
dhcpClientXSLTProcessor = new xsltProcessingObject(dhcpClientXSLTReady, onDHCPClientXSLTProcessorTimeout, 6000, "../dhcp_clients.sxsl");
}
dhcpClientXSLTProcessor.retrieveData();
if(lang=="1"){
dhcpClientPulldownXSLTProcessor = new xsltProcessingObject(dhcpClientPulldownXSLTReady, onDHCPClientPulldownXSLTProcessorTimeout, 6000, "../computer_ipaddr_list_pack.sxsl");
}else{
dhcpClientPulldownXSLTProcessor = new xsltProcessingObject(dhcpClientPulldownXSLTReady, onDHCPClientPulldownXSLTProcessorTimeout, 6000, "../computer_ipaddr_list.sxsl");
}
dhcpClientPulldownXSLTProcessor.retrieveData();
/** Initialize rulesform checkboxes */				
for (var i = 0; i < parseInt("32", 10); ++i) {
	var enabled_field = document.getElementById("enabled_" + i);
	if (enabled_field == null) {
		continue;
	}
	entry_count = i;
	var chkbox_select = document.getElementById("enabled_select_" + i);
	chkbox_select.checked = (enabled_field.value == "true")? 1 : 0;
	}
//}//Brad without dependence with op mode

for(i=0; i<MAXNUM_RESERVED_DHCP; i++)
	{
		if(rsf["host_enabled_"+i].value == 1 )
		{
			rsf["host_enabled_"+i].checked = true;
		}
		else
		{
			rsf["host_enabled_"+i].checked = false;
		}
	}
	
allow_ip_mac_binding_selector(mf.allow_ip_mac_binding.value);
set_form_default_values("mainform");
set_form_default_values("editform");
set_form_default_values("RsvdIPform");
if (verify_failed != "") {
	set_form_always_modified("mainform");
	alert(verify_failed);
}
}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtLanSetting");
document.title = DOC_Title;	
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("Save").value = sw("txtSave");
get_by_id("Clear").value = sw("txtClear");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");			
get_by_id("CopyPCsMACAddress").value = sw("txtCopyPCsMACAddress");
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");
document.getElementById("dhcp_ip_range").innerHTML=sw("dhcp_hints");
}
function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function opMode_selector(selectMode)
{
	if(selectMode == 0) //Router
	{
		mf.opModeSelect.value = "Enabled";
		mf.opMode[0].checked = true;
		//get_by_id("dhcp_server_enabled_section").style.display = "block";
		//get_by_id("dhcp_server_reservations_list").style.display = "block";
		//get_by_id("dhcp_server_add_reservations").style.display = "block";
		//get_by_id("dhcp_client_list").style.display = "";
		
	}
	else //AP mode
	{
		mf.opModeSelect.value = "Disabled";
		mf.opMode[1].checked = true;
		//get_by_id("dhcp_server_enabled_section").style.display = "none";
		//get_by_id("dhcp_server_reservations_list").style.display = "none";
		//get_by_id("dhcp_server_add_reservations").style.display = "none";
		//get_by_id("dhcp_client_list").style.display = "none";
	}

}

var token= new Array(MAXNUM_RESERVED_DHCP);
var DataArray = new Array();
function reservedDhcpList(num)
{
token[0]="<%dhcpRsvdIp_PerInfo("RsvdIp_1");%>"
token[1]="<%dhcpRsvdIp_PerInfo("RsvdIp_2");%>"
token[2]="<%dhcpRsvdIp_PerInfo("RsvdIp_3");%>"
token[3]="<%dhcpRsvdIp_PerInfo("RsvdIp_4");%>"
token[4]="<%dhcpRsvdIp_PerInfo("RsvdIp_5");%>"
token[5]="<%dhcpRsvdIp_PerInfo("RsvdIp_6");%>"
token[6]="<%dhcpRsvdIp_PerInfo("RsvdIp_7");%>"
token[7]="<%dhcpRsvdIp_PerInfo("RsvdIp_8");%>"
token[8]="<%dhcpRsvdIp_PerInfo("RsvdIp_9");%>"
token[9]="<%dhcpRsvdIp_PerInfo("RsvdIp_10");%>"
token[10]="<%dhcpRsvdIp_PerInfo("RsvdIp_11");%>"
token[11]="<%dhcpRsvdIp_PerInfo("RsvdIp_12");%>"
token[12]="<%dhcpRsvdIp_PerInfo("RsvdIp_13");%>"
token[13]="<%dhcpRsvdIp_PerInfo("RsvdIp_14");%>"
token[14]="<%dhcpRsvdIp_PerInfo("RsvdIp_15");%>"
token[15]="<%dhcpRsvdIp_PerInfo("RsvdIp_16");%>"
token[16]="<%dhcpRsvdIp_PerInfo("RsvdIp_17");%>"
token[17]="<%dhcpRsvdIp_PerInfo("RsvdIp_18");%>"
token[18]="<%dhcpRsvdIp_PerInfo("RsvdIp_19");%>"
token[19]="<%dhcpRsvdIp_PerInfo("RsvdIp_20");%>"
token[20]="<%dhcpRsvdIp_PerInfo("RsvdIp_21");%>"
token[21]="<%dhcpRsvdIp_PerInfo("RsvdIp_22");%>"
token[22]="<%dhcpRsvdIp_PerInfo("RsvdIp_23");%>"
token[23]="<%dhcpRsvdIp_PerInfo("RsvdIp_24");%>"


for (var i = 0; i < num; i++)
{

DataArray = token[i].split("/"); /* Enabled:0, Name:1, ip:2, mac:3 */

document.write("<tr>");
document.write("	<td class='centered'><input type='checkbox' id='host_enabled_"+i+"' name='host_enabled_"+i+"' value='"+DataArray[0]+"'></td>");
document.write("	<td class='centered'><input type='text' id='host_name_"+i+"' name='hostName_"+i+"' size='15' maxlength='20' value='"+DataArray[1]+"' /></td>");
document.write("	<td class='centered'><input type='text' id='host_ip_"+i+"' name='host_ip_"+i+"' size='16' maxlength='15' value='"+DataArray[2]+"'></td>");
document.write("	<input type='hidden' id='mac_'"+i+" name='mac_"+i+"' value=''/>");
document.write("	<td class='centered'><input type='text' id='host_mac_"+i+"' size='18' maxlength='17' value='"+DataArray[3]+"'></td>");
document.write("	<td class='centered'>");
document.write("	<input type=button  value='<<' style='width:24;height:24' onClick='cp_computer_info("+i+")'>");
document.write("		<select name=\"computer_list_ipaddr_select_"+i+"\" id=\"computer_list_ipaddr_select_"+i+"\" style=\"width: 120px;\" modified=\"ignore\">");
document.write("			<option value=\"-1\" selected=\"selected\">"+sw("txtComputerName")+"</option>");
document.write("		</select>");


document.write("	</td>");
document.write("</tr>");
}
}

function allow_ip_mac_binding_selector(value)
{

if(value==true || value==1)
{
	mf.allow_ip_mac_binding.value = 1;
	imb.allow_ip_mac_binding_select.checked = true;
}
else
{
	mf.allow_ip_mac_binding.value = 0;
	imb.allow_ip_mac_binding_select.checked = false;
}

}
//]]>
</script>
</head>
<body onload="init();template_load();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside"><table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr>	<td><SCRIPT >
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
</td>
<td id="maincontent_container">
<!--<div id="rebootcontent" style="display: none">
<div class="section">
<div class="section_head">
<h2>
<SCRIPT >ddw("txtRebootNeeded");</SCRIPT>
</h2>
<p>
<SCRIPT >ddw("txtIndexStr5");</SCRIPT>
</p>
<form id="rebootdummy" name="rebootdummy" action="/goform/formDeviceReboot" method="post">
 <input type="hidden" name="next_page" value=""/>
 <input type="hidden" name="act" value=""/>
<input class="button_submit" id="RestartNow" type="button" value="" onclick="do_reboot()" />
<input class="button_submit" id="RestartLater" type="button" value="" onclick="no_reboot()" />
</form>
</div>
</div>
</div>
-->
<SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" ><div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div></div></div>	</div> 
<div id="maincontent" style="display: block">
<form id="mainform" name="mainform" action="/goform/formTcpipSetup" method="post">
	<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
	<input type="hidden" id="curTime" name="curTime" value=""/>
	<input type="hidden" id="isTopChanged" name="isTopChanged" value=""/>
	<input type="hidden" id="isMidChanged" name="isMidChanged" value=""/>
	<input type="hidden" id="allow_ip_mac_binding" name="allow_ip_mac_binding" value="<% getInfo("allow_ip_mac_binding");%>"/>	
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtLanSetting");</SCRIPT></h2>
<p><SCRIPT >ddw("txtNetworkStr3");</SCRIPT></p>
<br>
<p><b>
<SCRIPT >ddw("txtNetworkStr8");</SCRIPT>
</b></p>
<br>
<input class="button_submit" type="button" id="SaveSettings" name="SaveSettings" value="" onclick="page_submit();"/>
<input class="button_submit" type="button" id="DontSaveSettings" name="DontSaveSettings" value="" onclick="page_cancel();"/>
</div></div>
<div class="box" style="display:none" > 
<h3><SCRIPT >ddw("txtWANPortMode");</SCRIPT>	</h3>
<fieldset><p><label class="duple">
<SCRIPT >ddw("txtWANPortMode");</SCRIPT>
&nbsp;:</label><input type="hidden" name="config.wan_port_mode" id="wan_port_mode" value="0" />
<input id="wan_port_mode_radio_0" type="radio" name="wan_port_mode_radio" value="0" onclick="wan_port_mode_selector(this.value);"/>
<label>	<SCRIPT >ddw("txtRouterMode");</SCRIPT></label>
<input id="wan_port_mode_radio_1" type="radio" name="wan_port_mode_radio" value="1" onclick="wan_port_mode_selector(this.value);"/>
<label><SCRIPT >ddw("txtBridgeMode");</SCRIPT></label></p>
</fieldset></div>

<div id="box_op_mode">
<div class="box" style="display:none">
<h3><SCRIPT >ddw("txtNatEnableDisable");</SCRIPT></h3>
<p class="box_msg"> </p>
<fieldset>

<p><label class="duple"><SCRIPT >ddw("txtNatEnableDisable");</SCRIPT>:</label>
<input type="hidden" id="opModeSelect" name="opModeSelect" value=""/>	
<input type="radio" id="opMode_0" name="opMode" value="0" onclick="opMode_selector(this.value);wan_port_mode_selector(this.value);" />
<label><SCRIPT >ddw("txtRouterMode");</SCRIPT></label>
<input type="radio" id="opMode_1" name="opMode" value="1" onclick="opMode_selector(this.value);wan_port_mode_selector(this.value);" />
<label><SCRIPT >ddw("txtWirelessMode");</SCRIPT>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
(AP/AP Client/WDS/WDS with AP)</p></label>

</p></fieldset>
</div>



<div class="box"> 
<h3><SCRIPT >ddw("txtRouterSettings");</SCRIPT></h3>
<p class="box_msg"> </p><p><SCRIPT >ddw("txtNetworkStr4");</SCRIPT></p>
<fieldset><p><label class="duple">
<SCRIPT >ddw("txtRouterIPAddress");</SCRIPT>:</label>
<input type="text" id="lan_network_address" size="20" maxlength="15" value="" name="config.lan_network_address"/>
</p><p><label class="duple"><SCRIPT >ddw("txtSubnetMask");</SCRIPT>
:</label><input type="text" id="lan_subnet_mask" size="20" maxlength="15" value="" name="config.lan_subnet_mask"/>
</p><p style="display:none"><label class="duple"><SCRIPT >ddw("txtDeviceName");</SCRIPT>&nbsp;:</label>
<input type="text" id="lan_netbios_name" size="20" maxlength="32" value="" name="config.lan_netbios_name"/>
</p>
<div id="bridge_mode_only_settings"><p><label class="duple">
<SCRIPT >ddw("txtDefaultGateway");</SCRIPT>
:</label>	<input type="text" id="lan_gateway" size="20" maxlength="15" value="<% getInfo("gateway-rom");%>" name="config.lan_gateway"/><SCRIPT >ddw("txtOptional");</SCRIPT>
</p><p><label class="duple"><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>
&nbsp;:</label><input type="text" id="lan_primary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns1");%>" name="config.lan_primary_dns"/><SCRIPT >ddw("txtOptional");</SCRIPT>
</p><p><label class="duple">
<SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>
&nbsp;:</label><input type="text" id="lan_secondary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns2");%>" name="config.lan_secondary_dns" /><SCRIPT >ddw("txtOptional");</SCRIPT>
</p></div><div id="router_mode_only_settings"><p> 
<label class="duple"><SCRIPT >ddw("txtLocalDomainName");</SCRIPT>
:</label><input type="text" id="local_domain_name" size="20" maxlength="30" value="" name="config.local_domain_name"/> 

</p>
<p><label class="duple"><SCRIPT >ddw("txtEnableDNSRelay");</SCRIPT>
:</label><input type="hidden" id="dns_relay_enabled" name="config.dns_relay_enabled" value="true"/>
<input type="checkbox" id="dns_relay_enabled_select" onclick="dns_relay_enabled_selector(this.checked);"/>
</p></div></fieldset></div>

<div class="box" id="dhcp_server_enabled_section">
<h3><SCRIPT >ddw("txtDHCPServerSettings");</SCRIPT>	</h3>
<p><SCRIPT >ddw("txtNetworkStr5");</SCRIPT></p>
<fieldset><p><label class="duple">
<SCRIPT >ddw("txtEnableDHCPServer");</SCRIPT>
:</label>	<input type="hidden" id="dhcp_server_enabled" name="config.dhcp_server_enabled" value="1"/>
<input type="checkbox" id="dhcp_server_enabled_select" onclick="dhcp_server_enabled_selector(this.checked);"/>
</p><p><label class="duple"><SCRIPT >ddw("txtDHCPIPAddressRange");</SCRIPT>
:</label>
<input type="hidden" id="dhcp_server_range_ip_start"" name="config.dhcp_server_range_ip_start"	value=""/>
<input type="text" id="dhcp_ip_start" size="3" maxlength="3" value="" />
<label><SCRIPT >ddw("txtTo");</SCRIPT>
</label>
<input type="hidden" id="dhcp_server_range_ip_end"" name="config.dhcp_server_range_ip_end"	value=""/>
<input type="text" id="dhcp_ip_end" size="3" maxlength="3" value=""/><span id="dhcp_ip_range"></span>
</p><p><label class="duple"><SCRIPT >ddw("txtDHCPLeaseTime");</SCRIPT>
:</label>	<input type="text" id="dhcp_server_lease_time_max" size="10" maxlength="5" value="" name="config.dhcp_server_lease_time_max"/><SCRIPT >ddw("txtMinutes");</SCRIPT>
</p>
<p style="display:none"><label class="duple"><SCRIPT >ddw("txtAlwaysBroadcast");</SCRIPT>
:</label><input type="hidden" id="dhcp_server_always_broadcast" name="config.dhcp_server_always_broadcast" 	value="1"/>
<input type="checkbox" id="dhcp_server_always_broadcast_select" onclick="dhcp_server_always_broadcast_selector(this.checked);"/>
<SCRIPT >ddw("txtCompatibilityDHCPClients");</SCRIPT>
</p>
<p style="display:none"><label class="duple">
<SCRIPT >ddw("txtNetBIOSAnnouncement");</SCRIPT>
:</label><input type="hidden" id="lan_netbios_advertisement_enabled" name="config.lan_netbios_advertisement_enabled" 
value="false"/><input type="checkbox" id="lan_netbios_advertisement_enabled_select" onclick="lan_netbios_advertisement_enabled_selector(mf.dhcp_server_enabled.value == '1', this.checked);"/>
</p>
<p style="display:none"><label class="duple">
<SCRIPT >ddw("txtLearnNetBIOSfromWAN");</SCRIPT>
:</label>	<input type="hidden" id="lan_netbios_learn_from_wan_enabled" name="config.lan_netbios_learn_from_wan_enabled" 
value="false"/><input type="checkbox" id="lan_netbios_learn_from_wan_enabled_select" onclick="lan_netbios_learn_from_wan_enabled_selector(mf.lan_netbios_advertisement_enabled.value == 'true', this.checked);"/>
</p>

<div id="lan_wins_settings_1" style="display:none"><p> <label class="duple">
<SCRIPT >ddw("txtNetBIOSScope");</SCRIPT>
:</label><input type="text" id="lan_netbios_scope" size="20" maxlength="30" 	value="" 
name="config.lan_netbios_scope"/><SCRIPT >ddw("txtOptional");</SCRIPT>
</p><p><label class="duple">
<SCRIPT >ddw("txtNetBIOSNodeType");</SCRIPT>
&nbsp;:</label><input type="hidden" name="config.lan_netbios_registration_type" id="lan_netbios_registration_type" value="" />
<input id="lan_netbios_registration_type_radio_0" type="radio" name="lan_netbios_registration_type_radio" value="1" onclick="lan_netbios_registration_type_selector(this.value);"/>
<label><SCRIPT >ddw("txtBroadcastOnly");</SCRIPT>
</label></p><p><label class="duple"></label>
<input id="lan_netbios_registration_type_radio_1" type="radio" name="lan_netbios_registration_type_radio" value="2" onclick="lan_netbios_registration_type_selector(this.value);"/>
<label><SCRIPT >ddw("txtP2P");</SCRIPT>
</label></p><p><label class="duple"></label><input id="lan_netbios_registration_type_radio_2" type="radio" name="lan_netbios_registration_type_radio" value="4" onclick="lan_netbios_registration_type_selector(this.value);"/>
<label><SCRIPT >ddw("txtMixedMode");</SCRIPT>
</label><br/></p><p> 
<label class="duple"></label>
<input id="lan_netbios_registration_type_radio_3" type="radio" name="lan_netbios_registration_type_radio" value="8" onclick="lan_netbios_registration_type_selector(this.value);"/>
<label>
<SCRIPT >ddw("txtHybrid");</SCRIPT>
</label></p><p><label class="duple">
<SCRIPT >ddw("txtPrimaryWINSIPAddress");</SCRIPT>
:</label><input type="text" id="lan_netbios_primary_wins_ip" size="20" maxlength="15" value="0.0.0.0" 
name="config.lan_netbios_primary_wins_ip"/></p><p> 
<label class="duple"><SCRIPT >ddw("txtSecondaryWINSIPAddress");</SCRIPT>
:</label><input type="text" id="lan_netbios_secondary_wins_ip" size="20" maxlength="15" value="0.0.0.0" 
name="config.lan_netbios_secondary_wins_ip"/></p></div></fieldset></div>
</form>

<form id="editform" name="editform" action="" method="post">
<div class="box" id="dhcp_server_add_reservations" style="display:none">
<h3><SCRIPT >ddw("txtAdd");</SCRIPT><SCRIPT >ddw("txtDHCPReservation");</SCRIPT>
</h3><fieldset><p>
<input type="hidden" name="form_name" value="editform"/>				
<input type="hidden" name="edit_row" value="0"/>			
<input type="hidden" id="curTime" name="curTime" value=""/>							
<input type="hidden" id="used" /><input type="hidden" id="enabled" />
<input type="hidden" name="entry_id" value=""/>	
<input type="hidden" name="Action" value=""/>	
<label class="duple" for="enabled_select"><SCRIPT >ddw("txtEnable");</SCRIPT>
:</label>	<input type="checkbox" id="enabled_select" /></p><p> 
<label class="duple"><SCRIPT >ddw("txtComputerName");</SCRIPT>
:</label><input type="text" id="comp_name" size="20" maxlength="39" />
<span> &lt;&lt; </span><span id="dhcp_leases_pulldown_parent"></span></p>
<p><label class="duple"><SCRIPT >ddw("txtIPAddress");</SCRIPT>
:</label><input type="text" id="mac_ip" size="20" maxlength="15"/></p>
<p><label class="duple"><SCRIPT >ddw("txtMACAddress");</SCRIPT>
:</label>	<input type="text" id="mac_addr" size="20" maxlength="17" /></p>
<p><label class="duple"></label><input type="button" id="CopyPCsMACAddress"  class="button_submit" name="CopyPCsMACAddress" value="" onclick="clone_mac();"/>
</p><p><label class="duple"></label><input class="button_submit" type="button" id="Save" name="Save" value="" onclick="page_submit()" />
<input class="button_submit" type="button" id="Clear" name="Clear" value="" onclick="page_cancel()" />
</p></fieldset></div></form>

<form id="rulesform" name="rulesform" action="" method="post">
<div class="box" id="dhcp_server_reservations_list" style="display:none">
<h3><SCRIPT >ddw("txtDHCPReservation");</SCRIPT></h3>
<fieldset><table border="0" cellpadding="0" cellspacing="1" class="formlisting" id="dhcp_server_reservations" summary="">
<tr class="form_label_row"><th class="formlist_col1" rowspan="1" colspan="1">
<SCRIPT >ddw("txtEnable");</SCRIPT>
</th><th class="formlist_col2" rowspan="1" colspan="1">
<SCRIPT >ddw("txtComputerName");</SCRIPT>
</th><th class="formlist_col3" rowspan="1" colspan="1">
<SCRIPT >ddw("txtMACAddress");</SCRIPT>
</th><th class="formlist_col4" rowspan="1" colspan="1">
<SCRIPT >ddw("txtIPAddress");</SCRIPT>
</th><th class="formlist_col5" rowspan="1" colspan="1"></th>
<th class="formlist_col6" rowspan="1" colspan="1"></th></tr>
	<%dhcpRsvdIp_List("display_static");%>
</table><input type="hidden" id="free" value="1" /><input type="hidden" id="index" />
<input type="hidden" id="Action" name="Action" /><input type="hidden" id="revoke_ip" name="revoke_ip" /></fieldset>
</div></form>
<div class="box" id="dhcp_client_list"></div><!-- InstanceEndEditable -->
</div>

<form id="ipMacBindingform" action="" method="post">
<div class="box" id="wan_ping_box">
<h3><SCRIPT >ddw("txtArpAttack");</SCRIPT></h3>

<fieldset id="allow_up_mac_binding">
<p> 
<label class="duple" for="allow_wan_ping_select">
<SCRIPT >ddw("txtArpAttack");</SCRIPT>
&nbsp;:</label>
<input type="checkbox" id="allow_ip_mac_binding_select" onclick="allow_ip_mac_binding_selector(this.checked);"/>
</p>
</fieldset>
</div>
</form>
<form id="RsvdIPform" name="RsvdIPform" action="/goform/formSetDHCPResrvRule" method="post">
	<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<div class="box" id="" style="display:block">
<h3>24--<SCRIPT >ddw("txtDHCPReservation");</SCRIPT></h3>
<table border="0" cellpadding="0" cellspacing="1" class="formlisting">

<br><SCRIPT >ddw("txtRemainDHCPReservations");</SCRIPT>
 : <font color=red>
<%getIndexInfo("reamin_static_ip_num");%> 	
</font>

<tr>
<th class="duple">&nbsp;</th>
<th class="duple"><SCRIPT >ddw("txtComputerName");</SCRIPT></th>
<th class="duple"><SCRIPT >ddw("txtIPAddress");</SCRIPT></th>
<th class="duple"><SCRIPT >ddw("txtMACAddress");</SCRIPT></th>
<th class="duple">&nbsp;</th>
</tr>
<SCRIPT >reservedDhcpList(MAXNUM_RESERVED_DHCP);</SCRIPT>

</table>
<span id="xsl_span_computer_list_ipaddr_select" style="display:none"></span>
</div>
</form>
<SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>
</td>
<td id="sidehelp_container">
	
<div id="help_text">
<!-- InstanceBeginEditable name="Help_Text" --> 
<strong>	<SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtNetworkStr6");</SCRIPT></p>
<p><SCRIPT >ddw("txtNetworkStr7");</SCRIPT></p>
<p class="more"><!-- Link to more help --><a href="../Help/Basic.asp#Network" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>
</p><!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
