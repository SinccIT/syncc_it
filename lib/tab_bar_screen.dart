import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncc_it/tab_bar_screen1.dart';

import 'group_detail.dart';

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  late SharedPreferences prefs;
  late List<String> _groupItems;
  late List<String> _groupItemDescriptions;
  late List<String> _groupItemTags;
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

  void _addItem(String item, String description, String tags) async {
    setState(() {
      _groupItems.add(item);
      _groupItemDescriptions.add(description);
      _groupItemTags.add(tags);
    });
    await prefs.setStringList('groupItems', _groupItems);
    await prefs.setStringList('groupItemDescriptions', _groupItemDescriptions);
    await prefs.setStringList('groupItemTags', _groupItemTags);
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
    );
  }
}

class AddContactScreen extends StatefulWidget {
  final Function(String, String, String) onAdd;

  const AddContactScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  final List<String> _selectedContacts = []; // List to store selected contacts

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _tagsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  // Method to fetch contacts - Replace this with your actual contact fetching logic
  Future<List<String>> _fetchContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? contactItems = prefs.getStringList('contactItems');
    List<String>? contactItemDescriptions =
        prefs.getStringList('contactItemDescriptions');

    if (contactItems != null && contactItemDescriptions != null) {
      // Combine contact items with descriptions
      List<String> contacts = [];
      for (int i = 0; i < contactItems.length; i++) {
        contacts.add('${contactItems[i]}');
      }
      return contacts;
    } else {
      // Return an empty list if no contacts are found
      return [];
    }
  }

  void _saveContact() async {
    String name = _nameController.text;
    String description = _descriptionController.text;
    String tags = _tagsController.text;

    // Perform any validation here before saving
    // For simplicity, let's assume all fields are required

    // Call the callback function to add the contact
    widget.onAdd(name, description, tags);

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D'),
                ),
              ),
              SizedBox(
                  height: 16.0), // Add some spacing below the profile image
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
                      return AlertDialog(
                        title: Text("멤버 추가"),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: contacts.map((contact) {
                              return ListTile(
                                title: Text(contact),
                                onTap: () {
                                  setState(() {
                                    _selectedContacts.add(contact);
                                  });
                                  Navigator.of(context).pop();
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
                        ],
                      );
                    },
                  );
                },
                child: Text('멤버 추가'),
              ),
              SizedBox(height: 12.0),
              // Display selected contacts
              Wrap(
                children: _selectedContacts.map((contact) {
                  return Chip(
                    label: Text(contact),
                    onDeleted: () {
                      setState(() {
                        _selectedContacts.remove(contact);
                      });
                    },
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
