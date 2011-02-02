//hide/show work unit description
function set_trigger_for_work_unit(){
  $('#button').click(function() {
    $('.description').each(function() {
      $(this).toggle('fast');
    });
  });
};

set_trigger_for_work_unit();


