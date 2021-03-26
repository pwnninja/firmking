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
<% getLangInfo("LangPath");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[
function go_prev()
{
	history.back();
}	
function prev(fn)
{
	if(fn=="") fn="go_prev();";
	document.write("<input type='button' name='prev' value=\""+sw("txtPrev")+"\" onClick='"+fn+"'>&nbsp;");
}

function exit()
{
	document.write("<input type='button' name='exit' value=\""+sw("txtCancel")+"\" onClick=\"page_cancel()\">&nbsp;");
}


var no_reboot_alt_location = "";

function do_reboot()   
{   
     document.forms["rebootdummy"].next_page.value="Basic/Internet.asp";   
     document.forms["rebootdummy"].act.value="do_reboot";   
     document.forms["rebootdummy"].submit();   
}   
function no_reboot()   
{   
     document.forms["rebootdummy"].next_page.value="Basic/Internet.asp";   
     document.forms["rebootdummy"].submit();   
} 

function page_submit()
{
	if (is_form_modified("wz_form_pg_6"))  //something changed
	{
		get_by_id("settingsChanged").value = 1;
	}
	get_by_id("curTime").value = new Date().getTime();
	//document.forms["wz_form_pg_6"].submit();
	document.wz_form_pg_6.submit();
}
function page_cancel()
{
	if (is_form_modified("wz_form_pg_6") || get_by_id("settingsChanged").value == 1) 
  {
		if (confirm (sw("txtAbandonAallChanges"))) 
		{
			top.location='Internet.asp?t='+new Date().getTime();
		}
	}else{
					top.location='Internet.asp?t='+new Date().getTime();
			}			
}
function page_load() 
{
	displayOnloadPage("<%getInfo("ok_msg")%>");
	
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
document.title = DOC_Title;	
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("wz_save_b").value = sw("txtConnect");	
set_form_default_values("wz_form_pg_6");	
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
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;" style="display: none">&nbsp;</div>
<div id="outside_1col"><table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td><SCRIPT language=javascript type=text/javascript>
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr><td id="sidenav_container">&nbsp;</td>
<td id="maincontent_container">
<SCRIPT language=javascript type=text/javascript>DrawRebootContent();</SCRIPT>
<div id="maincontent" style="display: block">
<div id="wz_page_6" style="display:block">
<form id="wz_form_pg_6" name="wz_form_pg_6" action="http://<% getInfo("goformIpAddr"); %>/goform/formSetWAN_Wizard7" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" id="curTime" name="curTime" value=""/>

<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtSetupComplete");</SCRIPT>	</h1>
<p><SCRIPT language=javascript type=text/javascript>ddw("txtWizardWanStr21");</SCRIPT></p>

		<br>
		<center>
		<script>
		prev("");
		document.write("<input type='submit' id='wz_save_b' name='wz_save_b' value=\"\" onClick='page_submit();'>&nbsp;");
		exit();
		</script>
		</center>
		<br>
		</div>
</form></div><!-- wz_page_6 --><!-- wizard_box --></div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();	</SCRIPT><% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td>
</tr></table><SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
