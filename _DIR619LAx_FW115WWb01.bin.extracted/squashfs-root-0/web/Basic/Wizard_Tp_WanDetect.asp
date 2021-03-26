<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset="<% getLangInfo("charset");%>" />
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
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[

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
function doCheckSubmit(actionUrl)
{
	var mf = document.forms.wz_form_pg_5;
	if (__AjaxAsk == null) __AjaxAsk = __createRequest();
	__AjaxAsk.open("POST", actionUrl, true);
	__AjaxAsk.setRequestHeader('Content-type','application/x-www-form-urlencoded');  
	__AjaxAsk.send("config.wan_type="+status);
	
}
var link_status='';
function goto()
{
	self.location.href="Wizard_Easy_complete.asp?t="+new Date().getTime()+"&mode="+link_status;
}
function goto_for_dhcp()
{
    if(link_status != "")
    {
        self.location.href="Wizard_Easy_complete.asp?t="+new Date().getTime()+"&mode="+link_status;
    }else
    {
        setTimeout("goto_for_dhcp()",1000);
    }
}

	
function get_link_update_page_ok()
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
			
				
				link_status=__AjaxReq.responseText.substring(0,1);
			    //alert(__AjaxReq.responseText);

			}else
			{
				return;
			}
					
	   } 	
}
function send_wan_link_request(url)
{
	if (__AjaxReq == null) __AjaxReq = __createRequest();
	__AjaxReq.open("GET", url, true);
	__AjaxReq.onreadystatechange = get_link_update_page_ok;
	__AjaxReq.send(null);

}
function decetive_wan_link()
{
	send_wan_link_request("/Basic/ajax_wan_link.asp?r="+generate_random_str());
		
}
function wan_link_Timeout()
{
	if(link_status != '0' && link_status != '1')
	{
		link_status = '2';
	}
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
				if (status=='1')
				{
					doCheckSubmit("/goform/formEasySetupWizard2");
			                    if("<%getInfo("wanType");%>" == "1")  /*if wan is dhcp, should speed up , not run init.sh*/
			                    {
			                        setTimeout("decetive_wan_link()", 1000);
			                        setTimeout("wan_link_Timeout()",11000);
			                        setTimeout("goto_for_dhcp()", 2000);
			                    }
			                    else
			                    {
			                        setTimeout("decetive_wan_link()", 30000);
			                        setTimeout("wan_link_Timeout()",39000);
			                        setTimeout("goto()", 40000);
			                    }
				}				
				if ((status=='0')||(status=='2')||(status=='9'))
				{
					self.location.href="Wizard_Easy_Wan_configure.asp?t="+new Date().getTime()+"&type="+status;
				}
				if (status=='8')
				{
					self.location.href="Wizard_Tp_WanDetect_Fail.asp?t="+new Date().getTime();
				}
				else
				{
					return;
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
function page_load() 
{
	//setTimeout("decetive_wan_type()", 1000);
	//decetive_wan_type();
	if(timeleft == 0)
		decetive_wan_type();		

	timeleft++;
	if(timeleft == 7)
		timeleft = 1;

	if(timeleft == 6){
		get_by_id("offline5").style.display = "";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}else if(timeleft == 5){
		get_by_id("offline4").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none"
	}else if(timeleft == 4){
		get_by_id("offline3").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}else if(timeleft == 3){
		get_by_id("offline2").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}else if(timeleft == 2){
		get_by_id("offline1").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}else{
		get_by_id("offline0").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
	}

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
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = modelname;
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
<div id="wz_page_1" style="display:block">
<h1><SCRIPT >ddw("txtWizardEasyStepWelcomeToEasySetUp");</SCRIPT></h1>
<div id="offline0" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterDetectWaitting");</SCRIPT>.</p></div>
<div id="offline1" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterDetectWaitting");</SCRIPT>..</p></div>
<div id="offline2" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterDetectWaitting");</SCRIPT>...</p></div>
<div id="offline3" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterDetectWaitting");</SCRIPT>... .</p></div>
<div id="offline4" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterDetectWaitting");</SCRIPT>... ..</p></div>
<div id="offline5" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterDetectWaitting");</SCRIPT>... ...</p>
</div></div><!-- wz_page_1 --></div> <!-- wizard_box -->
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
