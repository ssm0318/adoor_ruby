function show_likes(event) {
    event.stopImmediatePropagation();
    form = $(this)

    //익명이면 보이지 않게 하기
    if(form.parents(".anonymous-comments").length > 0) {
        $(document).one('click', ".num-of-likes", show_likes)
        return;
    }

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
            $(document).one('click', ".num-of-likes", show_likes)
        },
        error: function(data) {
            console.log("error!")
        }
    })
}


$(document).on('click', function()  {
    $(".num-of-likes").filter(function(index) {
        return $(this).text() != '0'
    }).removeClass("zero")

    $(".num-of-drawers").filter(function(index) {
        return $(this).text() != '0'
    }).removeClass("zero")

    $(".num-of-reposts").filter(function(index) {
        return $(this).text() != '0'
    }).removeClass("zero")

    $(document).one('click', ".num-of-likes", show_likes)

})
