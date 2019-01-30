function show_likes() {
    form = $(this)
    $.ajax({
        type: "GET",
        url: form.attr('data-url'),
        success: function(data) {
            console.log("successed")
            var html = data.html_content
            $("#edit-box").hide()
            $("#btn-edit-exit").css('margin-right', '35%')
            $("#friends-box").show()
            $("#edit-background").find("#friends-box").append(html)
            $("#edit-background").show()
            $("body").css('overflow', 'hidden')
            form.one('click', show_likes)
        },
        error: function(data) {
            console.log("error!")
        }
    })
}

$(document).on('turbolinks:load', function()  {
    $(".num-of-likes").one('click', show_likes)
})
