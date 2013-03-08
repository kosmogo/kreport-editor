@KReport ?= {}

class @KReport.Component extends Cafeine.ActiveObject
  _OID = 0
  OID = -> _OID++

  height: 0

  remove: ->
    @element.remove()

  constructor: (@element, @report) ->
    @_oid = OID()
    @element.attr(id: "kreport-#{@constructor.INFO.id}-#{@_oid}", class: 'kreport-component')
    @element.data('contextmenu', (evt) => @sub_menu?(evt) )

    self = this
    @element.on 'click', (evt) ->
      self.report.select(element)
      self.report.properties.propertiesPanel -> @set self
      evt.stopPropagation()

    @title = $(document.createElement('div'))
    .attr(class: 'kreport-component-title label label-info')
    .html(@constructor.INFO.name + ' <a href="#" class="remove"><i class="icon-remove icon-white"></i></a>')

    @content = $(document.createElement('div')).attr(class: 'kreport-component-content')

    @element.append [@title, @content]

    @title.find('a.remove').on 'click', =>
      @remove() if confirm('Are you sure?')


  #This must be refined by subclass
  sub_menu: -> { }
