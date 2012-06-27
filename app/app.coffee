# Application bootstrapper

App = Em.Application.create
    Views       : Em.Namespace.create()
    Models      : Em.Namespace.create()
    Controllers : Em.Namespace.create()

App.store = DS.Store.create {
  revision: 4
  adapter: DS.RESTAdapter.create { bulkCommit: false }
}

module.exports = App
