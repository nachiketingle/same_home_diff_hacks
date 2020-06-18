import 'package:samehomediffhacks/Models/User.dart';

class ToWaiting{
  /// Name of event to update waiting room
  String eventName;
  /// Name of event to indicate next action
  String futureEvent;
  /// String of route to the next page
  String nextRoute;
  /// Current user
  User user;
  /// Names of users that we are waiting for
  List<String> remaining;

  ToWaiting(this.user, this.eventName, this.futureEvent, this.nextRoute, this.remaining);
}