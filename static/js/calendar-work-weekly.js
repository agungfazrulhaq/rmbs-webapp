// Function to generate rows for each 30 minutes from 07:00 to 21:00
function generateRows() {
    const tableBody = document.getElementById('schedule-body');
    for (let hour = 7; hour <= 21; hour++) {
        for (let minute = 0; minute < 60; minute += 30) {
            const time = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
            const row = document.createElement('tr');
            row.innerHTML = `<th class="time-cell">${time}</th>`;
            for (let day = 1; day <= 5; day++) {
                row.innerHTML += '<td></td>'; // You can fill in data for each cell if needed
            }
            tableBody.appendChild(row);
        }
    }
}

// Call the function to generate the rows
generateRows();