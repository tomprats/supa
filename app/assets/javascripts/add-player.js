$(document).ready(function() {
  $(".add-winner.icon-plus-sign").click(function() {
    addWinner();
  });
  $(".add-loser.icon-plus-sign").click(function() {
    addLoser();
  });
});

function addWinner() {
  var winner = $("#winners .game_team_stats1_player_stats_player_id:last").clone();
  winner = updatePlayer(winner);
  winner.appendTo("#winners .row-fluid");
}

function addLoser() {
  var loser = $("#losers .game_team_stats2_player_stats_player_id:last").clone();
  loser = updatePlayer(loser);
  loser.appendTo("#losers .row-fluid");
}

function updatePlayer(player) {
  var old_name = player.find("select").attr("name");
  var result = /\[[\d]+\]/.exec(old_name).toString();
  var old_index = result.slice(1, -1);
  var new_index = (parseInt(old_index, 10) + 1).toString();
  var new_name = old_name.replace(old_index, new_index);
  return player.html(player.html().replace(old_name, new_name));
}
