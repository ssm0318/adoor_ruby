$(document).on('turbolinks:load', function()  {
    $("#btn-edit-exit").on('click', function() {
        console.log("exit~")
        $("#edit-box").html(``)
        $("#edit-box").show()
        $("#friends-box").html(``)
        $("#friends-box").hide()
        $("#edit-background").hide()
        $("#btn-edit-exit").css('margin-right', '29%')
        $("body").css('overflow', 'auto')
    })
})