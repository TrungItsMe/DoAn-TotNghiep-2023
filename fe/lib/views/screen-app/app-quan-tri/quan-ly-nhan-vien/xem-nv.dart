// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, unused_local_variable
import 'dart:async';
import 'package:fe/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../config.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/status.dart';
import '../../../common/footer.dart';
import '../../../common/header.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';

class XemNVScreen extends StatefulWidget {
  User data;
  XemNVScreen({Key? key, required this.data}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<XemNVScreen> {
  var diaChi = "";
  @override
  void initState() {
    super.initState();

    diaChi = widget.data.diaChi ?? "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Header(
        widgetBody: Consumer<SecurityModel>(
      builder: (context, user, child) => Scaffold(
        body: ListView(
          controller: ScrollController(),
          children: [
            TitlePage(
              listPreTitle: [],
              content: 'Thông tin chi tiết',
            ),
            Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: borderRadiusContainer,
                  boxShadow: [boxShadowContainer],
                  border: borderAllContainerBox,
                ),
                padding: paddingBoxContainer,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (widget.data.avatar != "" && widget.data.avatar != null)
                            ? Image.network(
                                "$baseUrl/api/files/${widget.data.avatar}",
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "/images/noavatar.png",
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      children: [
                        Container(
                          width: 300,
                          margin: EdgeInsets.only(right: 20, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Mã người dùng ",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                child: TextBoxCustom(
                                  enabled: false,
                                  height: 40,
                                  controller: TextEditingController(
                                      text: widget.data.userCode),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: EdgeInsets.only(right: 20, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Tên người dùng ",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                child: TextBoxCustom(
                                  enabled: false,
                                  height: 40,
                                  controller: TextEditingController(
                                      text: widget.data.fullName),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: EdgeInsets.only(right: 20, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Email ",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                child: TextBoxCustom(
                                  enabled: false,
                                  height: 40,
                                  controller: TextEditingController(
                                      text: widget.data.email),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: EdgeInsets.only(right: 20, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Số điện thoại ",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                child: TextBoxCustom(
                                  enabled: false,
                                  height: 40,
                                  controller: TextEditingController(
                                      text: widget.data.sdt),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (widget.data.role == 1)
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 20, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Ngày sinh ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 300,
                                  child: TextBoxCustom(
                                    enabled: false,
                                    height: 40,
                                    controller: TextEditingController(
                                        text: DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(
                                                widget.data.ngaySinh!))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (widget.data.role == 1)
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 20, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Ngày vào ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 300,
                                  child: TextBoxCustom(
                                    enabled: false,
                                    height: 40,
                                    controller: TextEditingController(
                                        text: DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(
                                                widget.data.ngayVao!))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (widget.data.role == 1)
                          Container(
                            width: 300,
                            margin: EdgeInsets.only(right: 20, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Giới tính ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 300,
                                  child: TextBoxCustom(
                                      enabled: false,
                                      height: 40,
                                      controller: TextEditingController(
                                          text: widget.data.gioiTinh == 0
                                              ? "Nam"
                                              : "Nữ")),
                                ),
                              ],
                            ),
                          ),
                        if (widget.data.role == 1)
                          Tooltip(
                            message: diaChi,
                            child: Container(
                              width: 300,
                              margin: EdgeInsets.only(right: 20, bottom: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Địa chỉ ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 300,
                                    child: TextBoxCustom(
                                      enabled: false,
                                      height: 40,
                                      controller:
                                          TextEditingController(text: diaChi),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Trở về', style: textBtnWhite),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 211, 55, 44),
                            elevation: 3,
                            minimumSize: Size(100, 40),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
            Footer()
          ],
        ),
      ),
    ));
  }
}
