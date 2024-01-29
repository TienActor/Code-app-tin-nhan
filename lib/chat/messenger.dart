import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:test_121/api/apis.dart';
import 'package:test_121/auth/profile_screen.dart';
import 'package:test_121/main.dart';
import 'package:test_121/models/chat_user.dart';
import 'package:test_121/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for sorting all  user
  List<ChatUser> _list = [];
  //for storing search list
  final List<ChatUser> _searchList = [];
  // for sorting search status
  bool _isSearching = false;

  int _selectedIndex = 0; // Index của tab hiện tại
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    APIs.getSelfInfo();

    //for getting user status to active
    APIs.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true); // rusume -- active login and true
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false); // PAUSE  -- inactive login and false
        }
      }

      return Future.value(message);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_pageController.hasClients) {
      if (index == 3) {
        // Giả sử rằng 3 là index cho 'Profile'
        // Điều hướng đến ProfileScreen
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileScreen(
              user: APIs
                  .me), // Thay thế list[0] bằng đối tượng ChatUser thích hợp
        ));
      } else {
        _pageController.jumpToPage(index);
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng MediaQuery để lấy thông tin kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // Điều chỉnh kích thước dựa trên kích thước màn hình
    double iconSize = screenWidth * 0.06; // Khoảng 6% chiều rộng màn hình
    double fontSize = screenHeight * 0.02; // Khoảng 2% chiều cao màn hình
    double tabBarHeight = screenHeight * 0.12; // Khoảng 12% chiều cao màn hình

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        // title cho trang tin nhan
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Ten,email ...'),
                autofocus: true,
                style: const TextStyle(fontSize: 16, letterSpacing: 0.5),
                onChanged: (val) {
                  //search logic
                  _searchList.clear();
                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                        i.email.toLowerCase().contains(val.toLowerCase())) {
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
              )
            : const Text('Tin nhắn',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 25,
                )),
        //them icon search va phim chuc nang cho icon
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search))
        ],
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(),
      ),
      // them icon bieu tuong o goc man hinh
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_circle_outlined),
        ),
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          StreamBuilder(
            // xử lý dữ liệu từ firebase và hiển thị lên màn hình
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                log('Error loading users: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data?.docs;
              _list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (_list.isNotEmpty) {
                // Show user list if it is not empty.
                return ListView.builder(
                  itemCount: _isSearching ? _searchList.length : _list.length,
                  padding: EdgeInsets.only(top: mq.height * .01),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUserCard(
                        user: _isSearching ? _searchList[index] : _list[index]);
                  },
                );
              } else {
                // Show this when the list is empty.
                return const Center(
                  child: Text(
                    'Không có dữ liệu',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            },
          ),
        ],
      ),

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
          duration: const Duration(milliseconds: 300), // tab animation duration
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
          onTabChange: _onItemTapped,
        ),
      ),
    );
  }
}
