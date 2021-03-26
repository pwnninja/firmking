<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />

	<link rel="stylesheet" rev="stylesheet" href="../style.css" type="text/css" />
		
	<link rel="stylesheet" rev="stylesheet" href="../<% getInfo("substyle");%>" type="text/css" />
	
	
	<script language="JavaScript" type="text/javascript">
	<!--
	var lang = "<% getLangInfo("lang");%>";
	//-->
	</script>
	<!-- InstanceEndEditable -->

	<!-- InstanceBeginEditable name="Local Styles" -->
	<style type="text/css">
	/*
	 * Styles used only on this page.
	 */
	</style>
	<!-- InstanceEndEditable -->

	
		
	

	<script type="text/javascript" src="../ubicom.js"></script>
	<script type="text/javascript" src="../xml_data.js"></script>
	<script type="text/javascript" src="../navigation.js"></script>
	<% getLangInfo("LangPath");%>
	<script type="text/javascript" src="../utility.js"></script>
	<script type="text/javascript">
	//<![CDATA[
var WLAN_ENABLED; 
var OP_MODE;
if('<%getInfo("opmode");%>' =='Disabled')
	OP_MODE='1';
else
	OP_MODE='0';
if('<%getIndexInfo("wlanDisabled");%>'=='Disabled')
	WLAN_ENABLED='0';
else
	WLAN_ENABLED='1';
		
		
		//2007.11.27
		function update_wan_ip_mode_list()
		{
			mf.wan_ip_mode_select.length = 0;
			mf.wan_ip_mode_select[0] = new Option(sw("txtStaticIP"), "0", false, false);
	    mf.wan_ip_mode_select[1] = new Option(sw("txtDynamicIP"), "1", false, false);
			mf.wan_ip_mode_select[2] = new Option("PPPoE "+sw("txtUsernamePassword"), "2", false, false);
			mf.wan_ip_mode_select[3] = new Option("PPTP "+sw("txtUsernamePassword"), "3", false, false);
			mf.wan_ip_mode_select[4] = new Option("L2TP "+sw("txtUsernamePassword"), "4", false, false);
			//mf.wan_ip_mode_select[5] = new Option("BigPond "+sw("txtAustralia"), "5", false, false);		
if(LangCode == "SC")
				mf.wan_ip_mode_select[5] = new Option("DHCP+("+sw("txtDynamicIP")+")", "9", false, false);

		}


		/*
		 * Used by template.js.
		 * You cannot put this function in a sourced file, because SSI will not process it.
		 */


		function get_webserver_ssi_uri() {
			return ("" !== "") ? "/Basic/Setup.asp" : "/Basic/WAN.asp";
		}
function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}		
		var ItvID=0;
function template_load()
		{
<% getFeatureMark("MultiLangSupport_Head_script");%>
lang_form = document.forms.lang_form;
if ("" === "") {
assign_i18n();
lang_form.i18n_language.value = "<%getLangInfo("langSelect")%>";
}
<% getFeatureMark("MultiLangSupport_Tail_script");%>
/** Prepend "0" to Firmware minor version if it is less than 10*/
var global_fw_minor_version = "<%getInfo("fwVersion")%>";
var fw_extend_ver = "";			
var fw_minor;
assign_firmware_version(global_fw_minor_version,fw_extend_ver,fw_minor);
var hw_version="<%getInfo("hwVersion")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = modelname;
/** Enable or disable subnavigation links depending on feature options.*/
SubnavigationLinks(WLAN_ENABLED, OP_MODE);
topnav_init(document.getElementById("topnav_container"));
page_load();
/** Render any warnings to the user*/
RenderWarnings();
}


		var verify_failed = "<%getInfo("err_msg")%>";

		/*
		 * Handle for document.form["mainform"].
		 */
		var mf;


		var pcmac;
		var remote_login;



		// 2007.08.02
		var default_idle_time = parseInt("5",10);




		/*
		 * wan_ip_mode_selector()
		 *	Hide or show WAN settings according to selected WAN mode.
		 */
		function wan_ip_mode_selector(mode)
		{
			var html_file="";
			/*
			 * Get a numerical mode
			 */
			mode = mode * 1;

			switch(mode)
			{
				case STATIC:
					html_file = "wan_static.asp";
					break;
					
				case DHCP:
					html_file = "wan_dhcp.asp";
					break;
				
				case PPPOE:
					html_file = "wan_pppoe.asp";
					break;
				
				case PPTP:
					html_file = "wan_pptp.asp";
					break;
				
				case L2TP:
					html_file = "wan_l2tp.asp";
					break;
				
				case BIGPOND:
					html_file = "wan_bigpond.asp";
					break;
					
				case DHCPPLUS:
					html_file = "wan_dhcpplus.asp";			
					break;						
			}
			/*
			 * Restore the form to its on-load values
			 */
			reset_form("mainform");

			/*
			 * Update to the correct default MTU provided the mode actually changed
			 */
			 
			if(mode != mf.wan_ip_mode.value) 
			{
				window.location.href=html_file+"?t="+new Date().getTime();
				mf.wan_mtu.value = mtu_default_values[mode];

			}
			

			//document.getElementById("box_wan_static").style.display = mode == STATIC ? "block" : "none";

		}

		function disable_route_protocol_table()
		{
			var route_protocol_table_size = parseInt("32", 10);
			for (var i = 0; i < 10; i++) {
				mf["p_enabled_select_" + i].disabled = true;
				mf["p_entry_name_" + i].disabled = true;
				mf["p_dest_port_start_" + i].disabled = true;
				mf["p_dest_port_end_" + i].disabled = true;
				mf["p_traffic_type_select_" + i].disabled = true;
			}
		}
		

		function page_load() 
		{
			var oldmac;
			displayOnloadPage("<%getInfo("ok_msg")%>");
			/*
			 * Get a handle to the main form
			 */
			mf = document.forms["mainform"];

			/*
			 * Initialise this to local login before checking for local debugging
			 */
			remote_login = false;
			
			update_wan_ip_mode_list();
      
			pcmac = "<% getInfo("host-hwaddr"); %>";
			remote_login = (pcmac == "00:00:00:00:00:00") ? true : false;
			oldmac=mf.mac_cloning_address.value; 
			mf.mac1.value=oldmac.substring(0,2);
			mf.mac2.value=oldmac.substring(3,5);
			mf.mac3.value=oldmac.substring(6,8);
			mf.mac4.value=oldmac.substring(9,11);
			mf.mac5.value=oldmac.substring(12,14);
			mf.mac6.value=oldmac.substring(15,17);
			/*
			 * Track the WAN mode
			 */
			mf.wan_ip_mode.value = STATIC;
			mf.wan_ip_mode_select.value = STATIC;

			/*
			 * Show the MTU default for this mode
			 */
			 
			/*document.getElementById("wan_mtu_default").innerHTML = mtu_default_values[mf.wan_ip_mode.value];*/
			mf["dsl_mode"].value = 0;

			/*
			 * Assert form defaults so we know if the user changed something
			 */
			set_form_default_values("mainform");


			/* Check for validation errors. */
			if (verify_failed != "") {
				set_form_always_modified("mainform");
				alert(verify_failed);
			}
			
			
		}

		function clone_mac() {
			var copy_mac;
			mf.mac_cloning_address.value = pcmac;
			mf.mac_cloning_enabled.value = "true";
			copy_mac=mf.mac_cloning_address.value; 
			mf.mac1.value=copy_mac.substring(0,2);
			mf.mac2.value=copy_mac.substring(3,5);
			mf.mac3.value=copy_mac.substring(6,8);
			mf.mac4.value=copy_mac.substring(9,11);
			mf.mac5.value=copy_mac.substring(12,14);
			mf.mac6.value=copy_mac.substring(15,17);
		}
					

		function page_submit(mode)
		{
			var mac_addr;
			if (!is_form_modified("mainform"))
			{
				if(!confirm(sw("txtSaveAnyway"))) 
					return false;
			}
			else
			{


				/*
				 * Make sure mode is an integer and not a string
				 */
				mode = mode * 1;
				if (!is_ipv4_valid(mf.wan_ip_address.value) || mf.wan_ip_address.value=="0.0.0.0" || is_FF_IP(mf.wan_ip_address.value)) {
					alert(sw("txtInvalidWANIPaddress") + mf.wan_ip_address.value);
					try	{
						mf.wan_ip_address.select();
						mf.wan_ip_address.focus();
					} catch (e) {
					}
					return;
				}
				if (!is_ipv4_valid(mf.wan_subnet_mask.value) || 	!is_mask_valid(mf.wan_subnet_mask.value) )
				{
					alert(sw("txtInvalidWANsubnetMask") + mf.wan_subnet_mask.value);
					try	{
						mf.wan_subnet_mask.select();
						mf.wan_subnet_mask.focus();
					} catch (e) {
					}
					return;
				}
				if (!is_ipv4_valid(mf.wan_gateway.value) || mf.wan_gateway.value=="0.0.0.0" || is_FF_IP(mf.wan_gateway.value) ) {
					alert(sw("txtInvalidGatewayIPAddress") + mf.wan_gateway.value);
					try	{
						mf.wan_gateway.select();
						mf.wan_gateway.focus();
					} catch (e) {
					}
					return;
				}
				var lan_ip_str = "<% getInfo("ip-rom"); %>";
				var LAN_IP = ipv4_to_unsigned_integer(lan_ip_str);
				var lan_mask_str = "<% getInfo("mask-rom"); %>"
				var LAN_MASK = ipv4_to_unsigned_integer(lan_mask_str);
				var wan_ip = ipv4_to_unsigned_integer(mf.wan_ip_address.value);
				var mask_ip = ipv4_to_unsigned_integer(mf.wan_subnet_mask.value);
				var gw_ip = ipv4_to_unsigned_integer(mf.wan_gateway.value);
 		        var b255 = ipv4_to_unsigned_integer("255.255.255.255");
                b255 ^= mask_ip;
		        if((b255 & wan_ip) == b255)
		        {
		            alert(sw("txtWanIp")+" "+integer_to_ipv4(wan_ip)+" "+sw("txtShouldNotBroadcast"));
                    return false;
		        }
				if((wan_ip & b255) == 0)
				{
					alert(sw("txtWanIp")+" "+integer_to_ipv4(wan_ip)+" "+sw("txtShouldNotNetworkAddr"));
					return false;
				}
		        if((b255 & gw_ip) == b255)
		        {
                    alert(sw("txtWANGwIp")+" "+integer_to_ipv4(gw_ip)+" "+sw("txtShouldNotBroadcast"));
		            return false;
		        }
				if((gw_ip & b255) == 0)
				{
					alert(sw("txtWANGwIp")+" "+integer_to_ipv4(gw_ip)+" "+sw("txtShouldNotNetworkAddr"));
					return false;
				}
				if ((wan_ip & mask_ip) != (gw_ip & mask_ip))
				{
					alert(sw("txtWANGwIp")+" "+integer_to_ipv4(gw_ip)+" "+sw("txtWithinWanSubnet"));
					return false;
				}
				if ((LAN_IP & LAN_MASK) == (wan_ip & LAN_MASK))
				{
					alert(sw("txtWanSubConflitLanSub"));
					return false;
				}
	
				/*
				 * Check DNS IP's for well-formed-ness
				 */
				mf.wan_primary_dns.value = trim_string(mf.wan_primary_dns.value);
				mf.wan_secondary_dns.value = trim_string(mf.wan_secondary_dns.value);
	
				/*
				 * Allow blank as wel as 0.0.0.0 for primary and secondary
				 */
				mf.wan_primary_dns.value = mf.wan_primary_dns.value == "" ? "0.0.0.0" : mf.wan_primary_dns.value;
				mf.wan_secondary_dns.value = mf.wan_secondary_dns.value == "" ? "0.0.0.0" : mf.wan_secondary_dns.value;
	
				if(!is_valid_ip(mf.wan_primary_dns.value)||!is_valid_gateway(lan_ip_str,lan_mask_str,mf.wan_primary_dns.value)||!is_valid_gateway(mf.wan_ip_address.value,mf.wan_subnet_mask.value,mf.wan_primary_dns.value))
				{
					alert(sw("txtInvalidPPPoEPrimaryDNS") +  mf.wan_primary_dns.value);
					try {
						mf.wan_primary_dns.select();
						mf.wan_primary_dns.focus();
					} catch (e) {
					}
					return;
				}
				if(mf.wan_secondary_dns.value != "0.0.0.0")
				{
					if(!is_valid_ip(mf.wan_secondary_dns.value)||!is_valid_gateway(lan_ip_str,lan_mask_str,mf.wan_secondary_dns.value)||!is_valid_gateway(mf.wan_ip_address.value,mf.wan_subnet_mask.value,mf.wan_secondary_dns.value))
					{
						alert(sw("txtInvalidPPPoESecondaryDNS") +  mf.wan_secondary_dns.value);
						try {
							mf.wan_secondary_dns.select();
							mf.wan_secondary_dns.focus();
						} catch (e) {
						}
						return;
					}
				}
				if ((mf.wan_primary_dns.value != "0.0.0.0") || (mf.wan_secondary_dns.value != "0.0.0.0")) {
					mf.wan_force_static_dns_servers.value = "true";
				} else {
					mf.wan_force_static_dns_servers.value = "false";
				}

                                if((mf.wan_primary_dns.value != "0.0.0.0") && mf.wan_primary_dns.value == mf.wan_secondary_dns.value)
                                {
                                        alert(sw("txtSameDNS"));
                                        mf.wan_secondary_dns.select();
                                        mf.wan_secondary_dns.focus();
                                        return 0;
                                }

				/*
				 * MTU
				 */

				if (!is_number(mf.wan_mtu.value)) {
					alert(sw("txtInvalidMTUSize"));
					try {
						mf.wan_mtu.select();
						mf.wan_mtu.focus();
					} catch (e) {
					}
					return;
				}
				if(mf.wan_mtu.value > 1500 || mf.wan_mtu.value < 576)
				{
					alert(sw("txtInvalidMTUSize")+"("+sw("txtPermittedRange")+sw("txtMtuRng576to1500")+")");
					return false;
				}

				/*
				 * Validate MAC and activate cloning if necessary
				 */			

			
				mf.mac_cloning_address.value=mf.mac1.value+':'+mf.mac2.value+':'+mf.mac3.value+':'+mf.mac4.value+':'+mf.mac5.value+':'+mf.mac6.value;
				mf.mac_cloning_address.value = trim_string(mf.mac_cloning_address.value);
				if(!verify_mac(mf.mac_cloning_address.value,mf.mac_cloning_address))
				{
					alert (sw("txtInvalidMACAddress") + " "+mf.mac_cloning_address.value + ".");
					return;
				}
				if(mf.mac_cloning_address.value == "00:00:00:00:00:00") {
					mf.mac_cloning_enabled.value = "false";
				}			
				else
				{
					mf.mac_cloning_enabled.value = "true";
				}
				mac_addr = mf.mac_cloning_address.value.split(":");					
					mf.mac_clone.value = "";
				for(var i=0;i<mac_addr.length;i++)
				{
					mf.mac_clone.value += mac_addr[i];
				}
				mf["settingsChanged"].value = 1;
			}
			
			if(mf["dsl_mode"].value != <%getInfo("wanType");%>)
				mf["settingsChanged"].value = 1;
				
			mf.curTime.value = new Date().getTime();	
			mf.submit();
		}

		function init()
		{
			var DOC_Title= sw("txtTitle")+" : "+sw("txtSetup")+'/'+sw("txtWAN");
			document.title = DOC_Title;
			get_by_id("RestartNow").value = sw("txtRebootNow");
			get_by_id("RestartLater").value = sw("txtRebootLater");
			get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");
			get_by_id("SaveSettings").value = sw("txtSaveSettings");			
			get_by_id("clone_mac_addr").value = sw("txtCopyMACAddress");
			get_by_id("DontSaveSettings_Btm").value = sw("txtDontSaveSettings");
			get_by_id("SaveSettings_Btm").value = sw("txtSaveSettings");		
		}

	//]]>
	</script>
</head>
<body onload="template_load(); init();web_timeout();">
	<div id="loader_container" onclick="return false;">&nbsp;</div>
	<div id="outside">
		<table id="table_shell" cellspacing="0" summary=""><col span="1"/>
			<tr>
				<td>
					<SCRIPT >
						DrawHeaderContainer();
						DrawMastheadContainer();
						DrawTopnavContainer();
					</SCRIPT>



					<table id="content_container" border="0" cellspacing="0" summary=""><col span="3"/>
						<tr>
										
							<td id="sidenav_container">
								<div id="sidenav">
					<SCRIPT >
								DrawBasic_subnav();
								DrawAdvanced_subnav();
								DrawTools_subnav();
								DrawStatus_subnav();
								DrawHelp_subnav();
DrawEarth_onlineCheck(<%getWanConnection("");%>);
DrawRebootButton();
					</SCRIPT>
								</div>
										
<% getFeatureMark("MultiLangSupport_Head");%>
					<SCRIPT >
								DrawLanguageList();
					</SCRIPT>
<% getFeatureMark("MultiLangSupport_Tail"); %>								
							</td>

							<td id="maincontent_container">
					<SCRIPT >
								DrawRebootContent("wan");
					</SCRIPT>

								<div id="warnings_section" style="display:none">
									<div class="section" >
										<div class="section_head">
											<h2>
												<SCRIPT >ddw("txtConfigurationWarnings");</SCRIPT>
											</h2>
											<div style="display:block" id="warnings_section_content">
											</div>
										</div>
									</div>
								</div>
								<div id="maincontent" style="display: block">
			<form name="mainform" action="/goform/formSetWanNonLogin" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
				<input type="hidden" id="webpage" name="webpage" value="/Basic/wan_static.asp">
				<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
				<input type="hidden" id="curTime" name="curTime" value=""/>	
				<input type="hidden" id="dsl_mode" name="dsl_mode" value="<%getInfo("wanType");%>"/>
				<div class="section">
					<div class="section_head"> 
						<h2><SCRIPT >ddw("txtWAN");</SCRIPT></h2>
						<p>
							<SCRIPT >ddw("txtWANStr2");</SCRIPT>
						</p> 
						<p>
							<b>
								<SCRIPT >ddw("txtNote");</SCRIPT>
							&nbsp;:</b> 
								<SCRIPT >ddw("txtWANStr3");</SCRIPT>
						</p> 
												<input class="button_submit" type="button" id="SaveSettings" name="SaveSettings" value="" onclick="page_submit();"/>
												<input class="button_submit" type="button" id="DontSaveSettings" name="DontSaveSettings" value="" onclick="page_cancel();"/>
					</div>
				</div>
				<div class="box"> 
					<h3>
						<SCRIPT >ddw("txtInternetConnectionType");</SCRIPT>
					</h3>
					<p class="box_msg"> 
						<SCRIPT >ddw("txtWANStr5");</SCRIPT>						 
					</p>
					<fieldset>
						<p> 
							<input type="hidden" name="config.wan_force_static_dns_servers" id="wan_force_static_dns_servers" value="false" />
							<input type="hidden" name="config.wan_ip_mode" id="wan_ip_mode" value="<%getInfo("wanType");%>" />
							<input type="hidden" name="config.bigpond_enable" id="bigpond_enable" value="false" />
							<label class="duple">
								<SCRIPT >ddw("txtWANStr4");</SCRIPT>
							&nbsp;:</label>
							<select id="wan_ip_mode_select" onchange="wan_ip_mode_selector(this.value);">
							// 2007.11.27 
								
							</select>
						</p>
					</fieldset>
				</div>
				<div class="box"> 
					<div  id="box_wan_static" style="display:block"> 
						<h3>
							<SCRIPT >ddw("txtWANStr6");</SCRIPT>
						&nbsp;</h3>
						<p class="box_msg"> 
						<SCRIPT >ddw("txtWANStr7");</SCRIPT>
					</p>
					</div>
					
					<fieldset>
						<div id="box_wan_static_body" style="display:block"> 
							<p> 
								<label class="duple" for="wan_ip_address">
									<SCRIPT >ddw("txtIPAddress");</SCRIPT>									
								&nbsp;:</label>
								<input type="text" id="wan_ip_address" size="20" maxlength="15" value="<% getInfo("wan-ip-rom");%>" name="config.wan_ip_address"/>
								<SCRIPT >ddw("txtAssignByIsp");</SCRIPT>
							</p>
							<p> 
								<label class="duple" for="wan_subnet_mask">
									<SCRIPT >ddw("txtSubnetMask2");</SCRIPT>
								&nbsp;:</label>
								<input type="text" id="wan_subnet_mask" size="20" maxlength="15" value="<% getInfo("wan-mask-rom");%>" name="config.wan_subnet_mask"/>
							</p>
							<p> 
								<label class="duple" for="wan_gateway">
									<SCRIPT >ddw("txtDefaultGateway");</SCRIPT>									
								&nbsp;:</label>
								<input type="text" id="wan_gateway" size="20" maxlength="15" value="<% getInfo("wan-gateway-rom");%>" name="config.wan_gateway"/>
							</p>
						
						<p>	<label class="duple" for="mac_cloning_address"><SCRIPT >ddw("txtMACAddress");</SCRIPT>&nbsp;:</label>
							<input type="hidden" id="mac_cloning_address" size="20" maxlength="17" value="<% getInfo("wanMac"); %>" name="config.mac_cloning_address" />
							<input type="hidden" id="mac_cloning_enabled" name="config.mac_cloning_enabled" value="true"/>
							<input type="hidden" id="mac_clone" name="mac_clone" value=""/>
								<input type=text id=mac1 name=mac1 size=2 maxlength=2 value=""> -
								<input type=text id=mac2 name=mac2 size=2 maxlength=2 value=""> -
								<input type=text id=mac3 name=mac3 size=2 maxlength=2 value=""> -
								<input type=text id=mac4 name=mac4 size=2 maxlength=2 value=""> -
								<input type=text id=mac5 name=mac5 size=2 maxlength=2 value=""> -
								<input type=text id=mac6 name=mac6 size=2 maxlength=2 value=""> <SCRIPT >ddw("txtOptional");</SCRIPT>&nbsp;&nbsp;
						</p>
								<p><label class="duple">&nbsp;</label>
										<input class="button_submit" type="button" id="clone_mac_addr" value="" onclick="clone_mac();" />
								</p>
						</div>
						<div id="box_wan_general_body_dns" style="display:block"> 
						<p> 
							<label class="duple" for="wan_primary_dns"><SCRIPT >ddw("txtPrimaryDNSServer");</SCRIPT>&nbsp;:</label>
							<input type="text" id="wan_primary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns1");%>" name="config.wan_primary_dns"/>
							<!--2007.04.16 --><label for="wan_primary_dns" id="wan_primary_dns_optional" style="display: none;"><SCRIPT >ddw("txtOptional");</SCRIPT></label>
							
						</p>
						<p> 
							<label class="duple" for="wan_secondary_dns"><SCRIPT >ddw("txtSecondaryDNSServer");</SCRIPT>&nbsp;:</label>
							<input type="text" id="wan_secondary_dns" size="20" maxlength="15" value="<% getInfo("wan-dns2");%>" name="config.wan_secondary_dns" />
							<SCRIPT >ddw("txtOptional");</SCRIPT>
						</p>
						</div>
						<div id="box_wan_general_body" style="display:block"> 
						<p> 
							<label class="duple" for="wan_mtu">MTU&nbsp;:</label>
							<input type="hidden" name="config.wan_mtu_use_default" id="wan_mtu_use_default" value="true" />
							<input type="text" id="wan_mtu" size="10" maxlength="5" value="<%getInfo("fixedIpMtuSize");%>" name="config.wan_mtu" />
							<SCRIPT >ddw("txtBytes");</SCRIPT>
							<SCRIPT >ddw("txtMTUdefault");</SCRIPT>
							<SCRIPT >ddw("txtStaticMTUdefault");</SCRIPT>
						</p>
						
						</div>
					</fieldset>
				</div>
				
			</form>
								<SCRIPT language=javascript>DrawSaveButton_Btm();</SCRIPT>
								</div>
							</td>
							<td id="sidehelp_container">
								<div id="help_text">
									<strong>
										<SCRIPT >ddw("txtHelpfulHints");</SCRIPT>
									...</strong>
										<p>
											<SCRIPT >ddw("txtWANStr10");</SCRIPT>
										</p>
										<p>
											<SCRIPT >ddw("txtWANStr11");</SCRIPT>
										</p>
										<p class="more">
											<!-- Link to more help -->
											<a href="../Help/Basic.asp#WAN" onclick="return jump_if();">
												<SCRIPT >ddw("txtMore");</SCRIPT>...
											</a>
										</p>
								<!-- InstanceEndEditable -->
								</div>
							</td>

						</tr>
					</table>
					<table id="footer_container" border="0" cellspacing="0" summary="">
						<tr>
							<td>
								<img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
							</td>
							<td>&nbsp;

							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

		<SCRIPT language=javascript>print_copyright();</SCRIPT>
	</div>
</body>
</html>
