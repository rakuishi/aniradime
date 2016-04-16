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
        if ($html.find('.radios').length === 0) { return false; }
        $($('.js-radios')).append($html.find('.js-radio'));

        $html.find('.js-more').click(event);
        $($('.js-radios')).append($html.find('.js-more'));
        isLoading = false;
      }
    });
  };

  var event = function() {
    preload();
    return false;
  };

  $('.js-more').click(event);

})(jQuery);
