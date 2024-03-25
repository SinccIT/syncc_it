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

  void _addItemToContacts(String item, String description) async {
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
  final Function(String, String) onAdd;

  const AddContactScreen1({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddContactScreenState1 createState() => _AddContactScreenState1();
}

class _AddContactScreenState1 extends State<AddContactScreen1> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('연락처 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final description = _descriptionController.text;
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
