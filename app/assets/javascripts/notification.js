$(document).on('click', '.btn-noti', function() {
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


function noti_click(e) {
    form = $(this)

    $.ajax({
        type: "GET",
        url: form.attr('data-url'),
        success: function(data) {
            $(document).one('click', '.noti-el, .noti-box', noti_click)
            //Assign인 경우만 json render
            if(data.html_content) {
                var html = $(`${data.html_content}`)
                $("#edit-background").find("#edit-box").append(html)
                html.find(".new_answer").prepend(`<input value="true" type="hidden" name="from_noti">`)

                check_channels($(".answer-button"))
                $("#edit-background").show()
                $("body").css('overflow', 'hidden')
                // textarea_init($(html.find('textarea')), $("#edit-background"))
                autosize(html.find('textarea'))
                $('body').trigger('click'); 
                
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
}

$(document).one('click', '.noti-el, .noti-box', noti_click)

