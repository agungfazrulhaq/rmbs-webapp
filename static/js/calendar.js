function generateMonthCalendarWithPrevious(year, month, bookings) {
const calendar = [];
const startDate = new Date(year, month, 1);
const endDate = new Date(year, month + 1, 0);
const firstDayOfWeek = startDate.getDay();

// Calculate the date for the start of the previous month
const prevMonthEndDate = new Date(year, month, 0);
const daysInPrevMonth = prevMonthEndDate.getDate();
const prevMonthStartDate = new Date(prevMonthEndDate);
prevMonthStartDate.setDate(prevMonthStartDate.getDate() - firstDayOfWeek + 1);

let currentDate = new Date(prevMonthStartDate);

while (currentDate <= endDate) {
	const week = [];
	for (let i = 0; i < 7; i++) {
		week.push(new Date(currentDate));
		currentDate.setDate(currentDate.getDate() + 1);
	}
	calendar.push(week);
}

// Create and populate the HTML table
const table = document.getElementById('thecalendar');

console.log(bookings)

for (const week of calendar) {
	const tr = document.createElement('tr');
	for (const day of week) {
		const td = document.createElement('td');
		const year_ = day.getFullYear();
		const month_ = String(day.getMonth() + 1);
		const day_ = String(day.getDate());
		const current_date_ = `${year_}-${month_}-${day_}`;
		console.log(current_date_);
		if (bookings[current_date_]) {
			td.innerHTML= "<a href='"+ bookings[current_date_][1] +"'>"+day.getDate()+"</a>";
			td.title = bookings[current_date_][0]; // Set the tooltip text
			td.classList.add('has-bookings');

			const tooltip = document.createElement('span');
			tooltip.className = 'tltip';
			const tooltipText = document.createElement('span');
			tooltipText.className = 'tltip-text';
			tooltipText.textContent = bookings[current_date_][0];
			tooltip.appendChild(tooltipText);
			td.appendChild(tooltip);
		} else {
			td.innerHTML = day.getDate();
		}
		tr.appendChild(td);
	}
	table.appendChild(tr);
}

return table;
}

// Create a new Date object, which represents the current date and time.
const currentDate = new Date();

// Get the current month (0 for January, 1 for February, and so on...)
const currentMonth = currentDate.getMonth();
const currentYear = currentDate.getFullYear();

// Example usage:
let year = currentYear;
let month = currentMonth; // Note: January is 0, February is 1, and so on...

// const bookings = {
// 	'2023-9-5': ['Event 1', 'Event 2'],
// 	'2023-9-12': ['Event 3'],
// 	'2023-9-19': ['Event 4'],
// };

// Function to generate and display the calendar for a specific month and year
function displayCalendar(year, month, bookings) {
	const currentdate = new Date(year, month);
	const monthName = currentdate.toLocaleString('en-US', { month: 'long' });

	document.getElementById("currentmonthheader").innerHTML = monthName + " " + year;
	const calendarContainer = document.getElementById('thecalendar');
	calendarContainer.innerHTML = '<tr><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th><th>Sun</th></tr>'; // Clear previous calendar
	const calendarTable = generateMonthCalendarWithPrevious(year, month, bookings);
  }
  
  // Event listener for the "Next Month" button
document.getElementById('nextBtn').addEventListener('click', () => {
	month++;
	if (month > 11) {
	  month = 0;
	  year++;
	}
	displayCalendar(year, month, bookings);
  });
  
  // Event listener for the "Previous Month" button
  document.getElementById('prevBtn').addEventListener('click', () => {
	month--;
	if (month < 0) {
	  month = 11;
	  year--;
	}
	displayCalendar(year, month, bookings);
  });

// Initial display of the calendar
displayCalendar(currentYear, currentMonth, bookings);