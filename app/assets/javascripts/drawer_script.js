$(document).on('turbolinks:load', function()  {
    $(".btn-drawer").on('click', function(e) {

        var drawer = $(this)

        console.log(drawer)
        var method

        if(drawer.hasClass("do-drawer")) {
            method = "POST"
        }
        else {
            if(confirm("이 글을 서랍장에서 꺼내시겠습니까?")) {
                method = "DELETE"
            }
            else {
                return;
            }
        }


        $.ajax({
            type: method,
            url: drawer.attr("data-url"),
            success: function(data) {
                const src = drawer.attr('src')
                const url = drawer.attr('data-url')
                const changed_src = drawer.attr('data-changed-src')
                const changed_url = drawer.attr('data-changed-url')
                drawer.attr('src', changed_src)
                drawer.attr('data-url', changed_url)
                drawer.attr('data-changed-src', src)
                drawer.attr('data-changed-url', url)
                drawer.toggleClass("do-drawer")
            },
            error: function(data) {
                console.log("error!")
            }
        })
    })
})