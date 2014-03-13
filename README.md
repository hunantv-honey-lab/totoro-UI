totoro-UI
=========

totoro-UI是一个基于totoro的UI工具，主要目的是隔离复杂的操作，让普通的前端人员可以直接通过可视化界面的方式来调度测试，并提供一个友好的可视化测试报告。

##先决条件

* 你需要了解totoro，并部署totoro-server，如果你还不了解totoro，可以参考如下链接：
	* [totoro](https://github.com/totorojs/totoro)
	* [totoro-server](https://github.com/totorojs/totoro-server)
* 使用`npm install totoro-server`来安装totoro-server，然后启动totoro-server。你看到一个totoro-server的监听地址被打印出来，如**http://192.168.1.2:9999**
* 至少启动一个浏览器labor，即使用任意浏览器访问totoro-server监听的地址


##安装及配置totoro-UI

1. `git clone https://github.com/hunantv-honey-lab/totoro-UI.git`
2. `cd totoro-UI/src`
3. `npm install`
4. 打开`src/config.json`，将server键改为totoro-server监听的地址，如`192.168.1.2`
5. `node app.coffee`，启动totoro-UI，totoro-UI默认的端口为1436

提醒，目前totoro-UI必需安装有coffee-script，自动build的功能还没有完成，但这部分正在schdule中


##使用

在任何浏览器中，打开totoro-UI的访问URL，如`http://127.0.0.1:1436`，输入你将要测试的地址，待测试完成后，你将会得到一个友好的可视化测试报告。



