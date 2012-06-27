require('zappajs') ->
  require('./server/model')(@app)

  @use 'static'

  modelDel = (@q) ->
    @app.Contact.find(@q, (err, docs) ->
      doc.remove() for doc in docs
    )

  # Router
  # @get '/' : ->
  #   @Contacts = @app.Contact.find()

  @on connection: ->
    console.log 'Hello there! App is now connected.'