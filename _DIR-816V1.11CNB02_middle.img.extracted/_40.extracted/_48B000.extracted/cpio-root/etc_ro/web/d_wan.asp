<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<title>Internet设置</title>
<SCRIPT>


var lanip="<% getLanIp(); %>";
var lanmask="<% getCfgGeneral(1, "lan_netmask"); %>";


function GetTimeAbs()
{
   var d;
   d = new Date();
   return Math.round(d.getTime()/1000)-d.getTimezoneOffset()*60;
}
function validateKey(str)
{
   for (var i=0; i<str.length; i++) {
    if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9'))
   continue;
 return 0;
  }
  return 1;
}


function validateIP(ip,msg)
{
 if (ip.value=="") {
  alert(msg+'不能为空. 必须为 xxx.xxx.xxx.xxx形式的数字串.');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }

 var str=ip.value;
 var count=0;
 for (var i=0; i<str.length; i++)
 {
  if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') )
   continue;
  if (str.charAt(i) == '.')
  {
   count++;
   continue;
  }
  alert(msg+'无效. 必须由数字(0-9)构成.');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if(count!=3)
 {
  alert(msg+'无效. 必须为 xxx.xxx.xxx.xxx形式的数字串.');
  ip.focus();
  return false;
 }

 if( IsLoopBackIP( ip.value)==1 ) {
  alert(msg+'无效.');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }

 if ( !checkDigitRange(ip.value,1,1,223) ) {
  alert(msg+'第一个数字段必须为 1-223.');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if ( !checkDigitRange(ip.value,2,0,255) ) {
  alert(msg+'第二个数字段必须为 0-255.');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if ( !checkDigitRange(ip.value,3,0,255) ) {
  alert(msg+'第三个数字段必须为 0-255.');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }
 if ( !checkDigitRange(ip.value,4,1,254) ) {
  alert(msg+'第四个数字段必须为 1-254.');
  ip.value = ip.defaultValue;
  ip.focus();
  return false;
 }

 return true;
}

function saveChanges()
{
 with(document.wan)
 {
  enableTextField(document.wan.mac_clone_value);

  if(wantype.value == 0)
  {

       if ( !validateIP(staip_ipaddr,"IP 地址"))
       {
         staip_ipaddr.focus();

          return false;
       }
       if (Lan1EqLan2(staip_ipaddr.value, lanmask, lanip, lanmask))
       {
         alert("WAN IP和LAN IP必须在不同的网段中!");
         staip_ipaddr.focus();
         return false;
       }
       if (staip_netmask.value != "")
       {
          if (!checkMask(staip_netmask))
          {

             staip_netmask.focus();
             return false;
          }
   d1 = getDigit(staip_netmask.value,1);
   d2 = getDigit(staip_netmask.value,2);
   d3 = getDigit(staip_netmask.value,3);
   d4 = getDigit(staip_netmask.value,4);
   if((d1 == 0) || (d4 == 254) || ((d1 == 255)&&(d2 == 255)&&(d3 == 255)&&(d4 == 255)))
   {
             alert('子网掩码无效!');
             staip_netmask.focus();
        return false;
   }
       }


  if ( !validateIP(staip_gateway,"默认路由地址"))
  {
   staip_gateway.focus();

           return false;
       }
	
	if (!Lan1EqLan2(staip_ipaddr.value, staip_netmask.value, staip_gateway.value, staip_netmask.value))
   {
    alert("Internet接口地址和网关地址必须在同一网络中!");
    staip_gateway.focus();
     return false;
   }
	
   if (staip_ipaddr.value == staip_gateway.value)
   {
    alert("Internet接口地址和网关地址必须不同!");
    staip_gateway.focus();
     return false;
   }

     if (staip_mtusize.value != "")
     {
      if ( validateKey(staip_mtusize.value) == 0 ) {
    alert("非法MTU值. 必须是数字.");
    staip_mtusize.focus();
    return false;
   }
      if (!checkDigitRange(staip_mtusize.value, 1, 616, 1500))
      {
       alert('MTU 取值无效!有效范围为616-1500.');
       staip_mtusize.focus();
       return false;
      }
     }
  }

  if(wantype.value == 1 || wantype.value == 7)
  {
   if(!checkSpecialChar(dhcpc_hostname.value,0))
   {
    alert('主机名称无效!');
    dhcpc_hostname.focus();
       return false;
   }
   if (dhcpc_mtusize.value != "")
      {
       if ( validateKey(dhcpc_mtusize.value) == 0 ) {
     alert("非法MTU值. 必须是数字.");
     dhcpc_mtusize.focus();
     return false;
    }
       if (!checkDigitRange(dhcpc_mtusize.value, 1, 616, 1500))
       {
        alert('MTU 取值无效!有效范围为616-1500.');
        dhcpc_mtusize.focus();
        return false;
       }
      }
  }

  if(wantype.value >= 2 && wantype.value <= 6)
  {
   if (show_pppoe_usrname.value=="")
   {
    alert('pppoe用户名不能为空!');
    show_pppoe_usrname.focus();
    return false;
   }
   if(!checkSpecialChar(show_pppoe_usrname.value,1))
   {
     alert("pppoe用户名中存在非法字符!");
     show_pppoe_usrname.focus();
     return false;
   }
   if (pppoe_psword.value=="")
   {
    alert('pppoe密码不能为空!');
    pppoe_psword.focus();
    return false;
   }
   if(!checkSpecialChar(pppoe_psword.value,1))
   {
    alert('pppoe密码中存在非法字符!');
    pppoe_psword.focus();
    return false;
   }
   if (pppoe_idletime.value != "")
      {
    if(validateKey(pppoe_idletime.value))
    {
        if (!checkDigitRange(pppoe_idletime.value, 1, 1, 1000) && (pppoe_contype.value == 1))
        {
         alert('空闲时间取值无效');
         pppoe_idletime.focus();
         return false;
        }
    }
    else
    {
        alert('空闲时间值非法. 必须是数字.');
        pppoe_idletime.focus();
        return false;
    }
      }

   if (pppoe_mtusize.value != "")
      {

    if(validateKey(pppoe_mtusize.value))
    {
        if (!checkDigitRange(pppoe_mtusize.value, 1, 616, 1492))
        {
         alert('MTU 取值无效!有效范围为616-1492.');
         pppoe_mtusize.focus();
         return false;
        }
       }
       else
       {
      alert("非法MTU值. 必须是数字.");
      pppoe_mtusize.focus();
      return false;
       }
      }
   if (pppoe_sername.value!="")
   {
    if(!checkSpecialChar(pppoe_sername.value,1))
    {
     alert('pppoe服务名中存在非法字符!');
     pppoe_sername.focus();
     return false;
    }
    if ( !confirm('请确认是否需要输入服务名称，如果输入的服务名称与服务器的不同，将导致拨号不成功！'))
    {
     pppoe_acname.focus();
     return false;
    }
   }

   if (pppoe_staticip.value!="")
   {
    if ( !validateIP(pppoe_staticip,"IP 地址"))
    {
           pppoe_staticip.focus();

     return false;
    }
        }

  }
  if( (wantype.value==0 || (wantype.value>0 && dns_ctrl[1].checked)) )
  {

   if ( !validateIP(wan_dns1,"DNS 1地址"))
   {
    wan_dns1.focus();
     return false;
   }
   if(wantype.value == 0 && wan_dns1.value == staip_ipaddr.value)
   {
    alert("DNS和Internet接口地址不能相同!");
    wan_dns1.focus();
     return false;
   }
   if (Lan1EqLan2(wan_dns1.value, lanmask, lanip, lanmask)) {
    alert("DNS和LAN IP必须在不同的网段中!");
    wan_dns1.focus();
     return false;
   }

   if(wan_dns2.value!="" && wan_dns2.value != "0.0.0.0") //
   {

    if ( !validateIP(wan_dns2,"DNS 2地址"))
    {
     wan_dns2.focus();
      return false;
    }
    if(wan_dns2.value == wan_dns1.value)
    {
     alert("DNS 2 和 DNS 1不能相同!");
     wan_dns2.focus();
      return false;
    }
    if(wantype.value == 0 && wan_dns2.value == staip_ipaddr.value)
    {
     alert("DNS和Internet接口地址不能相同!");
     wan_dns2.focus();
      return false;
    }
    if (Lan1EqLan2(wan_dns2.value, lanmask, lanip, lanmask)) {
     alert("DNS和LAN IP必须在不同的网段中!");
     wan_dns2.focus();
      return false;
    }
   }
	/*
   if(wan_dns3.value!="0.0.0.0")
   {

    if ( !validateIP(wan_dns3,"DNS 3地址"))
    {
     wan_dns3.focus();
      return false;
    }
    if(wan_dns3.value == wan_dns1.value)
    {
     alert("DNS 3 和 DNS 1不能相同!");
     wan_dns3.focus();
      return false;
    }
    if(wan_dns3.value == wan_dns2.value)
    {
     alert("DNS 3 和 DNS 2不能相同!");
     wan_dns3.focus();
      return false;
    }
    if(wantype.value == 0 && wan_dns3.value == staip_ipaddr.value)
    {
     alert("DNS和Internet接口地址不能相同!");
     wan_dns3.focus();
      return false;
    }
    if (Lan1EqLan2(wan_dns3.value, lanmask, lanip, lanmask)) {
     alert("DNS和LAN IP必须在不同的网段中!");
     wan_dns3.focus();
      return false;
    }
   }
   */
  }
 }
 wan_connection_type = document.wan.wantype.value;
 if(document.wan.mac_clone[2].checked)
 {
  if(!checkFormatUnicastMac(document.wan.mac_clone_value,1))
  {
   return false;
  }
 }
	if ( document.wan.show_pppoe_usrname.value != "")
	{
		document.wan.pppoe_usrname.value = Base64.Encode(document.wan.show_pppoe_usrname.value);
	}
	
	if ( document.wan.pppoe_psword.value != "" && document.wan.pppoe_psword.value != "********")
	{
		document.wan.pppoe_psword.value = Base64.Encode(document.wan.pppoe_psword.value);
	}
	
	document.wan.show_pppoe_usrname.disabled = true;
 create_backmask();
 document.getElementById("loading").style.display="";	
 return true;
}
function resetClick()
{
  disableAll();
  if (document.wan.wanconn_type.value==0)
  {
 displayStaticIp();
  }
  else if(document.wan.wanconn_type.value==1)
  {
 displayDhcpClient();
  }
  else if(document.wan.wanconn_type.value ==2)
  {
  if( Number(document.wan.pppoe_mtusize.value) > 1492)
	  document.wan.pppoe_mtusize.value = '1492';
 document.wan.localTimeAbs.value = GetTimeAbs();
 displayPppoe();
  }
  if(document.wan.mac_clone_display.value == 1)
  {
 enableRadioGroup(document.wan.mac_clone);
  }
  else
  {
 disableRadioGroup(document.wan.mac_clone);
 disableTextField(document.wan.mac_clone_value);
  }
  if (wmode != "STATIC")
  {
	disableTextField(document.wan.wan_dns1);
	disableTextField(document.wan.wan_dns2);
	disableRadioGroup(document.wan.wan_dns3);
  }
  var macclone = '<% getCfgGeneral(1, "macCloneEnabled"); %>';
  if(macclone == '0'){
  	document.wan.mac_clone[0].checked = true;
	disableTextField(document.wan.mac_clone_value);
  }else if(macclone == '1'){
  	document.wan.mac_clone[1].checked = true;  	
	disableTextField(document.wan.mac_clone_value);
  }else if(macclone == '2'){
  	document.wan.mac_clone[2].checked = true;  
	document.wan.mac_clone_value.disalbed = false;
  }
}
function idleTimeEnabled()
{
  document.getElementById('idletime_label').style.display = '';
  document.getElementById('idletime_text').style.display = '';
}
function idleTimeDisabled()
{
  document.getElementById('idletime_label').style.display = 'none';
  document.getElementById('idletime_text').style.display = 'none';
}
function staticIpEnabled()
{
  document.getElementById('staticIp_block').style.display = 'block';
}
function staticIpDisabled()
{
  document.getElementById('staticIp_block').style.display = 'none';
}
function dhcpClientEnabled()
{
  document.getElementById('dhcpClient_block').style.display = 'block';
}
function dhcpClientDisabled()
{
  document.getElementById('dhcpClient_block').style.display = 'none';
}
function pppoeEnabled()
{
  document.getElementById('pppoe_block').style.display = 'block';
}
function pppoeDisabled()
{
  document.getElementById('pppoe_block').style.display = 'none';
}
function dnsEnabled()
{
  document.getElementById('dns_block').style.display = 'block';
}
function dnsDisabled()
{
  document.getElementById('dns_block').style.display = 'none';
}
function dnsipEnabled()
{
  document.getElementById('dns_ip_block').style.display = 'block';
}
function dnsipDisabled()
{
  document.getElementById('dns_ip_block').style.display = 'none';
}
function maccloneEnabled()
{
  document.getElementById('macclone').style.display = 'block';
}
function maccloneDisabled()
{
  document.getElementById('macclone').style.display = 'none';
}
function dnsSelection()
{
 if (document.wan.dns_ctrl[0].checked)
 {
  disableTextField(document.wan.wan_dns1);
  disableTextField(document.wan.wan_dns2);
  disableTextField(document.wan.wan_dns3);
 }
 else
 {
  enableTextField(document.wan.wan_dns1);
  enableTextField(document.wan.wan_dns2);
  enableRadioGroup(document.wan.wan_dns3);
 }
}
function macSelection()
{
 if (document.wan.mac_clone[0].checked)
 {
  document.wan.mac_clone_value.value = document.wan.mac_default_value.value;
  disableTextField(document.wan.mac_clone_value);
 }
 else if (document.wan.mac_clone[1].checked)
 {
  document.wan.mac_clone_value.value = document.wan.mac_client_value.value;
  disableTextField(document.wan.mac_clone_value);
 }
 else if (document.wan.mac_clone[2].checked)
 {
  document.wan.mac_clone_value.value = document.wan.mac_manual_value.value;
  enableTextField(document.wan.mac_clone_value);
 }
}
function displayStaticIp(){
  enableTextField(document.wan.wan_dns1);
  enableTextField(document.wan.wan_dns2);
  enableTextField(document.wan.wan_dns3);
   staticIpEnabled();
   dnsipEnabled();
   maccloneEnabled();
}
function displayDhcpClient(){
 dnsSelection();
    dhcpClientEnabled();
   dnsEnabled();
   dnsipEnabled();
   maccloneEnabled();
   if(document.wan.wantype.value == 1)
   {
   document.getElementById('dhcpplus_username_label').style.display = 'none';
   document.getElementById('dhcpplus_username_text').style.display = 'none';
   document.getElementById('dhcpplus_password_label').style.display = 'none';
   document.getElementById('dhcpplus_password_text').style.display = 'none';
   }
 else if(document.wan.wantype.value == 7)
   {
   document.getElementById('dhcpplus_username_label').style.display = '';
   document.getElementById('dhcpplus_username_text').style.display = '';
   document.getElementById('dhcpplus_password_label').style.display = '';
   document.getElementById('dhcpplus_password_text').style.display = '';
   }
}
function displayPppoe(){
 dnsSelection();
   pppoeEnabled();
   dnsEnabled();
   dnsipEnabled();
   maccloneEnabled();
 if (document.wan.pppoe_contype.value == 0)
 {
  idleTimeDisabled();
 }
 else if(document.wan.pppoe_contype.value == 1)
 {
  idleTimeEnabled();
  enableTextField(document.wan.pppoe_idletime);
  if(document.wan.pppoe_idletime.value == "0")
  {
   document.wan.pppoe_idletime.value = "5";
  }
 }
 else if(document.wan.pppoe_contype.value == 2)
 {
  idleTimeDisabled();
 }
}
function pppoe_contypechang()
{
 with(document.wan)
 {
  if(pppoe_contype.value == 0)
  {
    //pppoe_cntbtn.disabled = true;
    //pppoe_discntbtn.disabled = true;
    idleTimeDisabled();
  }
  else if(pppoe_contype.value == 1)
  {
    //pppoe_cntbtn.disabled = true;
    //pppoe_discntbtn.disabled = true;
    idleTimeEnabled();
    enableTextField(pppoe_idletime);
    if(pppoe_idletime.value == "0")
    {
     pppoe_idletime.value = "5";
    }
  }
  else if(pppoe_contype.value == 2)
  {
    if(wanPPPoeConnection.value == 0) {
        //pppoe_cntbtn.disabled=false;
        //pppoe_discntbtn.disabled=true;
     }
    else {
        //pppoe_cntbtn.disabled=true;
        //pppoe_discntbtn.disabled=false;
     }
    idleTimeDisabled();
  }
 }
}

/* 
function pppoe_btn_Connect()
{
 with(document.wan)
 {
  pppoe_cntbtn.disabled = true;
  pppoe_discntbtn.disabled = false;
 }
}
function pppoe_btn_Disconnect()
{
 with(document.wan)
 {
  pppoe_cntbtn.disabled = false;
  pppoe_discntbtn.disabled = true;
 }
}
*/
function updateState()
{
}
function disableAll()
{
 staticIpDisabled();
 dhcpClientDisabled();
 pppoeDisabled();
 dnsDisabled();
 dnsipDisabled();
 maccloneDisabled();
}
function wantypechang()
{
 disableAll();
 if (document.wan.wantype.value==0)
 {
    displayStaticIp();
 }
 else if(document.wan.wantype.value==1 || document.wan.wantype.value==7)
 {
  displayDhcpClient();
 }
 else if(document.wan.wantype.value >=2 && document.wan.wantype.value <=6)
 {
  if( Number(document.wan.pppoe_mtusize.value) > 1492)
	  document.wan.pppoe_mtusize.value = '1492';
  document.wan.localTimeAbs.value = GetTimeAbs();
  displayPppoe();
 }
}
var wjson = {
0	:	["STATIC", 	"<#Wan_Body_3#>"],
1	:	["DHCP", 	"<#Wan_Body_2#>"],
2	:	["PPPOE", 	"<#Wan_Body_4#>"]
};

var wmode = "<% getCfgGeneral(1, "wanConnectionMode"); %>";
var wdns = "<% getCfgGeneral(1, "wan_dhcp_autodns"); %>";
var pppoe_mode = "<% getCfgGeneral(1, "wan_pppoe_opmode"); %>";

function initValue()
{
	var wmtu = "<% getCfgGeneral(1, "wan_mtu"); %>";
	var whostname = "<% getCfgGeneral(1, "wan_dhcp_hn"); %>";
	var wdns; 
	if ( "<% getCfgGeneral(1, "wan_pppoe_user_encode"); %>" != "")
	{
		document.wan.show_pppoe_usrname.value = Base64.Decode("<% getCfgGeneral(1, "wan_pppoe_user_encode"); %>");
	}	
	
	if (wmode == "STATIC")
	{
		document.wan.staip_mtusize.value = wmtu;
		document.wan.wan_dns1.value = "<% getCfgGeneral(1, "wan_primary_dns"); %>";
		document.wan.wan_dns2.value = "<% getCfgGeneral(1, "wan_secondary_dns"); %>";
		
	}
	else if (wmode == "DHCP")
	{
		document.wan.dhcpc_mtusize.value = wmtu;
		document.wan.dhcpc_hostname.value = whostname;
		wdns = "<% getCfgGeneral(1, "wan_dhcp_autodns"); %>";
		if(wdns == "1")//enable
		{
			document.wan.dns_ctrl[0].checked = true;
			document.wan.dns_ctrl[1].checked = false;
		}
		else//disable
		{
			document.wan.dns_ctrl[0].checked = false;
			document.wan.dns_ctrl[1].checked = true;
			document.wan.wan_dns1.value = "<% getCfgGeneral(1, "wan_dhcp_primary_dns"); %>";
			document.wan.wan_dns2.value = "<% getCfgGeneral(1, "wan_dhcp_secondary_dns"); %>";
		}

		dnsSelection();
	}
	else if (wmode == "PPPOE")
	{
		document.wan.pppoe_mtusize.value = wmtu;		
		wdns = "<% getCfgGeneral(1, "wan_pppoe_autodns"); %>";
		if(wdns == "1")//enable
		{
			document.wan.dns_ctrl[0].checked = true;
			document.wan.dns_ctrl[1].checked = false;
		}
		else//disable
		{
			document.wan.dns_ctrl[0].checked = false;
			document.wan.dns_ctrl[1].checked = true;
			document.wan.wan_dns1.value = "<% getCfgGeneral(1, "wan_pppoe_primary_dns"); %>";
			document.wan.wan_dns2.value = "<% getCfgGeneral(1, "wan_pppoe_secondary_dns"); %>";
		}
		dnsSelection();
	}

	if (document.wan.wan_dns2.value == "")	
	{
		document.wan.wan_dns2.value = "0.0.0.0";
	}

	
	document.wan.wanspeed.value = "<% getCfgGeneral(1, "wan_speed"); %>";

	macSelection();
	
}
</SCRIPT>

</head>
<body onload="initValue();">
<blockquote>
<script language="JavaScript">
 TabHeader="设置";
 SideItem="Internet设置";
 HelpItem="wanif";
</script>
<script type='text/javascript'>
 mainTableStart();
 logo();
 TopNav();
 ThirdRowStart();
 Write_Item_Images();
 mainBodyStart();
</script>
<table id="box_header" border=0 cellSpacing=0>
 <tr>
  <td class="topheader">Internet设置</td>
 </tr>
 <tr>
  <td class="content">
   <p>您可以配置Internet端口的参数,可以修改上网模式为:静态IP,DHCP或者PPPoE方式.</p>
  </td>
 </tr>
</table>
<form method=POST Action="/goform/form2Wan.cgi" name="wan">
<table id="body_header" border="0" cellSpacing="0">
 <tr>
  <td class="topheader">Internet接口</td>
 </tr>
 <tr>
  <td class="content" align="left">
   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
<INPUT TYPE="hidden" NAME="wanPPPoeConnection" VALUE="0"> 
    <tr>
     <td class="form_label_left">Internet接入方式:</td>
     <td style="display:none;">
     <input type="text" name="localTimeAbs" size="12" maxlength="12" value="">
                    </td>
<script language="javascript">
for (var i in wjson)
{
	if( wmode == wjson[i][0] )
		dw('<input type="hidden" name="wanconn_type" value="' + i + '">');
}
</script>
     
     <td class="form_label_right">
      <select size="1" name="wantype" onChange="wantypechang()">
<script language="javascript">

for (var i in wjson)
{
	if(wjson[i][0] == wmode )
		dw('<OPTION VALUE=\"' + i + '\" SELECTED>' + wjson[i][1] + '</OPTION>');
	else
		dw('<OPTION VALUE=\"' + i + '\" >' + wjson[i][1] + '</OPTION>');		
}
//<OPTION VALUE="0" SELECTED> 静态IP</OPTION>
//<OPTION VALUE="1" > DHCP客户端</OPTION>
//<OPTION VALUE="2" > PPPoE</OPTION>
</script>
      </select>
                    </td>
    </tr>
   </table>
   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500" id="staticIp_block" style="display:block">
    <tr>
     <td class="form_label_left">IP 地址:</td>
     <td class="form_label_right">
      <input type="text" name="staip_ipaddr" size="15" maxlength="15" value="<% getWanIp(); %>">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left">子网掩码:</td>
     <td class="form_label_right">
      <input type="text" name="staip_netmask" size="15" maxlength="15" value="<% getWanNetmask(); %>">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left">默认路由:</td>
     <td class="form_label_right">
      <input type="text" name="staip_gateway" size="15" maxlength="15" value="<% getWanGateway(); %>">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left">MTU :</td>
     <td class="form_label_right">
      <input type="text" name="staip_mtusize" size="6" maxlength="6" value="1500">
                    </td>
    </tr>
   </table>
   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500" id="dhcpClient_block" style="display:block">
    <tr>
     <td class="form_label_left" id="dhcpplus_username_label" style="display:none;">用户名:</td>
     <td class="form_label_right" id="dhcpplus_username_text" style="display:none;">
      <input type="text" name="dhcpplus_username" size="31" maxlength="31" value="">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left" id="dhcpplus_password_label" style="display:none;">密码:</td>
     <td class="form_label_right" id="dhcpplus_password_text" style="display:none;">
      <input type="password" name="dhcpplus_password" size="18" maxlength="18" value="">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left">主机名称:</td>
     <td class="form_label_right">
     <input type="text" name="dhcpc_hostname" size="15" maxlength="15" value="<% getCfgGeneral(1, "wan_dhcp_hn"); %>">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left">MTU:</td>
     <td class="form_label_right">
     <input type="text" name="dhcpc_mtusize" size="6" maxlength="6" value="1500">
                    </td>
    </tr>
   </table>
   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500" id="pppoe_block" style="display:block">
    <tr>
     <td class="form_label_left">用户名:</td>
     <td class="form_label_right">
      <input type="text" name="show_pppoe_usrname" size="32" maxlength="64" value="">
	  <input type="hidden" name="pppoe_usrname" size="32" maxlength="64" value="">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left">密码:</td>
     <td class="form_label_right">
      <input type="password" name="pppoe_psword" size="32" maxlength="256" value="<% getPPPoePass(); %>">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left">服务名称:</td>
     <td class="form_label_right">
      <input type="text" name="pppoe_sername" size="32" maxlength="32" value="<% getCfgGeneral(1, "wan_pppoe_srvname"); %>">(可选。需与拨号服务器参数设置一致或者为空。)
                    </td>
    </tr>
    <tr style="display:none">
     <td class="form_label_left">AC 名称:</td>
     <td class="form_label_right">
      <input type="text" name="pppoe_acname" size="15" maxlength="15" value="">
                    </td>
    </tr>
    <tr>
     <td class="form_label_left" id="idletime_label" style="display:none;">空闲时间:</td>
     <td class="form_label_right" id="idletime_text" style="display:none;">
<input type="text" name="pppoe_idletime" size="6" maxlength="6" value="<% getCfgGeneral(1, "wan_pppoe_optime"); %>"> (1-1000 分钟)</td> 
                   </td>
    </tr>
    <tr>
     <td class="form_label_left">MTU:</td>
     <td class="form_label_right">
      <input type="text" name="pppoe_mtusize" size="6" maxlength="6" value="1492">
                   </td>
    </tr>
    <tr style="display:none">
     <td class="form_label_left">静态IP地址:</td>
     <td class="form_label_right">
      <input type="text" name="pppoe_staticip" size="15" maxlength="15" value="">
                   </td>
    </tr>
    <tr>
     <td class="form_label_left">连接类型:</td>
     <td class="form_label_right">
      <select name="pppoe_contype" onChange="pppoe_contypechang()">
<option value="0"  >连续的</option>
<option value="1" selected>需要时连接</option>
<!--<option value="2" >手动</option>-->
      </select>&nbsp;&nbsp;&nbsp;&nbsp;
<!--
	  <input type="submit" value="连接" name="pppoe_cntbtn" disabled="true" >&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit" value="断开" name="pppoe_discntbtn" disabled="true">
-->
<script language="javascript">
	if( pppoe_mode == "KeepAlive" )
		document.wan.pppoe_contype.value = 0;
	else
		document.wan.pppoe_contype.value = 1;
</script>

     </td>
    </tr>
   </table>
   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500" id="dns_block" style="display:block">
    <tr>
     <td class="form_label_left">自动获取DNS服务器:</td>
     <td class="form_label_right">
		<input type="radio" name="dns_ctrl" value="0"  checked onClick="dnsSelection()">
	 <script language="javascript">
	/*
	 if( wdns == '1' )
		dw('<input type="radio" name="dns_ctrl" value="0" checked onClick="dnsSelection()">');
	else
		dw('<input type="radio" name="dns_ctrl" value="0" onClick="dnsSelection()">');
	*/
		</script>
     </td>
     <td class="form_label_right">(修改DNS配置后需要您手动修复PC的网络连接.)</td>
    </tr>
    <tr>
     <td class="form_label_left">手动配置DNS服务器:</td>
     <td class="form_label_right">
		<input type="radio" name="dns_ctrl" value="1" onClick="dnsSelection()">
	 <script language="javascript">
	/*
	if( wdns == '0' )
		dw('<input type="radio" name="dns_ctrl" value="1" checked onClick="dnsSelection()">');
	else
		dw('<input type="radio" name="dns_ctrl" value="1" onClick="dnsSelection()">');
	*/
		</script>
     </td>
    </tr>
   </table>
   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500" id="dns_ip_block" style="display:block">
    <tr>
     <td class="form_label_left">DNS服务器1:</td>
     <td class="form_label_right">
<input type="text" name="wan_dns1" size="15" maxlength="15" value=""> 
     </td>
    </tr>
    <tr>
     <td class="form_label_left">DNS服务器2:</td>
     <td class="form_label_right">
<input type="text" name="wan_dns2" size="15" maxlength="15" value=""> 
      &nbsp;(可选)
     </td>
    </tr>
    <tr style="display:none">
     <td class="form_label_left">DNS服务器3:</td>
     <td class="form_label_right">
<input type="text" name="wan_dns3" size="15" maxlength="15" value=0.0.0.0> 
     </td>
    </tr>
   </table>
  </td>
 </tr>
</table>
<div id="wanspeed" style="display:block">

<table id="body_header" border="0" cellSpacing="0">

 <tr>

  <td class="topheader">WAN端口速率</td>

 </tr>

 <tr>

  <td class="content" align="left">

   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">

    <tr>

     <td class="form_label_left">WAN端口速率:</td>

     <td class="form_label_right">

      <select size="1" name="wanspeed">

<OPTION VALUE="1" > 10Mbps</OPTION>
<OPTION VALUE="2" > 100Mbps</OPTION>
<OPTION VALUE="0" SELECTED> 10/100Mbps</OPTION>

      </select>

                    </td>

    </tr>

   </table>

  </td>

 </tr>

</table>

</div>
<div id="macclone" style="display:block">
<table id="body_header" border="0" cellSpacing="0">
 <tr>
  <td class="topheader">MAC地址克隆</td>
 </tr>
 <tr>
  <td class="content" align="left">
   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
    <tr>
     <td class="form_label_left">使用缺省MAC地址</td>
     <td class="form_label_right">
<input type="radio" name="mac_clone" value="0" checked onClick="macSelection()">
     </td>
    </tr>
    <tr>
     <td class="form_label_left">使用计算机MAC地址</td>
     <td class="form_label_right">
<input type="radio" name="mac_clone" value="1" onClick="macSelection()">
     </td>
    </tr>
    <tr>
     <td class="form_label_left">手动指定MAC地址</td>
     <td class="form_label_right">
<input type="radio" name="mac_clone" value="2" onClick="macSelection()">
     </td>
    </tr>
   </table>
   <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
    <tr>
     <td class="form_label_left"></td>
     <td class="form_label_right">
<input disabled="disabled" type="text" name="mac_clone_value" size="18" maxlength="17" value="<% getCfgGeneral(1, "macCloneMac"); %>"> 
     </td>
    </tr>
    <tr>
     <td style="display:none;">
<input type="text" name="mac_manual_value" size="18" maxlength="17" value="<% getCfgGeneral(1, "macCloneMac"); %>">
     </td>

	<td style="display:none;">
<input type="text" name="mac_default_value" size="18" maxlength="17" value="<% getCfgGeneral(1, "WAN_MAC_ADDR"); %>">
     </td>
     <td style="display:none;">
<input type="text" name="mac_client_value" size="18" maxlength="17" value="<% d_getPCMac(); %>">
<input type="hidden" name="mac_clone_display" value="1">
     </td>
    </tr>
   </table>
  </td>
 </tr>
</table>
</div>
<br>
<p align=center>
<input type="submit" value="应用" name="save" onClick="return saveChanges()">&nbsp;&nbsp;
<input type="reset" value="取消" name="reset" onClick="resetClick()">

</p>
<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
 </form>
<script type="text/javascript">
   resetClick();
</script>
<script type='text/javascript'>
 mainBodyEnd();
 ThirdRowEnd();
 Footer()
 mainTableEnd()
</script>
</blockquote>
</body>
</html>

