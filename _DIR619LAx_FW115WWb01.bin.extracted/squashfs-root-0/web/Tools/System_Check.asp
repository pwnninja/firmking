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
	return ("" !== "") ? "/Basic/Setup.asp" : "/Tools/System_Check.asp";
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

var mf;
var local_debug = false;
var pingXsltProcessor;
var dnsXsltProcessor;
var xmlData; // This will be an XMLDocument
var pingXsltReady = false;
var dnsXsltReady = false;
var ping_tx_count;
var ping_rx_count;
var rtt_min;
var rtt_max;
var rtt_avg;
var rtt_tot;
var host_name;
var xmlDataFetcher;
var stop_now;
var progress;
var ping_hint;
var ping_fail=0;
var ping_ok=0;
var ping_result;
var host_name_value;
function XsltReady(xmlDoc)
{
	pingXsltReady = true;
	dnsXsltReady = true;
}
//keep url length less than 63. if url is too lang , it will ugly in page.
function shorturl(url)
{
	var ret_url;
	if(url.length > 40)
	{
		ret_url = url.substr(0, 33); 
		ret_url += "......";
	}else{
		ret_url = url;
	}
	return ret_url;	
}
function dnsDataReady(xmlDoc)
{
	xmlData = xmlDoc.getDocument();
	var parent = document.getElementById("ping_ip");
	parent.innerHTML = "";
	dnsXsltProcessor.transform(xmlData, window.document, parent);
	host_name = parent.innerHTML;
	if(is_ipv4_valid(host_name)) {
		//progress.innerHTML += sw("txtResolvedTo") + host_name + ".<br/>";
		xmlDataFetcher = new xmlDataObject(pingDataReady, ping_timeout, 6000, "ssi_ping_test.asp?ip=" + host_name + "&ttl=128&size=64");
		xmlDataFetcher.retrieveData();
	} else {
		
		if(ping_tx_count==4){
			mf.ping.disabled = false;
			progress.innerHTML = shorturl(host_name_value)+"<br/>"+"<br/>";
			progress.innerHTML +=sw("txtPingResult")+':'+sw("txtPingTimeout");
			progress.innerHTML += "<br/>"+sw("txtUnableToResolveTheNameIsCorrect")+"<br/>";
		}else{
			xmlDataFetcher.dataURL =  "ssi_dns_resolve.asp?data=" + host_name_value;
			setTimeout("ping_tx_count++; xmlDataFetcher.retrieveData()", 1000);
		}
	}
}
function pingDataReady(xmlDoc)
{
	if(xmlDoc.getElementData("reply_millis_0")){
		update_stats(xmlDoc);
	}

	xmlData = xmlDoc.getDocument();
	var parent = document.getElementById("ping_list");
	parent.innerHTML = '';
	pingXsltProcessor.transform(xmlData, window.document, parent);
	//progress.innerHTML += parent.innerHTML;
	//progress.innerHTML +='<br>';
if(ping_tx_count==4)
	stop_now=1;
if(parent.innerHTML=='Fail'){
	ping_fail++;
}else{
	ping_ok++;
}
	
	if(stop_now == 0) {
		xmlDataFetcher.dataURL =  "ssi_ping_test.asp?ip=" + host_name + "&ttl=128" + "&size=64";
		setTimeout("ping_tx_count++; xmlDataFetcher.retrieveData()", 2000);
	} else {
		display_ping_result();
		}
}

function update_stats(dataInstance){
	ping_rx_count++;
	rtt = dataInstance.getElementData("reply_millis_0") *1;
	if(rtt > rtt_max)
		rtt_max = rtt;
	if(rtt < rtt_min)
		rtt_min = rtt;
		rtt_tot += rtt;
	rtt_avg = parseInt(rtt_tot / ping_rx_count);
}

function display_ping_result(){
	
		
	if(ping_ok > 0){
		progress.innerHTML =  shorturl(host_name_value)+"<br/><br/>";
		progress.innerHTML +=sw("txtPingResult")+':'+sw("txtPingSuccess");
	}else{
		progress.innerHTML =  shorturl(host_name_value)+"<br/><br/>";
		progress.innerHTML +=sw("txtPingResult")+':'+sw("txtPingTimeout");
	}	
	ping_tx_count = 0;
	ping_rx_count = 0;
	rtt_min = 10000;
	rtt_max = 0;
	rtt_avg = 0;
	rtt_tot = 0;
	ping_ok=0;
	ping_fail=0;
	mf.ping.disabled = false;
}


function display_stats(){
	progress.innerHTML += sw("txtUserStopped")+"<br/>";
	progress.innerHTML += sw("txtPingsSent")+" : "+ ping_tx_count + "<br/>";
	progress.innerHTML += sw("txtPingsReceived")+" : "+ ping_rx_count + "<br/>";
	progress.innerHTML += sw("txtPingsLost") + " : "+(ping_tx_count - ping_rx_count) 
							+ " (" + parseInt((100 - ((ping_rx_count / ping_tx_count) * 100)) + "")
							+ "% " +sw("txtLoss")+" )"+"<br/>";
	if(ping_rx_count != 0){
		progress.innerHTML += sw("txtShortestPingTime")+ " : " +rtt_min + "<br/>";
		progress.innerHTML += sw("txtLongestPingTime")+ " : " +rtt_max + "<br/>";
		progress.innerHTML += sw("txtAveragePingTime")+ " : "+rtt_avg + "<br/>";
	}
	ping_tx_count = 0;
	ping_rx_count = 0;
	rtt_min = 10000;
	rtt_max = 0;
	rtt_avg = 0;
	rtt_tot = 0;
	mf.ping.disabled = false;
}
function ping_timeout()
{
	//progress.innerHTML += sw("txtNoResponseFromRouter")+"<br/>";
ping_tx_count++; 
if(ping_tx_count < 4){
	xmlDataFetcher.retrieveData();
	}else{
		ping_ok=0;
		 display_ping_result()
	}
}

function get_timeout()
{
progress.innerHTML += sw("txtNoResponseFromRouter_table")+"<br/>";
}
function dns_timeout()
{
		progress.innerHTML = sw("txtUnableToResolveTheNameIsCorrect")+"<br/>";
		mf.ping.disabled = false;
		ping_tx_count = 0;
		ping_rx_count = 0;
		rtt_min = 10000;
		rtt_max = 0;
		rtt_avg = 0;
		rtt_tot = 0;
		ping_ok=0;
		ping_fail=0;
}
function process_start(type)
{
	host_name = mf.host_to_ping.value;
	host_name_value = mf.host_to_ping.value;
	host_name = trim_string(host_name);
	host_name_value = trim_string(host_name_value);
	if(host_name == "") { 
		alert(sw("txtEnterHostNameOrIPAddress"));
		return;
	}
	if (is_ipv4_valid(host_name) && host_name!="0.0.0.0" && !is_FF_IP(host_name)) {
		xmlDataFetcher = new xmlDataObject(pingDataReady, ping_timeout, 6000, "ssi_ping_test.asp?ip=" + host_name + "&ttl=128" + "&size=64");
	}else if (/^([.]*[0-9]*)*$/.test(host_name)) {
        alert(sw("txtInvalidWANIPaddress") + shorturl(host_name));
        return;
	} else {
		xmlDataFetcher = new xmlDataObject(dnsDataReady, dns_timeout, 33000, "ssi_dns_resolve.asp?data=" + host_name);
	}
	stop_now = 0;
	process_clean();
	ping_tx_count = 1;
	ping_rx_count = 0;
	mf.ping.disabled = true;
	progress.innerHTML = '<br><b><font color="blue">Pinging...</font></b><br>';
	xmlDataFetcher.retrieveData();
}
function process_stop()
{
	stop_now = 1;
}
function process_clean()
{
	document.getElementById("ping_list").innerHTML = "";
	progress.innerHTML = "";
}
var sDisConnect = sw("txtDisconnected");
cableTestLists=["",sw("txtInternet2"),sw("txtLan2")+"1",sw("txtLan2")+"2",sw("txtLan2")+"3",sw("txtLan2")+"4"];
linkType=[sDisConnect,"100Mbps "+sw("txtFULLDuplex"),"100Mbps "+sw("txtHALFDuplex"),"10Mbps "+sw("txtFULLDuplex"),"10Mbps "+sw("txtHALFDuplex")];


//sData=["","0","0","0","0","1"];
<%getIndexInfo("linkStatus");%>
function MoreInfo(name)
{
	window.open(name,"_blank","width=450,height=320");
}
function getConnectString(s)
{
	return linkType[isNaN(parseInt(s, [10]))? 0: parseInt(s, [10])];
}
function generateVS()
{
	var str=new String("");
	for (var i=1;i < 6;i++)
	{
		str+="<tr>";
		str+="<td width=64 height=20 align=center><b>"+cableTestLists[i]+"</b></td>";
		if (sData[i] != "0" && sData[i] != "")
		{
			str+="<td width=220 height=20>&nbsp;<img src=../Images/W_link.gif width=200 height=20 border=0></td>";
			str+="<td width=217 height=20>&nbsp;<strong>"+getConnectString(sData[i])+"</strong></td>";
		}
		else
		{
			str+="<td width=220 height=20>&nbsp;<img src=../Images/W_nolink.gif width=200 height=20 border=0></td>";
			str+="<td width=217 height=20>&nbsp;"+getConnectString(sData[i])+"</td>";
		}
		str+="<td width=17% height=20>"
		str+="<div align=left>"
		str+="<input type=button name=vct_test value=\""+sw("txtMoreInfo")+"\" onClick=\"MoreInfo('tools_vct_info.asp?port_id="+(i-1)+"')\">";
		str+="</div></td></tr>";
	}
	document.writeln(str);
}



function page_load() 
{
	
	if (local_debug) {
		hide_all_ssi_tr();
	}
	if(lang=="1"){
		pingXsltProcessor = new xsltProcessingObject(XsltReady, get_timeout, 6000, "ping_response_pack.sxsl");
	}else{
	pingXsltProcessor = new xsltProcessingObject(XsltReady, get_timeout, 6000, "ping_response.sxsl");
	}
	dnsXsltProcessor = new xsltProcessingObject(XsltReady, get_timeout, 6000, "dns_resolve.xsl");
	mf = document.forms["mainform"];
	progress = document.getElementById("ping_check_progress_field");
	progress.innerHTML = "<br/>"+"<br/>";
	//progress.innerHTML = sw("txtEnterHostNameOrIPAddressAndClickPing")+"<br/>";
	ping_hint = document.getElementById("ping_check_hint_field");
	ping_hint.innerHTML = "<br/>";
	ping_hint.innerHTML += sw("txtPingHints")+"<br/>"+"<br/>";
	rtt_min = 10000;
	rtt_max = 0;
	rtt_avg = 0;
	rtt_tot = 0;
	pingXsltProcessor.retrieveData();
	dnsXsltProcessor.retrieveData();
}
function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtTools")+'/'+sw("txtSystemCheck");
	document.title = DOC_Title;	
	get_by_id("RestartNow").value = sw("txtRebootNow");
	get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id('vct').style.display='block';
get_by_id('refreshing').style.display='none';
get_by_id('pingtest').style.display='block';
get_by_id('pingresult').style.display='block';
	
}
function page_init()
{
template_load(); 
setTimeout('init();',800)

}
//]]>
</script>

</head>
<body onload="page_init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
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
</SCRIPT>
</div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td>
<td id="maincontent_container">
<SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none">
<div class="section" ><div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
<!-- This division will be populated with configuration warning information -->
</div><!-- box warnings_section_content --></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<form name="mainform" action="dummy" onSubmit="process_start(); return false;" id="mainform">
<div class="section"><div class="section_head"> 




<h2><SCRIPT >ddw("txtSystemCheck");</SCRIPT></h2>
<p><SCRIPT >ddw("txtSystemCheckComment");</SCRIPT></p>
</div>

<div class="box" id="refreshing" style="display:block">
<h2><SCRIPT >ddw("txtVCTINFO");</SCRIPT></h2><br>
<div class=bc_tb>
	<center><b><font color="blue">Refreshing ...</font></b></center>
	</div>
	<br>
</div>
	
<div class="box" id="vct" style="display:none">
	<h2><SCRIPT >ddw("txtVCTINFO"); </SCRIPT></h2>
	<table borderColor=#ffffff cellSpacing=1 cellPadding=2 bgColor=#dfdfdf border=1>
	<tr id="box_header">
	<td width=64 height=25><div align="center"><strong><SCRIPT >ddw("txtPort");</SCRIPT></strong></div></td>
	<td width=220 height=25><div align="center"><strong><SCRIPT >ddw("txtLinkStatus");</SCRIPT></strong></div></td>
	<td width=217 height=25><div align="center">&nbsp;</div></td>
	<td width=109 height=25><div align="center">&nbsp;</div></td>
</tr>
<script>generateVS();</script>
</table>
</div>



<div class="box" id="pingtest" style="display:none"> 
<h3><SCRIPT >ddw("txtPingTest");</SCRIPT></h3>
<span id="ping_check_hint_field"></span>
<fieldset><p>	<div id="ping_list" style="display:none"></div>
<div id="ping_ip" style="display:none"></div>
<label class="duple" for="ping_addr">
<SCRIPT >ddw("txtHostNameOrIPAddress");</SCRIPT>
&nbsp;:</label>
<input type="text" id="ping_host" name="host_to_ping" size="30" maxlength="255" value=""/> 
<input type="button" value="Ping" name="ping" id="ping" onClick="process_start()"/>
</p></fieldset></div>
<div class="box" id="pingresult" style="display:none"> 
<h3><SCRIPT >ddw("txtPingResult");</SCRIPT></h3>
<center><span id="ping_check_progress_field"></span></center></div></div></form></div></td>
<td id="sidehelp_container">	<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtSystemCheckStr2");</SCRIPT>
</p><p class="more"><!-- Link to more help --><a href="../Help/Tools.asp#System_Check" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a></p>
</div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
