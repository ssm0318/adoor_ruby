$(document).on('click', '.channels-dropdown', function() {
    $(this).siblings(".channels-dropdown-content").toggle();
})

$(document).on('click', '.btn-select-all-channels', function() {
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

$("html").on('click', function(event) {
    var target = $(event.target)
    if(!target.hasClass("channels-dropdown-content") &&
    !target.hasClass("channel-el") &&
    !target.hasClass("channels-dropdown") &&
    !target.hasClass("btn-select-all-channels")) {
        $(".channels-dropdown-content").hide();
    }
}); 