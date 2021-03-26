<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<title>
 Wireless Router
</title>

<script>
var ModemVer="<% getCfgGeneral(1, "ModeName"); %>";
var HardwareVer="<% getCfgGeneral(1, "HardwareVer"); %>";
var FirmwareVer="<% getCfgGeneral(1, "FirmwareVer"); %>";
var regDomain, defaultChan, lastBand=0, lastMode=0,currentBand;
function addClick()
{
 return true;
}
 function isValidWPAPasswd(str)   
{   

	var patrn=/^[a-zA-Z0-9!#$%&()*+,-./:;=?@[\]^_`{|}~<>]{1}[a-zA-Z0-9!#$%&()*+,-./:;=?@[\]^_`{|}~<>\x20]{6,62}[a-zA-Z0-9!#$%&()*+,-./:;=?@[\]^_`{|}~<>]{1}$/;   
	if (!patrn.exec(str)) return false  ; 

	if(str.indexOf("  ") != -1)
		return false;
	
	return true;	
}

function encodeSelection()
{
 if (document.form2WizardStep54.wizardstep54_sec[0].checked)
 {
  disableTextField(document.form2WizardStep54.show_wizardstep54_pskpwd);
 }
 else
 {
  enableTextField(document.form2WizardStep54.show_wizardstep54_pskpwd);
 }
}
function showChannel2G(bound_40, band)
{
 start = 0;
 end = 0;
 if (regDomain==1 || regDomain==2) {
  start = 1;
  end = 11;
 }
 else if (regDomain==3) {
  if(document.form2WizardStep54.wizardstep54_domain.selectedIndex == 47){
   start = 3;
   end = 9;
  }else{
   start = 1;
   end = 13;
  }
 }
 else if (regDomain==4) {
  start = 10;
  end = 11;
 }
 else if (regDomain==5) {
  start = 10;
  end = 13;
 }
 else if (regDomain==6) {
  if(band == 0 || band == 2 || band == 10){
   start = 1;
   end = 14;
  }else{
   start = 1;
   end = 13;
  }
 }
 else {
  start = 1;
  end = 11;
 }
 return;
 /*
 document.form2WizardStep54.wizardstep54_chan.length=0;
 idx=0;
 document.form2WizardStep54.wizardstep54_chan.options[idx] = new Option("Auto", 0, false, false);
 if (0 == defaultChan) {
  document.form2WizardStep54.wizardstep54_chan.selectedIndex = 0;
 }
 idx++;
 for (chan=start; chan<=end; chan++, idx++) {
  document.form2WizardStep54.wizardstep54_chan.options[idx] = new Option(chan, chan, false, false);
  if (chan == defaultChan)
   document.form2WizardStep54.wizardstep54_chan.selectedIndex = idx;
 }
 document.form2WizardStep54.wizardstep54_chan.length = idx;
 */
}
function updateChan_channebound()
{
 var idx_value= document.form2WizardStep54.wizardstep54_band.selectedIndex;
 var band_value= document.form2WizardStep54.wizardstep54_band.options[idx_value].value;
 var bound = document.form2WizardStep54.wizardstep54_chanwid.selectedIndex;
 var adjust_chan;
 currentBand = 1;
 if(band_value==9 || band_value==10 || band_value ==7){
  if(bound ==0)
   adjust_chan=0;
  if(bound ==1)
   adjust_chan=1;
 }else
  adjust_chan=0;
   if (currentBand == 1)
  showChannel2G(adjust_chan, band_value);
   if(lastMode == 0)
    lastMode = band_value;
}
function updateChan()
{
 var idx_value= document.form2WizardStep54.wizardstep54_band.selectedIndex;
 var band_value= document.form2WizardStep54.wizardstep54_band.options[idx_value].value;
    currentBand = 1;
 if(band_value==9 || band_value==10 || band_value==7){
  updateChan_channebound();
 }
 else {
  if (lastBand != currentBand) {
     lastBand = currentBand;
     if (currentBand == 2)
    showChannel5G();
     else
    showChannel2G(0, band_value);
  }
  else {
   {
    showChannel2G(0, band_value);
   }
  }
 }
 lastMode = band_value;
  if (document.form2WizardStep54.wizardstep54_chanwid.selectedIndex == 0)
   disableCheckBox(document.form2WizardStep54.elements.wizardstep54_ctlband);
  else
   enableCheckBox(document.form2WizardStep54.elements.wizardstep54_ctlband);
  if (document.form2WizardStep54.wizardstep54_band.selectedIndex == 0||
   document.form2WizardStep54.wizardstep54_band.selectedIndex == 1||
   document.form2WizardStep54.wizardstep54_band.selectedIndex == 2){
  }
  else if (document.form2WizardStep54.wizardstep54_band.selectedIndex == 3||
   document.form2WizardStep54.wizardstep54_band.selectedIndex == 4||
   document.form2WizardStep54.wizardstep54_band.selectedIndex == 5){
  }
}
function disableWLAN()
{
  disableTextField(document.form2WizardStep54.wizardstep54_ssid);
  disableTextField(document.form2WizardStep54.wizardstep54_chan);
  disableTextField(document.form2WizardStep54.wizardstep54_band);
  disableTextField(document.form2WizardStep54.wizardstep54_chanwid);
  disableTextField(document.form2WizardStep54.wizardstep54_ctlband);
  disableRadioGroup(document.form2WizardStep54.wizardstep54_sec);
  disableTextField(document.form2WizardStep54.show_wizardstep54_pskpwd);
}
function enableWLAN()
{
  enableTextField(document.form2WizardStep54.wizardstep54_ssid);
  enableTextField(document.form2WizardStep54.wizardstep54_chan);
  enableTextField(document.form2WizardStep54.wizardstep54_band);
  enableTextField(document.form2WizardStep54.wizardstep54_chanwid);
  enableTextField(document.form2WizardStep54.wizardstep54_ctlband);
  enableRadioGroup(document.form2WizardStep54.wizardstep54_sec);
  enableTextField(document.form2WizardStep54.show_wizardstep54_pskpwd);
}
function updateIputState()
{
  if (document.form2WizardStep54.wizardstep54_wlanDisabled.checked == true) {
   document.form2WizardStep54.wizardstep54_wlanDisabled.value="ON";
  disableWLAN();
  } else {
   document.form2WizardStep54.wizardstep54_wlanDisabled.value="OFF";
   enableWLAN();
  }
  if (document.form2WizardStep54.wizardstep54_chanwid.selectedIndex == 0)
   disableCheckBox(document.form2WizardStep54.elements.wizardstep54_ctlband);
  else if (document.form2WizardStep54.wizardstep54_wlanDisabled.checked == false)
   enableCheckBox(document.form2WizardStep54.elements.wizardstep54_ctlband);
  if (document.form2WizardStep54.wizardstep54_band.selectedIndex == 0||
   document.form2WizardStep54.wizardstep54_band.selectedIndex == 1||
   document.form2WizardStep54.wizardstep54_band.selectedIndex == 2){
  }
  else if (document.form2WizardStep54.wizardstep54_band.selectedIndex == 3||
   document.form2WizardStep54.wizardstep54_band.selectedIndex == 4||
   document.form2WizardStep54.wizardstep54_band.selectedIndex == 5){
  }
  updateChan_channebound();
  encodeSelection();
}

function saveChanges()
{
 //if(!checkSpecialCharExcludeSpace(document.form2WizardStep54.wizardstep54_ssid.value,1))
 if(includeSpecialKey(document.form2WizardStep54.wizardstep54_ssid.value))
 {
	alert('无效的SSID! 不可以使用"|$@"\<>"这些特殊字元。');
    document.form2WizardStep54.wizardstep54_ssid.focus();
  return false;
 }
 if (document.form2WizardStep54.wizardstep54_sec[1].checked)
 {
  var str = document.form2WizardStep54.show_wizardstep54_pskpwd.value;
  if (str.length != 64)
  {
   if (str.length < 8)
   {
    alert('预共享密钥至少 8 个字符.');
    document.form2WizardStep54.show_wizardstep54_pskpwd.focus();
    return false;
   }
   if (str.length > 63)
   {
    alert('预共享密钥最多 63 个字符.');
    document.form2WizardStep54.show_wizardstep54_pskpwd.focus();
    return false;
   }
   /*if(!isValidWPAPasswd(str))
   {
     alert('预共享密钥中含有无效字符.不能包含\\\'"特殊字符');
    return false;
   }*/
   if(includeSpecialKey(str))
   {
    alert('预共享密码中含有无效字符.不能包含"|$@"\<>"特殊字符');
    return false;
   }
   if(includeChinese(str))
   {
    alert('预共享密码中含有无效字符.不能包含中文字符');
    return false;
   }
   document.form2WizardStep54.wizardstep54_pskFormat.value=0;
  }
  else
  {
   for (var i=0; i<str.length; i++)
   {
    if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') ||
    (str.charAt(i) >= 'a' && str.charAt(i) <= 'f') ||
    (str.charAt(i) >= 'A' && str.charAt(i) <= 'F') )
     continue;
    alert("无效的预共享密钥.请输入十六进制数字(0-9 或 a-f).");
    document.form2WizardStep54.show_wizardstep54_pskpwd.focus();
    return false;
   }
   document.form2WizardStep54.wizardstep54_pskFormat.value=1;
  }
 }
 if (document.form2WizardStep54.show_wizardstep54_pskpwd.value != "")
 {
	document.form2WizardStep54.wizardstep54_pskpwd.value = Base64.Encode(document.form2WizardStep54.show_wizardstep54_pskpwd.value);
 }
 document.form2WizardStep54.show_wizardstep54_pskpwd.disabled = true;
 
 return true;
}
function updateChanWidth()
{
   if (document.form2WizardStep54.wizardstep54_chanwid.selectedIndex == 0)
   disableCheckBox(document.form2WizardStep54.elements.wizardstep54_ctlband);
   else
   enableCheckBox(document.form2WizardStep54.elements.wizardstep54_ctlband);
   updateChan_channebound();
}

function InitValue()
{
	if ( "<% getWPAEncode5g(1, "WPAPSK1"); %>" != "")
	{
		document.form2WizardStep54.show_wizardstep54_pskpwd.value = Base64.Decode("<% getWPAEncode5g(1, "WPAPSK1"); %>");
	}
}
</script>
</head>
<body onload="InitValue()">
<div class="login">
<table class="productInfo" border="0" cellpadding="0" cellspacing="0" width="100%">
 <tr>
  <td align="left" height="30" bgcolor="#404343" colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;产品页面:
<script>
  document.write(ModemVer);
</script>
  </td>
  <td align="right" height="30" bgcolor="#404343" colspan="2">硬件版本:
<script>
  document.write(HardwareVer);
</script>
&nbsp;&nbsp;&nbsp;&nbsp;固件版本:
<script>
  document.write(FirmwareVer);
</script>
  &nbsp;&nbsp;&nbsp;&nbsp;
  </td>
 </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
 <tr>
  <td align="left"><a href="http://www.dlink.com.cn/" target="_blank"><img src="d_head_01.gif" border="0"></a></td>
  <td background="d_head_02.gif" width="600"></td>
  <td align="right"><img src="d_head_03.gif"></td>
 </tr>
</table>
<br>
<br>
<br>
<form action="/goform/form2WizardStep54.cgi" method=POST name="form2WizardStep54">
<table width="502" cellspacing="0" cellpadding="0" border="0" align="center" class="setting_table">
 <tbody>
  <tr>
   <td width="500" valign="middle" align="left" class="wizard_title">
    &nbsp&nbsp设置向导 - 无线设置 5.8GHz
   </td>
  </tr>
  <tr>
   <td colspan="2">
    <table width="502" cellspacing="0" cellpadding="0" border="0">
     <tbody>
      <tr>
       <td colspan="2">
        <br>
        <table width="430" align="center" cellspacing="0" cellpadding="0" border="0" class="space">
         <tbody>
          <tr>
           <td colspan="2">
            本向导页面设置路由器无线网络的基本参数以及无线安全。
           </td>
          </tr>
         </tbody>
        </table>
        <table width="430" align="center" border="0" class="space">
         <tbody>
          <tr>
           <td class=form_label_left>禁用无线
           </td>
           <td class=form_label_right>
            <script>
				var radio_off = '<% getCfg2Zero(1, "RadioOff"); %>';
				var radio_str = (radio_off=="0"?"OFF":"ON");
				if(radio_off=="0"){
					dw("<input type=\"checkbox\" name=\"wizardstep54_wlanDisabled\" value=\"" + radio_str + "\" ONCLICK=\"updateIputState()\">");
				}else{
					dw("<input type=\"checkbox\" name=\"wizardstep54_wlanDisabled\" value=\"" + radio_str + "\" ONCLICK=\"updateIputState()\" checked>");
				}
			</script>      
           </td>
          </tr>
          <tr>
           <td class=form_label_left>SSID:</td>
           <td class=form_label_right><input type=text name="wizardstep54_ssid" size="25" maxlength="32"
value="<% getCfg2ToHTML(1, "SSID1"); %>">
           </td>
          </tr>
          <tr style="display:none">
           <td>
            <input type="hidden" name="wizardstep54_domain" value="">
           </td>
          </tr>
          <tr style="display:none">
           <td class=form_label_left>信道:</td>
           <td class=form_label_right>
            <select size="1" name="wizardstep54_chan"> 
				<option value="0" id="basicFreqAAuto"><#AutoSelect#></option>
				<% getInic11aChannels(); %>
			</select>
           </td>
          </tr>
          <tr style="display:none">
           <td class=form_label_left>模式:</td>
           <td class=form_label_right><select size=1 name="wizardstep54_band" onChange="updateChan()">
            </select>
           </td>
          </tr>
          <tr style="display:none">
           <td class=form_label_left>带宽:</td>
           <td class=form_label_right><select size="1" name="wizardstep54_chanwid" onChange="updateChanWidth()">
            <option value="0">20M</option>
            <option value="1">Auto 20/40M</option>
            </select>
           </td>
          </tr>
          <tr style="display:none">
           <td class=form_label_left>控制边带:</td>
           <td class=form_label_right><select size="1" name="wizardstep54_ctlband" onChange="updateChan_channebound()">
            <option value="0">高</option>
            <option value="1">低</option>
            </select>
           </td>
          </tr>
          <SCRIPT>
regDomain=3;
defaultChan=0;
          // updateChan();
          </SCRIPT>
         </tbody>
        </table>
        <table width="430" align="center" cellspacing="0" cellpadding="2" border="0" class="space">
         <tbody>
          <tr>
           <td>&nbsp;</td>
          </tr>
          <tr>
           <td id="t_rate" class="Item" colspan="2">
            无线安全选项：
           </td>
          </tr>
          <tr>
           <td class="Item" colspan="2">
            <p style="color:red">为保障网络安全，强烈推荐开启无线安全，并使用WPA-PSK/WPA2-PSK AES加密方式。
            </p>
           </td>
          </tr>
          <tr>
           <tr>
            <td class=form_label_left><input type="radio" value="0" name="wizardstep54_sec" onClick="encodeSelection()"></td>
             <td class=form_label_right>不开启无线安全</td>
           </tr>
           <tr>
            <td class=form_label_left><input type="radio" value="1" checked name="wizardstep54_sec" onClick="encodeSelection()"></td>
             <td class=form_label_right>WPA-PSK/WPA2-PSK AES</td>
           </tr>
           <tr style="display:none">
            <td class=form_label_left>预共享密钥形式:</td>
            <td class=form_label_right><select size="1" name="wizardstep54_pskFormat">
             <option value=0 >密文</option>
             <option value=1 >十六进制 (64 characters)</option>
             </select>
            </td>
           </tr>
           <tr>
            <td class=form_label_left>PSK密码:</td>
            <td class=form_label_right><input type=text name="show_wizardstep54_pskpwd" size="25" maxlength="64" value=""> (8-63个字符或者64个十六进制数字)
			<input type="hidden" name="wizardstep54_pskpwd" size="25" maxlength="64" value="">
            </td>
           </tr>
          </tr>
         </tbody>
        </table>
        <table width="430" align="center" border="0" id="showReboot" class="space"
        style="display: none;">
        </table>
        <br>
       </td>
      </tr>
      <tr>
       <td width="224" height="30" class="wizard_tail">&nbsp;
        
       </td>
       <td width="276" align="right" class="wizard_tail">
        <input type="submit" name="wizardstep54_back" value="上一步">
        &nbsp;
        <input type="submit" name="wizardstep54_next" value="下一步" onClick="return saveChanges()">
        &nbsp;
        <input type="hidden" name="submit.htm?d_wizard_step4_wifi.asp" value="Send">
       </td>
      </tr>
     </tbody>
    </table>
   </td>
  </tr>
 </tbody>
</table>
<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
</form>
<br>
<br>
<br>
<div class="loginBottom">
</div>
<div class="copywright">
2008-2017 D-Link公司，版权所有。</div>
</div>
<script>
var PhyMode  = '<% getCfg2Zero(1, "WirelessMode"); %>';
	PhyMode = 1*PhyMode;

	if (PhyMode >= 8)
	{
	}
	var wmode_len = document.form2WizardStep54.wizardstep54_band.length;
	var Gband = "<% getRaixGBand(); %>";
	if (Gband == "1")
	{
		document.form2WizardStep54.wizardstep54_band.options[wmode_len] = new Option("11b/g mixed mode", "0");
                document.form2WizardStep54.wizardstep54_band.options[wmode_len+1] = new Option("11b only", "1");
		document.form2WizardStep54.wizardstep54_band.options[wmode_len+2] = new Option("11g only", "4");
                document.form2WizardStep54.wizardstep54_band.options[wmode_len+3] = new Option("11b/g/n mixed mode", "9");
		wmode_len = document.form2WizardStep54.wizardstep54_band.length;
	}
	var Aband = "<% getRaixABand(); %>";
	if (Aband == "1")
	{
		document.form2WizardStep54.wizardstep54_band.options[wmode_len] = new Option("11a only", "2");
                document.form2WizardStep54.wizardstep54_band.options[wmode_len+1] = new Option("11a/n mixed mode", "8");
		wmode_len = document.form2WizardStep54.wizardstep54_band.length;
	}
	var AC = "<% getRaixAC(); %>";
	if (AC == "1")
	{
		document.form2WizardStep54.wizardstep54_band.options[wmode_len] = new Option("11vht AC/AN/A", "14");
                document.form2WizardStep54.wizardstep54_band.options[wmode_len+1] = new Option("11vht AC/AN", "15");
		wmode_len = document.form2WizardStep54.wizardstep54_band.length;
	}

	for (var i=0; i<wmode_len; i++) {
		if (PhyMode == document.form2WizardStep54.wizardstep54_band.options[i].value) {
			document.form2WizardStep54.wizardstep54_band.selectedIndex = i;
			break;
		}
		document.form2WizardStep54.wizardstep54_band.selectedIndex = 0;
	}
	
var WirelessMode = "<% getCfg2Zero(1, "WirelessMode"); %>";
document.form2WizardStep54.wizardstep54_band.value = Number(WirelessMode); //模式:
document.form2WizardStep54.wizardstep54_pskFormat.value = 0;

//var channel_index  = '<% getWlanChannel(); %>';
//document.form2WizardStep54.wizardstep54_chan.selectedIndex = channel_index;

var ht_bw = '<% getCfg2Zero(1, "HT_BW"); %>';
var ht_2040_coexit = '<% getCfg2Zero(1, "HT_BSSCoexistence"); %>';

var HT_BW = "<% getCfg2Zero(1, "HT_BW"); %>";
var HW_2040_COEXIT = '<% getCfg2Zero(1, "HT_BSSCoexistence"); %>';
document.form2WizardStep54.wizardstep54_chanwid.value = Number(HT_BW); //带宽:
document.form2WizardStep54.wizardstep54_ctlband.value = 0;

var AuthMode = "<% getCfg2General(1, "AuthMode"); %>";
var EncrypType = "<% getCfg2General(1, "EncrypType"); %>";
if(AuthMode == "OPEN" && EncrypType == "NONE" ){
	document.form2WizardStep54.wizardstep54_sec[0].checked = true; //开启无线安全
}else{
	document.form2WizardStep54.wizardstep54_sec[1].checked = true; //开启无线安全
}
document.form2WizardStep54.wizardstep54_domain.value = 1;
defPskLen = document.form2WizardStep54.show_wizardstep54_pskpwd.value.length;
defPskFormat = document.form2WizardStep54.wizardstep54_pskFormat.selectedIndex;
updateIputState();
encodeSelection();
</script>
</body>
</html>

