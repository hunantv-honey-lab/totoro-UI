socket = io.connect '/'
#读取可用浏览器
getAllBrowsers = ()->
  #请求所有的浏览器
  socket.emit 'browsers'
  #响应请求
  socket.on 'browsers', (data)->
    source = $('#template-browsers').html()
    template = Handlebars.compile(source)
    $('#browsers').html template(data)

submitForm = ()->
  $('#mainForm').disable().bind 'submit', ()->
    runner = $('txtRunner').val()
    socket.emit 'newTask', {runner: runner}
    socket.on 'onTaskReport', (report)->
      console.log(report)
    socket.on 'onProxyReq', (info)->
      console.log(report)

$().ready ()->
  getAllBrowsers()
  submitForm()
