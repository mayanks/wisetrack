BlackSwan.Views.Accounts ||= {}

class BlackSwan.Views.Accounts.IndexView extends Backbone.View
  template: JST["backbone/templates/accounts/index"]

  events:
    "click a.new" : "new"

  initialize: () ->
    @options.accounts.bind('reset', @addAll)

  new: () ->
    alert('hello world')
    view = new BlackSwan.Views.Accounts.NewView(collection: new BlackSwan.Collections.AccountsCollection())
    @$("tbody").append(view.render().el)
    return false		
		
  addAll: () =>
    @options.accounts.each(@addOne)

  addOne: (account) =>
    view = new BlackSwan.Views.Accounts.AccountView({model : account})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(accounts: @options.accounts.toJSON() ))
    @addAll()

    return this
