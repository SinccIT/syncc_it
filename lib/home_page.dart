import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncc_it/message_screen.dart';
import 'package:syncc_it/tab_bar_screen.dart';
import 'contact_screen.dart';
import 'data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// 상태 클래스
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    _mounted = true;
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch(index) {
        case 0:
          // Home 탭
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          // 그룹 탭
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TabBarScreen(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            )),
          );
          break;
        case 2:
          // 연락처 탭
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder: (context) => ContactPage(data: data)),
              MaterialPageRoute(builder: (context) => ContactsScreen(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              )),
          );
          break;
        case 3:
          // 메시지 탭
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MessageScreen(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            )),
          );
          break;
      }
  }

  @override
  Widget build(BuildContext context) {
    // DataModel에 접근
    final data = DataProvider.of(context);

    return Scaffold(
      appBar: CustomAppBar(),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          // 프로필 영역
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 프로필 이미지
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),
                  ),
                ),
                // 닉네임
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

          // 그룹 및 연락처 목록
          Expanded(
            child: Consumer<DataModel>(
              builder: (context, data, child) {
                return ListView.builder(

                  itemCount: data.groupList.length + data.contactList.length + 4,
                  itemBuilder: (context, index) {

                    if(index == 0) {
                      // divider
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          thickness: 1,
                          color: Color(0xFFEEEEEE),
                        ),
                      );

                    } else if (index == 1) {
                      // 그룹 라벨
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '그룹',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF27F39D),
                          ),
                        ),
                      );

                    } else if (index < data.groupList.length+2) {
                      // 그룹 목록
                      Group group = data.groupList[index-2];
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
                        onTap: () {
                          // 클릭 시 해당 그룹 연락처 조회 페이지로 이동
                        },
                      );

                    } else if (index == data.groupList.length+2) {
                      // divider
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          thickness: 1,
                          color: Color(0xFFEEEEEE),
                        ),
                      );

                    } else if (index == data.groupList.length+3) {
                      // 연락처 라벨
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '연락처',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF27F39D),
                          ),
                        ),
                      );
                    } else {
                      // 연락처 목록
                      Contact contact = data.contactList[index - data.groupList.length-4];
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
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

    );
  }
}

// app bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF27F39D),
      title: Text(
        'SynccIT',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(
        Icons.menu,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.person),
        ),
      ],
    );
  }
}

// bottom navigation bar
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  // BottomNavigationBarItem을 생성하는 함수
  BottomNavigationBarItem _buildItem(IconData icon, String label, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: Colors.grey), // 기본 색상은 회색으로 설정
      activeIcon: Icon(icon, color: Colors.white), // 선택된 아이콘 색상은 흰색으로 설정
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF313034),
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      items: <BottomNavigationBarItem>[
        _buildItem(
          Icons.home,
          'Home',
          currentIndex == 0,
        ),
        _buildItem(
          Icons.people,
          '그룹',
          currentIndex == 1,
        ),
        _buildItem(
          Icons.call,
          '연락처',
          currentIndex == 2,
        ),
        _buildItem(
          Icons.message,
          '메시지',
          currentIndex == 3,
        ),
      ],
      onTap: onTap,
    );

  }
}
