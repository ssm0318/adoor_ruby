function drawer_ajax(element) {
    element.on('click', function(e){
        var drawer = $(this)

        var method
            if (drawer.hasClass("do-drawer")) {
                method = "POST"
            }
            else {
                if(confirm("이 글을 서랍장에서 꺼내시겠습니까?")) {
                    method = "DELETE"
                }
                else {
                    return;
                }
            }

            $.ajax({
                type: method,
                url: drawer.attr("data-url"),
                success: function(data) {
                    const src = drawer.attr('src')
                    const url = drawer.attr('data-url')
                    const changed_src = drawer.attr('data-changed-src')
                    const changed_url = drawer.attr('data-changed-url')
                    drawer.attr('src', changed_src)
                    drawer.attr('data-url', changed_url)
                    drawer.attr('data-changed-src', src)
                    drawer.attr('data-changed-url', url)
                    drawer.toggleClass("do-drawer")

                    var el
                    if (drawer.hasClass("btn-drawer")) {
                        // 클래스 구조 바뀌면 에러 날 수 있으니 바꾸지 말 것
                        el = drawer.parent().find(".num-of-drawers")
                    } 

                    let drawer_num = parseInt(el.text())
                    drawer_num += (!drawer.hasClass("do-drawer")) ? 1 : - 1
                    el.text(drawer_num)

                    if(drawer_num == 0) {
                        el.addClass("zero")
                    }
                    else {
                        el.removeClass("zero")
                    }
                },
                error: function(data) {
                    console.log("error!")
                }
            })

    })
}

$(document).on('turbolinks:load', function()  {
    $(".num-of-drawers").filter(function(index) {
        return $(this).text() != '0'
    }).removeClass("zero")
    drawer_ajax($(".btn-drawer"))
})