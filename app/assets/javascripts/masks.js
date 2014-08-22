$(document).ready(function() {
  $("#user_phone_number").mask("(999) 999-9999");
  $("#user_birthday").mask("99/99/9999");
  $("#game_date").pickadate({
    format: "mm/dd/yyyy"
  });
  $("#game_time").pickatime({
    format: "hh:i A",
    interval: 15,
    min: [9, 0],
    max: [21, 0]
  });
  $("#event_date").pickadate({
    format: "mm/dd/yyyy"
  });
  $("#event_time").pickatime({
    format: "hh:i A",
    interval: 15,
    min: [9, 0],
    max: [21, 0]
  });
});
