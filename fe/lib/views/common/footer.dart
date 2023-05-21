import 'package:fe/views/common/style.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: white,
      ),
      child: const Center(
        child: Text(
          "Phần mềm quản lý trông xe trường Đại học Công nghiệp Hà Nội",
          style: TextStyle(overflow: TextOverflow.clip, fontSize: 15, color: black,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
