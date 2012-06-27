require('zappajs') ->
  require('./server/model')(@app)

  @use 'static'

  # Model utility functions to make implementing CRUD easier

  modelAdd = (@contact) ->
    newContact = new @app.Contact
    newContact.firstName = @contact.firstName
    newContact.lastName = @contact.lastName
    newContact.save((err,doc) ->
      if err
        console.log err
        return err
      else
        return null
      )

  modelDel = (@q) ->
    @app.Contact.find(@q, (err, docs) ->
      doc.remove() for doc in docs
    )

  modelEdit = (@contact) ->
    @app.Contact.findById(@contact._id, (err, docs) ->
      if err
        console.log err
        err
      else
        doc.firstName = @contact.firstName
        doc.lastName = @contact.lastName
        doc.save((err, doc) ->
          if err
            console.log err
            err
          else
            null
          )
      )

  user = {}
  user.firstName = "Bob"
  user.lastName = "Bobb"
  modelAdd user


  # Router
  # @get '/' : ->
  #   @Contacts = @app.Contact.find()

  @on connection: ->
    console.log 'Hello there! App is now connected.'