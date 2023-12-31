// import 'dart:convert';
// import 'dart:developer';
// import 'dart:html';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_121/models/chat_user.dart';

import '../main.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:test_121/api/apis.dart';
// import 'package:test_121/widgets/chat_user_card.dart';
// import 'package:test_121/main.dart';
// import 'package:test_121/widgets/chat_user_card.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0; // Index của tab hiện tại

  @override
  Widget build(BuildContext context) {
    // Sử dụng MediaQuery để lấy thông tin kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Điều chỉnh kích thước dựa trên kích thước màn hình
    // double iconSize = screenWidth * 0.06; // Khoảng 6% chiều rộng màn hình
    // double fontSize = screenHeight * 0.02; // Khoảng 2% chiều cao màn hình
    // double tabBarHeight = screenHeight * 0.12; // Khoảng 12% chiều cao màn hình

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        // title cho trang tin nhan
        title: const Text('Thông tin người dùng ',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 25,
            )),
        //them icon search va phim chuc nang cho icon
        backgroundColor: Colors.blueAccent,
        actionsIconTheme: const IconThemeData(),
      ),
      // them icon bieu tuong o goc man hinh
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          },
          icon: const Icon(Icons.logout_rounded),
          label:const Text('Dang xuat')
        ),
      ),

      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(54),
        child: Column(
          children: [
             SizedBox(height: screenWidth * 0.05), // Khoảng cách nhỏ phía trên



            //  CircleAvatar(
            //   radius: screenWidth * 0.3, // Bán kính avatar bằng 30% chiều rộng màn hình
            //   backgroundImage: CachedNetworkImageProvider(widget.user.image),
            // ),
        
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CachedNetworkImage(
                imageUrl: widget.user.image,
                width: screenWidth*.6,
                height: screenHeight*.4,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),

             SizedBox(height: screenWidth * 0.05),
            Text(widget.user.email,style: const TextStyle(color: Colors.black,fontSize: 18),),

            //for adding some space
             SizedBox(height: screenWidth*.09,),


            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                prefixIcon:const Icon(Icons.person_4,color: Colors.blue,),
                border:  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Vui lòng nhập tên mới',
                label: const Text('Tên người dùng') 
              ),
            ),


            //for adding some space
             SizedBox(height: screenWidth*.09,),


            TextFormField(
              initialValue: widget.user.about,
              decoration: InputDecoration(
                prefixIcon:const Icon(Icons.note_add,color: Colors.blue,),
                border:  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Vui lòng nhập trạng thái',
                label: const Text('Trạng thái') 
              ),
            ),

            SizedBox(height: screenWidth*.04,),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text('Update'))
          ],
        ),
      ),
    );
  }
}
