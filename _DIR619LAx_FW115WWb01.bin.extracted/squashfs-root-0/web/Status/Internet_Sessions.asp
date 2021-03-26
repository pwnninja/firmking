<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />
<META http-equiv=Pragma content=no-cache >
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
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

/** Used by template.js.* You cannot put this function in a sourced file, because SSI will not process it.*/
function get_webserver_ssi_uri() {
	return ("" !== "") ? "/Basic/Setup.asp" : "/Status/Internet_Sessions.asp";
}
/** Perform initialization for items that belong to the DWT when page is loaded. */
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
/*
* For debuging the page on a local client.
*	This variable will be TRUE if this page is loaded locally in a browser,
*	and FALSE if this page is loaded from a live gateway,
*/
var local_debug = false;
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
	document.getElementById("internet_sessions").innerHTML = "";
	var parent = document.getElementById("internet_sessions");
	xsltProcessor.transform(xmlData, window.document, parent);
}
function onTimeout()
{
	xmlDataFetcher.retrieveData();
	document.getElementById("internet_sessions").innerHTML = "<strong>"+sw("txtFailedRetrieveSessionList")+"<\/strong>";
}

//['1','192.168.0.100','1958','192.168.0.1','80','430748'],
//['1','192.168.0.100','1975','192.168.0.1','80','430722'],
//['1','192.168.100.123','2672','192.168.100.1','80','431999']
//var tcpcount="3";
//var udpcount="0";
// natp
// tcp, srcip, sport, dstip, dport, time
dataList=[

["",""]
];

//var TCPSession = "3";
//var UDPSession = "0";

////////////////////////////////////////

///////////////////////////////////////
//var d_length=dataList.length-1;
//dataList.length=d_length;

function generateHTML()
{
	var str=new String("");
	//assign nx3 2D array.
	var udp_num=parseInt(UDPSession, [10]);
	var tcp_num=parseInt(TCPSession, [10]);
	var total_num= udp_num+tcp_num;
	if(total_num>0)
	var list= new Array(total_num);
	else
	var list= new Array(1);	
	for(i=0;i<total_num;i++)
		list[i]=new Array(3);
	
	
	
	var meet=false;
	var list_len=0;

	// find out all diffrent ip and list them into list[][];
	// list[j][0]: srcip,	list[j][1]: tcp num,	list[j][2]: udp num
	if(dataList.length>1)
	{
		list[0][0]=dataList[0][1];	//source ip
		list[0][1]=0;			//init tcp sum
		list[0][2]=0;			//init udp sum
		list_len++;

		// find out all diffrent ip and list them into list[][];
		
		for(var i=0; i<total_num;i++)
		{
			
			meet=false;
			for(j=0;j<list_len;j++)
			{
				if(dataList[i][1]!=list[j][0])	continue;
				else	{meet=true;	break;}
			}
			if(meet==false)
			{
				list[list_len][0]=dataList[i][1];	//source ip
				list[list_len][1]=0;			//init tcp sum
				list[list_len][2]=0;			//init udp sum
				list_len++;
			}
		}
		// count the tcp/udp number in the same source ip
		for(i=0; i<list_len;i++)
		{
			for(j=0;j<dataList.length;j++)
			{
				if(list[i][0]==dataList[j][1])
				{
					if(dataList[j][0]=="1")	list[i][1]++;	//tcp
					else			list[i][2]++;	//udp
				}
			}
		}
	}
//////20090513-patch-start//////////////
	// napt session
/*	
	str+="<div class='box'>";
	str+="<h2>"+sw("txtNAPTSession")+"</h2>";
	str+="<table cellpadding=1 cellspacing=1 border=0 width=525>";
	str+="<tr>";
	str+="	<td class=r_tb width=200>"+sw("txtTCPSession")+" :</td>";
	str+="	<td class=l_tb>&nbsp;&nbsp;"+TCPSession+"</td>";
	str+="</tr>";
	str+="<tr>";
	str+="	<td class=r_tb width=200>"+sw("txtUDPSession")+" :</td>";
	str+="	<td class=l_tb>&nbsp;&nbsp;"+UDPSession+"</td>";
	str+="</tr>";
	str+="<tr>";
	str+="	<td class=r_tb width=200>"+sw("txtTotal")+" :</td>";
	
	if(parseInt(TCPSession, [10]) || parseInt(UDPSession, [10]))
		str+="<td class=l_tb>&nbsp;&nbsp;"+(parseInt(TCPSession, [10])+parseInt(UDPSession, [10]))+"</td></tr>";
	else
		str+="<td class=l_tb>&nbsp;&nbsp;"+0+"</td></tr>";
	str+="</table>";
	str+="</div>";

	// natp active session list
	str+="<div class='box'>";
	str+="<h2>"+sw("txtNAPTActiveSession")+"</h2>";
	str+="<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>";
	str+="<tr id=box_header>";
	str+="<td class=bc_tb>"+sw("txtIPAddress")+"</td>";
	str+="<td class=bc_tb>"+sw("txtTCPSession")+"</td>";
	str+="<td class=bc_tb>"+sw("txtUDPSession")+"</td>";
	//str+="<td class=bc_tb>&nbsp;</td>";
	str+="</tr>";
	
	//for debug
	var debug=false;
	dbg="";
	
	for (var i=0; i<list_len; i++)
	{
		str+="<tr><td class=c_tb>"+list[i][0]+"</td>";
		str+="<td class=c_tb>"+list[i][1]+"</td>";
		str+="<td class=c_tb>"+list[i][2]+"</td>";

		str +="</tr>";
	}
	str+="</table>";
	str+="</div>";
	

	document.writeln(str);
*/	
//////20090513-patch-end//////////////
}
function do_refresh()
{
	var CurrentTime=new Date().getTime();
	var t_time='?t='+CurrentTime; 
	top.location = "../Status/Internet_Sessions.asp"+t_time;
}
function do_detail(src_ip)
{
	var d_len=dataList.length;
	get_by_id("session_refresh").style.display="none";
	get_by_id("session_back").style.display="block";
	get_by_id("generateHtml").style.display="none";
	get_by_id("session_detail").style.display="block";
	get_by_id("refreshing").style.display="none";
	generateHTML_detail_filter(src_ip);
}

function generateHTML_detail_filter(src_ip)
{
	var d_len=dataList.length;
	for(i=0;i<d_len;i++){
		if(document.getElementById("detail_session_table").rows[i+1].cells[1].innerHTML == src_ip){
			get_by_id("session_"+i).style.display="block";
		}else{
			get_by_id("session_"+i).style.display="none";
		}
	}
	

	
}

function generateHTML_detail()
{
	var d_len=dataList.length;
	var str;
	str+="<tr>";
	str+="<td width=50>"+sw("txtProtocol")+"</td>";
	str+="<td width=100>"+sw("txtSourceIP")+"</td>";
	str+="<td width=100>"+sw("txtSourcePort")+"</td>";
	str+="<td width=100>"+sw("txtDestIP")+"</td>";
	str+="<td width=100>"+sw("txtDestPort")+"</td>";
	str+="</tr>";
	var protocol_session;
	
	
	for(i=0;i<d_len;i++){
	str+="<tr id=session_"+i+" style=\"display:block\">";
	if(dataList[i][0]=="1")
		protocol_session="TCP";
	else
		protocol_session="UDP";
	str+="<td>"+protocol_session+"</td><td>"+dataList[i][1]+"</td>";
	str+="<td>"+dataList[i][2]+"</td><td>"+dataList[i][3]+"</td><td>"+dataList[i][4]+"</td>";
	str+="</tr>";
	}
	document.writeln(str);
}


function page_load() 
{
	if (local_debug) {
		hide_all_ssi_tr();
	}
	get_by_id("session_refresh").style.display="block";
	get_by_id("session_back").style.display="none";
	get_by_id("refreshing").style.display="none";

}
function buttoninit()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtStatus")+'/'+sw("txtInternetSessions2");
document.title = DOC_Title;	
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("refresh").value = sw("txtRefresh");
get_by_id("bt_back").value = sw("txtBack");

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
</SCRIPT><table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
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
</td><td id="maincontent_container">
<SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none"><div class="section" >
<div class="section_head"><h2><SCRIPT>ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div><!-- box warnings_section_content --></div></div></div> <!-- warnings_section -->
<div id="maincontent" style="display: block">
<form id="mainform" name="mainform" action="" method="post" enctype="application/x-www-form-urlencoded">
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtInternetSessions2");</SCRIPT></h2>
<p><SCRIPT >ddw("txtAllinternetSsessionsdisplayed");</SCRIPT></p>
<br><span id="session_refresh" style="display:none"><input type=button name=refresh id="refresh" value="" onClick="do_refresh()"></span>
<span id="session_back" style="display:none"><input type=button name=bt_back id="bt_back" value="" onClick="do_refresh()"></span>
</div>
<div class="box" id="internet_sessions" style="display:none">
<h3><SCRIPT >ddw("txtInternetSessions");</SCRIPT></h3>
</div>
<div class="box" id="refreshing" style='display:block'>
<h3><SCRIPT >ddw("txtNAPTSession");</SCRIPT></h3><br>
<div style='display:none'>
<font color="blue">Refreshing ...</font>
</div>
<br>
</div>
<div class="box" id="session_detail" style='display:none'>
<h2><SCRIPT >ddw("txtNAPTDetail");</SCRIPT></h2><br>
<table id="detail_session_table" borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>
<script language="JavaScript">generateHTML_detail();</script>
</table>
<br>
</div>
<span id="generateHtml" style="display:block">
<!--20090513-patch-start-->	
<!--	<script language="JavaScript">generateHTML();</script></span>-->
<%get_InternetSessions("");%>
<!--20090513-patch-end-->	
</div>
</form></div></td>
<td id="sidehelp_container">	<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtAllActiveConversationdisplayed");</SCRIPT></p>
<p class="more"><!-- Link to more help --><a href="../Help/Status.asp#Internet_Sessions" onclick="return jump_if();"><SCRIPT >ddw("txtMore");</SCRIPT>...</a></p>
<!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT></div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
