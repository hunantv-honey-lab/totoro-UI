_socket = io.connect '/'
_ele = null

#写入报告
reportWriter = (report)->
  info = report.info
  action = report.action
  ###
  switch action
    when 'debug', 'info', 'warn', 'error' then console.log(action, info)
    when 'pass' then console.log 'pass'
    when 'pending' then console.log 'pending'
    when 'fail' then console.log 'fail'
    when 'timeout' then console.log 'timeOut'
    when 'endAll' then console.log 'endAll'
    else console.log 'Not realized report action <' + action + '>'
  ###
  html = "<li class='#{action}'><span class='action'>#{action}</span><span class='info'>#{JSON.stringify(info)}</span>"
  _ele.reports.append(html)

  console.dir report if action is 'endAll'

#读取可用浏览器
getAllBrowsers = ()->
  #请求所有的浏览器
  _socket.emit 'browsers'
  #响应请求
  _socket.on 'browsers', (data)->
    source = $('#template-browsers').html()
    template = Handlebars.compile(source)
    $('#browsers').html template(data)

#提交表单
submitForm = ()->
  #绑定处理执行任务的报告
  _socket.on 'onTaskReport', (reports)->
    reports.forEach reportWriter
  _socket.on 'onProxyReq', (info)->
    console.log 'onProxyReq'
    console.dir(info)

  _ele.mainForm.bind 'submit', ()->
    _ele.reports.empty()
    runner = _ele.runner.val()
    _socket.emit 'newTask', {runner: runner}
    return false

$().ready ()->
  _ele =
    runner: $('#txtRunner'),
    mainForm: $('#mainForm'),
    reports: $('#reports')

  getAllBrowsers()
  submitForm()
