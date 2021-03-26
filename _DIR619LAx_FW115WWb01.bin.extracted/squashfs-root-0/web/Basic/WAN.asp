<html>
<head>
<title></title>
<meta http-equiv=Content-Type content="text/html;">
</head>
<body>
	<script language="javascript" type="text/javascript">
	<!-- hide script from old browsers
	var dsl_mode="<%getInfo("wanType");%>";
	var dsl_asp = "wan_dhcp.asp";
	if(dsl_mode=="0"){
		dsl_asp = "wan_static.asp";
	}else if(dsl_mode=="2"){
		dsl_asp = "wan_pppoe.asp";
	}else if(dsl_mode=="3"){
		dsl_asp="wan_pptp.asp";
	}else if(dsl_mode=="4"){
		dsl_asp="wan_l2tp.asp";
	}
	else if(dsl_mode=="5"){
		dsl_asp="wan_bigpond.asp";
	}
	else if(dsl_mode=="9"){
		dsl_asp="wan_dhcpplus.asp";
	}
<% getFeatureMark("No_RU_Head_Comment"); %>			      
	else if (dsl_mode == "PPPoE_RU")
	{
	    	dsl_asp = "wan_pppoe_ru.asp";   
	}
	else if (dsl_mode == "PPTP_RU")
	{
	    	dsl_asp = "wan_pptp_ru.asp";       
	}
<% getFeatureMark("No_RU_Tail_Comment"); %>	

	window.location.href=dsl_asp+"?t="+new Date().getTime();
	//-->
	</script>
</body>
</html>