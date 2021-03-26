<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>

<title>网络尖兵配置</title>
<script>

function netsniperEnabledClick(){
	if(document.NetSniper.netsniperEnabled.checked){
		enableTextField(document.NetSniper.ignIpOpn);
		enableTextField(document.NetSniper.rmvTcpTime);
		enableTextField(document.NetSniper.mdyUsrAgt);
	}
	else{
		disableTextField(document.NetSniper.ignIpOpn);
		disableTextField(document.NetSniper.rmvTcpTime);
		disableTextField(document.NetSniper.mdyUsrAgt);
	}
}

function saveChanges()
{

  return true;
}

function initValue()
{
	var netsniper_enable = '<% getCfgZero(1, "wan_netsniper_enable"); %>';	
	if (netsniper_enable == "1")
	{
		document.NetSniper.netsniperEnabled.checked = true;
	}
	else
	{
		document.NetSniper.netsniperEnabled.checked = false;	
	}
}

</script>

</head>

<body onload="initValue()">
<blockquote>

<script language="JavaScript">
	TabHeader="高级";
	SideItem="网络尖兵";
	HelpItem="Netsniper";
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
		<td class="topheader">网络尖兵</td>
	</tr>
	<tr>
		<td class="content">
			<p>	本页面用于配置网络尖兵,正确配置可以使多台电脑通过此路由器共享宽带.
			</p>
		</td>
	</tr>
</table>

<form action="goform/form2NetSniper.cgi" method=POST name="NetSniper">
<table id="body_header" border="0" cellSpacing="0">
	<tr>
		<td class="topheader">网络尖兵设置</td>
	</tr>
	<tr>
		<td class="content" align="left">
			<table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
				<tr>
					<td class="form_label_left">
						<input type="checkbox" name="netsniperEnabled" value="1"  ></td>
					<td class="form_label_right">启用网络尖兵</td>
				</tr>

			</table>
		</td>
	</tr>
</table>
<br>
<p align=center>
  <input type="hidden" name="submit.htm?netsniper.htm" VALUE="Send">
  <input type="submit" value="应用" name="save" onClick="return saveChanges()">&nbsp;&nbsp;
</p>
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

