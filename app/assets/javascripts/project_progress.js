window.onload=function(){
  $('#progress_trigger').on('click', function(){
    $(this).toggleClass('active');
    $('#progress_container').toggleClass('open');
  });
};
