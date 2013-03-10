@KReport ?= {}

class @KReport.StripeReportItem extends Cafeine.ActiveObject
  @include Cafeine.Editable

  # Constants describes used offset of arrays
  # which store coordinates
  X = 0
  Y = 1
  LEFT = 0
  TOP = 1
  WIDTH = 2
  HEIGHT = 3

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

  prepare_handling: ->
    self = this

    # We prepare the event on every anchors + element itself.
    anchors = [@element]
    anchors.push v for k,v of @anchors

    #some function scope values...
    has_started_drag = false
    start_offset = [0,0]
    start_coords = [0,0,0,0]
    drag_anchor = 'center'

    for anchor in anchors
      anchor.on 'mousedown', (evt) ->
        has_started_drag = yes

        start_offset = [
          evt.pageX
          evt.pageY
        ]

        start_coords = [
          self.element.position().left
          self.element.position().top
          self.element.width()
          self.element.height()
        ]

        # We check the class of each anchor. It's used to get the right behaviour
        # function of the anchor selected.
        drag_anchor = $(this).attr('class').split(' ').filter((c) -> c.match /^anchor-/)

        if drag_anchor.length > 0
          # We get the anchor target with remove the 7 first characters (== "anchor-")
          drag_anchor = drag_anchor[0]
          drag_anchor = drag_anchor[7..drag_anchor.length]
        else
          #If not class, it's the  element itself.
          drag_anchor = 'x'

        console.log "target = ", drag_anchor
        console.log "start = ", start_coords

        evt.stopPropagation();

    $('body')
    .on 'mousemove', (evt) ->
      return unless has_started_drag

      decal = [
        start_offset[X]-evt.pageX
        start_offset[Y]-evt.pageY
      ]

      coords = [].concat start_coords

      if ~drag_anchor.indexOf('x')
        coords[LEFT] -= decal[X]
        coords[TOP] -= decal[Y]
      else
        if ~drag_anchor.indexOf('n')
            coords[TOP] -= decal[Y]
            coords[HEIGHT] += decal[Y]
        else if ~drag_anchor.indexOf('s')
            coords[HEIGHT] -= decal[Y]

        if ~drag_anchor.indexOf('e')
            coords[WIDTH] -= decal[X]
        else if ~drag_anchor.indexOf('w')
            coords[LEFT] -= decal[X]
            coords[WIDTH] += decal[X]

      self.element.css
        left: coords[LEFT]
        top: coords[TOP]
        width: coords[WIDTH]
        height: coords[HEIGHT]
    .on 'mouseup', ->
      has_started_drag = no

  constructor: (@element, @band)->
    @report = band.report
    @element.attr(class: 'stripereport-item')
    @element.data('contextmenu', @contextmenu())
    @band.element.append @element

    #We create the anchors (handlers) for resizing
    @anchors = {}

    ['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw'].each (pos) =>
      anchor = $(document.createElement('div')).attr(class: "stripe-item anchor anchor-#{pos}")
      @anchors[pos] = anchor
      @element.append(anchor)

    @prepare_handling()

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