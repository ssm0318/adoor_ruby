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
            $("#edit-background").show()
            $("body").css('overflow', 'hidden')
            $(document).one('click', '.feed-edit', edit_modal)
            // textarea_init($(html.find('textarea')), $("#edit-background"))
            autosize(html.find('textarea'))
            $('body').trigger('click'); 
            
            //편집 완료
            $(".edit_answer, .edit_post, .edit_repost").submit( function(e) {
                e.preventDefault()

                form = $(this)
                console.log(form)
                $.ajax({
                    type: "PUT",
                    url: form.attr('action'),
                    data: form.serialize(),
                    success: function(data) {
                    console.log("successed")
                        $(`.prism-box.${data.type}.${data.id}`).find(".answer").html(form.find(".new-answer-field").val())
                        $(`.prism-box.${data.type}.${data.id}`).find(".feed-channels").html('<strong style = "padding-right: 10px; color: #4f4f4f;">공개그룹</strong>' + data.channels)
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


$(document).one('click', '.feed-edit', edit_modal)