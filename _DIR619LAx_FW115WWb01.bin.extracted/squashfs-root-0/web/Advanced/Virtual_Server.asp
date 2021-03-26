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
var MAXNUM_VIRTUAL_SERVER = "<% getInfo("maxVirtualServer");%>"*1;
var MAXNUM_PORT_FW = "<% getInfo("maxPortFwNum");%>"*1;

function get_webserver_ssi_uri() {
return ("" !== "") ? "/Basic/Setup.asp" : "/Advanced/Virtual_Server.asp";
}

function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function fill_priv_port( who, inx )
{
	var pub_sport = get_by_id("vs_public_"+inx);
	var pub_eport = get_by_id("public_port_to_"+inx);
	var priv_sport = get_by_id("vs_private_"+inx);
	var priv_eport = get_by_id("private_port_to_"+inx);
	var hidden_private_eport = get_by_id("hidden_private_port_to_"+inx);
	if(who == "pub_start" && pub_sport.value != "")
	{
		if(pub_eport.value == "")
			pub_eport.value = pub_sport.value;
		if(priv_sport.value == "")
			priv_sport.value = pub_sport.value;
		priv_eport.value = parseInt(priv_sport.value) + (parseInt(pub_eport.value) - parseInt(pub_sport.value));
		hidden_private_eport.value=priv_eport.value;
	}
	if(who == "pub_end" && pub_eport.value != "")
	{
		if(pub_sport.value == "")
			pub_sport.value = pub_eport.value;
		if(priv_eport.value == "")
			priv_eport.value = pub_eport.value;
		priv_eport.value = parseInt(priv_sport.value) + (parseInt(pub_eport.value) - parseInt(pub_sport.value));
		hidden_private_eport.value=priv_eport.value;
	}
	if(who == "priv_start" && priv_sport.value != "")
	{
		if(pub_sport.value == "")
			pub_sport.value = priv_sport.value;
		if(pub_eport.value == "")
			pub_eport.value = priv_sport.value;
		priv_eport.value = parseInt(priv_sport.value) + (parseInt(pub_eport.value) - parseInt(pub_sport.value));
		hidden_private_eport.value=priv_eport.value;
	}
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

var schedule_options = [
	<%virSevSchRuleList();%>
];

var ingress_filter_options = [
	<%dumpInboundFilterList();%>  
];

var verify_failed = "<%getInfo("err_msg")%>";

var mf;

var computer_list_xslt_processor;
var computer_list_retriever;
var is_computer_list_ready = false;
var is_computer_list_xslt_ready = false;
var computer_list_xml_data;

var vs_table_size = MAXNUM_VIRTUAL_SERVER;
var vl = [
{ name: sw("txtApplicationName"), private_port: "", protocol: "", public_port: "", alg_assoc: "" },
{ name: sw("txtTELNET"), private_port: "23", protocol: "6", public_port: "23", alg_assoc: "" }, //1
{ name: sw("txtHTTP"), private_port: "80", protocol: "6", public_port: "80", alg_assoc: "" },
{ name: sw("txtHTTPS"), private_port: "443", protocol: "6", public_port: "443", alg_assoc: "" },  //3
{ name: sw("txtFTP"), private_port: "21", protocol: "6", public_port: "21", alg_assoc: "FTP" },
{ name: sw("txtDNS"), private_port: "53", protocol: "17", public_port: "53", alg_assoc: "" }, //5
{ name: sw("txtSMTP"), private_port: "25", protocol: "6", public_port: "25", alg_assoc: "" },
{ name: sw("txtPOP3"), private_port: "110", protocol: "6", public_port: "110", alg_assoc: "" }, //7
{ name: sw("txtH323"), private_port: "1720", protocol: "6", public_port: "1720", alg_assoc: "H.323" },
{ name: sw("txtRemoteDesktop"), private_port: "3389", protocol: "6", public_port: "3389", alg_assoc: "" }, //9
{ name: sw("txtPPTP"), private_port: "1723", protocol: "6", public_port: "1723", alg_assoc: "PPTP Control" },
{ name: sw("txtL2TP"), private_port: "1701", protocol: "17", public_port: "1701", alg_assoc: "" }, //11
{ name: sw("txtWakeOnLAN"), private_port: "9", protocol: "17", public_port: "9", alg_assoc: "Wake-On-LAN" }
];

function populate_vs_list(select_field)
{
select_field.options.length = 0;
for (var j = 0; j < vl.length; j++) {
select_field.options.add(new Option(vl[j].name, j));
}
select_field.setAttribute("modified", "ignore");
select_field.onfocus = null;
select_field.onmouseover = null;
}

function vs_enabled_selector(index, value) {
mf["vs_enabled_" + index].value = value;
mf["vs_enabled_select_" + index].checked = value;
mf["vs_used_" + index].value = 1;
}

function vs_name_selector(index, value)
{
mf["vs_name_"+index].value = value;
}

function vs_ingress_filter_name_selector(index, value)
{
mf["vs_ingress_filter_name_"+index].value = value;
//mf["vs_ingress_filter_name_select_"+index].value = value;
mf["vs_used_" + index].value = 1;
}

function vs_ipaddr_selector(index, value)
{
mf["vs_ipaddr_"+index].value = value;
}

function computer_list_ipaddr_selector(index)
{
var value = mf["computer_list_ipaddr_select_"+index].value;
if (value != -1){
vs_ipaddr_selector(index, value);
}
mf["computer_list_ipaddr_select_"+index].value = -1;
}

function vs_private_selector(index, port)
{
mf["vs_private_"+index].value = port;
mf["private_port_to_"+index].value = port;
mf["hidden_private_port_to_" + index].value = port;
}

function vs_proto_selector(index, value)
{
if (value != -1) {
mf["vs_proto_" + index].value = value;
}
if (value == "6" || value == "17" || value == "257") {
mf["vs_proto_select_" + index].value = value;
} else {
mf["vs_proto_select_" + index].value = -1;
}

var disabled = (value != "6" && value != "17" && value != "257");
mf["vs_public_" + index].disabled = disabled;
mf["vs_private_" + index].disabled = disabled;
}

function vs_public_selector(index, port)
{
mf["vs_public_"+index].value = port;
mf["public_port_to_"+index].value = port;
}

function vs_sched_name_selector(index, value)
{
mf["vs_sched_name_"+index].value = value;
mf["vs_sched_name_select_"+index].value = value;
mf["vs_used_" + index].value = 1;
}

function vs_entry_selector(index)
{
var opt_index = mf["default_virtual_servers_"+index].selectedIndex;

if (opt_index != 0) {
var vs = vl[opt_index];

vs_name_selector(index, vs.name);
vs_private_selector(index, vs.private_port);
vs_proto_selector(index, vs.protocol);
vs_public_selector(index, vs.public_port);
mf["default_virtual_servers_"+index].selectedIndex = 0;
}
}

function populate_computer_list()
{
if (!(is_computer_list_ready && is_computer_list_xslt_ready)) {
return;
}
var parent = document.getElementById("xsl_span_computer_list_ipaddr_select");

/*
* Clear existing pulldown list
*/
while (parent.firstChild != null) {
parent.removeChild(parent.firstChild);
}

computer_list_xslt_processor.transform(computer_list_xml_data, window.document, parent);
for (var i = 0; i < vs_table_size; i++) {
copy_select_options(mf.computer_list_ip_address_pulldown, mf["computer_list_ipaddr_select_" + i]);
mf["computer_list_ipaddr_select_" + i].setAttribute("modified", "ignore");
mf.computer_list_ip_address_pulldown.setAttribute("modified", "ignore");
}
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

var PF_Port = [

];


function page_verify()
{
	var start;
	var end;
	var len=0;
for (var i = 0; i < vs_table_size; i++) 
{
if (mf["vs_enabled_" + i].value == "true" || mf["vs_enabled_" + i].value == true) {
var vs_name = mf["vs_name_" + i].value;
var vs_proto = mf["vs_proto_" + i].value;
var vs_private = mf["vs_private_" + i].value;
var vs_public = mf["vs_public_" + i].value;
var vs_public_port_to = mf["public_port_to_" + i].value; 
var vs_ipaddr = mf["vs_ipaddr_" + i].value;
var priv_port;
if(is_blank(vs_name)){
	alert(sw("txtNameBlank"));		
	return false;
}else if(utf8len(vs_name) > 15){
		alert(sw("txtRuleNameInvalid"));	
		mf["vs_name_" + i].select();
		mf["vs_name_" + i].focus();				
		return false;
}
var Router_ip = "<% getInfo("ip-rom"); %>";
if (is_blank(vs_ipaddr) || is_valid_ip(vs_ipaddr,0)==false || Router_ip==vs_ipaddr)//boer
{
//alert(vs_name + sw("txtInvalidIPAddressForVirSer") + ".");
alert(sw("txtPortForwarding") +" '"+vs_name+"'"+sw("txtDe")+ sw("txtIPaddressInvalid") + "!");//modified by gold
mf["vs_ipaddr_" + i].select();
mf["vs_ipaddr_" + i].focus();	
return 0;
}

if (vs_proto == "6" || vs_proto == "17" || vs_proto == "257") {
if (is_blank(vs_public))
{
		alert(sw("txtWarningBlank"));
		mf["vs_public_" + i].select();
		mf["vs_public_" + i].focus();	
		return 0;
}
if (is_blank(vs_public_port_to))
{
		vs_public_port_to = vs_public;
		mf["public_port_to_" + i].value = vs_public_port_to;
}
if (!is_valid_port_str(vs_public))
{
		alert(sw("txtInvalidPort"));
		mf["vs_public_" + i].select();
		mf["vs_public_" + i].focus();	
		return 0;
}
if (!is_valid_port_str(vs_public_port_to))
{
		alert(sw("txtInvalidPort"));
		mf["public_port_to_" + i].select();
		mf["public_port_to_" + i].focus();	
		return 0;
}
if (is_blank(vs_private))
{
				vs_private = vs_public;
				mf["vs_private_" + i].value = vs_private;
}else if (!is_valid_port_str(vs_private))
{
				alert(sw("txtInvalidPort"));
				mf["vs_private_" + i].select();
				mf["vs_private_" + i].focus();	
				return 0;
}

start = parseInt(vs_public, [10]);
end = parseInt(vs_public_port_to, [10]);

var bMAXNUM_TRIGPORT = "<% getInfo("maxTrigPortNum");%>"*1;
var btoken= new Array(bMAXNUM_TRIGPORT);
var bDataArray = new Array();

btoken[0]="<% triggporList("trigPort_1");%>"
btoken[1]="<% triggporList("trigPort_2");%>"
btoken[2]="<% triggporList("trigPort_3");%>"
btoken[3]="<% triggporList("trigPort_4");%>"
btoken[4]="<% triggporList("trigPort_5");%>"
btoken[5]="<% triggporList("trigPort_6");%>"
btoken[6]="<% triggporList("trigPort_7");%>"
btoken[7]="<% triggporList("trigPort_8");%>"
btoken[8]="<% triggporList("trigPort_9");%>"
btoken[9]="<% triggporList("trigPort_10");%>"
btoken[10]="<% triggporList("trigPort_11");%>"
btoken[11]="<% triggporList("trigPort_12");%>"
btoken[12]="<% triggporList("trigPort_13");%>"
btoken[13]="<% triggporList("trigPort_14");%>"
btoken[14]="<% triggporList("trigPort_15");%>"
btoken[15]="<% triggporList("trigPort_16");%>"
btoken[16]="<% triggporList("trigPort_17");%>"
btoken[17]="<% triggporList("trigPort_18");%>"
btoken[18]="<% triggporList("trigPort_19");%>"
btoken[19]="<% triggporList("trigPort_20");%>"
btoken[20]="<% triggporList("trigPort_21");%>"
btoken[21]="<% triggporList("trigPort_22");%>"
btoken[22]="<% triggporList("trigPort_23");%>"
btoken[23]="<% triggporList("trigPort_24");%>"

for(var j=0; j<bMAXNUM_TRIGPORT; j++)
{
	bDataArray = btoken[j].split("/");
	if((start <= bDataArray[4]) && (end >= bDataArray[4]))
	{
		var err_value = bDataArray[4];
		alert(sw("txtInvalidPort")+"["+err_value+"]"+sw("txtPort")+sw("txtIsAlreadyUsed"));
                mf["public_port_to_" + i].select();
                mf["public_port_to_" + i].focus();
		return false;
	}
}

//boer add 
len++;
for(var k=0; k<len; k++)//boer
{
	if(i == k)
		continue;

	chk_start=parseInt(mf["vs_public_" + k].value, [10]);
	chk_end=parseInt(mf["public_port_to_" + k].value, [10]);
					
	if((start<=chk_start && end>=chk_start)||(start>=chk_start&&start<=chk_end))
	{
		alert(sw("txtInvalidPort"));
		//		mf["vs_publice_" + k].select();
		//		mf["vs_publice_" + k].focus();
		return false;
	}
}

if (start > end)
{
alert(sw("txtInvalidPortRange"));
mf["public_port_to_" + i].select();
mf["public_port_to_" + i].focus();	
return false;
}
priv_port = parseInt(vs_private, [10]);
if ((end-start+priv_port)>65535)
{
	alert(sw("txtInvalidPort"));
	mf["vs_private_" + i].select();
	mf["vs_private_" + i].focus();	
	return false;
}
mf["private_port_to_" + i].value =end-start+priv_port;
mf["hidden_private_port_to_" + i].value =mf["private_port_to_" + i].value; 
}

var allow_wan_http = "<%getIndexInfo("wanaccessEnabled");%>";
var allow_wan_port = "<%getIndexInfo("webWanAccessport");%>";
if( allow_wan_http == "true") {
	if (vs_proto == "6" || vs_proto == "257") {
		if ( vs_public == allow_wan_port) {
		alert(sw("txtVirtualServer1") + "'" + vs_name + "'" );
		return 0;
		}
	}
}

}
else
{
if(mf["public_port_to_" + i].value == "" || mf["vs_public_" + i].value == "" || mf["vs_private_" + i].value == "")
	mf["hidden_private_port_to_" + i].value = "";

if(mf["vs_ipaddr_" + i].value == "" || is_valid_ip(mf["vs_ipaddr_" + i].value,0)==false)
	mf["vs_ipaddr_" + i].value = "0.0.0.0";
}
}

for (var i = 0; i < vs_table_size; i++) 
{
if (mf["vs_enabled_" + i].value == "true" || mf["vs_enabled_" + i].value == true)
{
var compareName = mf["vs_name_" + i].value;			
var vs_private = mf["vs_private_" + i].value;
var vs_public = mf["vs_public_" + i].value;
var vs_ipaddr = mf["vs_ipaddr_" + i].value;
var vs_proto = mf["vs_proto_"+i].value;

if(compareName == "")
{
alert(sw("txtNameBlank"));					
return 0;				
}

/* Check already exist */
for(var j=0; j<vs_table_size ;j++)
{
var tmp="vs_name_"+j;
if(i==j || mf["vs_enabled_" + j].value == 0 || mf["vs_enabled_" + j].value == false || mf["vs_enabled_" + j].value == "false")
{
continue;
}

if(get_by_id(tmp) != null)
{
if(get_by_id(tmp).value == compareName)
{
alert(sw("txtName")+" '"+get_by_id(tmp).value+"' "+sw("txtIsAlreadyUsed"));
return false;
}
}					

if(vs_public == mf["vs_public_" + j].value && mf["vs_proto_"+j].value == vs_proto)
{
var protoStr;
if(mf["vs_proto_"+j].value == 6)
protoStr = "TCP";
else if(mf["vs_proto_"+j].value == 17)
protoStr = "UDP";
else
protoStr = "BOTH";

alert("'"+mf["vs_name_" + i].value+"' "+"["+protoStr+":"+vs_public+"]->"+vs_ipaddr+":"+vs_private+" "+sw("txtConflictWithStr1")+"'"+mf["vs_name_" + j].value+"' [" +protoStr+":"+mf["vs_public_" + j].value+"]->"+mf["vs_ipaddr_" + j].value+":"+mf["vs_private_" + j].value+sw("txtConflictWithStr2"));

return false;
}

if(vs_ipaddr == mf["vs_ipaddr_" + j].value && vs_private == mf["vs_private_" + j].value)
{
var protoStr;
if(mf["vs_proto_"+j].value == 6)
protoStr = "TCP";
else if(mf["vs_proto_"+j].value == 17)
protoStr = "UDP";
else
protoStr = "BOTH";

alert("'"+mf["vs_name_" + i].value+"' "+"["+protoStr+":"+vs_public+"]->"+vs_ipaddr+":"+vs_private+" "+sw("txtConflictWithStr1")+" '"+mf["vs_name_" + j].value+"' [" +protoStr+":"+mf["vs_public_" + j].value+"]->"+mf["vs_ipaddr_" + j].value+":"+mf["vs_private_" + j].value+sw("txtConflictWithStr2"));
return false;
}						
}
}
}
// add by gold			
//var LAN_IP = ipv4_to_unsigned_integer("<% getInfo("ip-rom"); %>");
var lan_ip = "<% getInfo("ip-rom"); %>";
//var LAN_MASK = ipv4_to_unsigned_integer("<% getInfo("mask-rom"); %>");			
var lan_mask = "<% getInfo("mask-rom"); %>";			
for (var i = 0; i < vs_table_size; i++) 
{
if (mf["vs_enabled_" + i].value == "true" || mf["vs_enabled_" + i].value == true)
{
var tarIp = mf["vs_ipaddr_"+i].value;

//if(tarIp == lan_ip || (tarIp & ~LAN_MASK) == ~LAN_MASK || (tarIp & ~LAN_MASK) == 0x00000000)
/*if(is_valid_ip2(tarIp,lan_mask,lan_ip))
{
	alert(sw("txtIPAddress")+" ("+mf["vs_ipaddr_"+i].value+") "+sw("txtisInvalid"));
	return false;
}*/
if (is_valid_ip2(tarIp,lan_mask,lan_ip) == false)
{
alert(sw("txtPortForwarding")+" '"+mf["vs_name_" + i].value+"'"+sw("txtDeIPAddr")+sw("txtShouldWithinLanSubnet"));
return false;
}
}
}

return 1;
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
mf = document.forms.mainform;

displayOnloadPage("<%getInfo("ok_msg")%>");

for (var index = 0; index < vs_table_size; index++) {
//ingress_filter_populate_select(mf["vs_ingress_filter_name_select_" + index]);
//schedule_populate_select(mf["vs_sched_name_select_" + index]);
vs_proto_selector(index, mf["vs_proto_" + index].value);

mf["vs_enabled_select_" + index].checked = mf["vs_enabled_" + index].value == "1";
//mf["vs_ingress_filter_name_select_" + index].value = mf["vs_ingress_filter_name_" + index].value;
//mf["vs_sched_name_select_" + index].value = mf["vs_sched_name_" + index].value;
}
set_form_default_values("mainform");

/* Check for validation errors. */
if (verify_failed != "") {
set_form_always_modified("mainform");
alert(verify_failed);
}

window.setTimeout(retrieve_xml_data, 500);
}

function page_submit()
{
if (!is_form_modified("mainform"))  //nothing changed
{
if (!confirm(sw("txtSaveAnyway"))) 				
return false;
}
else
{
if (page_verify()) 
mf["settingsChanged"].value = 1;
else
return false;
}
mf.submit();
}

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtAdvanced")+'/'+sw("txtVirtualServer");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings").value = sw("txtSaveSettings");			
get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");			
}

var token= new Array(MAXNUM_VIRTUAL_SERVER);
var DataArray = new Array();

function virtualSerList(num)
{
token[0]="<% virtualServList("virtualServ_1");%>"
token[1]="<% virtualServList("virtualServ_2");%>"
token[2]="<% virtualServList("virtualServ_3");%>"
token[3]="<% virtualServList("virtualServ_4");%>"
token[4]="<% virtualServList("virtualServ_5");%>"
token[5]="<% virtualServList("virtualServ_6");%>"
token[6]="<% virtualServList("virtualServ_7");%>"
token[7]="<% virtualServList("virtualServ_8");%>"
token[8]="<% virtualServList("virtualServ_9");%>"
token[9]="<% virtualServList("virtualServ_10");%>"
token[10]="<% virtualServList("virtualServ_11");%>"
token[11]="<% virtualServList("virtualServ_12");%>"
token[12]="<% virtualServList("virtualServ_13");%>"
token[13]="<% virtualServList("virtualServ_14");%>"
token[14]="<% virtualServList("virtualServ_15");%>"
token[15]="<% virtualServList("virtualServ_16");%>"
token[16]="<% virtualServList("virtualServ_17");%>"
token[17]="<% virtualServList("virtualServ_18");%>"
token[18]="<% virtualServList("virtualServ_19");%>"
token[19]="<% virtualServList("virtualServ_20");%>"
token[20]="<% virtualServList("virtualServ_21");%>"
token[21]="<% virtualServList("virtualServ_22");%>"
token[22]="<% virtualServList("virtualServ_23");%>"
token[23]="<% virtualServList("virtualServ_24");%>"


for (var i = 0; i < num; i++)
{

DataArray = token[i].split("/"); /* Enabled:0, Name:1, Protocol:2, PublicPort:3, PrivatePort:4, Lanip:5, scheduleRule:6, inBoundFilterRule:7, PublicPortTo:8, PrivatePortTo:9 */

document.write("<tr>");
document.write("	<td class=\"centered\" rowspan=\"2\">");
document.write("		<input type=\"hidden\" name=\"index\" value=\""+(i+1)+"\" />");
document.write("		<input type=\"checkbox\" id=\"vs_enabled_select_"+i+"\" onclick=\"vs_enabled_selector(&quot;"+i+"&quot;, this.checked );\" />");
document.write("		<input type=\"hidden\" id=\"vs_enabled_"+i+"\" name=\"enabled_"+i+"\" value=\""+DataArray[0]+"\" />");
document.write("		<input type=\"hidden\" id=\"vs_used_"+i+"\" name=\"used_"+i+"\" value=\"0\" />");
document.write("	</td>");
document.write("	<td>");
document.write("		"+sw("txtName")+"<br />");
document.write("		<input type=\"text\" size=\"20\" maxlength=\"15\" id=\"vs_name_"+i+"\"  name=\"name_"+i+"\" value=\""+DataArray[1]+"\" />");
document.write("	</td>");
document.write("	<td class=\"bottom\">");
document.write("		<input type=\"button\" value=\"&lt;&lt;\" class=\"arrow\" onclick=\"vs_entry_selector(&quot;"+i+"&quot;)\" />");
document.write("		<select name=\"default_virtual_servers_"+i+"\" style=\"width:120px\" onfocus=\"populate_vs_list(this);\" onmouseover=\"populate_vs_list(this);\">");
document.write("			<option value=\"-1\">"+sw("txtApplicationName")+"</option>");
document.write("		</select>");
document.write("	</td>");
document.write("	<td class=\"centered\">");
document.write("		"+sw("txtPublic")+"<br />");
document.write("		<input type=\"text\" size=\"4\" maxlength=\"5\" id=\"vs_public_"+i+"\" name=\"public_port_"+i+"\" value=\""+DataArray[3]+"\" onchange=\"fill_priv_port('pub_start',"+i+");\" />");
document.write("		&nbsp;~&nbsp;<input type=\"text\" size=\"4\" maxlength=\"5\" id=\"public_port_to_"+i+"\" name=\"public_port_to_"+i+"\" value=\""+DataArray[8]+"\" onchange=\"fill_priv_port('pub_end',"+i+");\" />");
document.write("	</td>");
document.write("	<td class=\"centered\" rowspan='2'>");
document.write("		<br />");
document.write("		<select id=\"vs_proto_select_"+i+"\" onchange=\"vs_proto_selector(&quot;"+i+"&quot;, this.value);\" >");
document.write("			<option value=\"6\">TCP</option>");
document.write("			<option value=\"17\">UDP</option>");
document.write("			<option value=\"257\">"+sw("txtAny")+"</option>");
document.write("		</select>");
document.write("	</td>");
document.write("		<input type=\"hidden\" id=\"vs_sched_name_"+i+"\" name=\"sched_name_"+i+"\" value=\""+DataArray[6]+"\" />");
document.write("</tr>");
document.write("<tr>");
document.write("	<td>");
document.write("		"+sw("txtIPAddress")+"<br />");
document.write("		<input type=\"text\" size=\"20\" maxlength=\"15\" id=\"vs_ipaddr_"+i+"\" name=\"ip_"+i+"\" value=\""+DataArray[5]+"\" />");
document.write("	</td>");
document.write("	<td class=\"bottom\">");
document.write("		<input type=\"button\" value=\"&lt;&lt;\" class=\"arrow\" onclick=\"computer_list_ipaddr_selector(&quot;"+i+"&quot;)\" />");
document.write("		<select name=\"computer_list_ipaddr_select_"+i+"\" id=\"computer_list_ipaddr_select_"+i+"\" style=\"width: 120px;\" modified=\"ignore\">");
document.write("			<option value=\"-1\" selected=\"selected\">"+sw("txtComputerName")+"</option>");
document.write("		</select>");
document.write("	</td>");
document.write("	<td class=\"centered\">");
document.write("		"+sw("txtPrivate")+"<br />");
document.write("		<input type=\"text\" size=\"4\" maxlength=\"5\" id=\"vs_private_"+i+"\" name=\"private_port_"+i+"\" value=\""+DataArray[4]+"\" onchange=\"fill_priv_port('priv_start',"+i+");\"/>");
document.write("		&nbsp;~&nbsp;<input type=\"text\" size=\"4\" maxlength=\"5\" id=\"private_port_to_"+i+"\" name=\"private_port_to_"+i+"\" value=\""+DataArray[9]+"\" disabled = true />");
document.write("<input type=\"hidden\" size=\"4\" maxlength=\"5\" id=\"hidden_private_port_to_"+i+"\" name=\"hidden_private_port_to_"+i+"\" value=\""+DataArray[9]+"\" />");
document.write("	</td>");
document.write("	<td class=\"bottom centered\" style='display: none'>");
document.write("		<input type=\"text\" size=\"4\" maxlength=\"3\" id=\"vs_proto_"+i+"\" name=\"protocol_"+i+"\" value=\""+DataArray[2]+"\" />");
document.write("	</td>");

document.write("</tr>");
}
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
<h2>
<SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT>
</h2>
<div style="display:block" id="warnings_section_content">
</div></div></div></div>
<div id="maincontent" style="display: block">
<form name="mainform" action="/goform/formVirtualServ" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section">
<div class="section_head">
<h2><SCRIPT >ddw("txtVirtualServer");</SCRIPT></h2>
<p><SCRIPT >ddw("txtVirtualServer6");</SCRIPT></p>
<SCRIPT language=javascript>DrawSaveButton();</SCRIPT>
</div>
<div class="box">
<h3>24--<SCRIPT >ddw("txtVirtualServer");</SCRIPT></h3>
<table border="0" cellpadding="0" cellspacing="1" class="formlisting" id="adv_virtualserver_list" summary="">

<SCRIPT >ddw("txtRemainRulesCanbeCreated");</SCRIPT>
 : <font color=red>
<%getIndexInfo("reamin_virtual_num");%> 	
</font>
<br><br>

<tr class="form_label_row">
<th class="formlist_col1">&nbsp;</th>
<th class="formlist_col2">&nbsp;</th>
<th class="formlist_col3">&nbsp;</th>
<th class="formlist_col4"><SCRIPT >ddw("txtPort");</SCRIPT></th>
<th class="formlist_col5"><SCRIPT >ddw("txtTrafficType");</SCRIPT></th>
<th class="formlist_col6">&nbsp;</th>
</tr>
<SCRIPT >virtualSerList(MAXNUM_VIRTUAL_SERVER);</SCRIPT>
</table>
<span id="xsl_span_computer_list_ipaddr_select" style="display:none"></span>
</div></div></form>

<SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>

</div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtVirtualServer2");</SCRIPT></p>

<p class="more">
<a href="../Help/Advanced.asp#Gaming" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>
</p></div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr>
<td>
<img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td>
<td>&nbsp;
</td></tr></table></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body></html>
