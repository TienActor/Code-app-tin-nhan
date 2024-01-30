import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test_121/models/chat_user.dart';
import 'package:test_121/models/message.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for saving self information
  static late ChatUser me;

  //for accessing clound firestore database
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //for accessing firestore database
  static FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://test-121-f65b0.appspot.com');

  // static FirebaseStorage storage = FirebaseStorage.instance;

  // to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase firebase messaging  (Push notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t)  {
      if(t!=null)
      {
        me.pushToken=t;
        log('Push token $t');
      }
    });
  }

  // for checking if user exists or not ?
  static Future<bool> userExists() async {
    return (await firebaseFirestore.collection('users').doc(user.uid).get())
        .exists;
  }

  // for checking if user exists or not ?
  static Future<void> getSelfInfo() async {
    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async  {
              if (user.exists)
                {
                  me = ChatUser.fromJson(user.data()!);
                  getFirebaseMessagingToken();
                  log('My data is : ${user.data()}');
                }
              else
                {await createUser().then((value) => getSelfInfo());}
            });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Đây là project test",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

// for getting all users form fire store
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firebaseFirestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for update user infor
  static Future<void> updateUserInfo() async {
    firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  //update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extention
    final ext = file.path.split('.').last;
    log('Extention: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_picture/ ${user.uid}.$ext');

    //upload image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Tranfered : ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  // for getting specific user info

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firebaseFirestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status for user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firebaseFirestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().microsecondsSinceEpoch.toString(),
      'push_token': me.pushToken
    });
  }

  /// Chat screen related APIs   cai dat cac function xu ly du lieu
  /// useful for getting conversation id

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messenger form fire store
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessenger(
      ChatUser user) {
    return firebaseFirestore
        .collection('chats/${getConversationID(user.id)}/messenger/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // For sending messages
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    // Message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // Message to send
    final Message message = Message(
        msg: msg,
        read: '',
        toId: chatUser.id,
        type: type,
        fromId: user.uid,
        sent: time);

    // Directly get a DocumentReference to the new document
    final DocumentReference docRef = firebaseFirestore
        .collection('chats/${getConversationID(chatUser.id)}/messenger/')
        .doc(time);

    // Set the data for the new document
    await docRef.set(message.toJson());
  }

  //update read status of message

  static Future<void> updateMessageReadStatus(Message message) async {
    firebaseFirestore
        .collection('chats/${getConversationID(message.fromId)}/messenger/')
        .doc(message.sent)
        .update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
  }

  // get only last message of a specific chat

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firebaseFirestore
        .collection('chats/${getConversationID(user.id)}/messenger/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // send image chat
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extention
    final ext = file.path.split('.').last;
    log('Extention: $ext');

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().microsecondsSinceEpoch}.$ext');

    //upload image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Tranfered : ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database

    final imageUrl = await ref.getDownloadURL();
    await APIs.sendMessage(chatUser, imageUrl, Type.image);
  }
}
