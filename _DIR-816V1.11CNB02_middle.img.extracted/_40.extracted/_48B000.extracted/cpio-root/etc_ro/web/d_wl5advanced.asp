<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<title>无线高级设置</title>


<SCRIPT>

//WPS was disabled automatically because WPS2.0 has some restrictions to enable WPS
var authmode = '<% getCfg2General(1, "AuthMode"); %>';
var encrytype = '<% getCfg2General(1, "EncrypType"); %>';
var hiddenssid5g = '<% getCfg2General(1, "HideSSID"); %>';
var encrypt=0;
var enable1x=0;
var wpa_auth=2;
var mode=0;
var is_adhoc=0;
var isWPSLimit=0;
var use40MValue='<% getCfg2Zero(1, "HT_BW"); %>';

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

var band;
function validateNum(str)
{
  for (var i=0; i<str.length; i++) {
   	if ( !(str.charAt(i) >='0' && str.charAt(i) <= '9')) {
		alert("无效值. 应该为十进制数0-9.");
		return false;
  	}
  }
  return true;
}
function saveChanges()
{
  if ( validateNum(document.advanceSetup.fragThreshold.value) == 0 ) {
  	document.advanceSetup.fragThreshold.focus();
	return false;
  }
  num = parseInt(document.advanceSetup.fragThreshold.value);
  if (document.advanceSetup.fragThreshold.value == "" || num < 256 || num > 2346) {
  	alert('分片门限的值无效.请输入 256-2346 之间的数字.');
  	document.advanceSetup.fragThreshold.focus();
	return false;
  }

  if ( validateNum(document.advanceSetup.rtsThreshold.value) == 0 ) {
  	document.advanceSetup.rtsThreshold.focus();
	return false;
  }
  num = parseInt(document.advanceSetup.rtsThreshold.value);
  if (document.advanceSetup.rtsThreshold.value=="" || num > 2347 || num < 1) {
  	alert('RTS 门限的值无效.请输入 1-2347 之间的数字.');
  	document.advanceSetup.rtsThreshold.focus();
	return false;
  }

  if ( validateNum(document.advanceSetup.beaconInterval.value) == 0 ) {
  	document.advanceSetup.beaconInterval.focus();
	return false;
  }
  num = parseInt(document.advanceSetup.beaconInterval.value);
  if (document.advanceSetup.beaconInterval.value=="" || num < 20 || num > 1024) {
  	alert('Beacon 间隔的值无效.请输入 20-1024 之间的数字.');
  	document.advanceSetup.beaconInterval.focus();
	return false;

  }
  num = parseInt(document.advanceSetup.dtimInterval.value);
  if (document.advanceSetup.dtimInterval.value=="" || num < 1 || num > 255) {
  	alert('DTIM 值无效. 请输入1-255 之间的数字.');
  	document.advanceSetup.dtimInterval.focus();
	return false;

  }

 create_backmask();
 document.getElementById("loading").style.display="";	
 
  return true;
}

function disableRadioGroup (radioArrOrButton)
{
  if (radioArrOrButton.type && radioArrOrButton.type == "radio") {
 	var radioButton = radioArrOrButton;
 	var radioArray = radioButton.form[radioButton.name];
  }
  else
 	var radioArray = radioArrOrButton;
 	radioArray.disabled = true;
 	for (var b = 0; b < radioArray.length; b++) {
 	if (radioArray[b].checked) {
 		radioArray.checkedElement = radioArray[b];
 		break;
	}
  }
  for (var b = 0; b < radioArray.length; b++) {
 	radioArray[b].disabled = true;
 	radioArray[b].checkedElement = radioArray.checkedElement;
  }
}

function enableRadioGroup (radioArrOrButton)
{
  if (radioArrOrButton.type && radioArrOrButton.type == "radio") {
 	var radioButton = radioArrOrButton;
 	var radioArray = radioButton.form[radioButton.name];
  }
  else
 	var radioArray = radioArrOrButton;

  radioArray.disabled = false;
  radioArray.checkedElement = null;
  for (var b = 0; b < radioArray.length; b++) {
 	radioArray[b].disabled = false;
 	radioArray[b].checkedElement = null;
  }
}

function updateState()
{
	if (document.advanceSetup.wlanDisabled.value == "1") {
	document.advanceSetup.advWlanDisabled.checked = false;
	}else{
	document.advanceSetup.advWlanDisabled.checked = true;
	}
	if(document.advanceSetup.advEnableWPS.value == "1"){
	document.advanceSetup.advEnableWPS.checked=true;
	}else{
	document.advanceSetup.advEnableWPS.checked=false;
	}
	if(document.advanceSetup.advDisablePIN.value == "0"){
	document.advanceSetup.advDisablePIN.checked=false;
	}else{
	document.advanceSetup.advDisablePIN.checked=true;
	}
	if(document.advanceSetup.advConfigured.value == "1"){
	document.advanceSetup.advConfigured.checked=true;
	}else{
	document.advanceSetup.advConfigured.checked=false;
	}

	if (false == document.advanceSetup.advWlanDisabled.checked) {
	disableRadioGroup(document.advanceSetup.authType);
	disableTextField(document.advanceSetup.fragThreshold);
	disableTextField(document.advanceSetup.rtsThreshold);
	disableTextField(document.advanceSetup.beaconInterval);
	disableTextField(document.advanceSetup.dtimInterval);
	disableTextField(document.advanceSetup.txRate);
	disableRadioGroup(document.advanceSetup.hiddenSSID);
	disableRadioGroup(document.advanceSetup.block);
	disableRadioGroup(document.advanceSetup.BlockEth2Wir);
	disableRadioGroup(document.advanceSetup.mc2uc);
	disableRadioGroup(document.advanceSetup.aggregation);
	disableRadioGroup(document.advanceSetup.shortGI);
	disableRadioGroup(document.advanceSetup.coexistence);

	disableCheckBox(document.advanceSetup.preamble);
	disableCheckBox(document.advanceSetup.advTxpower);
	disableCheckBox(document.advanceSetup.advEnableWPS);
	disableCheckBox(document.advanceSetup.advDisablePIN);
	disableCheckBox(document.advanceSetup.advConfigured);
	return;
	}

    if(use40MValue == "0"){
    disableRadioGroup(document.advanceSetup.coexistence);
    }

	if(false == document.advanceSetup.advEnableWPS.checked){
	disableCheckBox(document.advanceSetup.advDisablePIN);
	disableCheckBox(document.advanceSetup.advConfigured);
	}
	if(encrytype == "WEP" || encrytype =="TKIP" || hiddenssid5g == '1')
	{
	disableCheckBox(document.advanceSetup.advEnableWPS);
	}

	return;
}

function jumpToListPage()
{
	window.location.href = "d_wl5actrl.asp"
	//document.advanceSetup.setupListFlag.value = "1";
	//document.advanceSetup.submit();
}

function onClickAdvWlanEnable()
{
  if (document.advanceSetup.advWlanDisabled.checked == true) 
  {
	document.advanceSetup.wlanDisabled.value = "0";
	document.advanceSetup.advWlanDisabled.value="0";//enable
    enableRadioGroup(document.advanceSetup.authType);
    enableTextField(document.advanceSetup.fragThreshold);
    enableTextField(document.advanceSetup.rtsThreshold);
    enableTextField(document.advanceSetup.beaconInterval);
    enableTextField(document.advanceSetup.dtimInterval);
    enableTextField(document.advanceSetup.txRate);
    enableRadioGroup(document.advanceSetup.hiddenSSID);
    enableRadioGroup(document.advanceSetup.block);
    enableRadioGroup(document.advanceSetup.BlockEth2Wir);
    enableRadioGroup(document.advanceSetup.mc2uc);
    enableRadioGroup(document.advanceSetup.aggregation);
    enableRadioGroup(document.advanceSetup.shortGI);
    if(use40MValue == "0")
    {
        disableRadioGroup(document.advanceSetup.coexistence);
    }
    else
    {
        enableRadioGroup(document.advanceSetup.coexistence);
    }
    enableCheckBox(document.advanceSetup.preamble);
    enableCheckBox(document.advanceSetup.advTxpower);
    if (hiddenssid5g == "1")
	{
		disableCheckBox(document.advanceSetup.advEnableWPS);
	}
	else
	{
		enableCheckBox(document.advanceSetup.advEnableWPS);
	}
	if(document.advanceSetup.advEnableWPS.value == "1")
    {
		enableCheckBox(document.advanceSetup.advDisablePIN);
	    enableCheckBox(document.advanceSetup.advConfigured);
	}
	else
	{
		disableCheckBox(document.advanceSetup.advDisablePIN);
	    disableCheckBox(document.advanceSetup.advConfigured);
	}
  }
  else if(document.advanceSetup.advWlanDisabled.checked == false)
  {
	document.advanceSetup.wlanDisabled.value = "1";  //disable
	document.advanceSetup.advWlanDisabled.value="1";//disable
    disableRadioGroup(document.advanceSetup.authType);
    disableTextField(document.advanceSetup.fragThreshold);
    disableTextField(document.advanceSetup.rtsThreshold);
    disableTextField(document.advanceSetup.beaconInterval);
    disableTextField(document.advanceSetup.dtimInterval);
    disableTextField(document.advanceSetup.txRate);
    disableRadioGroup(document.advanceSetup.hiddenSSID);
    disableRadioGroup(document.advanceSetup.block);
    disableRadioGroup(document.advanceSetup.BlockEth2Wir);
    disableRadioGroup(document.advanceSetup.mc2uc);
    disableRadioGroup(document.advanceSetup.aggregation);
    disableRadioGroup(document.advanceSetup.shortGI);
    disableRadioGroup(document.advanceSetup.coexistence);

    disableCheckBox(document.advanceSetup.preamble);
    disableCheckBox(document.advanceSetup.advTxpower);
    disableCheckBox(document.advanceSetup.advEnableWPS);
    disableCheckBox(document.advanceSetup.advDisablePIN);
    disableCheckBox(document.advanceSetup.advConfigured);
  }
}
function onClickAdvWPSEnable()
{
  if (disable_all || true == document.advanceSetup.advEnableWPS.disabled) {
  	disableCheckBox(document.advanceSetup.advEnableWPS);
  	disableCheckBox(document.advanceSetup.advDisablePIN);
	disableCheckBox(document.advanceSetup.advConfigured);  
	return;
  }
  
  if(document.advanceSetup.advEnableWPS.checked == false || disable_all)
  {
  	disableCheckBox(document.advanceSetup.advDisablePIN);
	disableCheckBox(document.advanceSetup.advConfigured);  
  }else{
	enableCheckBox(document.advanceSetup.advDisablePIN);
	enableCheckBox(document.advanceSetup.advConfigured);
  }
  
  if (document.advanceSetup.advEnableWPS.checked == true) 
  {
  	document.advanceSetup.advEnableWPS.value="1";//enable
  }
  //else if(document.advanceSetup.advEnableWPS.checked == false)
  else
  {
  	document.advanceSetup.advEnableWPS.value="0";//disable
  }
}
function onClickAdvPinEnable()
{
  if (document.advanceSetup.advDisablePIN.checked == true) 
  {
  	document.advanceSetup.advDisablePIN.value="1";//disable
  }
  else if(document.advanceSetup.advDisablePIN.checked == false)
  {
  	document.advanceSetup.advDisablePIN.value="0";// enable
  }
}
function onClickAdvConfigEnable()
{
  if (document.advanceSetup.advConfigured.checked == true) 
  {
  	document.advanceSetup.advConfigured.value="1";//enable
  }
  else if(document.advanceSetup.advConfigured.checked == false)
  {
  	document.advanceSetup.advConfigured.value="0";//disable
  }
}
function coexistValueInit()
{
	var coexistValue = '<% getCfg2Zero(1, "HT_BSSCoexistence"); %>';
	if(coexistValue == "0")//disable
    {
	    document.advanceSetup.coexistence[0].checked = false;
	    document.advanceSetup.coexistence[1].checked = true;
	}
	else//enable
	{
	    document.advanceSetup.coexistence[0].checked = true;
	    document.advanceSetup.coexistence[1].checked = false;
	}
}


function initValue()
{
	var radio_off = '<% getCfg2Zero(1, "RadioOff"); %>';
	var TxPreamble = '<% getCfg2Zero(1, "TxPreamble"); %>';
	var TxPower = '<% getCfg2Zero(1, "TxPower"); %>';	
	var wpsenable = "<% getCfg2Zero(1, "WscModeOption"); %>";
	var wscmethods = "<% getCfg2General(1, "WscConfMethods"); %>";
	var wpsconfigured = "<% getCfg2Zero(1, "WscConfigured"); %>";
	var lockstatus = '<% getRaixWscLockASP(); %>';
	
	if (1*radio_off == 1) {
		document.advanceSetup.wlanDisabled.value = "1";
	}
	else {
		document.advanceSetup.wlanDisabled.value = "0";
	}	
	
	if (TxPreamble == "0")
	{
		document.advanceSetup.preamble.value = 0;
	}
	else
	{
		document.advanceSetup.preamble.value = 1;
	}

	if	(TxPower == "100")
	{
		document.advanceSetup.advTxpower.value = 0;	
	}
	else if	(TxPower == "80") 
	{
		document.advanceSetup.advTxpower.value = 1;	
	}
	else if	(TxPower == "50") 
	{
		document.advanceSetup.advTxpower.value = 2;	
	}
	else if	(TxPower == "25") 
	{
		document.advanceSetup.advTxpower.value = 3;	
	}
	else if	(TxPower == "10") 
	{
		document.advanceSetup.advTxpower.value = 4;	
	}
	
	if (wpsenable == "0")
	{
		document.advanceSetup.advEnableWPS.value = "0";
	}
	else 
	{
		document.advanceSetup.advEnableWPS.value = "1";
	}
	
	if (((wscmethods == "0x268c") || (wscmethods == "0x238c"))&& (lockstatus != "1"))
	{
		document.advanceSetup.advDisablePIN.value = "0";
	}
	else
	{
		document.advanceSetup.advDisablePIN.value = "1";
	}

	if (wpsconfigured == "1")
	{
		document.advanceSetup.advConfigured.value = "1";
	}
	else 
	{
		document.advanceSetup.advConfigured.value = "0";
	}

	coexistValueInit();
	updateState();
	//onClickAdvWPSEnable();
	

}
</SCRIPT>

<blockquote>


<script language="JavaScript">

	TabHeader="无线5G";
	SideItem="无线高级设置";
	HelpItem="wladv";
</script>

<script type='text/javascript'>

	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>


<body onload="initValue()">


<form action="/goform/form2Wl5AdvanceSetup.cgi" method=POST name="advanceSetup">

	<table id=box_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>无线高级设置</td>

		</tr>

		
		<tr>

			<td class=content>

			<p>此页面指引您设置高级无线功能，包括设置碎片限值等。</p>

			</td>

		</tr>

		
	</table>


	<table id=body_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>无线高级设置</td>

		</tr>


		<tr>

			<td class=content align=center>

				<table class=formarea border="0" cellpadding="0" cellspacing="0" width="450">

					<tr>

					<input type=hidden name="wlanDisabled" value="0" >
					</tr>


					<tr style="display:none">

						<td class=form_label_left>认证类型  ：</td>

						<td class=form_label_right>

							<input type="radio" name="authType" value=0 >Open System&nbsp;&nbsp;

							<input type="radio" name="authType" value=1 >Shared Key&nbsp;&nbsp;

							<input type="radio" name="authType" value=2 >自动

						</td>

					</tr>

					
					<tr>

						<td class=form_label_left>启用无线收发功能  ：</td>   					

						<td class=form_label_right><input type="checkbox" name="advWlanDisabled" value="0"
						onclick="onClickAdvWlanEnable()"></td>
					</tr>

					
					<tr>

						<td class=form_label_left>碎片限值(256-2346)  ：</td>

						<td class=form_label_right>

							<input type="text" name="fragThreshold" size="10" maxlength="4" value="<% getCfg2ToHTML(1, "FragThreshold"); %>" >
						</td>

					</tr>

    
					<tr>

						<td class=form_label_left>CTS/RTS限值(1-2347)  ：</td>

						<td class=form_label_right><input type="text" name="rtsThreshold" size="10" maxlength="4" value="<% getCfg2ToHTML(1, "RTSThreshold"); %>" >
						</td>

					</tr>


					<tr style="display:none">

						<td class=form_label_left>Beacon 间隔  ：</td>

						<td class=form_label_right><input type="text" name="beaconInterval" size="10" maxlength="4" value="<% getCfg2ToHTML(1, "BeaconPeriod"); %>"  >(20-1024 毫秒)</td>
					</tr>


					<tr style="display:none">

						<td class=form_label_left>DTIM 间隔  ：</td>

						<td class=form_label_right><input type="text" name="dtimInterval" size="10" maxlength="3" value="<% getCfg2ToHTML(1, "DtimPeriod"); %>"	>(1-255)</td>
					</tr>


					<tr style="display:none">

						<td class=form_label_left>数据速率  ：</b></td>

						<td class=form_label_right><select size="1" name="txRate">

						<SCRIPT>

band=11;
txrate=1;
auto=1;
rf_num=2;


	rate_mask = [15,1,1,1,1,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,8,8,8,8,8,8,8,8];
	rate_name =["Auto","1M","2M","5.5M","11M","6M","9M","12M","18M","24M","36M","48M","54M", "MCS0", "MCS1",
		"MCS2", "MCS3", "MCS4", "MCS5", "MCS6", "MCS7", "MCS8", "MCS9", "MCS10", "MCS11", "MCS12", "MCS13", "MCS14", "MCS15"];
	mask=0;
	if (auto)
		txrate=0;
	if (band & 1)
		mask |= 1;
	if ((band&2) || (band&4))
		mask |= 2;
	if (band & 8) {
		if (rf_num == 2)
			mask |= 12;	
		else
			mask |= 4;
	}
	defidx=0;
	for (idx=0, i=0; i<=28; i++) {
		if (rate_mask[i] & mask) {
			if (i == 0)
				rate = 0;
			else
				rate = (1 << (i-1));
			if (txrate == rate)
				defidx = idx;
			document.write('<option value="' + i + '">' + rate_name[i] + '\n');
			idx++;
		}
	}
	document.advanceSetup.txRate.selectedIndex=defidx;

						</SCRIPT>

						</select>

						</td>

					</tr>

					
					<tr>

						<td class=form_label_left>报头模式  ：</td>

						<td class=form_label_right>

							<select name="preamble" size="1">      		

							<option value="1">短报头</option>

							<option value="0">长报头</option>    		

							</select>					

						</td>

					</tr>

										
					<tr>

						<td class=form_label_left>调节发射功率  ：</td>

						<td class=form_label_right>

							<select name="advTxpower" size="1">

							<option value="0">100%</option>        		

							<option value="1">80%</option> 

							<option value="2">50%</option> 

							<option value="3">25%</option>

							<option value="4">10%</option>

							</select>					

						</td>

					</tr>

					
					<tr style="display:none">

						<td class=form_label_left>广播SSID  ：</td>

						<td class=form_label_right>

						<input type="radio" name="hiddenSSID" value=0>启用&nbsp;&nbsp;

						<input type="radio" name="hiddenSSID" value=1>禁用</td>

					</tr>


					<tr style="display:none">

						<td class=form_label_left>无线隔离  ：</td>

						<td class=form_label_right>

						<input type="radio" name=block value=1>启用&nbsp;&nbsp;

						<input type="radio" name=block value=0>禁用</td>

					</tr>


					<tr style="display:none">

						<td class=form_label_left>以太网到无线阻塞  ：</td>

						<td class=form_label_right>

						<input type="radio" name=BlockEth2Wir value=1>启用&nbsp;&nbsp;

						<input type="radio" name=BlockEth2Wir value=0>禁用</td>

					</tr>


					<tr style="display:none">

						<td class=form_label_left>Wifi多播转单播  ：</td>

						<td class=form_label_right>

						<input type="radio" name=mc2uc value=1>启用&nbsp;&nbsp;

						<input type="radio" name=mc2uc value=0>禁用</td>

					</tr>


					<tr  style="display:none">

						<td class=form_label_left>聚合  ：</td>

						<td class=form_label_right>

						<input type="radio" name=aggregation value=1>启用&nbsp;&nbsp;

						<input type="radio" name=aggregation value=0>禁用</td>

					</tr>

			   
					<tr  style="display:none">

						<td class=form_label_left>短保护间隔  ：</td>

						<td class=form_label_right>

						<input type="radio" name=shortGI value=1>启用&nbsp;&nbsp;

						<input type="radio" name=shortGI value=0>禁用</td>

					</tr>


					<tr id="ht2040_coexistence">

						<td class=form_label_left>HT20/40 Coexistence  ：</td>

						<td class=form_label_right>

						<input type="radio" name=coexistence value=1>启用&nbsp;&nbsp;

						<input type="radio" name=coexistence value=0>禁用</td>

					</tr>	    

				</table>


			</td>

		</tr>

	</table>


	<table id=body_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>WPS设置</td>

		</tr>


		<tr>

			<td class=content align=center>

				<table class=formarea border="0" cellpadding="0" cellspacing="0" width="450">

					<tr>

						<td class=form_label_left>路由器的PIN值  ：</td>   					

						<td class=form_label_right> <% getRaixPINASP(); %>


						</td>

					</tr>

					<script>

isClient=0;


					if (mode == 0 || mode == 3)
						disable_all = check_wps_enc(encrypt, enable1x, wpa_auth);
					if (disable_all == 0 && isWPSLimit == 1){
						disable_all = 4;
					}else{
						disable_all = check_wps_wlanmode(mode, is_adhoc);
					}
					</script>

					<tr>

						<td class=form_label_left>启用WPS  ：</td>   					

						<td class=form_label_right><input type="checkbox" name="advEnableWPS" value="1" onclick="onClickAdvWPSEnable()"></td>
					</tr>

					<tr>

						<td class=form_label_left>禁用路由器PIN  ：</td>   					

						<td class=form_label_right><input type="checkbox" name="advDisablePIN" value="0"
						onclick="onClickAdvPinEnable()"></td>
					</tr>

					<tr>

						<td class=form_label_left>保持现有的无线配置  ：</td>   					

						<td class=form_label_right><input type="checkbox" name="advConfigured" value="1"
						onclick="onClickAdvConfigEnable()"></td>			
						</td>

					</tr>															

				</table>

			</td>

		</tr>

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
	</script>

	</table>



	<table id=body_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>无线网卡访问列表</td>

		</tr>


		<tr>

			<td class=content>

				<table class=formarea border="0" cellpadding="0" cellspacing="0" width="450">

					<tr>

						<td>

							<input type="button" value="设置访问列表" onclick="jumpToListPage()" name="setupList">

						</td>

						<td style="display:none">

							<input type="text" value="0" name="setupListFlag">

						</td>

					</tr> 

				</table>

			</td>

		</tr>

	</table>



	<p align=center>

	<input type="submit" value="应用" name="save" onClick="return saveChanges()">&nbsp;&nbsp;

	</p>

	<script>

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



