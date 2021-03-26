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
var wireless = '1';</SCRIPT>
<script language="JavaScript">
 TabHeader="帮助";
 SideItem="无线";
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
    无线帮助(2.4G/5.8G)
   </td>
  </tr>
  <tr>
   <td class=content>
   <ul>

    <li><a href="d_helpwlan.asp#WlanBasic">无线基本设置</a>
    <script>
    if (LoginUser == "admin"){

    document.writeln('<li><a href="d_helpwlan.asp#wlwps">WPS设置</a>');
    document.writeln('<li><a href="d_helpwlan.asp#wladv">无线高级设置</a>');
    document.writeln('<li><a href="d_helpwlan.asp#wlrepeater">无线中继</a>');
    }
    </script>
   </ul>
   </td>
  </tr>
 </table>
 <br>
 <table id=body_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>
    <a id=WlanBasic name=WlanBasic>无线基本设置</a>
   </td>
  </tr>
  <tr>
   <td class=content>
    <dl>
    <dt>无线网络</dt>
    <dd>
     <dl>
      <p>
       <strong>启用SSID广播</strong>
       <br>启用了本选项之后，无线路由器会向所有无线工作站广播其无线网络标识（SSID）。这样附近的计算机或其他无线客户端即可搜索到本路由器的无线信号、通过选择正确的无线网络标识来连接到本接入点。
      </p>
      <p>
       <strong>启用无线隔离</strong>
       <br>如果选中，此SSID下的无线客户端只能访问互联网，无法与其他无线客户端、以太网客户端或其他设备互访。
      </p>
      <p>
       <strong>无线网络标识（SSID）</strong>
       <br>SSID可以简单理解为无线网络的名称，默认为
       <script>
                            document.write('\"D-Link_DIR-816\"');
       </script>
       ，不过本公司强烈建议您将自己的无线网络标识（SSID）更改为其它值，以免与附近的其他无线网络混淆。修改SSID时，请在本框中输入一个最多不超过32个字符的字母数字字符串。本名称区分大小写。比如，SSID和SSId就是不同的。
      </p>
      <p>
       <strong>模式</strong>
       <br>选择所需的无线模式。选项如下：
       <ul>
       <script>
        document.writeln('<li>802.11b -- 最高速率不超过11 Mbps。</a>');
        document.writeln('<li>802.11g -- 最高速率不超过54 Mbps。</a>');
        document.writeln('<li>802.11n -- 20M带宽最高速率不超过130 Mbps（短报文下则不超过150 Mbps）；40M带宽最高速率不超过270 Mbps（短报文下则不超过300 Mbps）。 </a>');
        document.writeln('<li>802.11b/g -- 最高速率不超过54 Mbps。</a>');
        document.writeln('<li>802.11n/g -- 20M带宽最高速率不超过130 Mbps（短报文下则不超过150 Mbps）；40M带宽最高速率不超过270 Mbps（短报文下则不超过300 Mbps）。</a>');
        document.writeln('<li>802.11b/g/n -- 20M带宽最高速率不超过130 Mbps（短报文下则不超过150 Mbps）；40M带宽最高速率不超过270 Mbps（短报文下则不超过300 Mbps）。 </a>');
        document.writeln('<li>802.11a -- 最高速率不超过54 Mbps。</a>');
        document.writeln('<li>802.11a/n -- 20M带宽最高速率不超过130 Mbps（短报文下则不超过150 Mbps）；40M带宽最高速率不超过270 Mbps（短报文下则不超过300 Mbps）。</a>');
        document.writeln('<li>802.11a/n/ac -- 20M带宽最高速率不超过78 Mbps（短报文下则不超过86 Mbps）；40M带宽最高速率不超过180 Mbps（短报文下则不超过200 Mbps）；80M带宽最高速率不超过390 Mbps（短报文下则不超过433 Mbps）。 </a>');
        document.writeln('<li>802.11n/ac -- 20M带宽最高速率不超过78 Mbps（短报文下则不超过86 Mbps）；40M带宽最高速率不超过180 Mbps（短报文下则不超过200 Mbps）；80M带宽最高速率不超过390 Mbps（短报文下则不超过433 Mbps）。 </a>');
		</script>
       </ul>
      </p>
      <p>
       <br>可以从<strong>无线高级设置</strong>中设置为长报文或短报文。
      </p>
      <p>
       <strong>频道</strong>
       <br>默认为“自动”。无线路由器将自动搜索当前可用的最佳频道。您也可以指定无线网络工作的频道，可选的频道中，优先选择1、6、11（与相邻频道重叠最小）。
      </p>
     </dl>
    </dd>
    <dt>安全选项</dt>
    <dd>
     <ul>
      <li><p>无——无数据加密。</p></li>
      <li><p>WEP（有线等效加密）——采用WEP 64位或者128位数据加密。注意：当启用该加密时，Wi-Fi Protected Setup(WPS)功能则停止且不支持11N的速率。</p></li>
      <li><p>WPA-PSK（预共享密钥Wi-Fi保护访问）——采用WPA-PSK标准加密，加密类型TKIP。TKIP即“Temporal Key Integrity Protocol”（临时密钥完整性协议），它利用更强大的加密方法，并结合“消息完整性代码”(MIC)来防御黑客的攻击。</p></li>
      <li><p>WPA2-PSK[AES]（预共享密钥Wi-Fi保护访问，版本2）——采用WPA2-PSK标准加密，加密类型AES。AES即“Advanced encryption standard”（高级加密标准），其利用对称128位块数据加密。</p></li>
      <li><p>WPA-PSK[AES]+WPA2-PSK[AES]——允许客户端使用WPA-PSK[AES]或者WPA2-PSK[AES]。</p></li>
     </ul>
    </dd>
    <dt>安全加密（WEP）</dt>
    <dd>
     <dl>
     <p>
      <strong>认证类型</strong>
      <br>一般情况下本栏可保留缺省值<b>自动</b>。默认值无法正常工作时，请选择适当的值：<b>共享密钥</b>。具体采用哪种方法，请参考您的无线网卡说明书。
     </p>
     <p>
      <strong>加密强度</strong>
      <br>请选择WEP加密强度：<br>
      <ul>
       <li>64位（有时也称为40位）加密。</li>
       <li>128位加密。</li>
      </ul>
     </p>
     </dl>
    </dd>
    <dt>安全加密（WEP）密钥</dt>
    <dd><p>在启用了WEP之后，用户可手工输入或者采用程序自动生成这四个数据加密密钥。在网络中的无线客户端上，必须准确输入密钥的数值，才能成功连接。</p>
    <p><br>WEP加密有设置方法：从四个密钥中选择需要使用的一个，然后在所选的密钥框中输入网络的匹配WEP密钥信息。输入时遵循以下规则：</p>
    <ul>
     <li>64位WEP——输入十位十六进制数字（0-9和A-F之间的任意组合）。 </li>
     <li>128位WEP——输入二十六位十六进制数字（0-9和A-F之间的任意组合）。 </li>
    </ul>
    <p><b>注意：</b>以Windows XP SP2操作系统为例，无线管理工具默认密钥为“密钥1”，如果您不熟悉计算机中选择其他密钥的方法，请在设置加密时选择“密钥1”即可。</p>
    </dd>
    <dt>安全加密（WPA-PSK、WPA2-PSK、WPA-PSK+WPA2-PSK）</dt>
    <dd><p>选择相应的加密方式，在本框中输入长度介于8~63个字符之间的口令。</p></dd>
    </dl>
    <br>
     </td>
  </tr>
 </table>
 <br>
<div id="wirelessAdvHelp" style="display:none">

<br>
 <table id=body_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>
    <a id=wlwps name=wlwps>WPS设置</a>
   </td>
  </tr>
  <tr>
   <td class=content>
    <dl>
    <dt>WPS设置</dt>
    <dd><p>WPS代表Wi-Fi保护设置。您可以通过这一过程轻松地将无线客户端添加到网络，而无需进行任何具体的配置，例如SSID、安全模式和密码之类的配置。<br>采用<b>PIN码模式</b>，您需要在此处输入客户端的PIN码。您必须同时启动客户端WPS进程，可以在客户端的管理工具上找到客户端的PIN码。</p></dd>
    </dl>
    <br>
     </td>
  </tr>
 </table>
 <table id=body_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>
    <a id=wladv name=wladv>无线高级设置</a>
   </td>
  </tr>
  <tr>
   <td class=content>
    <dl>
       <dt>无线高级设置</dt>
       <dd>
        <dl>
         <p>
          <strong>启用无线路由器无线收发功能</strong>
          <br>路由器的无线功能可以由用户选择启用或禁用。路由器前面板上的无线指示灯会显示无线接入点的当前状态。无线功能启用时，路由器面板上无线指示灯闪亮，客户端可以无线连接到路由器；无线功能禁用时，无线指示灯熄灭，无线客户端无法搜索到此无线网络。
         </p>
         <p>
          <strong>碎片限值、CTS/RTS限值、报头模式</strong>
          <br>这些设置属于保留设置，仅用于无线测试及高级配置。切勿更改这些设置。
         </p>
         <p>
          <strong>调节发射功率</strong>
          <br>显示路由器可用的发射功率。您可以根据需要自行调节该功率大小。
         </p>
        </dl>
       </dd>
       <dt>WPS设置</dt>
       <dd>
        <dl>
         <p>
          <strong>路由器的PIN值</strong>
          <br>这是通过WPS配置路由器的无线设置时要在无线客户端上使用的PIN码。您也可以在路由器的产品标签上找到该PIN。
         </p>
         <p>
          <strong>启用WPS</strong>
          <br>开启WPS功能。
         </p>
         <p>
          <strong>禁用路由器的PIN</strong>
          <br>仅当启用了路由器的PIN时，您才能依据路由器的PIN通过WPS配置路由器的无线设置或添加无线客户端。当路由器检测到存在依据路由器的PIN通过WPS侵扰路由器无线设置的可疑操作时，系统可能暂时禁用路由器的PIN功能。用户可以通过取消选中该选项并单击“应用”按钮手动启用此功能。
         </p>
         <p>
          <strong>保持现有的无线设置</strong>
          <br>这显示路由器是否处于“WPS已配置”状态。如果未选中上述这一选项，添加新的无线客户端会将路由器的无线设置更改为自动生成的随机SSID和安全密钥。相反，如果选中该选项，则一些外部注册者（例如Windows Vista上的“网络浏览器”）可能看不到该路由器。从路由器的管理界面配置基本无线设置将使该选项变为选中状态。
         </p>
        </dl>
       </dd>
      <dt>无线网卡访问列表</dt>
      <dl></dl>
      <dd><p>默认情况下，配置正确的无线网卡均可访问用户的无线网络。每一块网卡均有全球唯一的物理地址-MAC地址。用户可通过在无线网卡访问列表中添加特定无线网卡的MAC地址，对哪些客户端可以访问自己的无线网络进行限制，从而有效提高无线网络的安全性。设置页面中显示了无线网卡访问控制列表。启用访问控制后，只有列表中的无线网卡可连接到本路由器。不过，要访问无线网络，还必须注意其他的无线设置同样准确无误。</p>
      <dl>
       <p>
        <strong>打开无线访问控制</strong>
        <br></p>
        <ol>
         <li>单击<b>打开无线访问控制</b>复选框，即可根据无线网卡的MAC地址对无线网卡进行限制。 </li>
         <li>单击<b>应用</b>按钮保存更改，并返回到<b>无线高级设置</b>页面。</li>
         <b>注意：</b>启用了<b>打开无线访问控制</b>之后，如果<b>访问控制列表</b>为空，那么所有的无线网卡均无法连接到用户的无线网络！
        </ol>
       <p></p>



       <p>
        <strong>可用的无线网卡</strong>
        <br>列表显示了所有可用的无线PC网卡及其MAC地址。
        <br>对于<b>可用的无线网卡</b>列表中显示的无线PC网卡而言，单击该网卡的单选按钮即可捕获其MAC地址。但如果列表中没有显示所需的无线PC网卡，则需确认该网卡是否已经过了正确的设置，然后单击<b>刷新</b>按钮更新无线PC网卡的可用列表。如果此时仍然没有显示出所需的无线PC网卡，则请按照以下说明手工设置该无线PC网卡的MAC地址。
       </p>
       <p>
        <strong>输入无线网卡</strong>
        <br>如果可用的无线网卡列表中没有显示任何无线网卡，则可以手工输入待授权无线PC网卡的设备名和MAC地址。
        <br><b>注意：</b>MAC地址是一个字符串，其中包含十二个字符，通常可在无线设备的底部找到。
       </p>
      </dl>
      </dd>
    </dl>
    <br>
     </td>
  </tr>
 </table>
 <table id=body_header border=0 cellSpacing=0>
  <tr>
   <td class=topheader>
    <a id=wlrepeater name=wlrepeater>无线中继</a>
   </td>
  </tr>
  <tr>
   <td class=content>
    <dl>
     <dt>无线中继</dt>
     <dd>
      <dl>
       <p>
       <strong>启用无线中继</strong>
       <br>启用中继模式DHCP服务器将自动关闭(关闭中继模式DHCP服务器将自动开启)。建议将计算机的IP地址和DNS地址设置为自动获取。如果计算机是从上行AP获得地址，要登录本设备管理页面，需要手动设置计算机的IP地址。
       </p>
      </dl>
     </dd>
    </dl>
    <br>
     </td>
  </tr>
 </table>
</div>
<script type='text/javascript'>
 mainBodyEnd();
 ThirdRowEnd();
 Footer();
 mainTableEnd();
</script>
<script language="javascript">
if (LoginUser == "admin"){
 document.getElementById("wirelessAdvHelp").style.display = 'block';
}else {
 document.getElementById("wirelessAdvHelp").style.display = 'none';
}
</script>
</blockquote>
   </body>
</html>

