//hide/show work unit description
$('.expand').click(function() {
  $(this).parents('.calendar').find('a').siblings('.description').each(function() {
    $(this).toggle('fast');
  });
  return false;
});

function show_by_default(var status)
{
  if status == true
  {
    $('.calendar').find('a').siblings('.description').each(function() {
      $(this).show();
    });
  }
}


