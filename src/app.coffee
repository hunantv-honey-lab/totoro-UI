_coffee = require 'coffee-script'
_express = require "express"
_http = require "http"
_app = _express()
_server = _http.createServer _app
_io = require('socket.io').listen(_server)
_router = require './router'
_proxy = require './proxy'

#配置express
_app.configure ()->
  _app.set 'port', 1436

_router(_app, _io);

_server.listen _app.get('port')

###
_app = require('express')()
_server = require('http').createServer(_app)
_io = require('socket.io').listen(_server);

_app.configure ()->
  _app.set 'port', 1436

_server.listen _app.get('port')
###
