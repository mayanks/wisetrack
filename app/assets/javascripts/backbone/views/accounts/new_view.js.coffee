BlackSwan.Views.Accounts ||= {}

class BlackSwan.Views.Accounts.NewView extends Backbone.View
  template: JST["backbone/templates/accounts/new"]

  events:
    "click #create-account-button": "save"

  tagName: "tr"
  id: "new-account"
	
  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

	
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (account) =>
        @model = account
        view = new BlackSwan.Views.Accounts.AccountView({model : @model})
        $(@el).parent().append(view.render().el)
        $(@el).remove()
        #window.location.hash = "/#{@model.id}"

      error: (account, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    #this.$("#new-account").backboneLink(@model)
    $(@el).backboneLink(@model)

    return this
