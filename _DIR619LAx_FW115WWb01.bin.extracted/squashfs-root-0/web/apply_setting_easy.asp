<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />
<meta http-equiv="pragma" content="no-cache" />
<link rel="stylesheet" rev="stylesheet" href="style.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="/<% getInfo("substyle");%>" type="text/css" />
<script language="JavaScript" type="text/javascript">
<!--
str=location.search;
str=str.substring(1,str.length);

var lang = "<% getLangInfo("lang");%>";
if(str != "" && str*1>=0 && str*1<=100)
{
	lang=str;
}
//-->
</script>
<script type="text/javascript" src="ubicom.js"></script>
<script type="text/javascript" src="xml_data.js"></script>
<script type="text/javascript" src="navigation.js"></script>
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="utility.js"></script>
<script type="text/javascript">
//<![CDATA[

var no_reboot_alt_location = "";

var get_update_page_returned = 0;
var times = 0;

function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function template_load()
{
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
var timeleft = "40";
var marqueetime = "0";
var xkjs = "0";
var url = location.search;
if(url.indexOf("?") != -1)
{
 timeleft = url.substr(1);
 if(timeleft > "40")
 {
	xkjs = "1";
 }
}

function countdown()
{
displayoffline();
document.getElementById("timeleft").innerHTML = timeleft;
if (timeleft === 0) {
top.location = '<%getInfo("last_url");%>?t='+new Date().getTime();
return;
}
timeleft--;
if(xkjs == "1")
{
	if(timeleft < 30 && times < 2)
	{
		ping_test();
		times++;
	}
	if(timeleft < 20 && times < 4)
	{
		ping_test();
		times++;
	}
	if(timeleft < 10 && times < 6)
	{
		ping_test();
		times++;
	}
}
else
{
	if(timeleft < 10 && times < 3)
	{
		ping_test();
		times++;
	}
}
setTimeout(countdown, 1000);
}

function displayoffline()
{
	marqueetime++;
	if(marqueetime == 7)
	{
		marqueetime = 1;
	}
	if(marqueetime == 6)
	{
		get_by_id("offline5").style.display = "";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}
	else if(marqueetime == 5)
	{
		get_by_id("offline4").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none"
	}
	else if(marqueetime == 4)
	{
		get_by_id("offline3").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
        }
	else if(marqueetime == 3)
	{
		get_by_id("offline2").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}
	else if(marqueetime == 2)
	{
		get_by_id("offline1").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}
	else
	{
		get_by_id("offline0").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
	}
}

function ping_test()
{
        send_wan_link_request("/Basic/ajax_ping_test.asp?r="+generate_random_str());
}
function send_wan_link_request(url)
{
	if(get_update_page_returned > 0) return 0; 
	if (__AjaxReq == null) __AjaxReq = __createRequest();
	__AjaxReq.open("GET", url, true);
	__AjaxReq.onreadystatechange = get_update_page_ok;
	__AjaxReq.send(null);
	get_update_page_returned++;
	return 1;
}
function get_update_page_ok()
{
	if (__AjaxReq != null && __AjaxReq.readyState == 4)
	{
		if (__AjaxReq.status == 200)
		{
			get_update_page_returned--;
			if (__AjaxReq.responseText.length <= 1) /* No data */
			{
				return;
			}
		}
		else
		{
			return;
		}
	}    
}

function page_load() 
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtRebooting");
document.title = DOC_Title;
countdown();
}
//]]>
</script>
</head>
<body onload="template_load();web_timeout();">
<div id="loader_container" onclick="return false;">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody>
<tr>
<td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>
<td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">
<div id="maincontent_1col" style="display: none">
	<div id="box_header">
		<h1><SCRIPT >ddw("txtRebooting");</SCRIPT>...</h1>
		<p class="centered">
		<SCRIPT >ddw("txtPleaseWait");</SCRIPT>
		<span id="timeleft"></span>&nbsp; 
		<SCRIPT >ddw("txtSeconds");</SCRIPT>
		</p>
		<p><SCRIPT >ddw("txtRebootWarning");</SCRIPT></p>
	</div>
</div>

<div id="maincontent_1col" style="display: block">
<div id="box_header">
<div id="wz_page_1" style="display:block">
<h1><SCRIPT >ddw("txtWizardEasyStepRenewConfig");</SCRIPT></h3>
<div id="offline"><p class="box_msg" align="center"><SCRIPT >ddw("txtWizardEasyStep4Str1");</SCRIPT></p></div>
<div id="offline0" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>.</p></div>
<div id="offline1" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>..</p></div>
<div id="offline2" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>...</p></div>
<div id="offline3" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>... .</p></div>
<div id="offline4" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>... ..</p></div>
<div id="offline5" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>... ...</p></div>
</div>
</div><!-- wz_page_1 -->
</div> <!-- wizard_box -->
</div>

</td>
<td id="sidehelp_container">&nbsp;</td>
</tr>
</table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr>
<td>
<img src="Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td>
<td>&nbsp;</td>
</tr>
</table>
</td>
</tr>
</tbody>
</table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
</html>
