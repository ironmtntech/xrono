class Ticket extends Spine.Model
  @configure "Ticket", "priority", "name", "description", "created_at", "updated_at", "guid", "state"
  @extend Spine.Model.Ajax

window.Ticket = Ticket
