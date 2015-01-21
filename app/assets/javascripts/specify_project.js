// when client is changed, populate the projects
$("#specify_client_id").change(function(){
  debugger;
  var me = $("#specify_project_id");
  me.children().remove();
  me.append( new Option("Select a project","") )
  if(this.value != "") {
    $.get("/dashboard/client", { id: this.value }, function(data){
      $.each(data, function(i, project){
        me.append( new Option(project.name, project.id) )
      });
    }, "json");
  }
});

// when project is changed, populate the tickets
$("#specify_project_id").change(function(){
  if(this.value != "") {
    $('#in_dash_ticketboard').load('dashboard/base/give_me_the_tickets', { id: this.value }, ticket_board_ready_function());
  }
});

