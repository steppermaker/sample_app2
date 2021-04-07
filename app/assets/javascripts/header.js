$(document).on('turbolinks:load', function(){
  var clicked = false;
  $('.menu').click(function(){
    $(this).toggleClass('toggle');
    clicked = !clicked;
    if (clicked) {
      $('.nav-flex').show();
    } else {
      $('.nav-flex').hide();
    }
  });
  var mediaQueryList = window.matchMedia('(min-width: 768px)');
  function listener(mql) {
    if(mql.matches){
      $('.nav-flex').show();
      $('.menu').removeClass('toggle')
    } else {
      $('.nav-flex').hide();
    }
  };
  mediaQueryList.addListener(listener);
});
