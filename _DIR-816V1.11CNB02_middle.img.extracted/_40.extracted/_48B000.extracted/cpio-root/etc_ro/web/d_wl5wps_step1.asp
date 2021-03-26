<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>


<title>Wi-Fi保护设置</title>

<script>

//WPS was disabled automatically because WPS2.0 has some restrictions to enable WPS
var encrypt=0;
var enable1x=0;
var wpa_auth=2;
var mode=0;
var is_adhoc=0;
var is_WPSLock=0;
var is_WPSEnabled="<% getCfg2Zero(1, "WscModeOption"); %>";
var isWPSLimit=0;
var is_WlanDisabled = '<% getCfg2Zero(1, "RadioOff"); %>';
var wscmethods = "<% getCfg2General(1, "WscConfMethods"); %>";

var warn_msg1='由于不支持该无线模式，WPS自动被禁用. ' +
				'必须跳转到"无线/基本配置"页面修改配置来启用WPS.';
var warn_msg2='由于不支持该认证模式，WPS自动被禁用. ' +
				'必须跳转到"无线/安全"页面修改配置来启用WPS.';
var warn_msg3="PIN号码已生成. 请点击\'应用\'按钮使修改生效.";
var warn_msg4='WPS必须在满足以下条件时，才能被启用；否则会被自动禁用。<BR>' +
				'1. 广播SSID必须被启用。(请在无线基本配置页面启用)<br>' +
				'2. 加密模式不能为WEP 或者 WPA-TKIP。(请在无线基本配置页面更改设置)<br>' +
				'3. 如果无线接入控制模式为允许列表，列表不能为空。(请在高级无线设置页面更改设置)';				
var disable_all=0;

isClient=0;


if (mode == 0 || mode == 3)
	disable_all = check_wps_enc(encrypt, enable1x, wpa_auth);
if (disable_all == 0 && isWPSLimit == 1){
	disable_all = 4;
}else{
	disable_all = check_wps_wlanmode(mode, is_adhoc);
}

function showWPSEnable()
{	
	if (disable_all) {
		disableButton(document.formWsc.next);
	}
}
</script>

</head>


<body>

<blockquote>


<script language="JavaScript">

	TabHeader="无线5G";
	SideItem="WPS设置";
	HelpItem="wlwps";
</script>

<script type='text/javascript'>

	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>


<form action="/goform/fform2Wl5Wsc.cgi" method=POST name="formWsc">

	<table id=box_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>

				WPS设置
			</td>

		</tr>

		<tr>

			<td class=content>

				<p>

				  WPS代表Wi-Fi保护设置。您可以通过这一过程轻松地将无线客户端添加到网络，而无需进行任何具体的配置，例如SSID、安全模式和密码之类的配置。
				</p>

			</td>

		</tr>

	</table>


	<table id=body_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>WPS设置

			</td>

		</tr>


		<tr>

			<td class=content>

				<b>

					通过WiFi保护设置（WiFi Protected setup，WPS）轻松连接到无线路由器的新方法
				</b>

				<br>

				<p>

					要使用本向导将无线客户端添加到启用了WPS的无线路由器，要求该客户端必须支持WPS功能。
				</p>

				<p>

					请查看无线客户端的用户手册和包装盒，确认其是否支持WPS功能。
				</p>

				<p>

					如果无线客户端不支持WPS功能，则您必须手动进行配置。
				</p>

			</td>

		</tr>	

	</table>


	<p  align=center>

	<input type="button" value="下一步" name="next"  onclick="window.location.href='d_wl5wps_step2.asp'">

	</p>

	<script>

		if (disable_all) {
			document.write("<font size=2><em>");
			if (disable_all == 1)
				document.write(warn_msg1);
			else if (disable_all == 2)
				document.write(warn_msg2);
			else if (disable_all == 4)
				document.write(warn_msg4);
		}
		if ((is_WPSEnabled == "0") || (is_WlanDisabled == "1") ||((wscmethods !="0x268c") &&(wscmethods !="0x238c")) )
		{
			disableButton(document.formWsc.next);
		}
	</script>
	<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
</form>


<script>

showWPSEnable();
</script>

<script type='text/javascript'>

	mainBodyEnd();
	ThirdRowEnd();
	Footer();
	mainTableEnd();
</script>


</blockquote>

</body>


</html>



