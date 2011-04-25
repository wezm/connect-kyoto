Store = require('connect').session.Store
kyoto = require 'kyoto-client'

###
 * Session Store Implementation:
 *
 * Every session store _must_ implement the following methods
 *
 *    - `.get(sid, callback)`
 *    - `.set(sid, session, callback)`
 *    - `.destroy(sid, callback)`
 *
 * Recommended methods include, but are not limited to:
 *
 *    - `.length(callback)`
 *    - `.clear(callback)`
###

class KyotoStore extends Store
  constructor: (options) ->
    options = options or {}
    unless options.db #and options.host and options.port
      throw new Error("db, host and port must be specified")
    Store.call this, options
    @kyoto = new kyoto.Db(options.db).open(options.host, options.port)
    # @db = options.db or 1
    this

  get: (sid, callback) ->
    @kyoto.get sid, (error, value) ->
      return callback error if error
      return callback undefined, value unless value?

      try
        callback undefined, JSON.parse(value.toString())
      catch exception
        console.log exception
        callback exception

  set: (sid, session, callback) ->
    # try {
    #   var maxAge = sess.cookie.maxAge
    #     , ttl = 'number' == typeof maxAge
    #       ? maxAge / 1000 | 0
    #       : oneDay
    #     , sess = JSON.stringify(sess);
    #   this.client.setex(sid, ttl, sess, function(){
    #     fn && fn.apply(this, arguments);
    #   });
    # } catch (err) {
    #   fn && fn(err);
    # }
    try
      maxAge = session.cookie.maxAge
      ttl = maxAge / 1000 | 0
      @kyoto.set sid, JSON.stringify(session), (error) ->
        callback()
    catch exception
      console.log exception
      callback exception

  destroy: (sid, callback) ->
    @kyoto.remove sid, (error) ->
      # Ignore the error for now.
      callback()

  length: (callback) ->
    @kyoto.status (error, info) ->
      callback info.count

  clear: (callback) ->
    @kyoto.clear (error) ->
      callback error

module.exports = KyotoStore
