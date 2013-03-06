class PropertiesPanel extends Cafeine.ActiveObject
  @include Cafeine.Plugin

  @jquery_plugin 'propertiesPanel'

  #Set an object into this property panel
  constructor: (element) ->
    @element = $ element

    @table = $(document.createElement('table'))
    @tbody = $(document.createElement('tbody'))

    @table.append @tbody

    @element.empty().append(@table).addClass('property-panel')

  set: (target) ->
    throw new Error("target must be editable") unless target.create_edit_form?

    form = target.create_edit_form
      per_field_update: yes
      class: ''
      #Making of the table
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
    console.log "Form = ", form
    @tbody.empty().append form
