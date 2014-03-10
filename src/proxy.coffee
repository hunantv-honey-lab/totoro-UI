#代理获取totoro-server的信息
_http = require 'http'
_utils = require './utils'
_strformat = require 'strformat'
_io = require 'socket.io-client'
_utils = require './utils'

#读取浏览器列表
exports.browsers = (data, callback)->
  url = _utils.server_url '__list'
  _http.get(url, ($res)->
    data = ''
    #读取数据
    $res.on "data", (chunk) ->
      data += chunk

    #结束
    $res.on "end", ->
      callback null, JSON.parse(data)
  ).on "error", (e) ->
    callback '服务器发生错误'

#获取正在运行的任务列表
exports.runningTasks = (res, req, next)->

#获取所有的任务列表
exports.allTasks = (res, req, next)->

###
  新建一个任务
  @param {string} runner - 即将要启动的任务
  @param {object} options - 选项，包括处理socket返回的数据
###
exports.newTask = (data, options)->
  socket = _io.connect _utils.server_url('order');
  #连接服务器
  socket.on 'connect', ()->
    config =
      runner: data.runner,
      catch: true,
      charset: 'utf-8',
      timeout: 5,
      adapter: undefined,
      repo: undefined,
      version: '0.5.3'
    socket.emit 'init', config;

  #获取报告
  socket.on 'report', options.onReport
  socket.on 'proxyReq', options.onProxyReq

  #失去链接
  socket.on 'disconnect', options.onDisconnect || ()->
    console.log '测试服务器链接失败'
  #发生错误
  socket.on 'error', options.onError || ()->
    console.log '发生Socket错误'

#获取一个任务的运行情况
exports.taskInfo = (taskId)->