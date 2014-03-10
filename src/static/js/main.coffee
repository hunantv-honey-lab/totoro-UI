_socket = io.connect '/'
_ele = null

#写入报告
reportWriter = (report)->
  source = $('#template-reports').html()
  template = Handlebars.compile(source)
  _ele.reportDetails.html template(report.info)
  _ele.reports.fadeIn()
  _ele.logs.hide()
  _ele.mainForm.fadeOut()

#写入日志
logWriter = (log)->
  info = log.info
  action = log.action
  html = "<div class='item #{action}'><span class='action'>#{action}</span><span class='info'>#{JSON.stringify(info)}</div>"
  _ele.logDetails.append(html)

statusWriter = (text, color)->
  html = "<span style='color: #{color}'>#{text}</span>"
  _ele.status.append(html)

#读取可用浏览器
getAllBrowsers = ()->
  #请求所有的浏览器
  _socket.emit 'browsers'
  #响应请求
  _socket.on 'browsers', (data)->
    source = $('#template-browsers').html()
    template = Handlebars.compile(source)
    _ele.browsers.html template(data)

#提交表单
submitForm = ()->
  #绑定处理执行任务的报告
  _socket.on 'onTaskReport', (reports)->
    reports.forEach (report)->
      switch report.action
        when 'endAll' then reportWriter report
        when 'pass' then statusWriter '.', 'green'
        when 'fail' then statusWriter 'x', 'red'
        else logWriter report

  _socket.on 'onProxyReq', (info)->
    console.log 'onProxyReq'
    console.dir(info)

  $('#btnTest').bind 'click', ()->
    runner = _ele.runner.val()
    objWrap = $('#divInput')

    #输入错误
    expression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
    if !expression.test(runner) then return objWrap.addClass('error') else objWrap.removeClass('error')

    _ele.status.empty()
    _ele.logs.fadeIn()
    _ele.logDetails.empty()
    _ele.mainForm.fadeOut();
    _socket.emit 'newTask', {runner: runner}

$().ready ()->
  _ele =
    runner: $('#txtRunner'),
    mainForm: $('#mainForm'),
    reports: $('#reports')
    logs: $('#logs')
    browsers: $('#browsers')
    status: $('#logs>.status')
    logDetails: $('#logs>.details')
    reportDetails: $('#reports>.details')
  getAllBrowsers()
  submitForm()
