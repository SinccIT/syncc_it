import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncc_it/tab_bar_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home', style: optionStyle),
    TabBarScreen(),
    Text('Index 2: call', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          TabBarScreen(), // TabBarScreen 추가
          _widgetOptions[1],
          _widgetOptions[2],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home', // title -> label 변경
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '그룹', // title -> label 변경
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: '연락처', // title -> label 변경
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
