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
#wan_modes p
{
	margin-bottom: 1px;
}
#wan_modes input
{
	float: left;
	margin-right: 1em;
}
#wan_modes label.duple
{
	float: none;
	width: auto;
	text-align: left;
}
#wan_modes .itemhelp
{
	margin: 0 0 1em 2em;
}
#wz_buttons
{
	margin-top: 1em;
	border: none;
}
#add_sta_progress_bar
{
	overflow: hidden;
	width:195px;
	height:15px;
	margin: 0 auto;
	border: 2px solid black;
}
</style>
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">

var wan_cur_Type=0;
var status='';	
var __AjaxAsk = null;
var timeleft = 0;

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

function get_update_page_ok()
{
		var conn_msg="";
    
		var f=get_obj("wz_form_pg_5");    	
				
		if (__AjaxReq != null && __AjaxReq.readyState == 4)
		{	  
		
				//alert(__AjaxReq.status);
		
			if (__AjaxReq.status == 200)
			{
				//alert(__AjaxReq.responseText.length);
				if (__AjaxReq.responseText.length <= 1) /* No data */
				{					
						return;		
				}
			
				
				status=__AjaxReq.responseText.substring(0,1);

				if (status=='8')
				{
					self.location.href="Wizard_Easy_WanDetect_Fail.asp?t="+new Date().getTime();
				}
				else
				{
					self.location.href="Wizard_Easy_Config.asp?t="+new Date().getTime()+"&type="+status;
				}
			    //alert(__AjaxReq.responseText);

			}else
			{
				return;
			}
					
	   } 	
}
function send_wan_type_request(url)
{
	if (__AjaxReq == null) __AjaxReq = __createRequest();
	__AjaxReq.open("GET", url, true);
	__AjaxReq.onreadystatechange = get_update_page_ok;
	__AjaxReq.send(null);

}

function decetive_wan_type()
{
	send_wan_type_request("/Basic/ajax_wan_type.asp?r="+generate_random_str());
		
}
function refresh_progress_bar(index)
{
	var bar_color = "#FF6F00";
	var clear = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	if(index > 10)
	{
		for (i = 0; i <= 10; i++)
		{
			var block = document.getElementById("block" + i);
			block.innerHTML = clear;
			block.style.backgroundColor = "#DFDFDF";
		}
		index = index - 10;
	}
	for (i = 0; i <= index; i++)
	{
		var block = document.getElementById("block" + i);
		block.innerHTML = clear;
		block.style.backgroundColor = bar_color;
	}
}
function page_load() 
{
	//setTimeout("decetive_wan_type()", 1000);
	//decetive_wan_type();
	if(timeleft == 0)
		decetive_wan_type();
	refresh_progress_bar(timeleft);
	timeleft++;

	setTimeout(page_load, 1000);
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
page_load();
RenderWarnings();
}
//]]>
</script>
</head>
<body onload="template_load();">
<div id="loader_container" onclick="return false;" style="display: none">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td>
<SCRIPT >
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr>	<td id="sidenav_container">&nbsp;</td><td id="maincontent_container">
<div id="maincontent_1col" style="display: block">
<!-- InstanceBeginEditable name="Main_Content" -->
<div id="box_header">
<div id="wz_page_3" style="display:block">
<h1><SCRIPT >ddw("txtWizardEasyStepWelcomeToEasySetUp");</SCRIPT></h1>
<p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterDetectWaitting");</SCRIPT>...</p>
<div id="add_sta_progress_bar" style="display:block">
<span id="block0">&nbsp;</span><span id="block1">&nbsp;</span><span id="block2">&nbsp;</span><span id="block3">&nbsp;</span><span id="block4">&nbsp;</span><span id="block5">&nbsp;</span><span id="block6">&nbsp;</span><span id="block7">&nbsp;</span><span id="block8">&nbsp;</span><span id="block9">&nbsp;</span><span id="block10">&nbsp;</span>
</div>
</div><!-- wz_page_1 -->
</div> <!-- wizard_box -->
</div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT >DrawLanguageList();</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT >Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div>
</body>
</html>
