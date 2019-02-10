const lock_icon = '<img src="/assets/icons/lock-icon.png" class="lock-icon" alt="Lock icon")>'


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
      let secret = form.find("input[type=checkbox]").is(":checked") ? true : false
      
      if(form.hasClass("comment")) {
        var new_url = "/comments/" + data.id;

        var html = $(`
          <div class='comment-replies-form'>
            <div class='comment-replies'>
              <div class='comment'>
                <div class='comment-content'>
                  <a href="${data.profile_path}">
                      <img class="user-profile" src="${data.profile_img_url}">
                  </a>
                  <span class="comment-text">
                    <a class="username" href="${data.profile_path}">
                        ${data.username}
                    </a>
                    <span class="content">
                      ${data.content}
                    </span> 
                  </span>
                  <div class="likes">
                  </div>
                </div>
                <div class = "comment-info">
                  <time datetime='${data.created_at}', class='timeago'></time>
                  <span class="btn-comment-delete hover-orange hover-pointer" data-url="${new_url}">삭제</span>
                  <span class="btn-comment friend hover-orange hover-pointer">댓글달기</span>
                </div> 
              </div>
            </div>
            <form class="prism-form-friend reply" action="/replies" accept-charset="UTF-8" method="post">
              <input name="utf8" type="hidden" value="✓">
              <input type="hidden" name="id" id="id" value="${data.id}">
              <input type="hidden" name="anonymous" value="false">
              <div class="form-text"">
                <textarea type="text" name="content" id="content" required="required" class="prism-form__comment" data-enable-grammarly= "false"></textarea>
              </div>
              <span class="comment-info-alert">귓속말 설정을 하면 댓글 작성자에게만 댓글이 보입니다.</span>
            </form>
          </div>
        `)

        if(secret) {
          //TODO (숨김댓글)추가
          html.find(".content").before($(lock_icon))
          html.find("form").find(".form-text").append($('<input type="hidden" name="secret" value="true" id="secret">'))
          html.find("textarea").addClass("secret")
          html.find("comment-info-alert").remove()
        }
        else {
          html.find("form").find(".form-text").append($(`<input type="checkbox" name="secret" id="reply_${data.id}" value="true"><label for="reply_${data.id}">귓속말</label>`))
        }

        var btn_like = getButtonLike(data.like_url, data.like_changed_url)
        var btn_show_like = getShowLike("Comment", data.id)
        html.find(".likes").append(btn_show_like)
        html.find(".likes").append(btn_like)

        if(form.hasClass("author")) {
          console.log("author")
          form.parent().find(".friend-comments").append(html)
        } 
        else {
          console.log("not author")
          form.parent().find(".comments").append(html)
        }

        // textarea_init(html.find(".prism-form__comment"), window)
        autosize(html.find(".prism-form__comment"))
        html.find("time.timeago").timeago();

        console.timeEnd("COMMENT AJAX")

      }
      else {
        var html = getReplyHtml(data.profile_path, data.profile_img_url, data.username, data.content, data.created_at, data.id, secret)
        html.find(".comment-info").append("<span class='btn-comment friend hover-orange hover-pointer' data-self='true'>댓글달기</span>")
        
        if(form.find(".replier-name")) {
          html.find(".content").before(`
            <a href="/profiles/${form.find(".target_author_id").val()}" 
            class="replier-name">
              ${form.find(".replier-name").text()}
            </a>`)
        }
        
        var btn_like = getButtonLike(data.like_url, data.like_changed_url)
        var btn_show_like = getShowLike("Reply", data.id)
        html.find(".likes").append(btn_show_like)
        html.find(".likes").append(btn_like)
        form.parent().find(".comment-replies").append(html)

        html.find("time.timeago").timeago();
      }
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