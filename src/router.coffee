_proxy = require './proxy'
_utils = require './utils'
_mime = require 'mime'
_path = require 'path'
_fs = require 'fs'
_less = require 'less'
_coffee = require 'coffee-script'

#编译coffee文件
compileCoffee = (content, callback)->
  content = _coffee.compile content
  callback null, content

#编译less文件
compileLess = (content, callback)->
  _less.render content, (err, css)->
    callback err, css

#读取静态文件
readStatic = (file, callback)->
  ext = _path.extname file
  content = _fs.readFileSync file, 'utf-8'
  switch ext
    when '.coffee' then compileCoffee content, callback
    when '.less' then compileLess content, callback
    else callback null, content

#返回404错误
responseNotFound = (req, res, next) ->
  res.statusCode = 404
  res.end('404 Not Found')

#响应静态文件
responseStatic = (req, res, file)->
  #查找文件，如果文件不存在，则返回404
  file = _path.join __dirname, file
  return responseNotFound(req, res, file) if not _fs.existsSync(file)

  readStatic file, (err, content)->
    #发生错误
    if(err)
      res.statusCode = 500
      console.log err
      return res.end('Server Error.')

    #响应数据
    mime = _mime.lookup file || '.txt'
    res.setHeader 'Content-Type', mime;
    res.end content

#创建新任务的API
newTaskAPI = (socket)->
  #监听客户端的newTask
  socket.on 'newTask', (data)->
    _proxy.newTask data,
      #处理返回的报告
      onReport: (reports)->
        socket.emit 'onTaskReport', reports
      #处理ProxyReq
      onProxyReq: (info)->
        socket.emit 'onProxyReq', info

module.exports = (app, io)->
  #处理socket相关
  io.sockets.on 'connection', (socket)->
    #创建新任务
    newTaskAPI(socket)
    #其它的一般性任务
    ['browsers'].forEach (action)->
      socket.on action, (data)->
        _proxy[action].call null, data, (err, response)->
          socket.emit action, response

  #预定义less和coffee
  _mime.define
    'application/x-font-truetype': ['ttf']
    'text/css': ['less'],
    'application/x-javascript': ['coffee']

  #读取首页
  app.get '/', (req, res, next) ->
    responseStatic req, res, 'static/index.html'

  #读取静态文件
  app.get /(css|js|ttf|eot|svg|woff|otf)\/*/i, (req, res, next)->
    responseStatic req, res, _path.join('static', req.url)

  #获取可用浏览器列表
  app.get '/api/browsers', (req, res, next)->
    _proxy.browsers res, req, next