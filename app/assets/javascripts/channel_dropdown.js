function toggle_channels_dropdown(element) {
    element.on('click', function() {
        console.log("ho")
        $(this).siblings(".channels-dropdown-content").toggle();
    })
}

$(document).on('turbolinks:load', function() {
    $("html").on('click', function(event) {
        var target = $(event.target)
        if(!target.hasClass("channels-dropdown-content") &&
        !target.hasClass("channel-el") &&
        !target.hasClass("channels-dropdown")) {
            $(".channels-dropdown-content").hide();
        }
    }); 
})