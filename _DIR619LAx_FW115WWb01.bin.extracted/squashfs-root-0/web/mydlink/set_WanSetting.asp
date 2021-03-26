<html>
<head>
</head>
<body>
<form name="myform" action="/goform/form_wansetting" method="post">
<table>
<tr><td><input type="text" name="settingsChanged" value="1"></td><td>settingsChanged</td></tr>
<tr><td><input name="config.wan_ip_mode" value="1"></td><td>config.wan_ip_mode 0:static; 1: DHCP; 2: PPPoE; 3: PPTP: 4:L2TP;</td></tr>
<tr><td><input type="text" name="config.wan_dhcp_gw_name" value="DIR-605L"></td><td>config.wan_dhcp_gw_name "DIR-605L" (hostname)(dhcp,dhcpplus,need)</td></tr>
<tr><td><input type="text" name="mac_clone" value="223344556611"></td><td>mac_clone (wan mac address)(dhcp,static,pppoe,pptp,l2tp,dhcpplus need)</td></tr>
<tr><td><input name="config.wan_primary_dns" value="172.18.50.1"></td><td>config.wan_primary_dns (dhcp,static,pppoe,pptp,l2tp,dhcpplus need)</td></tr>
<tr><td><input name="config.wan_secondary_dns" value="172.18.50.2"></td><td>config.wan_secondary_dns (dhcp,static,pppoe,pptp,l2tp,dhcpplus need)</td></tr>
<tr><td><input name="config.wan_mtu" value="1500"></td><td>config.wan_mtu 0  ~  1500(dhcp,static,pppoe,l2tp,pptp,dhcpplus need)</td></tr>
<tr><td><input name="config.wan_ip_address" value="172.18.75.54"></td><td>config.wan_ip_address wan ip (static need)</td></tr>
<tr><td><input name="config.wan_subnet_mask" value="255.255.255.0"></td><td>config.wan_subnet_mask Wan mask(static need)</td></tr>
<tr><td><input name="config.wan_gateway" value="172.18.75.254"></td><td>config.wan_gateway Wan gateway(static need)</td></tr>
<tr><td><input name="config.pppoe_use_dynamic_address" value="false"></td><td>config.pppoe_use_dynamic_address 'true' or 'false'(pppoe,need)</td></tr>
<tr><td><input name="config.pppoe_netsniper" value="true"></td><td>config.pppoe_netsniper 'true' or 'false'(pppoe, need)</td></tr>
<tr><td><input name="config.pppoe_xkjs" value="false"></td><td>config.pppoe_xkjs 'true' or 'false'(pppoe, need) </td></tr>
<tr><td><input name="config.xkjs_mode" value="0"></td><td>pppoe+, 4 or 0 (pppoe, need) </td></tr>
<tr><td><input name="config.pppoe_username" value="ADSLUSERNAME"></td><td>config.pppoe_username (pppoe need)</td></tr>
<tr><td><input name="config.pppoe_password" value="ADSLPASS"></td><td>config.pppoe_password (pppoe need)	</td></tr>
<tr><td><input name="config.pppoe_service_name" value="ADSLSERVER"></td><td>config.pppoe_service_name (pppoe need)	</td></tr>
<tr><td><input name="config.pppoe_ip_address" value="202.11.33.2"></td><td>config.pppoe_ip_address (pppoe need)	</td></tr>
<tr><td><input name="pppoe_use_dynamic_dns_radio" value="true"></td><td>pppoe_use_dynamic_dns_radio 'true' or 'false' (pppoe, need)</td></tr>
<tr><td><input name="config.pppoe_max_idle_time" value="5"></td><td>config.pppoe_max_idle_time pppoe idle time seconds(pppoe, need)</td></tr>
<tr><td><input name="ppp_schedule_control_0" value="Always"></td><td>ppp_schedule_control_0 (schedule name like 'Always')(pppoe,pptp,l2tp need)</td></tr>
<tr><td><input name="pppoe_reconnect_mode_radio" value="1"></td><td>pppoe_reconnect_mode_radio 0:Always on; 1:On demand; 2:Manual; (pppoe, need)</td></tr>
<tr><td><input name="wan_pptp_use_dynamic_carrier_radio" value="true"></td><td>wan_pptp_use_dynamic_carrier_radio "true" or "false" (pptp, need)</td></tr>
<tr><td><input name="config.wan_pptp_server" value="172.18.69.6"></td><td>config.wan_pptp_server Pptp server ip (pptp, need)</td></tr>
<tr><td><input name="config.wan_pptp_username" value="pptp"></td><td>config.wan_pptp_username (pptp, need)</td></tr>
<tr><td><input name="config.wan_pptp_password" value="12345678"></td><td>config.wan_pptp_password (pptp, need)</td></tr>
<tr><td><input name="config.wan_pptp_max_idle_time" value="5"></td><td>config.wan_pptp_max_idle_time (pptp, need)</td></tr>
<tr><td><input name="pptp_reconnect_mode_radio" value="1"></td><td>pptp_reconnect_mode_radio 0:Always on; 1:On demand; 2:Manual;(pptp need)</td></tr>
<tr><td><input name="wan_l2tp_use_dynamic_carrier_radio" value="true"></td><td>wan_l2tp_use_dynamic_carrier_radio "true" or "false" (l2tp, need)</td></tr>
<tr><td><input name="config.wan_l2tp_server" value="172.18.69.6"></td><td>config.wan_l2tp_server L2tp server ip(l2tp, need)</td></tr>
<tr><td><input name="config.wan_l2tp_username" value="l2tp"></td><td>config.wan_l2tp_username</td></tr>
<tr><td><input name="config.wan_l2tp_password" value="12345678"></td><td>config.wan_l2tp_password</td></tr>
<tr><td><input name="config.wan_l2tp_max_idle_time" value="5"></td><td>config.wan_l2tp_max_idle_time pptp idle time seconds(pppoe, need)</td></tr>
<tr><td><input name="l2tp_reconnect_mode_radio" value="1"></td><td>l2tp_reconnect_mode_radio (0:Always on; 1:On demand; 2:Manual;(l2tp need)</td></tr>

<input type="submit" value="Submit" />
</table>
</form>
</body>
</html>
