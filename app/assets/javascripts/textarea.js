// var observe;
// if (window.attachEvent) {
//     observe = function (element, event, handler) {
//         element.attachEvent('on' + event, handler);
//     };
// }
// else {
//     observe = function (element, event, handler) {
//         element.addEventListener(event, handler, false);
//     };
// }

function observe(element, event, handler) {
    element.on(event, handler)
}

function textarea_init (element) {
    var text = element;
    function resize () {
        // var scrollLeft = window.pageXOffset ||
        //                 (document.documentElement || document.body.parentNode || document.body).scrollLeft;

        // var scrollTop  = window.pageYOffset ||
        //                 (document.documentElement || document.body.parentNode || document.body).scrollTop;

        // console.log($("#edit-background").scrollTop())

        // var scrollTop = $("#edit-background").scrollTop(

        // console.log($("#edit-background").scrollTop)
        console.log(text.css('height'))
        text.css('height', 'auto')
        text.css('height', text[0].scrollHeight)
        // text.style.height = text.scrollHeight + 'px';

        $("#edit-background").scrollTop(text[0].scrollHeight);

        // $("#edit-background").scrollTo(0, scrollTop);
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
