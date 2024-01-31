import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_121/api/apis.dart';
import 'package:test_121/helper/my_date_util.dart';
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
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessenger() : _blueMessenger(),
    );
  }

  // sender or another user message
  // giao diện tin nhắn cho người dùng 2
  Widget _blueMessenger() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isNotEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      //log('Message read updated');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Container(
          margin:
              const EdgeInsets.symmetric(vertical: 6.0), // Thêm margin ở đây
          padding: EdgeInsets.all(widget.message.type == Type.image
              ? mq.height * .03
              : mq.width * .04),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 113, 145, 196),
              border:
                  Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: widget.message.type == Type.text
              ? Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                )
              : // for showing image
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.message.msg,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => (const Icon(
                      Icons.image,
                      size: 70,
                    )),
                  ),
                ),
        )),

        Padding(
          padding: EdgeInsets.only(right: mq.height * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.msg),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),

        //for add space
        SizedBox(width: mq.height * .04),
      ],
    );
  }

  // our or user messenger
  Widget _greenMessenger() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //for adding some space
            SizedBox(
              width: mq.width * .04,
            ),
            //double tick blue icon for messenger read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done,
                color: Colors.blueAccent,
                size: 20,
              ),
            //for addtion some space

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        Flexible(
          child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 6.0), // Thêm margin ở đây
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.height * .03
                : mq.width * .04),
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                :
                // for showing image
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => (const Icon(
                        Icons.image,
                        size: 70,
                      )),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black  divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                  vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type==Type.text ? // copy option
              _OptionItem(
                  icon: const Icon(
                    Icons.copy_all_rounded,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: 'Copy Text',
                  onTap: () {}):// copy option
              _OptionItem(
                  icon: const Icon(
                    Icons.download_rounded,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: 'Save image',
                  onTap: () {}),
              // separater or devide
              if(isMe)
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
              // edit option
              if( widget.message.type==Type.text && isMe )
              _OptionItem(
                  icon: const Icon(
                    Icons.edit_document,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: 'Edit message',
                  onTap: () {}),
              // delete option
              if(isMe)
              _OptionItem(
                  icon: const Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                    size: 26,
                  ),
                  name: 'Delete message',
                  onTap: () {}),
              // separater or devide
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
              // sent time
              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye_sharp,
                    color: Colors.blue,
                  ),
                  name: 'Sent time ',
                  onTap: () {}),
              // read time
              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye_sharp,
                    color: Colors.red,
                  ),
                  name: 'Read time',
                  onTap: () {}),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05,
            top: mq.height * .015,
            bottom: mq.height * .015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text('   $name',
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black, letterSpacing: 0.5)))
          ],
        ),
      ),
    );
  }
}
