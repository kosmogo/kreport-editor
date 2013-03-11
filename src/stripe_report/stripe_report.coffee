@KReport ?= {}

# # StripeReportComponent #
#
# This is the first component build for KReport.
# Stripe report component provides strip render of data.
# We can group data by value, and render header/footer
# for theses groups.
#
#
class @KReport.StripeReportComponent extends KReport.Component
  # Private field unique id
  # used to generate... unique id.
  _OID = 0
  OID = () -> _OID++

  # Meta informations
  # -----------------
  #
  # Here is a block important
  # for components.
  # This block which provides informations
  # about save of the component into json.
  @INFO:
    id: 'stripreport'
    name: 'Strip Report'
    version: '1.0'

  # Editable properties of the component
  @include Cafeine.Editable
  @editable
    height:
      type: 'number'
      label: 'Height'

  # Manage contextual actions
  # when right clicked into the space of the component.
  sub_menu: ->
    "Add":
      Band: =>
        @create_stripe()

  # The component contains stripes.
  # Strip are a repeatitive rendering of data
  # which can be header or footer of a group
  # (and repeat every time the value of the group variable changed.).
  # Strip can also be a data strip, which repeat for each item of the
  # data model.
  @include Cafeine.Container

  @contains('stripe') ->
    @validates @instance_of KReport.StripeReportStripe

  create_stripe: ->
    stripe_element = $(document.createElement('div'))
    stripe = new KReport.StripeReportStripe(stripe_element, this)
    @add_stripe stripe
    @content.append stripe_element
    # Triggering click to simulate the selection of the new stripe.
    stripe_element.trigger('click')

  constructor: (element, report) ->
    super(element, report)

# Plug the component
# ------------------
#
# We merge current kreport menus and actions
# with the actions of loading the component.
#
Cafeine.merge KReportEditor.CONTEXTUAL_MENU,
  "Add":
    "Stripe Report": ->
      @add_component(KReport.StripeReportComponent)

Cafeine.merge KReportEditor.MENUS,
  "Add":
    "Stripe Report": ->
      @add_component(KReport.StripeReportComponent)