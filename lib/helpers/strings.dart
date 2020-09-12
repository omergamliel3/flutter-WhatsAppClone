// Strings helper

// convert date time to readable text
String convertDateTimeToText(DateTime dateTime) {
  try {
    return dateTime.toString().split(' ')[1].substring(0, 5);
  } catch (_) {
    return '';
  }
}
