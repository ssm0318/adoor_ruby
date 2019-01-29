$(document).on('turbolinks:load', function()  {
    $("#btn-edit-exit").on('click', function() {
        console.log("exit~")
        $("#edit-box").html(``)
        $("#edit-background").hide()
        $("body").css('overflow', 'auto')
        
    })
})