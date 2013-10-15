request = require 'request'

ARecord = require './a_record'

class Client

  constructor: (@token)

  a_record: (zone, fqdn) ->
    new ARecord zone, fqdn, @

  query: (path = '/') ->
    path = '/' + path if path[0] isnt '/'
    uri = "https://"
    uri+= "api.dynect.com/REST#{path}"
    switch typeof @token
      when "object" # new session
        if @token.customer and @token.username and @token.password
          foo = bar
          # Add querystring to uri
      when "string" # existing session
        foo = bar
        # Use token in header?

  errorHandle: (res, body, callback) ->
    # TODO: More detailed HTTP error message
    return callback(new Error('Error ' + res.statusCode)) if Math.floor(res.statusCode/100) is 5
    try
      body = JSON.parse(body || '{}')
    catch err
      return callback(err)
    return callback(new Error(body.message)) if body.message and res.statusCode is 422
    return callback(new Error(body.message)) if body.message and res.statusCode in [400, 401, 404]
    callback null, res.statusCode, body, res.headers

  get: (path, callback) ->
    request
      uri: @query path
      method: 'GET'
      headers:
        'User-Agent': "node-dynect/0.0.0 (https://github.com/myplanetdigital/node-dynect)"
    , (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

  post: (path, content, callback) ->
    request
      uri: @query path
      method: 'POST'
      body: JSON.stringify content
      headers:
        'Content-Type': 'application/json'
        'User-Agent': "node-dynect/0.0.0 (https://github.com/myplanetdigital/node-dynect)"
    , (err, res, body) =>
      return callback(err) if err
      @errorHandle res, body, callback

module.exports = (token, credentials...) ->
  new Client(token, credentials...)
