<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
</head>
<body>
<blockquote>
<SCRIPT language="JavaScript">
var LoginUser = 'admin';
var wireless = '1';</SCRIPT>
<script language="JavaScript">
 TabHeader="帮助";
 SideItem="菜单";
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
  <td class=topheader>菜单帮助</td>
 </tr>
 <tr>
  <td class=content>
   <ul>
    <li><a href="d_helpmenu.asp#Setup">设置</a>
    <script>
    if(wireless=="1")
     document.writeln('<li><a href="d_helpmenu.asp#Wireless">无线</a>');
    if (LoginUser == "admin")
     document.writeln('<li><a href="d_helpmenu.asp#Advanced">高级</a>');
    </script>
    <li><a href="d_helpmenu.asp#Maintenance">维护</a>
    <li><a href="d_helpmenu.asp#Status">状态</a>
   </ul>
  </td>
 </tr>
</table><br>
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Setup>设置帮助</a></td>
 </tr>
 <tr>
  <td class=content>
   <ul>
    <script language="javascript">
    if(LoginUser == "admin"){
		document.writeln('<li><a href="d_helpsetup.asp#Wizard">Internet设置向导</a>');
	}
    </script>
    <li><a href="d_helpsetup.asp#LAN">局域网设置</a>
	<script language="javascript">
		if(!(("<% getCfgZero(1,"ApCliEnable");%>"==1)||("<% getCfg2Zero(1,"ApCliEnable");%>"==1))){
			document.writeln('<li><a href="d_helpsetup.asp#Internet">Internet 设置</a>');
		}
	</script>
   </ul>
  </td>
 </tr>
</table><br>

<div id="wirelessHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Wireless>无线帮助</a></td>
 </tr>
 <tr>
  <td class=content>
   <ul>

    <li><a href="d_helpwlan.asp#WlanBasic">无线基本设置</a>
    <script language="javascript">
    if (LoginUser == "admin"){

    document.writeln('<li><a href="d_helpwlan.asp#wlwps">WPS设置</a>');
    document.writeln('<li><a href="d_helpwlan.asp#wladv">无线高级设置</a>');
    document.writeln('<li><a href="d_helpwlan.asp#wlrepeater">无线中继</a>');
    }
    </script>
   </ul>
  </td>
 </tr>
</table><br>
</div>
<div id="advHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Advanced>高级帮助</a></td>
 </tr>
 <tr>
  <td class=content>
   <ul>
    <script language="javascript">
    if (LoginUser == "admin") {
                    document.writeln('<li><a href="d_helpadv.asp#Acl">访问控制</a>');
                    document.writeln('<li><a href="d_helpadv.asp#PortTriggering">端口触发</a>');
   document.writeln('<li><a href="d_helpadv.asp#DMZ">DMZ</a>');
                    document.writeln('<li><a href="d_helpadv.asp#Url">站点限制</a>');
                    document.writeln('<li><a href="d_helpadv.asp#DDNS">动态DNS</a>');
                    document.writeln('<li><a href="d_helpadv.asp#Netsniper">网络尖兵</a>');
                    document.writeln('<li><a href="d_helpadv.asp#IPQosTC">QoS设置</a>');
                    document.writeln('<li><a href="d_helpadv.asp#UPnP">UPnP</a>');
                    document.writeln('<li><a href="d_helpadv.asp#VirtualSrv">虚拟服务器</a>');
    }
    </script>
   </ul>
  </td>
 </tr>
</table><br>
</div>
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Maintenance>维护帮助</a></td>
 </tr>
 <tr>
  <td class=content>
   <ul>
    <li><a href="d_helpmain.asp#Reboot">重启</a>
    <script language="javascript">
    if (LoginUser == "admin") {
     document.writeln('<li><a href="d_helpmain.asp#Upload">固件升级</a>');
     document.writeln('<li><a href="d_helpmain.asp#Saveconf">备份设置</a>');
     document.writeln('<li><a href="d_helpmain.asp#Userconfig">用户帐户配置</a>');
     document.writeln('<li><a href="d_helpmain.asp#Time">时间与日期</a>');
    }
    </script>
   </ul>
  </td>
 </tr>
</table><br>
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Status>状态帮助</a></td>
 </tr>
 <tr>
  <td class=content>
   <ul>
    <li><a href="d_helpstatusinfo.asp#Status">设备信息</a>
    <li><a href="d_helpstatusinfo.asp#Dhcpclient">客户端列表</a>
    <li><a href="d_helpstatusinfo.asp#Stats">统计</a>
   </ul>
  </td>
 </tr>
</table>
<script language="javascript">
if(wireless == "1") {
 document.getElementById("wirelessHelp").style.display = 'block';
}
else {
 document.getElementById("wirelessHelp").style.display = 'none';
}
if (LoginUser == "admin"){
 document.getElementById("advHelp").style.display = 'block';
}else {
 document.getElementById("advHelp").style.display = 'none';
}
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

