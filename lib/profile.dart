import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'view_profile.dart'; // 새로운 페이지 파일 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyProfile());
}

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final _items = [
    '9am-10am',
    '10am-11am',
    '12pm-1pm',
    '1pm-2pm',
    '2pm-3pm',
    '3pm-4pm',
    '4pm-5pm',
    '5pm-6pm'
  ];
  var _selected = '9am-10am';

  List<String> _selectedContactTimes = [];

  String _name = '박채연';
  String _intro = '안녕하세요. 반갑습니다.';
  String _email = 'example@example.com';
  String _id = 'example_id';
  String _phoneNumber = '010-1234-5678';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _introController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _introController.text = _intro;
    _emailController.text = _email;
    _idController.text = _id;
    _phoneNumberController.text = _phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView(
            children: <Widget>[
              imageProfile(context),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _editName();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _editIntro();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _intro,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.edit, size: 20),
                  ],
                ),
              ),
              SizedBox(height: 50),
              nameTextFieldWithIcon('ID', _idController, Icons.edit),
              SizedBox(height: 20),
              nameTextFieldWithIcon('E-MAIL', _emailController, Icons.edit),
              SizedBox(height: 20),
              nameTextFieldWithIcon(
                  'Phone Number', _phoneNumberController, Icons.edit),
              SizedBox(height: 50),
              buildContactTimeDropdown(),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // 저장 버튼 클릭 시 변경된 정보를 저장하고 조회 페이지로 이동
                  _saveAndNavigateToViewProfile(context);
                },
                child: Text('저장'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 조회 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfile(
                        name: _name,
                        intro: _intro,
                        email: _email,
                        id: _id,
                        phoneNumber: _phoneNumber,
                        contactTime: _selected,
                      ),
                    ),
                  );
                },
                child: Text('프로필 보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundImage: _imageFile == null
                ? AssetImage('images/profile.png') as ImageProvider<Object>?
                : FileImage(File(_imageFile!.path)),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet(context)),
                );
              },
              child: Icon(
                Icons.camera_alt,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Choose Profile photo',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextButton.icon(
                  icon: Icon(Icons.camera, size: 50),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextButton.icon(
                  icon: Icon(Icons.photo_library, size: 50),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = PickedFile(pickedFile.path);
      });
      Navigator.pop(context); // bottomSheet를 닫음
    }
  }

  Widget nameTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }

  Widget nameTextFieldWithIcon(
      String labelText, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        suffixIcon: Icon(icon),
      ),
    );
  }

  Widget buildContactTimeDropdown() {
    return Container(
      width: 200, // 버튼의 너비 조정
      child: DropdownButtonFormField<String>(
        value: _selected,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '연락가능시간',
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selected = newValue!;
          });
        },
        items: _items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  void _editName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter your name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _name = _nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editIntro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Introduction'),
          content: TextField(
            controller: _introController,
            decoration: InputDecoration(hintText: "Enter your introduction"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _intro = _introController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    // 변경된 정보를 콘솔에 출력
    print('Name: ${_nameController.text}');
    print('Introduction: ${_introController.text}');
    print('Selected Dropdown Item: $_selected');
    print('ID: ${_idController.text}');
    print('E-mail: ${_emailController.text}');
    print('Phone Number: ${_phoneNumberController.text}');

    // 변경된 정보를 저장할 변수에 저장
    String newName = _nameController.text;
    String newIntro = _introController.text;
    String newSelected = _selected;
    String newId = _idController.text;
    String newEmail = _emailController.text;
    String newPhoneNumber = _phoneNumberController.text;

    // 여기에 변경된 정보를 데이터베이스나 파일에 저장하는 로직을 추가
    // 예를 들어, 데이터베이스에 저장하는 경우:
    // databaseService.updateUserProfile(newName, newIntro, newSelected, newId, newEmail, newPhoneNumber);

    // 저장 후에는 사용자에게 저장되었음을 알리는 메시지를 표시할 수 있습니다.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('수정 완료!'),
      ),
    );

    // 변경된 정보를 표시하기 위해 화면을 다시 빌드합니다.
    setState(() {
      // 변경된 정보를 반영하여 화면을 다시 그리는 로직을 추가합니다.
      _name = newName;
      _intro = newIntro;
      _selected = newSelected;
      _id = newId;
      _email = newEmail;
      _phoneNumber = newPhoneNumber;
    });
  }

  void _saveAndNavigateToViewProfile(BuildContext context) {
    // 저장 버튼 클릭 시 변경된 정보를 저장하고 조회 페이지로 이동
    _saveChanges();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewProfile(
          name: _name,
          intro: _intro,
          email: _email,
          id: _id,
          phoneNumber: _phoneNumber,
          contactTime: _selected,
        ),
      ),
    );
  }
}
