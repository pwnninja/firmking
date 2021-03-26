<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<meta http-equiv="refresh" content="60;url=d_status.asp">
<title>设备信息</title>
<script>
function modifyClick(url)
{
 var wide=600;
 var high=400;
 if (document.all)
  var xMax = screen.width, yMax = screen.height;
 else if (document.layers)
  var xMax = window.outerWidth, yMax = window.outerHeight;
 else
    var xMax = 640, yMax=480;
 var xOffset = (xMax - wide)/2;
 var yOffset = (yMax - high)/3;

 var settings = 'width='+wide+',height='+high+',screenX='+xOffset+',screenY='+yOffset+',top='+yOffset+',left='+xOffset+', resizable=yes, toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes';

 window.open( url, 'Status_Modify', settings );
}

function submitPPPoe(form,pppoenum,connect)
{
 form.pppoenum.value = pppoenum;
 form.connect.value = connect;
 form.submit();
}
function srefresh()
{
	document.location.href='d_status.asp';
}

var wjson = {
0	:	["STATIC", 	"<#Wan_Body_3#>"],
1	:	["DHCP", 	"<#Wan_Body_2#>"],
2	:	["PPPOE", 	"<#Wan_Body_4#>"]
};
var conntype = "";
var wmode = "<% getCfgGeneral(1, "wanConnectionMode"); %>";
var ppoeStatus=<% getPppoeStatus(); %>;
var pppoeMode='<% getCfgGeneral(1, "wan_pppoe_opmode"); %>';

for (var i in wjson)
{
	if( wmode == wjson[i][0] )
		conntype = wjson[i][1];
}

</script>
</head>
<body>
<blockquote>
<script language="JavaScript">
 TabHeader="状态";
 SideItem="设备信息";
 HelpItem="deviceinfo";
</script>
<script type='text/javascript'>
 mainTableStart();
 logo();
 TopNav();
 ThirdRowStart();
 Write_Item_Images();
 mainBodyStart();
</script>

<table id=box_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>设备信息</td>
 </tr>
 <tr>
  <td class=content>
   <p>本页面显示设备的当前状态和一些基本设置。</p>
  </td>
 </tr>
</table>
<br>

<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>系统</td>
 </tr>

 <tr>
  <td class=content>

  <table class=formlisting border=0>
    <tr class=form_label_row>
    <td class='form_label_col' width=50%>产品名称</td>
    <td class='form_label_col'>
<% getCfgGeneral(1, "ModeName"); %>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>上电时间</td>
    <td class='form_label_col'>
<script language="javascript">
	var stime = "<% getSysUptime(); %>";
	var patt2 = new RegExp("^([0-9]{1,2}) days, ([0-9]{1,2}):([0-9]{1,2}):([0-9]{1,2})$","g");//(alert[^;]*)
	var result,flag = 0;
	while( (result = patt2.exec( stime )) != null )
	{
		dw( result[1] + ' 天 , ' + result[2] + ':' + result[3] + ':' + result[4]  );
		flag = 1;
	}
	if( flag == 0)
	{
		dw( stime );
	}
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>日期/时间</td>
    <td class='form_label_col'>
<script language="javascript">
var Week  = [
[ "Monday"		,	"<#Monday#>"],
[ "Tuesday"		,	"<#Tuesday#>"],
[ "Wednesday"	,	"<#Wednesday#>"],
[ "Thursday"	,	"<#Thursday#>"],
[ "Friday"		,	"<#Friday#>"],
[ "Saturday"	,	"<#Saturday#>"],
[ "Sunday"		,	"<#Sunday#>"]
];
	var ctime = "<% d_getCurrentTimeASP(); %>";
	var patt3 = new RegExp("^([0-9]{1,5})-([0-9]{1,2})-([0-9]{1,2}) ([0-9]{1,5}):([0-9]{1,5}):([0-9]{1,5}) , ([A-Za-z0-9_]+)","g");
	var cresult, ctmp, cweek='', cflag = 0;//	2014-05-21 18:33:52
	while( (cresult = patt3.exec( ctime )) != null )
	{
		ctmp = cresult[1] + '年 ' + cresult[2] + '月 ' + cresult[3] + '日 ' + cresult[4] + '时 ' + cresult[5] + '分 ' +  cresult[6] + '秒 ' ;
		for(var i = 0 ; i < Week.length; i++)
		{
			if( Week[i][0] == cresult[7])
			{
				cweek = Week[i][1];
			}
		}
		dw( ctmp + ', ' + cweek);
		cflag = 1;
	}
	if( cflag == 0)
	{
		dw( ctime );
	}
</script>
</td>
    </tr>


  </table>
  </td>
  </tr>
</table>

<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>局域网配置</td>
 </tr>

 <tr>
  <td class=content>

  <table class=formlisting border=0>
    <tr class=form_label_row>
    <td class='form_label_col' width=50%>IP 地址</td>
    <td class='form_label_col'>
<% getLanIp(); %>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>子网掩码</td>
    <td class='form_label_col'>
<% getCfgGeneral(1, "lan_netmask"); %>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>DHCP 服务器</td>
    <td class='form_label_col'>
<script language="javascript">
	var dhcpEnabled = "<% getCfgGeneral(1, "dhcpEnabled"); %>";
	if( dhcpEnabled == '1'){
		dw( "<#Enable#>" );		
	}else{
		dw( "<#Disable#>" );		
	}
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>MAC 地址</td>
    <td class='form_label_col'>
<% getLanMac(); %>
</td>
    </tr>

  </table>
  </td>
  </tr>
</table>

<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>2.4G无线配置</td>
 </tr>

 <tr>
  <td class=content>

  <table class=formlisting border=0>
    <tr class=form_label_row>
    <td class='form_label_col' width=50%>2.4G无线网络</td>
    <td class='form_label_col'>
<script language="javascript">
	var radio_off = '<% getCfgZero(1, "RadioOff"); %>';
	if(radio_off == '1')
		dw( "<#Disable#>" );
	else
		dw( "<#Enable#>" );
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>模式</td>
    <td class='form_label_col'>
<script language="javascript">

var wirelessmode = "<% getCfgGeneral(1, "WirelessMode"); %>";
var mode_w = "802.11 ";
switch(wirelessmode)
{
 case "0":
 	dw( mode_w + "b/g"); break;
 case "1":
 	dw( mode_w + "b");  break;
 case "4":
 	dw( mode_w + "g");  break;
 case "6":
 	dw( mode_w + "n");  break;
 case "7":
 	dw( mode_w + "n/g");  break;
 case "9":
 	dw( mode_w + "b/g/n"); break;
}
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>SSID</td>
    <td class='form_label_col'>
<% getCfgToHTML(1, "SSID1"); %>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>加密模式</td>
    <td class='form_label_col'>
<script language="javascript">
	var authmode = '<% getCfgGeneral(1, "AuthMode"); %>';
	if (authmode == "OPEN")
	{
		dw( "NONE" );
	}
	else if (authmode == "SHARED")
	{
		dw( "WEP" );
	}
	else if (authmode == "WEPAUTO")
	{
		dw( "WEP" );
	}
	else if (authmode == "WPAPSK")
	{
		dw( "WPA-PSK(TKIP)" );
	}
	else if (authmode == "WPA2PSK")
	{
		dw( "WPA2-PSK(AES)" );
	}
	else if (authmode == "WPAPSKWPA2PSK")
	{
		dw( "WPA-PSK/WPA2-PSK AES" );
	}
</script>	
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>信道</td>
    <td class='form_label_col'>
<% getStatusWlanChannel(); %>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>广播SSID</td>
    <td class='form_label_col'>
<script language="javascript">
	var HideSSID = '<% getCfgZero(1, "HideSSID"); %>';
	if(HideSSID == '1')
		dw( "<#Disable#>" );
	else
		dw( "<#Enable#>" );
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>WPS</td>
    <td class='form_label_col'>
<script language="javascript">
var wpsenable = <% getWPSModeASP(); %>;
	if(wpsenable == '0')
		dw( "<#Disable#>" );
	else
		dw( "<#Enable#>" );
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>中继状态</td>
    <td class='form_label_col'>
<script language="javascript">
var connectStatus = "<% GetConnectStatus(); %>";
	if(connectStatus == '0')
		dw( "<#Disconnect#>" );
	else
		dw( "<#Connect#>" );
</script>

  </td>
    </tr>
    <tr class=form_label_row>
    <td class='form_label_col' width=50%>MAC 地址</td>
    <td class='form_label_col'>
<% getWlanCurrentMac(); %>
</td>
    </tr>

  </table>
  </td>
  </tr>
</table>

<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>5G无线配置</td>
 </tr>

 <tr>
  <td class=content>

  <table class=formlisting border=0>
    <tr class=form_label_row>
    <td class='form_label_col' width=50%>5G无线网络</td>
    <td class='form_label_col'>
<script language="javascript">
	var radio_off_5g = '<% getCfg2Zero(1, "RadioOff"); %>';
	if(radio_off_5g == '1')
		dw( "<#Disable#>" );
	else
		dw( "<#Enable#>" );
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>模式</td>
    <td class='form_label_col'>
<script language="javascript">

var wirelessmode_5g = "<% getCfg2General(1, "WirelessMode"); %>";
//var mode_w = "802.11 ";
switch(wirelessmode_5g)
{
 case "2":
 	dw( mode_w + "a"); break;
 case "8":
 	dw( mode_w + "a/n");  break;
 case "11":
 	dw( mode_w + "n");  break;
 case "14":
 	dw( mode_w + "a/n/ac"); break;
 case "15":
 	dw( mode_w + "n/ac"); break;
}
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>SSID</td>
    <td class='form_label_col'>
<% getCfg2ToHTML(1, "SSID1"); %>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>加密模式</td>
    <td class='form_label_col'>
<script language="javascript">
	var authmode_5g = '<% getCfg2General(1, "AuthMode"); %>';
	if (authmode_5g == "OPEN")
	{
		dw( "NONE" );
	}
	else if (authmode_5g == "SHARED")
	{
		dw( "WEP" );
	}
	else if (authmode_5g == "WEPAUTO")
	{
		dw( "WEP" );
	}
	else if (authmode_5g == "WPAPSK")
	{
		dw( "WPA-PSK(TKIP)" );
	}
	else if (authmode_5g == "WPA2PSK")
	{
		dw( "WPA2-PSK(AES)" );
	}
	else if (authmode_5g == "WPAPSKWPA2PSK")
	{
		dw( "WPA-PSK/WPA2-PSK AES" );
	}
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>信道</td>
    <td class='form_label_col'>
<% getStatusInicChannel(); %>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>广播SSID</td>
    <td class='form_label_col'>
<script language="javascript">
	var HideSSID_5g = '<% getCfg2Zero(1, "HideSSID"); %>';
	if(HideSSID_5g == '1')
		dw( "<#Disable#>" );
	else
		dw( "<#Enable#>" );
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>WPS</td>
    <td class='form_label_col'>
<script language="javascript">
var wpsenable_5g = <% getCfg2Zero(1, "WscModeOption"); %>;
	if(wpsenable_5g == '0')
		dw( "<#Disable#>" );
	else
		dw( "<#Enable#>" );
</script>
</td>
    </tr>

    <tr class=form_label_row>
    <td class='form_label_col' width=50%>中继状态</td>
    <td class='form_label_col'>
<script language="javascript">
var connectStatus_5g = "<% GetConnectStatus_5g(); %>";
	if(connectStatus_5g == '0')
		dw( "<#Disconnect#>" );
	else
		dw( "<#Connect#>" );
</script>

  </td>
    </tr>
    <tr class=form_label_row>
    <td class='form_label_col' width=50%>MAC 地址</td>
    <td class='form_label_col'>
<% getInicCurrentMac(); %>
</td>
    </tr>

  </table>
  </td>
  </tr>
</table>

<table id=body_header border=0 cellSpacing=0 style="display:none">
 <tr>
  <td class=topheader>DNS 状态</td>
 </tr>

 <tr>
  <td class=content>

    <table class=formlisting border=0>
      <tr class=form_label_row>
      <td class='form_label_col' width=50%>DNS 模式</td>
      <td class='form_label_col'>
自动      </td>
      </tr>

      <tr class=form_label_row>
      <td class='form_label_col' width=50%>DNS 服务器</td>
      <td class='form_label_col'>&nbsp;
      </td>
      </tr>

    </table>
  </td>
  </tr>
</table>

<form action="/goform/form2WebRefresh.cgi" method=POST name="status">
<script>
	if(!(("<% getCfgZero(1,"ApCliEnable");%>"==1)||("<% getCfg2Zero(1,"ApCliEnable");%>"==1))){
		document.writeln("<table id=body_header border=0 cellSpacing=0>");
	}else{
		document.writeln("<table id=body_header border=0 cellSpacing=0 style=\"display:none;\">");
	}
</script>
 <tr>
  <td class=topheader>Internet设置</td>
 </tr>

 <tr>
  <td class=content>
   <table class=formlisting border=0>
    <INPUT TYPE="HIDDEN" NAME="pppoenum" VALUE="" >
    <tr class=form_label_row>
     <td class='form_label_col'>接口</td>
     <td class='form_label_col'>协议</td>
     <td class='form_label_col'>IP 地址</td>
	 <td class="form_label_col">MAC 地址</td>
     <td class='form_label_col'>网关</td>
     <td class='form_label_col'>域名服务器</td>
     <td class='form_label_col'>状态</td>
    </tr>

<TR>
<TD align=center bgcolor="#C0C0C0"><b>WAN</b></TD>
<TD align=center bgcolor="#C0C0C0"><b>
<script language="javascript">
	dw( conntype );
</script>
</b></TD>
<TD align=center bgcolor="#C0C0C0"><b>
<script language="javascript">

     var wanip="<% getWanIp(); %>";
	 //alert("wanip="+wanip);
	 //alert(" wanip: ppoeStatus="+ppoeStatus+",pppoeMode="+pppoeMode+",conntype="+conntype);
	 if((conntype=="PPPoE")&&(pppoeMode!="KeepAlive")&& (ppoeStatus=='0'))
	 {
	    dw("0.0.0.0");
	 }
	 else
	 {
	   dw( wanip );
	 }

</script>

</b>
</TD>
<TD align=center bgcolor="#C0C0C0"><b><% getWanMac(); %></b></TD>
<TD align=center bgcolor="#C0C0C0"><b>

<script language="javascript">
     var wangateway="<% getWanGateway(); %>";
	 //alert(" gateway: ppoeStatus="+ppoeStatus+",pppoeMode="+pppoeMode+",conntype="+conntype);
	 if((conntype=="PPPoE")&&(pppoeMode!="KeepAlive")&& (ppoeStatus=='0'))
	 {
	    dw("0.0.0.0");
	 }
	 else
	 {
	  dw( wangateway );
	 }
</script>

</b>
</TD>
<TD align=center bgcolor="#C0C0C0"><b>
<script language="javascript">
if ("<% getWanIp(); %>" != "0.0.0.0")
{
	if ( "<% getDns(1); %>" == "<% getDns(2); %>" || "0.0.0.0" == "<% getDns(2); %>")
	{
		dw("<% getDns(1); %>");	
	}
	else
	{
		dw("<% getDns(1); %>" + "<br>" +  "<% getDns(2); %>");
	}
}
else
{
	dw("0.0.0.0")
}
</script>
</b></TD>
<TD align=center bgcolor="#C0C0C0"><b>
<script language="javascript">

var portStatus = "<% getPortStatus(); %>";

  		var wanPort = new Array();
		wanPort = portStatus.split(",");
		//alert("status: ppoeStatus="+ppoeStatus+",pppoeMode="+pppoeMode+",wanPort[0]="+wanPort[0]);
		if(wanPort[0] == "1" && "<% getWanIp(); %>" != "0.0.0.0")
		{
		      dw("<#Connect#>(" + conntype + ")");  
		}
		else
		{
			dw("<#Disconnect#>(" + conntype + ")");
		}
</script>
</b></TD>
</TR>
</TABLE>
  </td>
 </tr>
</table>

<input type="hidden" name="submit.asp?d_status.asp" value="Send">
<p align=center>
<input type="button" value="刷新" name="refresh" onClick="srefresh();">
</p>
<br>
<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
</form>

<script type='text/javascript'>
 mainBodyEnd();
 ThirdRowEnd();
 Footer()
 mainTableEnd()
</script>
</blockquote>

</body>

</html>

