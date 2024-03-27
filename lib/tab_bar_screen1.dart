import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late SharedPreferences _prefs;
  late List<String> _contactItems;
  late List<String> _contactItemDescriptions;
  late bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _contactItems = _prefs.getStringList('contactItems') ?? [];
    _contactItemDescriptions =
        _prefs.getStringList('contactItemDescriptions') ?? [];
    setState(() {
      _initialized = true;
    });
  }

  void _addItemToContacts(String item, String description, String tags) async {
    setState(() {
      _contactItems.add(item);
      _contactItemDescriptions.add(description);
    });
    await _prefs.setStringList('contactItems', _contactItems);
    await _prefs.setStringList(
        'contactItemDescriptions', _contactItemDescriptions);
  }

  void _removeItem(int index) async {
    setState(() {
      _contactItems.removeAt(index);
      _contactItemDescriptions.removeAt(index);
    });
    await _prefs.setStringList('contactItems', _contactItems);
    await _prefs.setStringList(
        'contactItemDescriptions', _contactItemDescriptions);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('연락처 목록'),
      ),
      body: ListView.builder(
        itemCount: _contactItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.people),
              title: Text(
                _contactItems[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_contactItemDescriptions[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
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
                              setState(() {
                                _removeItem(index);
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
              builder: (context) =>
                  AddContactScreen1(onAdd: _addItemToContacts),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddContactScreen1 extends StatefulWidget {
  final Function(String, String, String) onAdd;

  const AddContactScreen1({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddContactScreenState1 createState() => _AddContactScreenState1();
}

class _AddContactScreenState1 extends State<AddContactScreen1> {
  late TextEditingController _nameController1;
  late TextEditingController _descriptionController1;
  late TextEditingController _tagsController; // 태그 입력 필드 컨트롤러 추가

  @override
  void initState() {
    super.initState();
    _nameController1 = TextEditingController();
    _descriptionController1 = TextEditingController();
    _tagsController = TextEditingController(); // 컨트롤러 초기화
  }

  @override
  void dispose() {
    _nameController1.dispose();
    _descriptionController1.dispose();
    _tagsController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('연락처 추가'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              // 프로필 영역
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 프로필 이미지
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Container(
                        padding: EdgeInsets.all(20), // 테두리와 아이콘 사이의 간격을 설정합니다.
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 동그라미 모양의 테두리를 만듭니다.
                          color: Colors.grey, // 원의 색상을 설정합니다.
                        ),
                        child: Icon(
                          Icons.person_2, // 아이콘을 선택합니다.
                          size: 100, // 아이콘의 크기를 조정합니다.
                          color: Colors.white, // 아이콘의 색상을 설정합니다.
                        ),
                      ),
                    ),

                    TextField(
                      controller: _nameController1,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: _descriptionController1,
                      decoration: InputDecoration(
                        labelText: 'PhoneNumber',
                      ),
                    ),
                    SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        final name = _nameController1.text;
                        final description = _descriptionController1.text;
                        final tags = _tagsController.text;
                        widget.onAdd(name, description, tags);
                        Navigator.pop(context);
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
