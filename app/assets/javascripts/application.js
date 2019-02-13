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
        $('.pagination').html('<div class="d-flex loading-gif"><div class="spinner-border text-secondary" role="status"><span class="sr-only">Loading...</span></div></div>');
        $.getScript(url);
      }
    }); 
    return $(window).scroll();
  }
});
