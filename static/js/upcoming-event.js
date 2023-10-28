document.addEventListener('DOMContentLoaded', function() {
    const eventListUl = document.getElementById('events-list');
  
    events.sort((a, b) => new Date(`${a.date}T${a.time.start}`) - new Date(`${b.date}T${b.time.start}`));
  
    const now = new Date();
    const upcomingEvents = events.filter(event => new Date(`${event.date}T${event.time.start}`) > now).slice(0, 5);
  
    if (upcomingEvents.length === 0) {
        // Condition for no upcoming events
        const listItem = document.createElement('li');
        listItem.classList.add('list-group-item');
        listItem.innerHTML = "No upcoming events";
        eventListUl.appendChild(listItem);
      } else {
        upcomingEvents.forEach(event => {
          const listItem = document.createElement('li');
          listItem.classList.add('list-group-item', 'hoverable-box');
          
          const badgeColor = event.status === 'confirmed' ? 'primary' : 'warning';
          
          listItem.innerHTML = `
            <span class="badge badge-${badgeColor}">${event.date}</span> - ${event.title}
          `;
          
          listItem.setAttribute('data-toggle', 'tooltip');
          listItem.setAttribute('data-placement', 'top');
          listItem.setAttribute('title', `Time: ${event.time.start} - ${event.time.end}\nDescription: ${event.description}\nPlace: ${event.place}\nStatus: ${event.status}`);
          
          eventListUl.appendChild(listItem);
        });
  
        // Initialize tooltips
        $('[data-toggle="tooltip"]').tooltip();
      }
  });
  