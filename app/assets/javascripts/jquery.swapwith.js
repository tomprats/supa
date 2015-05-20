(function($, window, document, undefined) {
  $.fn.swapWith = function(to) {
    return this.each(function() {
      var copy_to = $(to).clone(true);
      var copy_from = $(this).clone(true);
      var to_value = $(to).find("select").val();
      var from_value = $(this).find("select").val();
      $(to).replaceWith(copy_from)
      $(this).replaceWith(copy_to).find("select").val(to_value);
      $(copy_from).find("select").val(from_value);
      $(copy_to).find("select").val(to_value);
    });
  };
}(jQuery, this, document));
