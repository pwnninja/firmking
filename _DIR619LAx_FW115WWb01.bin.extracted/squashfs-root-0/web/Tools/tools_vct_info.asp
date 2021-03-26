<html>
<head>
<link rel="stylesheet" href="../style.css"  type="text/css">
<meta http-equiv=Content-Type content="no-cache">
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<script type="text/javascript" src="../navigation.js"></script>
<% getLangInfo("LangPath");%>
<script type="text/javascript" src="../utility.js"></script>
<script>
var sDisConnect = sw("txtDisconnected");	
port_id="<%getIndexInfo("EthPortId");%>";
linkType=[sDisConnect,"100Mbps "+sw("txtFULLDuplex"),"100Mbps "+sw("txtHALFDuplex"),"10Mbps "+sw("txtFULLDuplex"),"10Mbps "+sw("txtHALFDuplex")];
txrxstat=[sw("txtError"),sw("txtNormalCable"),sw("txtOpenCable"),sw("txtShortCable")];

function getInfo()
{
	switch(port_id)
	{
	case "0":
		cable_name=sw("txtInternet2");
		linkStat="<%getIndexInfo("EthPort_status");%>";
		break;
	default:
		cable_name=sw("txtLan2")+eval(parseInt(port_id, [10]));
		linkStat="<%getIndexInfo("EthPort_status");%>";
		break;
	}
	txstatus="";
	rxstatus="";
	txmeter="";
	rxmeter="";
}

function getConnectString(s)
{
	return linkType[isNaN(parseInt(s, [10]))? 0: parseInt(s, [10])];
}

function getStatString(s)
{
	return txrxstat[isNaN(parseInt(s, [10]))? 0: parseInt(s, [10])];
}

function generateInfo()
{
	getInfo();
	var str=new String("");
	str+="<tr>";
	str+="<td width=11% height=76 align=left><b><font face=Arial size=2>"+cable_name+"</font></b></td>";
	if (linkStat != "0" && linkStat != "")
	{
		str+="<td width=37% height=76 align=center><img src=../Images/W_link.gif width=223 height=35 border=0></td>";
		str+="<td width=35% height=76 align=center><font font=Tahoma size=2 color=#000000><b><strong>"+getConnectString(linkStat)+"</strong></b></font></td>";
		str+="</tr>";
		str+="<tr><td height=20><div align=center></div></td><td height=20><div align=center><font face=Tahoma size=2><strong>TxPair" +sw("txtNormalCable")+"!</strong></font></div></td><td height=20>&nbsp;</td></tr>";
		str+="<tr><td height=20><div align=center></div></td><td height=20><div align=center><font face=Tahoma size=2><strong>RxPair" +sw("txtNormalCable")+"!</strong></font></div></td><td height=20>&nbsp;</td></tr>";
		
	}
	else
	{
		str+="<td width=37% height=76 align=center><img src=../Images/W_nolink.gif width=223 height=35 border=0></td>";
		str+="<td width=35% height=76 align=center><font font=Tahoma size=2 color=#000000><b><strong>"+getConnectString(linkStat)+"</strong></b></font></td>";
		str+="</tr>";
		str+="<tr><td height=20><div align=center></div></td><td height=20><div align=center><font face=Tahoma size=2><strong>TxPair "+getStatString(txstatus)+" at "+txmeter+" meters</strong></font></div></td><td height=20>&nbsp;</td></tr>";
		str+="<tr><td height=20><div align=center></div></td><td height=20><div align=center><font face=Tahoma size=2><strong>RxPair "+getStatString(rxstatus)+" at "+txmeter+" meters</strong></font></div></td><td height=20>&nbsp;</td></tr>";
	}
	document.write(str);
}

function ExitWindow()
{
        self.parent.close();
}

function init()
{
	var DOC_Title= sw("txtTitle")+" : "+sw("txtTools")+'/'+sw("txtSystemCheck");
	document.title = DOC_Title;
	get_by_id("exit").value = sw("txtLogout2");
}

</script>
</head>
<body bgcolor=#CCCCCC text=#000000 topmargin=0 leftmargin=0 onload="init();">
<form method=post id="vct_info" name="vct_info">
<table border=0 cellspacing=0 cellpadding=0 height=211 width=450>
<tr>
	<td height=11><img src="../Images/wwvct.jpg" width=450></td>
</tr>
<tr>
	<td height=10 bgcolor=#CCCCCC>
	<table border=0 width=450 height=175 cellpadding=0>
		<script>generateInfo();</script>
	</table>
	</td>
</tr>
<tr bgcolor=#CCCCCC align=right>
	<td height=10 colspan=2>
	<input name='exit' type=button id='exit' value='' class=button width=36 height=52 onClick='ExitWindow()'>&nbsp;
	</td>
</tr>
</table>
</form>
</body>
</html>
