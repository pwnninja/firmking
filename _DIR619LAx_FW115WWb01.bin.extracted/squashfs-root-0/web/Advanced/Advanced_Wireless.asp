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

function get_webserver_ssi_uri() {
	return ("" !== "") ? "/Basic/Setup.asp" : "/Advanced/Advanced_Wireless.asp";
}

		
function web_timeout()
{
setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}
function template_load()
{
<% getFeatureMark("MultiLangSupport_Head_script");%>
lang_form = document.forms.lang_form;
if ("" === "") {
assign_i18n();
lang_form.i18n_language.value = "<%getLangInfo("langSelect")%>";
}
<% getFeatureMark("MultiLangSupport_Tail_script");%>
var global_fw_minor_version = "<%getInfo("fwVersion")%>";
var fw_extend_ver = "";			
var fw_minor;
assign_firmware_version(global_fw_minor_version,fw_extend_ver,fw_minor);
var hw_version="<%getInfo("hwVersion")%>";
document.getElementById("hw_version_head").innerHTML = hw_version;
document.getElementById("product_model_head").innerHTML = modelname;
SubnavigationLinks(WLAN_ENABLED, OP_MODE);
topnav_init(document.getElementById("topnav_container"));
page_load();
RenderWarnings();
}

var DEFAULT_CHANNEL_A = 40;
var DEFAULT_CHANNEL_G = 6;

/*
 *  802.11 band
 *  On some UI, we split phy modes into two drop down list for the user to select
 *	2.4GHz
 * 		11b only
 * 		11g only
 *		11n only
 *		mixed 11g, 11b
 *		mixed 11n, 11g
 * 		mixed 11n, 11g, and 11b
 * 	5Ghz
 * 		11a only
 *		11n only
 *		mixed 11n and 11a
 */
 var DEFAULT_BAND = "2";	// 2.4GHz or 5GHz or both, used for the UIs that do not need to split the drop down list.
 var G_BAND_ONLY = "0";		// 2.4GHz
 var A_BAND_ONLY = "1";		// 5GHz

/* Default phy mode to be selected */
 var DEFAULT_PHY_MODE_G_BAND = "11";
 var DEFAULT_PHY_MODE_A_BAND = "20";
 var DEFAULT_PHY_MODE_A_AND_G_BAND = "31";

/* 
 * This defines a Radio object with properties that are used to include or
 *	exclude optional sections on the web pages.
 *	It also provides methods to populate radio settings <select>'s.
 */

function Radio()
{
/*
* Define radio's attributes and their default values.
*/
this.region = parseInt("4");
this.type = ""
this.type_A = false;
this.type_B = false;
this.type_G = false;
this.type_NG = false;
this.type_NA = false;
this.super_G = false;
this.turbo_A = false;
this.auto_channel = false;
this.adaptive_radio = false;
this.ar5416_extra = false;
this.scan_type_dual = false;
this.rf_test_mode = false;
this.band = DEFAULT_BAND;

/* Update attribute values according to configuration. */
//
this.type = "BG";
this.type_B = true;
this.type_G = true;
this.super_G = true;
//
this.type = "BGN";
this.type_NG = true;
this.super_G = false;
//
//
// 2007/08/01 
if (this.region > 3) {
//
}
this.auto_channel = true;
this.adaptive_radio = true;

this.turbo_A = false;

/* Private method to easily add an <option> to a given <select>. */
function add(select, name, value)
{
if (( value >= 52) && (value < 149) && name.match("GHz - CH")) {
return;
}
select.options.add(new Option(name, value));
}

/* Standard toString method. */
this.toString = function () {
return this.type;
};

/* Get the default channel for the radio */
this.get_default_channel = function() {
if (this.type_A || this.type_NA) {
return DEFAULT_CHANNEL_A;
} else {
return DEFAULT_CHANNEL_G;
}
}

/*
* populate_channel_selector()
*	Adds channel <option>'s to the given <select>.
*/
this.populate_channel_selector = function (select) {
if (this.type_B || this.type_G || this.type_NG) {
if (this.region == 2) {
add(select, "2.432 GHz - CH 5", 5);
add(select, "2.437 GHz - CH 6", 6);
add(select, "2.442 GHz - CH 7", 7);
add(select, "2.447 GHz - CH 8", 8);
add(select, "2.452 GHz - CH 9", 9);
add(select, "2.457 GHz - CH 10", 10);
add(select, "2.462 GHz - CH 11", 11);
add(select, "2.467 GHz - CH 12", 12);
add(select, "2.472 GHz - CH 13", 13);
}

if (this.region == 10) {
add(select, "2.457 GHz - CH 10", 10);
add(select, "2.462 GHz - CH 11", 11);
add(select, "2.467 GHz - CH 12", 12);
add(select, "2.472 GHz - CH 13", 13);
}

if (this.region != 2 && this.region != 10) {
add(select, "2.412 GHz - CH 1", 1);
add(select, "2.417 GHz - CH 2", 2);
add(select, "2.422 GHz - CH 3", 3);
add(select, "2.427 GHz - CH 4", 4);
add(select, "2.432 GHz - CH 5", 5);
add(select, "2.437 GHz - CH 6", 6);
add(select, "2.442 GHz - CH 7", 7);
add(select, "2.447 GHz - CH 8", 8);
add(select, "2.452 GHz - CH 9", 9);
add(select, "2.457 GHz - CH 10", 10);
add(select, "2.462 GHz - CH 11", 11);
}

if (this.region != 2 && this.region != 10 && this.region != 4 && this.region != 6 && this.region != 30) {
add(select, "2.467 GHz - CH 12", 12);
add(select, "2.472 GHz - CH 13", 13);
}

if (this.region == 16 || this.region == 17 || this.region == 19) {
add(select, "2.484 GHz - CH 14 (802.11b ONLY)", 14);
}

if (this.region == 26 || this.region == 27 || this.region == 28) {
add(select, "2.484 GHz - CH 14", 14);
}
}

/* Now add the 802.11a channels. */
if (!(this.type_A || this.type_NA)) {
return;
}

/*
Reason: SDK 7.4.2 patch
Modified: aaron
Date: 2008.01.16
*/
/*
*  	FCC1_FCCA 
*	FCC1_WORLD		
*	FCC2_FCCA		
*	FCC2_WORLD	
*	FCC2_ETSIC
*/
if (this.region == 4 || this.region == 5 || this.region == 6 || this.region == 7 || this.region == 8) {
add(select, "5.180 GHz - CH 36", 36);
add(select, "5.200 GHz - CH 40", 40);
add(select, "5.220 GHz - CH 44", 44);
add(select, "5.240 GHz - CH 48", 48);
add(select, "5.260 GHz - CH 52", 52);
add(select, "5.280 GHz - CH 56", 56);
add(select, "5.300 GHz - CH 60", 60);
add(select, "5.320 GHz - CH 64", 64);

add(select, "5.745 GHz - CH 149", 149);
add(select, "5.765 GHz - CH 153", 153);
add(select, "5.785 GHz - CH 157", 157);
add(select, "5.805 GHz - CH 161", 161);
add(select, "5.825 GHz - CH 165", 165);

if (this.region == 4 && this.turbo_A) {
add(select, "5.210 GHz - CH 42 Turbo", 42);
add(select, "5.250 GHz - CH 50 Turbo", 50);
add(select, "5.290 GHz - CH 58 Turbo", 58);
add(select, "5.760 GHz - CH 152 Turbo", 152);
add(select, "5.800 GHz - CH 160 Turbo", 160);
}
}

if (this.region == 9 || this.region == 10 || this.region == 11 || this.region == 12 || this.region == 13 || this.region == 14 || this.region == 15) {
add(select, "5.180 GHz - CH 36", 36);
add(select, "5.200 GHz - CH 40", 40);
add(select, "5.220 GHz - CH 44", 44);
add(select, "5.240 GHz - CH 48", 48);

if (this.region != 15) {
add(select, "5.260 GHz - CH 52", 52);
add(select, "5.280 GHz - CH 56", 56);
}

if (this.region != 15 && this.region != 11) {
add(select, "5.300 GHz - CH 60", 60);
add(select, "5.320 GHz - CH 64", 64);
}

if (this.region == 11 || this.region == 14) {
add(select, "5.500 GHz - CH 100", 100);
add(select, "5.520 GHz - CH 104", 104);
add(select, "5.540 GHz - CH 108", 108);
add(select, "5.560 GHz - CH 112", 112);
add(select, "5.580 GHz - CH 116", 116);
add(select, "5.600 GHz - CH 120", 120);
add(select, "5.620 GHz - CH 124", 124);
add(select, "5.640 GHz - CH 128", 128);
add(select, "5.660 GHz - CH 132", 132);
add(select, "5.680 GHz - CH 136", 136);
add(select, "5.700 GHz - CH 140", 140);
}
}
if (this.region == 16 || this.region == 17) {
add(select, "5.180 GHz - CH 36", 36);
add(select, "5.200 GHz - CH 40", 40);
add(select, "5.220 GHz - CH 44", 44);
add(select, "5.240 GHz - CH 48", 48);
}

if (this.region == 19) {
add(select, "5.170 GHz - CH 34", 34);
add(select, "5.190 GHz - CH 38", 38);
add(select, "5.210 GHz - CH 42", 42);
add(select, "5.230 GHz - CH 46", 46);
add(select, "4.920 GHz - CH 184", 184);
add(select, "4.940 GHz - CH 188", 188);
add(select, "4.960 GHz - CH 192", 192);
add(select, "4.980 GHz - CH 196", 196);
}

if (this.region == 18 || this.region == 20 || this.region == 21 || this.region == 22 || this.region == 23 || this.region == 24 || this.region == 25) {
add(select, "5.745 GHz - CH 149", 149);
add(select, "5.765 GHz - CH 153", 153);
add(select, "5.785 GHz - CH 157", 157);
add(select, "5.805 GHz - CH 161", 161);
if (this.region == 18 || this.region == 21 || this.region == 23 || this.region == 24) {
add(select, "5.825 GHz - CH 165", 165);
}
if (this.region == 18) {
add(select, "5.180 GHz - CH 36", 36);
add(select, "5.200 GHz - CH 40", 40);
add(select, "5.220 GHz - CH 44", 44);
add(select, "5.240 GHz - CH 48", 48);
}
if (this.region == 21) {
add(select, "5.260 GHz - CH 52", 52);
add(select, "5.280 GHz - CH 56", 56);
add(select, "5.300 GHz - CH 60", 60);
add(select, "5.320 GHz - CH 64", 64);
}
}
if (this.region >= 26 && this.region <= 31) {
add(select, "5.180 GHz - CH 36", 36);
add(select, "5.200 GHz - CH 40", 40);
add(select, "5.220 GHz - CH 44", 44);
add(select, "5.240 GHz - CH 48", 48);
add(select, "5.260 GHz - CH 52", 52);
add(select, "5.280 GHz - CH 56", 56);
add(select, "5.300 GHz - CH 60", 60);
add(select, "5.320 GHz - CH 64", 64);
if (this.region >= 26 && this.region <= 28) {
add(select, "5.500 GHz - CH 100", 100);
add(select, "5.520 GHz - CH 104", 104);
add(select, "5.540 GHz - CH 108", 108);
add(select, "5.560 GHz - CH 112", 112);
add(select, "5.580 GHz - CH 116", 116);
add(select, "5.600 GHz - CH 120", 120);
add(select, "5.620 GHz - CH 124", 124);
add(select, "5.640 GHz - CH 128", 128);
add(select, "5.660 GHz - CH 132", 132);
add(select, "5.680 GHz - CH 136", 136);
add(select, "5.700 GHz - CH 140", 140);
}
add(select, "5.745 GHz - CH 149", 149);
add(select, "5.765 GHz - CH 153", 153);
add(select, "5.785 GHz - CH 157", 157);
add(select, "5.805 GHz - CH 161", 161);
add(select, "5.825 GHz - CH 165", 165);
}

/*
*  	FCC3_FCCA 
*	FCC3_WORLD		
*/
if (this.region == 32 || this.region == 33) {
add(select, "5.180 GHz - CH 36", 36);
add(select, "5.200 GHz - CH 40", 40);
add(select, "5.220 GHz - CH 44", 44);
add(select, "5.240 GHz - CH 48", 48);
add(select, "5.260 GHz - CH 52", 52);
add(select, "5.280 GHz - CH 56", 56);
add(select, "5.300 GHz - CH 60", 60);
add(select, "5.320 GHz - CH 64", 64);

add(select, "5.500 GHz - CH 100", 100);
add(select, "5.520 GHz - CH 104", 104);
add(select, "5.540 GHz - CH 108", 108);
add(select, "5.560 GHz - CH 112", 112);
add(select, "5.580 GHz - CH 116", 116);
add(select, "5.600 GHz - CH 120", 120);
add(select, "5.620 GHz - CH 124", 124);
add(select, "5.640 GHz - CH 128", 128);
add(select, "5.660 GHz - CH 132", 132);
add(select, "5.680 GHz - CH 136", 136);
add(select, "5.700 GHz - CH 140", 140);

add(select, "5.745 GHz - CH 149", 149);
add(select, "5.765 GHz - CH 153", 153);
add(select, "5.785 GHz - CH 157", 157);
add(select, "5.805 GHz - CH 161", 161);
add(select, "5.825 GHz - CH 165", 165);

if (this.region == 4 && this.turbo_A) {
add(select, "5.210 GHz - CH 42 Turbo", 42);
add(select, "5.250 GHz - CH 50 Turbo", 50);
add(select, "5.290 GHz - CH 58 Turbo", 58);
add(select, "5.760 GHz - CH 152 Turbo", 152);
add(select, "5.800 GHz - CH 160 Turbo", 160);
}
}
};

/*
* populate_phymode_selector()
*	Adds PHY mode <option>'s to the given <select> in some particular order: list 802.11b only
* 802.11g only and 802.11n only first, then mixed modes.
*/
this.populate_phy_selector = function(select, band) {
band = band || this.band;

if (this.scan_type_dual && (band == DEFAULT_BAND)) {
add(select, "Mixed 802.11a and 802.11g", 6);
add(select, "Mixed 802.11a, 802.11g and 802.11b", 7);
add(select, "Mixed 802.11a, 802.11g and 802.11ng", 14);
add(select, "Mixed 802.11a, 802.11g, 802.11ng and 802.11b", 15);
add(select, "Mixed 802.11na, 802.11a and 802.11g", 22);
add(select, "Mixed 802.11na, 802.11a, 802.11g and 802.11b", 23);
add(select, "Mixed 802.11na, 802.11a, 802.11ng and 802.11g", 30);
add(select, "Mixed 802.11na, 802.11a, 802.11ng, 802.11g and 802.11b", 31);
return;
}

if (band == G_BAND_ONLY) {
if (this.type_B) {
add(select, "802.11b only", 1);
}

if (this.type_G) {
add(select, "802.11g only", 2);
}

if (this.type_NG) {
add(select, "802.11n only", 8);
}

if (this.type_G) {
add(select, "Mixed 802.11g and 802.11b", 3);
}

if (this.type_NG) {
//
add(select, "Mixed 802.11n and 802.11g", 10);
//
add(select, "Mixed 802.11n, 802.11g and 802.11b", 11);
}
}
if (band == A_BAND_ONLY) {
if (this.type_A) {
add(select, "802.11a only", 4);
}
if (this.type_NA) {
add(select, "802.11n only", 16);
add(select, "Mixed 802.11n and 802.11a", 20);
}
}
};

/*
* populate_super_mode_selector()
*	Adds super mode <option>'s to the given <select>.
*/
this.populate_super_mode_selector = function(select) {
add(select, sw("txtDisabled"), 0);
add(select, "Super G without Turbo", 1);
//
add(select, "Super G with Dynamic Turbo", 3);
add(select, "Super G with Static Turbo", 2);
//
};

/*
* populate_txrate_selector()
*	Adds tx rate <option>'s to the given <select>.
*/
this.populate_txrate_selector = function(select) {
add(select, "Best (automatic)", 0);
if (this.type_NA || this.type_NG) {
add(select, "MCS 15 - 130 [270]", 27);
add(select, "MCS 14 - 117 [243]", 26);
add(select, "MCS 13 - 104 [216]", 25);
add(select, "MCS 12 - 78 [162]", 24);
add(select, "MCS 11 - 52 [108]", 23);
add(select, "MCS 10 - 39 [81]", 22);
add(select, "MCS 9 - 26 [54]", 21);
add(select, "MCS 8 - 13 [27]", 20);
add(select, "MCS 7 - 65 [135]", 19);
add(select, "MCS 6 - 58.5 [121.5]", 18);
add(select, "MCS 5 - 52 [108]", 17);
add(select, "MCS 4 - 39 [81]", 16);
add(select, "MCS 3 - 26 [54]", 15);
add(select, "MCS 2 - 19.5 [40.5]", 14);
add(select, "MCS 1 - 13 [27]", 13);
add(select, "MCS 0 - 6.5 [13.5]", 12);
}
if (this.type_A || this.type_G) {
if ((this.type_A && this.turbo_A) || (this.type_G && this.super_G)) {
add(select, "54 [108]", 11);
add(select, "48 [96]", 10);
add(select, "36 [72]", 9);
add(select, "24 [48]", 8);
add(select, "18 [36]", 7);
add(select, "12 [24]", 6);
add(select, "9 [18]", 5);
add(select, "6 [12]", 4);
} else {
add(select, "54", 11);
add(select, "48", 10);
add(select, "36", 9);
add(select, "24", 8);
add(select, "18", 7);
add(select, "12", 6);
add(select, "9", 5);
add(select, "6", 4);
}
}
if (this.type_B) {
add(select, "11", 3);
add(select, "5.5", 2);
add(select, "2", 1);
add(select, "1", 32768);
}
}

/*
* populate_cwm_selector()
*	Adds channel width <option>'s to the given <select>.
*/
this.populate_cwm_selector = function(select) {
if (this.type_NG || this.type_NA) {
add(select, "20 MHz", 0);
add(select, "Auto 20/40 MHz", 1);
if (this.ar5416_extra) {
add(select, "40 MHz", 2);
}
} else {
add(select, "Not applicable", -1);
}
};

/*
* populate_streams_selector()
*	Adds spacial stream <option>'s to the given <select>.
*/
this.populate_streams_selector = function(select) {
if (this.ar5416_extra && (this.type_NG || this.type_NA)) {
add(select, "1 Stream", 255);
add(select, "2 Streams", 32512);
add(select, "Auto up to MCS14", 28927);
add(select, "Auto up to MCS14 (2 streams preferred)", 32527);
add(select, "Auto up to MCS15 (exclude MCS8-MCS11)", 61695);
add(select, "Auto up to MCS15", 65535);
} else {
add(select, "Not applicable", -1);
}
};
};

/*
* Server answers after page submission.
*/

var verify_failed = "";

/*
* Handle for document.form["mainform"].
*/
var mf;

/*
* Selectors.
*/

function wireless_dot11d_enabled_selector(checked)
{
mf.wireless_dot11d_enabled.value = checked;
mf.wireless_dot11d_enabled_select.checked = checked;

     document.getElementById("box_wireless_country_code").style.display = checked ? "block" : "none";
}

function wireless_country_code_selector()
{
  var sel = document.getElementById("select_country_code");
  document.getElementById("country_code_index").value = sel.selectedIndex;
  document.getElementById("country_code").value = sel.value;
}

function wireless_l2_isolation_enabled_selector(checked)
{
mf.wireless_l2_isolation_enabled.value = checked;
mf.wireless_l2_isolation_enabled_select.checked = checked;
}
/*
function wireless_qos_enabled_selector(checked)
{
mf.wireless_qos_enabled.value = checked;
mf.wireless_qos_enabled_select.checked = checked;
}
*/
function wireless_force_11n_sslot_selector(checked)
{
mf.wireless_force_11n_sslot.value = checked;
mf.wireless_force_11n_sslot_select.checked = checked;
}

function wireless_shortgi_selector(checked)
{
mf.wireless_shortgi.value = checked;
mf.wireless_shortgi_select.checked = checked;
}

function wireless_erp_protection_selector(checked)
{
mf.wireless_erp_protection.value = checked;
mf.wireless_erp_protection_select.checked = checked;
}

function wireless_aggr_limit_selector(value)
{
mf.wireless_aggr_limit.value = value;
mf.wireless_aggr_limit_select.value = value;
}
function wireless_wlan_chan_band_selector(value)
{
	mf.wlan_chan_band.value = value;
	mf.wireless_wlan_chan_band_select.value=value;
	if (value == 1) { // b+g
		wireless_wlan_chan_bandwidth_selector(0);
		mf.wireless_wlan_chan_bandwidth_select.disabled = true;
	}
	else
		mf.wireless_wlan_chan_bandwidth_select.disabled = false;	
}

function wireless_tx_power_selector(value)
{
mf.wireless_tx_power.value = value;
mf.wireless_tx_power_select.value = value;
}
function wireless_wlan_chan_bandwidth_selector(value)
{
mf.wlan_chan_bandwidth.value = value;
mf.wireless_wlan_chan_bandwidth_select.value=value;
        
if(value == 0) //0:20MHz
{
        /* 20MHz mode, coexist close */
        mf.wlan_coexist_mode_radio[0].disabled =true;
        mf.wlan_coexist_mode_radio[1].disabled =true;
}
else
{
        mf.wlan_coexist_mode_radio[0].disabled =false;
        mf.wlan_coexist_mode_radio[1].disabled =false;          
}
}

function wlan_preamble_radio_select(value)
{
mf.wlan_preamble_radio_saved.value=value;
if(value==1)
	mf.wlan_preamble_radio_0.checked=true;
if(value==0)
	mf.wlan_preamble_radio_1.checked=true;
}
function wlan_cts_mode_select(value)
{
	mf.wlan_cts_mode_radio_saved.value=value;
	if(value==0)
		mf.wlan_cts_mode_radio_0.checked=true;	
	else
		mf.wlan_cts_mode_radio_1.checked=true;
}


function wlan_stbc_mode_select(value)
{
        mf.wlan_stbc_mode_radio_saved.value=value;
        if(value==0)
                mf.wlan_stbc_mode_radio_0.checked=true; 
        else
                mf.wlan_stbc_mode_radio_1.checked=true;
}
function wlan_coexist_mode_select(value)
{
        mf.wlan_coexist_mode_radio_saved.value=value;
        if(value==0)
                mf.wlan_coexist_mode_radio_0.checked=true;      
        else
                mf.wlan_coexist_mode_radio_1.checked=true;
}


function page_load()
{
mf = document.forms.mainform;
displayOnloadPage("<%getInfo("ok_msg")%>");
/* When viewing the page locally. */

if ("" !== "") {
hide_all_ssi_tr();
return;
}

var radio = new Radio();
var wireless_wepon = "<%getIndexInfo("wep_enabled");%>";
var wireless_wpa_enabled = "<%getIndexInfo("wpa_enabled");%>";
var wireless_wpa_mode = "<%getIndexInfo("wpa_mode");%>";
var tkip_value = "<%getIndexInfo("wpaCipher");%>";
var wds_ap_encrypt = "<%getIndexInfo("WDS_AP_Encrypt");%>";
var wireless_mode = "<%getIndexInfo("wlanMode");%>";

/* 2007.12.04 remove 802.11d
wireless_dot11d_enabled_selector(mf.wireless_dot11d_enabled.value == "true");
      document.getElementById("select_country_code").selectedIndex = document.getElementById("country_code_index").value;
*/
//wireless_qos_enabled_selector(mf.wireless_qos_enabled.value == "true");
//wireless_l2_isolation_enabled_selector(mf.wireless_l2_isolation_enabled.value == "true");
mf.wlan_preamble_radio_saved.value=<%getIndexInfo("short_preamble")%>;
mf.wlan_cts_mode_radio_saved.value=<%getIndexInfo("gprotected")%>;
mf.wlan_stbc_mode_radio_saved.value=<%getIndexInfo("tx_stbc")%>;
mf.wlan_coexist_mode_radio_saved.value=<%getIndexInfo("coexist")%>;
var wlan_xTxR="<% getIndexInfo("wlan_xTxR"); %>";
wlan_cts_mode_select(mf.wlan_cts_mode_radio_saved.value);
wlan_stbc_mode_select(mf.wlan_stbc_mode_radio_saved.value);
if(wlan_xTxR == "1*1" || wlan_xTxR == "0*0")
{
        mf.wlan_stbc_mode_radio[0].checked= false;
        mf.wlan_stbc_mode_radio[1].checked= true;
        mf.wlan_stbc_mode_radio[0].disabled =true;
        mf.wlan_stbc_mode_radio[1].disabled =true;
}
wlan_coexist_mode_select(mf.wlan_coexist_mode_radio_saved.value);
wlan_preamble_radio_select(mf.wlan_preamble_radio_saved.value);
wireless_tx_power_selector(mf.wireless_tx_power.value);
wireless_wlan_chan_bandwidth_selector(mf.wlan_chan_bandwidth.value);
wireless_force_11n_sslot_selector(mf.wireless_force_11n_sslot.value == "true");
wireless_shortgi_selector(mf.wireless_shortgi.value == "true");
wireless_erp_protection_selector(mf.wireless_erp_protection.value == "true");

if(( wireless_mode!= 2 && wireless_wepon == "true") || (wireless_mode != 2 && wireless_wpa_enabled == "true" && (tkip_value == 1 || tkip_value == 3)) || (wireless_mode == 2 && wds_ap_encrypt == 1) || (wireless_mode == 2 && wds_ap_encrypt == 2) || (wireless_mode == 2 && wds_ap_encrypt == 3)){
	get_by_id("wireless_wlan_chan_band_select").length = 0;
	get_by_id("wireless_wlan_chan_band_select")[0] = new Option(sw("txtMixedGB"), "1", "false", "false");
	get_by_id("wireless_wlan_chan_band_select")[1] = new Option(sw("txtMixedNGB"), "2", "false", "false");
	get_by_id("wireless_wlan_chan_band_select").length = 2;
}else{
	get_by_id("wireless_wlan_chan_band_select").length = 0;
	get_by_id("wireless_wlan_chan_band_select")[0] = new Option(sw("txt11nOnly"), "0", "false", "false");
	get_by_id("wireless_wlan_chan_band_select")[1] = new Option(sw("txtMixedGB"), "1", "false", "false");
	get_by_id("wireless_wlan_chan_band_select")[2] = new Option(sw("txtMixedNGB"), "2", "false", "false");
	get_by_id("wireless_wlan_chan_band_select").length = 3;
}

wireless_wlan_chan_band_selector(mf.wlan_chan_band.value);

document.getElementById("box_wireless_aggr_limit").style.display = radio.ar5416_extra && (radio.type_NG || radio.type_NA) ? "block" : "none";
document.getElementById("box_wireless_tpc_max_gain").style.display = radio.ar5416_extra && (radio.type_NG || radio.type_NA) ? "block" : "none";
document.getElementById("box_wireless_aggr_byte_cnt").style.display = radio.ar5416_extra && (radio.type_NG || radio.type_NA) ? "block" : "none";
document.getElementById("box_wireless_aggr_pkt_cnt").style.display = radio.ar5416_extra && (radio.type_NG || radio.type_NA) ? "block" : "none";
document.getElementById("box_wireless_force_11n_sslot").style.display = radio.ar5416_extra && (radio.type_NG || radio.type_NA) ? "block" : "none";
document.getElementById("box_wireless_shortgi").style.display = radio.type_NG || radio.type_NA ? "block" : "none";
document.getElementById("box_wireless_erp_protection").style.display = (mf.wireless_phy_mode.value & 1) ? "none" : "block";

if (radio.ar5416_extra && (radio.type_NG || radio.type_NA)) {
wireless_aggr_limit_selector(mf.wireless_aggr_limit.value);
}

set_form_default_values("mainform");

/* Check for validation errors. */
if (verify_failed != "") {
set_form_always_modified("mainform");
alert(verify_failed);
return;
}
}

function page_verify()
{
/*
* Validate fields for type-correctness
*/
if (!is_number(mf.wireless_beacon_period.value) || (mf.wireless_beacon_period.value < 0) ||
(mf.wireless_beacon_period.value < 20) || (mf.wireless_beacon_period.value > 1000)) {
alert(sw("txInvalidBeaconPeriodt"));
try	{
mf.wireless_beacon_period.select();
mf.wireless_beacon_period.focus();
} catch (e) {
}
return false;
}
if (!is_number(mf.wireless_rts_threshold.value) || (mf.wireless_rts_threshold.value < 0) ||
(mf.wireless_rts_threshold.value < 256) || (mf.wireless_rts_threshold.value > 2346)	) {
alert(sw("txtInvalidRTSThreshold"));
try	{
mf.wireless_rts_threshold.select();
mf.wireless_rts_threshold.focus();
} catch (e) {
}
return false;
}
if (!is_number(mf.wireless_frag_threshold.value) || (mf.wireless_frag_threshold.value < 0) ||
(mf.wireless_frag_threshold.value < 1500) || (mf.wireless_frag_threshold.value > 2346) || (!(mf.wireless_frag_threshold.value % 2) == 0)) {
alert(sw("txtInvalidFragmentationThreshold"));
try	{
mf.wireless_frag_threshold.select();
mf.wireless_frag_threshold.focus();
} catch (e) {
}
return false;
}

var dtim_interval = mf.wireless_dtim_interval.value;
if (!is_number(dtim_interval) || (dtim_interval < 1) || (dtim_interval > 255)) {
alert(sw("txtWarningDTIMRange"));
try	{
mf.wireless_dtim_interval.select();
mf.wireless_dtim_interval.focus();
} catch (e) {
}
return false;
}
if (!is_number(mf.wireless_tpc_max_gain.value)) {
alert(sw("txtInvalidTPCMaxGain"));
try	{
mf.wireless_tpc_max_gain.select();
mf.wireless_tpc_max_gain.focus();
} catch (e) {
}
return false;
}
if (!is_number(mf.wireless_aggr_byte_cnt.value)) {
alert(sw("txtInvalidAggregationMaxSize"));
try	{
mf.wireless_aggr_byte_cnt.select();
mf.wireless_aggr_byte_cnt.focus();
} catch (e) {
}
return false;
}
if (!is_number(mf.wireless_aggr_pkt_cnt.value)) {
alert(sw("txtInvalidAggregationNumPackets"));
try	{
mf.wireless_aggr_pkt_cnt.select();
mf.wireless_aggr_pkt_cnt.focus();
} catch (e) {
}
return false;
}

return true;		
}

/* Validate and submit the form. */
function page_submit()
{
if (!is_form_modified("mainform") && !confirm(sw("txtSaveAnyway"))) {
return false;
mf["settingsChanged"].value = 0;						
}
else
mf["settingsChanged"].value = 1;		

if (!page_verify()) {
return false;
}

mf.submit();
}

function init()
{		
var DOC_Title= sw("txtTitle")+" : "+sw("txtAdvanced")+'/'+sw("txtAdvancedWirelessSettings");
document.title = DOC_Title;			
get_by_id("RestartNow").value = sw("txtRebootNow");
get_by_id("RestartLater").value = sw("txtRebootLater");
get_by_id("SaveSettings").value = sw("txtSaveSettings");
get_by_id("DontSaveSettings").value = sw("txtDontSaveSettings");			
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
DrawRebootContent("bridge");
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
<form name="mainform" action="/goform/formAdvanceSetup" method="post" enctype="application/x-www-form-urlencoded" id="mainform">
<input type="hidden" id="settingsChanged" name="settingsChanged" value="0"/>
<input type="hidden" id="webpage" name="webpage" value="/Advanced/Advanced_Wireless.asp">
<input type="hidden" id="curTime" name="curTime" value="<% getInfo("currTimeSec");%>"/>
<div class="section">
<div class="section_head">
<h2><SCRIPT >ddw("txtAdvancedWirelessSettings");</SCRIPT></h2>
<p><SCRIPT >ddw("txtAdvWlanStr1");</SCRIPT></p>
<input class="button_submit" type="button" id="SaveSettings" name="SaveSettings" value="" onclick="page_submit()"/>
<input class="button_submit" type="button" id="DontSaveSettings" name="DontSaveSettings" value="" onclick="page_cancel()"/>
</div>
</div>
<div class="box">
<h3><SCRIPT >ddw("txtAdvancedWirelessSettings");</SCRIPT></h3>
<fieldset>
<p><label class="duple_wlan_adv">
<SCRIPT >ddw("txtTransmitPower");</SCRIPT>:</label>
<input type="hidden" id="wireless_tx_power" name="config.wireless.tx_power" value="<%getInfo("RFPower");%>"/>
<select id="wireless_tx_power_select" onchange="wireless_tx_power_selector(this.value);">
<option value="0">100%</option>
<option value="1">70%</option>
<option value="2">50%</option>
<option value="3">35%</option>
<option value="4">15%</option>
</select>
</p>
<p><label class="duple_wlan_adv">
<SCRIPT >ddw("txtBeaconPeriod");</SCRIPT>:</label>
<input type="text" size="10" id="wireless_beacon_period"  name="config.wireless.beacon_period" value="<%getInfo("beaconInterval");%>"/><SCRIPT >ddw("txtBeaconPeriodHint");</SCRIPT>
</p>
<p><label class="duple_wlan_adv">
<SCRIPT >ddw("txtRTSThreshold");</SCRIPT>:</label>
<input type="text" size="10" id="wireless_rts_threshold" name="config.wireless.RTS_threshold" value="<%getInfo("rtsThreshold");%>" /><SCRIPT >ddw("txtRTSThresholdHint");</SCRIPT>
</p>
<p><label class="duple_wlan_adv">
<SCRIPT >ddw("txtFragmentationThreshold");</SCRIPT>:</label>
<input type="text" size="10" id="wireless_frag_threshold" name="config.wireless.frag_threshold" value="<%getInfo("fragThreshold");%>"/><SCRIPT >ddw("txtFragmentationThresholdHint");</SCRIPT>
</p>
<p><label class="duple_wlan_adv">
<SCRIPT >ddw("txtDTIMInterval");</SCRIPT>:</label>
<input type="text" size="10" id="wireless_dtim_interval" name="config.wireless.dtim_interval" value="<%getInfo("dtimPeriod");%>"/><SCRIPT >ddw("txtDTIMIntervalHint");</SCRIPT>
</p>

<p> <label class="duple_wlan_adv"><SCRIPT >ddw("txtPreambleType");</SCRIPT>:</label>
<input id="wlan_preamble_radio_0" type="radio" name="wlan_preamble_radio" value="1" onclick="wlan_preamble_radio_select(this.value);"/>
<label><SCRIPT >ddw("txtShortPreamble");</SCRIPT></label>
<input id="wlan_preamble_radio_1" type="radio" name="wlan_preamble_radio" value="0" onclick="wlan_preamble_radio_select(this.value);"/>
<label><SCRIPT >ddw("txtLongPreamble");</SCRIPT> </label></p>	
<p> 
	
<p> <label class="duple_wlan_adv"><SCRIPT >ddw("txtCTSMode");</SCRIPT>:</label>
<input id="wlan_cts_mode_radio_1" type="radio" name="wlan_cts_mode_radio" value="1" onclick="wlan_cts_mode_select(this.value);"/>
<label><SCRIPT >ddw("txtCTSModeNone");</SCRIPT> </label>
<input id="wlan_cts_mode_radio_2" type="radio" name="wlan_cts_mode_radio" value="2" disabled=true onclick="wlan_cts_mode_select(this.value);"/>
<label><SCRIPT >ddw("txtAlways");</SCRIPT></label>
<input id="wlan_cts_mode_radio_0" type="radio" name="wlan_cts_mode_radio" value="0" onclick="wlan_cts_mode_select(this.value);"/>
<label><SCRIPT >ddw("txtAuto");</SCRIPT></label>

</p>		
<p><label class="duple_wlan_adv">
<SCRIPT >ddw("txtWirelessMode");</SCRIPT>:</label>
<input type="hidden" id="wlan_chan_band" name="config.wlan_chan_band" value="<%getIndexInfo("band");%>"/>
<select id="wireless_wlan_chan_band_select" onchange="wireless_wlan_chan_band_selector(this.value);">
<option value="0"><SCRIPT >ddw("txt11nOnly");</SCRIPT></option>
<option value="1"><SCRIPT >ddw("txtMixedGB");</SCRIPT></option>
<option value="2"><SCRIPT >ddw("txtMixedNGB");</SCRIPT></option>
</select>
</p>	
	
<p><label class="duple_wlan_adv">
<SCRIPT >ddw("txtWlanBandWidth");</SCRIPT>:</label>
<input type="hidden" id="wlan_chan_bandwidth" name="config.wlan_chan_bandwidth" value="<%getIndexInfo("chanBound");%>"/>
<select id="wireless_wlan_chan_bandwidth_select" onchange="wireless_wlan_chan_bandwidth_selector(this.value);">
<option value="0">20MHz</option>
<option value="1">20/40MHz(<SCRIPT >ddw("txtAuto");</SCRIPT>)</option>
</select>
</p>
<input type="hidden" id="wlan_preamble_radio_saved">
<input type="hidden" id="wlan_cts_mode_radio_saved">
<input type="hidden" id="wlan_stbc_mode_radio_saved">
<input type="hidden" id="wlan_coexist_mode_radio_saved">
<p> <label class="duple_wlan_adv"><SCRIPT >ddw("txtWlanSTBC");</SCRIPT>:</label>
<input id="wlan_stbc_mode_radio_1" type="radio" name="wlan_stbc_mode_radio" value="1" onclick="wlan_stbc_mode_select(this.value);"/>
<label for="wlan_stbc_mode_radio_1"><SCRIPT >ddw("txtEnable");</SCRIPT> </label>
<input id="wlan_stbc_mode_radio_0" type="radio" name="wlan_stbc_mode_radio" value="0" onclick="wlan_stbc_mode_select(this.value);"/>
<label for="wlan_stbc_mode_radio_0"><SCRIPT >ddw("txtDisabled");</SCRIPT></label>

<p> <label class="duple_wlan_adv"><SCRIPT >ddw("txtWlan11nCoexist");</SCRIPT>:</label>
<input id="wlan_coexist_mode_radio_1" type="radio" name="wlan_coexist_mode_radio" value="1" onclick="wlan_coexist_mode_select(this.value);"/>
<label for="wlan_coexist_mode_radio_1"><SCRIPT >ddw("txtEnable");</SCRIPT> </label>
<input id="wlan_coexist_mode_radio_0" type="radio" name="wlan_coexist_mode_radio" value="0" onclick="wlan_coexist_mode_select(this.value);"/>
<label for="wlan_coexist_mode_radio_0"><SCRIPT >ddw("txtDisabled");</SCRIPT></label>


<!--
<p><input type="hidden" id="wireless_l2_isolation_enabled" name="config.wireless.l2_isolation_enabled" value="<%getIndexInfo("block_relay");%>"/>
<label class="duple">
<SCRIPT >ddw("txtWLANPartition");</SCRIPT>:</label>
<input type="checkbox" id="wireless_l2_isolation_enabled_select" onclick="wireless_l2_isolation_enabled_selector(this.checked);"/>
</p>
-->

<p id="box_wireless_aggr_limit">
<input type="hidden" id="wireless_aggr_limit" name="config.wireless.aggr_limit" value="3"/>
<label class="duple_wlan_adv">
<SCRIPT >ddw("txtAggregationLimit");</SCRIPT>:</label>
<select id="wireless_aggr_limit_select" onchange="wireless_aggr_limit_selector(this.value);">
<option value="0">8 Kbytes</option>
<option value="1">16 Kbytes</option>
<option value="2">32 Kbytes</option>
<option value="3">64 Kbytes</option>
</select>
</p>
<p id="box_wireless_tpc_max_gain"><label class="duple">
<SCRIPT >ddw("txtTPCMaxGain");</SCRIPT>:</label>
<input type="text" size="4" id="wireless_tpc_max_gain" name="config.wireless.tpc_max_gain" value="20"/>(0..50)
</p>
<p id="box_wireless_aggr_byte_cnt">
<label class="duple_wlan_adv">
<SCRIPT >ddw("txtAggregationMaxSize");</SCRIPT>:</label>
<input type="text" size="10" id="wireless_aggr_byte_cnt" name="config.wireless.aggr_byte_cnt" value="64000"/>(2000..65535)
</p>
<p id="box_wireless_aggr_pkt_cnt">
<label class="duple_wlan_adv">
<SCRIPT >ddw("txtAggregationNumPackets");</SCRIPT>:</label>
<input type="text" size="10" id="wireless_aggr_pkt_cnt" name="config.wireless.aggr_pkt_cnt" value="32"/>(1..64)
</p>
<p id="box_wireless_force_11n_sslot">
<input type="hidden" id="wireless_force_11n_sslot" name="config.wireless.force_11n_sslot" value="true"/>
<label class="duple_wlan_adv">
<SCRIPT >ddw("txtForceShortSlotfor11NClients");</SCRIPT>:</label>
<input type="checkbox" id="wireless_force_11n_sslot_select" onclick="wireless_force_11n_sslot_selector(this.checked);"/>
</p>
<p id="box_wireless_shortgi">
<input type="hidden" id="wireless_shortgi" name="config.wireless.shortgi" value="<%getIndexInfo("short_gi");%>"/>
<label class="duple_wlan_adv"><SCRIPT >ddw("txtShortGuardInterval");</SCRIPT> :</label>
<input type="checkbox" id="wireless_shortgi_select" onclick="wireless_shortgi_selector(this.checked);"/>
</p>
<p id="box_wireless_erp_protection">
<input type="hidden" id="wireless_phy_mode" value="11"/>
<input type="hidden" id="wireless_erp_protection" name="config.wireless.erp_protection" value="true"/>
<label class="duple_wlan_adv">
<SCRIPT >ddw("txtExtraWirelessProtection");</SCRIPT>:</label>
<input type="checkbox" id="wireless_erp_protection_select" onclick="wireless_erp_protection_selector(this.checked);"/>
</p></fieldset></div></form></div></td>
<td id="sidehelp_container">
<div id="help_text">
<strong><SCRIPT >ddw("txtHelpfulHints");</SCRIPT>...</strong>
<p><SCRIPT >ddw("txtAdvWlanStr2");</SCRIPT></p>
<!--
<p><SCRIPT >ddw("txtAdvWlanStr3");</SCRIPT></p>
-->
<p class="more">
<!-- Link to more help -->
<a href="../Help/Advanced.asp#Advanced_Wireless" onclick="return jump_if();">
<SCRIPT >ddw("txtMore");</SCRIPT>...</a>
</p></div></td></tr></table>
<table id="footer_container" border="0" cellspacing="0" summary="">
<tr><td>
<img src="../Images/img_wireless_bottom.gif" width="114" height="35" alt="" />
</td><td>&nbsp;
</td></tr></table></td></tr></table>
<SCRIPT language=javascript>print_copyright();</SCRIPT>
</div></body></html>
