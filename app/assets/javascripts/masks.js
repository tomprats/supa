jQuery(function($){
  $("#user_phone_number").mask("(999) 999-9999");
  $("#user_birthday").mask("99/99/9999");
  $("#game_date").pickadate({
    format: "mm/dd/yyyy"
  });
  $("#game_time").pickatime({
    format: "hh:i A"
  });
});
