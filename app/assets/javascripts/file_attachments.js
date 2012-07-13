invalid_file_attachments = $('.invalid_file_attachment')

$('#hide_show_invalid').click( function() {
  invalid_file_attachments.each( function() {
    $(this).parent().toggle('slow');
  });
});


