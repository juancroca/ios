var page_ready = function() {
	$('.slider').on("change load mousemove", function() {
		var target = $(this).data("target");
    $(target).html($(this).val());
  });
};


$(document).ready(page_ready);
$(document).on('page:load', page_ready);
