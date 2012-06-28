# Putting together Zappa, Brunch w/ Ember, Mongoose and Sockets.

```bash
npm install -g brunch

git clone git://github.com/icholy/ember-brunch.git -b coffee

brunch new myapp -s ./ember-brunch/
```

(or 
npm install -g brunch
git clone ######
npm install .
brunch build
)

### Set up server

In server.coffee, start our server with zappajs, and serve the public folder with "@use 'static'". We also log a simple message when a client makes a socket.io connection. 

```coffee
require('zappajs') ->
  require('./server/model')(@app)

  @use 'static'

  @on connection: ->
    console.log 'Hello there! App is now connected.'
```
### The server-side model

Set up 'mongoose' to be our MongoDB adapter, define a Schema and mongoose.model in /server/model.coffee :

```coffee

model = (@app) ->

  @app.mongoose = require 'mongoose'
  @app.db = @app.mongoose.connect('mongodb://localhost/zapp_ember_database')

  @app.Schema = @app.mongoose.Schema

  @app.ContactSchema = new @app.Schema
    firstName: String
    lastName: String

  @app.Contact = @app.mongoose.model('Contact', @app.ContactSchema)

module.exports = model
```
### Create Model Utility Functions

Removing a user from the database proved to be a little tricky, so we add these helper functions in server.coffee to make dealing with the database easier.

```coffee

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
    @app.Contact.find(@q._id, (err, docs) ->
      doc.remove() for doc in docs
    )

  modelEdit = (@contact) ->
    @app.Contact.findOne(@contact._id, (err, doc) =>
      if err
        console.log err
        err
      else
        doc?.firstName = @contact.firstName
        doc?.lastName = @contact.lastName
        doc?.save((err, doc) ->
          if err
            console.log err
            err
          else
            null
          )
      )

```
### Routing server-side

Ember-data expects the json wrapped in an object with the model name, so we set up our router like so:

```coffee
  @get '/': ->
    @app.Contact.find({}, (err, docs) =>
      Contacts = {}
      @Contacts = Contacts: docs
      @send @Contacts
      )
```

Notice we use the fat arrow here so we can retain the value of 'this' in our callback.


## Extra Notes

Note: To establish a socket.io "connection", on the client side you need some code like:

```html
  <script src="/socket.io/socket.io.js"></script>
  <script>
    var socket = this.io.connect('http://localhost');
    if (socket != undefined)
      console.log("Connection established");
  </script>
```
  # An example of finding and logging users:
  #
  # userB = ->
  #   @app.Contact.findOne({ firstName: user.firstName }, (err, doc) ->
  #     if err
  #       console.log err
  #     else
  #       console.log doc
  #   )

  # userB()

  # An example of finding and deleting users from the database:
  #
  # @app.Contact.find({ firstName: 'Bob' }, (err, docs) ->
  #   if err
  #     console.log err
  #   else
  #     for doc in docs
  #       doc.remove()
  #     userB()
  # )

### All in server.coffee

If you leave everything in server.coffee, instead of using a module, you can do it like:

```coffee
  mongoose = require 'mongoose'
  db = mongoose.connect('mongodb://localhost/zapp_ember_database')

  Schema = mongoose.Schema

  ContactSchema = new Schema
    firstName: String
    lastName: String

  Contact = mongoose.model('Contact', ContactSchema)

  user = new Contact
  user.firstName = "Bob"
  user.lastName = "Bobkinnick"
  user.save()

  console.log user

  Contact.findOne({ _id: user._id }, (err, doc) ->
    doc.remove()
    )
  ```
