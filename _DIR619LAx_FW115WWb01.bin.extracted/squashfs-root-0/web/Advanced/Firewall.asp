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
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[
var MAXNUM_FIREWALL_RULES = "<% getInfo("maxFirewallRuleNum");%>"*1;

var schedule_options = [
	<%virSevSchRuleList();%>
];
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
return ("" !== "") ? "/Basic/Setup.asp" : "/Advanced/Firewall.asp";
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

var verify_failed = "<%getInfo("err_msg")%>";
var mf;
var computer_list_xslt_processor;
var computer_list_retriever;
var is_computer_list_ready = false;
var is_computer_list_xslt_ready = false;
var computer_list_xml_data;



function is_in_range(str_val, min, max)
{
	var d = decstr2int(str_val);
	if ( d > max || d < min ) return false;
	return true;
}

function on_off_selector(element, selector, value)
{	
if(selector.name == "dmz_enabled_select"){
mf.computer_list_ipaddr_select.disabled = !value;
mf.dmz_address.disabled = !value;
mf.copy_ip_button.disabled = !value;
}

element.value = value;
selector.checked = value;
}


function set_ip_from_computer_list(){
if(mf.computer_list_ipaddr_select.value != -1){
mf.dmz_address.value = mf.computer_list_ipaddr_select.value;
}
}

//Computer List
function populate_computer_list()
{
if (!(is_computer_list_ready && is_computer_list_xslt_ready)) {
return;
}
var parent = document.getElementById("xsl_span_computer_list_ipaddr_select");

while (parent.firstChild != null) {
parent.removeChild(parent.firstChild);
}

computer_list_xslt_processor.transform(computer_list_xml_data, window.document, parent);
copy_select_options(mf.computer_list_ip_address_pulldown, mf["computer_list_ipaddr_select"]);
mf["computer_list_ipaddr_select"].setAttribute("modified", "ignore");
mf.computer_list_ip_address_pulldown.setAttribute("modified", "ignore");
}

function computer_list_xslt_ready(dataInstance)
{
is_computer_list_xslt_ready = true;
computer_list_xslt_processor.addParameter("id_spec", "computer_list_ip_address_pulldown");
populate_computer_list();
}

function computer_list_ready(dataInstance)
{
computer_list_xml_data = dataInstance.getDocument();
is_computer_list_ready = true;
populate_computer_list();

window.setTimeout("computer_list_retriever.retrieveData()", 20000);
}

function computer_list_timeout(dataInstance)
{
window.setTimeout("computer_list_retriever.retrieveData()", 60000);
}

function computer_list_xslt_timeout(dataInstance)
{
window.setTimeout("computer_list_xslt_processor.retrieveData()", 20000);
}
		
function retrieve_xml_data()
{
if (!computer_list_xslt_processor) {
computer_list_xslt_processor = new xsltProcessingObject(computer_list_xslt_ready, computer_list_xslt_timeout, 6000, "../computer_ipaddr_list_acc.sxsl");
}
if (!computer_list_retriever) {
computer_list_retriever = new xmlDataObject(computer_list_ready, computer_list_timeout, 20000, "../dhcp_clients.asp");
}
computer_list_retriever.retrieveData();
computer_list_xslt_processor.retrieveData();

}

function page_load() 
{
	displayOnloadPage("<%getInfo("ok_msg")%>");
	mf = document.forms["mainform"];

	on_off_selector(mf.firewall_anti_spoof, mf.firewall_anti_spoof_select, mf.firewall_anti_spoof.value == "true");
	on_off_selector(mf.spi_enabled, mf.spi_enabled_select, mf.spi_enabled.value == "true");
	on_off_selector(mf.dmz_enabled, mf.dmz_enabled_select, mf.dmz_enabled.value == "true");
	on_off_selector(mf.alg_pptp, mf.alg_pptp_select, mf.alg_pptp.value == "true");
	on_off_selector(mf.alg_ipsec, mf.alg_ipsec_select, mf.alg_ipsec.value == "true");

	on_off_selector(mf.alg_rtsp, mf.alg_rtsp_select, mf.alg_rtsp.value == "true");
	on_off_selector(mf.alg_sip, mf.alg_sip_select, mf.alg_sip.value == "true");

	for (var index = 0; index < MAXNUM_FIREWALL_RULES; index++) {
		schedule_populate_select(mf["schedule_" + index]);
		mf["schedule_" + index].value = mf["sched_name_" + index].value;

		if(mf["fw_enable_" + index].value == 1)
			mf["fw_enable_" + index].checked=true;
		else
			mf["fw_enable_" + index].checked=false;

		mf["fw_pro_" + index].length=0;
		mf["fw_pro_" + index][0] = new Option("All", "1", false, false);
		mf["fw_pro_" + index][1] = new Option("TCP", "2", false, false);
		mf["fw_pro_" + index][2] = new Option("UDP", "3", false, false);
		mf["fw_pro_" + index][3] = new Option("ICMP", "4", false, false);

		mf["src_inf_" + index].selectedIndex = mf["firewall_src_inf_" + index].value;
		mf["fw_pro_" + index].selectedIndex = mf["firewall_fw_pro_" + index].value-1;
		mf["fw_action_" + index].selectedIndex = mf["firewall_fw_action_" + index].value;
		mf["dst_inf_" + index].selectedIndex = mf["firewall_dst_inf_" + index].value;
	}

	set_form_default_values("mainform");

	/* Check for validation errors. */
	if (verify_failed != "") {
		set_form_always_modified("mainform");
		alert(verify_failed);
	}

	window.setTimeout(retrieve_xml_data, 500);
}

function sched_name_selector(index, value)
{
mf["sched_name_"+index].value = value;
mf["schedule_"+index].value = value;
}

function page_submit(){
if (!is_form_modified("mainform"))  //nothing changed
{
if (!confirm(sw("txtSaveAnyway")))
return false;
}
else if(submitCheck()==true)
{
if(mf.dmz_enabled.value == "true")
{
//var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
var LAN_IP = "<% getInfo("ip-rom"); %>";//add by gold
//var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");
var LAN_MASK = "<% getInfo("mask-rom"); %>";
//var tarIp = ipv4_to_unsigned_integer(mf.dmz_address.value);
var tarIp = mf.dmz_address.value;
 if (is_valid_ip(mf.dmz_address.value,0)==false)
 {
 	alert("DMZ " +sw("txtIPAddress")+" ("+mf.dmz_address.value+") "+sw("txtisInvalid"));
	return false;
}
if(tarIp == LAN_IP)
{
	alert("DMZ " +sw("txtIPAddress")+" ("+mf.dmz_address.value+") "+sw("txtisInvalid"));
	return false;
}
if (!is_valid_ip2(tarIp,LAN_MASK,LAN_IP))
{
//alert("DMZ "+sw("txtAddress")+" "+sw("txtShouldWithinLanSubnet")+"("+integer_to_ipv4(LAN_IP & LAN_MASK)+")");
alert("DMZ "+sw("txtAddress")+" "+sw("txtShouldWithinLanSubnet")+"("+LAN_IP+"/"+LAN_MASK+")");//gold
return false;
}
}
mf["settingsChanged"].value = 1;		

}
else
{
return false;

}
/*
for (var index = 0; index < MAXNUM_FIREWALL_RULES; index++)
{
	var name = get_obj("fw_description_"+index).value;
	if(!is_blank(name))
	{
		get_obj("fw_desc_update_"+index).value = name.replace(/\//g,"\t");
	}
}
*/
mf.submit();
}


// convert dec integer string
function decstr2int(str)
{
	var i = -1;
	if (is_number(str)==true) i = parseInt(str, [10]);
	return i;
}

// make the object be focused, and set the value to 'val'.
function field_focus(obj, val)
{
	if (val != '**') obj.value = val;
	obj.focus();
	obj.select();
}

function submitCheck()
{
	var f=get_by_id("mainform");
	
	var LAN_IP = "<% getInfo("ip-rom"); %>";
	var LAN_MASK = "<% getInfo("mask-rom"); %>";
	for(i=0; i < MAXNUM_FIREWALL_RULES; i++)
	{
		tmp_fw_description	= eval("f.fw_description_"+	i+".value");
		tmp_src_inf			= eval("f.src_inf_"+		i+".value");
		tmp_src_startip		= eval("f.src_startip_"+	i+".value");
		tmp_src_endip		= eval("f.src_endip_"+		i+".value");
		tmp_dst_inf			= eval("f.dst_inf_"+		i+".value");
		tmp_dst_startip		= eval("f.dst_startip_"+	i+".value");
		tmp_dst_endip		= eval("f.dst_endip_"+		i+".value");
		tmp_dst_startport	= eval("f.dst_startport_"+	i+".value");
		tmp_dst_endport		= eval("f.dst_endport_"+	i+".value");
		tmp_fw_pro			= eval("f.fw_pro_"+			i+".value");

		for(j=0; j<tmp_fw_description.length; j++){
			char_code=tmp_fw_description.charCodeAt(j);
			if(char_code == 32){
				if(j == (tmp_fw_description.length - 1)){
					alert(sw("txtRuleNameInvalid"));
					mf["fw_description_" + i].select();
					mf["fw_description_" + i].focus();
					return false;
				}
			}
		}

		if(mf["fw_enable_" + i].checked==true && is_blank(tmp_fw_description))
		{
		    alert(sw("txtNameBlank"));
	    	return false;
		}
		else if(!is_blank(tmp_fw_description))
		{
			
				if(utf8len(tmp_fw_description) > 31){
					alert(sw("txtRuleNameInvalid"));	
					mf["fw_description_" + i].select();
					mf["fw_description_" + i].focus();				
					return false;
				}

			if(tmp_src_startip == tmp_dst_startip  ||tmp_src_endip == tmp_dst_endip)
			{
					alert(sw("txtFirewallStr17"));
					field_focus(get_by_id("dst_startip_"+i), "**");
					return false;
			}

								
			if (tmp_src_inf == "0")
			{
				alert(sw("txtFirewallStr20"));
				field_focus(get_by_id("src_inf_"+i), "**");
				return false;
			}
			if (tmp_dst_inf == "0")
			{
				alert(sw("txtFirewallStr19"));
				field_focus(get_by_id("dst_inf_"+i), "**");
				return false;
			}
			if (tmp_src_inf == tmp_dst_inf)
			{
				alert(sw("txtFirewallStr7"));
				field_focus(get_by_id("src_inf_"+i), "**");
				return false;
			}

			var src_iptype=3;
			var dst_iptype=3;
			var dst_porttype=3;

			/* src_startip */
			if (tmp_src_startip == tmp_src_endip) tmp_src_endip="";
			if (tmp_src_endip == "") src_iptype=2;
			if (tmp_src_startip=="*")
			{
				src_iptype=1;
				tmp_src_endip="";
				mf["src_endip_" + i].value="";
			}
			else if (!is_valid_ip(tmp_src_startip,0))
			{
				alert(sw("txtFirewallStr8"));
				field_focus(get_by_id("src_startip_"+i), "**");
				return false;
			}
			if (tmp_src_inf == "1")
			{
				net1 = get_network_id(tmp_src_startip, "<% getInfo("mask-rom"); %>");
				net2 = get_network_id("<% getInfo("ip-rom"); %>", "<% getInfo("mask-rom"); %>");
				if ((net1[0] != net2[0]))
				{
					alert(sw("txtFirewallStr9"));
					field_focus(get_by_id("src_startip_"+i), "**");
					return false;
				}
				if(!is_valid_ip2(tmp_src_startip,LAN_MASK,LAN_IP))
	            {
	                alert(sw("txtFirewallStr8"));
	                field_focus(get_by_id("src_startip_"+i), "**");
	                return false;
	            }
			}

			if (tmp_src_inf == "1")
			{
				var router_ip;
				var src_start_ip;
				var src_end_ip;
				router_ip = get_ip("<% getInfo("ip-rom"); %>");
				src_start_ip =  get_ip(tmp_src_startip) ;
				src_end_ip = get_ip(tmp_src_endip);
				if( (router_ip[4] == src_start_ip[4])|| (router_ip[4] == src_end_ip[4]))
				{
					alert(txtFirewallStr18);
					field_focus(get_by_id("src_startip_"+i), "**");
					return false;
				}
				if(decstr2int(router_ip[4])>decstr2int(src_start_ip[4]))
				{
					if(decstr2int(router_ip[4])<decstr2int(src_end_ip[4]))
					{
						alert(txtFirewallStr18);
						field_focus(get_by_id("src_startip_"+i), "**");
						return false;
					}
				}

				if(src_end_ip[4] == 255)
				{
					alert(txtFirewallStr17);
					field_focus(get_by_id("src_endip_"+i), "**");
					return false;
				}
			}

			/* src_endip */
			if (tmp_src_endip!="" &&( !is_valid_ip(tmp_src_endip,0)))
			{
				alert(sw("txtFirewallStr10"));
				field_focus(get_by_id("src_endip_"+i), "**");
				return false;
			}
			if (tmp_src_endip!="" && tmp_src_inf=="1")
			{
				net1 = get_network_id(tmp_src_endip, "<% getInfo("mask-rom"); %>");
				net2 = get_network_id("<% getInfo("ip-rom"); %>", "<% getInfo("mask-rom"); %>");
				if (net1[0] != net2[0])
				{
					alert(sw("txtFirewallStr11"));
					field_focus(get_by_id("src_endip_"+i), "**");
					return false;
				}
				if(!is_valid_ip2(tmp_src_endip,LAN_MASK,LAN_IP))
            	{
	                alert(sw("txtFirewallStr10"));
	                field_focus(get_by_id("src_endip_"+i), "**");
	                return false;
	            }
			}

			/* dst_startip */
			if (tmp_dst_startip==tmp_dst_endip) tmp_dst_endip="";
			if (tmp_dst_endip=="") dst_iptype=2;
			if (tmp_dst_startip=="*")
			{
				dst_iptype=1;
				tmp_dst_endip="";
				mf["dst_endip_" + i].value="";
			}
			else if (is_valid_ip(tmp_dst_startip,0)==false)
			{
				alert(sw("txtFirewallStr12"));
				field_focus(get_by_id("dst_startip_"+i), "**");
				return false;
			}
			if (tmp_dst_inf=="1")
			{
				net1 = get_network_id(tmp_dst_startip, "<% getInfo("mask-rom"); %>");
				net2 = get_network_id("<% getInfo("ip-rom"); %>", "<% getInfo("mask-rom"); %>");
				if (net1[0] != net2[0])
				{
					alert(sw("txtFirewallStr13"));
					field_focus(get_by_id("dst_startip_"+i), "**");
					return false;
				}
				if(!is_valid_ip2(tmp_dst_startip,LAN_MASK,LAN_IP))
	            {
	                alert(sw("txtFirewallStr12"));
	                field_focus(get_by_id("dst_startip_"+i), "**");
	                return false;
	            }
			} 


			if (tmp_dst_inf == "1")
			{
				var router_ip;
				var src_start_ip;
				var src_end_ip;
				router_ip = get_ip("<% getInfo("ip-rom"); %>");
				src_start_ip =  get_ip(tmp_dst_startip) ;
				src_end_ip = get_ip(tmp_dst_endip);
				
				if( (router_ip[4] == src_start_ip[4])|| (router_ip[4] == src_end_ip[4]))
				{
					alert(txtFirewallStr18);
					field_focus(get_by_id("dst_startip_"+i), "**");
					return false;
				}
				if(decstr2int(router_ip[4])>decstr2int(src_start_ip[4]))
				{
					if(decstr2int(router_ip[4])<decstr2int(src_end_ip[4]))
					{
						alert(txtFirewallStr18);
						field_focus(get_by_id("dst_startip_"+i), "**");
						return false;
					}
				}

				if(src_end_ip[4] == 255)
				{
					alert(txtFirewallStr17);
					field_focus(get_by_id("dst_endip_"+i), "**");
					return false;
				}
			}

			/* dst_endip */
			if (tmp_dst_endip!="" && is_valid_ip(tmp_dst_endip,0)==false)
			{
				alert(sw("txtFirewallStr14"));
				field_focus(get_by_id("dst_endip_"+i), "**");
				return false;
			}
			if (tmp_dst_endip!="" && tmp_dst_inf=="1")
			{
				net1 = get_network_id(tmp_dst_endip, "<% getInfo("mask-rom"); %>");
				net2 = get_network_id("<% getInfo("ip-rom"); %>", "<% getInfo("mask-rom"); %>");
				if (net1[0] != net2[0])
				{
					alert(sw("txtFirewallStr15"));
					field_focus(get_by_id("dst_endip_"+i), "**");
					return false;
				}
				if(!is_valid_ip2(tmp_dst_endip,LAN_MASK,LAN_IP))
            	{
	                alert(sw("txtFirewallStr14"));
	                field_focus(get_by_id("dst_endip_"+i), "**");
	                return false;
	            }
			}
			
			/* check if src startip is lesser than end ip */
			if (tmp_src_endip!="")
			{
				var src_sip=get_ip(tmp_src_startip);
				var src_eip=get_ip(tmp_src_endip);
				var j;
				var is_valid_src_ip_range=false;
				for (j=1; j<5; j++)
				{
					if (decstr2int(src_sip[j]) < decstr2int(src_eip[j]))
					{
						is_valid_src_ip_range=true;
						j=5;
					}
				}
				if (is_valid_src_ip_range==false)
				{
					alert(sw("txtFirewallStr16"));
					field_focus(get_by_id("src_startip_"+i), "**");
					return false;
				}
			}
			/* check if dst startip is lesser than end ip */
			if (tmp_dst_endip!="")
			{
				var dst_sip=get_ip(tmp_dst_startip);
				var dst_eip=get_ip(tmp_dst_endip);
				var j;
				var is_valid_dst_ip_range=false;
				for (j=1; j<5; j++)
				{
					if (decstr2int(dst_sip[j]) < decstr2int(dst_eip[j]))
					{
						is_valid_dst_ip_range=true;
						break;
					}
				}
				if (is_valid_dst_ip_range==false)
				{
					alert(sw("txtFirewallStr17"));
					field_focus(get_by_id("dst_startip_"+i), "**");
					return false;
				}
			}

			if (tmp_fw_pro=="1" || tmp_fw_pro=="2" || tmp_fw_pro=="3")
			{
				if (tmp_dst_startport != "")
				{

					if (is_valid_port_str(tmp_dst_startport)==false)
					{
						alert(sw("txtInvalidPortNumber"));
						field_focus(get_by_id("dst_startport_"+i), "**");
						return false;
					}

					if(tmp_dst_startport.charAt(0)=='0')
					{
						alert(sw("txtInvalidPortNumber"));
						field_focus(get_by_id("dst_startport_"+i), "**");
						return false;
					}
				}
				if (tmp_dst_endport != "")
				{
					if(tmp_dst_endport.charAt(0)=='0')
					{
						alert(sw("txtInvalidPortNumber"));
						field_focus(get_by_id("dst_endport_"+i), "**");
						return false;
					}
				}
				/* start port */
				if (tmp_dst_startport==tmp_dst_endport) tmp_dst_endport="";
				if (tmp_dst_endport=="") dst_porttype=2;
				if (tmp_dst_startport=="*")
				{
					dst_porttype=1;
					tmp_dst_endport="";
				}
				if (tmp_dst_endport !="")
				{
					if (is_valid_port_str(tmp_dst_endport)==false)
					{
						alert(sw("txtInvalidPortNumber"));
						field_focus(get_by_id("dst_endport_"+i), "**");
						return false;
					}
					if (is_valid_port_range_str(tmp_dst_startport, tmp_dst_endport)==false)
					{
						if(tmp_dst_startport > tmp_dst_endport){
							alert(sw("txtInvalidSoucebigdest"));
						}else{
							alert(sw("txtInvalidPortRange"));
						}
						field_focus(get_by_id("dst_startport_"+i), "**");
						return false;
					}
				}
				else if (is_valid_port_str(tmp_dst_startport)==false)
				{
					alert(sw("txtInvalidPortNumber"));
					field_focus(get_by_id("dst_startport_"+i), "**");
					return false;
				}
			}	
			
			//check same rule exist or not			
			for(j=0; j < i; j++)
			{
				if(eval("f.src_inf_"+j+".value") == tmp_src_inf && eval("f.src_startip_"+j+".value") == tmp_src_startip
				&& eval("f.src_endip_"+j+".value") == eval("f.src_endip_"+i+".value") 
				&& eval("f.fw_pro_"+j+".value") == tmp_fw_pro
				&& eval("f.schedule_"+j+".value") == eval("f.schedule_"+i+".value")
				&& eval("f.fw_action_"+j+".value") == eval("f.fw_action_"+i+".value")
				&& eval("f.dst_inf_"+j+".value") == tmp_dst_inf && eval("f.dst_startip_"+j+".value") == tmp_dst_startip 
				&& eval("f.dst_endip_"+j+".value") == eval("f.dst_endip_"+i+".value") 
				&& eval("f.dst_startport_"+j+".value") == tmp_dst_startport
				&& eval("f.dst_endport_"+j+".value") == eval("f.dst_endport_"+i+".value"))
				{
					alert(sw("txtName")+" '"+get_obj("fw_description_"+i).value+"' "+sw("txtAlreadyUsed"));
					field_focus(get_by_id("fw_description_"+i), "**");
					return false;
				}
			}

			
		}
	}
	
	for (var index = 0; index < MAXNUM_FIREWALL_RULES; index++) 
	{
		if(mf["fw_enable_" + index].checked==true)
			mf["fw_enable_" + index].value = 1;
	else
			mf["fw_enable_" + index].value = 0;
}
	
	return 1;
}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtAdvanced")+'/'+sw("txtFirewall2");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");			
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");		
}

var token= new Array(MAXNUM_FIREWALL_RULES);
var DataArray = new Array();
function fireallRulesList(num)
{
	token[0]="<% firewallRule_row("firewallRule_1");%>";
	token[1]="<% firewallRule_row("firewallRule_2");%>";
	token[2]="<% firewallRule_row("firewallRule_3");%>";
	token[3]="<% firewallRule_row("firewallRule_4");%>";
	token[4]="<% firewallRule_row("firewallRule_5");%>";
	token[5]="<% firewallRule_row("firewallRule_6");%>";
	token[6]="<% firewallRule_row("firewallRule_7");%>";
	token[7]="<% firewallRule_row("firewallRule_8");%>";
	token[8]="<% firewallRule_row("firewallRule_9");%>";
	token[9]="<% firewallRule_row("firewallRule_10");%>";
	token[10]="<% firewallRule_row("firewallRule_11");%>";
	token[11]="<% firewallRule_row("firewallRule_12");%>";
	token[12]="<% firewallRule_row("firewallRule_13");%>";
	token[13]="<% firewallRule_row("firewallRule_14");%>";
	token[14]="<% firewallRule_row("firewallRule_15");%>";
	token[15]="<% firewallRule_row("firewallRule_16");%>";
	token[16]="<% firewallRule_row("firewallRule_17");%>";
	token[17]="<% firewallRule_row("firewallRule_18");%>";
	token[18]="<% firewallRule_row("firewallRule_19");%>";
	token[19]="<% firewallRule_row("firewallRule_20");%>";
	token[20]="<% firewallRule_row("firewallRule_21");%>";
	token[21]="<% firewallRule_row("firewallRule_22");%>";
	token[22]="<% firewallRule_row("firewallRule_23");%>";
	token[23]="<% firewallRule_row("firewallRule_24");%>";
	token[24]="<% firewallRule_row("firewallRule_25");%>";
	token[25]="<% firewallRule_row("firewallRule_26");%>";
	token[26]="<% firewallRule_row("firewallRule_27");%>";
	token[27]="<% firewallRule_row("firewallRule_28");%>";
	token[28]="<% firewallRule_row("firewallRule_29");%>";
	token[29]="<% firewallRule_row("firewallRule_30");%>";
	token[30]="<% firewallRule_row("firewallRule_31");%>";
	token[31]="<% firewallRule_row("firewallRule_32");%>";
	token[32]="<% firewallRule_row("firewallRule_33");%>";
	token[33]="<% firewallRule_row("firewallRule_34");%>";
	token[34]="<% firewallRule_row("firewallRule_35");%>";
	token[35]="<% firewallRule_row("firewallRule_36");%>";
	token[36]="<% firewallRule_row("firewallRule_37");%>";
	token[37]="<% firewallRule_row("firewallRule_38");%>";
	token[38]="<% firewallRule_row("firewallRule_39");%>";
	token[39]="<% firewallRule_row("firewallRule_40");%>";
	token[40]="<% firewallRule_row("firewallRule_41");%>";
	token[41]="<% firewallRule_row("firewallRule_42");%>";
	token[42]="<% firewallRule_row("firewallRule_43");%>";
	token[43]="<% firewallRule_row("firewallRule_44");%>";
	token[44]="<% firewallRule_row("firewallRule_45");%>";
	token[45]="<% firewallRule_row("firewallRule_46");%>";
	token[46]="<% firewallRule_row("firewallRule_47");%>";
	token[47]="<% firewallRule_row("firewallRule_48");%>";
	token[48]="<% firewallRule_row("firewallRule_49");%>";
	token[49]="<% firewallRule_row("firewallRule_50");%>";
	
	for (var i = 0; i < num; i++)
	{
		DataArray = token[i].split("/"); /* 0:comment, 1:enabled, 2:action, 3:protoType, 4:fromPort, 5:toPort, 6:srcFrom, 7:srcTo , 8:dstFrom, 9:dstTo, 10:scheRule, 11:src_interface, 12:dst_interface */
		document.write("<tr><td align=middle rowspan='2'><input type=checkbox id='fw_enable_"+i+"' name='en_"+i+"' value='"+DataArray[1]+"' ></td>");
		document.write("		<td align=left valign='bottom'>"+sw("txtName")+"<input type='text' id='fw_description_"+i+"' name='fw_description_"+i+"' size=8 maxlength='31' value='"+DataArray[0].replace(/\t/g,"/")+"'>"+"</td>");
		document.write("		<td align=left valign='bottom'>");
		document.write("      <input type='hidden' id='firewall_src_inf_"+i+"' value='"+DataArray[11]+"' />");			
		document.write("			<select id='src_inf_"+i+"' name='sinf_"+i+"' selectedValue='"+DataArray[11]+"'>");
		document.write("				<option value=0>"+sw("txtSource")+"</option>");
		document.write("				<option value=1>LAN</option>");
		document.write("				<option value=2>WAN</option>");
		
		document.write("			</select></td><td align=middle valign='bottom'>");
		document.write("			<input type=text id='src_startip_"+i+"' name='s_s_ip_"+i+"' maxlength=15 size=16 value='"+DataArray[6]+"'>");
		document.write("			<input type=text id='src_endip_"+i+"' name='s_e_ip_"+i+"' maxlength=15 size=16 value='"+DataArray[7]+"'>");
		document.write("		</td><td align=left valign='bottom'>"+sw("txtProtocol"));
		document.write("      <input type='hidden' id='firewall_fw_pro_"+i+"' value='"+DataArray[3]+"' />");						
		document.write("			<select id='fw_pro_"+i+"' name='pro_"+i+"' selectedValue='"+DataArray[3]+"' onchange='protocolChange(this.value,"+ i +")'");
		document.write("				<option value='1'>ALL</option>");
		document.write("				<option value='2'>TCP</option>");
		document.write("				<option value='3'>UDP</option>");
		document.write("				<option value='4'>ICMP</option>");
		document.write("			</select></td><td align=left valign=middle style='white-space:nowrap' rowspan='2'>");
		document.write("      <input type=\"hidden\" id=\"sched_name_"+i+"\" name=\"sc_name_"+i+"\" value=\""+DataArray[10]+"\" />");
		document.write("			<select id='schedule_"+i+"' onChange=\"sched_name_selector(&quot;"+i+"&quot;, this.value);\">");
		document.write("			</select>&nbsp;");
		document.write("			<input type='button' id='schedule_"+i+"_btn' value='"+sw("txtAddNew")+"' onclick='do_add_new_schedule()'>");
		document.write("		</td></tr><tr><td align=left valign='bottom'>"+sw("txtAction")+"<br>");
		document.write("      <input type='hidden' id='firewall_fw_action_"+i+"' value='"+DataArray[2]+"' />");						
		document.write("			<select id='fw_action_"+i+"' name='act_"+i+"' selectedValue='"+DataArray[2]+"'>");
		document.write("				<option value='0'>"+sw("txtDeny")+"</option>");
		document.write("				<option value='1'>"+sw("txtAllow")+"</option>");
		document.write("			</select></td><td align=left valign='bottom'>");
		document.write("      <input type='hidden' id='firewall_dst_inf_"+i+"' value='"+DataArray[12]+"' />");						
		document.write("			<select id='dst_inf_"+i+"' name='dinf_"+i+"' selectedValue='"+DataArray[12]+"'>");
		document.write("				<option value=0>"+sw("txtDest")+"</option>");
		document.write("				<option value=1>LAN</option>");
		document.write("				<option value=2 selected>WAN</option>");
		document.write("			</select></td><td align=middle valign='bottom'>");
		document.write("			<input type=text id='dst_startip_"+i+"' name='d_s_ip_"+i+"' maxlength=15 size=16 value='"+DataArray[8]+"'>");
		document.write("			<input type=text id='dst_endip_"+i+"' name='d_e_ip_"+i+"' maxlength=15 size=16 value='"+DataArray[9]+"'>");
		document.write("		</td><td align=left valign='bottom'>"+sw("txtPortRangeFire")+"<br>");
		document.write("			<input type=text id='dst_startport_"+i+"' name='d_s_port_"+i+"' maxlength=5 size=6 value='"+DataArray[4]+"'>");
		document.write("			<input type=text id='dst_endport_"+i+"' name='d_e_port_"+i+"' maxlength=5 size=6 value='"+DataArray[5]+"'>");
		document.write("		</td></tr>");

		if (DataArray[3] == 4)
			protocolChange(DataArray[3], i);		
	}
}

function protocolChange(selectValue, index)
{
	if(selectValue == 4)
	{
		get_by_id("dst_startport_"+index).value="";
		get_by_id("dst_endport_"+index).value="";
		get_by_id("dst_startport_"+index).disabled=true;
		get_by_id("dst_endport_"+index).disabled=true;
	
	}
	else
	{
		get_by_id("dst_startport_"+index).disabled=false;
		get_by_id("dst_endport_"+index).disabled=false;
	}

}
function do_add_new_schedule()
{
	top.location = "../Tools/Schedules.asp";
}
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load(); init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr>
<td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr>
<td id="sidenav_container">
<div id="sidenav">
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
<SCRIPT >
DrawLanguageList();
</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td>
<td id="maincontent_container">
<SCRIPT >
DrawRebootContent("wan");
</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" >
<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<form id="mainform" action="/goform/formAdvFirewall" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section">
<div class="section_head"> 
<h2><SCRIPT >ddw("txtFirewall2");</SCRIPT></h2>
<p><SCRIPT >ddw("txtFirewallStr1");</SCRIPT></p>
<SCRIPT language=javascript>DrawSaveButton();</SCRIPT>
</div>

<div class="box"><h3><SCRIPT >ddw("txtAntiSpoof");</SCRIPT></h3>
<fieldset>
<p><label class="duple">
<SCRIPT >ddw("txtEnable");</SCRIPT>
<SCRIPT >ddw("txtAntiSpoof");</SCRIPT>:</label>
<input type="hidden" id="firewall_anti_spoof" name="anti_spoof" value="<%getIndexInfo("antiSpoofing");%>"/>
<input type="checkbox" id="firewall_anti_spoof_select" onclick="on_off_selector(firewall_anti_spoof, this, this.checked);"/>
</p>
</fieldset>
</div>

<div class="box"><h3><SCRIPT >ddw("txtFirewallSetting");</SCRIPT></h3>
<fieldset>
<p><label class="duple">
<SCRIPT >ddw("txtEnable");</SCRIPT>
SPI:</label>
<input type="hidden" id="spi_enabled" name="spi_enabled" value="<%getIndexInfo("spi_Enabled");%>"/>
<input type="checkbox" id="spi_enabled_select" name="spi_enabled_select" value="" onclick="on_off_selector(spi_enabled, this, this.checked);"/>
</p>
</fieldset>
</div>

<div class="box">
<h3><SCRIPT >ddw("txtDMZHost");</SCRIPT></h3>
<p><SCRIPT >ddw("txtFirewallStr2");</SCRIPT></p>
<p><SCRIPT >ddw("txtFirewallStr3");</SCRIPT></p>
<fieldset>
<p><label class="duple" >
<SCRIPT >ddw("txtEnableDMZ");</SCRIPT> :</label>
<input type="hidden" id="dmz_enabled" name="dmz_enabled" value="<% getIndexInfo("dmzEnabled"); %>"/>
<input type="checkbox" id="dmz_enabled_select" onclick="on_off_selector(dmz_enabled, this, this.checked);"/>
</p><p><label class="duple">DMZ 
<SCRIPT >ddw("txtIPAddress");</SCRIPT> 
&nbsp;:</label>
<input type="text" id="dmz_address" size="20" maxlength="15" value="<% getInfo("dmzHost") %>" name="dmz_address"/>
<input type="button" class="arrow" id="copy_ip_button" value="&lt;&lt;" onClick="set_ip_from_computer_list()"/>
<select id="computer_list_ipaddr_select" style="width: 150px;">
<option value="-1"><SCRIPT >ddw("txtComputerName");</SCRIPT></option>
</select>
</p>
</fieldset>
</div>
<div class="box"> 
<h3><SCRIPT >ddw("txtALGConfiguration");</SCRIPT></h3>
<fieldset>
<p style="display:none"><label class="duple">PPTP&nbsp;:</label>
<input type="hidden" id="alg_pptp" value="<%getIndexInfo("pptppassthrouh");%>"/>
<input type="checkbox" id="alg_pptp_select" onclick="on_off_selector(alg_pptp, this, this.checked);"/>
</p>
<p style="display:none"><label class="duple">IPSec&nbsp;(VPN)&nbsp;:</label>
<input type="hidden" id="alg_ipsec" value="<%getIndexInfo("ipsecpassthrouh");%>"/>
<input type="checkbox" id="alg_ipsec_select" onclick="on_off_selector(alg_ipsec, this, this.checked);"/>
</p>
<p><label class="duple">RTSP&nbsp;:</label>
<input type="hidden" id="alg_rtsp" name="alg_rtsp" value="<%getIndexInfo("rtspAlgEnabled");%>"/>
<input type="checkbox" id="alg_rtsp_select" onclick="on_off_selector(alg_rtsp, this, this.checked);"/>
</p>
<p style="display:none"><label class="duple">SIP&nbsp;:</label>
<input type="hidden" id="alg_sip" value="<%getIndexInfo("sipAlgEnabled");%>"/>
<input type="checkbox" id="alg_sip_select" onclick="on_off_selector(alg_sip, this, this.checked);"/>
</p>
<span id="xsl_span_computer_list_ipaddr_select" style="display:none"></span>
</fieldset>
</div></div>

<div class="box">
			<h2>50 - <SCRIPT >ddw("txtFirewallRules");</SCRIPT></h2>
			<br>
			<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>
				
				<SCRIPT >ddw("txtRemainRulesCanbeCreated");</SCRIPT>
 : <font color=red>
<%getIndexInfo("reamin_firewall_rule_num");%> 	
</font>
<br><br>

			<tbody>
			<tr>
				<td align=middle width=20>&nbsp;</td>
				<td>&nbsp;</td>
				<td class=c_tb><SCRIPT >ddw("txtStrInterface");</SCRIPT></div></td>
				<td class=c_tb><SCRIPT >ddw("txtIPAddress");</SCRIPT></td>
				<td>&nbsp;</td>
				<td class=c_tb><SCRIPT >ddw("txtSchedule");</SCRIPT></div></td>

			</tr>
<SCRIPT >fireallRulesList(MAXNUM_FIREWALL_RULES);</SCRIPT>
<tr>
	<td align=middle rowspan=2><input type='checkbox' checked disabled></td>
	<td align=left valign=bottom><SCRIPT >ddw("txtName");</SCRIPT><br>
		<input type=text size=8 maxlength=31 disabled value="PING from WAN">
	</td>
	<td align=left valign=bottom><select disabled><option>WAN</option></select></td>
	<td align=center valign=bottom>*</td>
	<td align=left valign=bottom><SCRIPT >ddw("txtProtocol");</SCRIPT><br><select disabled><option>ICMP</option></select></td>
	<td align=middle rowspan=2>&nbsp;</td>
</tr>
<tr>
	<td align=left valign=bottom>Action<br><select disabled><option><SCRIPT >ddw("txtAllow");</SCRIPT></option></select></td>
	<td align=left valign=bottom><select disabled><option>LAN</option></select></td>
	<td align=center valign=bottom><% getInfo("ip-rom"); %></td>
	<td align=left valign=bottom>Port<br><input type=text size=6 value=' ' disabled></td>
</tr>
			


<!--
<tr>
			<td align=middle rowspan="2">
				<input type=checkbox id='fw_enable_1' value="1"  checked>
			</td>
			<td align=left valign="bottom">Name
				<input type="text" id='fw_description_1' size=8 maxlength="31" value="test">
				
			</td>
			<td align=left valign="bottom">
				<select id='src_inf_100' selectedValue=1>
					<option value="0">Source</option>
					<option value="1">LAN</option>
					<option value="2">WAN</option>
				</select>
			</td>
			
		
		</tr>
		
-->		
		
		
		
			
			</table>
		</div>
</form>
<SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>
</div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtFirewallStr6");</SCRIPT></p>
<p class="more">
<a href="../Help/Advanced.asp#Firewall" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a></p>
</div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr><td><img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" /></td>
<td>&nbsp;</td></tr></table></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body></html>
