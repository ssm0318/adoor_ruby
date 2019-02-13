// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks 
//= require jquery_ujs
//= require turbolinks
//= require ahoy
//= require i18n
//= require i18n/translations
//= require autosize

$(document).on('click', function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        console.log('scrolling');
        // $('.pagination').text("로딩 중...");
        $('.pagination').html('<div class="loading-gif"><img src="/assets/icons/loading-9059385ab0380d6cf557878923f4068a8f4a9d171349b72a0956866ec12f6950.gif"></div>');
        $.getScript(url);
        // $('.pagination').replaceWith('');
      }
    });
    return $(window).scroll();
  }
});