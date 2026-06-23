import 'package:routelearn/Data/models/activity.dart';
import 'package:routelearn/Data/models/commute.dart';

class CommuteView {
  final Commute commute;
  final Activity activity;
  final int day;

  CommuteView({
    required this.commute,
    required this.activity,
    required this.day,
  });
}
