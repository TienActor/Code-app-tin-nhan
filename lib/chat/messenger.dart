import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(),
      ),
      // them icon bieu tuong o goc man hinh
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add_circle_outlined),
        ),
      ),
    ); // Thay thế bằng widget của bạn
  }
}
