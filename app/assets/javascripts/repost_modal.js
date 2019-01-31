function repost_modal() {
    event.stopImmediatePropagation();
    
    form = $(this)
    $.ajax({
    type: "GET",
    url: form.attr('data-url'),
    success: function(data) {

        var html = $(`${data.html_content}`)

        $("#edit-background").find("#edit-box").append(html)
        
        check_channels($(".answer-button"))
        toggle_channels_dropdown(html.find(".channels-dropdown"))
        $("#edit-background").show()
        $("body").css('overflow', 'hidden')
        form.one('click', repost_modal)
        textarea_init($(html.find('textarea')), $("#edit-background"))

    },
    error: function(data) {
        console.log("error!")
    }
})
}


$(document).on('turbolinks:load', function()  {
    $(".btn-repost-modal").one('click', repost_modal)
})