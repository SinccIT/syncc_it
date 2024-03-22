import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  late SharedPreferences prefs;
  late List<String> _sharedItems;
  late List<String> _sharedDescriptions;
  late bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _sharedItems = prefs.getStringList('contactItems') ?? [];
    _sharedDescriptions = prefs.getStringList('contactItemDescriptions') ?? [];
    setState(() {
      _initialized = true;
    });
  }

  void _addItem(String item, String description) async {
    setState(() {
      _sharedItems.add(item);
      _sharedDescriptions.add(description);
    });
    await prefs.setStringList('_sharedItems', _sharedItems);
    await prefs.setStringList('_sharedDescriptions', _sharedDescriptions);
  }

  void _removeItem(int index) async {
    setState(() {
      _sharedItems.removeAt(index);
      _sharedDescriptions.removeAt(index);
    });
    await prefs.setStringList('_sharedItems', _sharedItems);
    await prefs.setStringList('_sharedDescriptions', _sharedDescriptions);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Center(child: CircularProgressIndicator()); // 로딩 인디케이터 중앙 정렬
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('그룹 목록'),
      ),
      body: ListView.builder(
        itemCount: _sharedItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3, // 그림자 효과
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.share),
              title: Text(
                _sharedItems[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_sharedDescriptions[index]),
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
                              Navigator.of(context).pop(); // 모달 닫기
                            },
                            child: Text("취소"),
                          ),
                          TextButton(
                            onPressed: () {
                              // 항목 삭제
                              setState(() {
                                _removeItem(index);
                              });
                              Navigator.of(context).pop(); // 모달 닫기
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
  final Function(String, String) onAdd;

  const AddContactScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late TextEditingController _nameController1;
  late TextEditingController _descriptionController1;

  @override
  void initState() {
    super.initState();
    _nameController1 = TextEditingController();
    _descriptionController1 = TextEditingController();
  }

  @override
  void dispose() {
    _nameController1.dispose();
    _descriptionController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('그룹 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController1,
              decoration: InputDecoration(
                labelText: 'Group Name',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController1,
              decoration: InputDecoration(
                labelText: 'Group Description',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                final name = _nameController1.text;
                final description = _descriptionController1.text;
                widget.onAdd(name, description);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
