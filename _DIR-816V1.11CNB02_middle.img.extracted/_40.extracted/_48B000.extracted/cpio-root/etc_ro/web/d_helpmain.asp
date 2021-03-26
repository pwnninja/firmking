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
</SCRIPT>
<script language="JavaScript">
 TabHeader="帮助";
 SideItem="维护";
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
  <td class=topheader>维护帮助</td>
 </tr>
 <tr>
  <td class=content>
   <ul>
    <li><a href="d_helpmain.asp#Reboot">重启/恢复</a>
    <script language="javascript">
    if (LoginUser == "admin")
    {
     document.writeln('<li><a href="d_helpmain.asp#Upload">固件升级</a>');
     document.writeln('<li><a href="d_helpmain.asp#Saveconf">备份设置</a>');
     document.writeln('<li><a href="d_helpmain.asp#Userconfig">用户帐户配置</a>');
     document.writeln('<li><a href="d_helpmain.asp#Time">时间与日期</a>');
    }
    </script>
   </ul>
  </td>
 </tr>
</table>
<br>
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Reboot>重启/恢复</a></td>
 </tr>
 <tr>
  <td class=content>
   <p>您可以选择一种方式重启系统</p>
   <dl>
   <dt>重启
      <dd>保存当前配置并重启系统。
   </dl>
   <dl>
   <dt>恢复出厂默认配置
      <dd>恢复出厂默认配置并重启系统。
   </dl>
  </td>
 </tr>
</table>
<br>
<div id="uploadHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Upload>固件升级</a></td>
 </tr>
 <tr>
  <td class=content>
   <p>您可以使用本页面为路由器升级一个新的软件版本。请注意，在升级过程中请不要断电，这样可能会使系统崩溃。
                提示:在升级完毕后系统会自动重启。</p>
  </td>
 </tr>
</table>
<br>
</div>
<div id="saveconfHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Saveconf>备份设置</a></td>
 </tr>
 <tr>
  <td class=content>
        <p>将路由器配置文件保存到硬盘上或者从配置文件恢复路由器配置。</p>
  </td>
 </tr>
</table><br>
</div>
<div id="userconfHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader><a name=Userconfig>用户帐户配置</a></td>
 </tr>
 <tr>
  <td class=content>
            <p>增加，删除或修改访问路由器的用户帐户。</p>
  </td>
 </tr>
</table>
<br>
</div>
 <div id="ntpHelp" style="display:none">
 <table id=body_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>
    <a id=Time name=Time>时间与日期</a>
   </td>
  </tr>
  <tr>
   <td class=content>
    <dl>
    <dd>日期配置页面可以设置，更新和纠正路由器的内部时钟。
    您也可以设置时区和时间服务器。
    <dt>系统时间
    <dd>显示路由器的当前时间，如果显示时间不正确，
    请填写正确的时间。
    <dl>
    <dt>服务器地址
       <dd>您可以输入用于时钟同步的网络时间服务器的地址。
    <dt>时区
    <dd>您可以在下拉框中选择您所在的时区。
    <dt>开始NTP
    <dd>您可以点击<span class=button_ref>获取GMT时间</span>
    从网络时间服务器上同步路由器时钟。
    </dd>
    </dl>
    </dd>
    </dl>
        </td>
  </tr>
 </table>
 </div>
<script language="javascript">
if (LoginUser == "admin"){
 document.getElementById("uploadHelp").style.display = 'block';
 document.getElementById("saveconfHelp").style.display = 'block';
 document.getElementById("userconfHelp").style.display = 'block';
 document.getElementById("ntpHelp").style.display = 'block';
}else{
 document.getElementById("uploadHelp").style.display = 'none';
 document.getElementById("saveconfHelp").style.display = 'none';
 document.getElementById("userconfHelp").style.display = 'none';
 document.getElementById("ntpHelp").style.display = 'none';
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

