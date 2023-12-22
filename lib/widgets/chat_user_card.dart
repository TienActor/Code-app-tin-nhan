import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_121/main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _CharUserCard();
}

class _CharUserCard extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width *.04,vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person_alt),),
          title: Text('User name'),
          subtitle: Text('Last messenger user',maxLines: 1,),
          trailing: Text('12:00 pm',style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
