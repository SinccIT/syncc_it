import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group_item.dart';

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
      _selectedContacts.addAll(selectedMembers); // 선택된 멤버 목록을 추가합니다.
    });
    await prefs.setStringList('groupItems', _groupItems);
    await prefs.setStringList('groupItemDescriptions', _groupItemDescriptions);
    await prefs.setStringList('groupItemTags', _groupItemTags);
    await prefs.setStringList('selectedContacts_${_groupItems.length - 1}',
        _selectedContacts); // 탭마다 별도의 저장 키 사용
  }

  void _removeItem(int index) async {
    setState(() {
      _groupItems.removeAt(index);
      _groupItemDescriptions.removeAt(index);
      _groupItemTags.removeAt(index);
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
        title: Text('그룹 목록'),
      ),
      body: ListView.builder(
        itemCount: _groupItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.work),
              title: Text(
                _groupItems[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_groupItemDescriptions[index]),
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
                          prefs.getStringList('selectedContacts_$index') ??
                              [], // 해당 탭에 대한 선택된 멤버 불러오기
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
                                _removeItem(index); // 항목 삭제
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
                  // Fetch contacts
                  List<String> contacts = await _fetchContacts();
                  // Open dialog to select contacts
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text("멤버 추가"),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: contacts.map((contact) {
                                  bool isSelected =
                                      _selectedContacts.contains(contact);
                                  return CheckboxListTile(
                                    title: Text(contact),
                                    value: isSelected,
                                    onChanged: (newValue) {
                                      setState(() {
                                        if (newValue!) {
                                          _selectedContacts.add(
                                              contact); // Add contact when checked
                                        } else {
                                          _selectedContacts.remove(
                                              contact); // Remove contact when unchecked
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("취소"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Close dialog and pass selected contacts
                                  Navigator.of(context).pop(_selectedContacts);
                                },
                                child: Text("확인"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ).then((selectedContacts) {
                    // Update selected contacts on dialog close
                    if (selectedContacts != null) {
                      setState(() {
                        _selectedContacts = List.from(selectedContacts);
                      });
                    }
                  });
                },
                child: Text('멤버 추가'),
              ),
              SizedBox(height: 12.0),
              // Display selected contacts
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
