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
var wireless = '1';var LanMacAddrCtrl = '0';var LanLinkModeCtrl = '0';</SCRIPT>
<script language="JavaScript">
 TabHeader="帮助";
 SideItem="设置";
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
   <td class=topheader>
    设置帮助
   </td>
  </tr>
  <tr>
   <td class=content>
   <ul>
    <script language="javascript">
    if (LoginUser == "admin")
     document.writeln('<li><a href="d_helpsetup.asp#Wizard">Internet设置向导</a>');
    </script>
    <li><a href="d_helpsetup.asp#LAN">局域网设置</a>
	<script>
			if(!(("<% getCfgZero(1,"ApCliEnable");%>"==1)||("<% getCfg2Zero(1,"ApCliEnable");%>"==1))){//如果关闭无线中继
				document.writeln('<li><a href="d_helpsetup.asp#Internet">Internet设置</a></a>');
			}
	</script>




   </ul>
   </td>
  </tr>
 </table>
 <br>

 <div id="wizzardHelp" style="display:none">
 <table id=body_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>
    <a name="Wizard" id="Wizard">Internet设置向导</a>
   </td>
  </tr>
  <tr>
   <td class=content>
   		<script>
			if(!(("<% getCfgZero(1,"ApCliEnable");%>"==1)||("<% getCfg2Zero(1,"ApCliEnable");%>"==1))){
				document.writeln("<p>如果您以前从未配置过路由器或者不知如何配置，请点击<span class=button_ref>Internet设置向导<\/span>，路由器将指导您通过一些简单的配置步骤使网络正常连线和工作。<\/p>");
			}else{
				document.writeln("<p>路由器将指导您通过一些简单的配置步骤使网络正常连线和工作。<\/p>");
			}
		</script>
   </td>
  </tr>
 </table>
 <br>
 </div>

 <table id=body_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>
    <a id=LAN name=LAN>局域网设置</a>
   </td>
  </tr>
  <tr>
  <td class=content>
  <p>您可以配置局域网接口的参数。</p>
   <dl>
   <dt>局域网接口设置
       <dd>您可以设置局域网接口的IP地址和子网掩码。IP地址用于访问路由器的网页管理接口。一般情况下，请保留默认设置。
         <dl>
       <dt>路由器IP地址
           <dd>表示路由器局域网的IP地址。可以设置路由器局域网IP地址，比如，192.168.0.1。
           <dt>子网掩码
           <dd>路由器局域网地址的子网掩码。
      </dd>
      </dl>
   </dl>

   <dl>
    <dt>DHCP服务器设置
        <dd>DHCP表示动态主机配置协议。DHCP页面上可以配置DHCP服务器参数，用于给局域网中的计算机和其他设备正确分配IP地址。
         <dl>
          <dt>DHCP模式
           <dd>
           <p>如果您的路由器已正确配置，只要开启此功能，DHCP服务器负责管理局域网中的计算机和其他设备的IP地址和其他网络配置信息。您不需要自己管理这些信息。</p>
           <p>您局域网中的计算机或其他设备需要把TCP/IP协议属性设置为"DHCP"或者"自动获得IP地址"。</p>
     <p>
     当您设置DHCP模式为<span class=option>DHCP服务器</span>，主要参数如下:</p>
           <dt>IP地址池
     <dd>
     起始IP地址和终止IP地址指定了DHCP服务器分配给局域网中的计算机和其他设备的IP地址范围。这个范围之外的地址不能由DHCP服务器分配，可以用于手动配置IP地址的设备或者不能使用DHCP自动获取网络地址等信息的设备。
     <p>
     您的路由器，默认有一个静态IP地址192.168.0.1，所以DHCP服务器可用于分配的地址范围为192.168.0.2-192.168.0.254。</p>
           <DIV class=help_example>
           <dl>
     <dt>例如:
     <dd>
     您路由器的IP地址为192.168.0.1，另外您指定一台IP地址为192.168.0.3的计算机为网页服务器，指定一台IP地址为192.168.0.4的计算机为FTP服务器，在这种情况下，DHCP服务器的起始地址需要设置为192.168.0.5或者更大。
     <dt>例如:
     <dd>
     假如您配置的DHCP服务器地址池为192.168.0.100-192.168.0.199，这表示地址范围192.168.0.3-192.168.0.99和192.168.0.200-192.168.0.254不可分配，计算机或者其他设备必须手动配置才能使用这些地址。
     </dd>
     </dl>
     </DIV>
           <dt>默认网关
           <dd>DHCP服务器作用域的默认网关地址。
           <dt>最大租约时间
                 <dd>
                 租约时间表示计算机获取IP地址后可以使用这个IP地址的期限。如果客户端需要继续使用这个地址，必须在到期前重新发起请求。只有当原来的客户端租约到期并且不再发起续租请求时，这个地址才能分配给其他客户端使用。
           <dt>域名
           <dd>DHCP服务器作用域的默认域名。
           <dt>DNS服务器
           <dd>DHCP服务器作用域的默认DNS服务器地址。
      </dd>
      </dl>
   </dl>

   <dl>
   <dt>DHCP地址保留配置
      <dd>
      如果您需要为局域网上的计算机或设备分配固定的IP地址，请配置DHCP地址保留，绑定设备的MAC地址到对应的IP地址。
         <dl>
      <dt>IP地址
         <dd>配置局域网接入设备的IP地址。例如，192.168.0.2。
         <dt>Mac地址
         <dd>局域网接入设备的MAC地址。
      </dd>
      </dl>
   </dl>







       </td>
  </tr>
 </table>
 <br>

<script>
	if(!(("<% getCfgZero(1,"ApCliEnable");%>"==1)||("<% getCfg2Zero(1,"ApCliEnable");%>"==1))){//如果关闭无线中继
		document.writeln("<table id=body_header border=0 cellSpacing=0>");
	}else{
		document.writeln("<table id=body_header border=0 cellSpacing=0 style=\"display:none;\">");
	}
</script>
  <tr>
   <td class=topheader>
    <a name="Internet" id="Internet">Internet设置</a>
   </td>
  </tr>
  <tr>
   <td class=content><dl>
               <dd>
              <p>如果您曾经有配置路由器的经验，对路由器配置比较熟悉，请在页面<span class=button_ref>Internet设置</span>中手动配置上网参数。
              </p>
     </dd>
   </dl>
        </td>
  </tr>
 </table>
 <br>
<script language="javascript">
if (LoginUser == "admin"){
 document.getElementById("wizzardHelp").style.display = 'block';
}else{
 document.getElementById("wizzardHelp").style.display = 'none';
}
</script>
<script type='text/javascript'>
 mainBodyEnd();
 ThirdRowEnd();
 Footer();
 mainTableEnd();
</script>
</blockquote>
   </body>
</html>

