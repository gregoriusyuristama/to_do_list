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
}
