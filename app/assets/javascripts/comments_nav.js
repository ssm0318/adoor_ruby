$(document).on('click', '.friend-comments-nav', function() {
    $(this).siblings(".anonymous-comments-nav").removeClass("selected")
    $(this).addClass("selected")
    $(this).siblings(".anonymous-comments-div").hide()
    $(this).siblings(".friend-comments-div").show()
})

$(document).on('click', '.anonymous-comments-nav', function() {
    $(this).siblings(".friend-comments-nav").removeClass("selected")
    $(this).addClass("selected")
    $(this).siblings(".anonymous-comments-div").show()
    $(this).siblings(".friend-comments-div").hide()
})