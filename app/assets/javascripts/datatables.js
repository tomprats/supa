$(document).ready( function () {
  // Simple data-table setup
  $(".data-table-lite").each(function() {
    var $table = $(this);

    $table.DataTable({
      "bPaginate": false,
      "bSort": true,
      "bSortClasses": false,
      "sDom": '<"dt-content"rt>'
    });
  });

  // Default datatable setup
  $(".data-table").each(function() {
    var $table = $(this);

    // For the default sorting
    var defaultSort = [];
    $table.find("th.default-sort").each(function() {
      var $element = $(this);
      order = $element.data("order") || 0;
      index = $table.find("th").index($element);
      direction = $element.data("dir") || "asc";
      defaultSort.push([order, index, direction]);
    });
    defaultSort.sort(function(a, b) {
      return a[0] - b[0]; // sort ascending
    });
    for(var i=0; i < defaultSort.length; i++) {
      defaultSort[i].splice(0, 1); // Remove order attribute
    }

    // For the action columns
    var dontSort = [];
    $table.find("th.dont-sort").each(function() {
      dontSort.push($table.find("th").index($(this)));
    });

    $table.DataTable({
      "bPaginate": true,
      "bSort": true,
      "bSortClasses": false,
      "aaSorting": defaultSort,
      "aoColumnDefs": [{ "asSorting": [], "bSearchable": false, "aTargets": dontSort }],
      "sDom": '<"search">f<"dt-content"rt>ilp<"clearfix">',
      "sPaginationType": "bootstrap"
    });
  });

  $(".dataTables_filter").each(function(){
    var $this = $(this);
    $this.closest(".dataTables_wrapper").siblings("h3").append($this);
  })
  $(".dt-content .table-footer").append($(".dt-content #table_id_info"));
  $(".dt-content #table_id_info").addClass("pagination");
  $(".dt-content .table-footer").append($(".dt-content #table_id_length"));
  $(".dt-content #table_id_length").addClass("pagination");
  $(".dt-content .table-footer").append($(".dt-content #table_id_paginate"));
});
