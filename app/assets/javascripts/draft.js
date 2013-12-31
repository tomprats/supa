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

  // View/Edit Group Swap
  $(".draft .group a").click(function(e) {
    var groupID = $(this).data("id");
    var first = "#" + $(this).data("type") + groupID;
    var second = "#" + $(this).data("not") + groupID;
    $(first).toggleClass("hide");
    $(second).toggleClass("hide");
    $(first).swapWith(second);
    e.preventDefault();
  })

  // Order
  $(".super a.admin_modal").click(function(e) {
    var draftID = "#draft" + $(this).data("id");
    $(".draft-order").addClass("hide");
    $(draftID).removeClass("hide");
    e.preventDefault();
  })

  // Add Player
  $(".draft .group a.add-player").click(function(e) {
    var data = $(this).data("id");
    if(data) {
      var groupID = "editable" + data;
    } else {
      var groupID = "add"
    }
    var empty = $(".draft .group#" + groupID + " .add-here:last").clone();

    empty.find(".span3 select").each(function() {
      var name = $(this).attr("name");
      var result = /\[[\d]+\]/.exec(name).toString();
      var old_index = result.slice(1, -1);
      var new_index = (parseInt(old_index, 10) + 1).toString();
      name = name.replace(old_index, new_index);
      $(this).attr("name", name);
    });

    empty.find(".span3 input").each(function() {
      var name = $(this).attr("name");
      var result = /\[[\d]+\]/.exec(name).toString();
      var old_index = result.slice(1, -1);
      var new_index = (parseInt(old_index, 10) + 1).toString();
      name = name.replace(old_index, new_index);
      $(this).attr("name", name);
    });

    empty.insertAfter(".draft .group#" + groupID + " .add-here:last");
    e.preventDefault();
  });
});

function check_turn() {
  var draftID = $(".draft .check").data("id");
  var turn = $(".draft .check").data("turn");
  $.get("/drafts/" + draftID +  "/turn", function(data) {
    console.log(data);
    if (data["turn"] != turn) {
      if(purl().param("reload") == "true") {
        location.reload();
      } else {
        window.location.href = window.location.href + "?reload=true";
      }
    }
  }, "json");
}
