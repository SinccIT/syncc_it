import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupName;
  final String groupDescription;
  final String groupTags; // groupTags 추가

  const GroupDetailScreen({
    Key? key,
    required this.groupName,
    required this.groupDescription,
    required this.groupTags, // 생성자에 groupTags 추가
  }) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  List<String> _members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Name: ${widget.groupName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Group Description: ${widget.groupDescription}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Group Tags: ${widget.groupTags}', // groupTags 출력
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Members:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_members[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addMember();
              },
              child: Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }

  void _addMember() {
    showDialog(
      context: context,
      builder: (context) {
        String newMember = '';

        return AlertDialog(
          title: Text('Add Member'),
          content: TextField(
            onChanged: (value) {
              newMember = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter member name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _members.add(newMember);
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
