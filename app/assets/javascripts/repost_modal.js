$(document).on('turbolinks:load', function()  {
    $(".btn-repost-modal").on('click', function() {
        
        console.log("repost-modal")
        form = $(this)
        $.ajax({
        type: "GET",
        url: form.attr('data-url'),
        success: function(data) {

            var html = $(`${data.html_content}`)

            $("#edit-background").find("#edit-box").append(html)

            //질문피드에서 ajax은 안되게 하고 새로고침하게 할 거임.
            check_channels($(".answer-button"))
            toggle_channels_dropdown(html.find(".channels-dropdown"))
            $("#edit-background").show()
            $("body").css('overflow', 'hidden')
            textarea_init($(html.find('textarea')), $("#edit-background"))


            //FIXME 룰렁: 저장하고 나서 모달 내리기, x누르면 창 닫히기...
            //지금 저장 버튼 누르면 모달은 내려가지 않지만.... 새로고침을 하면 저장되긴 함
            //공개범위가 custom question의 공개범위로 불러와짐.
            
            //편집 완료
            // $(".new_repost").submit( function(e) {
                
            //     e.preventDefault()
            //     form = $(this)
            //     $.ajax({
            //         type: "POST",
            //         url: form.attr('action'),
            //         data: form.serialize(),
            //         success: function(data) {
            //             console.log("successed")
            //             html.remove()
            //             $("#edit-background").hide()
            //             $("body").css('overflow', 'auto')
            //         },
            //         error: function(data) {
            //             console.log("error!")
            //         }
            //     })
            // })
        },
        error: function(data) {
            console.log("error!")
        }
        })
        
    })
})