$(document).on('turbolinks:load', function(){
  $('.menu').click(function(){
    $(this).toggleClass('toggle');
    $('.nav-flex').toggle();
  });
  const mediaQueryList = window.matchMedia('(min-width: 769px)');
  const listener = (mql) => {
    if(mql.matches){
      $('.nav-flex').show();
    } else {
      $('.nav-flex').hide();
    }
  };
  mediaQueryList.addListener(listener);
});
