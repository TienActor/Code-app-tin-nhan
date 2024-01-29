import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_121/helper/my_date_util.dart';
import 'package:test_121/models/chat_user.dart';
import 'package:test_121/main.dart';

//view profile another user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          //back button
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black54)),
          centerTitle: true,
          elevation: 1,
          // title cho trang tin nhan
          title: Text('Thông tin ${widget.user.name}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 25,
              )),

          //them icon search va phim chuc nang cho icon
          backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading:
              false, // Thêm dòng này vào cấu hình của AppBar
          actionsIconTheme: const IconThemeData(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tham gia ứng dụng vào :',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            Text(
              MyDateUtil.getLastMessage(context: context, time: widget.user.createdAt,showYear:true),
              style: const TextStyle(color: Colors.black38, fontSize: 18),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .1),
                child: CachedNetworkImage(
                  width: mq.height * .2,
                  height: mq.height * .2,
                  fit: BoxFit.fill,
                  imageUrl: widget.user.image,
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

              SizedBox(
                height: mq.height * .02,
              ),
              Text(
                widget.user.email,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),

              //for adding some space
              SizedBox(
                height: mq.height * .02,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Trạng thái:',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  Text(
                    widget.user.about,
                    style: const TextStyle(color: Colors.black38, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
