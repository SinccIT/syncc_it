import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncc_it/home_page.dart';

class TabBarScreen extends StatefulWidget {
  final int selectedIndex;
  final void Function(int index) onItemTapped;

  const TabBarScreen({Key? key, required this.selectedIndex, required this.onItemTapped}) : super(key: key);

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

// 상태 클래스
class _TabBarScreenState extends State<TabBarScreen> {
  late SharedPreferences prefs;
  late List<String> _groupItems;
  late List<String> _groupItemDescriptions;
  late bool _initialized = false;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _groupItems = prefs.getStringList('groupItems') ?? [];
    _groupItemDescriptions = prefs.getStringList('groupItemDescriptions') ?? [];
    setState(() {
      _initialized = true;
    });
  }

  void _addItem(String item, String description) async {
    setState(() {
      _groupItems.add(item);
      _groupItemDescriptions.add(description);
    });
    await prefs.setStringList('groupItems', _groupItems);
    await prefs.setStringList('groupItemDescriptions', _groupItemDescriptions);
  }

  void _removeItem(int index) async {
    setState(() {
      _groupItems.removeAt(index);
      _groupItemDescriptions.removeAt(index);
    });
    await prefs.setStringList('groupItems', _groupItems);
    await prefs.setStringList('groupItemDescriptions', _groupItemDescriptions);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: CustomAppBar(),

      body: ListView.builder(
        itemCount: _groupItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.compare),
              title: Text(
                _groupItems[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_groupItemDescriptions[index]),
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
              builder: (context) => AddContactScreen(onAdd: _addItem),
            ),
          );
        },
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // 선택된 인덱스 업데이트
          });
          widget.onItemTapped(index); // 전달된 콜백 함수 호출
        },
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

      appBar: CustomAppBar(),

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
