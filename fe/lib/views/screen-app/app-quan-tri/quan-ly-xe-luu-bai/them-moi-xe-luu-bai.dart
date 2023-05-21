// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously, must_be_immutable
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/xe-luu-bai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/bai-xe.dart';
import '../../../../models/status.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/toast.dart';

class ThemMoiXeLuuBai extends StatefulWidget {
  Function callBack;
  ThemMoiXeLuuBai({Key? key, required this.callBack}) : super(key: key);
  @override
  State<ThemMoiXeLuuBai> createState() => _State();
}

class _State extends State<ThemMoiXeLuuBai> {
  XeLuuBai data = XeLuuBai();
  TextEditingController bienSo = TextEditingController();
  TextEditingController moTa = TextEditingController();
  Status selectLoaiXe = Status(id: null, name: "--Chọn--");
  Future<List<Status>> callGender() async {
    var object = [
      {"id": 0, "name": "Xe đạp"},
      {"id": 1, "name": "Xe máy"},
      {"id": 2, "name": "Ô tô"},
      {"id": 3, "name": "Khác"},
    ];
    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    return listStatus;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bienSo.dispose();
    moTa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityModel>(
      builder: (context, user, child) => AlertDialog(
          content: SizedBox(
        width: 460,
        height: 420,
        child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Thêm mới', style: textTitleAlertDialog),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.callBack(false);
                },
                icon: Icon(Icons.close)),
          ]),
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
                      'Loại xe ',
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
                    selectedItem: selectLoaiXe,
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
                          borderSide:
                              BorderSide(color: Colors.black45, width: 1 / 5),
                        ),
                        // hintText: hintText ?? '--Trạng thái--',
                        hintMaxLines: 1,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          borderSide:
                              BorderSide(color: Colors.black45, width: 1 / 5),
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
                      selectLoaiXe = value!;
                    },
                  ))
            ],
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
                      'Bãi xe ',
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
                child: DropdownSearch<BaiXe>(
                  asyncItems: (String? filter) => callBx(),
                  itemAsString: (BaiXe? u) => "${u!.code} - ${u.name}",
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
                        borderSide:
                            BorderSide(color: Colors.black45, width: 1 / 5),
                      ),
                      hintMaxLines: 1,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        borderSide:
                            BorderSide(color: Colors.black45, width: 1 / 5),
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
                      'Biển số ',
                      style: textDropdownTitle,
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
                      controller: bienSo,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Mô tả ',
                      style: textDropdownTitle,
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
                      controller: moTa,
                      width: 300,
                      maxLines: 20,
                      minLines: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          const Divider(thickness: 1, color: Colors.black),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (selectLoaiXe.id == null || selectedBx.id == null) {
                    showToast(
                      context: context,
                      msg: "Cần nhập đủ thông tin",
                      color: Colors.orange,
                      icon: const Icon(Icons.warning),
                    );
                  } else {
                    data.idNvT = user.user.id;
                    data.idBx = selectedBx.id;
                    data.xe = selectLoaiXe.id;
                    data.bienSo = bienSo.text;
                    data.moTa = moTa.text;
                    data.status = 0;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              content: Container(
                                height: 120,
                                width: 460,
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    Text('Xác nhận thêm mới',
                                                        style:
                                                            textTitleAlertDialog),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    {Navigator.pop(context)},
                                                icon: Icon(Icons.close),
                                              ),
                                            ]),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        const Divider(
                                            thickness: 1, color: Colors.black),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                await httpPost(
                                                    "/api/xe-luu-bai/post",
                                                    data.toJson(),
                                                    context);
                                                showToast(
                                                  context: context,
                                                  msg: "Thêm mới thành công",
                                                  color: Color.fromARGB(
                                                      136, 72, 238, 67),
                                                  icon: const Icon(Icons.done),
                                                );
                                                widget.callBack(true);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Xác nhận'),
                                              style: ElevatedButton.styleFrom(
                                                primary: Color.fromARGB(
                                                    255, 100, 181, 248),
                                                onPrimary: Colors.white,
                                                minimumSize: Size(100, 40),
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Hủy',
                                                  style: textBtnWhite),
                                              style: ElevatedButton.styleFrom(
                                                primary: Color.fromARGB(
                                                    255, 255, 132, 124),
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
          ),
        ]),
      )),
    );
  }
}
