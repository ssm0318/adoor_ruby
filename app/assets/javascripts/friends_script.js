var lock_icon = '<img src="/assets/icons/lock-icon.png" class="lock-icon" alt="Lock icon")>'

$(document).on('turbolinks:load', function()  {

    // TODO : 숨김댓글 체크한채로 보내면 숨김댓글이라고 뜨기!
    $(".prism-form-friend").submit( function(e) {
        e.preventDefault();
  
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
                        <span>
                          <a href="${data.profile_path}">
                              <img class="user-profile" src="${data.profile_img_url}">
                          </a>
                          <a class="username" href="${data.profile_path}">
                              ${data.username}
                          </a>
                          <span class="content">
                            ${data.content}
                          </span> 
                        </span>
                      </div>
                      <div class = "comment-info">
                          <span>
                              <time datetime='${data.created_at}', class='timeago'></time>
                              <span class="comment-like">좋아요 <span class="show-likes">0</span>개</span>
                              <span class="btn-comment-delete hover-orange hover-pointer" data-url="${new_url}">삭제</span>
                              <span class="btn-comment">댓글달기</span>
                          </span>
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

              var btn_like = getButtonLike(data.like_url, data.like_changed_url)
              html.find(".comment-content").append(btn_like)

              if(form.hasClass("author")) {
                console.log("author")
                form.parent().find(".friend-comments").append(html)
              } 
              else {
                console.log("not author")
                form.parent().find(".comments").append(html)
              }
  
              ///////// 동적으로 삽입한 form에 다시 event binding 해줌. 하나만 선택해야됨.
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
                    var new_btn_like = getButtonLike(data.like_url, data.like_changed_url)
                    new_html.find(".comment-content").append(new_btn_like)
                    new_form.parent().find(".comment-replies").append(new_html);
  
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
              console.log("here");
              var html = getReplyHtml(data.profile_path, data.profile_img_url, data.username, data.content, data.created_at, data.id, secret)
              var btn_like = getButtonLike(data.like_url, data.like_changed_url)
              html.find(".comment-content").append(btn_like)
              form.parent().find(".comment-replies").append(html)
  
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