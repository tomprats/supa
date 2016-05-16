$(document).ready(function() {
  $(document).on("change", "#waiver-modal #agree", function(e) {
    $("#waiver-modal .waiver-register").attr("disabled", !$(this).is(":checked"))
  });

  $(document).on("click", "#waiver-modal .waiver-register", function(e) {
    if($(this).attr("disabled")) {
      e.preventDefault();
      return false;
    }
  });
});
