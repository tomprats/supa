$(document).ready(function() {
  $(document).on("click", "#questionnaire-modal input#select_all", function() {
    if(this.checked) {
      $(this).closest(".form-group").find(".checkbox input").each(function() {
        this.checked = true;
      });
    } else {
      $(this).closest(".form-group").find(".checkbox input").each(function() {
        this.checked = false;
      });
    }
  });

  $(document).on("click", "#questionnaire-modal input:not(#select_all):not(:checked)", function() {
    $("#questionnaire-modal input#select_all")[0].checked = false;
  });
});
