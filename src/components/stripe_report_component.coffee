@KReport ?= {}

class @KReport.StripeReportItem extends Cafeine.ActiveObject
  @include Cafeine.Editable

  content: ''
  height: '1cm'
  width: '2cm'

  @editable
    content:
      type: 'text'
      label: 'Content'
    height:
      type: 'number'
      label: 'Height'
    width:
      type: 'number'
      label: 'Width'
    x:
      type: 'number'
      label: 'Left Offset'
    y:
      type: 'number'
      label: 'Top Offset'
    style:
      type: -> ['1', '2', '3']
      label: 'Font style'

  remove: -> alert('todo: remove')

  refresh_element: ->
    @element.css
      width: @width
      height: @height

  contextmenu: ->
    'Remove item': => @remove()

  constructor: (@element, @band)->
    @report = band.report
    @element.attr(class: 'stripereport-item')
    @element.data('contextmenu', @contextmenu())
    @band.element.append @element

    @refresh_element()


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
      alert('todo: remove')

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

    $('html')
    .on 'mouseup', (evt) ->
      if resize_started
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

    @content = $(document.createElement('div'))

    #Create a header for edit mode. This will popup whenever mouse goes in.
    @header = $(document.createElement('div')).attr(class: 'stripereport-stripe-header label label-inverse')

    #The resize zone
    @resize_bottom = $(document.createElement('div')).attr(class: 'stripereport-stripe-resize')

    @element.append [@header, @content, @resize_bottom]

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




class @KReport.StripeReportComponent extends KReport.Component
  _OID = 0
  OID = () -> _OID++

  # Meta informations about this component (for save)
  @INFO:
    id: 'stripreport'
    name: 'Strip Report'
    version: '1.0'

  @include Cafeine.Container, Cafeine.Editable

  @editable
    height:
      type: 'number'
      label: 'Height'

  @contains('stripe') ->
    @validates @instance_of KReport.StripeReportStripe

  create_stripe: ->
    stripe_element = $(document.createElement('div'))
    stripe = new KReport.StripeReportStripe(stripe_element, this)
    @add_stripe stripe
    @content.append stripe_element
    # Triggering click to simulate the selection of the new stripe.
    stripe_element.trigger('click')


  sub_menu: ->
    "New...":
      Band: =>
        @create_stripe()

  constructor: (element, report) ->
    super(element, report)

#We plug to the contextual menu of the document the new report
Cafeine.merge KReportEditor.CONTEXTUAL_MENU,
  "New...":
    "Stripe Report": ->
      @add_component(KReport.StripeReportComponent)

Cafeine.merge KReportEditor.MENUS,
  "Add":
    "Stripe Report": ->
      @add_component(KReport.StripeReportComponent)