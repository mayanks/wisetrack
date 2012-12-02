class BlackSwan.Models.Account extends Backbone.Model
  paramRoot: 'account'

  defaults:
    src: null
    name: null
    number: null
    branch: null
    balance: null
    ac_type: null

class BlackSwan.Collections.AccountsCollection extends Backbone.Collection
  model: BlackSwan.Models.Account
  url: '/accounts'
