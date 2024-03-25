import 'package:flutter/cupertino.dart';

class MessageScreen extends StatefulWidget {
  final int selectedIndex;
  final void Function(int index) onItemTapped;

  const MessageScreen({Key? key, required this.selectedIndex, required this.onItemTapped}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
