function assign_modal() {
    console.log("assign_modal")
    form = $(this)

    $.ajax({
        type: "GET",
        url: form.attr('data-url'),
        success: function(data) {

            var html = $(`${data.html_content}`)
            console.log(html)

            var modal = $("#edit-background").find("#friends-box")
            modal.append(html)
            $("#edit-box").hide()
            $("#btn-edit-exit").css('margin-right', '35%')
            $("#friends-box").show()
            $("#edit-background").show()
            $("body").css('overflow', 'hidden')
            form.one('click', assign_modal)

            $(".btn-do-assign").on('click', function() {
                var thisButton = $(this);
                if($(this).text()=='질문하기') {
                    console.log("try assign");
                    const friendId = $(this).data("friend-id");
                    const questionId = $(this).data("question-id");
                    $.ajax({
                        type: "POST",
                        dataType: "JSON",
                        url: '/assignments/' + friendId + '/' + questionId,
                        success: function(data) {
                            console.log("success assign!");
                            thisButton.text("질문취소");
                            thisButton.data("assign-id", data.assign_id);
                            thisButton.css("background-color", "white");
                            thisButton.css("color", "black");
                            flash_message(data.assigned_user.username+ "님께 질문을 보냈습니다.")
                        }
                    })
                } else {
                    console.log("try cancel?");
                    const friendId = $(this).data("friend-id");
                    const questionId = $(this).data("question-id");
                    console.log(friendId);
                    console.log(questionId);
                    $.ajax({
                        type: "DELETE",
                        dataType: "JSON",
                        url: '/assignments/' + friendId + '/' + questionId,
                        success: function(data) {
                            console.log("success canceling!");
                            thisButton.text("질문하기");
                            thisButton.css("background-color", "#F48462");
                            thisButton.css("color", "white");
                            flash_message(data.assigned_user.username+ "님께 질문 보내기를 취소하셨습니다.")
                        }
                    })
                }
            });
        },
        error: function(data) {
            console.log("error!")
        }
    })
}
$(document).on('turbolinks:load', function() {

    $(".btn-assign-modal").one('click', assign_modal)

})