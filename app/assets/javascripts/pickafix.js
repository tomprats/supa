/* see https://github.com/amsul/pickadate.js/issues/227 */
var BAD_ATTR_RE = /\]_submit$/;
$(function() {
  $('form').submit(function(event) {
    var target = $(event.target);
    $.each(target.find("input[type=hidden]"), function(i, el) {
      var e = $(el);
      var name = e.attr('name');
      if (name.match(BAD_ATTR_RE)) {
        var newName = name.replace(BAD_ATTR_RE, "_submit]");
        e.attr("name", newName)
      }
    });
  });
});
