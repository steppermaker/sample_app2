this.onPageLoad('rooms#show', () => {
    console.log("called!")
    var chat = document.getElementById('chat');
    chat.scrollTop = chat.scrollHeight;
    $("#chat").scroll(function() {
      if (($("#chat").scrollTop() == 0 && ($('#chat').attr('data-page') != "last") && $("#chat").find(".page-item a[rel=next]")[0])){
        var height = chat.scrollHeight;
        var page = $('#chat').attr('data-page');
        $.ajax({
          url: $("#chat").find(".page-item a[rel=next]")[0].href.replace(/page=[0-9]+/, `page=${page}`),
          dataType: 'script',
          async: true
        }).done(function(data) {
         chat.scrollTop = chat.scrollHeight - height;
        })
      }
    })
  });

this.onPageLoad(["microposts#show","microposts#likes","static_pages#home","users#show"], () => {
  var reply_btn = document.getElementsByClassName('reply_btn');
  var reply_form = document.getElementsByClassName('reply_form')
  for(let i = 0; i < reply_btn.length; i++) {
    reply_btn[i].addEventListener("click", {count: i, handleEvent: reply_click},false);
  }
  function reply_click(event) {
    let form = reply_form[this.count]
    $(form).show()
    form.querySelector('.close_reply_form').addEventListener("click", close_form)
  }
  function close_form(e) {
    $(e.currentTarget.parentNode).hide()
  }
});
