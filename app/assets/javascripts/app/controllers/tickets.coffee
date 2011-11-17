$ = jQuery

class TicketsListItem extends Spine.Controller
  tag: 'li'

  constructor: ->
    super

  render: ->
    @log(this)
    @html $.tmpl('app/views/tickets/list_item', @item)
    @item.list_transition_events.map (e) =>
      @$('a.event.' + e).on('click', () =>
        @item.transition_event = e
        @item.save()
      )
    @log('why')
    # At present, this won't work without that log statement.
    # I do not understand :(
  
class TicketsListLane extends Spine.Controller
  elements:
    'ul': 'ul'

  constructor: ->
    super
    @render()

  render: =>
    @replace $.tmpl('app/views/tickets/list_lane')
    @items.map (item) =>
      @ul.append(new TicketsListItem( { item: item } ).render().el)

class TicketsList extends Spine.Controller
  elements:
    '.fridge': 'fridge',
    '.development': 'development',
    '.peer_review': 'peer_review',
    '.user_acceptance': 'user_acceptance',
    '.archived': 'archived'
  
  constructor: ->
    super
    @states = ['fridge', 'development', 'peer_review', 'user_acceptance', 'archived']
    Ticket.bind('refresh change', @render)
    
  render: =>
    @html ''
    @states.map (state) =>
      @append(new TicketsListLane(items: Ticket.findAllByAttribute('state', state), state: state))
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/projects', @project_id, 'tickets', item.id

class Tickets extends Spine.Controller
  elements:
    '.lanes': 'lanes'

  constructor: ->
    super
    @list = new TicketsList(el: @lanes, project_id: @project_id)
    
    new Spine.Manager(@list)
    
    @routes
      '/projects/:project_id/tickets': (params) ->
        @list.active(params)

    @navigate '/projects', @project_id, 'tickets'
        
    # Only setup routes once tickets have loaded
    Ticket.bind 'refresh', ->
      Spine.Route.setup()

    Ticket.fetch({ project_id: @project_id })
  
window.Tickets = Tickets
