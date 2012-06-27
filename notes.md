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
### Function to easily delete a model from the database.

Removing a user from the database proved to be a little tricky, so this is a helper function in server.coffee

```coffee

  modelDel = (@q) ->
    @app.Contact.find(@q, (err, docs) ->
      doc.remove() for doc in docs
    )

```




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
