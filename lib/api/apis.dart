import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_121/models/chat_user.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing clound firestore database

  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // to return current user

  static User get user => auth.currentUser!;

  // for checking if user exists or not ?
  static Future<bool> userExists() async {
    return (await firebaseFirestore.collection('users').doc(user.uid).get())
        .exists;
  }

  // for creating a new user

  static Future<void> createUser() async {

    final time =DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser =
        ChatUser(
          name: user.displayName.toString(),
          id: user.uid,
          email: user.email.toString(),
          about: "Day la project test",
          image: user.photoURL.toString(),
          createdAt: time,
          isOnline: false,
          lastActive: time,
          pushToken: '',
        );


    return await firebaseFirestore.collection('users').doc(user.uid).set(chatUser.toJson());
  }
}
