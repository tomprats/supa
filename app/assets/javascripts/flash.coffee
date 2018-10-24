window.flash = (message, type) ->
  window.location.href = "#reloading-alert"
  className = "alert alert-#{type || "success"} text-center"
  $flash = $("<div id='alert' class='#{className}'>#{message}</div>")
  $flash.insertAfter(".flash-placeholder")
  window.location.href = "#alert"
