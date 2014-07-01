$(document).ready(ticket_board_ready_function());
$( ".concealed" ).hide();
function ticket_board_ready_function() {

  if (!document.getElementById("div_restricted_access")) {
    $('.bucket ul li').each(function(){
      makeItemDraggable($(this));
    });
  }

  $('.bucket ul li').on('dblclick', function(){
    $.ajax({
      url: '/tickets/'+this.id+'/ticket_detail',
      success: function(data) {
        $(".effect").dialog({draggable: true,closeOnEscape: true, 
            closeText: 'close', width: 850, height: 600, show: 'slide', hide: 'slide'});
        $(".effect").html(data);
      }
    });
  });

  $('#fridge_ul').droppable({
    accept: "",
    drop: function(event, ui){
    }});

  $('#development_ul').droppable({
    accept: ".fridge_li, .peer_review_li, .user_acceptance_li",
    activeClass: "ui-state-hover",
    drop: function(event, ui){
      var dragged = ui.draggable;
      dragged.hide("puff", {}, 350);
      dragged.hasClass("fridge_li") ? advance(dragged, this, "development_li") : reverse(dragged, this, "development_li");
    }
  });
  $('#peer_review_ul').droppable({
    accept: ".development_li",
    activeClass: "ui-state-hover",
    drop: function(event, ui){
      var dragged = ui.draggable
      advance(dragged, this, "peer_review_li");
      dragged.hide("puff", {}, 350);
    }
  });
  $('#user_acceptance_ul').droppable({
    accept: ".peer_review_li",
    activeClass: "ui-state-hover",
    drop: function(event, ui){
      var dragged = ui.draggable
      dragged.hide("puff", {}, 350);
      advance(dragged, this, "user_acceptance_li");
    }
  });
  $('#archived_ul').droppable({
    accept: ".user_acceptance_li",
    activeClass: "ui-state-hover",
    drop: function(event, ui){
      var dragged = ui.draggable
      dragged.hide("puff", {}, 350);
      advance(dragged, this, "archived_li");
    }
  })
}
    
function reverse(dragged, dest_bucket, dest_class) {
  $.ajax({
    type: "POST",
    url: '/tickets/'+dragged.attr("id")+'/reverse_state',
    success: function(data) {
      var new_element = $("<li></li>").text(dragged.text()).attr("id",dragged.attr("id")).appendTo(dest_bucket);
      new_element.addClass(dest_class);
      new_element.html(dragged.html());
      makeItemDraggable(new_element);
      dragged.remove();
    },
    error: function() {
      dragged.show("pulsate", {}, 200);
    }
  });
}

function advance(dragged, dest_bucket, dest_class) {
  $.ajax({
    type: "POST",
    url: '/tickets/'+dragged.attr("id")+'/advance_state',
    success: function(data) {
      var new_element = $("<li></li>").text(dragged.text()).attr("id",dragged.attr("id")).appendTo(dest_bucket);
      new_element.addClass(dest_class);
      new_element.html(dragged.html());
      makeItemDraggable(new_element);
      dragged.remove();
    },
    error: function() {
      dragged.show("pulsate", {}, 200);
    }
  });
}

function makeItemDraggable(element) {
  element.draggable({
    revert: true,
    opacity: 0.7,
  })
}
