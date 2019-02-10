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
        $("#edit-background").show()
        $("body").css('overflow', 'hidden')
        $(document).on('click', '.btn-repost-modal', repost_modal)
        // textarea_init($(html.find('textarea')), $("#edit-background"))
        autosize(html.find('textarea'))
        $('body').trigger('click'); 
    },
    error: function(data) {
        console.log("error!")
    }
})
}


$(document).on('click', '.btn-repost-modal', repost_modal)