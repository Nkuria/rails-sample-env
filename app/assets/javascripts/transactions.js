$(document).ready(function() {
  $(".add-deal").click(function(e) {
    e.preventDefault();

    let template = $(this).data("fields"); // Get the fields from the data attribute
    let newId = new Date().getTime(); // Unique ID for new deal
    let newFields = template.replace(/new_deal/g, newId); // Replace placeholder with new ID

    $("#deals-fields").append(newFields);
  });

  $("#deals-fields").on("click", ".remove-deal", function(e) {
    e.preventDefault();
    let dealItem = $(this).closest(".deal-item");

    // If the deal exists in the DB, mark it for deletion
    let hiddenDestroyField = dealItem.find("input[name*='[_destroy]']");
    if (hiddenDestroyField.length) {
      hiddenDestroyField.val("1"); // Rails will remove it
      dealItem.hide(); // Hide it visually
    } else {
      dealItem.remove(); // Otherwise, just remove it
    }
  });
});
