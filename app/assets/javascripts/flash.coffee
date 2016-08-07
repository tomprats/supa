window.flash = (message, type) ->
  className = "alert alert-#{type || "notice"} text-center"
  $flash = $("<div class='#{className}'>#{message}</div>")
  $flash.insertAfter(".flash-placeholder")
