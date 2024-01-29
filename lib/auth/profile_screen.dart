import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:test_121/api/apis.dart';
import 'package:test_121/auth/login_screen.dart';
import 'package:test_121/chat/messenger.dart';
import 'package:test_121/helper/dialogs.dart';
import 'package:test_121/models/chat_user.dart';
import 'package:test_121/main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Index của tab hiện tại

  final _formKey = GlobalKey<FormState>(); // key để cập nhật tên và trạng thái

  String? _image; // Replace with your image path variable

  void _onTap(int index) {
    // Điều hướng giữa các màn hình ở đây   // Đối với ví dụ này, chúng ta chỉ thay đổi state để cập nhật UI
    setState(() {
      if (index == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          ModalRoute.withName('/HomeScreen'), // Đặt tên route nếu đã định nghĩa
        );
      } else {
        //da sua lai
        // Cập nhật UI nếu cần thiết
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng MediaQuery để lấy thông tin kích thước màn hình
    double screenHeight = MediaQuery.of(context).size.height;
    double tabBarHeight = screenHeight * 0.12; // Khoảng 12% chiều cao màn hình
    double screenWidth = MediaQuery.of(context).size.width;
    // Điều chỉnh kích thước dựa trên kích thước màn hình
    double iconSize = screenWidth * 0.06; // Khoảng 6% chiều rộng màn hình
    double fontSize = screenHeight * 0.02; // Khoảng 2% chiều cao màn hình

    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
          automaticallyImplyLeading:
              false, // Thêm dòng này vào cấu hình của AppBar
          actionsIconTheme: const IconThemeData(),
        ),
        // them icon bieu tuong o goc man hinh
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () async {
            // Show progress dialog
            Dialogs.showProgressBar(context);


            await APIs.updateActiveStatus(false);
            // Sign out from app
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) => {
                    // Hide progress dialog
                    Navigator.pop(context),

                    // Move to home screen
                    Navigator.pop(context),
                    APIs.auth = FirebaseAuth.instance,
                    // Replace home screen with login screen
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()))
                  });
            });
          },
          child: const Icon(Icons.logout_rounded),
        ),

        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    //profile picture
                    _image != null
                        ? ClipRRect(
                            // borderRadius: BorderRadius.circular(mq.height * .3),
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: Image.file(
                              File(_image!),
                              width: screenWidth * .5,
                              height: screenHeight * .3,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
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
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  color: Colors.grey, // Màu của placeholder
                                ),
                                child: Icon(Icons.person, size: mq.height * .1),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        elevation: 1,
                        shape: const CircleBorder(),
                        color: Colors.blue,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
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

                //name input field

                TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (val) => APIs.me.name = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Repuire field",
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person_4,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Vui lòng nhập tên mới',
                      label: const Text('Tên người dùng')),
                ),

                //for adding some space
                SizedBox(
                  height: mq.height * .02,
                ),

                // trang thai input field
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (val) => APIs.me.about = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Repuire field",
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.note_add,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Vui lòng nhập trạng thái',
                      label: const Text('Trạng thái')),
                ),

                SizedBox(
                  height: mq.width * .07,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo();
                        Dialogs.showSnackBar(context, 'Update thanh cong !!!');
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Cập nhật'))
              ],
            ),
          ),
        ),

        // BottomNavigationBar giống như ở HomeScreen

        bottomNavigationBar: Container(
          height: tabBarHeight,
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 5), // Thêm padding nếu cần
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1)),
            ],
          ),
          child: GNav(
            rippleColor:
                Colors.grey[800]!, // tab button ripple color when pressed
            hoverColor: Colors.grey[700]!, // tab button hover color
            gap: 8,
            activeColor: Colors.blueAccent, // selected icon and text color
            iconSize: iconSize,
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 5), // navigation bar padding
            duration:
                const Duration(milliseconds: 300), // tab animation duration
            tabBackgroundColor:
                Colors.purple.withOpacity(0.1), // selected tab background color
            color: Colors.grey[800], // unselected icon color
            textStyle: TextStyle(fontSize: fontSize),
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.heart,
                text: 'Likes',
              ),
              GButton(
                icon: LineIcons.search,
                text: 'Search',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onTap,
          ),
        ),
      ),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button

                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(mq.width * .2, mq.height * .2)),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // Pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (mounted && image != null) {
                            log('Image Path: ${image.path}');
                            setState(() {
                              _image = image.path;
                            });

                            APIs.updateProfilePicture(File(_image!));

                            // APIs.updateProfilePicture(File(_image!));
                            // for hiding bottom sheet
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('images/image.png')),
                  )),
                  //take picture from camera button
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(mq.width * .3, mq.height * .15)),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // Pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            log('Image Path: ${image.path}');
                            setState(() {
                              _image = image.path;
                            });

                            APIs.updateProfilePicture(File(_image!));
                            // for hiding bottom sheet
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('images/camera.png')),
                  ))
                ],
              )
            ],
          );
        });
  }
}
