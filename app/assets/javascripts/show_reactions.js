function show_likes() {
    console.log("wh")
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
    $(".num-of-likes").filter(function(index) {
        return $(this).text() != '0'
    }).removeClass("zero")

    $(".num-of-drawers").filter(function(index) {
        return $(this).text() != '0'
    }).removeClass("zero")

    $(".num-of-reposts").filter(function(index) {
        return $(this).text() != '0'
    }).removeClass("zero")

    $(".num-of-likes").one('click', show_likes)
    // $(".num-of-drawers").one('click', show_likes)
})
