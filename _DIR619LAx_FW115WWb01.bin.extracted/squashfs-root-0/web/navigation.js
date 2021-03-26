/*
 * Javascript that animates the navigation in pages based on master.dwt
 */

/*
 * Enable or disable specific subnav links, depending on runtime configuration.
 */
function set_subnav_link(enabled,link_id)
{
	var lnk = document.getElementById(link_id);
	if (enabled) {
		remove_class(lnk.parentNode.parentNode, "disabled");
		lnk.onclick = jump_if;
	} else {
		add_class(lnk.parentNode.parentNode, "disabled");
		lnk.onclick = function() {
			return false;
		}
	}
}

/*
 * -----------------------------------------------------------------------------
 * Variables and functions for dynamic navigation
 */
var topnav_current = null;  	// Which topnav are we at.
var subnav_current = null;		// Subnav that corresponds to topnav_current

/*
 * Initialize dynamic navigation
 */
function topnav_init (topnav) 
{
	/*
	 * Determine from current URL what the corresponding topnav item is.
	 */
	var this_uri = get_webserver_ssi_uri();
	var this_path = this_uri.split("/");	
	topnav_current = document.getElementById(this_path[1] + "_topnav");
	remove_class(topnav_current.parentNode, "topnavoff");
	add_class(topnav_current.parentNode, "topnavon");
	/*
	 * Show the subnav that corresponds to the current topnav item
	 */
	subnav_current = document.getElementById(topnav_current.rel.split(" ")[1]);
	subnav_current.style.display = "block";
	/*
	 * Set up all the topnav items
	 */
	var top_items = topnav.getElementsByTagName("a");
	for (var i = 0; i < top_items.length; i++) {
		var top_item = top_items[i];
		/*
		 * Make each topnav link the same as its first active subnav link.
		 */
		var subnav_id = top_item.rel.split(" ")[1];
		var subnav = document.getElementById(subnav_id);
		var sub_items = subnav.getElementsByTagName("a");
		/*
		 * Look for the first subnav link that doesn't have class "disabled".
		 */
		var sub_item;
		for (var j = 0; j < sub_items.length; j++) {
			if(i == 0 && j == 0)
				sub_item = sub_items[1];
			else
				sub_item = sub_items[j];
			if (!has_class(sub_item.parentNode.parentNode, "disabled")) {
				top_item.href = sub_item.href;
				break;
			}
		}
		/*
		 * If all sub_nav items were disabled, we should disable the top_nav item.
		 * But we know that does not occur in the current navigational system. X
		 */
	}

	var sub_items = subnav_current.getElementsByTagName("a");
	for (var i = 0; i < sub_items.length; i++) {
		//alert ("href: " + sub_item[i].href + "ssi_uri: " + get_webserver_ssi_uri());
		if (sub_items[i].href.search(get_webserver_ssi_uri()) > -1) {
			add_class(sub_items[i].parentNode.parentNode, "here");
		}
	}
	
}

function DrawHeaderContainer()
{
	document.write("<div id=\"header_container\">");
	document.write("	<div id=\"info_bar\">");
	document.write("		<div class=\"fwv\">");
	document.write("			<SCRIPT>ddw(\"txtFirmwareVersion\");</SCRIPT>");
	document.write("			:");
	document.write("		<span id=\"fw_minor_head\"></span>");
	document.write("		</div>");
	document.write("		<div class=\"hwv\">");
	document.write("			<SCRIPT>ddw(\"txtHardwareVersion\");</SCRIPT>");
	document.write("			:");
	document.write("		<span id=\"hw_version_head\"></span>");	
	document.write("		</div>");
	document.write("		<div class=\"pp\">");
	document.write("			<SCRIPT>ddw(\"txtProductPage\");</SCRIPT>");
	document.write("			: <a href=\"http://support.dlink.com.tw/\"  onclick=\"return jump_if();\">");
	document.write("		<span id=\"product_model_head\"></span>");
	document.write("    </a></div>");
	document.write("	</div>");
	document.write("</div>");
	
	
}

/*function DrawMastheadContainer()
{
	document.write("<table id=\"masthead_container\" cellspacing=\"0\" cellpadding=\"0\" summary=\"\">");
	document.write("	<tr padding=\"0\">");
	document.write("                <td padding=\"0\"><div id=\"masthead_image\" style=\"width:856\"></div></td>");
	document.write("	</tr>");
	document.write("</table>");
	
	
}*/

function DrawMastheadContainer()
{
	document.write("<table id=\"masthead_container\" cellspacing=\"0\" cellpadding=\"0\" summary=\"\" style=\"width:856px; height:92px;  \">");
	document.write("<map id=\"masthead_image_map\" name=\"masthead_image_map\">");
	document.write("<area shape=\"rect\" coords=\"10,10,180,70\" target=\"_blank\" href=\"http://www.dlink.com.tw\">");
	document.write("</area>");
	document.write("</map>");
	document.write("	<tr padding=\"0\">");
	document.write("		<td padding=\"0\">");
	document.write("			<img src=\"/Images/img_masthead_red.gif\" usemap=\"#masthead_image_map\" bordder=\"0\"/>");
	document.write("		</td>");
	document.write("	</tr>");
	document.write("</table>");
}

function DrawTopnavContainer()
{
	document.write("<table id=\"topnav_container\" border=\"0\" cellspacing=\"1\" summary=\"\">");
	document.write("	<tr>");
	document.write("		<td id=\"modnum\">");
	document.write("			<div id=\"modnum_image\"></div>");
	document.write("		</td>");
	document.write("		<td class=\"topnavoff\">");
	document.write("			<a href=\"../Basic/Internet.asp\" id=\"Basic_topnav\" rel=\"Chapter Basic_subnav\" onclick=\"return jump_if();\">");
	document.write("				<SCRIPT>ddw(\"txtSetup\");</SCRIPT>");
	document.write("			</a>");
	document.write("		</td>");
	document.write("		<td class=\"topnavoff\">");
	document.write("			<a href=\"../Advanced/Virtual_Server.asp\" id=\"Advanced_topnav\" rel=\"Chapter Advanced_subnav\" onclick=\"return jump_if();\">");
	document.write("				<SCRIPT>ddw(\"txtAdvanced\");</SCRIPT>");
	document.write("			</a>");
	document.write("		</td>");
	document.write("		<td class=\"topnavoff\">");
	document.write("			<a href=\"../Tools/Admin.asp\" id=\"Tools_topnav\" rel=\"Chapter Tools_subnav\" onclick=\"return jump_if();\">");
	document.write("				<SCRIPT>ddw(\"txtTools\");</SCRIPT>");
	document.write("			</a>");
	document.write("		</td>");
	document.write("		<td class=\"topnavoff\">");
	document.write("			<a href=\"../Status/Device_Info.asp\" id=\"Status_topnav\" rel=\"Chapter Status_subnav\" onclick=\"return jump_if();\">");
	document.write("				<SCRIPT>ddw(\"txtStatus\");</SCRIPT>");
	document.write("			</a>");
	document.write("		</td>");
	document.write("		<td class=\"topnavoff\">");
	document.write("			<a href=\"../Help/Menu.asp\" id=\"Help_topnav\" rel=\"Chapter Help_subnav\" onclick=\"return jump_if();\">");
	document.write("				<SCRIPT>ddw(\"txtSupport\");</SCRIPT>");
	document.write("			</a>");
	document.write("		</td>");
	document.write("	</tr>");
	document.write("</table>");
}

function DrawBasic_subnav()
{
			document.write("<ul id=\"Basic_subnav\" class=\"subnav_group\">");

                                document.write("<li>");
                                        document.write("<div>");
                                                document.write("<a id=\"Wizard_Easy_link\" href=\"javascript:location='../Basic/Wizard_Tp_WanDetect_Login.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
                                                        document.write("<SCRIPT>ddw(\"txtWizardEasyAutoStr\");</SCRIPT>");
                                                document.write("</a>");
                                        document.write("</div>");
                                document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Basic_Internet_nav_link\" href=\"javascript:location='../Basic/Internet.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtInternetSetup1\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");

				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Basic/Wizard_Wireless.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtWirelessCONN\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"../Basic/Basic_Network_nav_link\" href=\"javascript:location='../Basic/Network.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtLanSetting\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Basic/Time.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtTime\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Advanced_Web_Filter_nav_link\" href=\"javascript:location='../Basic/Web_Filter.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtWebsiteFilteringRules\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<form id=\"logout_form\" name=\"logout_form\" action=\"\" method=\"post\">");
  document.write("<input type=\"hidden\" name=\"logout\" value=\"1\"/>");  
  document.write("<input type=\"hidden\" id=\"webpage\" name=\"webpage\" value=\"/logout.asp\">");
	document.write("</form>");
	
	document.write("<li>");
		document.write("<div>");
			document.write("<a id=\"\" href=\"javascript:location='../logout.asp?t='+new Date().getTime();\" >");
				document.write("<SCRIPT>ddw(\"txtLogout2\");</SCRIPT>");
			document.write("</a>");
		document.write("</div>");
	document.write("</li>");
	
			document.write("</ul>");
}

function DrawAdvanced_subnav()
{
			document.write("<ul id=\"Advanced_subnav\" class=\"subnav_group\">");
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Advanced_Virtual_Server_nav_link\" href=\"javascript:location='../Advanced/Virtual_Server.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtVirtualServer\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");

				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Advanced_Special_Applications_nav_link\" href=\"javascript:location='../Advanced/Special_Applications.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtApplicationRules\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
		
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"MAC_Address_Filter_nav_link\" href=\"javascript:location='../Advanced/MAC_Address_Filter.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtMACAddressFilter\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
                                document.write("<li>");
                                        document.write("<div>");
                                                document.write("<a id=\"ACL_Address_Filter_nav_link\" href=\"javascript:location='../Advanced/Wlan_Acl_Filter.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
                                                        document.write("<SCRIPT>ddw(\"txtACLAddressFilter\");</SCRIPT>");
                                                document.write("</a>");
                                        document.write("</div>");
                                document.write("</li>");
	
				document.write("<li>");
					document.write("<div>");
				               document.write("<a id=\"Traffic_Shaping_nav_link\" href=\"javascript:location='../Advanced/Traffic_Shaping.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");   
				               document.write("<SCRIPT>ddw(\"txtQoSEngine\");</SCRIPT>");   
				               document.write("</a>");   
				       document.write("</div>");   
				document.write("</li>");   
	
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Advanced_Firewall_nav_link\" href=\"javascript:location='../Advanced/Firewall.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtFirewall2\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Advanced_wireless_nav_link\" href=\"javascript:location='../Advanced/Advanced_Wireless.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtAdvancedWirelessSettings\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Advanced_Network_nav_link\" href=\"javascript:location='../Advanced/Network.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtAdvancedNetworkSettings\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Advanced_Routing_nav_link\" href=\"javascript:location='../Advanced/Routing.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtRouting\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
document.write("<li>");
		document.write("<div>");
			document.write("<a id=\"\" href=\"javascript:location='../logout.asp?t='+new Date().getTime();\" >");
				document.write("<SCRIPT>ddw(\"txtLogout2\");</SCRIPT>");
			document.write("</a>");
		document.write("</div>");
	document.write("</li>");
	
			document.write("</ul>");
}

function DrawTools_subnav()
{
			document.write("<ul id=\"Tools_subnav\" class=\"subnav_group\">");
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Tools/Admin.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtDeviceAdmin1\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Tools/System.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtSystemSettings\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Tools/Firmware.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtFirmware\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Tools_Dynamic_DNS_nav_link\" href=\"javascript:location='../Tools/Dynamic_DNS.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtDDNS\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Tools/System_Check.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtSystemCheck\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Tools/Schedules.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtSchedule\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
			
/*			
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Tools/SysLog.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtSysLog\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
*/				
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Tools/EMail.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtLogSettings\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
document.write("<li>");
                                        document.write("<div>");
                                                document.write("<a href=\"javascript:location='../Tools/Log_dnsquery.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
                                                        document.write("<SCRIPT>ddw(\"txtEventSettings\");</SCRIPT>");
                                                document.write("</a>");
                                        document.write("</div>");
                                document.write("</li>");
	
				document.write("<li>");
		document.write("<div>");
			document.write("<a id=\"\" href=\"javascript:location='../logout.asp?t='+new Date().getTime();\" >");
				document.write("<SCRIPT>ddw(\"txtLogout2\");</SCRIPT>");
			document.write("</a>");
		document.write("</div>");
	document.write("</li>");
	

			document.write("</ul>");
}						

function DrawStatus_subnav()
{
			document.write("<ul id=\"Status_subnav\" class=\"subnav_group\">");
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Status/Device_Info.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtDeviceInfo\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Status/Logs.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtViewLogs\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Status/Statistics.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtTrafficStatistics\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Status_Internet_Sessions_nav_link\" href=\"javascript:location='../Status/Internet_Sessions.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtInternetSessions2\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				document.write("<li>");
					document.write("<div>");
						document.write("<a id=\"Status_wireless_nav_link\" href=\"javascript:location='../Status/Wireless.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtWireless\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				
				
				//document.write("<li>");
				////	document.write("<div >");
				//		document.write("<a id=\"Status_WISH_nav_link\" href=\"javascript:location='../Status/WISH_Sessions.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">WISH Sessions</a>");
				//	document.write("</div>");
				//document.write("</li>");				
				
				document.write("<li>");
		document.write("<div>");
			document.write("<a id=\"\" href=\"javascript:location='../logout.asp?t='+new Date().getTime();\" >");
				document.write("<SCRIPT>ddw(\"txtLogout2\");</SCRIPT>");
			document.write("</a>");
		document.write("</div>");
	document.write("</li>");
					
			document.write("</ul>");
}

function DrawHelp_subnav()
{
			document.write("<ul id=\"Help_subnav\" class=\"subnav_group\">");
				document.write("<li>");
					document.write("<div>");
						document.write("<a href=\"javascript:location='../Help/Menu.asp?t='+new Date().getTime();\" onclick=\"return jump_if();\">");
							document.write("<SCRIPT>ddw(\"txtMenu\");</SCRIPT>");
						document.write("</a>");
					document.write("</div>");
				document.write("</li>");
				document.write("<li>");
					document.write("<div>");
			document.write("<a id=\"\" href=\"javascript:location='../logout.asp?t='+new Date().getTime();\" >");
				document.write("<SCRIPT>ddw(\"txtLogout2\");</SCRIPT>");
			document.write("</a>");
		document.write("</div>");
	document.write("</li>");
	
			document.write("</ul>");
}
			

var __AjaxReq = null;
var __update_wan_conn_status_period=6000;

function __createRequest()
{
	var request = null;
	try { request = new XMLHttpRequest(); }
	catch (trymicrosoft)
	{
		try { request = new ActiveXObject("Msxml2.XMLHTTP"); }
		catch (othermicrosoft)
		{
			try { request = new ActiveXObject("Microsoft.XMLHTTP"); }
			catch (failed)
			{
				request = null;
			}
		}
	}
	if (request == null) alert("Error creating request object !");
	return request;
}

function __send_request(url)
{
	if (__AjaxReq == null) __AjaxReq = __createRequest();
	__AjaxReq.open("GET", url, true);
	__AjaxReq.onreadystatechange = __update_page;
	__AjaxReq.send(null);
}

function generate_random_str()
{
	var d = new Date();
	var str=d.getFullYear()+"."+(d.getMonth()+1)+"."+d.getDate()+"."+d.getHours()+"."+d.getMinutes()+"."+d.getSeconds();
	return str;
}

function __update_state()
{
	__send_request("/wan_conninfo.asp?t="+generate_random_str());
}

function __update_page()
{
	var conn_msg="";
	if (__AjaxReq != null && __AjaxReq.readyState == 4)
	{
		if (__AjaxReq.responseText.substring(0,3)=="var")
		{
			eval(__AjaxReq.responseText);
			switch (__result[0])
			{
				case "OK":
					if(__result[1] == "connected")
					{
						get_by_id("wan_online").style.display = "";
						get_by_id("wan_offline").style.display = "none";
					}
					else
					{
						get_by_id("wan_online").style.display = "none";
						get_by_id("wan_offline").style.display = "";
					}
					break;

				default :
					get_by_id("wan_online").style.display = "none";
					get_by_id("wan_offline").style.display = "";					
					break;
			}
			setTimeout("__update_state()", __update_wan_conn_status_period);
			delete __result;
		}
	}
}

function DrawEarth_onlineCheck(onlineValue)
{
//setTimeout("__update_state()", __update_wan_conn_status_period);

if(onlineValue == 2) //2: online
{
document.write("<br><div id=\"wan_online\" style=\"display:none\"><table><tr><td><img src=\"../Images/wan_on.jpg\"></td>");
document.write("<td class=wansts>"+sw("txtInternetOnline")+"</td></tr></table></div>");
document.write("<div id=\"wan_offline\" style=\"display:none\"><table><tr>");
document.write("<td><img src=\"../Images/wan_off.jpg\"></td>");
document.write("<td class=wansts>"+sw("txtInternetOffline")+"</td>");
document.write("</tr></table></div><br></div>");
}
else
{
document.write("<br><div id=\"wan_online\" style=\"display:none\"><table><tr><td><img src=\"../Images/wan_on.jpg\"></td>");
document.write("<td class=wansts>"+sw("txtInternetOnline")+"</td></tr></table></div>");
document.write("<div id=\"wan_offline\" style=\"display:none\"><table><tr>");
document.write("<td><img src=\"../Images/wan_off.jpg\"></td>");
document.write("<td class=wansts>"+sw("txtInternetOffline")+"</td>");
document.write("</tr></table></div><br></div>");	
}

}
		
function do_dev_reboot()
{
	if(confirm(sw("txtRebootDevice"))==1)
	{
		get_by_id("reboot_form").Target.value= "resetonly";
		get_by_id("reboot_form").submit();
	}
}

function DrawRebootButton()
{	
	document.write("<form id=\"reboot_form\" name=\"reboot_form\" action=\"/goform/formSetFactory\" method=\"post\" >");
	document.write("<input type=\"hidden\" id=\"Target\" name=\"Target\" value=\"\"/>")
	document.write("<div id=\"reboot_button\" style=\"display:none\"><table><tr><td align=center width=120><input type=button name=\"never_disabled\" value=Reboot onclick=\"do_dev_reboot();\"></td></tr></table></div>");
	document.write("</form>");
}

function DrawLanguageList()
{	
		document.write("<!-- language selection functions -->");
		document.write("<form id=\"lang_form\" name=\"lang_form\" action=\"/goform/formLanguageChange\" method=\"post\" >");
		  document.write("<input type=\"hidden\" id=\"nextPage\" name=\"nextPage\" value=\"\"/>");
		  document.write("<input type=\"hidden\" id=\"currTime\" name=\"currTime\" value=\"\"/>");
			document.write("<div id=\"lang_container\">");
				document.write("<span id=\"i18n_language_selection\">");
					document.write("<select>");
						document.write("<option value=\"DE\">Deutsch</option>");
						document.write("<option value=\"EN\" selected=\"selected\">English</option>");
						document.write("<option value=\"ES\">Espa&#241;ol</option>");
						document.write("<option value=\"FR\">Fran&#231;ais</option>");
						document.write("<option value=\"IT\">Italiano</option>");
						document.write("<option value=\"JA\">&#26085;&#26412;&#35486;</option>");
						document.write("<option value=\"KO\">&#54620;&#44397;&#50612;</option>");
						document.write("<option value=\"PT\">Portugu&#234;s</option>");
						document.write("<option value=\"ZH\">&#20013;&#25991;</option>");
					document.write("</select>");
				document.write("</span>");
				document.write("<input type=\"hidden\" id=\"i18n_language\" name=\"config.i18n_language\" value=\"\" />");
			document.write("</div>");
		document.write("</form>");		
}

function DrawRebootContent(mode)
{
	document.write("<div id=\"rebootcontent\" style=\"display: none\">");
	document.write("	<div class=\"section\">");
	document.write("		<div class=\"section_head\">");
	document.write("			<h2>");
	document.write("				<SCRIPT>ddw(\"txtRebootNeeded\");</SCRIPT>");
	document.write("			</h2>");
	document.write("			<p>");
	document.write("				<SCRIPT>ddw(\"txtIndexStr5\");</SCRIPT>");
	document.write("			</p>");
	document.write("			<form id=\"rebootdummy\" name=\"rebootdummy\" action=\"/goform/formDeviceReboot\" method=\"post\">");
  document.write("      <input type=\"hidden\" name=\"next_page\" value=\"\"/>");
  document.write("      <input type=\"hidden\" name=\"act\" value=\"\"/>");
  document.write("      <input type=\"hidden\" name=\"actmode\" value=\""+mode+"\"/>");
	document.write("			<input class=\"button_submit\" id=\"RestartNow\" type=\"button\" value=\"\" onclick=\"do_reboot()\" />");
	document.write("			<input class=\"button_submit\" id=\"RestartLater\" type=\"button\" value=\"\" onclick=\"no_reboot()\" />");
	document.write("			</form>");
	document.write("		</div>");
	document.write("	</div> <!-- reboot_warning -->");
	document.write("</div>");
}

function DrawSaveButton()
{
	document.write("<input class=\"button_submit\" type=\"button\" id=\"SaveSettings\" value=\"\" onclick=\"page_submit()\"/>");
	document.write("<input class=\"button_submit\" type=\"button\" id=\"DontSaveSettings\" value=\"\" onclick=\"page_cancel()\"/>");	
}

function DrawSaveButton_Btm()
{
	document.write("<div>");
	document.write("<br>&nbsp;");
	document.write("<input class=\"button_submit\" type=\"button\" id=\"SaveSettings_Btm\" value=\"\" onclick=\"page_submit()\"/>");
	document.write("<input class=\"button_submit\" type=\"button\" id=\"DontSaveSettings_Btm\" value=\"\" onclick=\"page_cancel()\"/>");	
	document.write("<br><br>");
	document.write("</div>");
}

function SubnavigationLinks(wlan_enabled, op_mode)
{
			var wireless_enabled = wlan_enabled == "1";
			set_subnav_link(wireless_enabled, "Advanced_wireless_nav_link");
			

			

			var wireless_enabled = wlan_enabled == "1";
			set_subnav_link(wireless_enabled, "Status_wireless_nav_link");

			
			
			var router_mode_enabled = op_mode != "1";
			set_subnav_link(router_mode_enabled, "Basic_Internet_nav_link");
			set_subnav_link(router_mode_enabled, "Wizard_Easy_link"); //ada
			set_subnav_link(router_mode_enabled, "Advanced_Virtual_Server_nav_link");
			set_subnav_link(router_mode_enabled, "Advanced_Special_Applications_nav_link");
			set_subnav_link(router_mode_enabled, "MAC_Address_Filter_nav_link");
set_subnav_link(router_mode_enabled, "ACL_Address_Filter_nav_link");
	
			set_subnav_link(router_mode_enabled, "Advanced_Firewall_nav_link");
			set_subnav_link(router_mode_enabled, "Advanced_Network_nav_link");

			set_subnav_link(router_mode_enabled, "Advanced_Routing_nav_link");
			
			set_subnav_link(router_mode_enabled, "Traffic_Shaping_nav_link");
			set_subnav_link(router_mode_enabled, "Advanced_Web_Filter_nav_link");
			set_subnav_link(router_mode_enabled, "Tools_Dynamic_DNS_nav_link");
			set_subnav_link(router_mode_enabled, "Status_Internet_Sessions_nav_link");
}
