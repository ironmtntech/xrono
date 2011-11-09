// ---------- Schedule Modal

// Setup the dialog
$("#schedule_modal").dialog({ 
  modal: true,
  autoOpen: false,
  width: 500,
  height: 500
});

// open the dialog
$('#schedule_modal_link').click(function() {
  $("#schedule_modal").dialog('open');
  return false;
});

// setup datepicker inside the dialog
$("#scheduled_at").datepicker( {
  onSelect: function(dateText, inst) {
    $("#work_unit_scheduled_at").val(dateText);
    $("#schedule_modal").dialog('close');
    $('#schedule_modal_link').text($('#work_unit_scheduled_at').val());
  },
  dateFormat: 'yy-mm-dd'
});
