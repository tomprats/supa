$(document).ready( function () {
  // Simple data-table setup
  $(".data-table-lite").each(function() {
    var $table = $(this);

    $table.DataTable({
      "bSort": true,
      "bSortClasses": false,
      "sDom": '<"panel-body"rt>'
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
      "sDom": '<"search">f<"panel-body"rt>ilp<"clearfix">',
      "sPaginationType": "bootstrap"
    });
  });

  $(".dataTables_filter").prepend();
  $(".panel-body .table-footer").append($(".panel-body #table_id_info"));
  $(".panel-body #table_id_info").addClass("pagination");
  $(".panel-body .table-footer").append($(".panel-body #table_id_length"));
  $(".panel-body #table_id_length").addClass("pagination");
  $(".panel-body .table-footer").append($(".panel-body #table_id_paginate"));
});
