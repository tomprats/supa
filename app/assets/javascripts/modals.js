$(document).ready(function() {
  $("body").on("click", ".edit-stats", function(e) {
    e.preventDefault();
    setModal("stats", "/admin/games/" + $(this).data("id") + "/stats/edit");
    return false;
  });
});

function setModal(name, url) {
  $.get(url, function(data) {
    $("#" + name + "-modal").html(data);
    $("#" + name + "-modal").modal("show");
  });
}
