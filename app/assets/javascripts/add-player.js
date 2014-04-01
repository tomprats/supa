$(document).ready(function() {
  $(".add-player1.fa-plus-circle").click(function() {
    addPlayer(1);
  });
  $(".add-player2.fa-plus-circle").click(function() {
    addPlayer(2);
  });
  $("#team1 .delete, #team2 .delete").click(function(e) {
    $(this).closest(".row-fluid").remove();
    e.preventDefault();
  });
});

function addPlayer(type) {
  var selector = "#team" + type;
  var player = $(selector + " select:last").closest(".row-fluid").clone();
  player = updatePlayer(player);
  player.appendTo(selector + " .players");
}

function updatePlayer(player) {
  var old_name = player.find("select").attr("name");
  var result = /\[[\d]+\]/.exec(old_name).toString();
  var old_index = result.slice(1, -1);
  var new_index = (parseInt(old_index, 10) + 1).toString();
  var new_name = old_name.replace(old_index, new_index);
  return player.html(player.html().replace(old_name, new_name));
}
