// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $("#help").dialog({ autoOpen: false });
  $("#help_modal_link").click(function() {
    $("#help").dialog('open')
    return false;
  });
});