<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<title>ALG</title>
<SCRIPT>

function saveChanges()
{
	if(document.getElementById('alg_pptp_enable').checked == true)
	{
		document.alg.alg_pptp_enable.value= "1";
	}
	else
	{
		document.alg.alg_pptp_enable.value = "0";
	}

	if(document.getElementById('alg_l2tp_enable').checked == true)
	{
		document.alg.alg_l2tp_enable.value= "1";
	}
	else
	{
		document.alg.alg_l2tp_enable.value = "0";
	}
	
	if(document.getElementById('alg_ipsec_enable').checked == true)
	{
		document.alg.alg_ipsec_enable.value= "1";
	}
	else
	{
		document.alg.alg_ipsec_enable.value = "0";
	}
	
	if(document.getElementById('alg_sip_enable').checked == true)
	{
		document.alg.alg_sip_enable.value= "1";
	}
	else
	{
		document.alg.alg_sip_enable.value = "0";
	}
	
	if(document.getElementById('alg_ftp_enable').checked == true)
	{
		document.alg.alg_ftp_enable.value= "1";
	}
	else
	{
		document.alg.alg_ftp_enable.value = "0";
	}
	create_backmask();
	document.getElementById("loading").style.display="";
	return true;
}
function resetClick()
{
 
}

function initValue()
{
	 var pptp_en = "<% getCfgGeneral(1, "ALG_PPTP"); %>";
	 var l2tp_en = "<% getCfgGeneral(1, "ALG_L2TP"); %>";
	 var ipsec_en = "<% getCfgGeneral(1, "ALG_IPSEC"); %>";
	 var sip_en = "<% getCfgGeneral(1, "ALG_SIP"); %>";
	 var ftp_en = "<% getCfgGeneral(1, "ALG_FTP"); %>";

	if (pptp_en == "1")
	{
		document.alg.alg_pptp_enable.checked = true;
	}
	else
	{
		document.alg.alg_pptp_enable.checked = false;	
	}
	if (l2tp_en == "1")
	{
		document.alg.alg_l2tp_enable.checked = true;
	}
	else
	{
		document.alg.alg_l2tp_enable.checked = false;	
	}
	if (ipsec_en == "1")
	{
		document.alg.alg_ipsec_enable.checked = true;
	}
	else
	{
		document.alg.alg_ipsec_enable.checked = false;	
	}
	if (sip_en == "1")
	{
		document.alg.alg_sip_enable.checked = true;
	}
	else
	{
		document.alg.alg_sip_enable.checked = false;	
	}
	if (ftp_en == "1")
	{
		document.alg.alg_ftp_enable.checked = true;
	}
	else
	{
		document.alg.alg_ftp_enable.checked = false;	
	}
	
}
</SCRIPT>

</head>
<body onload="initValue();">
<blockquote>
<script language="JavaScript">
TabHeader="高级";
SideItem="ALG";
HelpItem="Alg";
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
  <td class="topheader"><#adv_alg_000#></td>
 </tr>
 <tr>
  <td class="content">
   <p><#adv_alg_001#></p>
  </td>
 </tr>
</table>
<form method=POST Action="/goform/form2alg.cgi" name="alg">
<table id="body_header" border="0" cellSpacing="0">
 <tr>
  <td class="topheader"><#adv_alg_002#></td>
 </tr>
 <tr>
  <td class="content" align="left">
     <table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500" id="alg_on">
     <tr>
	     <td class="form_label_left"><#adv_alg_003#></td>
	     <td class="form_label_right">
	     		<input type="checkbox" name="alg_pptp_enable" id="alg_pptp_enable" value="1">
	     </td>
     </tr>
      <tr>
	     <td class="form_label_left"><#adv_alg_004#></td>
	     <td class="form_label_right">
	     		<input type="checkbox" name="alg_l2tp_enable" id="alg_l2tp_enable" value="1">
	     </td>
     </tr>
      <tr>
	     <td class="form_label_left"><#adv_alg_005#></td>
	     <td class="form_label_right">
	     		<input type="checkbox" name="alg_ipsec_enable" id="alg_ipsec_enable" value="1">
	     </td>
     </tr>
      <tr>
	     <td class="form_label_left"><#adv_alg_006#></td>
	     <td class="form_label_right">
	     		<input type="checkbox" name="alg_ftp_enable" id="alg_ftp_enable" value="1">
	     </td>
     </tr>
    <tr>
	     <td class="form_label_left"><#adv_alg_007#></td>
	     <td class="form_label_right">
	     		<input type="checkbox" name="alg_sip_enable" id="alg_sip_enable" value="1">
	     </td>
     </tr>
    </table>
  </td>
 </tr>
</table>
<br>
<p align=center>
<input type="submit" value="<#adv_alg_008#>" name="save" onClick="return saveChanges()">&nbsp;&nbsp;
<input type="reset" value="<#adv_alg_009#>" name="reset" onClick="resetClick()">
</p>
 <input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
</form>
<script type="text/javascript">
   resetClick();
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

