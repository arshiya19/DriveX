import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class TextStorage {
  bool _initialized = false;

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initialized = true;
    if (kDebugMode) {
      print("Initialized default Firebase app $app");
    }
  }

  TextStorage();

  bool get isInitialized => _initialized;

  Future<Stream<DocumentSnapshot>> getStream() async {
    if (!isInitialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection("rider").doc("ride_id").snapshots();
  }

  Future<bool> writeText(String text) async {
    try {
      if (!isInitialized) {
        await initializeDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection("rider")
          .doc("ride_id")
          .set({"Credentials": text}).then((value) {
        if (kDebugMode) {
          print("Entered Credentials are $text");
        }
        return true;
      }).catchError((error) {
        if (kDebugMode) {
          print("Failed to set Credentials: $error");
        }
        return false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  Future<String> readText() async {
    try {
      if (!isInitialized) {
        await initializeDefault();
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot ds =
      await firestore.collection("rider").doc("ride_id").get();
      if (ds.exists && ds.data() != null) {
        Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
        if (data.containsKey("Credentials")) {
          return data["Credentials"];
        }
      }
      bool writeSuccess = await writeText("google");
      if (writeSuccess) {
        return "written google";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return "nothing";
  }
}