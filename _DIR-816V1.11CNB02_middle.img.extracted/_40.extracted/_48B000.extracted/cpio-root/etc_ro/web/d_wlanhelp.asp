if (HelpItem=='wlbasic'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'修改<b><font color="rgb(108,169,213)">无线网络名(SSID)</font></b> ' +
					'是保护您的网络的第一步. ' +
					'修改成您熟悉的名字但注意不要包含任何个人信息.<br><br>' +
					'选择自动信道模式可以使您的路由器选择最好的无线信道.<br><br>' +
					'<a href="d_helpwlan.asp#WlanBasic">更多帮助...</a>';

}else if (HelpItem=='wlsecurity'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'如果您设置了无线安全,请确保记录下您设置的 ' +
					'<b><font color="rgb(108,169,213)">加密密钥</font></b> ' +
					'您需要在无线客户端输入密钥信息. <br><br>' +
					'<a href="d_helpwlan.asp#WlanSecu">更多帮助...</a>';

}else if (HelpItem=='wladvanced'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'此页面配置无线高级参数。<br> ' +
					'<a href="d_helpwlan.asp#AdvWlan">更多帮助...</a>';
} else if (HelpItem=='Ctrl'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'此页面配置无线接入的白名单或黑名单。<br><br>' +
					'<a href="d_helpwlan.asp#WlanActrl">更多帮助...</a>';
} else if (HelpItem=='Wps'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面可以修改WPS设置。<br><br>' +
					'<a href="d_helpwlan.asp#WPS">更多帮助...</a>';
} else if (HelpItem=='Mbssid'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面用来配置虚拟AP。在这里您可以启用/禁用虚拟AP，以及设置SSID、认证类型等。<br><br>' +
					'<a href="d_helpwlan.asp#MBSSID">更多帮助...</a>';
} else if (HelpItem=='Wds'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'无线分布的系统通过无线介质与其他AP相联系，作用类似以太网。'+
					'您必须确保每个WDS设备使用相同的加密算法和密钥。<br><br>' +
					'<a href="d_helpwlan.asp#WDS">更多帮助...</a>';
}else if (HelpItem=='wlanbasic'){
  var tips='<br><strong>帮助提示...</strong><br><br><p><b>注意：</b>为保证本产品符合当地政府规定，同时与类似产品兼容，必须正确设置工作频道和地区。<p><b>正确安放路由器，优化无线连接性能 </b></p><p>路由器的实际安放情况将对无线连接的工作距离（或者说工作范围）产生显著影响。为求最佳工作效果，请按以下原则安放路由器：</p><ul><li>靠近计算机工作范围的中心部位， <li>放到高处，比如放到高台上， <li>远离潜在干扰源，例如计算机、微波炉和无绳电话， <li>天线拉直并且直立向上， <li>远离大块金属面。</ul></p>';
  document.getElementById('helpLabel').innerHTML = tips+'<br><br>' +
					'<a href="d_helpwlan.asp#WlanBasic">更多帮助...</a>';					
} else if (HelpItem=='wlanguest'){
  var tips='<br><strong>帮助提示...</strong><p><br><b>网络方案 </b></p><p>此表格是您所创建的访客网络的简短摘要，您最多可同时创建4个访客网络。它提供了此4个访客网络的编号、SSID、加密类型、访客网络是否启用、SSID是否广播等信息。选中每一方案的单选按钮可查看详细信息或更改其设置。</p><p><b>无线设置-方案</b></p><p>启用访客网络 </p><p>一旦选中该复选框，访客网络将被启用。您与来访者都能通过访客网络的SSID连接到网络。</p>';
  document.getElementById('helpLabel').innerHTML = tips+'<br><br>' +
					'<a href="d_helpwlan.asp#MBSSID">更多帮助...</a>';					
}else if (HelpItem=='wlwps'){
  var tips='<br><strong>帮助提示...</strong><br><br><p>您可以选择通过<b>PIN码模式</b>添加无线客户端。采用“<b>PIN码模式</b>”，您需要在此处输入客户端的PIN码。您必须同时启动客户端WPS进程，可以在客户端的管理工具上找到客户端的PIN码。</p>';
  document.getElementById('helpLabel').innerHTML = tips+'<br><br>' +
					'<a href="d_helpwlan.asp#wlwps">更多帮助...</a>';					
} else if (HelpItem=='wladv'){
  var tips='<br><strong>帮助提示...</strong><p>本无线路由器的设置已配置到最佳。如无支持人员指导，切勿对其进行更改。如更改不当，则有可能发生意外，从而致使路由器无法工作。</p>';
  document.getElementById('helpLabel').innerHTML = tips+'<br><br>' +
					'<a href="d_helpwlan.asp#wladv">更多帮助...</a>';					
}else if (HelpItem=='wlrepeater'){
  var tips='<br><strong>帮助提示...</strong><br><br><p><b>启用无线中继功能</b></p><p>此模式下，具有桥的功能。可使用无线中继器来扩大无线信号的覆盖范围。请在本页面扫描并连接要扩大无线信号覆盖范围的网络。</p>';
  document.getElementById('helpLabel').innerHTML = tips+'<br><br>' +
					'<a href="d_helpwlan.asp#wlrepeater">更多帮助...</a>';					
}else if (HelpItem=='wlctrl'){
  var tips='<br><strong>帮助提示...</strong><br><br><p>默认情况下，配置正确的无线网卡均可访问用户的无线网络。每一块网卡均有全球唯一的物理地址-MAC地址。用户可通过在无线网卡访问列表中添加特定无线网卡的MAC地址，对哪些客户端可以访问自己的无线网络进行限制，从而有效提高无线网络的安全性。</p>';
  document.getElementById('helpLabel').innerHTML = tips+'<br><br>' +
					'<a href="d_helpwlan.asp#wladv">更多帮助...</a>';					
}




