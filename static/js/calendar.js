let today = new Date();
let weeklyView = false;

function loadMonth(date) {
    const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
    const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);
    // console.log(startOfMonth.getDay());

    $("#currentMonthYear").text(`${startOfMonth.toLocaleString('default', { month: 'long' })} ${startOfMonth.getFullYear()}`);
    
    let days = "<tr>";
    for(let i = startOfMonth.getDay(); i > 0; i--){
        days += '<td></td>';
    }
    for (let i = 1; i <= endOfMonth.getDate(); i++) {
        const currentDay = new Date(date.getFullYear(), date.getMonth(), i);
        if (currentDay.getDay() === 0) {
            console.log(currentDay);
            days += '</tr><tr>';
            // console.log(days);
        }
        days += `<td>${i}`;
        events.forEach(event => {
            const eventDate = new Date(event.date);
            if (eventDate.getFullYear() === currentDay.getFullYear() && 
                eventDate.getMonth() === currentDay.getMonth() && 
                eventDate.getDate() === currentDay.getDate()) {
                const badgeColor = event.status === "confirmed" ? "badge-primary" : "badge-warning";
                days += `<div class="badge ${badgeColor} badge-primary badge-event" data-toggle="tooltip" title="Time: ${event.time}\nDescription: ${event.description}\nPlace: ${event.place}\nBooked by: ${event.bookedBy}\nStatus: ${event.status}">${event.title}</div>`;
            }
        });
        days += '</td>';

        // If it's the last day of the month, close the row.
        if (i == endOfMonth.getDate()) {
            days += '</tr>';
        }
    }
    $("#calendarBody").html(days);
    $('[data-toggle="tooltip"]').tooltip();
}

function loadWeek(date) {
    // Setting up startDate to the first day of the week (Sunday)
    let startDate = new Date(date);
    startDate.setDate(startDate.getDate() - startDate.getDay());

    // Building the header for the days of the week
    let headerRows = "<tr class='bg-secondary text-light'><td>Time</td>";
    for (let dayOffset = 0; dayOffset < 7; dayOffset++) {
        let currentDate = new Date(startDate);
        currentDate.setDate(currentDate.getDate() + dayOffset);
        headerRows += `<td>${currentDate.toLocaleString('default', { month: 'short' })} ${currentDate.getDate()}</td>`;
    }
    headerRows += "</tr>";

    let rows = "";
    let occupiedSlots = Array(7).fill().map(() => Array((18 * 2) + 1).fill(false));

    for (let hour = 5; hour <= 22; hour++) {
        for (let minute = 0; minute < 60; minute += 30) {
            let timeStr = minute === 0 ? `${hour.toString().padStart(2, '0')}:00` : "";

            rows += `<tr><td>${timeStr}</td>`;

            for (let dayOffset = 0; dayOffset < 7; dayOffset++) {
                let slotIndex = ((hour - 5) * 2) + (minute / 30);

                if (occupiedSlots[dayOffset][slotIndex]) {
                    continue;  // Skip this <td>, it's occupied by a rowspan
                }

                let currentTime = new Date(startDate);
                currentTime.setDate(currentTime.getDate() + dayOffset);
                currentTime.setHours(hour, minute, 0, 0);

                let matchingEvent = events.find(event => {
                    const eventDate = new Date(event.date);
                    const [startHr, startMin] = event.time.start.split(':').map(Number);
                    const [endHr, endMin] = event.time.end.split(':').map(Number);
                    const startTime = new Date(eventDate);
                    startTime.setHours(startHr, startMin, 0, 0);
                    const endTime = new Date(eventDate);
                    endTime.setHours(endHr, endMin, 0, 0);
                    return eventDate.getDate() === currentTime.getDate() &&
                           eventDate.getMonth() === currentTime.getMonth() &&
                           eventDate.getFullYear() === currentTime.getFullYear() &&
                           currentTime >= startTime && currentTime < endTime;
                });
                const weekEndDate = new Date(startDate);
                weekEndDate.setDate(weekEndDate.getDate() + 6);

                document.getElementById("currentMonthYear").innerText = `${startDate.toLocaleString('default', { day: 'numeric', month: 'short', year:'2-digit' })} - ${weekEndDate.toLocaleString('default', { day: 'numeric', month: 'short', year: '2-digit' })}`;

                if (matchingEvent) {
                    const [startHr, startMin] = matchingEvent.time.start.split(':').map(Number);
                    const [endHr, endMin] = matchingEvent.time.end.split(':').map(Number);
                    const eventStartSlot = ((startHr - 5) * 2) + (startMin / 30);
                    const eventEndSlot = ((endHr - 5) * 2) + (endMin / 30);
                    const rowspan = eventEndSlot - eventStartSlot;

                    for (let i = 0; i < rowspan; i++) {
                        occupiedSlots[dayOffset][slotIndex + i] = true;
                    }

                    const bgColorClass = matchingEvent.status === 'confirmed' ? 'bg-primary' : 'bg-warning';
                    rows += `<td rowspan="${rowspan}" class="${bgColorClass} text-light" title="Time: ${matchingEvent.time.start} - ${matchingEvent.time.end}\nEvent: ${matchingEvent.description}\nPlace: ${matchingEvent.place}\nBooked By: ${matchingEvent.bookedBy}">${matchingEvent.title} (${matchingEvent.time.start}-${matchingEvent.time.end})</td>`;
                } else {
                    rows += "<td></td>";
                }
            }
            rows += "</tr>";
        }
    }

    document.getElementById("weeklyCalendar").innerHTML = headerRows + rows;
}





loadMonth(today);
// Event handlers
$("#weeklyToggle").click((event) => {
    event.preventDefault();
    weeklyView = true;

    if (weeklyView) {
        $("#monthlyCalendar").hide();
        $("#weeklyCalendar").show();
        loadWeek(today);
    } else {
        $("#monthlyCalendar").show();
        $("#weeklyCalendar").hide();
        loadMonth(today);
    }
});

$("#monthlyToggle").click((event) => {
    event.preventDefault();
    weeklyView = false;

    if (weeklyView) {
        $("#monthlyCalendar").hide();
        $("#weeklyCalendar").show();
        loadWeek(today);
    } else {
        $("#monthlyCalendar").show();
        $("#weeklyCalendar").hide();
        console.log('its here');
        loadMonth(today);
    }
});


$("#prev").click((event) => {
    event.preventDefault();
    if (weeklyView) {
        today.setDate(today.getDate() - 7);
        loadWeek(today);
    } else {
        today = new Date(today.getFullYear(), today.getMonth() - 1);
        loadMonth(today);
    }
});

$("#next").click((event) => {
    event.preventDefault();
    if (weeklyView) {
        today.setDate(today.getDate() + 7);
        loadWeek(today);
    } else {
        today = new Date(today.getFullYear(), today.getMonth() + 1);
        loadMonth(today);
    }
});