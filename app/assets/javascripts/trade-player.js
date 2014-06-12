$(document).ready(function() {
  $("body").on("change", ".trade-team-1 select", function() {
    tradePlayer(1);
  });
  $("body").on("change", ".trade-team-2 select", function() {
    tradePlayer(2);
  });
});

function tradePlayer(type) {
  var teamSelector = ".trade-team-" + type;
  var playerSelector = ".trade-player-" + type;
  var teamID = $(teamSelector + " select").val();
  var options = $(".team-" + teamID + " option").clone();
  $(playerSelector + " select").empty().append(options);
}
