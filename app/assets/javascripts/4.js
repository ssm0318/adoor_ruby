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
        })
    })
});