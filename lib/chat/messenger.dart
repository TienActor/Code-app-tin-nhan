// import 'dart:convert';
// import 'dart:developer';
// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_121/api/apis.dart';
import 'package:test_121/models/chat_user.dart';
import 'package:test_121/widgets/chat_user_card.dart';
// import 'package:test_121/main.dart';
// import 'package:test_121/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        // title cho trang tin nhan
        title: const Text('Tin nhắn',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 25,
            )),
        //them icon search va phim chuc nang cho icon
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(),
      ),
      // them icon bieu tuong o goc man hinh
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_circle_outlined),
        ),
      ),

      body: StreamBuilder(
        stream: APIs.firebaseFirestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;

              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                // Hiển thị danh sách người dùng nếu list không rỗng.
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ChatUserCard(user: list[index]);
                  },
                );
                // TODO: Handle this case.
              } else {
                return const Center(
                    child: Text(
                  'Không có dữ liệu',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ));
              }
          }
        },
      ),
    ); // Thay thế bằng widget của bạn
  }
}
