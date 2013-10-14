class ARecord

  constructor: (@zone, @fqdn, @client) ->
    get: (record_id, callback) ->
      @client.get "ARecord/#{@zone}/#{@fqdn}/#{record_id}", (err, s, b) ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('ARecord get error')) else cb null, b

    list: (callback) ->
      @client.get "ARecord/#{@zone}/#{@fqdn}", (err, s, b) ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('ARecord list error')) else cb null, b

    create: (rdata) ->
      @client.post "ARecord/#{@zone}/#{@fqdn}", rdata, (err, s, b) ->
        return cb(err) if err
        if s isnt 200 then cb(new Error('ARecord create error')) else cb null, b
