import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncc_it/tab_bar_screen.dart';
import 'package:syncc_it/tab_bar_screen1.dart';
import 'data_model.dart';
import 'view_profile.dart'; // ViewProfile 클래스를 임포트합니다.

class HomePage extends StatefulWidget {
  final String name; // 사용자 이름을 저장할 변수
  const HomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onProfileIconPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewProfile(
          name: widget.name,
          intro: '상태 메시지',
          email: 'example@example.com',
          id: 'user_id',
          phoneNumber: '010-1234-5678',
          contactTime: '오전 10시 - 오후 6시',
          profileImage: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = DataProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF27F39D),
        title: Text(
          'SynccIT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // 검색 기능을 수행할 작업 추가
            },
            icon: Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () => _onProfileIconPressed(context),
            icon: Icon(CupertinoIcons.person),
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
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),
                        ),
                      ),
                      Text(
                        '사용자 닉네임',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '상태 메시지',
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
                  : SizedBox(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xFF27F39D),
        unselectedItemColor: Color(0xFFC8C8C8),
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
}
