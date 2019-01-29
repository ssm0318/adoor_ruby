function flash_message(message) {
    console.log(message)

    var html = $(`<div class="flash-message">${message}</div>`)
    $("#flash-messages").append(html)
    // html.fadeIn(200)
    setTimeout(function() {
        html.fadeOut(400);
    }, 1000)
    setTimeout(function() {
        html.remove()
    }, 2000)
}