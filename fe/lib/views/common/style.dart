// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//Colors
// const Color mainColor = Color(0xfffdc81a);
const Color mainColor = Color.fromARGB(255, 90, 144, 43);

const Color red = Colors.red;
const Color yellow = Colors.yellow;
const Color black = Colors.black;
const Color white = Colors.white;
const Color orange = Color(0xfffdc81a);
const Color grey = Colors.grey;
const Color colorPage = Color.fromARGB(255, 234, 234, 234);
Color colorBGIconOverviewDataBox1 = Color(0xff7D00B5);
const borderRadiusIconOverviewDataBox = BorderRadius.all(
  Radius.elliptical(10, 10),
);


BoxShadow boxShadowContainer = BoxShadow(
  color: Color.fromARGB(255, 224, 224, 224).withOpacity(0.5),
  spreadRadius: 2,
  blurRadius: 12,
  offset: Offset(4, 8), // changes position of shadow
);

//Borderadius box container
const borderRadiusContainer = BorderRadius.all(
  Radius.elliptical(8, 8),
);
Border borderAllContainerBox = Border.all(width: 1, color: Color(0xffDADADA));
const paddingBoxContainer = EdgeInsets.all(15);


TextStyle titleWidget =TextStyle(color: const Color(0xff1C4281), fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none);
TextStyle textBtn =TextStyle(
  letterSpacing: 0.1,
  wordSpacing: 1,
  height: 1.2,
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
TextStyle titlePage =TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black);
TextStyle textNormal =TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black);
TextStyle textTitleNavbar =TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white);
TextStyle textTitleNavbarBlack =TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textDropdownTitle =TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black);
TextStyle textDropdownTitleRed =TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 251, 8, 8));
TextStyle textDropdownTitleMain =TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: mainColor);
TextStyle textDropdownTitleOrange =TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 164, 115, 0));
TextStyle textDropdownTitleGreen =TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 3, 168, 0));
TextStyle textCardContentBlack =TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textCardContentBlue =TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: const Color.fromRGBO(2, 62, 116, 1));
TextStyle textCardTitle =TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: const Color.fromRGBO(2, 62, 116, 1));
TextStyle titleContainerBox =TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textBtnWhite =TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white);
TextStyle textBtnBlack =TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black);
TextStyle textDataColumn =TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textDataRow =TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black);
TextStyle textBtnTopic =TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textBtnTopicWhite =TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white);
TextStyle textTitleAlertDialog =TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black);
double verticalPaddingPage = 35;
double horizontalPaddingPage = 50;

EdgeInsets paddingPage = EdgeInsets.symmetric(vertical: verticalPaddingPage, horizontal: horizontalPaddingPage);
TextStyle titleOverviewDataBox = TextStyle(
  color: Color(0xff7F838B),
  fontSize: 14,
  letterSpacing: 0.1,
);
TextStyle dataOverviewDataBox = TextStyle(
  color: Color(0xff141B2B),
  fontSize: 20,
  letterSpacing: 0.1,
);