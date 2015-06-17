function registration_ready() {
  $("#friends").chosen({
      disable_search_threshold: 10,
      no_results_text: "That person isn't on the list (yet)\<br \/\>Maybe you can check again later!",
      placeholder_text_multiple: "Please select your preferred partners"
  });
}
$(document).ready(registration_ready);
$(document).on('page:load', registration_ready);
