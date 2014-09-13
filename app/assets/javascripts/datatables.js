$(document).ready( function () {
  // Simple data-table setup
  $(".data-table-lite").each(function() {
    var $table = $(this);
    var defaultSortArray = defaultSort($table);
    var dontSortArray = dontSort($table);

    $table.DataTable({
      "bPaginate": false,
      "bSort": true,
      "bSortClasses": false,
      "aaSorting": defaultSortArray,
      "aoColumnDefs": [{ "asSorting": [], "bSearchable": false, "aTargets": dontSortArray }],
      "sDom": '<"dt-content"rt>'
    });
  });

  // Default datatable setup
  $(".data-table").each(function() {
    var $table = $(this);
    var defaultSortArray = defaultSort($table);
    var dontSortArray = dontSort($table);

    $table.DataTable({
      "bPaginate": true,
      "bSort": true,
      "bSortClasses": false,
      "aaSorting": defaultSortArray,
      "aoColumnDefs": [{ "asSorting": [], "bSearchable": false, "aTargets": dontSortArray }],
      "sDom": '<"search">f<"dt-content"rt>ilp<"clearfix">',
      "sPaginationType": "bootstrap"
    });
  });

  $(".dataTables_filter").html($(".dataTables_filter input"));
  $(".dataTables_filter input").attr("placeholder", "Search the table")
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

var defaultSort = function($table) {
  var array = [];
  $table.find("th.default-sort").each(function() {
    var $element = $(this);
    order = $element.data("order") || 0;
    index = $table.find("th").index($element);
    direction = $element.data("dir") || "asc";
    array.push([order, index, direction]);
  });
  array.sort(function(a, b) {
    return a[0] - b[0]; // sort ascending
  });
  for(var i=0; i < array.length; i++) {
    array[i].splice(0, 1); // Remove order attribute
  }
  return array;
}

var dontSort = function($table) {
  var array = [];
  $table.find("th.dont-sort").each(function() {
    array.push($table.find("th").index($(this)));
  });
  return array;
}
