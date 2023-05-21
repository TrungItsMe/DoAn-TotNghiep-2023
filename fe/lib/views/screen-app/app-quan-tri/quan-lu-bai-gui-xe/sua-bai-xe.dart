// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/bai-xe.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/api.dart';
import '../../../../models/status.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/toast.dart';

class CapNhatBaiXe extends StatefulWidget {
  BaiXe data;
  final Function callBack;
  CapNhatBaiXe({Key? key, required this.callBack, required this.data})
      : super(key: key);
  @override
  State<CapNhatBaiXe> createState() => _State();
}

class _State extends State<CapNhatBaiXe> {
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");
  Future<List<Status>> callStatus() async {
    var object = [
      {"id": 1, "name": "Mở"},
      {"id": 0, "name": "Đóng"},
    ];

    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    return listStatus;
  }

  BaiXe data = BaiXe();
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController dienTich = TextEditingController();
  TextEditingController maxSlot = TextEditingController();
  TextEditingController viTri = TextEditingController();

  @override
  void initState() {
    super.initState();
    data = widget.data;
    code.text = data.code ?? "";
    name.text = data.name ?? "";
    dienTich.text = data.dienTich ?? "";
    maxSlot.text = data.slotMax ?? "";
    viTri.text = data.viTri ?? "";
    if (data.status == 1) {
      selectStatus = Status(id: 1, name: "Mở");
    } else {
      selectStatus = Status(id: 0, name: "Đóng");
    }
  }

  @override
  void dispose() {
    code.dispose();
    name.dispose();
    dienTich.dispose();
    maxSlot.dispose();
    viTri.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 460,
        height: 470,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Cập nhật', style: textTitleAlertDialog),
              IconButton(
                  onPressed: () => {Navigator.pop(context)},
                  icon: Icon(Icons.close)),
            ]),
            const Divider(thickness: 1, color: Colors.black),
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
                        'Mã bãi ',
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
                        controller: code,
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
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
                        'Tên bãi ',
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
                        'Diện tích ',
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
                        controller: dienTich,
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
                        'Vị trí ',
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
                        controller: viTri,
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
                        'Trạng thái ',
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
                    selectedItem: selectStatus,
                    asyncItems: (String? filter) => callStatus(),
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
                        height: 130,
                      ),
                      showSearchBox: false,
                    ),
                    onChanged: (value) {
                      selectStatus = value!;
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (name.text == "" ||
                        code.text == "" ||
                        dienTich.text == "" ||
                        maxSlot.text == "" ||
                        viTri.text == "") {
                      showToast(
                        context: context,
                        msg: "Cần nhập đủ thông tin",
                        color: Colors.orange,
                        icon: const Icon(Icons.warning),
                      );
                    } else {
                      data.name = name.text;
                      data.code = code.text;
                      data.dienTich = dienTich.text;
                      data.slotMax = maxSlot.text;
                      data.viTri = viTri.text;
                      data.status = selectStatus.id;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Container(
                                  height: 470,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  child: Row(
                                                    children: [
                                                      Text('Xác nhận cập nhật',
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
                                          const SizedBox(height: 10),
                                          const Divider(
                                              thickness: 1,
                                              color: Colors.black),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                      Flexible(
                                        child: Text(
                                            "Cập nhật bãi xe: ${data.name}",
                                            style: textNormal),
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          const Divider(
                                              thickness: 1,
                                              color: Colors.black),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  // print(data.toJson());
                                                  var abc = await httpPut(
                                                      "/api/bai-xe/put/${data.id}",
                                                      data.toJson(),
                                                      context);
                                                  print(abc);
                                                  showToast(
                                                    context: context,
                                                    msg:
                                                        "Cập nhật chức vụ thành công",
                                                    color: Color.fromARGB(
                                                        136, 72, 238, 67),
                                                    icon:
                                                        const Icon(Icons.done),
                                                  );
                                                  widget.callBack(data);
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
                                                      255, 211, 55, 44),
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
    );
  }
}
