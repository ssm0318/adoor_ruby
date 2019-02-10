$(document).on('click', ".btn-feed-like, .btn-comment-like", function(e) {
    console.time("LIKE")
    console.time("LIKE AJAX")
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
                console.timeEnd("LIKE")
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
                el = like.parent().find(".num-of-likes")

                let like_num = parseInt(el.text());
                like_num += (!like.hasClass("do-like")) ? 1 : - 1
                el.text(like_num)

                if(like_num == 0) {
                    el.addClass("zero")
                }
                else {
                    el.removeClass("zero")
                }
                console.timeEnd("LIKE AJAX")
            },
            error: function(data) {
                console.log("error!")
            }
        })
})