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
	return ("" !== "") ? "/Basic/Setup.asp" : "/Status/Logs.asp";
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

function doClear()
{
if (!confirm(sw("txtClearAllLog"))) {
	return;
}
mf["settingsChanged"].value = 1;
mf["action"].value="clear";
mf.submit();
}

//["Jan  1 01:40:55  ","PPPoE: Sending PADI for session1."],

dataLists=[
<%dumplog()%>

["",""]
];

var d_len=dataLists.length-1;
var row_num=parseInt("10", [10]);
var max=(d_len%row_num==0? d_len/row_num : parseInt(d_len/row_num, [10])+1);

function showSysLog()
{
	var str=new String("");
	var f=document.getElementById("mainform");
	var p=parseInt(f.curpage.value, [10]);

	if (max==0 || max==1)
	{
		f.Pp1.disabled=true;
		f.Np1.disabled=true;
	}
	else
	{
		if (p==1)
		{
			f.Pp1.disabled=true;
			f.Np1.disabled=false;
		}
		if (p==max)
		{
			f.Pp1.disabled=false;
			f.Np1.disabled=true;
		}
		if (p > 1 && p < max)
		{
			f.Pp1.disabled=false;
			f.Np1.disabled=false;
		}
	}

	if (document.layers) return true;
	{
		if(max == 0)
			p = 0;
		str+="<p>"+sw("txtPage")+" "+p+" "+sw("txtOf")+" "+max+"</p>";
		str+="<table borderColor=#ffffff cellSpacing=1 cellPadding=2 width=525 bgColor=#dfdfdf border=1>";
		str+="<tr>";
		str+="<td align=middle>"+sw("txtTime2")+"</td>";
		str+="<td align=middle>"+sw("txtMessage")+"</td>";
		str+="</tr>";

		if(max > 0)
		{
			for (var i=((p-1)*row_num);i < p*row_num;i++)
			{
				if (i>=dataLists.length) break;
				str+="<tr border=1 borderColor='#ffffff' bgcolor='#dfdfdf'>";
				str+="<td>"+dataLists[i][0]+"</td>";
				str+="<td>"+dataLists[i][1]+"</td>";
				str+="</tr>";
			}
		}
		str+="</table>";
	}

	if (document.all)           document.all("sLog").innerHTML=str;
	else if (document.getElementById)   document.getElementById("sLog").innerHTML=str;
}

function ToPage(p)
{
	if (document.layers)
	{
		alert("");
	}
	if (dataLists.length==0) return;
	var f=document.getElementById("mainform");

	switch (p)
	{
		case "0":
			f.curpage.value=max;
		break;
		case "1":
			f.curpage.value=1;
		break;
		case "-1":
			f.curpage.value=(parseInt(f.curpage.value, [10])-1 <=0? 1:parseInt(f.curpage.value, [10])-1);
		break;
		case "+1":
			f.curpage.value=(parseInt(f.curpage.value, [10])+1 >=max? max:parseInt(f.curpage.value, [10])+1);
		break;
	}
	showSysLog();
}
/** Clear the log.*/
function clear_log()
{
if (!confirm(sw("txtClearAllLog"))) {
	return;
}
mf["settingsChanged"].value = 1;
mf["action"].value="clear";
mf.submit();
}
function init()
{
	showSysLog();
}

function page_load() {

mf = document.forms["mainform"];

var is_router_mode = OP_MODE == "0";
set_form_default_values("mainform");
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
mf["settingsChanged"].value = 1;
}
mf.submit();
}

function buttoninit()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtStatus")+'/'+sw("txtViewLogs");
document.title = DOC_Title;
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("Clear").value = sw("txtClear");
get_by_id("linkLog").value = sw("txtLinkLog");
get_by_id("Pp1").value = sw("txtPrevious");
get_by_id("Lp1").value = sw("txtLastPage");
get_by_id("Fp1").value = sw("txtFirstPage");
get_by_id("Np1").value = sw("txtNextPage");

}
function link_log_setting()
{
	self.location.href='../Tools/EMail.asp?t='+new Date().getTime();
}
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load();buttoninit();init();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside"><table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tr><td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
DrawTopnavContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
<tr>	<td id="sidenav_container">
<div id="sidenav">
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
</td><td id="maincontent_container"><SCRIPT >DrawRebootContent();</SCRIPT>
<div id="warnings_section" style="display:none"><div class="section" >
<div class="section_head"><h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div>
</div></div></div> 
<div id="maincontent" style="display: block">
<form id="saveform" name="saveform" method='get' action=''>
</form>
<form id="mainform" name="mainform" action="/goform/formSetLog" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="action" name="action" value="0"/>
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>	
<input type=hidden id="curpage" name="curpage" value="1">
<div class="section"><div class="section_head">
<h2><SCRIPT >ddw("txtViewLogs");</SCRIPT></h2>
<p><SCRIPT >ddw("txtOptionViewLog");</SCRIPT></p>
</div></div>
<div class="box">
<h2><SCRIPT >ddw("txtLogFile");</SCRIPT></h2>
<table cellpadding="1" cellspacing="1" border="0" width="525">
<tr>
<td align="right">
<div align="left">
<input type=button value="" id="Fp1" name="Fp1" onclick=ToPage("1")>
<input type=button value="" id="Lp1" name="Lp1" onclick=ToPage("0")>
<input type=button value="" id="Pp1" name="Pp1" onclick=ToPage("-1")>
<input type=button value="" id="Np1" name="Np1" onclick=ToPage("+1")>
<input type=button value="" id=Clear name=Clear onclick=doClear()>
<input type=button value="" id="linkLog" name="linkLog" onclick="link_log_setting();">
</div></td></tr><tr><td class=l_tb><div id=sLog></div></td></tr>
</table>
</div>
<!--	</div>--></form><!-- InstanceEndEditable --></div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtCheckLog");</SCRIPT></p>
<p><SCRIPT >ddw("txtLogMailed");</SCRIPT></p>
<p class="more"><a href="../Help/Status.asp#Logs" onclick="return jump_if();"><SCRIPT >ddw("txtMore");</SCRIPT>...</a></p>
<!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
