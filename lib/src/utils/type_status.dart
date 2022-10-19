part of constants;


class TypeStatus {
  static Color getTaskStatusColor(int status) {
    switch (status) {
      case 3:
        return Colors.lightBlue;
      case 2:
        return Colors.amber[700]!;
      default:
        return Colors.redAccent;
    }
  }

  static String taskStatustoStringValue(int status) {
    switch (status) {
      case 3:
        return "结束";
      case 2:
        return "进行中";
      default:
        return "待执行";
    }
  }
}