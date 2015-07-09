function formHelpers(){
  $('.slider').on("change load mousemove", function() {
		var target = $(this).data("target");
    var targetInverse = $(this).data("target-inverse");
    $(target).html($(this).val());
    $(targetInverse).html($(this).attr('max') - $(this).val());
  });
  $(".skills").chosen({
      disable_search_threshold: 10,
      no_results_text: "That skill isn't on the list (yet)\<br \/\>Maybe you can check again later!",
      placeholder_text_multiple: "Please select your preferred skills"
  });
}

function ready() {
  var uniqueId = 1;
  $('.add_fields').click(function() {
    var target = $(this).data("target");
    var element = $(this).data("element");
    var new_table_row = $(target + ' ' + element + ':last').clone();
    var new_id = new Date().getTime() + (uniqueId++);

    new_table_row.find("input, select, textarea").each(function () {
      var el = $(this);
      el.prop("id", el.prop("id").replace(/\d+/, new_id));
      el.prop("name", el.prop("name").replace(/\d+/, new_id));
    });

    new_table_row.find("input:not([type='checkbox'], [type='hidden']), textarea").each(function () {
      var el = $(this);
      el.val("");
    });

    new_table_row.find("input[type='checkbox']").each(function () {
      var el = $(this);
      el.attr("checked", false);
    });

    new_table_row.find("select").each(function () {
      var el = $(this);
      el.val("");
      el.attr("style", '');
      el.find("option").attr("selected", false);
    });
    new_table_row.find(".chosen-container.chosen-container-multi").each(function () {
      var el = $(this);
      el.remove();
    });

    new_table_row.find(".slider").each(function () {
      var el = $(this);
      el.data("target", el.data("target").replace(/\d+/, new_id));
      el.attr("data-target", el.data("target").replace(/\d+/, new_id));
    });
    new_table_row.find(".slider-score").each(function () {
      var el = $(this);
      el.prop("id", el.prop("id").replace(/\d+/, new_id));
    });
    // When cloning a new row, set the href of all icons to be an empty "#"
    // This is so that clicking on them does not perform the actions for the
    // duplicated row
    new_table_row.find("a").each(function () {
      var el = $(this);
      el.prop('href', '#');
    });
    new_table_row.show();
    $(target).prepend(new_table_row);
    formHelpers();

    return false; // prevent default click action from happening!
    e.preventDefault(); // same thing as above
  })

  $('body').on('click', 'a.remove_fields', function() {
    el = $(this);
    el.siblings("input[type=hidden]").val("true")
    el.parents("tr").fadeOut('hide');
    el.parents(".entry").fadeOut('hide');
    return false;
  });
  formHelpers();
}
$(document).ready(ready);
$(document).on('page:load', ready);
