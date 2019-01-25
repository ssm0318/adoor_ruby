function like_ajax(element) {
    element.on('click', function(e) {
        var like = $(this)

        var method

            if(like.hasClass("do-like")) {
                method = "POST"
            }
            else {
                method = "DELETE"
            }

            $.ajax({
                type: method,
                url: like.attr("data-url"),
                success: function(data) {
                    const src = like.attr('src')
                    const url = like.attr('data-url')
                    const changed_src = like.attr('data-changed-src')
                    const changed_url = like.attr('data-changed-url')
                    like.attr('src', changed_src)
                    like.attr('data-url', changed_url)
                    like.attr('data-changed-src', src)
                    like.attr('data-changed-url', url)
                    like.toggleClass("do-like")

                    var el
                    if(like.hasClass("btn-feed-like")) {
                        // 클래스 구조 바뀌면 에러 날 수 있으니 바꾸지 말 것
                        el = like.parent().find(".num-of-likes")
                    } else {
                        // 클래스 구조 바뀌면 에러 날 수 있으니 바꾸지 말 것
                        el = like.parent().parent().find(".num-of-likes")
                    }

                    let like_num = parseInt(el.text())
                    like_num += (!like.hasClass("do-like")) ? 1 : - 1
                    el.text(like_num)
                },
                error: function(data) {
                    console.log("error!")
                }
            })
    })
}

$(document).on('turbolinks:load', function()  {
    like_ajax($(".btn-feed-like"))
    like_ajax($(".btn-comment-like"))
})