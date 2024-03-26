import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final double size;
  final Widget? child;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    this.size = 36.0,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onChanged(!widget.value); // 부모 위젯의 상태를 업데이트
        });
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.0), // 사각형 형태로 설정
          border: Border.all(
            color: Colors.transparent,
            width: 2.0,
          ),
        ),
        child: widget.value
            ? Image.asset(
                'assets/images/checked.png',
                width: widget.size,
                height: widget.size,
              )
            : Image.asset(
                'assets/images/unchecked.png',
                width: widget.size,
                height: widget.size,
              ),
      ),
    );
  }
}
