document.addEventListener("DOMContentLoaded", function() {
    // Approve Button Click Event
    document.querySelectorAll('.approve-btn').forEach(button => {
      button.addEventListener('click', function(event) {
        const loanId = event.target.getAttribute('data-loan-id');
        if (confirm('Are you sure you want to approve this loan?')) {
          fetch(`/loans/${loanId}/approve`, {
            method: 'PATCH',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
            }
          })
          .then(response => response.text())
          .then(html => {
            // Turbo Stream will handle updating the page
          })
          .catch(error => console.error('Error:', error));
        }
      });
    });
  
    // Reject Button Click Event
    document.querySelectorAll('.reject-btn').forEach(button => {
      button.addEventListener('click', function(event) {
        const loanId = event.target.getAttribute('data-loan-id');
        if (confirm('Are you sure you want to reject this loan?')) {
          fetch(`/loans/${loanId}/reject`, {
            method: 'PATCH',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
            }
          })
          .then(response => response.text())
          .then(html => {
            // Turbo Stream will handle updating the page
          })
          .catch(error => console.error('Error:', error));
        }
      });
    });
  });
  