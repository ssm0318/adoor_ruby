function textarea_init (element, back) {

    if(back!=window) {
        resizeTextArea(element, back)
    }
    element.on('keyup', function() {
        var elem = $(this);
        
        //bind scroll
        if(!elem.data('has-scroll'))
        {
            elem.data('has-scroll', true);
            elem.bind('scroll keyup', function(){
                resizeTextArea($(this), back);
            });
        }
                
        resizeTextArea($(this), back);
    });

    element.focus()
}


//resize text area
function resizeTextArea(elem, back) {
    elem.height(1);
    elem.scrollTop(0);
    elem.height(elem[0].scrollHeight - elem[0].clientHeight + elem.height());
    // console.log($(window).height())
    if(back == window) {
        var scrollTop  = window.pageYOffset ||
        (document.documentElement || document.body.parentNode || document.body).scrollTop;
        a = $(window).height()
        b = scrollTop
        c = elem.offset().top
        d = elem.height()

        //만약 선 넘어가버리면 
        // window.scrollTo(0, elem[0].scrollHeight - 600)
        if(a < d) {
            window.scrollTo(0, c + d - a + 10)
        } 
        else if(a + b <= c + d + 10) {
            window.scrollTo(0, c + d - a + 10)
        }

    } else {
        back.scrollTop(elem[0].scrollHeight);
    }
}

