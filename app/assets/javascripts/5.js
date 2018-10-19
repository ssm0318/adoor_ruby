$(document).ready(function() {
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
         !target.hasClass("btn-do-assign") ) {
              $(".assignment-content").hide();
        }
    }); 

    $(".btn-do-assign").on('click', function() {

        var thisButton = $(this);

        if($(this).text()=='Assign') {
            console.log("try assign");
            const friendId = $(this).data("friend-id");
            const questionId = $(this).data("question-id");

            $.ajax({
                type: "POST",
                dataType: "JSON",
                url: '/assignments/' + friendId + '/' + questionId,
                success: function(data) {
                    if(data.assign_id != "-1") {
                        console.log("success assign!");
                        thisButton.text("Cancel");
                        thisButton.data("assign-id", data.assign_id);
                        $(".message").text(data.assigned_user+ "님을 assign하셨습니다.");
                    }
                    else {
                        console.log("이미 답했음");
                        $(".message").text(data.assigned_user+ "님은 이미 질문에 답하셨습니다.");
                    }
                }
            })
        } else {
            console.log("try cancel");
            const assignId = $(this).data("assign-id");

            $.ajax({
                type: "DELETE",
                dataType: "JSON",
                url: '/assignments/' + assignId,
                success: function(data) {
                    console.log("success canceling!");
                    thisButton.text("Assign");
                    $(".message").text(data.assigned_user+ "님을 assign 취소하셨습니다.");
                }
            })
        }

    }) 
}) 