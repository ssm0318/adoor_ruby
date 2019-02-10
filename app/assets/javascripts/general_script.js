
//익명 글의 댓글달기 눌렀을 때
$(document).on('click', ".btn-comment.general", function(e) {
  var form = $(this).parents(".comment-replies-form").find("form")
    form.show()
    form.find("textarea").focus()
})

//익명 댓글 ajax
$(document).on('submit', '.prism-form-general', function(e) {
  e.preventDefault();
  if($(this).find(".prism-form__comment").val().trim() ==''){
    return;
  }

  var form = $(this)
  var form_data = form.serialize()
  form.find(".prism-form__comment").val('')
  autosize.update(form.find(".prism-form__comment"))
  $('body').trigger('click'); 
  
  $.ajax({
    type: "POST",
    url: form.attr('action'),
    data: form_data,
    success: function(data) {

      form.find(".prism-form__comment").focus()
      var html = $(`${data.html_content}`)

      if(form.hasClass("comment")) {

        form.parent().find(".anonymous-comments").append(html)
        autosize(html.find(".prism-form__comment"))
        $('body').trigger('click'); 
        html.find("time.timeago").timeago();

      }
      else {
        
        form.parent().find(".comment-replies").append(html)
        html.find("time.timeago").timeago();
      }
    },
    error: function(data) {
        console.log("error")
    }
  })
})