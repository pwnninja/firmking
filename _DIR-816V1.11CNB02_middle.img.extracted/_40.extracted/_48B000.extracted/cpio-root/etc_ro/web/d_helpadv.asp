<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
</head>
<body>
<blockquote>
<SCRIPT language="JavaScript">
var LoginUser = 'admin';
var wireless = '1';var buildPortmap = '0';</SCRIPT>
<script language="JavaScript">
 TabHeader="帮助";
 SideItem = "高级";
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
  <td class=topheader>高级帮助</td>
 </tr>
 <tr>
  <td class=content>
   <ul>

    <script language="javascript">
    if (LoginUser == "admin")
                {
                    document.writeln('<li><a href="d_helpadv.asp#Acl">访问控制</a>');
                    document.writeln('<li><a href="d_helpadv.asp#PortTriggering">端口触发</a>');

   document.writeln('<li><a href="d_helpadv.asp#DMZ">DMZ</a>');

                    document.writeln('<li><a href="d_helpadv.asp#Url">站点限制</a>');
                    document.writeln('<li><a href="d_helpadv.asp#DDNS">动态DNS</a>');

                    document.writeln('<li><a href="d_helpadv.asp#Netsniper">网络尖兵</a>');

                    document.writeln('<li><a href="d_helpadv.asp#IPQosTC">QoS设置</a>');
                    document.writeln('<li><a href="d_helpadv.asp#UPnP">UPnP</a>');

                    document.writeln('<li><a href="d_helpadv.asp#VirtualSrv">虚拟服务器</a>');




    }
    </script>
   </ul>
  </td>
 </tr>
</table>
<br>
<div id="aclHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=Acl>访问控制</a>
  </td>
 </tr>

 <tr>
  <td class=content>
     <p>您可以指定在WAN端开启哪种服务。只有ACL列表中的条目所指定类型的数据包才能进入AP路由器。只有您指定的IP或接口才能访问AP路由器上您所开放的服务。</p>
  </td>
 </tr>
</table>
<br>
</div>
<div id="portTriggerHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=PortTriggering>端口触发</a>
  </td>
 </tr>
 <tr>
  <td class=content>
            <p>端口对外向流量进行监控。当路由器检测到特定外向端口的流量，它会记住发送数据和“触发”该输入端口的计算机的IP地址。被触发的端口上的输入信息流随后发送到触发计算机。通过端口映射/端口触发页面，可实现从因特网上对本地计算机或者服务器的访问，从而实现不同的服务（例如FTP或者HTTP）、网络游戏（Quake III之类），或者使用因特网应用（比如CUseeMe等等）。端口映射用于FTP，Web服务器或其它基于服务器的服务。一旦端口发送被安装，来自因特网的需求将发送到适当的服务器。端口触发只能在指定的端口被触发后才允许通过来自因特网的请求。端口触发应用于聊天和因特网游戏。
            </p>
  </td>
 </tr>
</table>
<br>
</div>

<div id="dmzHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=DMZ>DMZ</a>
  </td>
 </tr>
 <tr>
  <td class=content>
              <p>DMZ用来向广域网提供服务并且避免了本地主机被广域网的未经授权的进入。典型的DMZ有一些广域网可以访问的设备，比如web服务器，FTP服务器，SMTP(电子邮件)服务器和DNS服务器。</p>
  </td>
 </tr>
</table>
<br>
</div>

<div id="urlHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=Url>站点限制</a>
  </td>
 </tr>
 <tr>
  <td class=content>
   <p>此页面用来配置站点限制。您可以增加或删除限制站点的关键字。此功能启用并增加限制关键字后可以阻止局域网用户访问带关键字的站点。</p>
  </td>
 </tr>
</table>
<br>
</div>

<div id="ddnsHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=DDNS>动态DNS</a>
  </td>
 </tr>
 <tr>
  <td class=content>
            <p>动态DNS：是指没有固定IP的主机，利用动态DNS服务，帮助主机可以随著IP的改变去相应改变网域名称与IP的关系。本页面用来配置在dlinkddns，DynDNS.org，FreeDns和Oray等动态DNS地址. 您可以通过添加/删除来配置动态DNS。账户设置为DDNS服务商提供的账户。</p>
    </td>
 </tr>
</table>
<br>
</div>

<div id="netSniperHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=Netsniper>网络尖兵</a>
  </td>
 </tr>
 <tr>
  <td class=content>
            <p>用于配置网络尖兵，正确配置可以使多台电脑通过此路由器共享宽带。</p>
    </td>
 </tr>
</table>
<br>
</div>

<div id="netToolHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=IPQosTC>QoS设置</a>
  </td>
 </tr>
 <tr>
  <td class=content>
            <dl>
                <dt>QoS设置
                <dd>QoS是一种主动调整流量输出速率的措施。作用是限制流出某一网络的某一连接的流量与突发，使这类报文以比较均匀的速度向外发送。你可以添加Qos规则。
                <dt>启用自动带宽
                <dd>自动调整当前存在的流，使每个流的报文均匀的向外发送。
                <br>
            </dl>
    </td>
 </tr>
</table>
<br>
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=UPnP>UPnP</a>
  </td>
 </tr>
 <tr>
  <td class=content>
            <dl>
             <dd>用来配置UPnP。开启后系统将在后台执行。
            </dl>
    </td>
 </tr>
</table>
<br>
<table id=body_header border=0 cellSpacing=0>
    <tr>
        <td class=topheader>
            <a name=Telnet>Telnet</a>
        </td>
    </tr>
    <tr>
        <td class=content>
            <dl>
                <dd>Telnet协议是TCP/IP协议族的其中之一，是Internet远端登录服务的标准协议和主要方式，常用于网页服务器的远端控制，可供使用者在本地主机执行远端主机上的工作。
            </dl>
        </td>
    </tr>
</table>
<br>
</div>
<div id="routerHelp" style="display:none">

<br>
</div>
<div id="natHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=VirtualSrv>虚拟服务器</a>
  </td>
 </tr>
 <tr>
  <td class=content>
            <dl>
    <dd>
                    <dl>
                        <dt>通用服务名称
                        <dd>选择通用的服务名称。
                        <dt>用户自定义服务名称
                        <dd>用户可以自己定义服务名称。
                        <dt>协议
                        <dd>TCP或者UDP。
                        <dt>WAN端口
                        <dd>WAN的端口。
                        <dt>LAN侧开放端口
                        <dd>LAN侧开放的端口。
                        <dt>LAN侧IP地址
                        <dd>LAN侧的IP地址。
     </dl>
            </dl>
    </td>
 </tr>
</table>
<br>
</div>

<div id="algHelp" style="display:none">
<table id=body_header border=0 cellSpacing=0>
 <tr>
  <td class=topheader>
   <a name=Alg>系统安全管理</a>
  </td>
 </tr>
 <tr>
  <td class=content>
   <p>用于设置勾选每个基本安全选项。</p>
  </td>
 </tr>
</table>
<br>
</div>

<script language="javascript">
if (LoginUser == "admin"){
 document.getElementById("aclHelp").style.display = 'block';
 document.getElementById("portTriggerHelp").style.display = 'block';
 document.getElementById("dmzHelp").style.display = 'block';
 document.getElementById("urlHelp").style.display = 'block';
 document.getElementById("ddnsHelp").style.display = 'block';
 document.getElementById("netSniperHelp").style.display = 'block';
 document.getElementById("netToolHelp").style.display = 'block';
 document.getElementById("routerHelp").style.display = 'block';
 document.getElementById("natHelp").style.display = 'block';
 document.getElementById("algHelp").style.display = 'block';
}else{
 document.getElementById("aclHelp").style.display = 'none';
 document.getElementById("portTriggerHelp").style.display = 'none';
 document.getElementById("dmzHelp").style.display = 'none';
 document.getElementById("urlHelp").style.display = 'none';
 document.getElementById("filterHelp").style.display = 'none';
 document.getElementById("ddnsHelp").style.display = 'none';
 document.getElementById("netSniperHelp").style.display = 'none';
 document.getElementById("netToolHelp").style.display = 'none';
 document.getElementById("routerHelp").style.display = 'none';
 document.getElementById("natHelp").style.display = 'none';
 document.getElementById("algHelp").style.display = 'none';
}
</script>
<script type='text/javascript'>
 mainBodyEnd();
 ThirdRowEnd();
 Footer()
 mainTableEnd()
</script>
</blockquote>
</body>
</html>

