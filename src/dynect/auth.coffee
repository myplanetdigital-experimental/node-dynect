request = require 'request'
url = require 'url'
qs = require 'querystring'

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
      params =
        customer_name: @options.customer
        user_name: @options.username
        password: @options.password

      uri = 'https://api.dynect.net/REST/Session?'
      uri+= qs.stringify params

      options =
        url: url.parse uri
        method: 'POST'
        headers:
          'Content-Type': 'application/json'
          'User-Agent': 'node-dynect/0.0.0 (https://github.com/myplanetdigital/node-dynect) terminal/0.0'

      request options, (err, res, body) ->
        if err?
          callback err
        else
          try
            console.log body
            body = JSON.parse body
          catch err
            callback new Error('Unable to parse body')

          if res.statusCode is 400
            callback new Error(JSON.stringify body.msgs)
          else
            callback(null, body.job_id, body.data.token)
    else
      callback new Error('No working mode defined')
