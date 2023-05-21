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

class DangKyTheScreen extends StatefulWidget {
  const DangKyTheScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<DangKyTheScreen> {
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
  Status selectType = Status(id: null, name: "--Chọn loại vé--");
  Status selectTypeXe = Status(id: null, name: "--Chọn loại xe--");
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
    Timer(Duration(seconds: 1), () {});
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
              content: 'Đăng ký vé',
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
                            if (selectType.id != null)
                              Container(
                                width: 300,
                                margin: const EdgeInsets.only(
                                    right: 20, bottom: 20),
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
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      callBack: (value) {
                                        ngayHetHan = value;
                                      },
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                        if (selectType.id != null)
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
                                              style:
                                                  TextStyle(color: Colors.red),
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
                                        data.idNv = user.user.id;
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
                                        data.status = 1;
                                        String codeT = "";
                                        if (data.type == 0) {
                                          codeT = "VT";
                                        } else if (data.type == 1) {
                                          codeT = "VQ";
                                        } else if (data.type == 2) {
                                          codeT = "VN";
                                        } else if (data.type == 3) {
                                          codeT = "VF";
                                        }
                                        String code2 = "";
                                        var responseNV = await httpGet(
                                            "/api/ve-xe/get/page?filter=type:${data.type}&sort=id,desc",
                                            context);
                                        var bodyNv =
                                            jsonDecode(responseNV['body']);
                                        var content = [];
                                        content = bodyNv['result']['content'];
                                        if (content.isNotEmpty) {
                                          int id = bodyNv['result']
                                                  ['totalElements'] +
                                              1;
                                          if (id < 10) {
                                            code2 = "00000$id";
                                          } else if (id < 100) {
                                            code2 = "0000$id";
                                          } else if (id < 1000) {
                                            code2 = "000$id";
                                          } else if (id < 10000) {
                                            code2 = "00$id";
                                          } else if (id < 100000) {
                                            code2 = "0$id";
                                          } else {
                                            code2 = "$id";
                                          }
                                        } else {
                                          code2 = "000001";
                                        }
                                        data.code = codeT + code2;
                                        await httpPost("/api/ve-xe/post",
                                            data.toJson(), context);
                                        showToast(
                                          context: context,
                                          msg:
                                              "Tạo vé thành công - mọi yêu cầu chỉnh sửa liên hệ quản lý",
                                          color:
                                              Color.fromARGB(136, 72, 238, 67),
                                          icon: const Icon(Icons.done),
                                        );
                                        setState(() {
                                          selectType = Status(
                                              id: null,
                                              name: "--Chọn loại vé--");
                                          selectTypeXe = Status(
                                              id: null,
                                              name: "--Chọn loại xe--");
                                          selectCk = Status(
                                              id: null, name: "--Chọn--");
                                          selectTt = Status(
                                              id: null, name: "--Chọn--");
                                          ngayHetHan = null;
                                          fullName.text = "";
                                          chucVu.text = "";
                                          donVi.text = "";
                                          sdt.text = "";
                                          diaChi.text = "";
                                          bienSo.text = "";
                                          moTa.text = "";
                                          point.text = "";
                                        });
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
