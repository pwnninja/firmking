<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<title>
 Wireless Router
</title>
<script>
var ModemVer='<% getCfgGeneral(1, "ProductModemVersion"); %>';
var HardwareVer='<% getCfgGeneral(1, "HardwareVersion"); %>';
var FirmwareVer='<% getCfgGeneral(1, "FirmwareVersion"); %>';
var statuscheckpppoeuser=<% GetStatusCheckPPPOEser(); %>;
var statusconnect = '<% getCfgGeneral(1, "wanConnectionMode"); %>';
var statuslink = '<% getPortStatus(); %>'.split(',');
</script>
<style type="text/css">
.wizard_step{
 background: #404343;
    width: 842px;
 margin: 0 auto;
}
.wizard_main{
 padding-bottom: 10px;
}
.wizard_main h2{
 text-align: left;
 color: #fff;
 font-size: 18px;
 padding: 0 60px;
 font-weight: normal;
}
.wizard_main h2 span{
 color: #ccc;
 font-size: 14px;
 padding-right: 10px;
}
.wizard_main h2 img{
 background: url(../images/line.jpg) repeat-x;
 width: 360px;
 height: 1px;
 padding-left: 10px;
}
.wizard_main h2 i{
 background: #ccc;
 width: 50px;
 height:20px
}
.image_01{
 background:url(../images/pc.jpg) 10px 0 no-repeat;
 width: 134px;
 height: 117px;
}
.image_02{
 background:url(../images/connect_yes.jpg) 5px 15px no-repeat;
 width: 114px;
 height: 117px;
}
.image_03{
 background:url(../images/route.jpg) no-repeat;
 width: 136px;
 height: 117px;
}
.image_04{
 background:url(../images/connect_no.jpg) 5px 15px no-repeat;
 width: 114px;
 height: 117px;
}
.image_05{
 background:url(../images/global_no.jpg) 10px 0 no-repeat;
 width: 136px;
 height: 117px;
}
.image_06{
 background:url(../images/global_yes.jpg) 10px 0 no-repeat;
 width: 136px;
 height: 117px;
}
.setting_title{
 background-color: #F56D23;
    color: #000;
 font-size: 14px;
    font-weight: bold;
    height: 25px;
    padding-left: 10px;
}
.setting_table_save{
 margin: 20px auto;
    width: 500px;
 text-align: left;
}
.setting_table_save tr{
 text-align: right;
}
.setting_table_save td{
 text-align: center;
}
.setting_table_save a{
 text-decoration: none;
 color: #fff;
 font-size: 14px;
}
.setting_table_save input{
 padding: 5px 20px;
 font-size: 14px;
}
.wizard_step{
 background: #404343;
    width: 842px;
 margin: 0 auto;
}
.setting_table_local{
 background: #d4d4d4;
 margin: 0 auto;
    width: 720px;
 text-align: left;
}
.setting_client{
 padding-left: 15px;
}
.wizard_title{
 background: #F56D23;
}
</style>
<script language="javascript">
function updateChanX()
{
 document.getElementById("id_checkpppoeuser").style.display = 'none';
 if(document.getElementById("connect_select").value=="PPPOE")
 {
  document.getElementById("connect_PPPoE").style.display = 'block';
  document.getElementById("connect_static").style.display = 'none';
  document.getElementById("wantype").innerText = 'PPPoE';
  document.getElementById("id_checkpppoeuser").style.display = 'block';
 }
 else if(document.getElementById("connect_select").value=="STATIC")
 {
  document.getElementById("connect_static").style.display = 'block';
  document.getElementById("connect_PPPoE").style.display = 'none';
  document.getElementById("wantype").innerText = 'Static';
 }
 else
 {
  document.getElementById("connect_PPPoE").style.display = 'none';
  document.getElementById("connect_static").style.display = 'none';
  document.getElementById("wantype").innerText = 'DHCP';
 }

	if ("<% getWPAEncode2g(1, "WPAPSK1"); %>" != "")
	{
		document.form2WizardSetup.tmp_wizardstep4_pskpwd_2.value = Base64.Decode("<% getWPAEncode2g(1, "WPAPSK1"); %>");
	}
	if ("<% getWPAEncode5g(1, "WPAPSK1"); %>" != "")
	{
		document.form2WizardSetup.tmp_wizardstep4_pskpwd_5.value = Base64.Decode("<% getWPAEncode5g(1, "WPAPSK1"); %>");
	}
}
function updateChan()
{
if(statusconnect == 'PPPOE')
{
	if ( '<% getCfgGeneral(1, "wan_pppoe_user_encode"); %>' != '')
	{
		document.form2WizardSetup.show_pppoe_usrname.value = Base64.Decode('<% getCfgGeneral(1, "wan_pppoe_user_encode"); %>');
	}
	
	document.form2WizardSetup.pppoe_psword.value = '<% getPPPoePass(); %>';
}else if(statusconnect == 'STATIC'){
	document.form2WizardSetup.staip_ipaddr.value = "<% getWanIp(); %>";
	document.form2WizardSetup.staip_netmask.value = "<% getWanNetmask(); %>";
	document.form2WizardSetup.staip_gateway.value = "<% getWanGateway(); %>";
	document.form2WizardSetup.wan_dns1.value = "<% getDns(1); %>";
	document.form2WizardSetup.wan_dns2.value = "<% getDns(2); %>";
}
 document.getElementById("connect_select").value = statusconnect;
 updateChanX();
}
var lanip="<% getLanIp(); %>";
var lanmask="<% getLanNetmask(); %>";
function validateIP(ip, msg) {
 if (ip.value == "") {
  alert(msg + ' 不可以空白! 应该输入像 xxx.xxx.xxx.xxx 的4個数字。');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 var str = ip.value;
 var count = 0;
 for (var i = 0; i < str.length; i++) {
  if ((str.charAt(i) >= '0' && str.charAt(i) <= '9')) continue;
  if (str.charAt(i) == '.') {
   count++;
   continue;
  }
  alert('无效的 '+ msg+'数值 ! 数值应该是十进位的数字(0-9)。');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if (count != 3) {
  alert('无效的 '+ msg+'数值 ! 数值应该输入像 xxx.xxx.xxx.xxx 的4個数字。');
  ip.focus();
  return false;
 }
 if (IsLoopBackIP(ip.value) == 1) {
  alert(msg + '无效。');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if (!checkDigitRange(ip.value, 1, 1, 223)) {
  alert(msg + '第1位的IP位址范围无效! 范围应该在1-233。');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if (!checkDigitRange(ip.value, 2, 0, 255)) {
  alert(msg + '第2位的IP位址范围无效! 范围应该在0-255。');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if (!checkDigitRange(ip.value, 3, 0, 255)) {
  alert(msg + '第3位的IP位址范围无效! 范围应该在0-255。');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if (!checkDigitRange(ip.value, 4, 1, 254)) {
  alert(msg + '第4位的IP位址范围无效! 范围应该在1-254。');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 return true;
}
function includeSpace(str)
{
  for (var i=0; i<str.length; i++) {
   if ( str.charAt(i) == ' ' ) {
   return true;
 }
  }
  return false;
}

function saveChanges()
{
 with(document.form2WizardSetup)
 {
  if(document.getElementById("connect_select").value=="STATIC")
  {
   if (!validateIP(staip_ipaddr, "IP地址")) {
    staip_ipaddr.focus();
    return false;
   }
   if (Lan1EqLan2(staip_ipaddr.value, lanmask, lanip, lanmask)) {
    alert("WAN IP and LAN IP 必须在不同的网络!");
    staip_ipaddr.focus();
    return false;
   }
   if (staip_netmask.value != "") {
    if (!checkMask(staip_netmask)) {
     staip_netmask.focus();
     return false;
    }
    d1 = getDigit(staip_netmask.value, 1);
    d2 = getDigit(staip_netmask.value, 2);
    d3 = getDigit(staip_netmask.value, 3);
    d4 = getDigit(staip_netmask.value, 4);
    if ((d1 == 0) || (d4 == 254) || ((d1 == 255) && (d2 == 255) && (d3 == 255) && (d4 == 255))) {
     alert("无效的IP网络掩码位址!");
     staip_netmask.focus();
     return false;
    }
   }
   if (!validateIP(staip_gateway, "预设路由位址")) {
    staip_gateway.focus();
    return false;
   }
   
   if (!Lan1EqLan2(staip_ipaddr.value, staip_netmask.value, staip_gateway.value, staip_netmask.value)) {
    alert("WAN 和 网关 必须在同一個网络!");
    staip_gateway.focus();
    return false;
   }
	
   if (staip_ipaddr.value == staip_gateway.value) {
    alert("WAN 和 网关 不可以相同!");
    staip_gateway.focus();
    return false;
   }
   if (!validateIP(wan_dns1, "DNS 1地址")) {
    wan_dns1.focus();
    return false;
   }
   if (wan_dns1.value == staip_ipaddr.value) {
    alert("DNS IP 和 WAN IP 不可以相同!");
    wan_dns1.focus();
    return false;
   }
   if (Lan1EqLan2(wan_dns1.value, lanmask, lanip, lanmask)) {
    alert("DNS IP and LAN IP 必须在不同的网络!");
    wan_dns1.focus();
    return false;
   }
   if (wan_dns2.value != "0.0.0.0") {
    if (!validateIP(wan_dns2, "DNS 2地址")) {
     wan_dns2.focus();
     return false;
    }
    if (wan_dns2.value == wan_dns1.value) {
     alert("主要DNS 和 次要DNS 不可以相同!");
     wan_dns2.focus();
     return false;
    }
    if (wan_dns2.value == staip_ipaddr.value) {
     alert("DNS IP 和 WAN IP 不可以相同!");
     wan_dns2.focus();
     return false;
    }
    if (Lan1EqLan2(wan_dns2.value, lanmask, lanip, lanmask)) {
     alert("DNS IP and LAN IP 必须在不同的网络!");
     wan_dns2.focus();
     return false;
    }
   }
  }
  else if(document.getElementById("connect_select").value=="PPPOE")
  {
   if(show_pppoe_usrname.value.length == 0)
   {
    alert('使用者名称不可以空白，请再试一次。');
    show_pppoe_usrname.focus();
    return false;
   }
   else
   {
    if(!checkSpecialChar(show_pppoe_usrname.value, 1))
    {
     alert('无效的使用者名称!');
     show_pppoe_usrname.focus();
     return false;
    }
   }
   if(pppoe_psword.value.length == 0)
   {
    alert('密码不可以空白，请再试一次。');
    pppoe_psword.focus();
    return false;
   }
   else
   {
    if(!checkSpecialChar(pppoe_psword.value, 1))
    {
     alert('无效的密码!');
     pppoe_psword.focus();
     return false;
    }
   }
  }

  if(includeSpecialKey(wizardstep4_ssid_2.value))
  {
   alert('无效的SSID! 不可以使用"|$@"\<>"这些特殊字元。');
   wizardstep4_ssid_2.focus();
   return false;
  }

  var str = tmp_wizardstep4_pskpwd_2.value;
  if (str.length != 64)
  {
   if (str.length > 0 && str.length < 8)
   {
    alert('Pre-Shared密码必须为8個字符以上。');
    tmp_wizardstep4_pskpwd_2.focus();
    return false;
   }
   if (str.length > 63)
   {
    alert('Pre-Shared密码必须为63个字符以內。');
    tmp_wizardstep4_pskpwd_2.focus();
    return false;
   }
   
   if(includeSpecialKey(str))
   {
    alert('预共享密码中含有无效字符.不能包含"|$@"\<>"特殊字符');
	tmp_wizardstep4_pskpwd_2.focus();
    return false;
   }
   if(includeChinese(str))
   {
    alert('预共享密码中不能包含中文字符');
	tmp_wizardstep4_pskpwd_2.focus();
    return false;
   }
   
  }
  else
  {
   for (var i=0; i<str.length; i++)
   {
    if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') || (str.charAt(i) >= 'a' && str.charAt(i) <= 'f') || (str.charAt(i) >= 'A' && str.charAt(i) <= 'F') )
    {
     continue;
    }
    alert("无效的Pre-Shared密码格式! 格式必须为0-9或a-f。");
    tmp_wizardstep4_pskpwd_2.focus();
    return false;
   }
  }

  //5g 
    if(includeSpecialKey(wizardstep4_ssid_5.value, 1))
  {
   alert('无效的SSID! 不可以使用"|$@"\<>"这些特殊字元。');
   wizardstep4_ssid_5.focus();
   return false;
  }

  var str = tmp_wizardstep4_pskpwd_5.value;
  if (str.length != 64)
  {
   if (str.length > 0 && str.length < 8)
   {
    alert('Pre-Shared密码必须为8個字符以上。');
    tmp_wizardstep4_pskpwd_5.focus();
    return false;
   }
   if (str.length > 63)
   {
    alert('Pre-Shared密码必须为63个字符以內。');
    tmp_wizardstep4_pskpwd_5.focus();
    return false;
   }
   if(includeSpecialKey(str))
   {
    alert('预共享密码中含有无效字符.不能包含"|$@"\<>"特殊字符');
	tmp_wizardstep4_pskpwd_5.focus();
    return false;
   }
   if(includeChinese(str))
   {
    alert('预共享密码中不能包含中文字符');
	tmp_wizardstep4_pskpwd_5.focus();
    return false;
   }
  }
  else
  {
   for (var i=0; i<str.length; i++)
   {
    if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') || (str.charAt(i) >= 'a' && str.charAt(i) <= 'f') || (str.charAt(i) >= 'A' && str.charAt(i) <= 'F') )
    {
     continue;
    }
    alert("无效的Pre-Shared密码格式! 格式必须为0-9或a-f。");
    tmp_wizardstep4_pskpwd_5.focus();
    return false;
   }
  }
  
   if ( tmp_wizardstep4_pskpwd_2.value != "")
   {
		wizardstep4_pskpwd_2.value = Base64.Encode(tmp_wizardstep4_pskpwd_2.value);
   }
   if (tmp_wizardstep4_pskpwd_5.value != "")
   {
		wizardstep4_pskpwd_5.value = Base64.Encode(tmp_wizardstep4_pskpwd_5.value);
   }
   
   if ( show_pppoe_usrname.value != "")
   {
		pppoe_usrname.value = Base64.Encode(show_pppoe_usrname.value);
   }
   
	if (pppoe_psword.value != "" && pppoe_psword.value != "********" )
	{
		pppoe_psword.value = Base64.Encode(pppoe_psword.value);
	}

	show_pppoe_usrname.disabled = true;
	tmp_wizardstep4_pskpwd_2.disabled = true;
	tmp_wizardstep4_pskpwd_5.disabled = true;
  }
 document.form2WizardSetup.statuscheckpppoeuser.value = "0";
 document.form2WizardSetup.submit();
 return true;
}
var wtime;
function timerStart()
{
 if (wtime >= 0)
 {
  document.form2WizardSetup.checkpppoeuser.value = '检测中, 剩余'+wtime+'秒';
        document.form2WizardSetup.connecttype.disabled = true;
        document.form2WizardSetup.show_pppoe_usrname.disabled = true;
        document.form2WizardSetup.pppoe_psword.disabled = true;
        document.form2WizardSetup.wizardstep4_ssid_2.disabled = true;
        document.form2WizardSetup.tmp_wizardstep4_pskpwd_2.disabled = true;
        document.form2WizardSetup.wizardstep4_ssid_5.disabled = true;
        document.form2WizardSetup.tmp_wizardstep4_pskpwd_5.disabled = true;
        document.form2WizardSetup.checkpppoeuser.disabled = true;
  document.form2WizardSetup.save.disabled = true;
  wtime--;
  setTimeout("timerStart()",1000);
 }
 else
 {
        document.form2WizardSetup.connecttype.disabled = false;
        //document.form2WizardSetup.show_pppoe_usrname.disabled = false;
        document.form2WizardSetup.pppoe_psword.disabled = false;
        document.form2WizardSetup.wizardstep4_ssid_2.disabled = false;
        //document.form2WizardSetup.tmp_wizardstep4_pskpwd_2.disabled = false;
        document.form2WizardSetup.wizardstep4_ssid_5.disabled = false;
        //document.form2WizardSetup.tmp_wizardstep4_pskpwd_5.disabled = false;
		document.form2WizardSetup.checkpppoeuser.disabled = false;
  document.form2WizardSetup.save.disabled = false;
  document.form2WizardSetup.checkpppoeuser.value = "账号检测";
  document.form2WizardSetup.statuscheckpppoeuser.value = "2";

  if ( document.form2WizardSetup.tmp_wizardstep4_pskpwd_2.value != "")
   {
		document.form2WizardSetup.wizardstep4_pskpwd_2.value = Base64.Encode(document.form2WizardSetup.tmp_wizardstep4_pskpwd_2.value);
   }
   if (document.form2WizardSetup.tmp_wizardstep4_pskpwd_5.value != "")
   {
		document.form2WizardSetup.wizardstep4_pskpwd_5.value = Base64.Encode(document.form2WizardSetup.tmp_wizardstep4_pskpwd_5.value);
   }
   
   if ( document.form2WizardSetup.show_pppoe_usrname.value != "")
   {
		document.form2WizardSetup.pppoe_usrname.value = Base64.Encode(document.form2WizardSetup.show_pppoe_usrname.value);
   }
   if (document.form2WizardSetup.pppoe_psword.value != "" && document.form2WizardSetup.pppoe_psword.value != "********")
   {
		document.form2WizardSetup.pppoe_psword.value = Base64.Encode(document.form2WizardSetup.pppoe_psword.value);
   }
    	
  document.form2WizardSetup.submit();
 }
}
function pppoeSaveChanges()
{
 if(document.form2WizardSetup.show_pppoe_usrname.value.length == 0)
 {
  alert("密码不可以空白，请再试一次。");
  document.form2WizardSetup.show_pppoe_usrname.focus();
  return false;
 }
 else
 {
  if(!checkSpecialChar(document.form2WizardSetup.show_pppoe_usrname.value, 1))
  {
   alert('无效的使用者名称!');
   document.form2WizardSetup.show_pppoe_usrname.focus();
   return false;
  }
 }
 if(document.form2WizardSetup.pppoe_psword.value.length == 0)
 {
  alert('密码不可以空白，请再试一次。');
  document.form2WizardSetup.pppoe_psword.focus();
  return false;
 }
 else
 {
  if(!checkSpecialChar(document.form2WizardSetup.pppoe_psword.value, 1))
  {
   alert('无效的密码!');
   document.form2WizardSetup.pppoe_psword.focus();
   return false;
  }
 }
 /*
 if(statuslink[0] == '0')
 {
  document.getElementById("id_noconnected").style.display = 'block';
  return false;
 }*/
 return true;
}
function onClickCheckPppoeUser()
{
 if(true == pppoeSaveChanges())
 {
  document.form2WizardSetup.statuscheckpppoeuser.value = "1";
  
  document.form2WizardSetup.pppoe_usrname.value = Base64.Encode(document.form2WizardSetup.show_pppoe_usrname.value);
  if (document.form2WizardSetup.pppoe_psword.value != "")
  {
	document.form2WizardSetup.pppoe_psword.value = Base64.Encode(document.form2WizardSetup.pppoe_psword.value);
  }
  
  document.form2WizardSetup.show_pppoe_usrname.disabled = true;
  document.form2WizardSetup.tmp_wizardstep4_pskpwd_2.disabled = true;
  document.form2WizardSetup.tmp_wizardstep4_pskpwd_5.disabled = true;
  
  document.form2WizardSetup.submit();
  return true;
 }
 else
 {
  return false;
 }
}
function postload()
{
 if('1' == document.form2WizardSetup.statuscheckpppoeuser.value)
 {
  wtime = 15;
  timerStart(); 
 }
// else if('11' == document.form2WizardSetup.statuscheckpppoeuser.value)
 else if('2' == document.form2WizardSetup.statuscheckpppoeuser.value)
 {
	if(statuslink[0] == '0')
	{  
		document.getElementById("id_noconnected").style.display = 'block';
	}				
 }
 else if('12' == document.form2WizardSetup.statuscheckpppoeuser.value)
 {
  document.getElementById("id_noack").style.display = 'block';
 }
 else if('13' == document.form2WizardSetup.statuscheckpppoeuser.value)
 {
  document.getElementById("id_notpass").style.display = 'block';
 }
 else if('14' == document.form2WizardSetup.statuscheckpppoeuser.value)
 {
  document.getElementById("id_wanclass").className = 'image_02';
  document.getElementById("id_pass").style.display = 'block';
 }
 else
 {
  document.form2WizardSetup.statuscheckpppoeuser.value = "0";
 }
 var internetip = document.getElementById("id_internetip").innerText;
 if(internetip.indexOf("0.0.0.0") < 0 )
 {
  document.getElementById("id_wanclass").className = 'image_02';
  document.getElementById("id_wanclass_global").className = 'image_06';
 }
 else
 {
  document.getElementById("id_wanclass").className = 'image_04';
  document.getElementById("id_wanclass_global").className = 'image_05';
 }

}
</script>
</head>
<body onload="updateChan()">
<div class="wizard_step">
<table class="productInfo" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
    <tr>
  <td align="left" height="30" bgcolor="#404343" colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;产品页面:
            <script>
                document.write(ModemVer);
            </script>
        </td>
  <td align="right" height="30" bgcolor="#404343" colspan="2">硬件版本:
<script>
  document.write(HardwareVer);
</script>
&nbsp;&nbsp;&nbsp;&nbsp;固件版本:
            <script>
                document.write(FirmwareVer);
            </script>
            &nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
    </tbody>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="class_noframe">
    <tbody>
    <tr>
        <td align="left"><a href="http://www.dlink.com.cn/" target="_blank"><img src="../images/head_01.gif" border="0"></a></td>
        <td background="../images/head_02.gif" width="600"></td>
        <td align="right"><img src="../images/head_03.gif"></td>
    </tr>
    </tbody>
</table>
<div class="wizard_main">
    <h2>NET WORK <span>Map</span><img src="../images/line.jpg"/></h2>
 <form action="/goform/dir_setWanWifi" method=POST name="form2WizardSetup">
     <table class="setting_table_local">
         <tr>
             <td align="center" width="134" class="setting_client" height="30">用戶端</td>
    <td align="center" width="114"> </td>
             <td align="center" width="136">路由器</td>
    <td align="center" width="114"> </td>
             <td align="center" width="136">Internet</td>
         </tr>
     </table>
     <table class="setting_table_local">
         <tr>
             <td class="image_01"></td>
             <td class="image_02"></td>
             <td class="image_03"></td>
             <td id="id_wanclass" class="image_04"></td>
             <td id="id_wanclass_global" class="image_05"></td>
         </tr>
     </table>
     <table class="setting_table_local">
         <tr>
             <td class="setting_client" width="280" height="30">路由器IP
<% getLanIp(); %>
</td>
             <td id="id_internetip" width="300">Internet IP
			 <!-- 192.168.0.1 0.0.0.0 -->
<% getWanIp(); %>
</td>
             <td id="wantype">PPPOE</td>
         </tr>
     </table>
  <br>
     <table width="500" cellpadding="0" cellspacing="0" class="setting_table_local">
         <tr>
             <td class="setting_title">Internet设定</td>
         </tr>
         <tr>
             <td class="wizard_main">
                 <table width="490" border="0" align="center" class="space">
                     <tr>
                         <br>
                         <td width="105">
                             连线类型:
                         </td>
                         <td>
                             <select size="1" name="connecttype" onchange="updateChanX(this);" id="connect_select">
                                 <option value="PPPOE">PPPoE(使用者名称和密码)</option>
                                 <option value="DHCP">DHCP动态IP</option>
                                 <option value="STATIC">静态IP</option>
                             </select>
                         </td>
                     </tr>
                 </table>
                 <table width="490" border="0" align="center" class="space" id="connect_PPPoE" style="display:block">
                     <tr>
                         <td width="105">
                             使用者名称:
                         </td>
                         <td>
        <input type="text" name="show_pppoe_usrname" maxlength="64" size="25" value="">
		<input type="hidden" name="pppoe_usrname" maxlength="64" size="25">
                         </td>
                     </tr>
                     <tr>
                         <td>
						 	 密码:
                         </td>
                         <td>
        <input type="password" name="pppoe_psword" maxlength="64" size="25" value="">
                         </td>
                     </tr>
     </table>
     <table width="490" border="0" align="center" id="id_checkpppoeuser" >
      <tr style="display:none">
       <td>
        <script>
        document.writeln('<input type=\"text\" name=\"statuscheckpppoeuser\" maxlength=\"64\" size=\"25\" value=\"'+statuscheckpppoeuser+'\">');
        </script>
       </td>
      </tr>
      <tr>
       <td>
        <input type="button" name="checkpppoeuser" value="账号检测" onClick="return onClickCheckPppoeUser()">
       </td>
       <td id="id_noconnected" style="display:none">
        <p style="color:red">
		WAN口没有正确的连接，请确认WAN口已插上网络线，且路由器上的网络指示灯有亮起。
        </p>
       </td>
       <td id="id_noack" style="display:none">
        <p style="color:red">
		PPPoE服务器没有回应，请确认WAN口是否有连接到您的ISP的网络。
        </p>
       </td>
       <td id="id_notpass" style="display:none">
        <p style="color:red">
		账号或密码错误，请输入正确的Internet连线账号和密码，或联络您的ISP以确认资料。
        </p>
       </td>
       <td id="id_pass" style="display:none">
        <p style="color:red">
        有效的使用者名称和密码。
        </p>
       </td>
      </tr>
     </table>
                 <table width="500" cellspacing="0" cellpadding="0" border="0" align="center" id="connect_static" style="display:none;">
                     <tr>
                         <td colspan="2">
                             <table width="500" cellspacing="0" cellpadding="0" border="0">
                                 <tr>
                                     <td colspan="2">
                                         <table width="490" align="center" border="0" class="space">
                                             <tr>
                                                 <td width="105">
                                                     IP地址:
                                                 </td>
                                                 <td>
              <input type="text" name="staip_ipaddr" maxlength="15" size="16" value="
0.0.0.0">
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td>
                                                     子网掩码:
                                                 </td>
                                                 <td>
              <input type="text" name="staip_netmask" maxlength="15" size="16" value="
0.0.0.0">
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td>
                                                     网关:
                                                 </td>
                                                 <td>
              <input type="text" name="staip_gateway" maxlength="15" size="16" value="
0.0.0.0">
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td height="21">
                                                     主要DNS:
                                                 </td>
                                                 <td>
<input type="text" name="wan_dns1" size="15" maxlength="15" disabled="true" value="
0.0.0.0"> 
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td>
                                                     次要DNS:
                                                 </td>
                                                 <td>
<input type="text" name="wan_dns2" size="15" maxlength="15" disabled="true" value="
0.0.0.0"> 
&nbsp;(可选)
                                                 </td>
                                             </tr>
                                         </table>
                                         <br>
                                     </td>
                                 </tr>
                             </table>
                         </td>
                     </tr>
                 </table>
             </td>
         </tr>
     </table>
  <br>
  <table width="500" cellspacing="0" cellpadding="0" class="setting_table_local setting_bottom">
         <tr>
             <td class="setting_title">无线设定(2.4G)</td>
         </tr>
         <tr>
             <td class="wizard_main">
                 <br>
                 <table width="490" border="0" align="center" style="display:block" id="connect_PPPoE" class="space">
                     <tr>
                         <td width="105" id="basicSSID2">
                             无线网络名称:
                         </td>
                         <td>
                             <input type="text" maxlength="118" size="25" id="DIR_WIZ_BASIC_CFG_SSID"  tid="DIR_WIZ_BASIC_INPUT_CFG_SSID" name="wizardstep4_ssid_2" 
value="<% getCfgGeneral(1, "SSID1"); %>"
>
                         </td>
                     </tr>
                     <tr>
                         <td>
                             密码:
                         </td>
                         <td>
							<input type="hidden" maxlength="118" size="25" name="wizardstep4_pskpwd_2" id="DIR_WIZ_2G_BASIC_CFG_PWD"  tid="DIR_WIZ_2G_BASIC_INPUT_CFG_PWD" >
                             <input type="text" maxlength="118" size="25" name="tmp_wizardstep4_pskpwd_2" id="TMP_DIR_WIZ_2G_BASIC_CFG_PWD"  tid="TMP_DIR_WIZ_2G_BASIC_INPUT_CFG_PWD" >(WPA/WPA2-PSK AES)
                         </td>
                     </tr>
                     <tr>
                         <td><br></td>
                     </tr>
                 </table>
    </td>
   </tr>
  </table>
  <br>
  <table width="500" cellspacing="0" cellpadding="0" class="setting_table_local setting_bottom">
         <tr>
             <td class="setting_title">无线设定(5G)</td>
         </tr>
         <tr>
             <td class="wizard_main">
                 <br>
                 <table width="490" border="0" align="center" style="display:block" id="connect_PPPoE" class="space">
                     <tr>
                         <td width="105" id="basicSSID5">
                             无线网络名称:
                         </td>
                         <td>
                             <input type="text" maxlength="118" size="25" id="DIR_WIZ_5G_BASIC_CFG_SSID"  tid="DIR_WIZ_5G_BASIC_INPUT_CFG_SSID"  name="wizardstep4_ssid_5"
value="<% getCfg2ToHTML(1, "SSID1"); %>"
>
                         </td>
                     </tr>
                     <tr>
                         <td>
                             密码:
                         </td>
                         <td>
						 <input type="hidden" maxlength="118" size="25" name="wizardstep4_pskpwd_5"  id="DIR_WIZ_5G_BASIC_CFG_PWD"  tid="DIR_WIZ_5G_BASIC_INPUT_CFG_PWD" >
                             <input type="text" maxlength="118" size="25" name="tmp_wizardstep4_pskpwd_5"  id="TMP_DIR_WIZ_5G_BASIC_CFG_PWD"  tid="TMP_DIR_WIZ_5G_BASIC_INPUT_CFG_PWD" >(WPA/WPA2-PSK AES)
                         </td>
                     </tr>
                     <tr>
                         <td><br></td>
                     </tr>
                 </table>
    </td>
   </tr>
  </table>
  <table width="500" cellspacing="0" cellpadding="0" class="setting_table_save">
   <tr>
                <td width=25%></td>
    <td width=50%>
     <input type="button" name="save" value="存储设定" onClick="return saveChanges()">
    </td>
    <td width=25%><a href="d_wan.asp"><font size="3">进阶设定</font></a></td>
   </tr>
  </table>
  <input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
 </form>
</div>
<div class="copywright">
Copyright &copy; 2008-2017 D-Link Systems, Inc.
</div>
</div>
<script>
enableTextField(document.form2WizardSetup.wan_dns1);
enableTextField(document.form2WizardSetup.wan_dns2);
postload();
</script>
</body>
</html>
