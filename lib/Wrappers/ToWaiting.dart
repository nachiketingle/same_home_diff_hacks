import 'package:samehomediffhacks/Models/User.dart';

class ToWaiting{
  String eventName;
  String futureEvent;
  String nextRoute;
  User user;
  List<String> remaining;

  ToWaiting(this.user, this.eventName, this.futureEvent, this.nextRoute, this.remaining);
}