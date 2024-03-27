
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DataModel extends ChangeNotifier {

  List<Group> groupList = [
    Group(
        'One 에이전시',
        '파레트 프로젝트',
        [
          Contact('이한조', 'One 에이전시', 'Inactive'),
        ]
    ),
    Group(
        'Office',
        '사무실 연락망',
        [
          Contact('박채연', 'CloudMarketing / ABC Cloud Corp.', 'Active'),
          Contact('김성종', 'CloudMarketing / ABC Cloud Corp.', 'Inactive'),
          Contact('유윤경', 'CloudMarketing / ABC Cloud Corp.', 'Active'),
        ]
    ),
    Group(
        'LG생활건강',
        '파레트 프로젝트',
        [
          Contact('김한나', 'LG생활건강', 'Active'),
        ]
    ),
  ];

  List<Contact> contactList = [
    Contact('박채연', 'CloudMarketing / ABC Cloud Corp.', 'Active'),
    Contact('김성종', 'CloudMarketing / ABC Cloud Corp.', 'Inactive'),
    Contact('유윤경', 'CloudMarketing / ABC Cloud Corp.', 'Active'),
    Contact('송가람', 'CloudMarketing / ABC Cloud Corp.', 'Active'),
    Contact('이재형', 'CloudMarketing / ABC Cloud Corp.', 'Inactive'),
    Contact('백승용', 'CloudMarketing / ABC Cloud Corp.', 'Active'),
    Contact('이한조', 'One 에이전시', 'Inactive'),
    Contact('김한나', 'LG생활건강', 'Active'),
    Contact('Jane Smith', 'Colleague', 'Inactive'),
  ];

  void updateGroupList(List<Group> groupList) {
    this.groupList = groupList;
    notifyListeners();
  }

  void updateContactList(List<Contact> contactList) {
    this.contactList = contactList;
    notifyListeners();
  }
}

class DataProvider extends StatelessWidget {
  final Widget child;
  final DataModel dataModel;

  const DataProvider({super.key, required this.child, required this.dataModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataModel(),
      child: child,
    );
  }

  static DataModel of(BuildContext context, {bool listen = true}) {
    final provider = Provider.of<DataModel>(context, listen: listen);
    assert(provider != null, '해당 provider가 존재하지 않습니다.');
    return provider;
  }
}

class Contact {
  String name;
  String desc;
  String status;

  Contact(this.name, this.desc, this.status);
}

class Group {
  String groupName;
  String desc;
  List<Contact> contacts;

  Group(this.groupName, this.desc, this.contacts);
}