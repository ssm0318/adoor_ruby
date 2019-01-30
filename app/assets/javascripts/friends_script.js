const lock_icon = '<img src="/assets/icons/lock-icon.png" class="lock-icon" alt="Lock icon")>'

function click_friend_reply(element) {
  element.on('click', function() {

    var form = $(this).parents(".comment-replies-form").find("form")
    form.show()
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
    form.submit( function(e) {
      form.hide()
    })
  })
}


$(document).on('turbolinks:load', function()  {

    // textarea_init($(".prism-form-friend").find(".prism-form__input"), window)
    click_friend_reply($(".btn-comment.friend"))
    // TODO : 숨김댓글 체크한채로 보내면 숨김댓글이라고 뜨기!

    $(".prism-form-friend").submit( function(e) {
        e.preventDefault();

        console.log(e)

        var form = $(this)
        $.ajax({
          type: "POST",
          url: form.attr('action'),
          data: form.serialize(),
          success: function(data) {
            
            let secret = form.find("#secret").is(":checked") ? true : false
            
            if(form.hasClass("comment")) {
              var new_url = "/comments/" + data.id;
              console.log(new_url);
              console.log("hey"); 
  
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
                  <form class="prism-form-general reply" action="/replies" accept-charset="UTF-8" method="post">
                    <input name="utf8" type="hidden" value="✓">
                    <input type="hidden" name="id" id="id" value="${data.id}">
                    <input type="hidden" name="anonymous" value="false">
                    <input type="text" name="content" id="content" required="required" class="prism-form__input">
                    <button name="button" type="submit" class="prism-form__button">저장</button>
                    <span class="comment-info-alert">숨기기 설정을 하면 댓글 작성자에게만 댓글이 보입니다.</span>
                  </form>
                </div>
              `)

              if(secret) {
                //TODO (숨김댓글)추가
                html.find(".content").before($(lock_icon))
                html.find("form").find("#content").after('<input type="hidden" name="secret" value="true" id="secret">')
              }
              else {
                html.find("form").find("#content").after('<label><input type="checkbox" name="secret" id="secret" value="true">숨기기</label>')
              }

              click_friend_reply(html.find(".btn-comment"))
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

              btn_show_like.one('click', show_likes)
              like_ajax(btn_like)
              delete_ajax(html.find(".btn-comment-delete"))
              html.find("time.timeago").timeago();
              html.find("form").submit( function(event) {
  
                var new_form = $(this)
  
                event.preventDefault();
                $.ajax({
                  type: "POST",
                  url: new_form.attr('action'),
                  data: new_form.serialize(),
                  success: function(data) {

                    var new_html = getReplyHtml(data.profile_path, data.profile_img_url, data.username, 
                        data.content, data.created_at, data.id, secret || new_form.find("#secret").is(":checked"))
                    new_html.find(".comment-info").append("<span class='btn-comment friend hover-orange hover-pointer' data-self='true'>댓글달기</span>")
                    click_friend_reply(new_html.find(".btn-comment"))

                    var new_btn_like = getButtonLike(data.like_url, data.like_changed_url)
                    var new_btn_show_like = getShowLike("Reply", data.id)
                    new_html.find(".likes").append(new_btn_show_like)
                    new_html.find(".likes").append(new_btn_like)
                    new_form.parent().find(".comment-replies").append(new_html);

                    new_btn_show_like.one('click', show_likes)
                    like_ajax(new_btn_like)
                    delete_ajax(new_html.find(".btn-comment-delete"))
                    new_html.find("time.timeago").timeago()
                    new_form.find(".prism-form__input").val('')
                  },
                  error: function(data) {
                    console.log("error")
                  }
                })
              })
  
            }
            else {
              var html = getReplyHtml(data.profile_path, data.profile_img_url, data.username, data.content, data.created_at, data.id, secret)
              html.find(".comment-info").append("<span class='btn-comment friend hover-orange hover-pointer' data-self='true'>댓글달기</span>")
              click_friend_reply(html.find(".btn-comment"))
              
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

              btn_show_like.one('click', show_likes)
              like_ajax(btn_like)
              delete_ajax(html.find(".btn-comment-delete"))
              html.find("time.timeago").timeago();
            }
  
            console.log(form)
            form.find(".prism-form__input").val('')
          },
          error: function(data) {
              console.log("error")
          }
        })
    })
  
  })