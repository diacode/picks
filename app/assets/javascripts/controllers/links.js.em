DiacodePicks.LinksController = Ember.ArrayController.extend
  itemController: 'linksItem'
  selected: Ember.computed.filterBy('[]', 'isChecked', true)
  newLinkUrl: ''
  actions:
    addLink: ->
      newLink = @store.createRecord('link', {
        url: @get('newLinkUrl')
      })

      newLink.save().then (=>
        @set('newLinkUrl', "")
      ), -> 
        newLink.rollback()
        alert('Error!')
    deleteSelection: ->
      selectedItems = @get('selected')
      selectedItems.forEach (item) ->
        linkObject = item.get('content')
        linkObject.destroyRecord()