$(document).on('turbolinks:load', function()  {

    // like_ajax(".w-like")
    $(".prism-form-friend").submit( function(e) {

        e.preventDefault();
        
        var form = $(this)
 
            $.ajax({
                type: "POST",
                url: form.attr('action'),
                data: form.serialize(),
                success: function(data) {
                    var new_url = "/comments/" + data.id;
                    console.log(data);
                    console.log("here");
                    console.log(new_url);

                    // link_to는 undefined method라고 에러떠서 어쩔 수 없었듬다ㅠㅠㅠㅠ
                    
                    var html_str=
                    `
                            <div class = "comment-content">
                                <span>
                                    <a href="${data.profile_path}">
                                        <img class="user-profile" src="${data.profile_img_url}">
                                    </a>
                                    <a class="username" href="${data.profile_path}">
                                        ${data.username}
                                    </a>
                                    <span class= "content">${data.content} </span>
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
                    `

                    var btn_like = $(
                        `
                        <img src='/assets/icons/like-default-icon' 
                        class='btn-comment-like do-like'
                        data-url='${data.like_url}'
                        data-changed-src='/assets/icons/like-on-icon'
                        data-changed-url='${data.like_changed_url}'>
                        `
                    )

                    if(form.hasClass("comment")) {
                        html_str = "<div class='comment'>" + html_str
                    } else {
                        html_str = "<div class='comment-indent'>" + html_str
                    }

                    var html = $(html_str)
                    html.find(".comment-content").append(btn_like);
                    

                    if(form.hasClass("reply")) {
                        form.parent().find(".comment-replies").append(html)
                    } else {
                        form.parent().find(".comments").append(html)
                    }

                    form.find(".prism-form__input").val('')
                    like_ajax(btn_like)
                    delete_ajax(html.find(".btn-comment-delete"))
                    html.find("time.timeago").timeago();
                },
                error: function(data) {
                    console.log("error")
                }
            })
    })
})