// Setup click triggers on comments to hide/show individual comments
comments = $('.hidden_comment')
comments.each( function(comment){
  $(this).prev().click(function(el){
    $(this).next().toggle('slow');
  });
});

// Hide/Show hidden comments
$('#hide_show_comments').click(function() {
  $('.hidden_comment').each(function() {
    $(this).toggle('slow');
  });
});


