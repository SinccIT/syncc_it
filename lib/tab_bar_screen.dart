import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'group_service.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 800),
  );

  // 공유 목록과 각 항목에 대한 설명을 저장하는 리스트들
  List<String> sharedItems = [
    "One",
    "LG전자",
    "Two",
    "Hymedia",
    "SAMSUNG전자",
    // 추가적인 아이템들을 배열에 추가하세요
  ];
  List<String> sharedItemDescriptions = [
    "One 아이템 설명",
    "LG전자 아이템 설명",
    "Two 아이템 설명",
    "Hymedia 아이템 설명",
    "SAMSUNG전자 아이템 설명",
    // 추가적인 아이템들에 대한 설명을 배열에 추가하세요
  ];

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: [
          Expanded(child: _buildSharedList()),
          Expanded(child: _buildContactList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 목록 추가 창으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          ).then((value) {
            // 추가 창에서 입력한 값이 있으면 목록에 추가
            if (value != null) {
              setState(() {
                // 새로운 아이템을 목록에 추가
                sharedItems.add(value);
                sharedItemDescriptions.add('새로운 아이템 설명');
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSharedList() {
    return ListView.builder(
      itemCount: sharedItems.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.share),
            title: Text(sharedItems[index]),
            subtitle: Text(sharedItemDescriptions[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // 삭제 모달 표시
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("삭제"),
                      content: Text("이 항목을 삭제하시겠습니까?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("취소"),
                        ),
                        TextButton(
                          onPressed: () {
                            // 항목 삭제
                            setState(() {
                              sharedItems.removeAt(index);
                              sharedItemDescriptions.removeAt(index);
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text("삭제"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            onTap: () {
              // 해당 아이템을 눌렀을 때 동작할 함수 호출
            },
          ),
        );
      },
    );
  }

  Widget _buildContactList() {
    return ListView.builder(
      itemCount: contactItems.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(contactItems[index]),
            subtitle: Text(contactItemDescriptions[index]),
            trailing: IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                // 메시지 보내기 작업을 위한 함수 호출
              },
            ),
            onTap: () {
              // 해당 아이템을 눌렀을 때 동작할 함수 호출
            },
          ),
        );
      },
    );
  }
}
