if (HelpItem=='deviceinfo'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'此页面检查路由器的基本设置和状态。'+
					'不过这一页面显示的是当前设置。如需'+
					'更改设置，则需在相应页面上进行。<br><br>' +
					'<a href="d_helpstatusinfo.asp#Status">更多帮助...</a>';

}else if (HelpItem=='statistic'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'此页面显示路由器各网络端口的统计信息。<br><br>' +
					'<a href="d_helpstatusinfo.asp#Stats">更多帮助...</a>';

}else if (HelpItem=='dhcpclient'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'此页面显示连接到路由器的客户端列表。<br><br>' +
					'<a href="d_helpstatusinfo.asp#Dhcpclient">更多帮助...</a>';

}
