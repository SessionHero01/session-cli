import 'dart:io';

import 'package:dart_date/dart_date.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatForMessageRelative() {
    var now = DateTime.now();

    if (isSameDay(now)) {
      return DateFormat.jm().format(this);
    }

    if (differenceInDays(now) == 1) {
      return 'Yesterday ${DateFormat.jm().format(this)}';
    }

    return DateFormat.yMd(Platform.localeName).add_jm().format(this);
  }
}
