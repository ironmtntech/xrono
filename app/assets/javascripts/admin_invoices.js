$(".datepicker").datepicker();

$("#global_invoiced").keyup(function() {
  value = $("#global_invoiced").val();
  $(".global").each(function() {
    this.value = value;
  });
});

$(".ticket_invoiced").keyup(function() {
  value = this.value
  $("." + this.id).each(function() {
    this.value = value;
  });
});
