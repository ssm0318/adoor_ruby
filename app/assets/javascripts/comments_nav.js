$(document).on('turbolinks:load', function()  {
    $(".friend-comments-nav").on('click', function() {
        $(this).siblings(".anonymous-comments-nav").removeClass("selected")
        $(this).addClass("selected")
        $(this).siblings(".anonymous-comments-div").hide()
        $(this).siblings(".friend-comments-div").show()
    })
    
    $(".anonymous-comments-nav").on('click', function() {
        $(this).siblings(".friend-comments-nav").removeClass("selected")
        $(this).addClass("selected")
        $(this).siblings(".anonymous-comments-div").show()
        $(this).siblings(".friend-comments-div").hide()
    })
})