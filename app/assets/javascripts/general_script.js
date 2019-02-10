
//익명 글의 댓글달기 눌렀을 때
$(document).on('click', ".btn-comment.general", function(e) {
  var form = $(this).parents(".comment-replies-form").find("form")
    form.show()
    form.find("textarea").focus()
})


function getReplyHtml(profile_path, profile_img_url, username, content, created_at, id, secret) {
  var new_url = "/replies/" + id;

  let reply_html = $(`
    <div class='reply'>
      <div class="comment-content">
        <a href="${profile_path}">
          <img class="user-profile" src="${profile_img_url}">
        </a>
        <span class="comment-text">
          <a class="username" href="${profile_path}">
              ${username}
          </a>
          <span class="content">
            ${content}
          </span> 
        </span>
        <div class="likes">
        </div>
      </div>
      <div class = "comment-info">
        <time datetime='${created_at}', class='timeago'></time>
        <span class="btn-comment-delete hover-orange hover-pointer" data-url="${new_url}">삭제</span>
      </div> 
    </div> 
  `)

  if(secret) {
    reply_html.find(".content").before($(lock_icon))
  }

  return reply_html
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

function getShowLike(type, id) {
  return $(
    `
    <span class="num-of-likes zero" data-url="/likes/${type}/${id}">0</span>
    `
  )
}


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
  
  $.ajax({
    type: "POST",
    url: form.attr('action'),
    data: form_data,
    success: function(data) {

      form.find(".prism-form__comment").focus()
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
                  <span class="btn-comment general hover-orange hover-pointer">댓글달기</span>
                </div> 
              </div>
            </div>
            <form class="prism-form-general reply" action="/replies" accept-charset="UTF-8" method="post">
              <input name="utf8" type="hidden" value="✓">
              <input type="hidden" name="id" id="id" value="${data.id}">
              <input type="hidden" name="anonymous" value="true">
              <input type="hidden" name="secret" value="false" id="secret">
              <textarea type="text" name="content" id="content" required="required" class="prism-form__comment" data-enable-grammarly= "false"></textarea>
              <span class="comment-info-alert">이 댓글은 익명처리되어 공개되는 댓글입니다</span>
            </form>
          </div>
        `)

        var btn_like = getButtonLike(data.like_url, data.like_changed_url)
        var btn_show_like = getShowLike("Comment", data.id)
        html.find(".likes").append(btn_show_like)
        html.find(".likes").append(btn_like)
        form.parent().find(".anonymous-comments").append(html)

        // textarea_init(html.find(".prism-form__comment"), window)
        autosize(html.find(".prism-form__comment"))
        html.find("time.timeago").timeago();

      }
      else {
        var html = getReplyHtml(data.profile_path, data.profile_img_url, data.username, data.content, data.created_at, data.id, false)
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