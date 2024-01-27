import 'package:flutter/material.dart';
import 'package:test_121/api/apis.dart';
import 'package:test_121/main.dart';
import 'package:test_121/models/message.dart';

class MessengerCard extends StatefulWidget {
  const MessengerCard({super.key, required this.message});

  final Message message;
  @override
  State<MessengerCard> createState() => _MessengerCardState();
}

class _MessengerCardState extends State<MessengerCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessenger()
        : _blueMessenger();
  }

  // sender or another user message
  Widget _blueMessenger() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .03),
            decoration:  BoxDecoration(
                color: const Color.fromARGB(255, 113, 145, 196),
                border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),

        Padding(
          padding:  EdgeInsets.only(right: mq.height*.04),
          child: Text(widget.message.sent,style: const TextStyle(fontSize: 16,color: Colors.black),),
        ),

        //for add space
        SizedBox(width: mq.height*.04),
      ],
    );
  }

  // our or user messenger
  Widget _greenMessenger() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        

        Padding(
          padding:  EdgeInsets.only(right: mq.height*.04),
          child: Text(widget.message.sent,style: const TextStyle(fontSize: 16,color: Colors.black),),
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .03),
            decoration:  BoxDecoration(
                color: Colors.greenAccent,
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
