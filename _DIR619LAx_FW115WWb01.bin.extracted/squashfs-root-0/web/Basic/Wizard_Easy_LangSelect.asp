<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />
<link rel="stylesheet" rev="stylesheet" href="../networkmap.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="../style.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="../<% getInfo("substyle");%>" type="text/css" />
<script language="JavaScript" type="text/javascript">
<!--
var lang = "<% getLangInfo("lang");%>";
//-->
</script>
<style type="text/css">
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
<script type="text/javascript" src="../lang_wizard/wizard_country.js"></script>
<script type="text/javascript">
//<![CDATA[
var no_reboot_alt_location = "";

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
var productModel="<%getInfo("productModel")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = productModel;
RenderWarnings();
}
function next()
{
	document.write("<input type='button' name='next' value=\""+sw("txtWizardEasyLangSelectStart")+"\" onClick=\"page_next()\">&nbsp;");
}
var __AjaxAsk = null;
function doSaveSubmit(actionUrl)
{
	var mf = document.forms.wz_form_pg_1;
	if (__AjaxAsk == null) __AjaxAsk = __createRequest();
	__AjaxAsk.open("POST", actionUrl, true);
	__AjaxAsk.setRequestHeader('Content-type','application/x-www-form-urlencoded');  
	__AjaxAsk.send("config.lang_type="+mf.lang_type.value);
	
}
function on_change_lang_type(selectValue)
{	
	selectValue = selectValue *1;
	get_by_id("lang_type").value = selectValue;
	doSaveSubmit("/goform/formEasySetupLangWizard");
	setTimeout("window.location.reload()", 1000);
}
function page_load() 
{
	var mf = document.forms.wz_form_pg_1;
	get_by_id("lang_type").value = <% getIndexInfo("tmplangselect") %>;
}
function page_next()
{
	self.location.href="Wizard_Easy_Welcome.asp?t="+new Date().getTime();
}

function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
	document.title = DOC_Title;
	page_load();
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
<div id="wz_page_1" style="display:block">
<form id="wz_form_pg_1" name="wz_form_pg_1" action="http://<% getInfo("goformIpAddr"); %>/goform/formEasySetupLangWizard" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" id="curTime" name="curTime" value=""/>

<div id="box_header">

<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyStepWelcomeToEasySetUp");</SCRIPT>	</h1>
<p class="box_msg" style="display:block"><SCRIPT >ddw("txtWizardEasyLangSelectStr1");</SCRIPT>
</p>


		<table width="100%">
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardEasyLangSelectMenu");</SCRIPT></td>
			<td>:&nbsp;
			  <select id="lang_type" onchange="on_change_lang_type(this.value)" name="config.lang_type" style="width:120px">
                <option value = 0>
                 <SCRIPT >ddw("txtWizard_En");</SCRIPT>
                  </option>
                <option value = 1>
                 <SCRIPT >ddw("txtWizard_Fr");</SCRIPT>
                  </option>
                <option value = 2>
                 <SCRIPT >ddw("txtWizard_It");</SCRIPT>
                  </option>
                <option value = 3>
                 <SCRIPT >ddw("txtWizard_De");</SCRIPT>
                </option>
                <option value = 4>
                 <SCRIPT >ddw("txtWizard_Es");</SCRIPT>
                </option>
                <option value = 5>
                 <SCRIPT >ddw("txtWizard_Cs");</SCRIPT>
                  </option>
                <option value = 6>
                 <SCRIPT >ddw("txtWizard_Da");</SCRIPT>
                </option>
                <option value = 7>
                 <SCRIPT >ddw("txtWizard_El");</SCRIPT>
                </option>
		<option value = 8>
                 <SCRIPT >ddw("txtWizard_Fi");</SCRIPT>
                  </option>
		<option value = 9>
                 <SCRIPT >ddw("txtWizard_Hr");</SCRIPT>
                  </option>
                <option value = 10>
                 <SCRIPT >ddw("txtWizard_Hu");</SCRIPT>
                  </option>
                <option value = 11>
                 <SCRIPT >ddw("txtWizard_Nl");</SCRIPT>
                </option>
                <option value = 12>
                 <SCRIPT >ddw("txtWizard_No");</SCRIPT>
                </option>
		<option value = 13>
                 <SCRIPT >ddw("txtWizard_Pl");</SCRIPT>
                  </option>
                <option value = 14>
                 <SCRIPT >ddw("txtWizard_Pt");</SCRIPT>
                  </option>
                <option value = 15>
                 <SCRIPT >ddw("txtWizard_Ro");</SCRIPT>
                  </option>
                <option value = 16>
                 <SCRIPT >ddw("txtWizard_Sl");</SCRIPT>
                </option>
		<option value = 17>
                 <SCRIPT >ddw("txtWizard_Sv");</SCRIPT>
                </option>
			  </select>
			</td>
		</tr>
		</table>
		<br>
		<center><script>next();</script></center>
		<br>
</div>
</form>
</div><!-- wz_page_1 -->

</div>
<% getFeatureMark("MultiLangSupport_Head"); %>								
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td>
<td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
</html>
