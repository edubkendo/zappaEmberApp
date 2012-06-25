require('zappajs') ->

  mongoose = require 'mongoose'
  db = mongoose.connect('mongodb://localhost/zapp_ember_database')

  Schema = mongoose.Schema

  ContactSchema = new Schema
    firstName: String
    lastName: String

  Contact = mongoose.model('Contact', ContactSchema)


  @use 'static'