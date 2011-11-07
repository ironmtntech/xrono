//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require add_taxonomy
//= require admin_invoices
//= require calendar
//= require comments
//= require css_browser_selector
//= require dashboard
//= require file_attachments
//= require schedule_modal

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $("#help").dialog({ autoOpen: false });
  $("#help_modal_link").click(function() {
    $("#help").dialog('open')
    return false;
  });
});
