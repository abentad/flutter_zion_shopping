import 'package:intl/intl.dart';

DateTime correctTimeZone(DateTime time) {
  return time.add(const Duration(hours: 3));
}

String formatTime(DateTime time) {
  return DateFormat('yMMMEd').format(time);
}
