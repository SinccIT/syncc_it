import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncc_it/auth_service.dart';
import 'package:syncc_it/data_model.dart';
import 'package:syncc_it/tab_bar_screen.dart';
import 'package:syncc_it/tab_bar_screen1.dart';
import 'data_model.dart';
import 'message_screen.dart';
import 'package:syncc_it/view_profile.dart';
import 'package:syncc_it/profile.dart'; // MyProfile 클래스의 경로에 맞게 수정해야 합니다.
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 추가

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required AuthService authService}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences _prefs; // _prefs 변수 선언
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadPrefs(); // initState에서 _loadPrefs 호출
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance(); // SharedPreferences 초기화
    _loadProfileImage();
    setState(() {});
  }

  Future<void> _loadProfileImage() async {
    String? imagePath = _prefs.getString('profileImage');
    if(imagePath != null) {
      setState(() {
        _profileImage = XFile(imagePath);
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateProfileImage(XFile imageFile) {
    setState(() {
      _profileImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = DataProvider.of(context);
    String? name = _prefs.getString('name');

    return Consumer<AuthService>(
        builder: (context, authService, child) {
          // 로그인한 회원정보를 위젯트리 최상단에서 가져옴
          final AuthService authService = context.read<AuthService>();
          User? user = authService.currentUser();

          print(name);
          print(user?.email);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF27F39D),
              title: Text(
                'SynccIT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.add_home_outlined),
                onPressed: () {
                  // 홈 화면으로 이동
                  Navigator.pushNamed(context, '/home');
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfile(
                            prefs: _prefs), // MyProfile 클래스의 인스턴스를 생성하여 이동합니다.
                      ),
                    );
                  },
                  icon: Icon(Icons.person),
                ),
              ],
            ),
            body: _selectedIndex == 0
                ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage: _profileImage == null
                            ? AssetImage('images/profile.png',
                          ) as ImageProvider<Object>?
                          : FileImage(File(_profileImage!.path))
                            as ImageProvider<Object>?,
                        ),
                      ),
                      Text(
                        name!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<DataModel>(
                    builder: (context, data, child) {
                      return ListView.builder(
                        itemCount:
                        data.groupList.length + data.contactList.length + 4,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(
                                thickness: 1,
                                color: Color(0xFFEEEEEE),
                              ),
                            );
                          } else if (index == 1) {
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '그룹',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF27F39D),
                                ),
                              ),
                            );
                          } else if (index < data.groupList.length + 2) {
                            Group group = data.groupList[index - 2];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(group.groupName[0]),
                                backgroundColor: Color(0xFFEEEEEE),
                              ),
                              title: Text(
                                group.groupName,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                group.desc,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFC8C8C8),
                                ),
                              ),
                              onTap: () {},
                            );
                          } else if (index == data.groupList.length + 2) {
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(
                                thickness: 1,
                                color: Color(0xFFEEEEEE),
                              ),
                            );
                          } else if (index == data.groupList.length + 3) {
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '연락처',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF27F39D),
                                ),
                              ),
                            );
                          } else {
                            Contact contact = data
                                .contactList[index - data.groupList.length - 4];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(contact.name[0]),
                                backgroundColor: Color(0xFFEEEEEE),
                              ),
                              title: Text(
                                contact.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                contact.desc,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFC8C8C8),
                                ),
                              ),
                              onTap: () {},
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            )

                : _selectedIndex == 1
                ? TabBarScreen()
                : _selectedIndex == 2
                ? ContactsScreen()
                : _selectedIndex == 3
                ? SendSMS()

                : SizedBox(),

            // bottom navigation bar
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color(0xFF313034),
              selectedItemColor: Color(0xFF27F39D), // 선택된 항목의 색상
              unselectedItemColor: Color(0xFFC8C8C8), // 선택되지 않은 항목의 색상
              showUnselectedLabels: true,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: '그룹',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone),
                  label: '연락처',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: '메시지',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );

        }
    );
  }
}