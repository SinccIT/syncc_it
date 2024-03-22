// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class AddItemScreen1 extends StatefulWidget {
//   @override
//   _AddItemScreen1State createState() => _AddItemScreen1State();
// }
//
// class _AddItemScreen1State extends State<AddItemScreen1> {
//   late TextEditingController _textEditingController;
//
//   @override
//   void initState() {
//     super.initState();
//     _textEditingController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("새로운 연락처 추가"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _textEditingController,
//               decoration: InputDecoration(labelText: '연락처 이름'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // 입력된 항목을 전달하고 창 닫기
//                 Navigator.pop(context, _textEditingController.text);
//               },
//               child: Text('추가'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // 각 아이템에 대한 설명 배열
// List<String> contactItemDescriptions = [
//   "박채연 설명",
//   "유윤경 설명",
//   "김성종 설명",
//   "이한조 설명",
//   "백승용 설명",
//   "송가람 설명",
//   // 추가적인 아이템들에 대한 설명을 배열에 추가하세요
// ];
