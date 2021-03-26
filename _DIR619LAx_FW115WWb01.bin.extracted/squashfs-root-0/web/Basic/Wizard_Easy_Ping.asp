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
var status='3';	
var decetive_wan_link_time = 0;
var marqueetime = 0;
wan_type = "<%getInfo("wanType");%>";
ppp_xkjs = "<%getInfo("pppXkjs_on-of");%>";
var get_update_page_returned = 0;
function get_update_page_ok()
{
		var conn_msg="";
    
		var f=get_obj("wz_form_pg_5");    	
		if (__AjaxReq != null && __AjaxReq.readyState == 4)
		{	  
		
				//alert(__AjaxReq.status);
		
			if (__AjaxReq.status == 200)
			{
				get_update_page_returned--;
				//alert(__AjaxReq.responseText.length);
				if (__AjaxReq.responseText.length <= 1) /* No data */
				{					
						return;		
				}
			
				
				status=__AjaxReq.responseText.substring(0,1);
			    //alert(__AjaxReq.responseText);

			}else
			{
				return;
			}
					
	   } 	
}
function wan_link_Timeout()
{
	if(status != '0' && status != '1')
	{
		status='2';
	}
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
if((ppp_xkjs == 'true') && (wan_type == '2'))
	var timeleft = 230;
else
	var timeleft = 80;

var timeall = timeleft;
function decetive_wan_link()
{
	return send_wan_link_request("/Basic/ajax_wan_link.asp?r="+generate_random_str());
		
}
function ping_test()
{
	send_wan_link_request("/Basic/ajax_ping_test.asp?r="+generate_random_str());
}
var ping_test_start = 25;

function page_load() 
{
	if (timeall - timeleft >=ping_test_start && status == '3')
		ping_test();
	else if(status != '3')  //3: wan not have ip, ping_test() will return 3
	{    
		if(decetive_wan_link_time <= 1 && decetive_wan_link() == 1)  //ping 2 times
			decetive_wan_link_time++;	
	}
	if (decetive_wan_link_time > 1 && get_update_page_returned == 0 || status == 1) //if ping 2 times and boa returns, or ping seccuss
	{
		self.location.href="<%getInfo("last_url");%>?t="+new Date().getTime()+"&mode="+status;
		return;
	}
	if (timeleft == 0) 
	{
		if (status=='2')
		{
			self.location.href="<%getInfo("last_url");%>?t="+new Date().getTime()+"&mode="+status;
			return;
		}else
		{
			var str1 = self.location.href.split('?');
			var str2 = str1[1].substring(5,6);
			str2 = str2 *1 +1;      
			if(str2 == '5')
			{
				self.location.href="<%getInfo("last_url");%>?t="+new Date().getTime()+"&mode="+status;
				return;                         
			}
			if(str2 == '4')
			{
				if (wan_type=='0')
				{
					self.location.href="<%getInfo("last_url");%>?t="+new Date().getTime()+"&mode="+status;
					return;
				}
				self.location.href = '../logout.asp?t='+new Date().getTime();
				return;
			}
			else
			{
				self.location.href = 'Wizard_Easy_Wan_configure.asp?t='+new Date().getTime()+'&type='+wan_type+'&time='+str2;
				return;
			}       
		}
	}
	marqueetime++;
	if(marqueetime == 7)
	{
		marqueetime = 1;
	}
	if(marqueetime == 6){
		get_by_id("offline5").style.display = "";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}else if(marqueetime == 5){
		get_by_id("offline4").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none"
	}else if(marqueetime == 4){
		get_by_id("offline3").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline2").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}else if(marqueetime == 3){
		get_by_id("offline2").style.display = "";
		get_by_id("offline5").style.display = "none";
		get_by_id("offline4").style.display = "none";
		get_by_id("offline3").style.display = "none";
		get_by_id("offline1").style.display = "none";
		get_by_id("offline0").style.display = "none";
	}else if(marqueetime == 2){
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
	timeleft--;
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
<h1><SCRIPT >ddw("txtWizardEasyStepRenewConfig");</SCRIPT></h3>
<div id="offline0" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterRedetect");</SCRIPT>.</p></div>
<div id="offline1" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterRedetect");</SCRIPT>..</p></div>
<div id="offline2" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterRedetect");</SCRIPT>...</p></div>
<div id="offline3" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterRedetect");</SCRIPT>... .</p></div>
<div id="offline4" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterRedetect");</SCRIPT>... ..</p></div>
<div id="offline5" style="display:none"><p class="box_msg"><SCRIPT >ddw("txtWizardEasyStepRouterRedetect");</SCRIPT>... ...</p>
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
