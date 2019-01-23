function observe(element, event, handler) {
    element.on(event, handler)
}

function textarea_init (element, back) {

    var text = element;
    function resize () {

        text.css('height', 'auto')
        text.css('height', text[0].scrollHeight)

        if(back == window) {
            var scrollTop  = window.pageYOffset ||
            (document.documentElement || document.body.parentNode || document.body).scrollTop;

            window.scrollTo(0, scrollTop)
        } else {
            back.scrollTop(text[0].scrollHeight);
        }

    }
    /* 0-timeout to get the already changed text */
    function delayedResize () {
        window.setTimeout(resize, 0);
    }
    observe(text, 'change',  resize);
    observe(text, 'cut',     delayedResize);
    observe(text, 'paste',   delayedResize);
    observe(text, 'drop',    delayedResize);
    observe(text, 'keydown', delayedResize);



    text.focus();
    text.select();
    resize();
}
