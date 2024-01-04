import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:test_121/api/apis.dart';
import 'package:test_121/auth/login_screen.dart';
import 'package:test_121/chat/messenger.dart';
import 'package:test_121/helper/dialogs.dart';
import 'package:test_121/models/chat_user.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Index của tab hiện tại

  final _formKey =GlobalKey<FormState>();


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
        // Cập nhật UI nếu cần thiết
        setState(() {
          _selectedIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng MediaQuery để lấy thông tin kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () async {
              //for showing progress dialog
              Dialogs.showProgressBar(context);
      
              // sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) => {
                      //for hinding progress dialog
                      Navigator.pop(context),
      
                      // for moving to home screen
                      Navigator.pop(context),
      
                      // for replacing home screen with login screen
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()))
                    });
              });
            },
            child: const Icon(Icons.logout_rounded),
          ),
        ),
      
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenWidth * 0.05), // Khoảng cách nhỏ phía trên
                  
                //  CircleAvatar(
                //   radius: screenWidth * 0.3, // Bán kính avatar bằng 30% chiều rộng màn hình
                //   backgroundImage: CachedNetworkImageProvider(widget.user.image),
                // ),
                  
                Stack(
                  children: [
                    ClipRRect(
                      // borderRadius: BorderRadius.circular(mq.height * .3),
                      child: CachedNetworkImage(
                        imageUrl: widget.user.image,
                        width: screenWidth * .5,
                        height: screenHeight * .3,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(child: Icon(CupertinoIcons.person)),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {},
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
                  height: mq.height * .05,
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
                  onSaved: (val)=> APIs.me.name = val ?? '',
                  validator: (val)=> val!= null && val.isNotEmpty ? null:"Repuire field",
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
                  onSaved: (val)=> APIs.me.about = val ?? '',
                  validator: (val)=> val!= null && val.isNotEmpty ? null:"Repuire field",
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
                  height: screenWidth * .07,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
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
            height: mq.height * .09,
            child: GNav(
                rippleColor:
                    Colors.grey[800]!, // tab button ripple color when pressed
                hoverColor: Colors.grey[700]!, // tab button hover color
                gap: 8,
                activeColor: Colors.blueAccent, // selected icon and text color
      
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5), // navigation bar padding
                duration:
                    const Duration(milliseconds: 300), // tab animation duration
                tabBackgroundColor: Colors.purple
                    .withOpacity(0.1), // selected tab background color
                color: Colors.grey[800], // unselected icon color
                textStyle: TextStyle(fontSize: mq.height * .022),
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
                selectedIndex: _selectedIndex, // Đảm bảo 'Profile' được highlight
                onTabChange: _onTap)
            // Thêm logic điều hướng tương ứng với tab được chọn
      
            ),
      ),
    );
  }
}
