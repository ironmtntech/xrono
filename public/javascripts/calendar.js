//hide/show work unit description
function set_trigger_for_work_unit(){
  $('.expand').click(function() {
    $('.description').each(function() {
      $(this).toggle('fast');
    });
  });
};

set_trigger_for_work_unit();


