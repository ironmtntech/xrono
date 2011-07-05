//hide/show work unit description
$('.expand').click(function() {
  $(this).parents('.calendar').find('a').siblings('.description').each(function() {
    $(this).toggle('fast');
  });
  return false;
});

$('.calendar').find('a').siblings('.description').each(function() {
  $(this).show();
});

