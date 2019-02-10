$("html").on('click', function(event) {
    var target = $(event.target)
    if(!target.hasClass("btn-read-more") &&
    !target.hasClass("edit-or-delete") &&
    !target.hasClass("edit-or-delete-el")) {
        $(".edit-or-delete").hide();
    }
});

$(document).on('click', '.btn-read-more', function() {
    if($(this).siblings(".edit-or-delete").is(':visible')){
        $(".edit-or-delete").hide();
    }
    else {
        $(".edit-or-delete").hide();
        $(this).siblings(".edit-or-delete").show();
    }
})
