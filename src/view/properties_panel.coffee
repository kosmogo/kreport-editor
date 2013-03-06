# `PropertiesPanel` is a component
# which used for editing fields of an editable object.
# You can use it as standalone, with jquery extension `propertiesPanel`
class PropertiesPanel extends Cafeine.ActiveObject
  @include Cafeine.Plugin

  @jquery_plugin 'propertiesPanel'

  # As all dom component,
  # constructor empty the target element
  # and fill with own elements.
  constructor: (element) ->
    @element = $ element

    @table = $(document.createElement('table'))
    @tbody = $(document.createElement('tbody'))

    @table.append @tbody

    @element.empty().append(@table).addClass('property-panel')

  set: (target) ->
    throw new Error("target must be include ActiveObject.Editable") unless target.create_edit_form?

    form = target.create_edit_form
      per_field_update: yes
      class: ''
      #Making of the table of properties
      decoration: (label, control) ->
        tr = $(document.createElement('tr'))#.attr( class: 'prop-field' )
        td_label = $(document.createElement('th'))#.attr( class: 'prop-label')
        td_data = $(document.createElement('td'))#.attr( class: 'prop-input')
        $(control).css(width: '100%').addClass('prop-input')
        $(label).addClass('prop-label')

        td_label.append label
        td_data.append control
        tr.append([td_label, td_data])

        return tr[0]

    @tbody.empty().append form
