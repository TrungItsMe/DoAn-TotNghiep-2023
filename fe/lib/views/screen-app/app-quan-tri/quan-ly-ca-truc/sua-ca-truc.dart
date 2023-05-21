// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use, sort_child_properties_last
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/bai-xe.dart';
import 'package:fe/models/ca-truc.dart';
import 'package:fe/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/status.dart';
import '../../../common/date-picker.dart';
import '../../../common/dropdow_search_common.dart';
import '../../../common/footer.dart';
import '../../../common/header.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';
import 'package:intl/intl.dart';

import '../../../common/toast.dart';

class SuaCTScreen extends StatefulWidget {
  CaTruc data;
  final Function callBack;
  SuaCTScreen({Key? key, required this.callBack, required this.data})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SuaCTScreen> {
  //Load
  Future<void> processing() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  CaTruc data = CaTruc();
  User selectedUser = User(id: null, userCode: "--Chọn-", fullName: "");
  Future<List<User>> callUser() async {
    List<User> listData = [];
    try {
      var response = await httpGet(
          "/api/nguoi-dung/get/page?filter=status:1 and role:1&size=1000",
          context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listData = content.map((e) {
              return User.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listData;
  }

  BaiXe selectedBx = BaiXe(id: null, code: "--Chọn-", name: "");
  Future<List<BaiXe>> callBx() async {
    List<BaiXe> listData = [];
    try {
      var response = await httpGet(
          "/api/bai-xe/get/page?filter=status:1&size=1000", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listData = content.map((e) {
              return BaiXe.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listData;
  }

  Status selectStatus = Status(id: null, name: "--Chọn--");
  DateTime now = DateTime.now();
  DateTime gioiHan = DateTime.now();

  DateTime? chonNgayStrat;
  String? chonGioStart;
  DateTime? chonNgayEnd;
  String? chonGioEnd;
  TextEditingController noiDung = TextEditingController();
  @override
  void initState() {
    super.initState();
    gioiHan = now.subtract(const Duration(days: 1));
    data = widget.data;
    selectedUser = data.nhanVien!;
    selectedBx = data.baiXe!;
    chonNgayStrat = DateTime.parse(data.startTime!).toLocal();
    selectStatus = (data.ca == 0)
        ? Status(id: 0, name: "Ca ngày")
        : Status(id: 1, name: "Ca đêm");
    noiDung.text = data.noiDung ?? "";
  }

  @override
  void dispose() {
    noiDung.dispose();
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
              listPreTitle: [
                {'url': "/trang-chu", 'title': 'Trang chủ'},
                {
                  'url': "/quan-ly-ca-truc",
                  'title': 'Quản lý ca trực nhiện vụ'
                },
              ],
              content: "Cập nhật",
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView(
                    controller: ScrollController(),
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: borderRadiusContainer,
                          boxShadow: [boxShadowContainer],
                          border: borderAllContainerBox,
                        ),
                        padding: paddingBoxContainer,
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                rederNV(),
                                rederBx(),
                                Container(
                                  width: 300,
                                  margin: const EdgeInsets.only(
                                      bottom: 20, left: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Ngày trực ',
                                            style: textDropdownTitle,
                                          ),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      DatePickerBox(
                                        gioiHan: gioiHan,
                                        // isHourl: true,
                                        selectedDate: chonNgayStrat,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1 / 5,
                                                color: Colors.black45),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        callBack: (value) {
                                          chonNgayStrat = value;
                                        },
                                        callBackHuor: (value) {
                                          chonGioStart = value;
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                DropdowSearchComon(
                                  listStatusSelect: const [
                                    {"id": 0, "name": "Ca ngày"},
                                    {"id": 1, "name": "Ca đêm"},
                                  ],
                                  selectedItemStatus: selectStatus,
                                  removeSelection: "removeSelection",
                                  selectStatus: 2,
                                  onChangedCallback: (value) {
                                    selectStatus = value;
                                  },
                                  indexTypeDropdow: 5,
                                  labelDropdow: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Ca trực ",
                                            style: textDropdownTitle,
                                          ),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  widthDropdow: 300,
                                  heightStatus: 170,
                                  marginDropdow:
                                      EdgeInsets.only(left: 20, bottom: 20),
                                ),
                                rederND()
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    processing();

                                    if (chonNgayStrat == null ||
                                        chonGioStart == null ||
                                        chonNgayEnd == null ||
                                        chonNgayEnd == null ||
                                        selectedBx.id == null ||
                                        selectedUser.id == null) {
                                      showToast(
                                        context: context,
                                        msg: "Cần nhập đủ thông tin",
                                        color: Colors.orange,
                                        icon: const Icon(Icons.warning),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      data.idNv = selectedUser.id;
                                      data.idBx = selectedBx.id;
                                      data.ca = selectStatus.id;
                                      if (data.ca == 0) {
                                        data.startTime =
                                            "${DateFormat('yyyy-MM-dd').format(chonNgayStrat!)}T06:00:00";
                                        data.endTime =
                                            "${DateFormat('yyyy-MM-dd').format(chonNgayStrat!)}T22:00:00";
                                      } else {
                                        data.startTime =
                                            "${DateFormat('yyyy-MM-dd').format(chonNgayStrat!)}T22:00:00";
                                        data.endTime =
                                            "${DateFormat('yyyy-MM-dd').format(chonNgayStrat!.add(Duration(days: 1)))}T06:00:00";
                                      }
                                      data.noiDung = noiDung.text;
                                      // print(data.toJson());
                                      await httpPut(
                                          "/api/ca-truc/put/${data.id}",
                                          data.toJson(),
                                          context);
                                      widget.callBack(data);
                                      showToast(
                                        context: context,
                                        msg: "Cập nhật thành công",
                                        color: Color.fromARGB(136, 72, 238, 67),
                                        icon: const Icon(Icons.done),
                                      );
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    'Lưu',
                                    style: textBtnWhite,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 9, 209, 26),
                                    onPrimary: Colors.white,
                                    elevation: 3,
                                    minimumSize: Size(100, 40),
                                  ),
                                ),
                                SizedBox(width: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    widget.callBack(widget.data);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Hủy', style: textBtnWhite),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 211, 55, 44),
                                    onPrimary: Colors.white,
                                    elevation: 3,
                                    minimumSize: Size(100, 40),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Footer()
          ],
        ),
      ),
    ));
  }

  rederNV() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Nhân viên trực ',
                style: textDropdownTitle,
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: DropdownSearch<User>(
              asyncItems: (String? filter) => callUser(),
              itemAsString: (User? u) => "${u!.userCode}-${u.fullName}",
              selectedItem: selectedUser,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  constraints: BoxConstraints.tightFor(
                    width: 300,
                    height: 40,
                  ),
                  contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                  ),
                  hintMaxLines: 1,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                  ),
                ),
              ),
              popupProps: const PopupPropsMultiSelection.menu(
                constraints: BoxConstraints.expand(
                  width: 300,
                  height: 300,
                ),
                showSearchBox: true,
              ),
              onChanged: (value) {
                setState(() {
                  selectedUser = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  rederBx() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Bãi xe ',
                style: textDropdownTitle,
              ),
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: DropdownSearch<BaiXe>(
              asyncItems: (String? filter) => callBx(),
              itemAsString: (BaiXe? u) => "${u!.code}-${u.name}",
              selectedItem: selectedBx,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  constraints: BoxConstraints.tightFor(
                    width: 300,
                    height: 40,
                  ),
                  contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                  ),
                  hintMaxLines: 1,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                  ),
                ),
              ),
              popupProps: const PopupPropsMultiSelection.menu(
                constraints: BoxConstraints.expand(
                  width: 300,
                  height: 300,
                ),
                showSearchBox: true,
              ),
              onChanged: (value) {
                setState(() {
                  selectedBx = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  rederND() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nội dung',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              controller: noiDung,
              maxLines: 50,
              minLines: 4,
            ),
          )
        ],
      ),
    );
  }
}
