@KReport ?= {}

#This is a band
class @KReport.StripeReportStripe extends Cafeine.ActiveObject
  @include Cafeine.Container, Cafeine.Editable

  @contains('items') ->
    @validates @instance_of KReport.StripeReportItem

  position: 'data'
  group_for: ''
  height: '1cm'

  @editable
    height:
      type: 'number'
      label: 'Height'
    group_for:
      type: 'string'
      label: 'Group'
    position:
      type: ['header', 'footer', 'data']

  contextmenu: ->
    "Add field": => @add_field()
    #Strip every time a key return "undefined"
    "*": undefined
    "Add stripe above": => @add_stripe('before')
    "Add stripe below": => @add_stripe('after')
    "**": undefined
    "Remove stripe": => @remove()
    "Edit stripe...": => @edit()

  #This will create a stripe before or after current stripe
  add_stripe: (position) ->
    stripe_element = $(document.createElement('div'))
    stripe = new KReport.StripeReportStripe(stripe_element, @parent)
    @parent.add_stripe stripe
    #call function before/after of jquery selector.
    @element[position] stripe_element

  #Add textual field to this band.
  add_field: ->
    field = new KReport.StripeReportItem($(document.createElement('div')), this)
    @content.append field.element

  edit: ->
    self = this
    self.parent.report.properties.propertiesPanel -> @set self

  remove: ->
    if confirm('Are you sure?')
      @parent.remove_stripe this
      @element.remove()

  refresh_element: ->
    @element.css height: @height
    if @position is 'data'
      @header.html("data &infin; <small>(#{@height})</small>")
    else if @position is 'header'
      @header.html("&#9650; #{@group_for} <small>(#{@height})</small>")
    else
      @header.html("&#9660; #{@group_for} <small>(#{@height})</small>")

  prepare_resize_handling: ->
    resize_offset = 0
    resize_started = false
    start_size = 0
    self = this

    @resize_bottom.on 'mousedown', (evt) ->
      resize_offset = evt.pageY
      resize_started = true
      start_size = KReportEditor.cm2px(self.height)

    $('body')
    .on 'mouseup', (evt) ->
      console.log "mouseup?!"
      if resize_started
        console.log "mouse up?"
        resize_started = false
        resize_diff =  evt.pageY - resize_offset
    .on 'mousemove', (evt) ->
      if resize_started
        resize_diff =  evt.pageY - resize_offset
        self.height = KReportEditor.px2cm( start_size + resize_diff)
        self.refresh_element()


  constructor: (@element, @parent) ->
    @element.attr(class: 'stripereport-stripe')
    @element.data('contextmenu', @contextmenu())

    @content = $(document.createElement('div')).attr(class: 'stripereport-stripe-content')

    #Create a header for edit mode. This will popup whenever mouse goes in.
    @header = $(document.createElement('div')).attr(class: 'stripereport-stripe-header label label-inverse')

    #The resize zone
    @resize_bottom = $(document.createElement('div')).attr(class: 'stripereport-stripe-resize')

    @element.append [@resize_bottom, @header, @content]

    @prepare_resize_handling()

    self = this


    #Select element on click
    @element.on 'click', (evt) ->
      console.log self
      self.parent.report.select(self.element)
      self.parent.report.properties.propertiesPanel -> @set self
      evt.stopPropagation()

    #Refresh element every time with change a property
    @when_edition_done => @refresh_element()

    #Refresh element now
    @refresh_element()
