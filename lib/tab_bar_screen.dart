import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  late SharedPreferences prefs;
  late List<String> _groupItems;
  late List<String> _groupItemDescriptions;
  late List<String> _groupItemTags;
  late List<String> _selectedContacts = [];

  late bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _groupItems = prefs.getStringList('groupItems') ?? [];
    _groupItemDescriptions = prefs.getStringList('groupItemDescriptions') ?? [];
    _groupItemTags = prefs.getStringList('groupItemTags') ?? [];
    setState(() {
      _initialized = true;
    });
  }

  void _addItem(String item, String description, String tags,
      List<String> selectedMembers) async {
    setState(() {
      _groupItems.add(item);
      _groupItemDescriptions.add(description);
      _groupItemTags.add(tags);
      _selectedContacts = List.from(selectedMembers); // 선택된 멤버 목록을 복사합니다.
    });
    await prefs.setStringList('groupItems', _groupItems);
    await prefs.setStringList('groupItemDescriptions', _groupItemDescriptions);
    await prefs.setStringList('groupItemTags', _groupItemTags);
    await prefs.setStringList('selectedContacts_${_groupItems.length - 1}',
        _selectedContacts); // 탭마다 별도의 저장 키 사용
  }

  void _removeItem(String tabIdentifier) async {
    setState(() {
      int index = _groupItems.indexOf(tabIdentifier); // 그룹 아이템의 인덱스 가져오기
      if (index != -1) {
        // 그룹 아이템 삭제
        _groupItems.removeAt(index);
        _groupItemDescriptions.removeAt(index);
        _groupItemTags.removeAt(index);

        // 선택된 멤버 목록의 키 수정
        for (int i = index; i < _groupItems.length; i++) {
          String key = 'selectedContacts_$i';
          String nextKey = 'selectedContacts_${i + 1}';
          List<String>? selectedContacts = prefs.getStringList(nextKey);
          if (selectedContacts != null) {
            // 다음 탭의 선택된 멤버 목록을 현재 탭으로 이동
            _selectedContacts = selectedContacts;
            prefs.setStringList(key, _selectedContacts);
            prefs.remove(nextKey);
          }
        }
      }
    });

    await prefs.setStringList('groupItems', _groupItems);
    await prefs.setStringList('groupItemDescriptions', _groupItemDescriptions);
    await prefs.setStringList('groupItemTags', _groupItemTags);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 비활성화
        title: Padding(
          padding:
              const EdgeInsets.only(left: 16.0), // 그룹 목록을 왼쪽 끝으로 위치시키기 위한 패딩 추가
          child: Text(
            '그룹 목록',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF27F39D),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _groupItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colors.white, // ListTile의 배경색 설정
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 타일의 테두리 모양 설정
            ),
            leading: Container(
              width: 48, // CircleAvatar의 지름과 동일한 너비
              height: 48, // CircleAvatar의 지름과 동일한 높이
              child: CircleAvatar(
                backgroundColor: Color(0xFFEEEEEE),
                child: Text(
                  _groupItems[index][0],
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            title: Text(
              _groupItems[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _groupItemDescriptions[index],
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFC8C8C8),
              ),
            ),
            onTap: () {
              // 그룹 상세조회 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailScreen(
                    groupName: _groupItems[index],
                    groupDescription: _groupItemDescriptions[index],
                    groupTags: _groupItemTags[index],
                    selectedMembers:
                        prefs.getStringList('selectedContacts_$index') ?? [],
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // 삭제 다이얼로그 표시
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("삭제"),
                      content: Text("이 그룹을 삭제하시겠습니까?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("취소"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              String tabIdentifier =
                                  _groupItems[index]; // 삭제할 탭의 고유 식별자를 가져옵니다.
                              _removeItem(
                                  tabIdentifier); // 고유 식별자와 인덱스를 전달하여 삭제합니다.
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddContactScreen(onAdd: _addItem),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddContactScreen extends StatefulWidget {
  final Function(String, String, String, List<String>)
      onAdd; // 선택된 멤버 목록을 추가합니다.

  const AddContactScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late List<String> _selectedContacts = []; // _selectedContacts 필드 추가 및 초기화
  late SharedPreferences _prefs;
  late List<String> _contacts;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _tagsController = TextEditingController();
    _initSharedPreferences(); // Initialize SharedPreferences
  }

  // Initialize SharedPreferences and fetch contacts
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _contacts = _prefs.getStringList('contactItems') ?? [];
  }

  // Method to fetch contacts - Replace this with your actual contact fetching logic
  Future<List<String>> _fetchContacts() async {
    return _contacts;
  }

  void _saveContact() async {
    String name = _nameController.text;
    String description = _descriptionController.text;
    String tags = _tagsController.text;

    // Perform any validation here before saving
    // For simplicity, let's assume all fields are required

    // Pass selected members along with other details
    widget.onAdd(name, description, tags, _selectedContacts); // 추가된 멤버를 전달합니다.

    // Clear text fields after saving
    _nameController.clear();
    _descriptionController.clear();
    _tagsController.clear();

    // Optionally, you can also navigate back to the previous screen
    Navigator.pop(context);
  }

  // Group 추가 함수 정의
  void _addGroup(List<String> selectedContacts) {
    setState(() {
      _selectedContacts = selectedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('그룹 추가'),
        actions: [
          TextButton(
            onPressed: _saveContact,
            child: Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),
                ),
              ),
              SizedBox(
                  height: 32.0), // Add some spacing below the profile image
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Group Description',
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags',
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () async {
                  // 연락처 가져오기
                  List<String> contacts = await _fetchContacts();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    '멤버 추가',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: contacts.length,
                                    itemBuilder: (context, index) {
                                      String contact = contacts[index];
                                      return ListTile(
                                        title: Text(contact),
                                        trailing:
                                            _selectedContacts.contains(contact)
                                                ? Icon(Icons.check_circle)
                                                : Icon(Icons.circle_outlined),
                                        onTap: () {
                                          setState(() {
                                            if (_selectedContacts
                                                .contains(contact)) {
                                              _selectedContacts.remove(contact);
                                            } else {
                                              _selectedContacts.add(contact);
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _addGroup(_selectedContacts);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('확인'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Text('멤버 추가'),
              ),
              SizedBox(height: 12.0),
              Wrap(
                children: _selectedContacts.map((contact) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Chip(
                      label: Text(contact),
                      onDeleted: () {
                        setState(() {
                          _selectedContacts.remove(contact);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 이 위치에 상세조회 페이지 클래스를 추가합니다.
class GroupDetailScreen extends StatelessWidget {
  final String groupName;
  final String groupDescription;
  final String groupTags;
  final List<String> selectedMembers;

  const GroupDetailScreen({
    required this.groupName,
    required this.groupDescription,
    required this.groupTags,
    required this.selectedMembers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('그룹 정보'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGroupScreen(
                    groupName: groupName,
                    groupDescription: groupDescription,
                    groupTags: groupTags,
                    selectedMembers: selectedMembers,
                  ),
                ),
              );
            },
            child: Text('Edit'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),
                ),
              ),
              SizedBox(height: 64.0),
              Text(
                'Group Name',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0), // Additional space
              Text(
                groupName,
                style: TextStyle(fontSize: 18.0), // Increased font size
              ),
              SizedBox(height: 24.0),
              Text(
                'Group Description',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0), // Additional space
              Text(
                groupDescription,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 24.0),
              Text(
                'Tags',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0), // Additional space
              Text(
                groupTags,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 24.0),
              Text(
                'Selected Members',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: selectedMembers.map((member) {
                  return Chip(
                    label: Text(member),
                  );
                }).toList(),
              ),
              SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}

class EditGroupScreen extends StatefulWidget {
  final String groupName;
  final String groupDescription;
  final String groupTags;
  final List<String> selectedMembers;

  const EditGroupScreen({
    required this.groupName,
    required this.groupDescription,
    required this.groupTags,
    required this.selectedMembers,
  });

  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late List<String> _selectedMembers;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.groupName);
    _descriptionController =
        TextEditingController(text: widget.groupDescription);
    _tagsController = TextEditingController(text: widget.groupTags);
    _selectedMembers = List.from(widget.selectedMembers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('그룹 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
                  ),
                ),
              ),
              SizedBox(height: 64.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Group Description',
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags',
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  // 수정된 정보 저장 및 이전 페이지로 이동
                  _saveChanges();
                },
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    String newName = _nameController.text;
    String newDescription = _descriptionController.text;
    String newTags = _tagsController.text;
    List<String> newMembers = List.from(_selectedMembers);

    // 수정된 정보 저장
    // 예: 데이터베이스 업데이트 또는 SharedPreferences 업데이트

    // 수정이 완료되면 이전 페이지로 이동
    Navigator.pop(context, {
      'name': newName,
      'description': newDescription,
      'tags': newTags,
      'members': newMembers
    });
  }
}
