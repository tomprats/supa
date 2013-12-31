(function($, window, document, undefined) {
  $.fn.swapWith = function(to) {
    return this.each(function() {
      var copy_to = $(to).clone(true);
      var copy_from = $(this).clone(true);
      $(to).replaceWith(copy_from);
      $(this).replaceWith(copy_to);
    });
  };
}(jQuery, this, document));