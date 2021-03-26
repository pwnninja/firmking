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
.ifile {position:absolute;opacity:0;filter:alpha(opacity=0);}
</style>
<!-- InstanceEndEditable -->
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
		return ("" !== "") ? "/Basic/Setup.asp" : "/Tools/Firmware.asp";
}
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
SubnavigationLinks(WLAN_ENABLED, OP_MODE);
topnav_init(document.getElementById("topnav_container"));
page_load();
RenderWarnings();
}				  
//]]>
</script>
<script type="text/javascript">
//<![CDATA[
var mf;
var global_fw_minor_version = "<%getInfo("fwVersion")%>";
var query_return_count = 0;
var timeout_count = 0;
var is_latest_version = 0;

//davis
/////////////////////////  for firmware upload ////////////////
function selectfile()
{
    var evt = document.createEvent("MouseEvents");
    evt.initEvent("click",false,true);
    document.forms["uploadform"].upfile.dispatchEvent(evt);
}
function seturl()
{
    document.forms["uploadform"].url.value = document.forms["uploadform"].upfile.value;
}
function initinput()
{
    var br = navigator.userAgent.toLowerCase();
    chrome = "";
    nonechrome = "";
    chrome = '<div id="chrome"> \
                                <div style="z-index:2"> \
                                        <input style="visibility:hidden" type="file" value="" id="upfile" name="upfile" onChange="seturl()" />  \
                                </div>  \
                                <div style="position:relative;top:-10px;left:0;z-index:1">      \
                                        <input type="text" vlaue="" id="url" size="30" onClick="selectfile()" />        \
                                        <input type="button" value="Browse" id="select" onClick="selectfile()" />       \
                                </div>  \
                        </div>';
    nonechrome = '<input type="file" value="upfile" id="upfile" name="upfile" size="30" style="padding: 4px 4px;font-size: 12px;"/>';
    if( br.search("chrome") >= 0)
    {
        document.write(chrome);
    }
    else
    {
        document.write(nonechrome);
    }
}

///////////////////////////  for language upload  //////////////////////////////

function lang_selectfile()
{
    var evt = document.createEvent("MouseEvents");
    evt.initEvent("click",false,true);
    document.forms["lang_uploadform"].upfile.dispatchEvent(evt);
}
function lang_seturl()
{
    document.forms["lang_uploadform"].url.value = document.forms["lang_uploadform"].upfile.value;
}
function lang_initinput()
{
    var br = navigator.userAgent.toLowerCase();
    chrome = "";
    nonechrome = "";
    chrome = '<div id="chrome"> \
                                <div style="z-index:2"> \
                                        <input style="visibility:hidden" type="file" value="" id="upfile" name="upfile" onChange="lang_seturl()" />     \
                                </div>  \
                                <div style="position:relative;top:-10px;left:0;z-index:1">      \
                                        <input type="text" vlaue="" id="url" size="30" onClick="lang_selectfile()" />   \
                                        <input type="button" value="Browse" id="select_1" onClick="lang_selectfile()" />  \
                                </div>  \
                        </div>';
    nonechrome = '<input type="file" value="upfile" id="upfile" name="upfile" size="30" style="padding: 4px 4px;font-size: 12px;"/>';
    if( br.search("chrome") >= 0)
    {
        document.write(chrome);
    }
    else
    {
        document.write(nonechrome);
    }
}

//davis

//////////////////////////// tsrites 
function mydlink_selectfile()
{
    var evt = document.createEvent("MouseEvents");
    evt.initEvent("click",false,true);
    document.forms["mydlink_uploadform"].upfile.dispatchEvent(evt);
}
function mydlink_seturl()
{
    document.forms["mydlink_uploadform"].url.value = document.forms["mydlink_uploadform"].upfile.value;
}
function mydlink_initinput()
{
    var br = navigator.userAgent.toLowerCase();
    chrome = "";
    nonechrome = "";
    chrome = '<div id="chrome"> \
                                <div style="z-index:2"> \
                                        <input style="visibility:hidden" type="file" value="" id="upfile" name="upfile" onChange="mydlink_seturl()" />     \
                                </div>  \
                                <div style="position:relative;top:-10px;left:0;z-index:2">      \
                                        <input type="text" vlaue="" id="url" size="30" onClick="mydlink_selectfile()" />   \
                                        <input type="button" value="Browse" id="select" onClick="mydlink_selectfile()" />  \
                                </div>  \
                        </div>';
    nonechrome = '<input type="file" value="upfile" id="upfile" name="upfile" size="30" style="padding: 4px 4px;font-size: 12px;"/>';
    if( br.search("chrome") >= 0)
    {
        document.write(chrome);
    }
    else
    {
        document.write(nonechrome);
    }
}

function doUpload_mydlink()
{
	if (document.forms["mydlink_uploadform"].upfile.value === "") {
			alert(sw("txtEnterFirmwareName"));
			return;
	}
	if (!confirm(sw("txtFirmwareStr1"))) {
			return;
	}
	if (!confirm(sw("txtFirmwareStr2")+" \"" +
			document.forms["mydlink_uploadform"].upfile.value + "\"?")) {
		return;
	}
	try {
			document.getElementById("mydlink_msg_upload").style.display = "block";
			document.forms["mydlink_uploadform"].mydlink_upgrade_button.disabled = true;
			document.forms["mydlink_uploadform"].submit();
		} catch (e) {
			alert("%[.error:Error]%: " + e.message);
			document.getElementById("mydlink_msg_upload").style.display = "none";
			document.forms["mydlink_uploadform"].mydlink_upgrade_button.disabled = false;
		}
}	






function doUpload()
{
	if (document.forms["uploadform"].upfile.value === "") {
			alert(sw("txtEnterFirmwareName"));
			return false;
	}
	if (!confirm(sw("txtFirmwareStr1"))) {
			return false;
	}
	if (!confirm(sw("txtFirmwareStr2")+" \"" +
			document.forms["uploadform"].upfile.value + "\"?")) {
		return false;
	}
	try {
			document.getElementById("msg_upload").style.display = "block";
			document.forms["uploadform"].upgrade_button.disabled = true;
			document.forms["uploadform"].submit();
		} catch (e) {
			//alert("%[.error:Error]%: " + e.message);
			document.getElementById("msg_upload").style.display = "none";
			document.forms["uploadform"].upgrade_button.disabled = false;
			return false;
		}	
}
function doUpload_lang()
{
	if (document.forms["lang_uploadform"].upfile.value === "") {
			alert(sw("txtEnterFirmwareName"));
			return false;
	}
	if (!confirm(sw("txtFirmwareStr1"))) {
			return false;
	}
	if (!confirm(sw("txtFirmwareStr2")+" \"" +
			document.forms["lang_uploadform"].upfile.value + "\"?")) {
			return false;
	}
	try {
			document.getElementById("lang_msg_upload").style.display = "block";
			document.forms["lang_uploadform"].lang_upgrade_button.disabled = true;
			document.forms["lang_uploadform"].submit();
		} catch (e) {
			//alert("%[.error:Error]%: " + e.message);
			document.getElementById("lang_msg_upload").style.display = "none";
			document.forms["lang_uploadform"].lang_upgrade_button.disabled = false;
			return false;
		}	
}


function page_submit()
{
	if (!is_form_modified("mainform") && 
		!confirm(sw("txtSaveAnyway"))) {
		return false;
	}
	mf.submit();
}
var FW_INFO = [
{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},
{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},
{ site: "", // end ...
  URL: ""
}
];
var PACK_INFO = [
	[{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},
	{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},
	{ site: "",	URL: ""}],
	[{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},
	{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},{ site: "",  URL: ""},
	{ site: "",	URL: ""}]
];
var FW_INFO_Count = "";
var PACK_INFO_Count= new Array();		
var fw_major = "";
var fw_minor = "";
var fw_date  = "";
var fw_update_avail = "false";
var display_result=0;
var LANG_PACKS = new Array("SC","TW");
function xml_done(xml)
{
	query_return_count++;
	// enable checknow buton
	var major = xml.getElementData("major");
	if( major == null) {
		display_check();
		return;
	}
	if( major == "0" ) {
		// no information
		display_check();
		return;
	}
	var minor = xml.getElementData("minor");			
	if( minor == null) {
		display_check();
		return;
	}			
	var fw_date = xml.getElementData("date");			
	if( fw_date == null) {
		display_check();
		return;
	}
	var site_count = xml.getElementData("site_count");			
	if( site_count == null) {
		display_check();
		return;
	}
	var count;
	var i;
	count = site_count * 1;
	for(i=0;i<count;i++) {
		// update site information
		var site_name = xml.getElementData("site_name"+i);	
		if( site_name == null) {
			display_check();
			return;
		}
		var site_firmware = xml.getElementData("site_firmware"+i);	
		if( site_firmware == null) {
			display_check();
			return;
		}
		site_name = site_name.replace(/Area/g,"");
		site_name = site_name.replace(/_/g," ");
		FW_INFO[i].site = site_name;
		FW_INFO[i].URL = site_firmware;
		}
		// maybe need check latest
		var fw_major_version = "<%getInfo("fwVersion_major")%>";
		var fw_minor_version = "<%getInfo("fwVersion_minor")%>";
		var current_version = fw_major_version * 100 + fw_minor_version * 1 ;
		var latest_version = major * 100 + minor * 1;			
		if( latest_version <= current_version) {
			// no lastest firmware
			is_latest_version++;
			display_check();
			document.getElementById("firmware_check").style.display="none";
			return;
		}
		// update date, not consider date format
		document.getElementById("fw_date").innerHTML = fw_date;
			
		// update date and firmware information
		//<span id="fw_major"></span>
		document.getElementById("fw_major").innerHTML = major;
		//1.<span id="fw_minor_latest"></span>
		document.getElementById("fw_minor_latest").innerHTML = minor;
			// show it
		FW_INFO_Count = count;			
		update_CheckNow();
}

function xml_timeout()
{
    timeout_count++;
	display_check();
	return;
}
function xml_tryagain() 
{
	setTimeout(xml_load, 10000);
}
function xml_load()
{
	var myxml = new xmlDataObject(xml_done, xml_timeout, 13000, "dfw_query_result.asp");
	myxml.retrieveData();
}


var pack_return_count = -1;
function xml_done_pack(xml)
{
	
	query_return_count++;
	pack_return_count++;
	var major = xml.getElementData("major");
	
	if( major == null) {
		display_check();
		return;
	}
	if( major == "0" ) {
		display_check();
		return;
	}
	var minor = xml.getElementData("minor");			
	if( minor == null) {
		display_check();
		return;
	}			
	var fw_date = xml.getElementData("date");			
	if( fw_date == null) {
		display_check();
		return;
	}
	var site_count = xml.getElementData("site_count");			
	if( site_count == null) {
		display_check();
		return;
	}
	var count;
	var i;
	count = site_count * 1;
	for(i=0;i<count;i++) {
		// update site information
		var site_name = xml.getElementData("site_name"+i);	
		if( site_name == null) {
			display_check();
			return;
		}
		var site_firmware = xml.getElementData("site_firmware"+i);	
		if( site_firmware == null) {
			display_check();
			return;
		}
		site_name = site_name.replace(/Area/g,"");
		site_name = site_name.replace(/_/g," ");
		PACK_INFO[pack_return_count][i].site = site_name;
		PACK_INFO[pack_return_count][i].URL = site_firmware;
		}
		// maybe need check latest
		var pack_major_version = "<%getInfo("fwVersion_major")%>";
		var pack_minor_version = "<%getInfo("fwVersion_minor")%>";
		var current_version = pack_major_version * 100 + pack_minor_version * 1 ;
		var latest_version = major * 100 + minor * 1;			
		if( latest_version <= current_version) {
			is_latest_version++;
			display_check();
			return;
		}
		document.getElementById("language_pack_check" + pack_return_count).style.display="block";
		// update date, not consider date format
		document.getElementById("pack_date" + pack_return_count).innerHTML = fw_date;
		document.getElementById("pack_major" + pack_return_count).innerHTML = major;
		document.getElementById("pack_minor_latest" + pack_return_count).innerHTML = minor;
		PACK_INFO_Count[pack_return_count] = count;			
		update_CheckNow_PACK();
		display_check();
}
function display_check()
{
	if(query_return_count + timeout_count == LANG_PACKS.length + 1){
        document.getElementById("check_on_line").disabled = false;
		if(query_return_count == 0){
			document.getElementById("fw_message").innerHTML = sw("txtSessionTimeOut");
		}else if(display_result){
            document.getElementById("fw_message").style.display = "none";
        }else if(is_latest_version){
            document.getElementById("fw_message").innerHTML = sw("txtLatestFwVersion");
        }else{
			document.getElementById("fw_message").innerHTML = sw("txtUnkownError");
		}
    }

}
function xml_timeout_pack()
{
	timeout_count++;
	display_check();
	return;
}
function xml_tryagain_pack() 
{
	setTimeout(xml_load_pack, 10000);
}
function xml_load_pack()
{
	var i;
	var sleep_time = 0;
	for(i = 0; i < LANG_PACKS.length; i++)
	{
		if(LANG_PACKS[i] == "SC")	
		{
			setTimeout(xml_send_sc,sleep_time);
			get_by_id("pack_type" + i).innerHTML="CN";
		}else if(LANG_PACKS[i] == "TW")
		{
			setTimeout(xml_send_tw,sleep_time);
			get_by_id("pack_type" + i).innerHTML="TW";
		}
		sleep_time += 2000;
	}
}
function xml_send_sc()
{
	var myxml_sc = new xmlDataObject(xml_done_pack, xml_timeout_pack, 13000, "dpack_query_result.asp");
	myxml_sc.retrieveData();
}
function xml_send_tw()
{
	var myxml_tw = new xmlDataObject(xml_done_pack, xml_timeout_pack, 13000, "dpack_query_result_tw.asp");
	myxml_tw.retrieveData();
}

function Check_OnLine()
{
	document.getElementById("fw_message").innerHTML =sw("txtConnectFwVersion");
document.getElementById("fw_message").style.display = "block";
// disable checknow buton			
document.getElementById("check_on_line").disabled = true;
// not display last firmware 
document.getElementById("check_lastest_firmware").style.display = "none";
pack_return_count = -1;
query_return_count = 0;
timeout_count = 0;
display_result=0;
is_latest_version=0;
xml_load();
document.getElementById("language_pack_check0").style.display="none";
document.getElementById("language_pack_check1").style.display="none";
setTimeout(xml_load_pack,2000);
return;
document.getElementById("check_on_line").disabled = true;
}
function update_CheckNow()
{
// update 
var count;
var i;
count = FW_INFO_Count;			
count = count * 1;
document.getElementById("download_site_select").options.length = 0;
for(i=0;i<count;i++) {
		document.getElementById("download_site_select").options.add( new Option(FW_INFO[i].site,i) );				
display_result++;
}
// display last firmware 
document.getElementById("check_lastest_firmware").style.display = "block";
}

function doDownload()
{
window.open(FW_INFO[document.getElementById("download_site_select").value].URL);
}
function update_CheckNow_PACK()
{
// update 
var count;
var i;
count = PACK_INFO_Count[pack_return_count];			
count = count * 1;
document.getElementById("pack_download_site_select" + pack_return_count).options.length = 0;
for(i=0;i<count;i++) {
		document.getElementById("pack_download_site_select" + pack_return_count).options.add( new Option(PACK_INFO[pack_return_count][i].site,i) );
display_result++;
}
// display last firmware 
document.getElementById("check_lastest_firmware").style.display = "block";
}
	
function doDownload_PACK(num)
{
window.open(PACK_INFO[num][document.getElementById("pack_download_site_select" + num).value].URL);
}


function page_load() 
{

document.getElementById("fw_minor_current").innerHTML = global_fw_minor_version;
set_form_default_values("mainform");
var verify_failed = "<%getInfo("err_msg")%>";
if (verify_failed != "") {
		alert(verify_failed);
		verify_failed = "";
}		
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtTools")+'/'+sw("txtFirmware");
var br = navigator.userAgent.toLowerCase();
document.title = DOC_Title;	

get_by_id("upgrade_button").value = sw("txtUpload");	
get_by_id("check_on_line").value = sw("txtCheckNow");
get_by_id("download_button").value = sw("txtDownload");
get_by_id("pack_download_button0").value = sw("txtDownload");
get_by_id("pack_download_button1").value = sw("txtDownload");
get_by_id("lang_upgrade_button").value = sw("txtUpload");
get_by_id("select_1").value = sw("txtBrowser");
get_by_id("select").value = sw("txtBrowser");
document.forms["uploadform"].upgrade_button.disabled = false;
document.forms["lang_uploadform"].lang_upgrade_button.disabled = false;
get_by_id("select_2").value = sw("txtBrowser");
get_by_id("mydlink_upgrade_button").value = sw("txtUpload");

if(LangCode == "TW")
{
	document.getElementById("upgrade_url").href = "http://www.dlink.com.tw";
}else if(LangCode == "SC")
	document.getElementById("upgrade_url").href = "http://www.dlink.com.cn";
}	
//]]>
</script>
<!-- InstanceEndEditable -->
</head>
<body onload="template_load();init();web_timeout();">
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
</SCRIPT></div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
</td>
<td id="maincontent_container">

<div id="warnings_section" style="display:none">
<div class="section" >
<div class="section_head">
<h2><SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT></h2>
<div style="display:block" id="warnings_section_content">
</div></div></div>	</div> 
<div id="maincontent" style="display: block">
<div class="section"><div class="section_head"> 
<h2><SCRIPT >ddw("txtFirmware");</SCRIPT></h2>
<p><SCRIPT >ddw("txtFirmwareStr3");</SCRIPT>												
<%getInfo("productModel")%>&nbsp;<SCRIPT >ddw("txtFirmwareStr4");</SCRIPT>
<br><a id="upgrade_url" href=http://www.dlink.com target=_blank><SCRIPT >ddw("txtClickForAnUpgrade");</SCRIPT></a><br>
</p><br><p><SCRIPT >ddw("txtFirmwareStr5");</SCRIPT></p><br>
<p><SCRIPT >ddw("txtFirmwareStr5_2");</SCRIPT></p><br>
<p><SCRIPT >ddw("txtFirmwareStr5_3");</SCRIPT></p><br>
<!--<input class="button_submit" type="button" id="SaveSettings"  name="SaveSettings" value="" onclick="page_submit()"/>
<input class="button_submit" type="button" id="DontSaveSettings" name="DontSaveSettings" value="" onclick="page_cancel()"/>
-->
</div><!-- section_head -->
<div class="box">
<h3><SCRIPT >ddw("txtFirmwareInformation");</SCRIPT></h3>
<fieldset><p><label class="duple"><b><SCRIPT >ddw("txtCurrentFirmwareVersion");</SCRIPT></b>
&nbsp;:</label><span id="fw_minor_current"></span>
</p><p><label class="duple"><b><SCRIPT >ddw("txtCurrentFirmwareDate");</SCRIPT></b>
&nbsp;:</label>
<%getInfo("fwBuiltDate")%>
</p><p></p>
<p><center><strong><SCRIPT >ddw("txtCheckFw");</SCRIPT>&nbsp;:</strong>
<input type="button" class="button_submit" id="check_on_line" value="" onclick="Check_OnLine()"/></center></p>
<p><center><strong class="output"><div id="fw_message"></div></strong></center></p>
</fieldset></div>
<div id="check_lastest_firmware" class="box" style="display:none">
<h3><SCRIPT >ddw("txtCheckFwLatest");</SCRIPT></h3>
<fieldset id="firmware_check">
<p><label class="duple"><SCRIPT >ddw("txtFwLatest");</SCRIPT>&nbsp;:</label>
<strong class="output">
<span id="fw_major"></span>.<span id="fw_minor_latest"></span>
</strong>
</p>
<p>
<label class="duple"><SCRIPT >ddw("txtFwLatestDate");</SCRIPT>&nbsp;:</label>
<strong class="output"><span id="fw_date"></span></strong>
</p>
<p>
<label class="duple"><SCRIPT >ddw("txtAvailableDownloadSite");</SCRIPT>&nbsp;:</label>
<select id="download_site_select" >
</select>	
</p>		
<p class="centered">
<input type="button" class="button_submit" id="download_button"
value="" 
onclick="doDownload()"/></p>
</fieldset>


<fieldset id="language_pack_check0">
<p><label class="duple"><SCRIPT >ddw("txtLangPackLatest");</SCRIPT>&nbsp;:</label>
<strong class="output">
<span id="pack_major0"></span>.<span id="pack_minor_latest0"></span><span id=pack_type0></span>
</strong>
</p>
<p>
<label class="duple"><SCRIPT >ddw("txtLangPackLatestDate");</SCRIPT>&nbsp;:</label>
<strong class="output"><span id="pack_date0"></span></strong>
</p>
<p>
<label class="duple"><SCRIPT >ddw("txtLangPackAvailableDownloadSite");</SCRIPT>&nbsp;:</label>
<select id="pack_download_site_select0" >
</select>	
</p>		
<p class="centered">
<input type="button" class="button_submit" id="pack_download_button0"
value="" 
onclick="doDownload_PACK(0)"/></p>
</fieldset>

<fieldset id="language_pack_check1">
<p><label class="duple"><SCRIPT >ddw("txtLangPackLatest");</SCRIPT>&nbsp;:</label>
<strong class="output">
<span id="pack_major1"></span>.<span id="pack_minor_latest1"></span><span id=pack_type1></span>
</strong>
</p>
<p>
<label class="duple"><SCRIPT >ddw("txtLangPackLatestDate");</SCRIPT>&nbsp;:</label>
<strong class="output"><span id="pack_date1"></span></strong>
</p>
<p>
<label class="duple"><SCRIPT >ddw("txtLangPackAvailableDownloadSite");</SCRIPT>&nbsp;:</label>
<select id="pack_download_site_select1" >
</select>
</p>
<p class="centered">
<input type="button" class="button_submit" id="pack_download_button1"
value=""
onclick="doDownload_PACK(1)"/></p>
</fieldset>


</div>

<div class="box">
<h3><SCRIPT >ddw("txtFirmwareUpgrade");</SCRIPT></h3>
<p class=""><font color="red"><strong><SCRIPT >ddw("txtNote");</SCRIPT>
:&nbsp;<SCRIPT >ddw("txtFirmwareStr7");</SCRIPT></p></strong></font>
<p class=""><font color="blue"><strong><SCRIPT >ddw("txtFirmwareStr8");</SCRIPT></p></strong></font>
<form id="uploadform" name="uploadform" method="post" onSubmit="return doUpload()" enctype="multipart/form-data" action="/goform/formFirmwareUpgrade">
<table>
			<tr>
				<td class=bc_tb><b><SCRIPT>ddw("txtUpload");</SCRIPT>:&nbsp;</b></td>
<!--                            <td><input type="file" id="upfile" name="upfile" size="30"/></td>  -->
                                <!--<td><script>initinput();</script></td> -->
                                <td>
									<input type="file" id="upfile" name="upfile" onchange="seturl()" size="30" class="ifile">
									<input type="text" vlaue="" id="url" size="30" onclick="selectfile();" readonly>
									<input type="button" value="" id="select" onclick="selectfile();">
								</td>
			</tr>
			<tr>
				<td class=bc_tb></td>
				<td><input type="button" class="button_submit" id="upgrade_button" value="" onclick="doUpload()"/></td>
			</tr>
			<tr>
				<td class=bc_tb></td>
				<td><p class="msg_inprogress" id="msg_upload" style="display:none"><SCRIPT >ddw("txtUploadTake1Minute");</SCRIPT></p></td>
			</tr>
			
</table></form></div>

<div class="box">
<h3><SCRIPT >ddw("txtLangPackUpgrade");</SCRIPT></h3>
<form id="lang_uploadform" name="lang_uploadform" method="post" onSubmit="return doUpload_lang();" enctype="multipart/form-data" action="/goform/formLanguageUpgrade">
<table>
			<tr>
				<td class=bc_tb><b><SCRIPT >ddw("txtUpload");</SCRIPT>:&nbsp;</b></td>
<!--                            <td><input type="file" id="upfile" name="upfile" size="30"/></td> -->
                                <!--<td><script>lang_initinput();</script></td>-->
				<td>
					<input type="file" id="upfile" name="upfile" onchange="lang_seturl()" size="30" class="ifile">
					<input type="text" vlaue="" id="url" size="30" onclick="lang_selectfile();" readonly>
					<input type="button" value="" id="select_1" onclick="lang_selectfile();">
				</td>
			</tr>
			<tr>
				<td class=bc_tb></td>
				<td><input type="button" class="button_submit" id="lang_upgrade_button" value="" onclick="doUpload_lang()"/></td>
			</tr>
			<tr>
				<td class=bc_tb></td>
				<td><p class="msg_inprogress" id="lang_msg_upload" style="display:none"><SCRIPT >ddw("txtUploadTake1Minute");</SCRIPT></td>
			</tr>
		</table></form></div>

<div class="box">
<h3><SCRIPT >ddw("txtMYDlinkUpgrade");</SCRIPT></h3>
<form id="mydlink_uploadform" name="mydlink_uploadform" method="post" enctype="multipart/form-data" action="/goform/formMydlinkUpgrade">
<table>
			<tr>
				<td class=bc_tb><b><SCRIPT >ddw("txtUpload");</SCRIPT>:&nbsp;</b></td>
<!--                            <td><input type="file" id="upfile" name="upfile" size="30"/></td> -->
                                <!--<td><script>mydlink_initinput();</script></td>-->
				<td>
					<input type="file" id="upfile" name="upfile" onchange="mydlink_seturl()" size="30" class="ifile">
					<input type="text" vlaue="" id="url" size="30" onclick="mydlink_selectfile();" readonly>
					<input type="button" value="" id="select_2" onclick="mydlink_selectfile();">
				</td>                            
			</tr>
			<tr>
				<td class=bc_tb></td>
				<td><input type="button" class="button_submit" id="mydlink_upgrade_button" value="" onclick="doUpload_mydlink()"/></td>
			</tr>
			<tr>
				<td class=bc_tb></td>
				<td><p class="msg_inprogress" id="mydlink_msg_upload" style="display:none"><SCRIPT >ddw("txtUploadTake1Minute");</SCRIPT></td>
			</tr>
		</table></form></div>


<div class="box" style="display:none">
<h3><SCRIPT >ddw("txtFwNotify");</SCRIPT></h3>
<fieldset>
<p>
<label class="duple" for="fw_notify_email_enable_select">
<SCRIPT >ddw("txtFwNotify1");</SCRIPT> :
</label>
<strong><a href="http://wrpd.dlink.com.tw/register.asp" target="_blank"><SCRIPT >ddw("txtFwNotify2");</SCRIPT></a>
</strong></p></fieldset></div>
<!-- InstanceEndEditable --></div></td>
<td id="sidehelp_container">	<div id="help_text"><!-- InstanceBeginEditable name="Help_Text" --> 
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtFirmwareStr6");</SCRIPT></p><p class="more">
<!-- Link to more help --><a href="../Help/Tools.asp#Firmware" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a></p>
<!-- InstanceEndEditable --></div></td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div><!-- outside -->
</body>
<!-- InstanceEnd -->
</html>
