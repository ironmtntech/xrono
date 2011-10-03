/$(document).ready(ready_function());
$( ".concealed" ).hide();
function ready_function() {

  $('.bucket ul li').each(function(){
    makeItemDraggable($(this));
  });

  $('.bucket ul li').live('dblclick', function(){
    $.ajax({
      url: '/tickets/'+this.id+'/ticket_detail',
      success: function(data) {
        $(".effect").show().html(data);
        //$.filter(function (index) {
          //return $(this).attr("id") == ".effect #header";
        //});
        $(".effect #header").css("display", "none");
        $(".effect #footer").css("display", "none");
      }
    });

    //$.get('/tickets/'+this.id+'/ticket_detail', function(data) {
      //$(".effect").show().html(data);
      //$( ".div_effect #header" ).hide();
    //});
    $( ".bucket" ).hide();
  });

  $( ".effect" ).click(function(){
    $( ".effect" ).css("display", "none");      
    $( ".bucket" ).show();
  });
    
  $('#fridge_ul').droppable({
    accept: "",
    drop: function(event, ui){
      var new_element = $("<li></li>").text(ui.draggable.text()).attr("id",ui.draggable.attr("id")).appendTo(this);
      new_element.addClass("fridge_li")
      makeItemDraggable(new_element);
      var id = ui.draggable.attr("id")
      reverseState(id);
      ui.draggable.remove();
    }
  })
  $('#development_ul').droppable({
    accept: ".fridge_li, .peer_review_li, .user_acceptance_li",
    activeClass: "ui-state-hover",
    drop: function(event, ui){
      var id = ui.draggable.attr("id")
      if (ui.draggable.hasClass("fridge_li")) {
        advanceState(id);
      } else {
        reverseState(id);
      }
      var new_element = $("<li></li>").text(ui.draggable.text()).attr("id",ui.draggable.attr("id")).appendTo(this);
      new_element.addClass("development_li")
      new_element.html(ui.draggable.html());
      makeItemDraggable(new_element);
      
      ui.draggable.remove();
      }
  });
  $('#peer_review_ul').droppable({
    accept: ".development_li",
    activeClass: "ui-state-hover",
    drop: function(event, ui){
      var id = ui.draggable.attr("id")
      advanceState(id);
      var new_element = $("<li></li>").text(ui.draggable.text()).attr("id",ui.draggable.attr("id")).appendTo(this);
      new_element.addClass("peer_review_li")
      new_element.html(ui.draggable.html());
      makeItemDraggable(new_element);
      ui.draggable.remove();
    }
  });
  $('#user_acceptance_ul').droppable({
    accept: ".peer_review_li",
    activeClass: "ui-state-hover",
    drop: function(event, ui){       
      var id = ui.draggable.attr("id")
      advanceState(id);
      var new_element = $("<li></li>").text(ui.draggable.text()).attr("id",ui.draggable.attr("id")).appendTo(this);
      new_element.addClass("user_acceptance_li")
      new_element.html(ui.draggable.html());
      makeItemDraggable(new_element);
      ui.draggable.remove();
    }
  });
  $('#archived_ul').droppable({
    accept: ".user_acceptance_li",
    activeClass: "ui-state-hover",
    drop: function(event, ui){
      var id = ui.draggable.attr("id")
      advanceState(id);
      var new_element = $("<li></li>").text(ui.draggable.text()).attr("id",ui.draggable.attr("id")).appendTo(this);
      new_element.addClass("archived_li")
      new_element.html(ui.draggable.html());
      makeItemDraggable(new_element);
      ui.draggable.remove();
    }
  })
}

function reverseState(id) {
  $.ajax({
    type: "POST",
    url: '/tickets/'+id+'/reverse_state',
    success: function(data) {
    }
  });
}

function advanceState(id) {
  $.ajax({
    type: "POST",
    url: '/tickets/'+id+'/advance_state',
    success: function(data) {
    }
  });
  //$.post("/tickets/" + id + "/advance_state");
}

function makeItemDraggable(element) {
  element.draggable({
    revert: true,
    opacity: 0.7,
  })
}
function showDetailView(element) {
  element.animate({
    width: "800px",
    height: "600px",
  })
}
