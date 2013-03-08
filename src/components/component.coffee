@KReport ?= {}

class @KReport.Component extends Cafeine.ActiveObject
  _OID = 0
  OID = -> _OID++

  height: 0

  constructor: (@element, @report) ->
    @_oid = OID()
    @element.attr(id: "kreport-#{@constructor.INFO.id}-#{@_oid}")
    @element.data('contextmenu', (evt) => @sub_menu?(evt) )

    self = this
    @element.on 'click', (evt) ->
      self.report.select(element)
      self.report.properties.propertiesPanel -> @set self
      evt.stopPropagation()

  #This must be refined by subclass
  sub_menu: -> { }
