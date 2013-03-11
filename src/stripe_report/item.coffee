@KReport ?= {}

# # StripReport Item #
#
#
# An item is a textual block of data
# used to render static or dynamic text.
#
# Here we set handler for edit the item.
class @KReport.StripeReportItem extends Cafeine.ActiveObject
  # Private constants
  # -----------------
  #
  # We store in private constants
  # the offsets of arrays
  # which store coordinates
  X = 0
  Y = 1
  LEFT = 0
  TOP = 1
  WIDTH = 2
  HEIGHT = 3

  # Edition & Properties
  # --------------------
  #
  # Editables properties of the `StripeReportItem`:
  # - content is the textual content to render
  # - style is the current selected style
  # - height/width/left/top Absolute position of the block into his parent stripe
  @include Cafeine.Editable

  content: ''
  height: '0.5cm'
  width: '1.5cm'
  top: '0.5cm'
  left: '0.5cm'
  text: ''

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
    left:
      type: 'number'
      label: 'Left Offset'
    top:
      type: 'number'
      label: 'Top Offset'
    style:
      type: -> ['Title', 'Content Header', 'Content Small']
      label: 'Font style'

  remove: ->
    alert('todo: remove')

  # We reload all visible property to the editor view.
  refresh_element: ->
    @element.css
      width: @width
      height: @height

  contextmenu: ->
    'Remove item': => @remove()


  # Prepare the handling
  # --------------------
  #
  # Set the events on every anchors of the element.
  # The element has nine anchors: positional anchors (nsew)
  # and it's itself an anchor (for dragging it.)
  prepare_handling: ->
    self = this

    # We prepare the event on every anchors + element itself.
    # We use also some inner scope data used to store
    # variables during drag&drop state.
    anchors = [@element]
    anchors.push v for k,v of @anchors

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

        # Retrieve the anchor
        # ------------------
        #
        # We check the class of each anchor. It's used to get the right behaviour
        # function of the anchor selected.
        drag_anchor = $(this).attr('class').split(' ').filter((c) -> c.match /^anchor-/)

        # We get the anchor target with remove the 7 first characters (== "anchor-")
        # if a class is found.
        # Otherwise, it's mean that drag_anchor is the element itself.
        # `drag_anchor` value would be in `[n, ne, nw, e, w, se, sw, s, x]`
        # where `x` means *self element*
        if drag_anchor.length > 0
          drag_anchor = drag_anchor[0]
          drag_anchor = drag_anchor[7..drag_anchor.length]
        else
          drag_anchor = 'x'

        evt.stopPropagation();

    # Handling the anchors
    # --------------------
    # Here we handle the anchors
    # function of the value of `drag_anchor` variable.
    #
    # **Small trick!**
    #
    # *Operator `~` means negative bitwise.*
    #
    # *So, `~(-1) == 0 == false`*
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

  # Build the object
  # ----------------
  #
  # Create DOM of the instance.
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