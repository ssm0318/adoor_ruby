function write_modal(event) {
    event.stopImmediatePropagation();
    
    form = $(this)
    $.ajax({
        type: "GET",
        url: form.attr('data-url'),
        success: function(data) {

            var html = $(`${data.html_content}`)

            $("#edit-background").find("#edit-box").append(html)

            //질문피드에서 ajax은 안되게 하고 새로고침하게 할 거임.
            if(form.hasClass("feed")) {
                html.find(".new_answer").prepend(`<input value="true" type="hidden" name="from_feed">`)
            }
            check_channels($(".answer-button"))
            $("#edit-background").show()
            $("body").css('overflow', 'hidden')
            form.one('click', write_modal)
            // textarea_init($(html.find('textarea')), $("#edit-background"))
            autosize(html.find('textarea'))
            
            //편집 완료
            $(".new_answer").submit( function(e) {
                        
                e.preventDefault()
                var new_form = $(this)
                $.ajax({
                    type: "POST",
                    url: new_form.attr('action'),
                    data: new_form.serialize(),
                    success: function(data) {
                        console.log("successed")
                        $("#edit-box").html(``)
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

$(document).one('click', '.btn-write-modal', write_modal)