<?xml version="1.0" encoding="UTF-8" standalone="yes"?><status>
<wan_physical_link><% getIndexInfo("wan_phylink");%></wan_physical_link><wan_physical_state><% getIndexInfo("wan_phylink");%></wan_physical_state>
<auth_sec_model>N/A</auth_sec_model><connection_state><%getWanConnection("");%></connection_state>
<link_drop_time_remain>0</link_drop_time_remain><link_drop_time_active>0</link_drop_time_active>
<user_stop>0</user_stop><wan_ip_address><% getInfo("wan-ip");%></wan_ip_address>
<wan_subnet><% getInfo("wan-mask");%></wan_subnet><wan_gateway><% getInfo("wan-gateway");%></wan_gateway>
<wan_primary_dns><%getInfo("wan_primary_dns");%></wan_primary_dns>
<wan_secondary_dns><%getInfo("wan_secondary_dns");%></wan_secondary_dns><wan_interface_up_time><%getWanConnection("wan_uptime");%></wan_interface_up_time>
<wan_state>0</wan_state><lan_ip_address><% getInfo("ip"); %></lan_ip_address>
<lan_subnet><% getInfo("mask"); %></lan_subnet><lan_gateway><% getInfo("gateway-rom");%></lan_gateway>
<lan_primary_dns><% getInfo("wan-dns1");%></lan_primary_dns><lan_secondary_dns><% getInfo("wan-dns2");%></lan_secondary_dns>
<wirless_schedule><%getIndexInfo("wlan_state");%></wirless_schedule><wirless_channel><% getInfo("channel_drv");%></wirless_channel>
</status>