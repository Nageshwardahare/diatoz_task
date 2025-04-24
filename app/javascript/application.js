//= require bootstrap
import Rails from "@rails/ujs"
Rails.start()
import "popper"
import "bootstrap"

document.addEventListener("DOMContentLoaded", function() {
  setTimeout(function() {
    document.querySelectorAll(".flash-message").forEach(function(el) {
      el.style.transition = "opacity 0.5s ease-out";
      el.style.opacity = "0";
      setTimeout(() => el.remove(), 500);
    });
  }, 3000);
});