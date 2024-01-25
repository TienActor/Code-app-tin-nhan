import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_121/main.dart';
import 'package:test_121/models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _CharUserCard();
}

class _CharUserCard extends State<ChatUserCard> {
 

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 0.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          //user profile picture
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
           child: CachedNetworkImage(
              imageUrl: widget.user.image,
              width: 50,
              height: 50,
               fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          title: Text(widget.user.name), //user name
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
