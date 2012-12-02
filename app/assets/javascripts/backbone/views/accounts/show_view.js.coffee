BlackSwan.Views.Accounts ||= {}

class BlackSwan.Views.Accounts.ShowView extends Backbone.View
  template: JST["backbone/templates/accounts/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
