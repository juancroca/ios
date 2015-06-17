function ready() {
  var uniqueId = 1;
  $('.add_fields').click(function() {
    var target = $(this).data("target");
    var element = $(this).data("element");
    var new_table_row = $(target + ' ' + element + ':last').clone();
    new_table_row.show();
    var new_id = new Date().getTime() + (uniqueId++);
    new_table_row.find("input, select, textarea").each(function () {
      var el = $(this);
      el.val("");
      el.prop("id", el.prop("id").replace(/\d+/, new_id))
      el.prop("name", el.prop("name").replace(/\d+/, new_id))
    })
    // When cloning a new row, set the href of all icons to be an empty "#"
    // This is so that clicking on them does not perform the actions for the
    // duplicated row
    new_table_row.find("a").each(function () {
      var el = $(this);
      el.prop('href', '#');
    })
    $(target).prepend(new_table_row);
  })

  $('body').on('click', 'a.remove_fields', function() {
    el = $(this);
    el.siblings("input[type=hidden]").val("true")
    el.parents("tr").fadeOut('hide');
    return false;
  });
}
$(document).ready(ready);
$(document).on('page:load', ready);
