<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<title>Autoboot</title>
<script>
var wtime=180;
function stop()
{
   clearTimeout(id); 
}
function start() 
{ 
	if(wtime==180)
	{
		wtime = parseInt(document.frm.waitTime.value);
	}
   wtime--;
   if (wtime >= 0)
   { 
      frm.time.value = wtime;
      id=setTimeout("start()",1000);
   }
   if (wtime == 0)
   { 
		if ( autoboot == "2") 
		{
			window.open("http://<% getResetLanIp(); %>/",target="_parent");
		}
		else
		{
			window.open("http://<% getLanIp(); %>/",target="_parent");
		}
   }
}
</script>
</head>
<body onLoad="start();" onUnload="stop();">
<blockquote>
<script language="JavaScript">
var autoboot = "<% d_getautobootHtm(); %>";
if( autoboot == "1" ){
 TabHeader="设置";
 SideItem="Internet设置";
 HelpItem="wanif";
}else{
	TabHeader="维护";
	SideItem="重启/恢复";
	HelpItem="reboot";
}
</script>
<script type='text/javascript'>
	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>

<form name=frm>
	<table id="box_header" border=0 cellSpacing=0>
		<tr>
			<td class="topheader">系统重启!</td>
		</tr>
		<tr>
			<td class="content">
			<p>
<script type='text/javascript'>
var macclone = "MAC地址改变，系统重启";	// 1
var reboot   = "您单击了重启按钮，系统重启 ";
var resetfac = "恢复出厂配置, 系统重启";
if( autoboot == "1" ){
	dw(macclone);
}else{
	dw(resetfac);
}
</script>
			</p>
			<p>请等待 
			<INPUT TYPE=text NAME=time size=2>
			 秒</p>
			<input style="display:none;" type="text" name="waitTime" size="15" maxlength="15" value="80">
			</td>
		</tr>
	</table>
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

