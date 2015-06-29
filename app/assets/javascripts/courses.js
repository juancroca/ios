var page_ready = function() {
	$('#iterations').on("change load mousemove", function() {
      $('#iterationsVal').html($(this).val());
    });
};


$(document).ready(page_ready);
$(document).on('page:load', page_ready);
