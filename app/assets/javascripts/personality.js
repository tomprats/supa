$(document).ready(function() {
  $(document).on("click", ".personality", function() {
    $("#personality-modal").modal("show");
    assessment = $(".personality-data").data("uid");
    traitify = Traitify.ui.load(assessment, ".personality-content");
    traitify.slideDeck.onFinished(function() {
      $.ajax("/assessments/" + assessment, { method: "PUT" });
    });
  });
});
