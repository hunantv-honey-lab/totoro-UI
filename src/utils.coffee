_config = require './config.json'
_os = require 'os'
_strformat = require 'strformat'

#获取本机的IP地址，用于没有设置服务器的地址，则用本机的地址作为服务器的地址。
getLocalIp = ()->
  localIp = ''
  ifaces = _os.networkInterfaces().en1
  ifaces.forEach (item)->
    localIp = item.address if (item.family is 'IPv4' && item.address != '127.0.0.1')
  localIp

exports.config = ()->
  host: _config.host || getLocalIp(),
  port: _config.port || 9999
  socket_port: _config.socket_port || 9998

exports.server_url = (api)->
  config = exports.config()
  _strformat 'http://{0}:{1}/{2}', config.host, config.port, api