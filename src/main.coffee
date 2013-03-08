# Core object of the KReportEditor.
window.KReportEditor = class KReportEditor extends Cafeine.ActiveObject
  # Paper format constants
  @FORMATS =
    A6: ['10.5cm', '14.8cm']
    A5: ['14.8cm', '21cm']
    A4: ['21cm', '29.7cm']
    A3: ['29.7cm', '42cm']

  @KNOWN_FORMATS = ['A3', 'A4', 'A5', 'A6']

  #Recreate `KNOWN FORMATS` via `FORMATS` field.
  @UPDATE_KNOWN_FORMATS = ->
    @KNOWN_FORMATS = []
    @KNOWN_FORMATS.push k for k,v in @FORMATS

  # Menu hierarchy
  @MENUS:
    Report:
      Save: "save"
      hr1: '***'
      'Properties...': 'properties'
    Edit:
      Undo: 'undo'
      Redo: 'redo'

  @CONTEXTUAL_MENU: {}

  # Using of useful [cafeine](http://github.com/anykeyh/cafeine) class macros
  @include Cafeine.Plugin, Cafeine.Editable, Cafeine.Observable

  #   Here to deploy this class as jquery report.
  @jquery_plugin "kreport"

  # This class is observable through save action.
  @observable 'save'

  # And we set default value into fields
  margin_top: '1cm'
  margin_bottom: '1cm'
  margin_left: '1cm'
  margin_right: '1cm'
  name: 'untitled report'
  _format: 'A4'
  width: KReportEditor.FORMATS['A4'][0]
  height: KReportEditor.FORMATS['A4'][1]
  landscape: no

  # Some helper functions
  # we set a local scope var
  # for fast use them.
  cm2px = @cm2px = (cm) ->
    parseFloat(cm) * 37.795275590551181102362204724409 #28.346456692913385826771653543305

  px2cm = @px2cm = (px) ->
    #(parseFloat(px) / 28.346456692913385826771653543305).round(0.01) + 'cm'
    (parseFloat(px) / 37.795275590551181102362204724409).round(0.01) + 'cm'

  # Format attribute replace width & height with current format.
  @attr 'format',
    get: -> return @_format
    set: (value) ->
      vals = KReportEditor.FORMATS[value]
      if vals?
        @_format = value
      else
        @_format = 'A4'
        vals = KReportEditor.FORMATS[@_format]

      @width = vals[0]
      @height = vals[1]

  # Set the parameters as editables.
  @editable
    'name':
      label: 'Name'
      type: 'string'
    'format':
      label: 'Format'
      type: KReportEditor.KNOWN_FORMATS
    'landscape':
      label: 'Landscape'
      type: 'boolean'
    'margin_top':
      label: 'Margin Top (cm)'
      type: 'string'
    'margin_bottom':
      label: 'Margin Bottom (cm)'
      type: 'string'
    'margin_left':
      label: 'Margin Left some azfazfazfazf text (cm)'
      type: 'string'
    'margin_right':
      label: 'Margin Right (cm)'
      type: 'string'

  # Action callbacks.
  # We check if the action exists in the class.
  # Else we put a warning.
  when_action: (name) ->
    if @["_when_action_#{name}"]?
      @["_when_action_#{name}"]()
      return true
    else
      console.log "UNIMPLEMENTED ACTION: #{name}"
      return false

  # Here we implement actions methods.
  _when_action_save: ->
    self = this
    @properties.propertiesPanel -> @set self
    return true

  _when_action_properties:  ->
    form = @create_edit_form
      class: 'form-horizontal'
      #It's important to decorate the edit form controllers, to keep homogeneic style.
      decoration: (label, control) ->
        $(label).attr(class: 'control-label')
        control_wrapper = $(document.createElement('div')).attr(class: 'controls')
        control_wrapper.append(control)
        group_wrapper = $(document.createElement('div')).attr(class: 'control-group')
        group_wrapper.append([label, control_wrapper])

        return group_wrapper[0]

    @show_dialog "Document properties",
      content: form
      buttons:
        "Apply":
          class: "btn-primary"
          click: =>
            form.apply_to_object()
            @hide_dialog()
        "Cancel":
          click: =>
            @hide_dialog()

  # This will generate the menu bar according to the hierarchy into MENUS constant.
  # Sample architecture:
  #
  #      <div class="navbar">
  #       <div class="navbar-inner">
  #         <a class="brand" href="#">KReport</a>
  #         <ul class="nav">
  #           <li class="dropdown">
  #             <a class="dropdown-toggle" data-toggle="dropdown" href="#">File<b class="caret"></b></a>
  #             <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
  #               <li><a tabindex="-1" href="#">Load</a></li>
  #               <li><a tabindex="-1" href="#">Save</a></li>
  #             </ul>
  #           </li>
  #         </ul>
  #       </div>
  #      </div>
  #
  generate_menu_bar: ->
    @navbar = $(document.createElement('div')).attr(class: 'navbar kreport-navbar')

    navbar_inner = $(document.createElement('div')).attr(class: 'navbar-inner')

    @navbar.append(navbar_inner)

    brand = $(document.createElement('a')).attr({ class: 'brand', href: '#' }).text('KReport')
    nav = $(document.createElement('ul')).attr(class: 'nav')

    $(navbar_inner).append([brand, nav])

    for k,v of KReportEditor.MENUS
      dd = $(document.createElement('li')).attr(class: 'dropdown')
      nav.append dd
      dd.append $(document.createElement('a')).attr(class: 'dropdown-toggle', 'data-toggle': 'dropdown', 'href': '#').html(k + '<b class="caret"></b>')
      dd_ul = $(document.createElement('ul')).attr(class: 'dropdown-menu', role:'menu', 'aria-labelledby': 'dLabel')
      dd.append dd_ul
      if typeof v is 'object'
        for k2,v2 of v
          do(k=k, v=v, k2=k2, v2=v2) =>
            #  Special case when we want a divider.
            if v2 is '***'
              dd_li = $(document.createElement('li')).attr(class: 'divider')
              dd_ul.append dd_li
            else
              #
              #  We put a `do => =>` because we need to output a function which return a function, to keep v2 as internal to function
              #  FYI it can be translated `do => return => ...` which is better to read?.
              #
              dd_li = $(document.createElement('li'))
              .append(
                $(document.createElement('a')).attr(tabindex: '-1', href: '#').click( do => => @when_action(v2)  ).text(k2)
              )
              dd_ul.append dd_li

    return @navbar

  resize: ->
    @content.css height: @content.height() -  @navbar.height()

  #  Dialog handling.
  init_dialog: ->
    @dialog_title = $(document.createElement('h3'))
    @dialog_header = $(document.createElement('div')).attr(class: 'modal-header').append([
      $(document.createElement('button')).attr(type: 'button', class: 'close', 'data-dismiss':'modal', 'aria-hidden':'true').html("&times;")
      @dialog_title
    ])

    @dialog_content = $(document.createElement('div')).attr(class: 'modal-body')
    @dialog_footer = $(document.createElement('div')).attr(class: 'modal-footer')

    @dialog = $(document.createElement('div')).attr(class: 'modal fade').css(display: 'none')
    @dialog.append [@dialog_header, @dialog_content, @dialog_footer]
    return @dialog

  #Dialog rendering
  show_dialog: (title, opts={}) ->
    @dialog_title.text(title)
    @dialog.css(display: 'block').modal()

    opts = Cafeine.merge {
      content: ''
      buttons: {}
    }, opts

    @dialog_content.empty().append(opts.content)

    @dialog_footer.empty()

    for name,parameters of opts.buttons
      button = $(document.createElement('a')).attr(class: "btn #{parameters.class ? ''}").click( parameters.click ? -> ).text(name)
      @dialog_footer.append(button)

  hide_dialog: ->
    @dialog.modal('hide')

  add_component: (clazz) ->
    element = $(document.createElement('div')).attr(class: 'kreport-component')
    component = Cafeine.invoke(clazz, [element, this])
    @page_content.append element

  # Refresh the size parameters of the page.
  refresh_page: ->
    inner_width = px2cm(cm2px(@width) - (cm2px(@margin_left)+cm2px(@margin_right)))
    inner_height = px2cm(cm2px(@height) - (cm2px(@margin_top)+cm2px(@margin_bottom)))

    width = @width
    height = @height

    #We swap width and height if it's landscape
    if @landscape
      [inner_width, inner_height, width, height] = [inner_height, inner_width, height, width]

    @page = $("#kreport-page").css
      width: width
      height: height

    @page_content.css
      'margin-left':   @margin_left
      'margin-right':  @margin_right
      'margin-top':    @margin_top
      'margin-bottom': @margin_bottom
      width: inner_width,
      height: inner_height


  #This generate a bootstrap compliant dropdown menu, with items writtend into a javascript object.
  generate_sub_menu: (obj) ->
    ul = $(document.createElement("ul")).attr(class: "dropdown-menu", role:"menu", "aria-labelledby": "dLabel")

    for k,v of obj
      li = $(document.createElement("li"))
      if typeof v is 'undefined'
        li.addClass('divider')
      else if typeof v in ['function', 'string']
        in_link = $(document.createElement("a")).attr(tabindex:'-1', href:'#').text(k)
        do(k=k, v=v, in_link=in_link, self=this) ->
          in_link.on 'click', ->
            if typeof v is 'function'
              v.call(self)
            else
              self.when_action(v)
        li.append in_link
      else
        li.addClass('dropdown-submenu')
        li.append $(document.createElement("a")).attr(tabindex:'-1', href:'#').text(k)
        li.append @generate_sub_menu(v)

      ul.append li

    return ul

  generate_contextual_menu: (target=KReportEditor.CONTEXTUAL_MENU) ->
    @contextual_menu ?= $(document.createElement('div')).attr id: "kreport-document-context-menu"
    @contextual_menu.empty()

    ul = @generate_sub_menu(target)

    @contextual_menu.append ul

  #Select an HTML element.
  select: (selectable) ->
    $(".selected", @element).removeClass("selected")
    $(selectable).addClass("selected")

  constructor: (element) ->
    # We build the main element structure
    @element = $ element
    @element.empty()
    @element.append(@generate_menu_bar())

    @content = $(document.createElement('div')).attr(id: 'kreport-content')
    @element.append(@content)

    @canvas = $(document.createElement('div')).attr(id: 'kreport-canvas')
    @toolbox = $(document.createElement('div')).attr(id: 'kreport-toolbox')

    #Create mighty properties panel! Easy isn't?
    #see (property panel doc)[view/properties_panel.html]
    @properties = $(document.createElement('div')).attr(id: 'kreport-properties-panel')
    @properties.propertiesPanel()

    @toolbox.append(@properties)

    @content.append [@toolbox, @canvas]
    @element.append @content

    @page = $(document.createElement('div')).attr(id: 'kreport-page', 'data-target':"#kreport-document-context-menu" )
    @page_content =  $(document.createElement('div')).attr(id: 'kreport-page-content')
    @element.append @init_dialog()

    @page.append @page_content
    @canvas.append @page

    @element.append @generate_contextual_menu()

    #contextual menu preparation
    self = this
    @page.contextmenu()
    @page.data('contextmenu', KReportEditor.CONTEXTUAL_MENU)
    # We check for subcontextual menu
    @page
    .on 'context', (evt) ->
      item_path = [evt.mouseTarget]
      #We select the best context menu for this target.
      $(evt.mouseTarget).parents().each -> item_path.push this
      for x in item_path
        menu = $(x).data('contextmenu')
        if typeof menu is 'object'
          self.generate_contextual_menu(menu)
          break
        else if typeof menu is 'function'
          self.generate_contextual_menu(menu())
          break
    # When we click on page, we select the page properties
    .on 'click', (evt) ->
      self.select self.page
      self.properties.propertiesPanel('set', self)

    #  We prepare the bootstrap dropdown plugins
    $('.dropdown-toggle').dropdown()

    #  Call resize once to keep each elements up...
    @resize()

    #  ... And call it every time when window resize.
    $(window).resize => @resize

    # We refresh also the page properties size every time we update the editables fields.
    @when_edition_done @refresh_page

