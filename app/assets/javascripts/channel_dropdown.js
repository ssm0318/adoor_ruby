function toggle_channels_dropdown(element) {
    element.on('click', function() {
        $(this).siblings(".channels-dropdown-content").toggle();
    })

    element.siblings(".channels-dropdown-content").find(".btn-select-all-channels").on('click', function() {
        if($(this).html()=="전체선택") {
            $(this).html("전체해제")
            $(this).addClass("unselect")
            $(this).siblings("input[type=checkbox]").attr('checked', true)
        } else {
            $(this).html("전체선택")
            $(this).removeClass("unselect")
            $(this).siblings("input[type=checkbox]").attr('checked', false)
        }
    })
}

$(document).on('turbolinks:load', function() {
    $("html").on('click', function(event) {
        var target = $(event.target)
        if(!target.hasClass("channels-dropdown-content") &&
        !target.hasClass("channel-el") &&
        !target.hasClass("channels-dropdown") &&
        !target.hasClass("btn-select-all-channels")) {
            $(".channels-dropdown-content").hide();
        }
    }); 
})