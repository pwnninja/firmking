<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<title>重启/恢复</title>

<SCRIPT>
function resetClick()
{
	if(!confirm('确定恢复默认配置吗?'))
	{
		return false;
	}
	return true;
}
function rebootClick()
{
	if(!confirm('确定重启设备吗?'))
	{
		return false;
	}
	return true;
}
</SCRIPT>

</head>

<body>
<blockquote>

<script language="JavaScript">
	TabHeader="维护";
	SideItem="重启/恢复";
	HelpItem="reboot";
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
		<td class=topheader>重启/恢复</td>
	</tr>
	<tr>
		<td class=content>
			<p>此页面用来重启系统或者恢复出厂默认配置。
            </p>
		</td>
	</tr>
</table>

<form action="/goform/form2Reboot.cgi" method="POST" name="cmboot">
<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>重启/恢复出厂默认配置</td>
	</tr>
	<tr>
		<td class="content" align="center">
			<input type="submit" value="Reboot" name="reboot" onClick="return rebootClick()">
			<input type="submit" value="Reset" name="reset" onclick="return resetClick()">
			<input type="hidden" NAME="submit.asp?d_reboot.asp" value="Send">
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

