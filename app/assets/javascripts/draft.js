$(document).ready(function() {
  // Auto-reload
  if($(".draft .check")[0]) {
    clear = ""
    if(purl().param("reload") == "true") {
      clear = setInterval(check_turn, 1000);
    }

    $(".draft .check input").click(function(e) {
      if($(".draft .check input").is(':checked')) {
        clear = setInterval(check_turn, 1000);
      } else {
        clearInterval(clear);
      }
    });
  }

  // Feed
  if($(".feed")[0]) {
    setInterval(check_turn, 1000);
  }

  // Order
  $(".super a.admin_modal").click(function(e) {
    var draftID = "#draft" + $(this).data("id");
    $(".draft-order").addClass("hide");
    $(draftID).removeClass("hide");
    e.preventDefault();
  })
});

function check_turn() {
  var draftID = $(".draft .check").data("id");
  var turn = $(".draft .check").data("turn");
  if(draftID && turn) {
    $.get("/drafts/" + draftID +  "/turn", function(data) {
      if (data["turn"] != turn) {
        if(purl().param("reload") == "true") {
          location.reload();
        } else {
          window.location.href = window.location.href + "?reload=true";
        }
      }
    }, "json");
  }
}
