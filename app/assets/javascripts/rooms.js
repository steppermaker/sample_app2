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
