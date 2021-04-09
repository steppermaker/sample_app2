this.onPageLoad('rooms#show', function() {
    var chat = document.getElementById('chat');
    chat.scrollTop = chat.scrollHeight;
    $("#chat").scroll(function() {
      if (($("#chat").scrollTop() == 0 && ($('#chat').attr('data-page') != "last") && $("#chat").find(".page-item a[rel=next]")[0])){
        var height = chat.scrollHeight;
        var page = $('#chat').attr('data-page');
        $.ajax({
          url: $("#chat").find(".page-item a[rel=next]")[0].href.replace(/page=[0-9]+/, 'page=' + page),
          dataType: 'script',
          async: true
        }).done(function(data) {
         chat.scrollTop = chat.scrollHeight - height;
        })
      }
    })
  });

this.onPageLoad(["microposts#show","microposts#likes",
                 "static_pages#home","users#show","users#likes"], function() {
  var login_required = document.getElementsByClassName('login_required');

  if (login_required[0]) {
    for(var i = 0; i < login_required.length; i++) {
      login_required[i].addEventListener("click", show_login_required, false);
    }
    function show_login_required(e) {
      e.preventDefault();
      var btn = $(e.target).data("btn");
      if ('like' == btn) {
        $('.login_or_new_user h1').text("Like your favorite microposts!");
      } else if ("reply" == btn) {
        $('.login_or_new_user h1').text("Reply and join the conversation!");
      } else {
        $('.login_or_new_user h1').text("Would you like to express yourself?");
      }

      $('.show_login_required').show();
      $('.close_show_login_required').on('click', function() {
        $(this.parentNode.parentNode).hide();
        $(this).off('click');
      });
    }
  } else {
    var reply_btn = document.getElementsByClassName('reply_btn');
    var reply_form = document.getElementsByClassName('reply_form')
    add_click_event(reply_btn, show_reply_form);
    function show_reply_form(e) {
      var form = reply_form[this.count]
      $(form).show();
      form.querySelector('.close_reply_form').addEventListener("click", close_form);
    }

    function close_form(e) {
      $(e.currentTarget.parentNode).hide();
      e.currentTarget.removeEventListener("click", close_form);
    }


    var edit_btn = document.getElementsByClassName('edit_btn');
    var edit_screen = document.getElementsByClassName('edit_micropost_screen')
    add_click_event(edit_btn, show_edit_screen);

    function show_edit_screen(e) {
      var screen = edit_screen[this.count]
      var current_edit_btn = e.currentTarget;
      $(screen).show('fast');
      $(current_edit_btn).hide()
      setTimeout(close_edit_screen, 10);
      function close_edit_screen() {
        document.addEventListener('click', click_other_place_for_close);
      }

      function click_other_place_for_close(e) {
        if(!e.target.closest('.edit_micropost_screen')) {
          $(screen).hide();
          $(current_edit_btn).show()
        document.removeEventListener('click', click_other_place_for_close)
        }
      }
    }

    var like_btns = document.getElementsByClassName('like_btns');

    add_click_event(like_btns, stop_send)

    function stop_send(e) {
      e.target.classList.add('stop')
    }

    function add_click_event(btn,callback) {
      for(var i = 0; i < btn.length; i++) {
        btn[i].addEventListener("click",
                                {count: i, handleEvent: callback}, false);
      }
    }
  }
});
