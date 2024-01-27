import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_121/api/apis.dart';
import 'package:test_121/main.dart';
import 'package:test_121/models/message.dart';
import 'package:test_121/widgets/messenger_card.dart';

import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //su dung cho viec luu tru tin nhan
  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //app Bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),


          // thay doi mau man hinh giao dien 
          backgroundColor: Colors.white,

          // hien thi man hinh chat
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  // xử lý dữ liệu từ firebase và hiển thị lên màn hình
                  stream: APIs.getAllMessenger(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        log('Data:${jsonEncode(data![0].data())}');
                        // _list = data
                        //         ?.map((e) => Message.fromJson(e.data()))
                        //         .toList() ??
                        //     [];
                        // final _list = [];

                        // final data = snapshot.data?.docs;
                        // _list =
                        //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                        _list.clear();
                        _list.add(Message(
                            msg: 'Toi la tien',
                            read: '',
                            toId: 'xyz',
                            type: Type.text,
                            fromId: APIs.user.uid,
                            sent: '12:00 am'));
                        _list.add(Message(
                            msg: 'Day la mau thu',
                            read: '',
                            toId: APIs.user.uid,
                            type: Type.text,
                            fromId: 'fromId',
                            sent: '12:05 am'));

                        if (_list.isNotEmpty) {
                          // Show user list if it is not empty.
                          return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: mq.height * .01),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessengerCard(
                                message: _list[index],
                              );
                            },
                          );
                        } else {
                          // Show this when the list is empty.
                          return const Center(
                            child: Text(
                              'Nhắn để trò  chuyện !!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              _chatInput()
            ],
          )),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          //back button
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          //user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: widget.user.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),

          // for adding some space
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Lan cuoi truy cap',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .03, horizontal: mq.width * .03),
      child: Row(
        children: [
          //input text chat and button
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 26,
                      )),

                  // chat space
                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Vui long nhap tin nhan',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  // image button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  // camera  button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueAccent,
                        size: 26,
                      ))
                ],
              ),
            ),
          ),

          //send messenger button
          MaterialButton(
            onPressed: () {},
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.lightGreen,
            child: const Icon(
              Icons.send,
              color: Colors.blueGrey,
              size: 29,
            ),
          )
        ],
      ),
    );
  }
}
