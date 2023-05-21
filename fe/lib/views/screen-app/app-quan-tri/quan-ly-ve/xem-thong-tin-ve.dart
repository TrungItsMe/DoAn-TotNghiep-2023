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

class XemVeScreen extends StatefulWidget {
  VeXe data;
  XemVeScreen({Key? key, required this.data}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<XemVeScreen> {
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
              content: 'Thông tin chi tiết',
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
                                        "Loại vé ",
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 300,
                                    child: TextBoxCustom(
                                      enabled: false,
                                      height: 40,
                                      controller: TextEditingController(text: selectType.name),
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
                                        "Mã vé ",
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 300,
                                    child: TextBoxCustom(
                                      enabled: false,
                                      height: 40,
                                      controller: TextEditingController(text: data.code),
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
                                        "Trạng thái vé ",
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
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
                                        text: (data.status == 0)
                                            ? "Khoá"
                                            : (data.status == 1)
                                                ? (data.status == 3)
                                                    ? "Kích hoạt"
                                                    : (data.statusTt == 1)
                                                        ? "Kích hoạt"
                                                        : "Kích hoạt - Chưa thanh toán"
                                                : "",
                                      ),
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
                                        'Ngày hết hạn ',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 300,
                                    child: TextBoxCustom(
                                      enabled: false,
                                      height: 40,
                                      controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(ngayHetHan!)),
                                    ),
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
                            Divider(thickness: 1, color: Color.fromARGB(255, 201, 201, 201)),
                            SizedBox(height: 10),
                            (selectType.id == 3)
                                ? Wrap(
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
                                                  'Tên',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                enabled: false,
                                                height: 40,
                                                controller: fullName,
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
                                                  'Chức vụ',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                enabled: false,
                                                height: 40,
                                                controller: chucVu,
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
                                                  'Đơn vị',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                enabled: false,
                                                height: 40,
                                                controller: donVi,
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
                                                  'Số điện thoại',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                enabled: false,
                                                height: 40,
                                                controller: sdt,
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
                                                  'Địa chỉ',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                enabled: false,
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
                                        margin: EdgeInsets.only(right: 20, bottom: 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Tên',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                enabled: false,
                                                height: 40,
                                                controller: fullName,
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
                                                  'Số điện thoại',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                enabled: false,
                                                height: 40,
                                                controller: sdt,
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
                                                  'Địa chỉ',
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 300,
                                              child: TextBoxCustom(
                                                enabled: false,
                                                height: 40,
                                                controller: diaChi,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            Divider(thickness: 1, color: Color.fromARGB(255, 201, 201, 201)),
                            SizedBox(height: 10),
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
                                            "Loại xe ",
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 300,
                                        child: TextBoxCustom(
                                          enabled: false,
                                          height: 40,
                                          controller: TextEditingController(text: selectTypeXe.name),
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
                                            'Biển số',
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 300,
                                        child: TextBoxCustom(
                                          enabled: false,
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đặc điểm xe',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 300,
                                    child: TextBoxCustom(
                                      enabled: false,
                                      maxLines: 30,
                                      minLines: 4,
                                      controller: moTa,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(thickness: 1, color: Color.fromARGB(255, 201, 201, 201)),
                            SizedBox(height: 10),
                            if (selectType.id != 3)
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
                                              'Tiền vé (VNĐ) ',
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 300,
                                          child: TextBoxCustom(
                                            enabled: false,
                                            height: 40,
                                            controller: point,
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
                                              "Hình thức thanh toán",
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 300,
                                          child: TextBoxCustom(
                                            enabled: false,
                                            height: 40,
                                            controller: TextEditingController(text: selectCk.name),
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
                                              "Trạng thái thanh toán",
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 300,
                                          child: TextBoxCustom(
                                            enabled: false,
                                            height: 40,
                                            controller: TextEditingController(text: selectTt.name),
                                          ),
                                        )
                                      ],
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
