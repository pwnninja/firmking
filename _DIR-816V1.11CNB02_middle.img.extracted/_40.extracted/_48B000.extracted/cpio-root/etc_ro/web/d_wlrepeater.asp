<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>


<title>无线中继设置</title>

<SCRIPT>

var InitRepeaterMode = "<% getCfgZero(1, "ApCliEnable"); %>";
function saveChanges()
{
	document.wlanSetup.startScanUplinkAp.value = "0";
	if((document.wlanSetup.RepeaterMode.checked == true) && (!checkSpecialChar(document.wlanSetup.RepeaterSSID.value,1)))
	{
		alert('无效的SSID.不能包含特殊字符 \\\'"? ');
		document.wlanSetup.RepeaterSSID.focus();
		return false;  	
	}
	if((InitRepeaterMode == 0) && (document.wlanSetup.RepeaterMode.checked == true))
	{
		if (confirm("启用中继将关闭路由器的DHCP Server功能.\n确定要启用中继吗?") == 0)
		{
			return false;
		}
	}

	create_backmask();
	document.getElementById("loading").style.display="";	
	return true;
}

var wtime;
function timerStart() 
{ 
	if (wtime >= 0)
	{ 
		document.wlanSetup.scanUplinkAp.value = '正在扫描,请勿中断, 剩余'+wtime+'秒';
		wtime--;
		setTimeout("timerStart()",1000);
	}
	else
	{
		// set flag to '2', and then submit
		document.wlanSetup.scanUplinkAp.value = "站点扫描";
		enableCheckBox(document.wlanSetup.RepeaterMode);
		enableButton(document.wlanSetup.scanUplinkAp);
		enableButton(document.wlanSetup.save);
		enableTextField(document.wlanSetup.RepeaterSSID);  
		document.wlanSetup.startScanUplinkAp.value = "2";//wtime initial value
		//window.location = "http://"+lanip+"/wlbasic.htm";
		document.wlanSetup.submit();
	}
}
// startScanUplinkAp.value: 1-start scan 2-scan time out 3-next configure
function onClickScanUplinkAp()
{
	// set flag to '1', and then submit
	if((InitRepeaterMode == 0) && (document.wlanSetup.RepeaterMode.checked == true))
	{
		if (confirm("启用中继将关闭路由器的DHCP Server功能.\n确定要启用中继吗?") == 0)
		{
			return false;
		}
	}
	document.wlanSetup.startScanUplinkAp.value = "1";
	document.wlanSetup.submit();
	return true;
}

function onClickScanUplinkApNext()
{
	if("" == document.wlanSetup.RepeaterSSID.value) 
	{
		alert('SSID不能为空!');
		document.wlanSetup.RepeaterSSID.focus();
		return false;
	}
	
	//if(getStringByteCount(document.wlanSetup.RepeaterSSID.value) > 32)
	if(document.wlanSetup.RepeaterSSID.value.length > 32)
	{
		alert('SSID字符字节数不得超过32!');
		document.wlanSetup.RepeaterSSID.value = "";
		document.wlanSetup.RepeaterSSID.focus();
		return false; 	
	}
	
	// set flag to '3', and then submit
	if((InitRepeaterMode == 0) && (document.wlanSetup.RepeaterMode.checked == true))
	{
		if (confirm("启用中继将关闭路由器的DHCP Server功能.\n确定要启用中继吗?") == 0)
		{
			return false;
		}
	}
	document.wlanSetup.startScanUplinkAp.value = "3";
	document.wlanSetup.submit();
	create_backmask();
	document.getElementById("loading").style.display="";	
	return true;
}

function updateRepeater()
{
	var Wl5RepeaterMode = "<% getCfg2Zero(1, "ApCliEnable"); %>"; //5g
	if(document.wlanSetup.wlanDisabled.value == "1" || Wl5RepeaterMode == "1")
	{
		disableCheckBox(document.wlanSetup.RepeaterMode);
		disableButton(document.wlanSetup.scanUplinkAp);
		disableButton(document.wlanSetup.save);
		disableTextField(document.wlanSetup.RepeaterSSID); 
		if(document.wlanSetup.RepeaterMode.value=="0")
		{
			document.wlanSetup.RepeaterMode.checked = false;
		}
		else if(document.wlanSetup.RepeaterMode.value=="1")
		{
			document.wlanSetup.RepeaterMode.checked = true;
		} 

		return;
	}

	// check RepeaterMode and then refresh the checkbox
	if(document.wlanSetup.RepeaterMode.value=="0")
	{
		document.wlanSetup.RepeaterMode.checked = false;
		InitRepeaterMode = false;
		disableTextField(document.wlanSetup.RepeaterSSID);  
		disableButton(document.wlanSetup.scanUplinkAp);
	}
	else if(document.wlanSetup.RepeaterMode.value=="1")
	{
		document.wlanSetup.RepeaterMode.checked = true;
		InitRepeaterMode = true;
	}

	// fsm
	if('1' == document.wlanSetup.startScanUplinkAp.value)
	{
		wtime = 15;//wtime initial value
		disableCheckBox(document.wlanSetup.RepeaterMode);
		disableButton(document.wlanSetup.scanUplinkAp);
		disableButton(document.wlanSetup.save);
		disableTextField(document.wlanSetup.RepeaterSSID);  
		// set flag to '2', and then submit
		timerStart();
	}
	else
	{
		if ('2' == document.wlanSetup.startScanUplinkAp.value)
		{
			document.getElementById("scantable").style.display ="";
		}

		// set flag to '0'
		document.wlanSetup.startScanUplinkAp.value = "0";
	}
}

function clickUpdateRepeater()
{
	if(document.wlanSetup.RepeaterMode.checked == false)
	{
		document.wlanSetup.RepeaterMode.value="0";
		document.wlanSetup.RepeaterSSID.disabled = true;
		document.wlanSetup.scanUplinkAp.disabled = true;
	}
	else if(document.wlanSetup.RepeaterMode.checked == true)
	{
		document.wlanSetup.RepeaterMode.value="1";
		document.wlanSetup.RepeaterSSID.disabled = false;
		document.wlanSetup.scanUplinkAp.disabled = false;
	}
}
function isEmpty(ui)   
{ 
	return (ui == null||ui == "");
}
function rightTrim(ui)
{ 
	var notValid=/\s$/; 
	while(notValid.test(ui))
	{ 
		ui=ui.replace(notValid,"");
	} 
	return ui;
}

function postSsid(index)
{
	document.wlanSetup.RepeaterSSID.value = unEscapeHtmlString(document.getElementById( "ssid_" + index ).innerHTML);
	document.wlanSetup.RepeaterBSSID.value = document.getElementById( "bssid_" + index ).innerHTML;
	document.wlanSetup.apcli_channel.value = document.getElementById( "channel_" + index ).innerHTML;
	//document.wlanSetup.apcli_extchannel.value = document.getElementById( "extch_" + index ).innerHTML;
	//document.wlanSetup.WifiSecurity.value = wifiSecurity;
	var wifiSecurity = document.getElementById( "security_" + index ).innerHTML;
	var encryMethod00 = "NONE";
	var encryMethod01 = "WEP";
	var encryMethod02 = "WPA[^0-9]*TKIP.*";
	var encryMethod03 = "WPA[^0-9]*AES.*";
	var encryMethod05 = "WPA2.*TKIP.*";
	var encryMethod04 = "WPA2.*AES.*";
	var condition = wifiSecurity.match(encryMethod00);
	if(condition != null)
	{
		document.wlanSetup.WifiSecurity.value = "0";
		return true;
	}
	var condition = wifiSecurity.match(encryMethod01);
	if(condition != null)
	{
		document.wlanSetup.WifiSecurity.value = "1";
		return true;
	}
	var condition = wifiSecurity.match(encryMethod02);
	if(condition != null)
	{
		document.wlanSetup.WifiSecurity.value = "2";
		return true;
	}
	var condition = wifiSecurity.match(encryMethod03);
	if(condition != null)
	{
		document.wlanSetup.WifiSecurity.value = "3";
		return true;
	}
	var condition = wifiSecurity.match(encryMethod04);
	if(condition != null)
	{
		document.wlanSetup.WifiSecurity.value = "4";
		return true;
	}
	var condition = wifiSecurity.match(encryMethod05);
	if(condition != null)
	{
		document.wlanSetup.WifiSecurity.value = "5";
		return true;
	}
	return true;
}
</SCRIPT>

</head>


<body>

<blockquote>


<script language="JavaScript">

	TabHeader="无线2.4G";
	SideItem="无线中继";
	HelpItem="wlrepeater";
</script>

<script type='text/javascript'>

	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>


<form action="goform/form2RepeaterSetup.cgi" method=POST name="wlanSetup">

	<table id=box_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>

				无线中继
			</td>

		</tr>

		<tr>

			<td class=content>

				<p>本页面用于设置无线网路的中继功能。</p>

				<p>第一步: 点击“站点扫描”按钮扫描无线站点。扫描出来的站点信息将显示在下面的列表中。选中某一站点，然后点击“下一步”。</p>

			</td>

		</tr>

	</table>


	<table id=body_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>无线中继设置

			</td>

		</tr>


		<tr>

			<td class=content>

				<table id="basicSetup" class=formarea border="0" cellpadding="0" cellspacing="0" width=100% style="display:none">

					<tr>

					<td align=right><input type="checkbox" name="wlanDisabled" value="<% getCfgZero(1, "RadioOff"); %>" ></td>
					<td class=form_label_enabled>&nbsp;&nbsp;禁用无线

     					</td>     					

					</tr>

				</table>

				<br>

				
				<table class=formarea border="0" cellpadding="0" cellspacing="0" width=100%>

					<td align=right><input type="checkbox" name="RepeaterMode" value="<% getCfgZero(1, "ApCliEnable"); %>" ONCLICK=clickUpdateRepeater()></td>
					<td class=form_label_enabled>&nbsp;&nbsp;启用中继(<font style="color:red">启用中继将关闭路由器的DHCP Server功能</font>)</td>     					

					</tr>

					<tr>

					<td class=form_label_40>中心AP的SSID</td>

					<td>

				<input type=text name="RepeaterSSID" size="25" maxlength="32" value="<% getCfgGeneral(1, "ApCliSsid1"); %>" >
				<input type=hidden name='RepeaterBSSID' value=''></td>
				<input type=hidden name='WifiSecurity' value=''></td>
				<input type=hidden id="apcli_channel" name="apcli_channel" value="">
				<input type=hidden id="apcli_extchannel" name="apcli_extchannel" value="">

				
					</tr>


					<tr>

					<td class=form_label_40></td>     					

					<td>

					<input type="button" value="站点扫描" name="scanUplinkAp" onClick="return onClickScanUplinkAp()">

					</td>

					<td style="display:none">

					<input type=text name="startScanUplinkAp" value="<% getCfgZero(1, "startScanUplinkAp"); %>" ></td>     					
					</tr>

				</table>

			</td>

		</tr>

		<tr>

			<td id="scantable" class=content align=center  style ="display:none">
			<table class=formlisting border=0>

				<tr class=form_label_row>

					<td class=form_label_col>#</td>

					<td class=form_label_col>网络名称</td>

					<td class=form_label_col>MAC地址</td>

					<td class=form_label_col>信道</td>

					<td class=form_label_col>信号强度</td>

					<td class=form_label_col>加密方式</td>

					<td class=form_label_col>选择网络</td>	

				</tr>

			  <% ApcliScan(); %>
			</table>

			<p align=left><font color="red">点击 "下一步" 继续设置中继参数</font></p>

			<input type="button" value="下一步" name="scanUplinkApNext" onClick="return onClickScanUplinkApNext()">

			</td>

		</tr>

	</table>


	<p align=center>

	<input type="submit" value="应用" name="save" onClick="return saveChanges()">&nbsp;&nbsp;

	</p>

	<INPUT TYPE="hidden" NAME="submit.htm?wlrepeater.htm" VALUE="Send">

	
	<script>

	updateRepeater();
	</script>
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



