$(document).on('turbolinks:load', function()  {
    $(".btn-write-modal").on('click', function() {
        
        $("#edit-background").show()
        $("body").css('overflow', 'hidden')

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
            toggle_channels_dropdown(html.find(".channels-dropdown"))
            textarea_init($(html.find('textarea')), $("#edit-background"))

            //편집 exit 버튼
            $("#btn-edit-exit").on('click', function() {
            html.remove()
            $("#edit-background").hide()
            $("body").css('overflow', 'auto')
            })
            
            //편집 완료
            $(".new_answer").submit( function(e) {
                
                e.preventDefault()
                form = $(this)
                $.ajax({
                    type: "POST",
                    url: form.attr('action'),
                    data: form.serialize(),
                    success: function(data) {
                        console.log("successed")
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
        
    })
})