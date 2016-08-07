$(document).ready(function() {
  if($(".draft.order").length > 0) {
    $(document).on("click", ".preview-section .move-up", function(e) {
      e.preventDefault()

      var team = $(this).closest(".team")
      var prev = team.prev(".team")
      if(prev.length > 0) {
        team.swapWith(prev)
      }
    });

    $(document).on("click", ".preview-section .move-down", function(e) {
      e.preventDefault()

      var team = $(this).closest(".team")
      var next = team.next(".team")
      if(next.length > 0) {
        team.swapWith(next)
      }
    });

    $(document).on("click", ".preview", function(e) {
      var teams = $(".preview-section .team").map(function() { return $(this).data("id") })
      $(".pick").not(".hide").remove();
      for(var i = 0; i < $(".total").text(); i++) {
        index = i % (teams.length*2);
        if(index >= teams.length) {
          if($(".preview-section select").val() == "Snake") {
            index = teams.length*2 - index - 1;
          } else {
            index = index - teams.length;
          }
        }

        var pick = $(".pick.hide").clone();
        pick.removeClass("hide");
        pick.find(".position").text(i + 1);
        pick.find("select").val(teams[index]);
        $(".pick").parent().append(pick);
      }

      resetCounts()
    });

    $(document).on("click", ".pick .move-up", function(e) {
      e.preventDefault()

      var pick = $(this).closest(".pick")
      var prev = pick.prev(".pick:not(.hide)")
      if(prev.length > 0) {
        pick.swapWith(prev)
        resetCounts()
      }
    });

    $(document).on("click", ".pick .move-down", function(e) {
      e.preventDefault()

      var pick = $(this).closest(".pick")
      var next = pick.next(".pick:not(.hide)")
      if(next.length > 0) {
        pick.swapWith(next)
        resetCounts()
      }
    });

    $(document).on("click", ".pick .add", function(e) {
      e.preventDefault()

      var original = $(this).closest(".pick")
      var pick = original.clone()
      pick.find("select").val(original.find("select").val());
      pick.insertBefore(original);
      resetCounts()
    });

    $(document).on("click", ".pick .delete", function(e) {
      e.preventDefault()

      $(this).closest(".pick").remove();
      resetCounts()
    });

    $(document).on("change", ".pick select", function(e) {
      resetCounts()
    });

    $(document).on("click", ".save", function(e) {
      var picks = $(".pick:not(.hide)").map(function() { return $(this).find("select").val() }).get()
      if(picks.length == parseInt($(".total").text())) {
        $.post(location.pathname, { picks: picks }, function(data) {
          flash("Draft Order Saved", "success");
        });
      } else {
        flash("Number of Picks does not match Number of Registered Players", "danger");
      }
    });
  }
});

function resetCounts() {
  $(".count").text($(".pick:not(.hide)").length);
  $(".team-count").each(function() {
    $this = $(this);
    count = $('.pick:not(.hide) option[value="' + $this.data("id") + '"]:selected').length;
    $this.text(count);
  });
  $(".pick").each(function(index) {
    $(this).find(".position").text(index);
  });
}
