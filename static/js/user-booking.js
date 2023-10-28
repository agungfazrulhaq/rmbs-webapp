
document.addEventListener('DOMContentLoaded', function() {
    const bookingListUl = document.getElementById('bookings-list');
  
    if (eventsbyusers.length === 0) {
        // Condition for no upcoming events
        const listItem = document.createElement('li');
        listItem.classList.add('list-group-item');
        listItem.innerHTML = "No upcoming events";
        bookingListUl.appendChild(listItem);
      } else {
        eventsbyusers.forEach(event => {
          const listItem = document.createElement('li');
          listItem.classList.add('list-group-item', 'hoverable-box');
          
          const badgeColor = event.status === 'confirmed' ? 'primary' : 'warning';
          
          listItem.innerHTML = `
            <span class="badge badge-${badgeColor}">${event.date}</span> - ${event.title}
          `;
          
          listItem.setAttribute('data-toggle', 'tooltip');
          listItem.setAttribute('data-placement', 'top');
          listItem.setAttribute('title', `Time: ${event.time.start} - ${event.time.end}\nDescription: ${event.description}\nPlace: ${event.place}\nStatus: ${event.status}`);
          
          bookingListUl.appendChild(listItem);
        });
  
        // Initialize tooltips
        $('[data-toggle="tooltip"]').tooltip();
      }
  });
  