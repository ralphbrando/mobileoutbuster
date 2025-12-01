import 'package:rxdart/rxdart.dart';

import '/backend/schema/structs/index.dart';
import 'custom_auth_manager.dart';

class OutbusterAuthUser {
  OutbusterAuthUser({
    required this.loggedIn,
    this.uid,
    this.userData,
  });

  bool loggedIn;
  String? uid;
  UsersStruct? userData;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<OutbusterAuthUser> outbusterAuthUserSubject =
    BehaviorSubject.seeded(OutbusterAuthUser(loggedIn: false));
Stream<OutbusterAuthUser> outbusterAuthUserStream() =>
    outbusterAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
