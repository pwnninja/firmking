function openSupport(){

 window.open('http://support.dlink.com', '', '');
}
var TabHeader="";
var SideItem="";
var HelpItem="";
var ModemVer="<% getCfgGeneral(1, "ModeName"); %>";
var HardwareVer="<% getCfgGeneral(1, "HardwareVer"); %>";
var FirmwareVer="<% getCfgGeneral(1, "FirmwareVer"); %>";
var copyrightInfo="2008-2017 D-Link公司，版权所有。";
var CSetup = 1;

var CWireless = 2;
var CWireless5g = 3;
var CAdvanced = 4;
var CMaintain = 5;
var CStatus = 6;
var CHelp = 7;
var CEnd = 7;
var delaytimer=300;
  var user = 'admin';
  var proto = 'PPPoE';
  var ipExt = '0';
  var dhcpen = '1';
  var std = 'annex_a';
var wireless = '1';  var voice = '';
  var buildSnmp = '1';
  var buildDdnsd = '1';
  var buildSntp = '1';
  var buildPureBridge = '0';
var buildPortmap = '0';var showTrafficShaping = '1';var WAN3g = '0';var ShowTR069 = '0';  var buildipp = '0';
  var buildSes = '';
  var siproxd = '0';
  var tod = '1';
  var QosEnabled = 'false';
  var buildRip = '1';
  var buildUsbHost = '0';
  var buildUsbFtp = '0';
  var buildUsbSmb = '0';
  var ipsec = '0';
  var certificate = '1';
  var wirelessqos = '1';
  var tr69c = '1';
  var buildPptpClient = '&nbsp';
  var buildDOS = '1';
  var buildPT = '1';
  var buildQoS='1';
  var urlFilter = '1';
  var iptSchedule = '1';
  var buildUpnp = '1';
  var QuickSetup=0;
  var VirtualServers=0;
  var PortTriggering=0;
  var DMZHost=0;
  var ALG=0;
  var Outgoing=0;
  var Incoming=0;
  var Filter=0;
  var AttackPrevent=0;
  var MACFiltering=0;
  var ParentalControl=0;
  var QualityofService=0;
  var DefaultGateway=0;
  var StaticRoute=0;
  var RIP=0;
  var Routing=0;
  var DNSServer=0;
  var DynamicDNS=0;
  var Annex="";
  var PortMapping=0;
  var PPTPClient=0;
  var IPSec=0;
  var wlBasic=0;
  var wlSecurity=0;
  var wlMACFilter=0;
  var wlBridge=0;
  var wlAdvanced=0;
  var wlQos=0;
  var wlSES=0;
  var wlStationInfo=0;
  var WirelessAdv=0;
  var MassStorage=0;
var PrintServer = '0';  var Settings=0;
  var SNMP=0;
  var TR069Client=0;
  var cert = 0;
  var InternetTime=0;
  var AccessControl=0;
  var Security="";
  var UpdateSoftware=0;
  var schedule = 0;
  var statswanweb="statsifcwan.html";
if ( user != 'support' && user != 'user') {
  if ( buildPureBridge == 0) {
      VirtualServers=1;
    if(buildPT == '1')
      PortTriggering=1;
      DMZHost=1;
        if ( siproxd == '1' )
           ALG =1;
      Outgoing=1;
      Incoming=1;
 MACFiltering=1;
      Filter=1;
        if (buildDOS == '1')
          AttackPrevent=1;
         if (( tod == '1' ) || (urlFilter == '1'))
            ParentalControl=1;
         if (iptSchedule=='1')
          schedule = 1;
  }
}
if ( buildPureBridge == 0) {
  QuickSetup=1;
  if ( user != 'user') {
      if (buildQoS == '1')
        QualityofService=1;
        DefaultGateway=1;
        StaticRoute=1;
        Routing=1;
      if ( buildRip == '1')
        RIP=1;
      DNSServer=1;
      if ( buildDdnsd == '1')
        DynamicDNS=1;
  }
}
if ( std == 'annex_c' )
  Annex="adslcfgc.html";
else
  Annex="adslcfg.html";
if ( buildPortmap == '1' ) {
  PortMapping=1;
}
if ( buildPptpClient == '1' ) {
  PPTPClient=1;
}
if ( ipsec == '1' ) {
  IPSec=1;
}
if ( user != 'user'){
  statswanweb="statsifcwanber.html";
 if (certificate == '1') {
  cert = 1;
 }
 if ( tr69c == '1' )
    TR069Client=1;
}
if ( wireless == '1' ) {
  wlBasic=1;
  wlSecurity=1;
  wlMACFilter=1;
  wlBridge=1;
  wlAdvanced=1;
  WirelessAdv=1;
  if (buildQoS == '1'){
  if ( wirelessqos == '1' ) {
     wlQos=1;
  }
  }
  if ( buildSes == '1' ) {
     wlSES=1;
  }
  wlStationInfo=1;
}
if ( buildUsbHost == '1' ) {
  if ( buildUsbFtp == '1' || buildUsbSmb == '1' ) {
    MassStorage=1;
  }
  if ( buildipp == '1' ) {
    PrintServer=1;
  }
}
if ( user != 'user') {
  Settings=1;
  if ( buildSnmp == '1' )
   SNMP=1;
  if ( (buildPureBridge == '0') && (buildSntp == '1') )
    InternetTime=1;
  AccessControl=1;
}
var SetupMenu=new Array();
var WirelessMenu=new Array();
var Wireless5GMenu=new Array();
var AdvMenu=new Array();
var MaintainMenu = new Array();
var StatMenu=new Array();
var HelpMenu=new Array();
var SiteMenu=new Array();
var TabMenu = new Array();
var tabPos = GetTABpos();
var index = 0;
SetupMenu[index++]=new Gitem(CSetup, "Internet设置向导", "d_wizard_step1_start.asp", 1, "d_setuphelp.asp", -1);
SetupMenu[index++]=new Gitem(CSetup, "局域网设置", "d_lan.asp", 1, "d_setuphelp.asp", -1);
if(!(("<% getCfgZero(1,"ApCliEnable");%>"==1)||("<% getCfg2Zero(1,"ApCliEnable");%>"==1))){
	SetupMenu[index++]=new Gitem(CSetup, "Internet设置", "d_wan.asp", 1, "d_setuphelp.asp", -1);
}
index = 0;
WirelessMenu[index++]=new Gitem(CWireless, "无线基本设置", "d_wlan_basic.asp", 1, "d_wlanhelp.asp", -1);
WirelessMenu[index++]=new Gitem(CWireless, "WPS设置", "d_wlwps_step1.asp", 1, "d_wlanhelp.asp", -1);
WirelessMenu[index++]=new Gitem(CWireless, "无线高级设置", "d_wladvanced.asp", 1, "d_wlanhelp.asp", -1);
WirelessMenu[index++]=new Gitem(CWireless, "无线中继", "d_wlrepeater.asp", 1, "d_wlanhelp.asp", -1);
index = 0;
Wireless5GMenu[index++]=new Gitem(CWireless5g, "无线基本设置", "d_wl5basic.asp", 1, "d_wlanhelp.asp", -1);
Wireless5GMenu[index++]=new Gitem(CWireless5g, "WPS设置", "d_wl5wps_step1.asp", 1, "d_wlanhelp.asp", -1);
Wireless5GMenu[index++]=new Gitem(CWireless5g, "无线高级设置", "d_wl5advanced.asp", 1, "d_wlanhelp.asp", -1);
Wireless5GMenu[index++]=new Gitem(CWireless5g, "无线中继", "d_wl5repeater.asp", 1, "d_wlanhelp.asp", -1);
index = 0;
AdvMenu[index++]=new Gitem(CAdvanced, "访问控制", "d_acl.asp", 1, "d_advhelp.asp", -1);
AdvMenu[index++]=new Gitem(CAdvanced, "端口触发", "d_nat_portrigger.asp", 1, "d_advhelp.asp", -1);
AdvMenu[index++]=new Gitem(CAdvanced, "DMZ", "d_fw-dmz.asp", 1, "d_advhelp.asp", -1);
AdvMenu[index++]=new Gitem(CAdvanced, "站点限制", "d_url_nokeyword.asp", 1, "d_advhelp.asp", -1);
AdvMenu[index++]=new Gitem(CAdvanced, "动态DNS", "d_ddns.asp", 1, "d_advhelp.asp", -1);
AdvMenu[index++]=new Gitem(CAdvanced, "网络尖兵", "d_netsniper.asp", 1, "d_advhelp.asp", -1);
if(PortMapping) {
 AdvMenu[index++]=new Gitem(CAdvanced, "端口绑定", "d_portmap.asp", 1, "d_advhelp.asp", -1);
}
if(showTrafficShaping){
 AdvMenu[index++]=new Gitem(CAdvanced, "QoS设置", "d_ipqostc_gen_ap.asp", 1, "d_advhelp.asp", -1);
}
AdvMenu[index++]=new Gitem(CAdvanced, "UPnP", "d_upnp.asp", 1, "d_advhelp.asp", -1);
//AdvMenu[index++]=new Gitem(CAdvanced, "Telnet", "d_telnet.asp", 1, "d_advhelp.asp", -1);
if(ShowTR069=='1') {
 AdvMenu[index++]=new Gitem(CAdvanced, "TR-069", "d_tr069.asp", 1, "d_advhelp.asp", -1);
}
AdvMenu[index++]=new Gitem(CAdvanced, "虚拟服务器", "d_virtualSrv.asp", 1, "d_advhelp.asp", -1);
AdvMenu[index++]=new Gitem(CAdvanced, "USB 打印机", "d_cups.asp", PrintServer, "d_advhelp.asp", -1);
AdvMenu[index++]=new Gitem(CAdvanced, "ALG", "d_alg.asp", 1, "d_advhelp.asp", -1);
index = 0;
MaintainMenu[index++]=new Gitem(CMaintain, "重启/恢复", "d_reboot.asp", 1, "d_mainhelp.asp", -1);
MaintainMenu[index++]=new Gitem(CMaintain, "固件升级", "d_upload.asp", 1, "d_mainhelp.asp", -1);
MaintainMenu[index++]=new Gitem(CMaintain, "备份设置", "d_saveconf.asp", 1, "d_mainhelp.asp",-1);
MaintainMenu[index++]=new Gitem(CMaintain, "用户帐户配置", "d_userconfig.asp", 1, "d_mainhelp.asp",-1);
MaintainMenu[index++]=new Gitem(CMaintain, "时间与日期", "d_time.asp", InternetTime, "d_mainhelp.asp", -1);
index = 0;
StatMenu[index++]=new Gitem(CStatus, "设备信息", "d_status.asp", 1, "d_statushelp.asp", -1);
StatMenu[index++]=new Gitem(CStatus, "客户端列表", "d_dhcptbl.asp", 1, "d_statushelp.asp", -1);
StatMenu[index++]=new Gitem(CStatus, "统计信息", "d_stats.asp", 1, "d_statushelp.asp", -1);
index = 0;
HelpMenu[index++]=new Gitem(CHelp, "菜单", "d_helpmenu.asp", 1, "", -1);
HelpMenu[index++]=new Gitem(CHelp, "设置", "d_helpsetup.asp", 1, "", -1);
HelpMenu[index++]=new Gitem(CHelp, "无线(2.4G/5.8G)", "d_helpwlan.asp", 1, "", -1);
HelpMenu[index++]=new Gitem(CHelp, "高级", "d_helpadv.asp", 1, "", -1);
HelpMenu[index++]=new Gitem(CHelp, "维护", "d_helpmain.asp", 1, "", -1);
HelpMenu[index++]=new Gitem(CHelp, "状态", "d_helpstatusinfo.asp", 1, "", -1);
SiteMenu[0]=new Gitem(CHelp, "", "", 0, "", -1);
var setup=getDefaultPage(0);
var wlan=getDefaultPage(1);
var wlan5g=getDefaultPage(2);
var adv=getDefaultPage(3);
var maintenace=getDefaultPage(4);
var status=getDefaultPage(5);
var help=getDefaultPage(6);
index = 0;
TabMenu[index++] =new Gtab("设置", setup);
TabMenu[index++] =new Gtab("无线2.4G", wlan);
TabMenu[index++] =new Gtab("无线5G", wlan5g);
TabMenu[index++] =new Gtab("高级", adv);
TabMenu[index++] =new Gtab("维护", maintenace);
TabMenu[index++] =new Gtab("状态", status);
TabMenu[index++] =new Gtab("帮助", help);
function getDefaultPage(ID)
{
 var sideMenu = SetupMenu;

 if (ID == 1)
 {
  sideMenu = WirelessMenu;
 }else if (ID == 2)
 {
  sideMenu = Wireless5GMenu;
 }else if (ID == 3)
 {
  sideMenu = AdvMenu;
 }
 else if (ID == 4)
 {
  sideMenu = MaintainMenu;
 }
 else if (ID == 5)
 {
  sideMenu = StatMenu;
 }
 else if (ID == 6)
 {
  sideMenu = HelpMenu;
 }
 for(i=0;i < sideMenu.length;i++)
    {
  if (sideMenu[i].ishow == 1)
         return sideMenu[i].surl;
    }
}
function Gitem(ifolder,sname,surl,ishow,shelp, idmenu)
{
    this.ifolder=ifolder;
    this.sname=sname;
    this.surl=surl;
    this.ishow=ishow;
    this.shelp=shelp;
 this.idmenu = idmenu;
}
function Gtab(sname,surl)
{
    this.sname=sname;
    this.surl=surl;
}
function doLink(surl)
{
    shref =""+surl;
    document.location.href = shref;
}
function GetTABpos()
{
 var tabOn = -1;
 for(i=0; i < TabMenu.length; i++)
 {
  if (TabHeader == TabMenu[i].sname)
   tabOn = i;
 }
 return tabOn;
}
function GetSidepos(menu)
{
 var tabOn = -1;
 for(i=0; i < menu.length; i++)
 {
  if (SideItem == menu[i].sname)
   tabOn = i;
 }
 return tabOn;
}
function Write_Folder_Images()
{
	if(ie5){
		var top1 = '<td width=138 class=';//140
		var top1_5g = '<td width=168 class=';//154
	}else{
    var top1 = '<td width=139 class=';//140
	var top1_5g = '<td width=154 class=';//154
	}
 var top2 = '><a href="';
 var top3 = '">';
 var top4 = '</a></td>';
 var end = '<td style="background-color:white; width:2px;"></td>';
 var result = "";
 tabPos = GetTABpos();
 for(i=0; i < TabMenu.length; i++)
 {
  if (tabPos == i){
   if( TabMenu[i].surl == "d_helpmenu.asp"){
	   	result = result + top1_5g + 'topnavon rowspan=2' + top2 + TabMenu[i].surl + top3 + TabMenu[i].sname + top4 + end;
	}else{
   		result = result + top1 + 'topnavon rowspan=2' + top2 + TabMenu[i].surl + top3 + TabMenu[i].sname + top4 + end;
	}
  }else
   if( TabMenu[i].surl == "d_helpmenu.asp"){
   result = result + top1_5g + 'topnavoff' + top2 + TabMenu[i].surl + top3 + TabMenu[i].sname + top4 + end;
   }else{
   result = result + top1 + 'topnavoff' + top2 + TabMenu[i].surl + top3 + TabMenu[i].sname + top4 + end;
	}
 }
 document.write(result);
 if (tabPos == -1){
  document.write('</tr><tr><td></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>');
 } else {
  document.write('</tr><tr><td></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td><td style="background-color:#404343;"></td>' +
   '<td style="background-color:#404343;"></td>');
 }
}
function Write_Item_Images()
{
 var sideMenu = SetupMenu;;
 var top = '<td id=sidenav_container><div id=sidenav><ul>';
 var bottom = '</li></ul></div></td>';
 var side1 = '<li><div onMouseover="showmenu(event,linkset[';
 var side1_2 = '<li><div ';
 var side2_1 = '><a href="';
 var side2_2 = '], this)" onMouseout="delayhidemenu()" ';
 var side2_3 = '><a href="';
 var side3 = '">';
 var side4 = '</a></div>';
 var result = "";
 if (tabPos == 0)
 {
  sideMenu = SetupMenu;
 }else if (tabPos == 1)
 {
  sideMenu = WirelessMenu;
 }else if (tabPos == 2)
 {
  sideMenu = Wireless5GMenu;
 }else if (tabPos == 3)
 {
  sideMenu = AdvMenu;
 }
 else if (tabPos == 4)
 {
  sideMenu = MaintainMenu;
 }
 else if (tabPos == 5)
 {
  sideMenu = StatMenu;
 }
 else if (tabPos == 6)
 {
  sideMenu = HelpMenu;
 }
 
 if (tabPos == -1)
 {
  sideMenu = SiteMenu;
 }
 var g_FID= GetSidepos(sideMenu);
 for(i=0;i < sideMenu.length;i++)
    {
  if ((g_FID == i)&&(sideMenu[i].ishow == 1)){
   if (sideMenu[i].idmenu > -1)
    result = result + side1 + sideMenu[i].idmenu + side2_2 + ' class=sidenavoff id=dmenu' + sideMenu[i].idmenu + side2_3 + sideMenu[i].surl + side3 + sideMenu[i].sname + side4;
   else
    result = result + side1_2 + ' class=sidenavoff' + side2_1 + sideMenu[i].surl + side3 + sideMenu[i].sname + side4;
  }else if (sideMenu[i].ishow == 1){
   if (sideMenu[i].idmenu > -1)
    result = result + side1 + sideMenu[i].idmenu + side2_2 + ' id=dmenu' + sideMenu[i].idmenu + side2_3 + sideMenu[i].surl + side3 + sideMenu[i].sname + side4;
   else
    result = result + side1_2 + side2_1 + sideMenu[i].surl + side3 + sideMenu[i].sname + side4;
  }
    }
    document.write(top);
 document.write(result);
 document.write(bottom);
}
function mainTableStart()
{
 var tabPos;
  document.write('<style>');
 document.write('div.overflow');
 document.write('{');
 document.write('	overflow: auto;');
 if (HelpItem != ""){
   document.write('	width: 670px;');
 } else {
   document.write('	width: 795px;');
 }
 document.write('}');
  document.write('</style>');
 tabPos = GetTABpos();
 if (tabPos == 6)
  document.write('<div align="center" style="display: hidden" id="tblmain">');
 else
  document.write('<div align="center" style="display: none" id="tblmain">');
 document.write('<table border="0" cellpadding="0" cellspacing="0" width="980"><tr><td>');
 document.write('<table id="header_container" border="0" cellpadding="0" cellspacing="0"><tr class="top_product">');
 document.write('<td align="right" height="30" colspan="3" bgcolor="#404343">硬件版本:' + HardwareVer + '&nbsp;&nbsp;&nbsp;&nbsp;固件版本: ' + FirmwareVer + '&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>')
 document.write('<tr>');
 document.write('<td class="product_page" align="left">产品页面: ' + ModemVer+ '</td>')
 document.write('</tr>');
 document.write('<tr>');
 document.write('<td align="left"><a href="http://www.dlink.com.cn/" target="_blank"><img src="../images/head_01.gif" border="0"></a></td>');
 document.write('<td background="../images/head_02.gif" width="722"></td>');
 document.write('<td align="right"><img src="../images/head_03.gif"></td>');
 document.write('</tr></table>');
 document.write('<table cellSpacing=0 width=100%>');
 document.write('<tr><td height=3 style="background:white"></td></tr>');
 document.write('</table>');
}
function logo()
{
}
function TopNav()
{
 document.write('<table cellSpacing=0 width="100%" style="background-color:f1f1f1" Height=3px border=0><tr><td width="980"></td></tr></table>');
 document.write('<table id=topnav_container2 border=0 cellSpacing=0><tr><td style="background-color:white; width:1px;"></td><td id=modnum rowspan=2><img alt="" src="d_img_short_modnum.gif"></td>');
 document.write('<td style="background-color:white; width:2px;"></td>');
 Write_Folder_Images();
 document.write('</tr></table>');
 document.write('<table cellSpacing=0 width="100%" style="background-color:f1f1f1" Height:3px border=0><tr><td width="980"></td></tr></table>');
}
function ThirdRowStart()
{
 document.write('<table id=content_container cellSpacing=0 summary="" border=0 width="980"><tr>');
}
function mainBodyStart()
{
 document.write('<td id=maincontent_container><table><tr><td>');
  if (HelpItem != ""){
   document.write('<div id=maincontent style="width:703">');
 } else {
   document.write('<div id=maincontent style="width:830">');
 }
}
function mainBodyEnd()
{
 document.write('</div>');
 document.write('</td></tr></table></td>');
}
function ThirdRowEnd()
{
 var sideMenu;
 if (tabPos == 0)
 {
  sideMenu = SetupMenu;
 }else if (tabPos == 1)
 {
  sideMenu = WirelessMenu;
 }
 else if (tabPos == 2)
 {
  sideMenu = Wireless5GMenu;
 }
 else if (tabPos == 3)
 {
  sideMenu = AdvMenu;
 }
 else if (tabPos == 4)
 {
  sideMenu = MaintainMenu;
 }
 else if (tabPos == 5)
 {
  sideMenu = StatMenu;
 }
 else if (tabPos == 6)
 {
  sideMenu = HelpMenu;
 }
 else if (tabPos == -1)
 {
  sideMenu = SiteMenu;
 }
 var g_FID= GetSidepos(sideMenu);
  if (HelpItem != ""){
 document.write('<td id=sidehelp_container>');
 document.write('<div id=help_text>');
 document.write('<label id="helpLabel"></label>');
 document.write('<script language="Javascript" src="' + sideMenu[g_FID].shelp + '?rnd=' + Math.random() + '"></script>');
 document.write('</div>');
 document.write('</td>');
 }
 document.write('</tr></table>');
}
function Footer()
{
 document.write('<table id=footer_container cellSpacing=0 border=0>')
 document.write('<tr><td>'+copyrightInfo+'</td></tr>');
 document.write('</table>');
}
function mainTableEnd()
{
 document.write('</td></tr></table><div id=copyright></div></div>');
 setTimeout("document.getElementById('tblmain').style.display = 'block'", delaytimer);
}
function wizardHead()
{
 document.write('<DIV align="center"><TABLE cellSpacing=0 width="980"><TR><TD>' +
 '<TABLE id="header_container" width="980"><TR><TD align=left width="200">产品页面: ' + ModemVer+ '</TD><TD align=right width="50"></TD>' +
 '<TD align=right width="690">固件版本:1.07</TD></TR></TABLE>');
 document.write('<TABLE cellSpacing=0 width=100%><TR><td height=3 style={background:white}></td></TR></TABLE>' +
 '<TABLE cellSpacing=0 width="980"><TR><TD id=masthead_container width="980"><IMG alt="" src="img_masthead.gif" width=980></TD></TR></TABLE>' +
 '<TABLE cellSpacing=0 width="100%" style="background-color:f1f1f1" Height=3px border=0><TR><TD width="940"></TD></TR></TABLE>' +
 '<TABLE cellSpacing=0 width="100%" style="background-color:f1f1f1" Height=3px border=0><TR><TD width="940"></TD></TR></TABLE>' +
 '<TABLE id=content_container cellSpacing=0 summary="" border=0 width="940"><TR><TD width=78></TD><TD id=maincontent_container colspan=4><TABLE><TR><TD><DIV id=maincontent style="width:820">');
}
function wizardFooter()
{
 document.write('</DIV></TD></TR></TABLE></TD></TR></TABLE><TABLE id=footer_container cellSpacing=0 border=0>' +
 '<TR><TD></TD><TD>&nbsp;</TD></TR></TABLE></TD></TR></TABLE>' +
 '</DIV>');
}
var defaultMenuWidth="130px"
var baseTop = 147;
var top = 27;
var width = 127;
var linkset=new Array()
linkset[0]='<div id=sidenav><ul>';
linkset[0]+='<li><div><a href="d_lan.asp">局域网设置</a></div>';
linkset[0]+='<li><div><a href="d_dhcpd_nocheck_lanip.asp">DHCP服务器</a></div>';
linkset[0]+='<li><div><a href="d_dhcpip_nocheck_lanip.asp">DHCP地址保留</a></div>';
linkset[0]+='</li></ul></div>';
linkset[1]='<div id=sidenav><ul>';
linkset[1]+='<li><div><a href="d_wanadsl_auto_droute.asp">Channel Config</a></div>';
if(WAN3g== '1'){
 linkset[1]+='<li><div><a href="d_wan3gconf.asp">3G Config</a></div>';
}
linkset[1]+='<li><div><a href="d_wanatm.asp">ATM Settings</a></div>';
linkset[1]+='<li><div><a href="d_adslset.asp">ADSL Settings</a></div>';
linkset[1]+='<li><div><a href="d_autopvc.asp">PVC Auto Search</a></div>';
linkset[1]+='</li></ul></div>';
linkset[2]='<div id=sidenav><ul>';
linkset[2]+='<li><div><a href="d_wlbasic.asp">无线基本设置</a></div>';
linkset[2]+='<li><div><a href="d_wlwpa_mbssid.asp">无线安全配置</a></div>';
linkset[2]+='</li></ul></div>';
linkset[3]='<div id=sidenav><ul>';
linkset[3]+='<li><div><a href="d_wladvanced.asp">无线高级配置</a></div>';
linkset[3]+='<li><div><a href="d_wlactrl.asp">访问控制</a></div>';
linkset[3]+='<li><div><a href="d_wlwps.asp">WPS</a></div>';
linkset[3]+='<li><div><a href="d_wlguest.asp">MBSSID</a></div>';
linkset[3]+='<li><div><a href="d_wlwds.asp">WDS</a></div>';
linkset[3]+='<li><div><a href="d_wlwds_enc.asp">WDS加密</a></div>';
linkset[3]+='</li></ul></div>';
linkset[4]='<div id=sidenav><ul>';
linkset[4]+='<li><div><a href="d_fw-ipportfilter_adv.asp">IP端口过滤</a></div>';
linkset[4]+='</li></ul></div>';
linkset[5]='<div id=sidenav><ul>';
if(PortMapping) {
 linkset[5]+='<li><div><a href="d_portmap.asp">端口绑定</a></div>';
}
linkset[5]+='<li><div><a href="d_igmproxy.asp">IGMP 代理</a></div>';
if(showTrafficShaping){
 linkset[5]+='<li><div><a href="d_ipqostc_gen_ap.asp">IP QoS</a></div>';
}
linkset[5]+='<li><div><a href="d_upnp.asp">UPnP</a></div>';
if(ShowTR069=='1') {
 linkset[5]+='<li><div><a href="d_tr069.asp">TR-069</a></div>';
}
linkset[5]+='</li></ul></div>';
linkset[6]='<div id=sidenav><ul>';
linkset[6]+='<li><div><a href="d_routing.asp">静态路由</a></div>';
linkset[6]+='</li></ul></div>';
linkset[7]='<div id=sidenav><ul>';
linkset[7]+='<li><div><a href="d_virtualSrv.asp">虚拟服务器</a></div>';
linkset[7]+='</li></ul></div>';
linkset[8]='<div id=sidenav><ul>';
linkset[8]+='<li><div><a href="d_ping.asp">Ping</a></div>';
linkset[8]+='<li><div><a href="d_traceroute.asp">Traceroute</a></div>';
linkset[8]+='<li><div><a href="d_diag-test.asp">诊断测试</a></div>';
linkset[8]+='</li></ul></div>';
linkset[9]='<div id=sidenav><ul>';
linkset[9]+='<li><div><a href="d_acl.asp">访问控制</a></div>';
linkset[9]+='</li></ul></div>';
linkset[10]='<div id=sidenav><ul>';
linkset[10]+='<li><div><a href="d_dns.asp">DNS</a></div>';
linkset[10]+='</li></ul></div>';
var ie5=document.all && !window.opera
var ns6=document.getElementById
if (ie5||ns6){
 document.write('<IFRAME id="iframetemp" style="position:absolute; display:none; z-index:0; width:0; height:0" frameborder=0 scrolling=no marginwidth=0 src="" marginheight=0></iframe>');
 document.write('<div id="popitmenu" onMouseover="clearhidemenu();" onMouseout="dynamichide(event)">menu</div>')
}
var frameTemp = ie5? document.all.iframetemp : document.getElementById("iframetemp");
function iecompattest(){
return (document.compatMode && document.compatMode.indexOf("CSS")!=-1)? document.documentElement : document.body
}
function showmenu(e, which, count){
 if (!document.all&&!document.getElementById)
  return;
 clearhidemenu();
 menuobj=ie5? document.all.popitmenu : document.getElementById("popitmenu");
 menuobj.innerHTML=which;
 menuobj.style.width=defaultMenuWidth;
 menuobj.contentwidth=menuobj.offsetWidth;
 menuobj.contentheight=menuobj.offsetHeight;
eventX=ie5? event.clientX : e.clientX;
eventY=ie5? event.clientY : e.clientY;
var rightedge=ie5? iecompattest().clientWidth-eventX : window.innerWidth-eventX;
var bottomedge=ie5? iecompattest().clientHeight-eventY : window.innerHeight-eventY;
var tempEl = count;
var baseLeft = 0;
var tempTop =0;
while (tempEl != null){
 baseLeft += tempEl.offsetLeft;
 tempTop += tempEl.offsetTop;
 tempEl = tempEl.offsetParent;
}
if (rightedge<menuobj.contentwidth)
menuobj.style.left=baseLeft+width;
else
menuobj.style.left=baseLeft+width;
if (bottomedge<menuobj.contentheight)
menuobj.style.top= tempTop;
else
menuobj.style.top=tempTop;
frameTemp.style.display="block";
frameTemp.style.left=menuobj.style.left;
frameTemp.style.top=menuobj.style.top;
frameTemp.style.width=menuobj.contentwidth;
frameTemp.style.height=menuobj.contentheight;
menuobj.style.visibility="visible";
return false;
}
function contains_ns6(a, b) {
while (b.parentNode)
if ((b = b.parentNode) == a)
return true;
return false;
}
function hidemenu(){
if (window.menuobj)
menuobj.style.visibility="hidden";
frameTemp.style.display="none";
}
function dynamichide(e){
if (ie5&&!menuobj.contains(e.toElement))
hidemenu()
else if (ns6&&e.currentTarget!= e.relatedTarget&& !contains_ns6(e.currentTarget, e.relatedTarget))
hidemenu()
}
function delayhidemenu(){
delayhide=setTimeout("hidemenu()",300)
}
function clearhidemenu(){
if (window.delayhide)
clearTimeout(delayhide)
}
if (ie5||ns6)
document.onclick=hidemenu

