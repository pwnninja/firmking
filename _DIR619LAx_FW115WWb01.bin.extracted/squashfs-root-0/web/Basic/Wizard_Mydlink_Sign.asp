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
<% getLangInfo("LangPathWizard");%>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript" src="../time_array.js"></script>
<script type="text/javascript">
//<![CDATA[
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
function WhatInfo(name)
{
	window.open(name,"_blank","width=850,height=420");
}
function sign_in(fn)
{
	document.write("<input type='button' name='sign_in' id='sign_in' value=\""+sw("txtWizardMydlinkSign_in")+"\" onClick='return "+fn+"'>&nbsp;");
}
function sign_up(fn)
{
	document.write("<input type='button' name='sign_up' id='sign_up' value=\""+sw("txtWizardMydlinkSign_up")+"\" onClick='return "+fn+"'>&nbsp;");
}
function go_back()
{
	var mf=document.forms.wz_form_pg_3;
	if(mf.submitflag.value == "current")
	{
		self.location.href="Wizard_Easy_current.asp?t="+new Date().getTime()+"&type=1";
	}
	else
	{
		self.location.href="Wizard_Easy_complete.asp?t="+new Date().getTime()+"&type=1";	
	}
}
function back(fn)
{
	if(fn=="") fn="go_back();";
	document.write("<input type='button' name='back' value=\""+sw("txtWizardMydlinkBack")+"\" onClick='"+fn+"'>&nbsp;");
}
function mail_addr_test(str)
{
	var rlt = 0;	
	var tmp = str.split("@");
	try{
        if(tmp.length == 2 && /^([+]?)*([a-zA-Z0-9]*[_|\-|\.|\+|\%|\*|\?|\!|\\]?)*[a-zA-Z0-9]*([+]?)+$/.test(tmp[0]) && /^([a-zA-Z0-9]*[_|\-|\.|\+|\%|\*|\?|\!|\\]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,6}$/.test(tmp[1])){
            rlt = 1
        }

//		rlt = /^([a-zA-Z0-9]+[_|\-|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\-|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,6}$/.test(str);
	}catch(e){}
	return rlt;
}
function checkString(str) 
{
    var reg = /^[-+@a-zA-Z0-9._\u0391-\uFFE5]+$/;
    if (arr = str.match(reg)) {     
        return true;
    }
    else {      
        return false;
    }
}
function strchk_hostname_mydlinkpw(str)
{
        if (__is_str_in_allow_chars(str, 1, "._-$")) return true;
        return false;
}
function wz_verify_3()
{
	var mf=document.forms.wz_form_pg_3;
	if(mf.mydlink_signflag.value == "sign_up")
	{
		if (mf.mydlink_account_up.value == "") {
			alert(sw("txtEmailAddressNotSet"));
			return;
		}
		if(!mail_addr_test(mf.mydlink_account_up.value))
		{
			alert(sw("txtGiveToAddress")+"("+ mf.mydlink_account_up.value +")"+sw("txtIsInvalid"));
			return false;
		}
		if ((mf.mydlink_passwd_up.value != mf.mydlink_passwdsec_up.value) || (mf.mydlink_passwd_up.value == "")) {
			alert(sw("txtPasswordsNotMatchReEnter"));
			mf.mydlink_passwd_up.value = "";
			mf.mydlink_passwdsec_up.value = "";
			mf.mydlink_passwd_up.selected = true;
			return false;
		}
		if (!strchk_hostname_mydlinkpw(mf.mydlink_passwd_up.value))
		{
			alert(sw("txtWizardMydlinkPasswd")+sw("txtIsInvalid"));
			return false;		
		}	
		if (mf.mydlink_firstname_up.value == ""){
			alert(sw("txtWizardMydlinkLastName")+sw("txtIsBlank"));
			return false;
		}
		/*
		if (!strchk_emailname(mf.mydlink_firstname_up.value))
		{
			if(strchk_unicode(mf.mydlink_firstname_up.value))
			{
				alert(sw("txtWizardMydlinkLastName")+sw("txtIsInvalid"));
				return false;	
			}	
		}	
		*/
		if(!checkString(mf.mydlink_firstname_up.value))
		{

				alert(sw("txtWizardMydlinkLastName")+sw("txtIsInvalid"));
				return false;	
		}
		if (mf.mydlink_lastname_up.value == ""){
			alert(sw("txtWizardMydlinkFirstName")+sw("txtIsBlank"));
			return false;
		}
		/*
		if (!strchk_emailname(mf.mydlink_lastname_up.value))
		{
			alert(sw("txtWizardMydlinkFirstName")+sw("txtIsInvalid"));
			return false;		
		}
		*/	
		if(!checkString(mf.mydlink_lastname_up.value))
		{

				alert(sw("txtWizardMydlinkFirstName")+sw("txtIsInvalid"));
				return false;	
		}
/*		if (mf.mydlink_routerpd_up.value == ""){
			alert(sw("txtWizardMydlinkRouterPasswd")+sw("txtIsBlank"));
			return false;
		}
		if(strchk_unicode(mf.mydlink_routerpd_up.value)==true)
		{
			alert(sw("txtUserInvalid3"));
			return false;
		}
*/
		if(mf.mydlink_server.checked != true)
		{
			alert(sw("txtWizardMydlinkQueryServerInfo"));
			return false;
		}
	}
	else
	{
		if (mf.mydlink_account_in.value == "") {
			alert(sw("txtEmailAddressNotSet"));
			return;
		}
		if(!mail_addr_test(mf.mydlink_account_in.value))
		{
			alert(sw("txtGiveToAddress")+"("+ mf.mydlink_account_in.value +")"+sw("txtIsInvalid"));
			return false;
		}
		if (mf.mydlink_passwd_in.value == "") {
			alert(sw("txtPasswordsNotMatchReEnter"));
			return false;
		}
		if (!strchk_hostname_mydlinkpw(mf.mydlink_passwd_in.value))
		{
			alert(sw("txtWizardMydlinkPasswd")+sw("txtIsInvalid"));
			return false;		
		}	
/*		if (mf.mydlink_routerpd_in.value == ""){
			alert(sw("txtWizardMydlinkRouterPasswd")+sw("txtIsBlank"));
			return false;
		}
		if(strchk_unicode(mf.mydlink_routerpd_in.value)==true)
		{
			alert(sw("txtUserInvalid3"));
			return false;
		}
*/		
	}

	return true;
}
var __AjaxAsk = null;
function doSaveSubmit(actionUrl)
{
	var mf=document.forms.wz_form_pg_3;
	if (__AjaxAsk == null) __AjaxAsk = __createRequest();
	__AjaxAsk.open("POST", actionUrl, true);
	__AjaxAsk.setRequestHeader('Content-type','application/x-www-form-urlencoded');  
	__AjaxAsk.send("config.submitflag="+mf.submitflag.value+"&config.mydlink_signflag="+mf.mydlink_signflag.value+"&config.mydlink_account_up="+mf.mydlink_account_up.value+"&config.mydlink_passwd_up="+mf.mydlink_passwd_up.value+"&config.mydlink_username_up="+mf.mydlink_username_up.value+"&config.mydlink_routerpd_up="+encode_base64(mf.mydlink_routerpd_up.value)+"&config.mydlink_firstname_up="+mf.mydlink_firstname_up.value+"&config.mydlink_lastname_up="+mf.mydlink_lastname_up.value+"&config.mydlink_account_in="+mf.mydlink_account_in.value+"&config.mydlink_passwd_in="+mf.mydlink_passwd_in.value+"&config.mydlink_username_in="+mf.mydlink_username_in.value+"&config.mydlink_routerpd_in="+encode_base64(mf.mydlink_routerpd_in.value));
	
}
function page_submit()
{
	var mf=document.forms.wz_form_pg_3;
	if (is_form_modified("wz_form_pg_3"))  //something changed
	{
		get_by_id("settingsChanged").value = 1;
	}
	if(wz_verify_3() == true){
		get_by_id("curTime").value = new Date().getTime();
		//document.wz_form_pg_3.submit();
	doSaveSubmit("/goform/form_mydlink_sign");		
   	get_by_id("wz_page_3").style.display = "none";
    get_by_id("wz_page_1").style.display = "";	
	setTimeout(save_load,500);
	}
}
function on_change_register_type(value)
{
	var mf=document.forms.wz_form_pg_3;
        mf.register_type_radio.value=value;
        if(value==1)
		{
        get_by_id("sign_in_setting").style.display = "none";
        get_by_id("sign_up_setting").style.display = "";
				get_by_id("sign_in").style.display = "none";
				get_by_id("sign_up").style.display = "";
				mf.register_type_radio_1.checked = true;
				mf.mydlink_signflag.value = "sign_up";
		} 	
        else
		{
       get_by_id("sign_in_setting").style.display = "";
       get_by_id("sign_up_setting").style.display = "none";	
				get_by_id("sign_in").style.display = "";
				get_by_id("sign_up").style.display = "none";	
				mf.register_type_radio_0.checked = true;
				mf.mydlink_signflag.value = "sign_in";
		}
}
function on_click_mydlink_server(value)
{
	var mf=document.forms.wz_form_pg_3;
	mf.mydlink_server.checked = value;
}
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtInternetConnectionSetupWizard");
document.title = DOC_Title;
get_by_id("wz_page_3").style.display = "";
get_by_id("wz_page_1").style.display = "none";	
var mf=document.forms.wz_form_pg_3;
var str1 = self.location.href.split('&');
var str2 = str1[1].substring(4,5);  
var errCode = str2 *1;
if(errCode==3)
{
	document.getElementById("show_err_info").innerHTML = sw("txtWizardMydlinkSignupError");
}
if(errCode==4)
{
	document.getElementById("show_err_info").innerHTML = sw("txtWizardMydlinkSigninError");		
}
if(errCode==5)
{
	document.getElementById("show_err_info").innerHTML = sw("txtWizardMydlinkAddDeviceErrorA");		
}
if(errCode==6)
{
	document.getElementById("show_err_info").innerHTML = sw("txtWizardMydlinkAddDeviceErrorB");		
}
if(errCode==7)
{
	document.getElementById("show_err_info").innerHTML = sw("txtWizardMydlinkNetworkUnreachable");		
}
if(errCode==0)
{
	document.getElementById("show_err_info").innerHTML = "";		
}
if(str1[2] == "sign_up")
{
	on_change_register_type(1);		
}
else
{
	on_change_register_type(0);		
}
if(str1[3]=="current")
{
	mf.submitflag.value = "current";
}
else
{
	mf.submitflag.value = "complete";
}
}

function doCheckSubmit(actionUrl)
{
	if (__AjaxAsk == null) __AjaxAsk = __createRequest();
	__AjaxAsk.open("POST", actionUrl, true);
	__AjaxAsk.setRequestHeader('Content-type','application/x-www-form-urlencoded');  
	__AjaxAsk.send("mydlink");
	
}
function GoToBack()
{
	var mf=document.forms.wz_form_pg_3;
	var str1 = self.location.href.split('&');	
	if(mf.submitflag.value == "current")
	{
		self.location.href="Wizard_Easy_current.asp?t="+new Date().getTime()+"&type=1"+"&"+mf.mydlink_account_in.value+"&"+mf.mydlink_routerpd_in.value;			
	}
	else
	{
		self.location.href="Wizard_Easy_complete.asp?t="+new Date().getTime()+"&type=1"+"&"+mf.mydlink_account_in.value+"&"+mf.mydlink_routerpd_in.value;
	}	
	return;
}
var status='';	
function get_update_page_ok()
{
		var conn_msg="";      	
		var mf=document.forms.wz_form_pg_3;				
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
			  //alert(__AjaxReq.responseText);
				//var str1 = self.location.href.split('&');		
				//2:success;1:run;3/4/5/6/7:show err info;    
			  if (status=='2')
			  {

			  	doCheckSubmit("/goform/formMydlinkWizardRegister");
          if(mf.mydlink_signflag.value== "sign_up")
          {
              self.location.href="Wizard_Mydlink_Save.asp?t="+new Date().getTime()+"&"+mf.submitflag.value;
          }
					setTimeout(GoToBack,2000);
			  }
			  if (status=='1')
			  {
			  		return;
			  }
			  if ((status=='3')||(status=='4')||(status=='5')||(status=='6')||(status=='7'))
			  {
			   	//get_by_id("wz_page_3").style.display = "";
			    //get_by_id("wz_page_1").style.display = "none";
			    //errCode = status;
			    //init();
			  	self.location.href="Wizard_Mydlink_Sign.asp?t="+new Date().getTime()+"&err="+status+"&"+mf.mydlink_signflag.value+"&"+mf.submitflag.value;
			  	return;
			  }

			}else
			{
				return;
			}
					
	   } 	
}
function send_mydlink_request(url)
{
	if (__AjaxReq == null) __AjaxReq = __createRequest();
	__AjaxReq.open("GET", url, true);
	__AjaxReq.onreadystatechange = get_update_page_ok;
	__AjaxReq.send(null);

}
function decetive_mydlink_request()
{
	send_mydlink_request("/Basic/ajax_mydlink_test.asp?r="+generate_random_str());
		
}
var marqueetime = 0;
var timeleft = 17;
function save_load() 
{
	var mf=document.forms.wz_form_pg_3;
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

	if(timeleft>0)
	{
		timeleft--;
	}
	if(timeleft ==5)
	{
		decetive_mydlink_request();
	}
	if(timeleft ==0)
	{
		self.location.href="Wizard_Mydlink_Sign.asp?t="+new Date().getTime()+"&err="+status+"&"+mf.mydlink_signflag.value+"&"+mf.submitflag.value;
		return;
	}
	setTimeout(save_load, 1000);
}
//]]>
</script>	
</head>
<body onload="template_load();init();web_timeout();">
<div id="loader_container" onclick="return false;" style="display: none">&nbsp;</div>
<div id="outside_1col">
<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
<tbody><tr><td>
<SCRIPT language=javascript type=text/javascript>
DrawHeaderContainer();
DrawMastheadContainer();
</SCRIPT>
<table id="content_container" border="0" cellspacing="0" summary="">
<tr><td id="sidenav_container">&nbsp;</td><td id="maincontent_container">
<div id="maincontent_1col" style="display: block">

<div id="wz_page_3" style="DISPLAY:none">
<form id="wz_form_pg_3" name="wz_form_pg_3" action="http://<% getInfo("goformIpAddr"); %>/goform/form_mydlink_sign" method="post">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="<%getWizardInformation("wizardSettingChanged");%>"/>
<input type="hidden" name="WEBSERVER_SSI_OPLOCK_ACTION" value="post"/>
<input type="hidden" name="WEBSERVER_SSI_OPLOCK_VALUE" value=""/>
<input type="hidden" name="wz_modified" value=""/>
<input type="hidden" id="curTime" name="curTime" value=""/>
<input type="hidden" id="mydlink_signflag" name="config.mydlink_signflag" value=""/>
<input type="hidden" id="submitflag" name="config.submitflag" value="">
<div id="box_header">
		<h1><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkSign");</SCRIPT></h1>
		<div>
		<table align="center">
		<tr>
			<td colspan="2"><SCRIPT>ddw("txtWizardMydlinkQueryAccount");</SCRIPT></td>
		</tr>
		<tr>
			<td class="r_tb"></td>
			<td class="l_tb">
            <input id="register_type_radio_0" type="radio" name="register_type_radio" value="0" onclick="on_change_register_type(this.value);"> <SCRIPT>ddw("txtWizardMydlinkHaveAccount");</SCRIPT></td>
		</tr>
		<tr>
			<td class="r_tb"></td>
			<td class="l_tb">
            <input id="register_type_radio_1" type="radio" name="register_type_radio" value="1" onclick="on_change_register_type(this.value);"> <SCRIPT>ddw("txtWizardMydlinkHaveNotAccount");</SCRIPT></td>
		</tr>				
		</table>
		</div>
		<br>	
		<div id=sign_in_setting style="DISPLAY:none">
		<table width="100%">
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkAccount");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="mydlink_account_in" size="25" maxlength="39" value="" name="config.mydlink_account_in"/>
			</td>
		</tr>	
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkPasswd");</SCRIPT></td>
			<td>:&nbsp;
				<input type="password" id="mydlink_passwd_in" size="25" maxlength="39" value="" name="config.mydlink_passwd_in"/>
			</td>
		</tr>	
		<tr style="display:none">
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkUsername");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="mydlink_username_in" size="25" maxlength="39" value="<% getIndexInfo("adminName"); %>" name="config.mydlink_username_in"/ disabled="disabled">
			</td>
		</tr>	
		<tr style="display:none">
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkRouterPasswd");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="mydlink_routerpd_in" size="25" maxlength="39" value="<% getIndexInfo("adminPass"); %>" name="config.mydlink_routerpd_in"/>
			</td>
		</tr>	
		</table>
		</div>	
		<div id=sign_up_setting style="DISPLAY:none">
		<table width="100%">
		<tr>
			<td colspan="2" align="center"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkPleaseFillInfo");</SCRIPT></td>
		</tr>	
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkAccount");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="mydlink_account_up" size="25" maxlength="39" value="" name="config.mydlink_account_up"/><a href="#" onclick="WhatInfo('MydlinkAccount.asp?');" style="color:#0000FF"><SCRIPT >ddw("txtWizardWhat");</SCRIPT></a>
			</td>
		</tr>	
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkPasswd");</SCRIPT></td>
			<td>:&nbsp;
				<input type="password" id="mydlink_passwd_up" size="25" maxlength="39" value="" name="config.mydlink_passwd_up"/>
			</td>
		</tr>	
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkPasswdSec");</SCRIPT></td>
			<td>:&nbsp;
				<input type="password" id="mydlink_passwdsec_up" size="25" maxlength="39" value="" name="config.mydlink_passwdsec_up"/>
			</td>
		</tr>	
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkLastName");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="mydlink_firstname_up" size="25" maxlength="39" value="" name="config.mydlink_firstname_up"/>
			</td>
		</tr>	
		<tr>
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkFirstName");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="mydlink_lastname_up" size="25" maxlength="39" value="" name="config.mydlink_lastname_up"/>
			</td>
		</tr>	
		<tr style="display:none">
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkUsername");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="mydlink_username_up" size="25" maxlength="39" value="<% getIndexInfo("adminName"); %>" name="config.mydlink_username_up"/ disabled="disabled">
			</td>
		</tr>	
		<tr style="display:none">
			<td class=br_tb width="40%"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkRouterPasswd");</SCRIPT></td>
			<td>:&nbsp;
				<input type="text" id="mydlink_routerpd_up" size="25" maxlength="39" value="<% getIndexInfo("adminPass"); %>" name="config.mydlink_routerpd_up"/>
			</td>
		</tr>	
		<tr>
			<td colspan="2" align="center"><font color="#0000FF"><SCRIPT language=javascript type=text/javascript>ddw("txtWizardMydlinkPasswdInfo");</SCRIPT></font></td>
		</tr>
		<tr>
			<td class=br_tb width="40%"><input type="checkbox" id="mydlink_server" onclick="on_click_mydlink_server(this.checked);"></td>
			<td><div id="mydlinkserverinfo"> <SCRIPT >ddw("txtWizardMydlinkServerInfo");</SCRIPT></div></td>    
		</tr>	
		</table>
		</div>	
		<br>
		<center><font color=red><B><span id="show_err_info"></span></B></font></center>
		<br>
		<center><script>sign_in("page_submit();");sign_up("page_submit();");back("");</script></center>
		<br>
		
</form></div></div><!-- wz_page_3 -->
<div id="wz_page_1" style="display:none">
<div id="box_header">
<h1><SCRIPT >ddw("txtWizardMydlinkSign");</SCRIPT></h3>
<div id="offline"><p class="box_msg" align="center"><SCRIPT >ddw("txtWizardEasyStep4Str1");</SCRIPT></p></div>
<div id="offline0" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>.</p></div>
<div id="offline1" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>..</p></div>
<div id="offline2" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>...</p></div>
<div id="offline3" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>... .</p></div>
<div id="offline4" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>... ..</p></div>
<div id="offline5" style="display:none"><p class="box_msg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<SCRIPT >ddw("txtWaittakeeffect");</SCRIPT>... ...</p>
</div></div></div><!-- wz_page_1 -->
</div>
<% getFeatureMark("MultiLangSupport_Head");%>
<SCRIPT language=javascript type=text/javascript>DrawLanguageList();	</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>
</td><td id="sidehelp_container">&nbsp;</td></tr></table>
<SCRIPT language=javascript type=text/javascript>Write_footerContainer();</SCRIPT>
</td></tr></tbody></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body>
</html>
