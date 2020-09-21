import 'package:intl/intl.dart';

/// format date time object to String useing intl package
String formatDateTime(DateTime dateTime) {
  DateFormat formatter;
  final difference = DateTime.now().difference(dateTime).inHours;
  if (difference > 24) {
    formatter = DateFormat('MMM d H:m');
    return formatter.format(dateTime);
  }
  formatter = DateFormat('H:m');
  return formatter.format(dateTime);
}
