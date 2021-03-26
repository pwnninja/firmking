<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<meta http-equiv="refresh" content="60">
<title>统计信息</title>
</head>
<body>
<blockquote>

<script language="JavaScript">
	TabHeader="状态";
	SideItem="统计信息";
	HelpItem="statistic";
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
		<td class=topheader>统计信息</td>
	</tr>
	<tr>
		<td class=content>
			<p>本页面显示通过网络接口发送和接收数据包的信息.
            </p>
		</td>
	</tr>
</table>
<br>
<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>统计信息</td>
	</tr>
	<tr>
		<td class=content>
  			<table class=formlisting border=0>
    			<tr class=form_label_row>
    				<td class='form_label_col' width="14%">
                    接口
                    </td>
    				<td class='form_label_col' width="12%">
                    收包
    				</td>
                    <td class='form_label_col' width="8%">
                    接收错误
    				</td>
                    <td class='form_label_col' width="8%">
                    接收丢弃
    				</td>
                    <td class='form_label_col' width="12%">
                    发包
    				</td>
                     <td class='form_label_col' width="8%">
                    发送错误
    				</td>
                     <td class='form_label_col' width="8%">
                    发送丢弃
    				</td>
    			</tr>
<script language="javascript">
	var WLAN_Packets = [<% getAllNICStatisticASP(); %>];
	var TxRxErrorDrop = <% getTxRxErrorDropPacketASP(); %>;
	
//	[	Rx	错误, 丢弃, Tx	错误, 丢弃, 
//		["lan","0","0","0","0"],
//		["wan","0","0","0","0"],
//		["wlan2","0","0","0","0"],
//		["wlan5","0","0","0","0"]
//	];
						//["ra0" ,"0","0","0","0",
						// "rai0","0","0","0","0"];
						//接口，接收封包，数据量，传送，数据量
</script>
    			<tr class=form_label_row>
    				<td class='form_label_col' width="8%">LAN1</td>
                    </td>
    				<td class='form_label_col' width="15%" rowspan="4"><% getLANRxPacketASP(); %>
    				</td>
                    <td class='form_label_col' width="8%" rowspan="4">
<script language="javascript">	dw( TxRxErrorDrop[0][1] )  </script>
					</td>
                    <td class='form_label_col' width="8%" rowspan="4">
<script language="javascript">	dw( TxRxErrorDrop[0][2] )  </script>
</td>
                    <td class='form_label_col' width="15%" rowspan="4"><% getLANTxPacketASP(); %>
    				</td>
                     <td class='form_label_col' width="8%" rowspan="4">
<script language="javascript">	dw( TxRxErrorDrop[0][3] )  </script>
</td>
                     <td class='form_label_col' width="8%" rowspan="4">
<script language="javascript">	dw( TxRxErrorDrop[0][4] )  </script>
</td>
    			</tr>
    			<tr class=form_label_row>
    				<td class='form_label_col' width="8%">LAN2</td>
    			</tr>
    			<tr class=form_label_row>
    				<td class='form_label_col' width="8%">LAN3</td>
    			</tr>
    			<tr class=form_label_row>
    				<td class='form_label_col' width="8%">LAN4</td>
    			</tr>
<tr class=form_label_row>
<td class=form_label_col >WAN</td>
<td class=form_label_col ><% getWANRxPacketASP(); %></td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[1][1] )  </script></td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[1][2] )  </script></td>
<td class=form_label_col ><% getWANTxPacketASP(); %></td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[1][3] )  </script></td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[1][4] )  </script></td>
</tr>

<tr class=form_label_row>
<td class=form_label_col >WLAN(2.4G)</td>
<td class=form_label_col ><script language="javascript"> dw( WLAN_Packets[1] ) </script>
</td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[2][1] )  </script></td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[2][2] )  </script></td>
<td class=form_label_col ><script language="javascript"> dw( WLAN_Packets[3] ) </script>
</td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[2][3] )  </script></td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[2][4] )  </script></td>
</tr>

<tr class=form_label_row>
<td class=form_label_col >WLAN(5.8G)</td>
<td class=form_label_col ><script language="javascript"> dw( WLAN_Packets[6] ) </script>
</td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[3][1] )  </script></td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[3][2] )  </script></td>
<td class=form_label_col ><script language="javascript"> dw( WLAN_Packets[8] ) </script>
</td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[3][3] )  </script></td>
<td class=form_label_col ><script language="javascript">	dw( TxRxErrorDrop[3][4] )  </script></td>
</tr>

</table> 
		</td>
	</tr>
</table>  

<form>
<p align=center>
<input type="button" value="刷新" onClick="window.location.href='d_stats.asp'">
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

