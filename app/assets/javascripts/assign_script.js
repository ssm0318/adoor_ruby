$(document).on('turbolinks:load', function() {

    $(".btn-assign").on('click', function() {

        if($(this).siblings(".assignment-content").is(':visible')){
            $(".assignment-content").hide();
        }
        else {
            $(".assignment-content").hide();
            $(this).siblings(".assignment-content").show();
        }
    });

    $("html").on('click', function(event) {

        var target = $(event.target)
        if(!target.hasClass("btn-assign") &&
        !target.hasClass("assignment-content") &&
        !target.hasClass("btn-do-assign") &&
        !target.hasClass("assignee") &&
        !target.hasClass("assignee-profile") &&
        !target.hasClass("assignee-name") ) {
            $(".assignment-content").hide();
        }
    }); 

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
                    if (data.assign_id != "-1") {
                        console.log("success assign!");
                        thisButton.text("질문취소");
                        thisButton.data("assign-id", data.assign_id);
                        thisButton.css("background-color", "white");
                        thisButton.css("color", "black");
                        $(".message").text(data.assigned_user.username+ "님께 질문을 보냈습니다.");
                        $(".message").fadeIn(900).fadeOut(900);
                        console.log(data.assigned_user);
                    }
                    else {
                        console.log("이미 답했음");
                        $(".message").text(data.assigned_user.username+ "님은 이미 질문에 답하셨습니다.");
                        $(".message").fadeIn(900).fadeOut(900);
                    }
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
                    $(".message").text(data.assigned_user.username+ "님께 질문 보내기를 취소하셨습니다.");
                    $(".message").fadeIn(900).fadeOut(900);
                }
            })
        }
    });
})