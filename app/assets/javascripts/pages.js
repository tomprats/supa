$(document).ready(function() {
  if($(".pages-index").length > 0) {
    $(document).on("input", "#new_page #page_name", function(e) {
      $this = $(this);
      value = $this.val().replace(/'|"/g, "");
      value = value.replace(/\s+/g, "-").toLowerCase();
      $this.closest("form").find("#page_path").val(value);
    });
  }
});
