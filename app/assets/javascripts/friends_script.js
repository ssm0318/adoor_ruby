//친구들, 내 댓글에서 댓글달기 눌렀을 때
$(document).on('click', ".btn-comment.friend", function(e) {
  var form = $(this).parents(".comment-replies-form").find("form")
  form.show()
  form.find("textarea").focus()
  form.find(".target_author_id").remove()
  form.find(".replier-name").remove()

  if($(this).parents().hasClass("reply") && 
    $(this).attr("data-self")=="false") {
    let tag = $(`
    <input type="hidden" 
      name="target_author_id" 
      class="target_author_id" 
      value="${$(this).attr("data-recipient-id")}">`)

    let name_span = $(`<span class="replier-name">${$(this).attr("data-recipient-name")}</span>`)

    form.prepend(tag)
    form.prepend(name_span)
  }
})


//댓글 엔터 누르면 저장되게 하고, Shift + 엔터 누르면 그냥 한 줄 늘려주기
$(document).on('keypress', '.prism-form__comment', function(e) {
  if(e.keyCode == 13 && !e.shiftKey) {        
    $(this).parents("form").submit();
    $(this).blur();
  }
})


//댓글 ajax
$(document).on('submit', '.prism-form-friend', function(e) {
  e.preventDefault();
  console.time("COMMENT")
  console.time("COMMENT AJAX")

  if($(this).find(".prism-form__comment").val().trim() ==''){
     return;
  }
  var form = $(this)
  var form_data = form.serialize()
  form.find(".prism-form__comment").val('')
  autosize.update(form.find(".prism-form__comment"))
  
  $.ajax({
    type: "POST",
    url: form.attr('action'),
    data: form_data,
    success: function(data) {
      console.timeEnd("COMMENT")
      
      form.find(".prism-form__comment").focus()
      
      var html = $(`${data.html_content}`)
      if(form.hasClass("comment")) {

        if(form.hasClass("author")) {
          form.parent().find(".friend-comments").append(html)
        } 
        else {
          form.parent().find(".comments").append(html)
        }
        autosize(html.find(".prism-form__comment"))
        html.find(".timeago").timeago();

      }
      else {
        form.parent().find(".comment-replies").append(html)
        html.find(".timeago").timeago();
      }

      console.timeEnd("COMMENT AJAX")
    },
    error: function(data) {
        console.log("error")
    }
  })
})

$(document).on('turbolinks:load', function()  {

    $(".friend-comments, .comments").find(".comment").each(function(index) {
      if($(this).find(".lock-icon").length != 0) {
        console.log($(this))
        $(this).parents(".comment-replies-form").find("textarea").addClass("secret")
      }
    }) 
  
  })