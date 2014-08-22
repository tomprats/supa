$(document).ready(function() {
  var owl = $(".owl-carousel");
  owl.owlCarousel({
    nav: true,
    dots: false,
    loop: true,
    margin: 10,
    navText: [
      "<i class='fa fa-chevron-left'></i>",
      "<i class='fa fa-chevron-right'></i>"
    ],
    responsive: {
      0: { items: 1 },
      600: { items: 2 },
      1000: { items: 3 }
    }
  });

  $(document).on("click", ".group-link", function(e) {
    e.preventDefault();

    $(".group").addClass("hide");
    $(".group-" + $(this).data("id")).removeClass("hide");

    return false;
  });
  $(".group-link:first").trigger("click");
});
