$(document).ready(function() {
  $(".edit-stats").click(function(e) {
    e.preventDefault();
    setModal("stats", "/games/" + $(this).data("id") + "/stats/edit");
  });
});

function setModal(name, url) {
  $.get(url, function(data) {
    $("#" + name + "-modal").html(data);
    $("#" + name + "-modal").modal('show');
  });
}
