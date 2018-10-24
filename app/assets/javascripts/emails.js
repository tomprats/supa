$(document).ready(function(){
  $(".email-action").on("ajax:success", function(e, data){
    if(data.success){
      window.location.href = "/super/emails";
    }else{
      flash(data.error, "danger");
    }
  });

  $("#email-form").on("ajax:success", function(e, data){
    if(data.success){
      window.location.href = "/super/emails";
    }else{
      $flash = $("<div class='alert alert-danger text-center'>" + data.error + "</div>");
      $flash.prependTo("#email-form");
    }
  });

  if($("#email-form #email_body").length > 0){
    previewBody = function(body){
      converter = new Markdown.Converter();
      preview = converter.makeHtml(body);
      $("#email-form #email_body_preview").html(preview);
    };

    previewBody($("#email-form #email_body").val());
    $("#email-form #email_body").on("input", function(e){
      previewBody(e.target.value);
    });
  }
});
