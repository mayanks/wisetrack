class BlackSwan.Routers.AccountsRouter extends Backbone.Router
  initialize: (options) ->
    @accounts = new BlackSwan.Collections.AccountsCollection()
    @accounts.reset options.accounts

  routes:
    "new"      : "newAccount"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newAccount: ->
    @view = new BlackSwan.Views.Accounts.NewView(collection: @accounts)
    #$("#accounts").html(@view.render().el)
    $("#accounts table tbody").append(@view.render().el)

  index: ->
    @view = new BlackSwan.Views.Accounts.IndexView(accounts: @accounts)
    $("#accounts").html(@view.render().el)

  show: (id) ->
    account = @accounts.get(id)

    @view = new BlackSwan.Views.Accounts.ShowView(model: account)
    $("#accounts").html(@view.render().el)

  edit: (id) ->
    account = @accounts.get(id)

    @view = new BlackSwan.Views.Accounts.EditView(model: account)
    $("#accounts").html(@view.render().el)
