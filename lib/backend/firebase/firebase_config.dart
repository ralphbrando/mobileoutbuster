import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAYdt25hpCDPMzfBjmlS2eFtnq120_S6as",
            authDomain: "drama-73c3c.firebaseapp.com",
            projectId: "drama-73c3c",
            storageBucket: "drama-73c3c.firebasestorage.app",
            messagingSenderId: "165104845659",
            appId: "1:165104845659:web:a643f9af57617509f4107e",
            measurementId: "G-TMJH9V3P9C"));
  } else {
    await Firebase.initializeApp();
  }
}
