;(function($, undefined) {
  'use strict';

  var isLoading = false;

  var preload = function() {
    if (isLoading) { return; }

    var url = $('.js-more').first().attr('href');
    if (url === undefined) { return false; }

    isLoading = true;
    $.ajax({
      url: url,
      dataType: 'html',
      success: function(html) {
        $('.js-more').first().remove();

        var $html = $(html);
        if ($html.find('.js-radios') === undefined) { return false; }
        $('.js-radios').append($html.find('.js-radio'));

        $html.find('.js-more').click(event);
        $('.js-radios').append($html.find('.js-more'));
        $('.js-lazy').lazyload({effect: 'fadeIn'}).removeClass('js-lazy');
        isLoading = false;
      }
    });
  };

  var event = function() {
    preload();
    return false;
  };

  $(window).ready(function(){
    $('.js-lazy').lazyload({effect: 'fadeIn'}).removeClass('js-lazy');
    $('.js-more').click(event);
  });

})(jQuery);
