import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_121/auth/view_profile_screen.dart';
import 'package:test_121/main.dart';
import 'package:test_121/models/chat_user.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(children: [
          //user profile picture
          Positioned(
             left: mq.width*.1,
            top: mq.height*.07,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .25),
              child: CachedNetworkImage(
                width: mq.width * .5,
                fit: BoxFit.fill,
                imageUrl: user.image,
                errorWidget: (context, url, error) => Container(
                  width: mq.height * .2,
                  height: mq.height * .2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    color: Colors.grey, // Màu của placeholder
                  ),
                  child: Icon(Icons.person, size: mq.height * .1),
                ),
              ),
            ),
          ),
          Positioned(
            left: mq.width * .04,
            top: mq.height * .02,
            child: Text(
              user.name,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
              right: 8,
              top: 4,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> ViewProfileScreen(user: user)));
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                minWidth: 0,
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.blueAccent,
                  size: 30,
                ),
              ))
        ]),
      ),
    );
  }
}
