<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
.text { font-family:Arial,Helvetica,Geneva,Swiss,SunSans-Regular,sans-serif;
		font-size:18px;
		font-weight:bold;
		color:#404343;}
</style>
<script language="javascript">var wtime = 35;
function timerStart()
{
 if (wtime >= 1)
 {
	  wtime--;
	  document.getElementById('SPAN_TimeNum').innerHTML = wtime;
  setTimeout("timerStart()",1000);
 }else{
	  document.getElementById('wait').style.display = 'none';
	  document.getElementById('clicklanip').style.display = '';
 }
}
</script>

</head><body>
<table cellspacing="0" cellpadding="3" border="0" align="center" class="mainFramWidth" id="wait">
		<tbody><tr><td style="color:#F56D23;FONT-SIZE:19px;font-weight:700" class="fontsize"><#Rebootintroduct1#></td></tr>
		<tr>
			<td nowrap="" align="center" colspan="2"><span class="text" id="lang_rebooting"></span>
													<span class="text" id="P_Note">
														<span class="text" id="lang_pleasewait"></span>
														<span class="text" id="SPAN_TimeNum">15</span>
														<span class="text" id="lang_seconds"></span>
													</span></td>
		</tr><tr>
		
		</tr><tr>
			<td nowrap="" align="center" colspan="2"><div class="ProgBar"><div id="RealStatus" style="width: 267px;"></div></div></td>
		</tr>

	
	
 </tbody></table>
 <div id="clicklanip" style="display:none; ">
<center>
<font face="Courier" color=red><h3>
<#Click_LANIP#>
<a href="http://<% getCfgGeneral(1, "lan_ipaddr"); %>/" target="_parent"><% getCfgGeneral(1, "lan_ipaddr"); %></a>
<#Contine_Config#>.
</font></center></div><script>timerStart();</script></body></html>