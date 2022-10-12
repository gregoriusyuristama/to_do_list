import 'package:intl/intl.dart';

class StringHelper {
  static String firstName(String name) {
    List<String> nameList = name.split(" ");
    if (nameList.isNotEmpty) {
      if (nameList[0].length >= 10) {
        return '${nameList[0].substring(0, 10)}...';
      }
      return nameList[0];
    } else {
      return '';
    }
  }

  static String formatDate(DateTime date) {
    late String day;
    switch (date.weekday) {
      case 1:
        day = 'Monday';
        break;
      case 2:
        day = 'Tuesday';
        break;
      case 3:
        day = 'Wednesday';
        break;
      case 4:
        day = 'Thursday';
        break;
      case 5:
        day = 'Friday';
        break;
      case 6:
        day = 'Saturday';
        break;
      case 7:
        day = 'Sunday';
        break;
    }
    return "$day, ${DateFormat.MMMMd('en_US').format(date)}";
  }
}
