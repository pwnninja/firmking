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
/** Styles used only on this page.*/
	fieldset label.duple {
		width: 300px;
	}
</style>
<!-- InstanceEndEditable -->
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
//<![CDATA[

var no_reboot_alt_location = "";

var ItvID=0;
var wan_cur_Type=0;
var status='';	

function get_update_page_ok()
{
		var conn_msg="";
    
		var f=get_obj("mainform");    	
				
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
				
				if((status=='0')||(status=='1')||(status=='2'))
				{
					self.location.href="Wizard_Easy_current.asp?t="+new Date().getTime()+"&type="+status;
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
function wan_link_timeout()
{
	if(status != '1' && status != '0')
	{
		status='2';
	}
	self.location.href="Wizard_Easy_current.asp?t="+new Date().getTime()+"&type="+status;
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
	setTimeout("wan_link_timeout()",15000);
	send_wan_type_request("/Basic/ajax_wan_link.asp?r="+generate_random_str());
		
}
function page_load() 
{
	decetive_wan_type();

}
function template_load()
{
<% getFeatureMark("MultiLangSupport_Head_script");%>
lang_form = document.forms.lang_form;
if ("" === "") {
i18n_xslt_processor = new xsltProcessingObject(i18n_xslt_is_ready, null, null, "/i18n_language_codes.xsl");
i18n_xml_data_fetcher = new xmlDataObject(i18n_data_is_ready, null, null, "/languages.xml");
i18n_xslt_processor.retrieveData();
i18n_xml_data_fetcher.retrieveData();
lang_form.i18n_language.value = "<%getLangInfo("langSelect")%>";
}
<% getFeatureMark("MultiLangSupport_Tail_script");%>
/** Prepend "0" to Firmware minor version if it is less than 10*/
var global_fw_minor_version = "<%getInfo("fwVersion")%>";
var fw_extend_ver = "";			
var fw_minor;
assign_firmware_version(global_fw_minor_version,fw_extend_ver,fw_minor);
var hw_version="<%getInfo("hwVersion")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = modelname;
/** Render any warnings to the user*/
page_load();
RenderWarnings();				
}
		
		
				

	//]]>
	</script>

	<!-- InstanceBeginEditable name="Scripts" -->
	<script type="text/javascript" src="/md5.js"></script>
	<script type="text/javascript">
	//<![CDATA[

function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtWanDetectFail");
document.title = DOC_Title;			
}
	//]]>
	</script>
	<!-- InstanceEndEditable -->
</head>
<body onload="init();template_load();">
<form name="mainform" action="http://<% getInfo("goformIpAddr"); %>/goform/formEasySetupWizard" method="post" id="mainform">
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
								
								<div id="maincontent_1col" style="display: block">

									<!-- InstanceBeginEditable name="Main_Content" -->
			<div class="section">
				<div class="section_head"> 
					<h5><SCRIPT >ddw("txtWizardEasyStepWelcomeToEasySetUp");</SCRIPT></h5>
					<br><br>
					<p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterDetectWaitting");</SCRIPT></p>
					<br>
				</div>
			</div> <!-- section -->
									<!-- InstanceEndEditable -->

								</div>
								
								<!-- language selection functions -->
<% getFeatureMark("MultiLangSupport_Head");%>
								<SCRIPT >
									DrawLanguageList();
								</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
							</td>
							<td id="sidehelp_container">&nbsp;</td>
						</tr>
					</table>
					<table id="footer_container" border="0" cellspacing="0" summary="">
						<tr>
							<td>
								<img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
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
</form>
</body>
<!-- InstanceEnd --></html>
