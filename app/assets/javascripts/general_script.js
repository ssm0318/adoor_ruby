
function getReplyHtml(profile_path, profile_img_url, username, content, created_at, id) {
  var new_url = "/replies/" + id;

  return $(`
    <div class='reply'>
      <div class="comment-content">
        <span>
          <a href="${profile_path}">
            <img class="user-profile" src="${profile_img_url}">
          </a>
          <a class="username" href="${profile_path}">
              ${username}
          </a>
          <span class="content">
            ${content}
          </span> 
        </span>
      </div>
      <div class = "comment-info">
          <span>
              <span class="comment-like">좋아요 <span class="show-likes">0</span>개</span>
              <span class="btn-comment-delete hover-orange hover-pointer" data-url="${new_url}">삭제</span>
          </span>
          <time datetime='${created_at}', class='timeago'></time>
      </div> 
    </div> 
  `)
}

function getButtonLike(like_url, like_changed_url) {
  return $(
    `
    <img src='/assets/icons/like-default-icon' 
    class='btn-comment-like do-like'
    data-url='${like_url}'
    data-changed-src='/assets/icons/like-on-icon'
    data-changed-url='${like_changed_url}'>
    `
  )
}

$(document).on('turbolinks:load', function()  {

  $(".prism-form-general").submit( function(e) {

      e.preventDefault();

      var form = $(this)
      $.ajax({
        type: "POST",
        url: form.attr('action'),
        data: form.serialize(),
        success: function(data) {
          
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
                            <span class="comment-like">좋아요 <span class="show-likes">0</span>개</span>
                            <span class="btn-comment-delete hover-orange hover-pointer" data-url="${new_url}">삭제</span>
                        </span>
                        <time datetime='${data.created_at}', class='timeago'></time>
                    </div> 
                  </div>
                </div>
                <form class="prism-form-general reply" action="/replies" accept-charset="UTF-8" method="post">
                  <input name="utf8" type="hidden" value="✓">
                  <input type="hidden" name="id" id="id" value="${data.id}">
                  <input type="text" name="content" id="content" required="required" class="prism-form__input">
                  <button name="button" type="submit" class="prism-form__button">저장</button>
                  <span class="comment-info-alert">이 댓글은 익명처리되어 공개되는 댓글입니다</span>
                </form>
              </div>
            `)

            var btn_like = getButtonLike(data.like_url, data.like_changed_url)
            html.find(".comment-content").append(btn_like)
            form.parent().find(".anonymous-comments-div").append(html)

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
                  var new_html = getReplyHtml(data.profile_path, data.profile_img_url, data.username, data.content, data.created_at, data.id)
                  var new_btn_like = getButtonLike(data.like_url, data.like_changed_url)
                  new_html.find(".comment-content").append(new_btn_like)
                  new_form.parent().find(".comment-replies").append(new_html);

                  like_ajax(new_btn_like)
                  delete_ajax(new_html.find(".btn-comment-delete"))
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
            var html = getReplyHtml(data.profile_path, data.profile_img_url, data.username, data.content, data.created_at, data.id)
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