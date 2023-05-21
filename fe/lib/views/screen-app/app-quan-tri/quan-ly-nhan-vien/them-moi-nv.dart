// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../config.dart';
import '../../../../controllers/api.dart';
import '../../../../models/status.dart';
import '../../../common/date-picker.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/toast.dart';

class ThemMoiNV extends StatefulWidget {
  final Function callBack;
  ThemMoiNV({Key? key, required this.callBack}) : super(key: key);
  @override
  State<ThemMoiNV> createState() => _State();
}

class _State extends State<ThemMoiNV> {
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");

  User data = User();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sdt = TextEditingController();
  TextEditingController cccd = TextEditingController();
  TextEditingController diaChi = TextEditingController();
  Status selectGioiTinh = Status(id: null, name: "--Chọn--");
  DateTime? ngaySinh;
  DateTime? ngayVao;
  Future<List<Status>> callGender() async {
    var object = [
      {"id": 0, "name": "Nam"},
      {"id": 1, "name": "Nữ"},
    ];
    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    return listStatus;
  }

  String avatar = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    sdt.dispose();
    diaChi.dispose();
    cccd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 460,
        height: 750,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Thêm mới', style: textTitleAlertDialog),
              IconButton(onPressed: () => {Navigator.pop(context)}, icon: Icon(Icons.close)),
            ]),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 15),
            SizedBox(
              width: 100,
              height: 100,
              child: (data.avatar == "" || data.avatar == null) ? Image.asset("/images/noavatar.png") : Image.network("$baseUrl/api/files/${data.avatar}"),
            ),
            SizedBox(height: 10),
            Center(
              child: OutlinedButton(
                child: Text("Tải ảnh"),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['png', 'JPEG', 'JPG', 'TIFF', 'GIF'],
                    withReadStream: true,
                    allowMultiple: false,
                  );
                  if (result != null) {
                    var avatarImage = await uploadFile(result, context: context);
                    setState(() {
                      data.avatar = avatarImage;
                    });
                  } else {
                    return showToast(
                      context: context,
                      msg: "Chọn lại file",
                      color: Color.fromRGBO(245, 117, 29, 1),
                      icon: const Icon(Icons.info),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Tên nv ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      TextBoxCustom(
                        controller: name,
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Email ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      TextBoxCustom(
                        controller: email,
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'SDT ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      TextBoxCustom(
                        controller: sdt,
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Ngày sinh ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: DatePickerBox(
                    selectedDate: ngaySinh,
                    width: 300,
                    decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
                    callBack: (value) {
                      ngaySinh = value;
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Ngày vào ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: DatePickerBox(
                    selectedDate: ngayVao,
                    width: 300,
                    decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
                    callBack: (value) {
                      ngayVao = value;
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Giới tính ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    flex: 4,
                    child: DropdownSearch<Status>(
                      selectedItem: selectGioiTinh,
                      asyncItems: (String? filter) => callGender(),
                      itemAsString: (Status? u) => u!.name.toString(),
                      // items: widget.listStatus ?? [],
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
                          // hintText: hintText ?? '--Trạng thái--',
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
                        showSearchBox: false,
                      ),
                      onChanged: (value) {
                        selectGioiTinh = value!;
                      },
                    ))
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Địa chỉ ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      TextBoxCustom(
                        controller: diaChi,
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'CCCD ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      TextBoxCustom(
                        controller: cccd,
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            const SizedBox(height: 10),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (name.text == "" || email.text == "" || sdt.text == "" || diaChi.text == "" || ngaySinh == null || selectGioiTinh.id == null) {
                      showToast(
                        context: context,
                        msg: "Cần nhập đủ thông tin",
                        color: Colors.orange,
                        icon: const Icon(Icons.warning),
                      );
                    } else {
                      String maNv = "";
                      var responseNV = await httpGet("/api/nguoi-dung/get/page?filter=role:1&sort=id,desc", context);
                      var bodyNv = jsonDecode(responseNV['body']);
                      var content = [];
                      content = bodyNv['result']['content'];
                      if (content.isNotEmpty) {
                        int id = content.first['id'] + 1;
                        if (id < 10) {
                          maNv = "NV0000$id";
                        } else if (id < 100) {
                          maNv = "NV000$id";
                        } else if (id < 1000) {
                          maNv = "NV00$id";
                        } else if (id < 10000) {
                          maNv = "NV0$id";
                        } else if (id < 100000) {
                          maNv = "NV$id";
                        }
                      } else {
                        maNv = "NV00001";
                      }
                      data.role = 1;
                      data.fullName = name.text;
                      data.userCode = maNv;
                      data.email = email.text;
                      data.sdt = sdt.text;
                      data.diaChi = diaChi.text;
                      data.ngaySinh = DateFormat('yyyy-MM-dd').format(ngaySinh!);
                      data.ngayVao = DateFormat('yyyy-MM-dd').format(ngayVao!);
                      data.gioiTinh = selectGioiTinh.id;
                      data.cccd = cccd.text;
                      data.status = 1;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Container(
                                  height: 370,
                                  width: 460,
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            SizedBox(
                                              child: Row(
                                                children: [
                                                  Text('Xác nhận thêm mới', style: textTitleAlertDialog),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => {Navigator.pop(context)},
                                              icon: Icon(Icons.close),
                                            ),
                                          ]),
                                          const SizedBox(height: 10),
                                          const Divider(thickness: 1, color: Colors.black),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                      Flexible(
                                        child: Text("Thêm mới: ${data.fullName}", style: textNormal),
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          const Divider(thickness: 1, color: Colors.black),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  var responseDK = await httpPost("/api/nguoi-dung/post", data.toJson(), context);
                                                  var bodyDK = jsonDecode(responseDK["body"]);
                                                  if (bodyDK['success'] == true) {
                                                    showToast(
                                                      context: context,
                                                      msg: "Thêm mới thành công",
                                                      color: Color.fromARGB(136, 72, 238, 67),
                                                      icon: const Icon(Icons.done),
                                                    );
                                                    widget.callBack(true);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  } else {
                                                    showToast(
                                                      context: context,
                                                      msg: "${bodyDK['result']}",
                                                      color: Colors.orange,
                                                      icon: const Icon(Icons.warning),
                                                    );
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text('Xác nhận'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(255, 100, 181, 248),
                                                  onPrimary: Colors.white,
                                                  minimumSize: Size(100, 40),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(context),
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
                                      )
                                    ],
                                  ),
                                ),
                              ));
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
                    widget.callBack(false);
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
    );
  }
}
