// document.addEventListener('DOMContentLoaded', function() {
    // Get the current URL path
    const path = window.location.pathname;
    
    if (path.startsWith('/booking')) {
        // Find elements with the class 'this-menu'
        const thisMenuElements = document.getElementById('collapseTwo');
        
        // Add the 'active' class to those elements
        if (thisMenuElements) {
          thisMenuElements.classList.add('show');
        }
    };

    // Check if the URL path matches '/room'
    if (path === '/booking/schedules') {
      // Find the element with ID 'room-menu'
      const scheduleMenuElement = document.getElementById('bookingSchedule');
  
      // Add the 'active' class to the element
      if (scheduleMenuElement) {
        scheduleMenuElement.classList.add('active');
      }
    };

    // Check if the URL path matches '/room'
    if (path === '/booking/form') {
        // Find the element with ID 'room-menu'
        const bookingMenuElement = document.getElementById('bookingForm');

        // Add the 'active' class to the element
        if (bookingMenuElement) {
          bookingMenuElement.classList.add('active');
        }
      };
//   });
    if (path === '/booking/rooms') {
      // Find the element with ID 'room-menu'
      const bookingMenuElement = document.getElementById('bookingRooms');

      // Add the 'active' class to the element
      if (bookingMenuElement) {
        bookingMenuElement.classList.add('active');
      }
    };
  