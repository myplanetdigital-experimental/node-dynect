qs = require 'querystring'
request = require 'request'

auth = module.exports =
  modes:
    cli: 0

  config: (options) ->
    if options.customer and options.username and options.password
      @mode = @modes.cli
    else
      throw new Error('No working mode recognized')
    @options = options
    return this

  login: (callback) ->
    if @mode == @modes.cli
      options =
        url: url.parse "https://api.dynect.net/REST/Session/"
        method: 'POST'
        body: qs.stringify
          customer_name: @options.customer
          user_name: @options.username
          password: @options.password
        headers:
          'Content-Type': 'application/json'
          'User-Agent': 'node-dynect/0.0.0 (https://github.com/myplanetdigital/node-dynect) terminal/0.0'

      request options, (err, res, body) ->
        if err?
          callback err
        else
          try
            body = JSON.parse body
          catch err
            callback new Error('Unable to parse body')
          if res.statusCode is 401 then callback(new Error(body.message)) else callback(null, body.version, body.token)
    else
      callback new Error('No working mode defined')
