
model = (@app) ->

  @app.mongoose = require 'mongoose'
  @app.db = @app.mongoose.connect('mongodb://localhost/zapp_ember_database')

  @app.Schema = @app.mongoose.Schema

  @app.ContactSchema = new @app.Schema
    firstName: String
    lastName: String

  @app.Contact = @app.mongoose.model('Contact', @app.ContactSchema)

module.exports = model