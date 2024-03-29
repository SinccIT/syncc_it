import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncc_it/auth_service.dart';
import 'dart:io';
import 'package:syncc_it/view_profile.dart';

class MyProfile extends StatefulWidget {
  final SharedPreferences prefs;

  const MyProfile({Key? key, required this.prefs}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  XFile? _imageFile;
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

  late TextEditingController _nameController;
  late TextEditingController _introController;
  late TextEditingController _emailController;
  late TextEditingController _idController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.prefs.getString('name') ?? '');
    _introController =
        TextEditingController(text: widget.prefs.getString('intro') ?? '');
    _emailController =
        TextEditingController(text: widget.prefs.getString('email') ?? '');
    _idController =
        TextEditingController(text: widget.prefs.getString('id') ?? '');
    _phoneNumberController = TextEditingController(
        text: widget.prefs.getString('phoneNumber') ?? '');
    _selected = widget.prefs.getString('selectedContactTime') ?? '9am-10am';
    String? imagePath = widget.prefs.getString('profileImage');
    if (imagePath != null) {
      _imageFile = XFile(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService,child) {
        User? user = authService.currentUser();

        return Scaffold(
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
                        _nameController.text,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.edit, size: 20),
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
                        _introController.text,
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
                Text(
                  'Email',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]
                ),
                SizedBox(height: 32),
                nameTextFieldWithIcon(
                    'Phone Number', _phoneNumberController, Icons.edit),
                SizedBox(height: 32),
                buildContactTimeDropdown(),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _saveAndNavigateToViewProfile,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF27F39D)),
                  ),
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _navigateToViewProfile,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF27F39D)),
                  ),
                  child: Text(
                    '프로필 보기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      await _saveImageToGallery(pickedFile.path);
      Navigator.pop(context);
    }
  }

  Future<void> _saveImageToGallery(String imagePath) async {
    // 이미지를 갤러리에 저장하는 로직을 구현하세요.
  }

  void chooseImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      Navigator.pop(context);
    }
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            '프로필 사진 변경',
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
                  onPressed: takePhoto,
                  label: Text(
                    '카메라',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextButton.icon(
                  icon: Icon(Icons.photo_library, size: 50),
                  onPressed: chooseImage,
                  label: Text(
                    '갤러리',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _imageFile = null;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    '기본 이미지 선택',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
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
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => _buildBottomSheet(context)),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nameTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 15), // 수정된 부분
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
    List<String> contactTimeOptions = ['상관없음'] + _items; // "상관없음" 옵션을 추가합니다.

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
        items: contactTimeOptions.map((String value) {
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
          title: Text('이름 입력'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "이름을 입력 하세요"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _nameController.text = _nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('저장'),
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
          title: Text('한줄 소개'),
          content: TextField(
            controller: _introController,
            decoration: InputDecoration(hintText: "Enter your introduction"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _introController.text = _introController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  void _saveAndNavigateToViewProfile() async {
    widget.prefs.setString('name', _nameController.text);
    widget.prefs.setString('intro', _introController.text);
    widget.prefs.setString('email', _emailController.text);
    widget.prefs.setString('id', _idController.text);
    widget.prefs.setString('phoneNumber', _phoneNumberController.text);
    widget.prefs.setString('selectedContactTime', _selected);
    if (_imageFile != null) {
      // 이미지 파일이 있는 경우에만 저장합니다.
      await widget.prefs.setString('profileImage', _imageFile!.path);
    } else {
      // 이미지 파일이 없는 경우 기본 이미지를 저장합니다.
      widget.prefs.remove('profileImage');
    }

    // 수정된 정보를 저장하고 프로필 보기 페이지로 이동합니다.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewProfile(
          name: _nameController.text,
          intro: _introController.text,
          email: _emailController.text,
          id: _idController.text,
          phoneNumber: _phoneNumberController.text,
          contactTime: _selected,
          profileImage: _imageFile?.path ?? '',
        ),
      ),
    );
  }

  void _navigateToViewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewProfile(
          name: _nameController.text,
          intro: _introController.text,
          email: _emailController.text,
          id: _idController.text,
          phoneNumber: _phoneNumberController.text,
          contactTime: _selected,
          profileImage: _imageFile?.path ?? '',
        ),
      ),
    );
  }
}
