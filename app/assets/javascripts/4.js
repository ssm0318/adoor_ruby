$(document).ready(function() {
    $("form").submit(function(event){
        const answer_id = $(this).data("answer_id")
        const recipient_id = $(this).data("recipient_id")
        $.ajax({
            url: "/answers/" + answer_id + "/comments",
            type: "POST",
            data: {
                // answer_id: answer_id,
                recipient_id: recipient_id,
                content: $(".input" + answer_id).val()
            },
            dataType: "JSON",
            success: function(data) {
            console.log("success")
            return
            }
        });
    });

    // https://zetawiki.com/wiki/HTML_textarea_%EC%9E%90%EB%8F%99_%EB%86%92%EC%9D%B4_%EC%A1%B0%EC%A0%88
    $(".new-answer-field").on('keydown keyup', function() {
        $(this).height(1).height($(this).prop('scrollHeight') + 20); // 저 1이 뭐지 나중에 찾아보기
    });
});