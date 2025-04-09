String formatIso8601Date(String isoDateString) {
  try {
    DateTime dateTime = DateTime.parse(isoDateString)
        .toLocal(); // Parse and convert to local time

    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1]; // Month is 1-based index
    final year = dateTime.year;

    int hour = dateTime.hour;
    final minute = dateTime.minute;
    final amPm = hour < 12 ? 'am' : 'pm';

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12; // Midnight is 12 am
    }

    return '${day}th ${month} ${year}, ${hour}:${minute.toString().padLeft(2, '0')} ${amPm}';
  } catch (e) {
    print('Error formatting date: $e');
    return 'Not Updated';
  }
}
