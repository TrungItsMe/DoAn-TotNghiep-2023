// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, unused_local_variable
import 'dart:async';
import 'dart:convert';

import 'package:fe/controllers/api.dart';
import 'package:fe/views/common/loadApi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/status.dart';
import '../../../../models/ve-xe.dart';
import '../../../common/date-picker.dart';
import '../../../common/dropdow_search_common.dart';
import '../../../common/footer.dart';
import '../../../common/header.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';
import '../../../common/toast.dart';

class SuaVeScreen extends StatefulWidget {
  VeXe data;
  Function? callback;
  SuaVeScreen({Key? key, this.callback, required this.data}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SuaVeScreen> {
  VeXe data = VeXe();
  Future<void> processing() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  bool statusData = true;
  Status selectType = Status(id: null, name: "--Chọn--");
  Status selectTypeXe = Status(id: null, name: "--Chọn--");
  Status selectCk = Status(id: null, name: "--Chọn--");
  Status selectTt = Status(id: null, name: "--Chọn--");
  DateTime? ngayHetHan;
  TextEditingController fullName = TextEditingController();
  TextEditingController chucVu = TextEditingController();
  TextEditingController donVi = TextEditingController();
  TextEditingController sdt = TextEditingController();
  TextEditingController diaChi = TextEditingController();
  TextEditingController bienSo = TextEditingController();
  TextEditingController moTa = TextEditingController();
  TextEditingController point = TextEditingController();

  @override
  void initState() {
    super.initState();
    data = widget.data;
    fullName.text = data.fullName ?? "";
    chucVu.text = data.chucVu ?? "";
    donVi.text = data.donVi ?? "";
    sdt.text = data.sdt ?? "";
    bienSo.text = data.bienSo ?? "";
    moTa.text = data.moTa ?? "";
    point.text = data.point ?? "";
    diaChi.text = data.diaChi ?? "";

    ngayHetHan = DateTime.parse(data.duration!);
    selectType = Status(
        id: data.type,
        name: data.type == 0
            ? "Vé tháng"
            : data.type == 1
                ? "Vé quý"
                : data.type == 2
                    ? "Vé năm"
                    : data.type == 3
                        ? "Vé CBGV, CNV"
                        : "--Chọn--");
    selectTypeXe = Status(
        id: data.xe,
        name: data.xe == 0
            ? "Xe đạp"
            : data.xe == 1
                ? "Xe máy"
                : data.xe == 2
                    ? "Ô tô"
                    : data.xe == 3
                        ? "Khác"
                        : "--Chọn--");
    selectCk = Status(
        id: data.loaiHinhTt,
        name: data.loaiHinhTt == 0
            ? "Tiền mặt"
            : data.loaiHinhTt == 1
                ? "Chuyển khoản"
                : "--Chọn--");
    selectTt = Status(
        id: data.statusTt,
        name: data.statusTt == 0
            ? "Chưa thanh toán"
            : data.statusTt == 1
                ? "Đã thanh toán"
                : "--Chọn--");
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
                {'url': "/trang-chu", 'title': 'Quản lý vé'},
              ],
              content: 'Cập nhật',
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: white,
                borderRadius: borderRadiusContainer,
                boxShadow: [boxShadowContainer],
                border: borderAllContainerBox,
              ),
              padding: paddingBoxContainer,
              child: (statusData)
                  ? ListView(
                      children: [
                        Wrap(
                          children: [
                            DropdowSearchComon(
                              heightStatus: 245,
                              listStatusSelect: const [
                                {"id": 0, "name": "Vé tháng"},
                                {"id": 1, "name": "Vé quý"},
                                {"id": 2, "name": "Vé năm"},
                                {"id": 3, "name": "Vé CBGV, CNV"},
                              ],
                              selectedItemStatus: selectType,
                              removeSelection: "removeSelection",
                              selectStatus: 2,
                              onChangedCallback: (value) {
                                setState(() {
                                  selectType = value;
                                });
                              },
                              indexTypeDropdow: 5,
                              labelDropdow: Row(
                                children: [
                                  Text(
                                    "Loại vé ",
                                    style: textDropdownTitle,
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              widthDropdow: 300,
                              marginDropdow:
                                  EdgeInsets.only(right: 20, bottom: 20),
                            ),
                            Container(
                              width: 300,
                              margin:
                                  const EdgeInsets.only(right: 20, bottom: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Ngày hết hạn ',
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
                                    selectedDate: ngayHetHan,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1 / 5,
                                            color: Colors.black45),
                                        borderRadius: BorderRadius.circular(5)),
                                    callBack: (value) {
                                      ngayHetHan = value;
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                                thickness: 1,
                                color: Color.fromARGB(255, 201, 201, 201)),
                            SizedBox(height: 10),
                            (selectType.id == 3)
                                ? Wrap(
                                    children: [
                                      Container(
                                        width: 300,
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Tên',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                height: 40,
                                                controller: fullName,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Chức vụ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                height: 40,
                                                controller: chucVu,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Đơn vị',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                height: 40,
                                                controller: donVi,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Số điện thoại',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                height: 40,
                                                controller: sdt,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Địa chỉ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                height: 40,
                                                controller: diaChi,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Wrap(
                                    children: [
                                      Container(
                                        width: 300,
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Tên',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                height: 40,
                                                controller: fullName,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Số điện thoại',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                height: 40,
                                                controller: sdt,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 300,
                                        margin: EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Địa chỉ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                height: 40,
                                                controller: diaChi,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            Divider(
                                thickness: 1,
                                color: Color.fromARGB(255, 201, 201, 201)),
                            SizedBox(height: 10),
                            Wrap(
                              children: [
                                DropdowSearchComon(
                                  heightStatus: 245,
                                  listStatusSelect: const [
                                    {"id": 0, "name": "Xe đạp"},
                                    {"id": 1, "name": "Xe máy"},
                                    {"id": 2, "name": "Ô tô"},
                                    {"id": 3, "name": "Khác"},
                                  ],
                                  selectedItemStatus: selectTypeXe,
                                  removeSelection: "removeSelection",
                                  selectStatus: 2,
                                  onChangedCallback: (value) {
                                    setState(() {
                                      selectTypeXe = value;
                                    });
                                  },
                                  indexTypeDropdow: 5,
                                  labelDropdow: Row(
                                    children: [
                                      Text(
                                        "Loại xe ",
                                        style: textDropdownTitle,
                                      ),
                                      Text(
                                        "*",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                  widthDropdow: 300,
                                  marginDropdow:
                                      EdgeInsets.only(right: 20, bottom: 25),
                                ),
                                Container(
                                  width: 300,
                                  margin:
                                      EdgeInsets.only(right: 20, bottom: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Biển số',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
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
                                        child: TextBoxCustom(
                                          height: 40,
                                          controller: bienSo,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 300,
                              margin: EdgeInsets.only(right: 20, bottom: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đặc điểm xe',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 300,
                                    child: TextBoxCustom(
                                      // height: 40,
                                      maxLines: 30,
                                      minLines: 4,
                                      controller: moTa,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                                thickness: 1,
                                color: Color.fromARGB(255, 201, 201, 201)),
                            SizedBox(height: 10),
                            if (selectType.id != 3)
                              Wrap(
                                children: [
                                  Container(
                                    width: 300,
                                    margin:
                                        EdgeInsets.only(right: 20, bottom: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Tiền vé (VNĐ) ',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 300,
                                          child: TextBoxCustom(
                                            height: 40,
                                            controller: point,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  DropdowSearchComon(
                                    heightStatus: 145,
                                    listStatusSelect: const [
                                      {"id": 0, "name": "Tiền mặt"},
                                      {"id": 1, "name": "Chuyển khoản"},
                                    ],
                                    selectedItemStatus: selectCk,
                                    removeSelection: "removeSelection",
                                    selectStatus: 2,
                                    onChangedCallback: (value) {
                                      setState(() {
                                        selectCk = value;
                                      });
                                    },
                                    indexTypeDropdow: 5,
                                    labelDropdow: Row(
                                      children: [
                                        Text(
                                          "Hình thức thanh toán",
                                          style: textDropdownTitle,
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    widthDropdow: 300,
                                    marginDropdow:
                                        EdgeInsets.only(right: 20, bottom: 25),
                                  ),
                                  DropdowSearchComon(
                                    heightStatus: 145,
                                    listStatusSelect: const [
                                      {"id": 0, "name": "Chưa thanh toán"},
                                      {"id": 1, "name": "Đã thanh toán"},
                                    ],
                                    selectedItemStatus: selectTt,
                                    removeSelection: "removeSelection",
                                    selectStatus: 2,
                                    onChangedCallback: (value) {
                                      setState(() {
                                        selectTt = value;
                                      });
                                    },
                                    indexTypeDropdow: 5,
                                    labelDropdow: Row(
                                      children: [
                                        Text(
                                          "Trạng thái thanh toán",
                                          style: textDropdownTitle,
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    widthDropdow: 300,
                                    marginDropdow:
                                        EdgeInsets.only(right: 20, bottom: 25),
                                  ),
                                ],
                              ),
                           
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    processing();

                                    if (ngayHetHan == null ||
                                        selectTypeXe.id == null ||
                                        selectType.id == null ||
                                        fullName.text == "") {
                                      showToast(
                                        context: context,
                                        msg: "Cần nhập đủ thông tin",
                                        color: Colors.orange,
                                        icon: const Icon(Icons.warning),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      data.type = selectType.id;
                                      data.fullName = fullName.text;
                                      data.chucVu = chucVu.text;
                                      data.donVi = donVi.text;
                                      data.sdt = sdt.text;
                                      data.diaChi = diaChi.text;
                                      data.xe = selectTypeXe.id;
                                      data.bienSo = bienSo.text;
                                      data.moTa = moTa.text;
                                      data.point = point.text;
                                      data.statusTt = selectTt.id;
                                      data.loaiHinhTt = selectCk.id;
                                      data.duration =
                                          "${DateFormat('yyyy-MM-dd').format(ngayHetHan!)}T12:00:00";
                                      await httpPut("/api/ve-xe/put/${data.id}",
                                          data.toJson(), context);
                                      showToast(
                                        context: context,
                                        msg: "Cập nhật thành công",
                                        color: Color.fromARGB(136, 72, 238, 67),
                                        icon: const Icon(Icons.done),
                                      );
                                      widget.callback!(data);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    'Tạo vé',
                                    style: textBtnWhite,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 9, 209, 26),
                                    elevation: 3,
                                    minimumSize: Size(100, 40),
                                  ),
                                ),
                                SizedBox(width: 25),
                                ElevatedButton(
                                  onPressed: () {
                                    widget.callback!(widget.data);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Hủy', style: textBtnWhite),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 211, 55, 44),
                                    elevation: 3,
                                    minimumSize: Size(100, 40),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  : CommonApp().loadingCallAPi(),
            ),
            Footer()
          ],
        ),
      ),
    ));
  }
}
