<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<title>无线局域网基本设置</title>

<style>

.on {display:on}
.off {display:none}
</style>

<SCRIPT>

var PreambleValue=0;
PreambleValue=0;
var wpsEnabled2g = '<% getCfgGeneral(1, "WscModeOption"); %>';

var regDomain, defaultChan, lastBand=0, lastMode=0, WiFiTest=0;

var regDomainList = new Array();

var wepkeys64_key1 = new Array();
var wepkeys64_key2 = new Array();
var wepkeys64_key3 = new Array();
var wepkeys64_key4 = new Array();
var wepkeys128_key1 = new Array();
var wepkeys128_key2 = new Array();
var wepkeys128_key3 = new Array();
var wepkeys128_key4 = new Array();
if ('<% getCfgGeneral(1, "encode_Key1Str1"); %>' != '')
{
	wepkeys64_key1[0] = Base64.Decode('<% getCfgGeneral(1, "encode_Key1Str1"); %>');
}
else
{
	wepkeys64_key1[0] = '';
}
if ('<% getCfgGeneral(1, "encode_Key2Str1"); %>' != '')
{
	wepkeys64_key2[0] = Base64.Decode('<% getCfgGeneral(1, "encode_Key2Str1"); %>');
}
else
{
	wepkeys64_key2[0] = '';
}

if ('<% getCfgGeneral(1, "encode_Key3Str1"); %>' != '')
{
	wepkeys64_key3[0] = Base64.Decode('<% getCfgGeneral(1, "encode_Key3Str1"); %>');
}
else
{
	wepkeys64_key3[0] = '';
}
if ('<% getCfgGeneral(1, "encode_Key4Str1"); %>' != '')
{
	wepkeys64_key4[0] = Base64.Decode('<% getCfgGeneral(1, "encode_Key4Str1"); %>');
}
else
{
	wepkeys64_key4[0] = '';
}


if ('<% getCfgGeneral(1, "encode_Key1Str1"); %>' != '')
{
	wepkeys128_key1[0] = Base64.Decode('<% getCfgGeneral(1, "encode_Key1Str1"); %>');
}
else
{
	wepkeys128_key1[0] ='';
}

if ('<% getCfgGeneral(1, "encode_Key2Str1"); %>' != '')
{
	wepkeys128_key2[0] = Base64.Decode('<% getCfgGeneral(1, "encode_Key2Str1"); %>');
}
else
{
	wepkeys128_key2[0]='';
}

if ('<% getCfgGeneral(1, "encode_Key3Str1"); %>' != '')
{
	wepkeys128_key3[0] = Base64.Decode('<% getCfgGeneral(1, "encode_Key3Str1"); %>');
}
else
{
	wepkeys128_key3[0]='';
}

if ('<% getCfgGeneral(1, "encode_Key4Str1"); %>' != '')
{
	wepkeys128_key4[0] = Base64.Decode('<% getCfgGeneral(1, "encode_Key4Str1"); %>');
}
else
{
	wepkeys128_key4[0]='';
}

wepkeys64_key1[1]="";
wepkeys64_key2[1]="";
wepkeys64_key3[1]="";
wepkeys64_key4[1]="";
wepkeys128_key1[1]="";
wepkeys128_key2[1]="";
wepkeys128_key3[1]="";
wepkeys128_key4[1]="";
wepkeys64_key1[2]="";
wepkeys64_key2[2]="";
wepkeys64_key3[2]="";
wepkeys64_key4[2]="";
wepkeys128_key1[2]="";
wepkeys128_key2[2]="";
wepkeys128_key3[2]="";
wepkeys128_key4[2]="";
wepkeys64_key1[3]="";
wepkeys64_key2[3]="";
wepkeys64_key3[3]="";
wepkeys64_key4[3]="";
wepkeys128_key1[3]="";
wepkeys128_key2[3]="";
wepkeys128_key3[3]="";
wepkeys128_key4[3]="";
wepkeys64_key1[4]="";
wepkeys64_key2[4]="";
wepkeys64_key3[4]="";
wepkeys64_key4[4]="";
wepkeys128_key1[4]="";
wepkeys128_key2[4]="";
wepkeys128_key3[4]="";
wepkeys128_key4[4]="";
wepkeys64_key1[5]="";
wepkeys64_key2[5]="";
wepkeys64_key3[5]="";
wepkeys64_key4[5]="";
wepkeys128_key1[5]="";
wepkeys128_key2[5]="";
wepkeys128_key3[5]="";
wepkeys128_key4[5]="";


 function isValidWPAPasswd(str)
{

 var patrn=/^[a-zA-Z0-9!#$%&()*+,-./:;=?@[\]^_`{|}~<>]{1}[a-zA-Z0-9!#$%&()*+,-./:;=?@[\]^_`{|}~<>\x20]{6,62}[a-zA-Z0-9!#$%&()*+,-./:;=?@[\]^_`{|}~<>]{1}$/;
 if (!patrn.exec(str)) return false ;

 if(str.indexOf("  ") != -1)
  return false;

 return true;
}

function validateWepKey(idx, str)
{
 if (document.wlanBasicSetup.defaultTxKeyId[idx].checked ==true && str.length==0) {
  idx++;
  alert('您所选择的\'密钥 ' + idx + '\'不能为空.');
  return 0;
 }
 if (str.length ==0)
  return 1;

 var keylen;
 if(document.wlanBasicSetup.length.selectedIndex == 0){

  if ( str.length == 5) {

   document.wlanBasicSetup.format.value = 1;
   keylen = 5;
  }else if ( str.length == 10) {

   document.wlanBasicSetup.format.value = 0;
   keylen = 10;
  }else {
   idx++;
   alert('无效的密钥长度 ' + idx + ' . 请输入 5个ASCII 字符或者10个十六进制数字(0-9 或 a-f)..');
   return 0;
  }
 }else{

  if ( str.length == 13) {

   document.wlanBasicSetup.format.value = 1;
   keylen = 13;
  }else if ( str.length == 26) {

   document.wlanBasicSetup.format.value = 0;
   keylen = 26;
  }else {
   idx++;
   alert('无效的密钥长度 ' + idx + ' . 请输入 13个ASCII 字符或者26个十六进制数字(0-9 或 a-f)..');
   return 0;
  }
 }

 if ( str == "*****" ||
  str == "**********" ||
  str == "*************" ||
  str == "**************************" )
  return 1;

 if (document.wlanBasicSetup.format.value == 1)
 {

  var patrn=/^[a-zA-Z0-9!#$%&()*+,-./:;=@[\]^_`{|}~<>]{1}[a-zA-Z0-9!#$%&()*+,-./:;=@[\]^_`{|}~<>\x20]*[a-zA-Z0-9!#$%&()*+,-./:;=@[\]^_`{|}~<>]{1}$/;

  if (!patrn.exec(str)) {
   alert('无效的字符!不能包含\\\'"? 特殊字符');
   return 0 ;
  }
  if(str.indexOf("  ",0)!=-1)
  {
   alert("密钥中不能包含一个以上连续空格!");
   return 0;
  }

  return 1;
 }

 for (var i=0; i<str.length; i++) {
  if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') ||
   (str.charAt(i) >= 'a' && str.charAt(i) <= 'f') ||
   (str.charAt(i) >= 'A' && str.charAt(i) <= 'F') )
   continue;

  alert("无效的密钥.请输入十六进制数字(0-9 或 a-f).");
  return 0;
 }

 return 1;
}

function saveChanges()
{

 if(document.wlanBasicSetup.hiddenSSID.checked == false){
  if ( wpsEnabled2g != '0')
   {
   	if (confirm("禁用SSID广播, WPS 功能将会被自动禁用.\n确定要修改吗?") == 0)
	{
		return false;
	}
 }
 else
 {
	if (confirm("禁用SSID广播.\n确定要修改吗?") == 0)
	{
		return false;
	}
  }
 }

// if(getStringByteCount(document.wlanBasicSetup.ssid.value) > 32)
 if(document.wlanBasicSetup.ssid.value.length ==0 || document.wlanBasicSetup.ssid.value.length > 32)
 {
  alert('SSID长度不得超过32!');
  document.wlanBasicSetup.ssid.focus();
  return false;
 }
 if(includeSpecialKey(document.wlanBasicSetup.ssid.value))
 {
	alert('无效的SSID! 不可以使用"|$@"\<>"这些特殊字元。');
    document.wlanBasicSetup.ssid.focus();
  return false;
 }
 var band;
 if (document.wlanBasicSetup.band.selectedIndex == 0)
  band = 1;
 else if (document.wlanBasicSetup.band.selectedIndex == 1)
  band = 2;
 else if (document.wlanBasicSetup.band.selectedIndex == 2)
  band = 3;
 else if (document.wlanBasicSetup.band.value == 7)
  band = 8;
 else if (document.wlanBasicSetup.band.value == 9)
  band = 10;
 else if (document.wlanBasicSetup.band.value == 10)
  band = 11;
 else
  band = 4;

 basicRate=0;
 operRate=0;
 if (band & 1) {
  basicRate|=0xf;
  operRate|=0xf;
 }
 if ( (band & 2) || (band & 4) ) {
  operRate|=0xff0;
  if (!(band & 1)) {
   if (WiFiTest)
    basicRate=0x15f;
   else
    basicRate=0x1f0;
  }
 }
 if (band & 8) {
  if (!(band & 3))
   operRate|=0xfff;
  if (band & 1)
   basicRate=0xf;
  else if (band & 2)
   basicRate=0x1f0;
  else
   basicRate=0xf;
 }
 operRate|=basicRate;

 document.wlanBasicSetup.basicrates.value = basicRate;
 document.wlanBasicSetup.operrates.value = operRate;

 if(document.wlanBasicSetup.checkWPS2.value != 0){
  if(document.wlanBasicSetup.method.selectedIndex != document.wlanBasicSetup.method_cur.value){
  if ( document.wlanBasicSetup.band.options[document.wlanBasicSetup.band.selectedIndex].value != 6 )
  {
   if (document.wlanBasicSetup.method.selectedIndex == 1){
    if (confirm("加密模式设置为WEP ,WPS 功能将会被自动禁用.\n确定要修改吗?") == 0){
     return false;
    }
   }else if (document.wlanBasicSetup.method.selectedIndex == 2){
    if (confirm("加密模式设置为WPA-TKIP, WPS 功能将会被自动禁用.\n确定要修改吗?") == 0){
     return false;
    }
   }
  }
  }
 }

 if (document.wlanBasicSetup.method.selectedIndex>=2 || (document.wlanBasicSetup.band.options[document.wlanBasicSetup.band.selectedIndex].value == 6 && document.wlanBasicSetup.method.selectedIndex > 0)) {
  var str = document.wlanBasicSetup.tmppskValue.value;
  if (str.length != 64) {

   if (str.length < 8) {
    alert('预共享密钥至少 8 个字符.');
    document.wlanBasicSetup.tmppskValue.focus();
    return false;
   }
   if (str.length > 63) {
    alert('预共享密钥最多 63 个字符.');
    document.wlanBasicSetup.tmppskValue.focus();
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
   document.wlanBasicSetup.pskFormat.value=0;
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
    document.wlanBasicSetup.tmppskValue.focus();
    return false;
   }

   document.wlanBasicSetup.pskFormat.value=1;
  }
 }
	if (document.wlanBasicSetup.tmppskValue.value != "")
	{
		var EncodePs = Base64.Encode(document.wlanBasicSetup.tmppskValue.value);
		document.wlanBasicSetup.pskValue.value = EncodePs;
	}

 if (document.wlanBasicSetup.band.options[document.wlanBasicSetup.band.selectedIndex].value != 6)
 {
 if (document.wlanBasicSetup.method.selectedIndex ==1)
 {
  if ( document.wlanBasicSetup.defaultTxKeyId[0].checked ==true){
   if(validateWepKey(0,document.wlanBasicSetup.show_key1.value)==0) {
    document.wlanBasicSetup.show_key1.focus();
    return false;
   }
  }
  if ( document.wlanBasicSetup.defaultTxKeyId[1].checked ==true){
   if (validateWepKey(1,document.wlanBasicSetup.show_key2.value)==0) {
    document.wlanBasicSetup.show_key2.focus();
    return false;
   }
  }
  if ( document.wlanBasicSetup.defaultTxKeyId[2].checked ==true){
   if (validateWepKey(2,document.wlanBasicSetup.show_key3.value)==0) {
    document.wlanBasicSetup.show_key3.focus();
    return false;
   }
  }
  if ( document.wlanBasicSetup.defaultTxKeyId[3].checked ==true){
   if (validateWepKey(3,document.wlanBasicSetup.show_key4.value)==0) {
    document.wlanBasicSetup.show_key4.focus();
    return false;
   }
  }
 }
 }

 //hidden
 for (var i=1; i<=4; i++)
 {
  var hidden_radiogroup = document.wlanBasicSetup.defaultTxKeyId;
  var hidden_keyfiled = document.getElementById('key'+i);
  var keyfiled = document.getElementById('show_key'+i);

  if(hidden_radiogroup[i-1].checked==true)
  {
   enableTextField(hidden_keyfiled);
   if ( keyfiled.value != '')
   {
	hidden_keyfiled.value  = Base64.Encode(keyfiled.value);
   }
  }
  else
  {
   disableTextField(hidden_keyfiled);
  }
  
  disableTextField(keyfiled);
 }

	document.wlanBasicSetup.tmppskValue.disabled = true;
	
	create_backmask();
	document.getElementById("loading").style.display="";
 return true;
}

function updateTxRate()
{
band=11;
txrate=1;
auto=1;
rf_num=2;


 if (document.wlanBasicSetup.band.selectedIndex == 0)
  band = 1;
 else if (document.wlanBasicSetup.band.selectedIndex == 1)
  band = 2;
 else if (document.wlanBasicSetup.band.selectedIndex == 2)
  band = 3;
 else if (document.wlanBasicSetup.band.value == 7)
  band = 8;
 else if (document.wlanBasicSetup.band.value == 9)
  band = 10;
 else if (document.wlanBasicSetup.band.value == 10)
  band = 11;
 else
  band = 4;


 var txRateOption = document.wlanBasicSetup.txRate;
 txRateOption.options.length = 0;

 rate_mask = [15,1,1,1,1,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,8,8,8,8,8,8,8,8];

 rate_name_s_40 =["Auto","1M","2M","5.5M","11M","6M","9M","12M","18M","24M","36M","48M","54M", "15M","30M","45M","60M","90M","120M","135M","150M","30M","60M","90M","120M","180M","240M","270M","300M"];
 rate_name_l_40 =["Auto","1M","2M","5.5M","11M","6M","9M","12M","18M","24M","36M","48M","54M", "13.5M","27M","40.5M","54M","81M","108M","121.5M","135M","27M","54M","81M","108M","162M","216M","243M","270M"];
 rate_name_s_20 =["Auto","1M","2M","5.5M","11M","6M","9M","12M","18M","24M","36M","48M","54M", "7.2M","14.4M","21.7M","28.9M","43.3M","57.8M","65M","72.2M","14.4M","28.9M","43.3M","57.8M","86.7M","115.6M","130M","144.4M"];
 rate_name_l_20 =["Auto","1M","2M","5.5M","11M","6M","9M","12M","18M","24M","36M","48M","54M", "6.5M","13M","19.5M","26M","39M","52M","58.5M","65M","13M","26M","39M","52M","78M","104M","117M","130M"];


 rate_option_enable=[1,0,0,0,1,0,0,0,0,0,0,0,1, 0, 0,
  0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1];
 mask=0;
 if(PreambleValue == '0' && document.wlanBasicSetup.chanwid.selectedIndex == 1)
 {
  rate_name = rate_name_s_40;
 }
 else if(PreambleValue == '1' && document.wlanBasicSetup.chanwid.selectedIndex == 1)
 {
  rate_name = rate_name_l_40;
 }
 else if(PreambleValue == '0' && document.wlanBasicSetup.chanwid.selectedIndex == 0)
 {
  rate_name = rate_name_s_20;
 }
 else if(PreambleValue == '1' && document.wlanBasicSetup.chanwid.selectedIndex == 0)
 {
  rate_name = rate_name_l_20;
 }

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
 var optionindex=0;
 for (idx=0, i=0; i<=28; i++) {
  if (rate_mask[i] & mask) {
   if (i == 0)
    rate = 0;
   else
    rate = (1 << (i-1));
   if (txrate == rate)
   {

    defidx = optionindex;
   }


   if(rate_option_enable[i])
   {
    txRateOption.options.add(new Option(rate_name[i], i));
    optionindex++
   }
   idx++;
  }
 }
 document.wlanBasicSetup.txRate.selectedIndex=defidx;
}

function updateIputState()
{
 if (document.wlanBasicSetup.band.selectedIndex == 0||
  document.wlanBasicSetup.band.selectedIndex == 1||
  document.wlanBasicSetup.band.selectedIndex == 2){

  document.wlanBasicSetup.chanwid.selectedIndex = 0;
  disableTextField(document.wlanBasicSetup.chanwid);
 }
 else if (document.wlanBasicSetup.band.selectedIndex == 3||
  document.wlanBasicSetup.band.selectedIndex == 4||
  document.wlanBasicSetup.band.selectedIndex == 5){

  enableTextField(document.wlanBasicSetup.chanwid);
 }

 updateTxRate();

 updateChan_channebound();

 checkState();
 updateFormat();
}

function showChannel5G()
{
 document.wlanBasicSetup.chan.length=0;

 for (idx=0, chan=36; chan<=64; idx++, chan+=4) {

  if (chan == defaultChan){
   document.wlanBasicSetup.chan.selectedIndex = idx;
   document.wlanBasicSetup.chan.options[idx] = new Option(chan, chan, true, false);
  }else{
   document.wlanBasicSetup.chan.options[idx] = new Option(chan, chan, false, false);
  }
 }
 document.wlanBasicSetup.chan.length = idx;
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

  if(document.wlanBasicSetup.domain.selectedIndex == 47){

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

 document.wlanBasicSetup.chan.length=0;
 idx=0;

 if (0 == defaultChan) {
  document.wlanBasicSetup.chan.selectedIndex = 0;
  document.wlanBasicSetup.chan.options[idx] = new Option("Auto", 0, true, true);
 }else{
  document.wlanBasicSetup.chan.options[idx] = new Option("Auto", 0, false, false);
 }
 idx++;

 for (chan=start; chan<=end; chan++, idx++) {

  if (chan == defaultChan){
   document.wlanBasicSetup.chan.options[idx] = new Option(chan, chan, true, true);
  }else{
   document.wlanBasicSetup.chan.options[idx] = new Option(chan, chan, false, false);
  }
  document.wlanBasicSetup.chan.selectedIndex = defaultChan;
 }
 document.wlanBasicSetup.chan.length = idx;
}

function change_band2g(band_value)
{
	var current_value = document.getElementById('methodSel').value;
	jsRemoveItemFromSelect();
	var objSelect = document.getElementById('methodSel');

	if (band_value == 6)
	{
		objSelect.options.add(new Option("WPA2-PSK(AES)", 4));
		objSelect.options.add(new Option("WPA-PSK/WPA2-PSK AES", 6));
		document.getElementById('methodSel').value = current_value;
		
		if (current_value == 1 || current_value == 2)
		{
			document.getElementById('methodSel').value = 0;
			document.getElementById('optionforwep').style.display = 'none';
			document.getElementById('optionforwpa').style.display = 'none';		
		}
		
		checkState();
	}
	else
	{	
		if (objSelect.options.length == 1 || objSelect.options[1].value != 1)
		{ 	
			objSelect.options.add(new Option("WEP", 1));
			objSelect.options.add(new Option("WPA-PSK(TKIP)", 2));
			objSelect.options.add(new Option("WPA2-PSK(AES)", 4));
			objSelect.options.add(new Option("WPA-PSK/WPA2-PSK AES", 6));
		}
		document.getElementById('methodSel').value = current_value;
		checkState();
	}
}

function updateChan()
{
 var idx_value= document.wlanBasicSetup.band.selectedIndex;
 var band_value= document.wlanBasicSetup.band.options[idx_value].value;
     currentBand = 1;
	 
	 change_band2g(band_value);
	 
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

 if (document.wlanBasicSetup.band.selectedIndex == 0||
  document.wlanBasicSetup.band.selectedIndex == 1||
  document.wlanBasicSetup.band.selectedIndex == 2){
   document.wlanBasicSetup.chanwid.selectedIndex = 0;
   disableTextField(document.wlanBasicSetup.chanwid);
 }
 else if (document.wlanBasicSetup.band.selectedIndex == 3||
  document.wlanBasicSetup.band.selectedIndex == 4||
  document.wlanBasicSetup.band.selectedIndex == 5){
   document.wlanBasicSetup.chanwid.selectedIndex = 1;
   enableTextField(document.wlanBasicSetup.chanwid);
 }

   updateTxRate();
}

function updateChan_channebound()
{
 var idx_value= document.wlanBasicSetup.band.selectedIndex;
 var band_value= document.wlanBasicSetup.band.options[idx_value].value;
 var bound = document.wlanBasicSetup.chanwid.selectedIndex;
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

 updateTxRate();
}

function updateChanWidth()
{
   updateChan_channebound();
}

function updateRegChan()
{
 regDomain = regDomainList[document.wlanBasicSetup.domain.selectedIndex];
 updateChan();
}

function WepKeyChange()
{
 for (var i=1; i<=4; i++)
 {
  var radiogroup = document.wlanBasicSetup.defaultTxKeyId;
  var keyfiled = document.getElementById('show_key'+i);

  if(radiogroup[i-1].checked==true){
   enableTextField(keyfiled);
  }else{
   disableTextField(keyfiled);
  }
 }
}

function checkState()
{
 var obj_method = document.wlanBasicSetup.method;
 var key_value = obj_method.options[obj_method.selectedIndex].value;
 
 var idx_value= document.wlanBasicSetup.band.selectedIndex;
 var band_value= document.wlanBasicSetup.band.options[idx_value].value;
if (band_value == 6)
{
	document.getElementById('optionforwpa').style.display = (document.wlanBasicSetup.method.selectedIndex>=1)? '':'none';
}
else
{
	document.getElementById('optionforwep').style.display = (document.wlanBasicSetup.method.selectedIndex==1)? '':'none';
	document.getElementById('optionforwpa').style.display = (document.wlanBasicSetup.method.selectedIndex>=2)? '':'none';
}
  WepKeyChange();
 document.getElementById('wpainfo1').style.display = 'none';
 document.getElementById('wpainfo2').style.display = 'none';
 document.getElementById('wpainfo3').style.display = 'none';
 if(key_value == 2 || key_value==3)
  document.getElementById('wpainfo1').style.display="";
 else if(key_value==4 || key_value==5)
  document.getElementById('wpainfo2').style.display="";
 else if(key_value==6)
  document.getElementById('wpainfo3').style.display="";
}

function lengthClick()
{
 if (document.wlanBasicSetup.length.selectedIndex==0){

  var keysize = 10;

  for (var i=1; i<=4; i++)
  {
   document.getElementById('key'+i).size =keysize + 2 ;

   if (document.getElementById('key'+i).value.length>10)
    document.getElementById('key'+i).value = document.getElementById('key'+i).value.substring(0,10);

   document.getElementById('key'+i).maxLength=10;
  }
 }else if (document.wlanBasicSetup.length.selectedIndex==1){

  var keysize = 26;

  for (var i=1; i<=4; i++)
  {
   document.getElementById('key'+i).size =keysize + 8 ;

   if (document.getElementById('key'+i).value.length>26)
    document.getElementById('key'+i).value = document.getElementById('key'+i).value.substring(0,26);

   document.getElementById('key'+i).maxLength=26;
  }
 }

 updateFormat();
}

function updateFormat()
{
 if (document.wlanBasicSetup.length.selectedIndex == 0) {
  document.wlanBasicSetup.format.options[0].text = 'ASCII (5 字符)';
  document.wlanBasicSetup.format.options[1].text = '十六进制 (10 字符)';
 }
 else {
  document.wlanBasicSetup.format.options[0].text = 'ASCII (13 字符)';
  document.wlanBasicSetup.format.options[1].text = '十六进制 (26 字符)';
 }

 setDefaultKeyValue();
}

function setDefaultKeyValue()
{
 var idx = 0;

 if (document.wlanBasicSetup.length.selectedIndex == 0) {
  document.wlanBasicSetup.show_key1.maxLength = 10;
  document.wlanBasicSetup.show_key2.maxLength = 10;
  document.wlanBasicSetup.show_key3.maxLength = 10;
  document.wlanBasicSetup.show_key4.maxLength = 10;

  document.wlanBasicSetup.show_key1.value = wepkeys64_key1[idx];
  document.wlanBasicSetup.show_key2.value = wepkeys64_key2[idx];
  document.wlanBasicSetup.show_key3.value = wepkeys64_key3[idx];
  document.wlanBasicSetup.show_key4.value = wepkeys64_key4[idx];
 }
   else {
  document.wlanBasicSetup.show_key1.maxLength = 26;
  document.wlanBasicSetup.show_key2.maxLength = 26;
  document.wlanBasicSetup.show_key3.maxLength = 26;
  document.wlanBasicSetup.show_key4.maxLength = 26;

  document.wlanBasicSetup.show_key1.value = wepkeys128_key1[idx];
  document.wlanBasicSetup.show_key2.value = wepkeys128_key2[idx];
  document.wlanBasicSetup.show_key3.value = wepkeys128_key3[idx];
  document.wlanBasicSetup.show_key4.value = wepkeys128_key4[idx];
   }
}

function resetClick()
{

 document.getElementById('optionforwep').style.display = (document.wlanBasicSetup.method_cur.value==1)? '':'none';
 WepKeyChange();

 document.getElementById('optionforwpa').style.display = (document.wlanBasicSetup.method_cur.value>=2)? '':'none';

 document.getElementById('wpainfo1').style.display=(document.wlanBasicSetup.method_cur.value)==2? '':'none';
 document.getElementById('wpainfo2').style.display=(document.wlanBasicSetup.method_cur.value)==4? '':'none';
 document.getElementById('wpainfo3').style.display=(document.wlanBasicSetup.method_cur.value)==6? '':'none';
}

function jsRemoveItemFromSelect()
{
	for (var i = 6; i > 0 ; i--)
	{
		document.getElementById('methodSel').options[i] = null;
	}
}

function InitValue()
{
	var mssid_num = 1; //ssid num
	var PhyMode  = '<% getCfgZero(1, "WirelessMode"); %>'; 
	var APIsolated = '<% getCfgZero(1, "NoForwarding"); %>';
	var HiddenSSID  = '<% getCfgZero(1, "HideSSID"); %>';
	var channel_index  = '<% getWlanChannel(); %>';
	var countrycode = '<% getCfgGeneral(1, "CountryCode"); %>';
	var ht_bw = '<% getCfgZero(1, "HT_BW"); %>';
	var AutoChannel = '<% getCfgZero(1, "AutoChannelSelect"); %>';
	var Channel = '<% getCfgZero(1, "Channel"); %>';
	var connectStatus = "<% GetConnectStatus(); %>";
	
	var defaultkeyid = '<% getCfgZero(1, "DefaultKeyID"); %>';

	var authmode = '<% getCfgGeneral(1, "AuthMode"); %>';
	var encrytype = '<% getCfgGeneral(1, "EncrypType"); %>';
	var pskvalue = '<% getWPAEncode2g(1, "WPAPSK1"); %>';

	var b = defaultkeyid.slice(0,1);
	var KeyType;
	var length;
	
	if ( pskvalue != '')
	{
		document.wlanBasicSetup.tmppskValue.value = Base64.Decode("<% getWPAEncode2g(1, "WPAPSK1"); %>");
	}
	
	var HiddenSSIDArray = HiddenSSID.split(";");
	for (i=0;i<mssid_num;i++)
	{
		if (HiddenSSIDArray[i] == "1")
			document.wlanBasicSetup.hiddenSSID.checked = false;
		else
			document.wlanBasicSetup.hiddenSSID.checked= true;
	}

	var APIsolatedArray = APIsolated.split(";");

	for (i=0;i<mssid_num;i++)
	{
	if (APIsolatedArray[i] == "1")
		document.wlanBasicSetup.block.checked = true;
	else
		document.wlanBasicSetup.block.checked = false;
	}

	document.wlanBasicSetup.band.value = PhyMode;
	regDomain=3;
	if (AutoChannel == "1" || AutoChannel == "2")
	{
		defaultChan = 0;
	}
	else
	{
		defaultChan	= Channel;
	}

	updateChan();

	//document.wlanBasicSetup.chan.value = channel_index;
	document.wlanBasicSetup.chanwid.value = ht_bw;
	
	if (authmode == "OPEN")
	{
		document.wlanBasicSetup.method.value = 0;	
	}
	else if (authmode == "SHARED")
	{
		document.wlanBasicSetup.authType.value = 1;
		document.wlanBasicSetup.method.value = 1;	
	}
	else if (authmode == "WEPAUTO")
	{
		document.wlanBasicSetup.authType.value = 2;
		document.wlanBasicSetup.method.value = 1;	
	}
	else if (authmode == "WPAPSK")
	{
		document.wlanBasicSetup.method.value = 2;	
	}
	else if (authmode == "WPA2PSK")
	{
		document.wlanBasicSetup.method.value = 4;	
	}
	else if (authmode == "WPAPSKWPA2PSK")
	{
		document.wlanBasicSetup.method.value = 6;	
	}

		
	if (b == "1")
	{
		document.wlanBasicSetup.defaultTxKeyId[0].checked = true;
		if ('<% getCfgGeneral(1, "encode_Key1Str1"); %>' != '')
		{
			KeyType = Base64.Decode('<% getCfgGeneral(1, "encode_Key1Str1"); %>');
			document.wlanBasicSetup.show_key1.value = KeyType;
		}
		else
		{
			KeyType = '';
		}
	}	
	else if (b == "2")
	{
		document.wlanBasicSetup.defaultTxKeyId[1].checked = true;
		if ('<% getCfgGeneral(1, "encode_Key2Str1"); %>' != '')
		{
			KeyType = Base64.Decode('<% getCfgGeneral(1, "encode_Key2Str1"); %>');
			document.wlanBasicSetup.show_key2.value = KeyType;
		}
		else
		{
			KeyType = '';
		}
	}
	else if (b == "3")
	{
		document.wlanBasicSetup.defaultTxKeyId[2].checked = true;
		if ('<% getCfgGeneral(1, "encode_Key3Str1"); %>' != '')
		{
			KeyType = Base64.Decode('<% getCfgGeneral(1, "encode_Key3Str1"); %>');
			document.wlanBasicSetup.show_key3.value = KeyType;
		}
		else
		{
			KeyType = '';
		}
	}
	else if (b == "4")
	{
		document.wlanBasicSetup.defaultTxKeyId[3].checked = true;
		if ('<% getCfgGeneral(1, "encode_Key4Str1"); %>' != '')
		{
			KeyType = Base64.Decode('<% getCfgGeneral(1, "encode_Key4Str1"); %>');
			document.wlanBasicSetup.show_key4.value = KeyType;
		}
		else
		{
			KeyType = '';
		}
	}
	else
	{
		document.wlanBasicSetup.defaultTxKeyId[0].checked = true;
		KeyType = "";
	}
	if(KeyType.length == 13 || KeyType.length == 26)
		document.wlanBasicSetup.length.value = 2;
	else
		document.wlanBasicSetup.length.value = 1;

	
	updateIputState();
	if(connectStatus == '1')
	{
		document.wlanBasicSetup.chan.disabled = true;	
	}
}

</SCRIPT>

</head>

<body onload="InitValue()">
<blockquote>
<script language="JavaScript">
 TabHeader="无线2.4G";
 SideItem="无线基本设置";
 HelpItem="wlanbasic";
</script>

<script type='text/javascript'>
 mainTableStart();
 logo();
 TopNav();
 ThirdRowStart();
 Write_Item_Images();
 mainBodyStart();
</script>

<form action="/goform/form2WlanBasicSetup.cgi" method=POST name="wlanBasicSetup">
 <table id=box_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>
    无线基本设置
   </td>
  </tr>

  <tr>
   <td class=content>
    <p>使用本节配置用于您的路由器的无线设置。注意，在这部分所做的更改需要复制到无线客户端。
为保护您的隐私，您可以配置无线安全特性。此设备支持3种无线安全模式，包括：WEP，WPA和WPA2。</p>
   </td>
  </tr>
 </table>


 <table id=body_header border=0 cellSpacing=0 style="display:none">
  <tr>
   <td class=topheader>区域选择
   </td>
  </tr>

  <tr>
   <td class=content>
    <table class=formarea border="0" cellpadding="0" cellspacing="0" width=100%>
     <tr>
     <td class=form_label_40>地区 ：</td>
     <td><select size="1" name="domain" onChange="updateRegChan()">
<option value="0">美国</option>
<option value="1" selected>中国</option>
<option value="2">中国(香港)</option>
<option value="3">中国(澳门)</option>
<option value="4">中国(台湾)</option>
<option value="5">日本</option>
<option value="6">欧洲</option>
<option value="7">安提瓜巴布达</option>
<option value="8">阿根廷</option>
<option value="9">阿鲁巴</option>
<option value="10">澳大利亚</option>
<option value="11">奥地利</option>
<option value="12">巴哈马</option>
<option value="13">孟加拉国</option>
<option value="14">巴巴多斯</option>
<option value="15">比利时</option>
<option value="16">百慕大</option>
<option value="17">玻利维亚</option>
<option value="18">巴西</option>
<option value="19">保加利亚</option>
<option value="20">加拿大</option>
<option value="21">开曼群岛</option>
<option value="22">智利</option>
<option value="23">哥伦比亚</option>
<option value="24">哥斯达黎加</option>
<option value="25">克罗地亚</option>
<option value="26">塞浦路斯</option>
<option value="27">捷克</option>
<option value="28">丹麦</option>
<option value="29">多米尼加共和国</option>
<option value="30">厄瓜多尔</option>
<option value="31">埃及</option>
<option value="32">萨尔瓦多</option>
<option value="33">爱沙尼亚</option>
<option value="34">芬兰</option>
<option value="35">法国</option>
<option value="36">德国</option>
<option value="37">希腊</option>
<option value="38">关岛</option>
<option value="39">危地马拉</option>
<option value="40">海地</option>
<option value="41">洪都拉斯</option>
<option value="42">匈牙利</option>
<option value="43">冰岛</option>
<option value="44">印度</option>
<option value="45">印度尼西亚</option>
<option value="46">爱尔兰</option>
<option value="47">以色列</option>
<option value="48">意大利</option>
<option value="49">约旦</option>
<option value="50">韩国</option>
<option value="51">拉脱维亚</option>
<option value="52">列支敦士登</option>
<option value="53">立陶宛</option>
<option value="54">卢森堡</option>
<option value="55">马来西亚</option>
<option value="56">马耳他</option>
<option value="57">墨西哥</option>
<option value="58">摩纳哥</option>
<option value="59">黑山共和国</option>
<option value="60">荷兰</option>
<option value="61">荷属安的列斯群岛</option>
<option value="62">新西兰</option>
<option value="63">尼加拉瓜</option>
<option value="64">尼日利亚</option>
<option value="65">挪威</option>
<option value="66">巴基斯坦</option>
<option value="67">巴拿马</option>
<option value="68">巴拉圭</option>
<option value="69">秘鲁</option>
<option value="70">菲律宾</option>
<option value="71">波兰</option>
<option value="72">葡萄牙</option>
<option value="73">罗马尼亚</option>
<option value="74">俄罗斯</option>
<option value="75">沙特阿拉伯</option>
<option value="76">塞尔维亚</option>
<option value="77">新加坡</option>
<option value="78">斯洛伐克</option>
<option value="79">斯洛文尼亚</option>
<option value="80">南非</option>
<option value="81">西班牙</option>
<option value="82">瑞典</option>
<option value="83">瑞士</option>
<option value="84">坦桑尼亚</option>
<option value="85">泰国</option>
<option value="86">突尼斯</option>
<option value="87">土耳其</option>
<option value="88">乌克兰</option>
<option value="89">阿拉伯联合酋长国</option>
<option value="90">英国</option>
<option value="91">乌拉圭</option>
<option value="92">委内瑞拉</option>
<option value="93">越南</option>
         </select>
     </td>
     </tr>
    </table>
   </td>
  </tr>
 </table>


 <table id=body_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>无线网络
   </td>
  </tr>

  <tr>
   <td class=content>
    <table id="basicSetup" class=formarea border="0" cellpadding="0" cellspacing="0" width=100%>
     <tr>
      <td class=form_label_40>启用SSID广播 ：</td>
      <td>
       <input type="checkbox" name="hiddenSSID" value="0" >
      </td>

     </tr>

     <tr>

      <td class=form_label_40>启用无线隔离 ：</td>

      <td>
       <input type="checkbox" name="block" value="1">
      </td>

     </tr>

     <tr>
      <td class=form_label_40>无线网络标识(SSID) ：</td>
      <td>
       <input type=text name=ssid size="25" maxlength="32" value="<% getCfgToHTML(1, "SSID1"); %>" >
      </td>
     </tr>

     <tr>
     <td class=form_label_40>模式 ：</td>
     <td><select size=1 name=band onChange="updateChan()">
		<option value="1">802.11b</option>
		<option value="4">802.11g</option>
		<option value="0">802.11b/g</option>
		<option value="6">802.11n</option>
		<option value="7">802.11n/g</option>
		<option value="9" selected>802.11b/g/n</option>
      </select>
     </td>
     </tr>

     <tr>
     <td class=form_label_40>频道 ：</td>
     <td><select size="1" name="chan"> </select>
		 <b>&nbsp; &nbsp;当前信道:</b><% getStatusWlanChannel(); %>
     </td>
     </tr>

     <tr>
     <td class=form_label_40>带宽 ：</td>
     <td><select size="1" name="chanwid" onChange="updateChanWidth()">
		<option value="0">20M</option>
		<option value="1" selected>Auto 20/40M</option>
		</select>
     </td>
     </tr>

     <tr style="display:none">
     <td class=form_label_40>最大传输速率 ：</td>
     <td><select size="1" name="txRate">
      </select>
     </td>
     </tr>

     <SCRIPT>
     	/*
		regDomain=3;
		defaultChan=0;
		updateChan();
		*/
     </SCRIPT>
    </table>
   </td>
  </tr>
 </table>

 <table id=body_header border=0 cellSpacing=0>

  <tr>
   <td class=topheader>安全选项
   </td>
  </tr>

  <tr>
   <td class=content>
    <table class=formarea border="0" cellpadding="0" cellspacing="0" width=100%>

	<tr>
      <input type="hidden" name="method_cur" value="0" >
      <td class=form_label_40>安全选项 ：
      </td>
      <td><select size="1" id="methodSel" name="method" onChange="checkState()">
<option value="0" selected>无</option>
<option value="1">WEP</option>
<option value="2">WPA-PSK(TKIP)</option>
<option value="3">WPA-PSK(AES)</option>
<option value="4">WPA2-PSK(AES)</option>
<option value="5">WPA2-PSK(TKIP)</option>
<option value="6">WPA-PSK/WPA2-PSK AES</option>
       </select>
      </td>
     </tr>

    </table>

   </td>

  </tr>

 </table>

 <div id="optionforwep" style="display:none">

 <table id=body_header border=0 cellSpacing=0>

  <tr>

   <td class=topheader>安全加密(WEP)</td>

  </tr>

  <tr>

   <td class=content align=center>

    <table class=formarea border="0" cellpadding="0" cellspacing="0" width=100%>

     <tr>

      <td class=form_label_40>认证类型 ：</td>

      <td>

       <select size="1" name="authType">

        
        <option value=2 >自动</option>

        <option value=1 >共享密钥</option>

       </select>

      </td>

     </tr>

     <tr>

      <td class=form_label_40>加密强度 ：</td>

      <td><select size="1" name="length" ONCHANGE=lengthClick()>

       <option value=1>64位</option>

       <option value=2>128位</option>

       </select>

      </td>

     </tr>

     <tr style="display:none">

      <td class=form_label_40>密钥格式:</td>

      <td><select size="1" name="format" ONCHANGE=setDefaultKeyValue()>

       <option value=1>ASCII</option>

       <option value=0>十六进制</option>

       </select>

      </td>

     </tr>

    </table>

   </td>

  </tr>

 </table>

 <table id=body_header border=0 cellSpacing=0>

  <tr>

   <td class=topheader>安全加密(WEP)密钥</td>

  </tr>

  <tr>

   <td class=content align=center>

    <table class=formarea border="0" cellpadding="0" cellspacing="0" width=100%>

     <tr>

      <td class=form_label_40>密钥 1 ：</td>

      <td>

       <input type="radio" name="defaultTxKeyId" value="1" onclick="WepKeyChange();">

       <input type="text" name="show_key1" id="show_key1" size="26" value="">
	   <input type="hidden" name="key1" id="key1" size="26" value="">

      </td>

     </tr>

     <tr>

      <td class=form_label_40>密钥 2 ：</td>

      <td>

       <input type="radio" name="defaultTxKeyId" value="2" onclick="WepKeyChange();">

       <input type="text" name="show_key2" id="show_key2" size="26" value="">
	   <input type="hidden" name="key2" id="key2" size="26" value="">

      </td>

     </tr>

     <tr>

      <td class=form_label_40>密钥 3 ：</td>

      <td>

       <input type="radio" name="defaultTxKeyId" value="3" onclick="WepKeyChange();">

       <input type="text" name="show_key3" id="show_key3" size="26" value="" >
	   <input type="hidden" name="key3" id="key3" size="26" value="">

      </td>

     </tr>

     <tr>

      <td class=form_label_40>密钥 4：</td>

      <td>

       <input type="radio" name="defaultTxKeyId" value="4" onclick="WepKeyChange();">

       <input type="text" name="show_key4" id="show_key4" size="26" value="" >
	   <input type="hidden" name="key4" id="key4" size="26" value="" >

      </td>

     </tr>

    </table>

   </td>

  </tr>

 </table>

 </div>

 <div id="optionforwpa" style="display:none">

 <table id=body_header border=0 cellSpacing=0>

  <tr>

   <td class=topheader id="wpainfo1" name = "wpainfo1" style="display:none">安全加密(WPA-PSK)

   </td>

   <td class=topheader id="wpainfo2" name = "wpainfo2" style="display:none">安全加密(WPA2-PSK)

   </td>

   <td class=topheader id="wpainfo3" name = "wpainfo3" style="display:none">安全加密(WPA-PSK+WPA2-PSK)

   </td>

  </tr>

  <tr>

   <td class=content align=center>

    <table class=formarea border="0" cellpadding="0" cellspacing="0" width=100%>

     <tr style="display:none">

      <td class=form_label_40>预共享密钥形式:</td>

      <td><select size="1" name="pskFormat">

       <option value=0 >密文</option>

       <option value=1 >十六进制 (64 characters)</option>

       </select>

             </td>

     </tr>

     <tr id=tr_psk style="">

      <td class=form_label_40>密码 ：</td>

      <td>

       <input type="text" name="tmppskValue" size="32" maxlength="64">(8-63个字符或者64个十六进制数字)
      </td>

     </tr>

    </table>

   </td>

  </tr>

 </table>

 </div>

 <p align=center>
<input type="hidden" name="pskValue" size="32" maxlength="64">
<INPUT TYPE="HIDDEN" NAME="checkWPS2" VALUE="<% getCfgZero(1, "WscModeOption"); %>">
 <input type="submit" value="应用" name="save" onClick="return saveChanges()">&nbsp;&nbsp;

 <input type="reset" value="取消" name="reset" onClick="resetClick()">

 </p>

 <input type="hidden" name="basicrates" value=0>

 <input type="hidden" name="operrates" value=0>
<!--
 <INPUT TYPE="hidden" NAME="submit.htm?wlan_basic.htm" VALUE="Send">
-->

<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
 </form>

<script type='text/javascript'>

 mainBodyEnd();
 ThirdRowEnd();
 Footer()
 mainTableEnd()
</script>

<script type='text/javascript'>

</script>

</blockquote>

</body>

</html>



