function edit_modal(event) {
    event.stopImmediatePropagation();

    form = $(this)
    $.ajax({
        type: "GET",
        url: form.attr('data-url'),
        success: function(data) {

            var html = $(`${data.html_content}`)

            $("#edit-background").find("#edit-box").append(html)
            check_channels(html.find(".answer-button"))
            toggle_channels_dropdown(html.find(".channels-dropdown"))
            $("#edit-background").show()
            $("body").css('overflow', 'hidden')
            form.one('click', edit_modal)
            textarea_init($(html.find('textarea')), $("#edit-background"))
            
            //편집 완료
            $(".edit_answer, .edit_post, .edit_custom_question").submit( function(e) {
                e.preventDefault()

                form = $(this)
                console.log(form)
                $.ajax({
                    type: "PUT",
                    url: form.attr('action'),
                    data: form.serialize(),
                    success: function(data) {
                    console.log("successed")
                        $(`.prism-box.${data.id}`).find(".answer").html(form.find(".new-answer-field").val())
                        $(`.prism-box.${data.id}`).find(".feed-channels").html("공개그룹: " + data.channels)
                        html.remove()
                        $("#edit-background").hide()
                        $("body").css('overflow', 'auto')
                    },
                    error: function(data) {
                        console.log("error!")
                    }
                })
            })
        },
        error: function(data) {
            console.log("error!")
        }
    })
}
$(document).on('turbolinks:load', function()  {
    $(".feed-edit").one('click', edit_modal)
})