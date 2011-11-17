class Ticket extends Spine.Model
  @configure "Ticket", "priority", "name", "description", "created_at", "updated_at", "guid", "state", "transition_event", "list_transition_events"
  @extend Spine.Model.Ajax

  transition_to: (state) ->
    @transition_event = state
    @save()


window.Ticket = Ticket
