import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({
    Key? key,
    this.updatedContactName = '', // 기본값 설정
    this.updatedContactPhoneNumber = '', // 기본값 설정
  }) : super(key: key);

  final String updatedContactName; // 수정된 정보를 받는 변수 추가
  final String updatedContactPhoneNumber; // 수정된 정보를 받는 변수 추가

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

  @override
  void didUpdateWidget(covariant ContactsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 위젯이 업데이트될 때마다 SharedPreferences에서 데이터 다시 읽어오기
    _initSharedPreferences();
  }

  void _addItemToContacts(String item, String description, String tags) async {
    _contactItems.add(item);
    _contactItemDescriptions.add(description);
    await _prefs.setStringList('contactItems', _contactItems);
    await _prefs.setStringList(
        'contactItemDescriptions', _contactItemDescriptions);
    setState(() {}); // 수정된 항목을 바로 반영하기 위해 setState 호출
  }

  void _removeItem(int index) async {
    _contactItems.removeAt(index);
    _contactItemDescriptions.removeAt(index);
    await _prefs.setStringList('contactItems', _contactItems);
    await _prefs.setStringList(
        'contactItemDescriptions', _contactItemDescriptions);
    setState(() {}); // 수정된 항목을 바로 반영하기 위해 setState 호출
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
            '연락처 목록',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF27F39D),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _contactItems.length,
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
                  _contactItems[index][0],
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            title: Text(
              _contactItems[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _contactItemDescriptions[index],
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
                  builder: (context) => ContactDetailScreen(
                    contactName: _contactItems[index],
                    contactPhoneNumber: _contactItemDescriptions[index],
                  ),
                ),
              );
            },

            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("연락처 삭제"),
                      content: Text("이 연락처를 삭제하시겠습니까?"),
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
                          Icons.person, // 아이콘을 선택합니다.
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

class ContactDetailScreen extends StatefulWidget {
  final String contactName;
  final String contactPhoneNumber;

  const ContactDetailScreen({
    required this.contactName,
    required this.contactPhoneNumber,
  });

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late String _updatedContactName;
  late String _updatedContactPhoneNumber;

  @override
  void initState() {
    super.initState();
    // 초기에는 수정된 정보가 없으므로 기존 정보로 초기화합니다.
    _updatedContactName = widget.contactName;
    _updatedContactPhoneNumber = widget.contactPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('연락처 정보'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 100,
                  // backgroundImage: NetworkImage(
                  //   'https://via.placeholder.com/150', // 대체 이미지 URL
                  // ),
                  child: Icon(
                    Icons.person, // 아이콘을 선택합니다.
                    size: 100, // 아이콘의 크기를 조정합니다.
                    color: Colors.white, // 아이콘의 색상을 설정합니다.
                  ),
                ),
              ),
              SizedBox(height: 64.0),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _updatedContactName,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 24.0),
              Text(
                'PhoneNumber',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _updatedContactPhoneNumber,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 64.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditContactScreen(
                        contactName: _updatedContactName,
                        contactPhoneNumber: _updatedContactPhoneNumber,
                        onNameChanged: (String newName) {
                          setState(() {
                            _updatedContactName = newName;
                          });
                        },
                        onPhoneNumberChanged: (String newPhoneNumber) {
                          setState(() {
                            _updatedContactPhoneNumber = newPhoneNumber;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditContactScreen extends StatefulWidget {
  final String contactName;
  final String contactPhoneNumber;
  final Function(String) onNameChanged;
  final Function(String) onPhoneNumberChanged;
  final String updatedContactName; // 수정된 정보를 추가합니다.
  final String updatedContactPhoneNumber; // 수정된 정보를 추가합니다.

  EditContactScreen({
    required this.contactName,
    required this.contactPhoneNumber,
    required this.onNameChanged,
    required this.onPhoneNumberChanged,
    this.updatedContactName = '', // 기본값을 설정합니다.
    this.updatedContactPhoneNumber = '', // 기본값을 설정합니다.
  });

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contactName);
    _phoneNumberController =
        TextEditingController(text: widget.contactPhoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              onChanged: widget.onNameChanged, // 이름이 변경될 때 콜백 함수 호출
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
              onChanged: widget.onPhoneNumberChanged, // 전화번호가 변경될 때 콜백 함수 호출
            ),
            ElevatedButton(
              onPressed: (_saveChanges),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text;
    final newPhoneNumber = _phoneNumberController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactItems = prefs.getStringList('contactItems') ?? [];
    List<String> contactItemDescriptions =
        prefs.getStringList('contactItemDescriptions') ?? [];

    // Find the index of the contact to update in the existing list
    int index = contactItems.indexOf(widget.contactName);
    if (index != -1) {
      // Update the contact information in the existing lists
      contactItems[index] = newName;
      contactItemDescriptions[index] = newPhoneNumber;

      // Update SharedPreferences with the modified contact information
      await prefs.setStringList('contactItems', contactItems);
      await prefs.setStringList(
          'contactItemDescriptions', contactItemDescriptions);

      // Pass the updated name and phone number to the parent widget
      widget.onNameChanged(newName);
      widget.onPhoneNumberChanged(newPhoneNumber);

      // Clear text fields after saving
      _nameController.clear();
      _phoneNumberController.clear();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }
}
