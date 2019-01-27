$(document).on('turbolinks:load', function()  {
    $(".btn-noti").on('click', function() {
        $(".noti-content").toggle();
    })

    $("html").on('click', function(event) {
        var target = $(event.target)
        if(!target.hasClass("btn-noti") &&
        !target.hasClass("noti-content") &&
        !target.hasClass("noti-el")) {
            $(".noti-content").hide();
        }
    });

    $(".noti-el").on('click', function(event) {
        form = $(this)

        $.ajax({
            type: "GET",
            url: form.attr('data-url'),
            success: function(data) {
                console.log(data.html_content)
                //Assign인 경우만 json render
                if(data.html_content) {
                    var html = $(`${data.html_content}`)
                    $("#edit-background").find("#edit-box").append(html)
                    html.find(".new_answer").prepend(`<input value="true" type="hidden" name="from_noti">`)

                    check_channels($(".answer-button"))
                    toggle_channels_dropdown(html.find(".channels-dropdown"))
                    $("#edit-background").show()
                    $("body").css('overflow', 'hidden')
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
                }
            },
            error: function(data) {
                console.log("error!")
            }
        })
    })
})