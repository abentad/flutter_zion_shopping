import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

DateTime correctTimeZone(DateTime time) {
  return time.add(const Duration(hours: 3));
}

String formatTime(DateTime time) {
  return DateFormat('yMMMEd').format(time);
}

Future<bool?> callNumber(String number) async {
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  return res;
}

String formatPrice(String? price) {
  return MoneyFormatter(amount: (double.parse(price!))).output.nonSymbol;
}
