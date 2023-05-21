// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/status.dart';
import '../../../../models/user.dart';
import '../../../common/dropdow_search_common.dart';
import '../../../common/footer.dart';
import '../../../common/header.dart';
import '../../../common/input-text.dart';
import '../../../common/loadApi.dart';
import '../../../common/pageding.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';
import '../../../common/toast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;
import 'sua-nv.dart';
import 'them-moi-nv.dart';
import 'xem-nv.dart';

class QuanNhanVienScreen extends StatefulWidget {
  const QuanNhanVienScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<QuanNhanVienScreen> {
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

  int curentPage = 1;
  int page = 0;
  int totalElements = 0;
  int selectedValueRpp = 5;
  bool onload = false;

  int? statusId;

  TextEditingController name = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sdt = TextEditingController();
  List<User> listData = [];
  List<bool> selectedDataRow = [];
  Status selectStatus = Status(id: null, name: "--Chọn--");
  Status selectGioiTinh = Status(id: null, name: "--Chọn--");
  String search = "";
  Future<List<User>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet(
            "/api/nguoi-dung/get/page?filter=role:1 and $search&sort=id,desc&page=${curentPage - 1}&size=$selectedValueRpp",
            context);
      } else {
        response = await httpGet(
            "/api/nguoi-dung/get/page?filter=role:1&sort=id,desc&page=${curentPage - 1}&size=$selectedValueRpp",
            context);
      }
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            totalElements = body["result"]["totalElements"];
            content = body["result"]["content"];
            page = body['result']['totalPages'];
            listData = content.map((e) {
              return User.fromJson(e);
            }).toList();
            selectedDataRow =
                List<bool>.generate(totalElements, (int index) => false);
          });
        }
      }
    } catch (e) {
      return listData;
    }

    return listData;
  }

  void btnReset() {
    setState(() {
      name.text = '';
      code.text = '';
      email.text = '';
      sdt.text = '';
      selectStatus = Status(id: null, name: "--Chọn--");
      selectGioiTinh = Status(id: null, name: "--Chọn--");
      search = "";
    });
    callApiData();
  }

  void btnSearch() async {
    setState(() {
      search = "";
      String findName = "";
      String findCode = "";
      String findLevel = "";
      String findStatus = "";
      String findEmail = "";
      String findSdt = "";
      String findGT = "";

      if (name.text != "") {
        findName = "and fullName~'*${name.text}*' ";
      } else {
        findName = "";
      }
      if (code.text != "") {
        findCode = "and userCode~'*${code.text}*' ";
      } else {
        findCode = "";
      }
      if (email.text != "") {
        findEmail = "and email~'*${email.text}*' ";
      } else {
        findEmail = "";
      }
      if (sdt.text != "") {
        findSdt = "and sdt~'*${sdt.text}*' ";
      } else {
        findSdt = "";
      }
      if (selectGioiTinh.id != null) {
        findGT = "and gioiTinh:${selectGioiTinh.id} ";
      } else {
        findGT = "";
      }
      if (selectStatus.id != null) {
        findStatus = "and status:${selectStatus.id} ";
      } else {
        findStatus = "";
      }
      search = findName +
          findLevel +
          findStatus +
          findCode +
          findEmail +
          findSdt +
          findGT;

      if (search != "") if (search.substring(0, 3) == "and")
        search = search.substring(4);
    });
    callApiData();
  }

  onChangeRowTable(value) {
    selectedValueRpp = value;
    curentPage = 1;
    callApiData();
  }

  Future<void> createExcel(List<User> listTNV) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    int stt = listTNV.length;
    sheet.getRangeByIndex(1, 1, 1 + stt, 9).cellStyle.fontSize = 12;
    sheet.getRangeByIndex(1, 1, 2 + stt, 9).cellStyle.fontName =
        "Times New Roman";
    sheet.getRangeByIndex(1, 1, 2 + stt, 9).cellStyle.hAlign =
        HAlignType.center;
    sheet.getRangeByIndex(1, 1, 2 + stt, 9).cellStyle.vAlign =
        VAlignType.center;
    sheet.getRangeByIndex(2, 1, 2 + stt, 9).cellStyle.borders.all.lineStyle =
        LineStyle.thin;
    sheet.getRangeByIndex(2, 1, 2, 9).cellStyle.backColor = '#009c87';
    sheet.getRangeByIndex(2, 1, 2, 9).cellStyle.fontSize = 13;
    sheet.getRangeByIndex(2, 1, 2, 9).cellStyle.bold = true;
    sheet.getRangeByIndex(2, 1).rowHeight = 40;
    sheet.getRangeByIndex(3, 1, 2 + stt, 1).rowHeight = 25;
    sheet.getRangeByIndex(1, 1, 1, 9).merge();
    sheet.getRangeByIndex(1, 1).rowHeight = 45;
    sheet.getRangeByIndex(1, 1).setText("Danh sách nhân viên");
    sheet.getRangeByIndex(1, 1).cellStyle.fontSize = 25;
    sheet.getRangeByIndex(1, 1).cellStyle.bold = true;
    sheet.getRangeByName('A1').columnWidth = 6.4;
    sheet.getRangeByName('B1').columnWidth = 25;
    sheet.getRangeByName('C1').columnWidth = 30;
    sheet.getRangeByName('D1').columnWidth = 25;
    sheet.getRangeByName('E1').columnWidth = 25;
    sheet.getRangeByName('F1').columnWidth = 10;
    sheet.getRangeByName('G1').columnWidth = 20;
    sheet.getRangeByName('H1').columnWidth = 20;
    sheet.getRangeByName('I1').columnWidth = 80;
    sheet.getRangeByName('A2').setText("STT");
    sheet.getRangeByName('B2').setText("Mã sinh viên");
    sheet.getRangeByName('C2').setText("Họ và tên");
    sheet.getRangeByName('D2').setText("Ngày vào");
    sheet.getRangeByName('E2').setText("Ngày sinh");
    sheet.getRangeByName('F2').setText("Giới tính");
    sheet.getRangeByName('G2').setText("Email");
    sheet.getRangeByName('H2').setText("Số điện thoại");
    sheet.getRangeByName('I2').setText("Địa chỉ");
    sheet.autoFilters.filterRange = sheet.getRangeByName('A2:I${1 + stt}');
    for (var i = 0; i < listTNV.length; i++) {
      sheet.getRangeByName('A${i + 3}').setNumber(i + 1);
      sheet.getRangeByName('B${i + 3}').setText(listTNV[i].userCode);
      sheet.getRangeByName('C${i + 3}').setText(listTNV[i].fullName);
      sheet.getRangeByName('D${i + 3}').setText(
          DateFormat('dd-MM-yyyy').format(DateTime.parse(listTNV[i].ngayVao!)));
      sheet.getRangeByName('E${i + 3}').setText(DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(listTNV[i].ngaySinh!)));
      sheet
          .getRangeByName('F${i + 3}')
          .setText((listTNV[i].gioiTinh == true) ? "Nữ" : "Nam");
      sheet.getRangeByName('G${i + 3}').setText(listTNV[i].email);
      sheet.getRangeByName('H${i + 3}').setText(listTNV[i].sdt);
      sheet.getRangeByName('I${i + 3}').setText(listTNV[i].diaChi);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Danh_sach_nhan_vien.xlsx')
        ..click();
    }
  }

  @override
  void initState() {
    super.initState();
    callApiData();
  }

  @override
  void dispose() {
    name.dispose();
    code.dispose();
    email.dispose();
    sdt.dispose();
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
              ],
              content: 'Quản lý nhân viên',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                rederCode(),
                                rederName(),
                                rederEmail(),
                                rederSDT(),
                                renderGioiTinh(context),
                                renderStatus(context)
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 25),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: TextButton(
                                      onPressed: () {
                                        btnSearch();
                                      },
                                      child: Text(
                                        "Tìm kiếm",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                    )),
                                Container(
                                    margin: const EdgeInsets.only(right: 25),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: TextButton(
                                      onPressed: () {
                                        btnReset();
                                      },
                                      child: Text(
                                        "Làm mới ",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                    )),
                                Container(
                                    margin: const EdgeInsets.only(right: 25),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: TextButton(
                                      onPressed: () async {
                                        bool statusChange = false;
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ThemMoiNV(
                                                  callBack: (value) {
                                                    statusChange = value;
                                                  },
                                                ));
                                        if (statusChange) {
                                          btnReset();
                                        }
                                      },
                                      child: Text(
                                        "Tạo mới",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                    )),
                                Container(
                                    margin: const EdgeInsets.only(right: 25),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color:mainColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: TextButton(
                                      onPressed: () async {
                                        List<User> listExport = [];
                                        try {
                                          var response;
                                          if (search != "") {
                                            response = await httpGet(
                                                "/api/nguoi-dung/get/page?filter=role:1 and $search",
                                                context);
                                          } else {
                                            response = await httpGet(
                                                "/api/nguoi-dung/get/page?filter=role:1",
                                                context);
                                          }
                                          if (response.containsKey("body")) {
                                            var body =
                                                jsonDecode(response["body"]);
                                            var content = [];
                                            if (body["success"] == true) {
                                              setState(() {
                                                totalElements = body["result"]
                                                    ["totalElements"];
                                                content =
                                                    body["result"]["content"];
                                                page = body['result']
                                                    ['totalPages'];
                                                listExport = content.map((e) {
                                                  return User.fromJson(e);
                                                }).toList();
                                              });
                                            }
                                          }
                                          setState(() {
                                            onload = true;
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
                                        createExcel(listExport);
                                      },
                                      child: Text(
                                        "Xuất file",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            tableWidget(),
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

  Widget tableWidget() {
    var tableIndex = (curentPage - 1) * selectedValueRpp + 1;
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(children: [
        SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: (listData != [])
              ? DataTable(
                  border: TableBorder.all(
                    color: Colors.black,
                    //style: BorderStyle.solid,
                    width: 0.1,
                  ),
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'STT',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Mã nv',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Tên nv',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Ngày vào',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Ngày sinh',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Giới tính',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Email',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Số điện thoại',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Trạng thái',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Tính năng',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    for (int i = 0; i < listData.length; i++)
                      DataRow(
                        selected: selectedDataRow[i],
                        cells: <DataCell>[
                          DataCell(Text(
                            '${tableIndex++}',
                            style: textDataRow,
                          )),
                          DataCell(SelectableText(listData[i].userCode ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(listData[i].fullName ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              listData[i].ngayVao != null
                                  ? DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(listData[i].ngayVao!)
                                          .toLocal())
                                  : "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              listData[i].ngaySinh != null
                                  ? DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(listData[i].ngaySinh!)
                                          .toLocal())
                                  : "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              listData[i].gioiTinh == 0
                                  ? "Nam"
                                  : listData[i].gioiTinh == 1
                                      ? "Nữ"
                                      : "",
                              style: textDataRow)),
                          DataCell(SelectableText(listData[i].email ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(listData[i].sdt ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              (listData[i].status == 0)
                                  ? "Khoá"
                                  : (listData[i].status == 1)
                                      ? "Kích hoạt"
                                      : "",
                              style: textDataRow)),
                          DataCell(
                            Row(
                              children: [
                                Tooltip(
                                  message: "Xem",
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        XemNVScreen(
                                                          data: listData[i],
                                                        ));
                                          },
                                          child: const Icon(
                                            Icons.visibility,
                                            color: Colors.blue,
                                            size: 20,
                                          ))),
                                ),
                                Tooltip(
                                  message: "Sửa",
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        SuaNV(
                                                          data: listData[i],
                                                          callBack: (value) {
                                                            setState(() {
                                                              listData[i] =
                                                                  value;
                                                            });
                                                          },
                                                        ));
                                          },
                                          child: const Icon(
                                            Icons.edit_calendar,
                                            color: Color(0xffD97904),
                                            size: 20,
                                          ))),
                                ),
                                Tooltip(
                                  message: (listData[i].status == 1)
                                      ? "Khoá"
                                      : "Kích hoạt",
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () async {
                                            await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                          content: (listData[i]
                                                                      .status ==
                                                                  1)
                                                              ? Container(
                                                                  height: 300,
                                                                  width: 460,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text('Xác nhận khoá', style: textTitleAlertDialog),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                IconButton(
                                                                                  onPressed: () => {
                                                                                    Navigator.pop(context)
                                                                                  },
                                                                                  icon: const Icon(Icons.close),
                                                                                ),
                                                                              ]),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          const Divider(
                                                                              thickness: 1,
                                                                              color: Colors.black),
                                                                          const SizedBox(
                                                                              height: 20),
                                                                        ],
                                                                      ),
                                                                      Flexible(
                                                                        child: Text(
                                                                            "Khoá: ${listData[i].fullName}",
                                                                            style:
                                                                                textNormal),
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          const SizedBox(
                                                                              height: 20),
                                                                          const Divider(
                                                                              thickness: 1,
                                                                              color: Colors.black),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  listData[i].status = 0;
                                                                                  await httpPut("/api/nguoi-dung/put/${listData[i].id}", listData[i].toJson(), context);
                                                                                  showToast(
                                                                                    context: context,
                                                                                    msg: "Khoá thành công",
                                                                                    color: const Color.fromARGB(136, 72, 238, 67),
                                                                                    icon: const Icon(Icons.done),
                                                                                  );
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text('Xác nhận'),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  foregroundColor: Colors.white,
                                                                                  backgroundColor: const Color.fromARGB(255, 100, 181, 248),
                                                                                  minimumSize: const Size(100, 40),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 15),
                                                                              ElevatedButton(
                                                                                onPressed: () => Navigator.pop(context),
                                                                                child: Text('Hủy', style: textBtnWhite),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  foregroundColor: Colors.white,
                                                                                  backgroundColor: const Color.fromARGB(255, 211, 55, 44),
                                                                                  elevation: 3,
                                                                                  minimumSize: const Size(100, 40),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(
                                                                  height: 300,
                                                                  width: 460,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text('Xác nhận kích hoạt', style: textTitleAlertDialog),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                IconButton(
                                                                                  onPressed: () => {
                                                                                    Navigator.pop(context)
                                                                                  },
                                                                                  icon: const Icon(Icons.close),
                                                                                ),
                                                                              ]),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          const Divider(
                                                                              thickness: 1,
                                                                              color: Colors.black),
                                                                          const SizedBox(
                                                                              height: 20),
                                                                        ],
                                                                      ),
                                                                      Flexible(
                                                                        child: Text(
                                                                            "Kích hoạt: ${listData[i].fullName}",
                                                                            style:
                                                                                textNormal),
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          const SizedBox(
                                                                              height: 20),
                                                                          const Divider(
                                                                              thickness: 1,
                                                                              color: Colors.black),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  listData[i].status = 1;
                                                                                  await httpPut("/api/nguoi-dung/put/${listData[i].id}", listData[i].toJson(), context);
                                                                                  showToast(
                                                                                    context: context,
                                                                                    msg: "Kích hoạt thành công",
                                                                                    color: const Color.fromARGB(136, 72, 238, 67),
                                                                                    icon: const Icon(Icons.done),
                                                                                  );
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text('Xác nhận'),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  foregroundColor: Colors.white,
                                                                                  backgroundColor: const Color.fromARGB(255, 100, 181, 248),
                                                                                  minimumSize: const Size(100, 40),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 15),
                                                                              ElevatedButton(
                                                                                onPressed: () => Navigator.pop(context),
                                                                                child: Text('Hủy', style: textBtnWhite),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  foregroundColor: Colors.white,
                                                                                  backgroundColor: const Color.fromARGB(255, 211, 55, 44),
                                                                                  elevation: 3,
                                                                                  minimumSize: const Size(100, 40),
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
                                            btnReset();
                                          },
                                          child: (listData[i].status == 1)
                                              ? Icon(
                                                  Icons.lock,
                                                  color: Colors.red,
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.lock_open,
                                                  color: Colors.green,
                                                  size: 20,
                                                ))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                )
              : CommonApp().loadingCallAPi(),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Hiển thị',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                SizedBox(width: 15),
                DropdowSearchComon(
                  selectedValueRpp: selectedValueRpp,
                  onChangedCallback: onChangeRowTable,
                  indexTypeDropdow: 6,
                  widthDropdow: 100,
                  marginDropdow: EdgeInsets.only(right: 0, bottom: 25),
                ),
                Text(
                  ' /$totalElements bản ghi',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ],
            ),
            PagingTable(
              page: page,
              curentPage: curentPage,
              rowCount: totalElements,
              setCurentPage: (value) {
                curentPage = value;
                callApiData();
                // setState(() {});
              },
            ),
          ],
        )
      ]),
    );
  }

  renderStatus(context) {
    return DropdowSearchComon(
      listStatusSelect: const [
        {"id": 0, "name": "Khoá"},
        {"id": 1, "name": "Kích hoạt"},
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
          Text(
            "Trạng thái",
            style: textDropdownTitle,
          ),
        ],
      ),
      widthDropdow: 300,
      marginDropdow: EdgeInsets.only(right: 20, bottom: 25),
    );
  }

  renderGioiTinh(context) {
    return DropdowSearchComon(
      listStatusSelect: const [
        {"id": 0, "name": "Nam"},
        {"id": 1, "name": "Nữ"},
      ],
      selectedItemStatus: selectGioiTinh,
      removeSelection: "removeSelection",
      selectStatus: 2,
      onChangedCallback: (value) {
        selectGioiTinh = value;
      },
      indexTypeDropdow: 5,
      labelDropdow: Row(
        children: [
          Text(
            "Giới tính",
            style: textDropdownTitle,
          ),
        ],
      ),
      widthDropdow: 300,
      marginDropdow: EdgeInsets.only(right: 20, bottom: 25),
    );
  }

  rederName() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tên',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: name,
            ),
          )
        ],
      ),
    );
  }

  rederEmail() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: email,
            ),
          )
        ],
      ),
    );
  }

  rederSDT() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SDT',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
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
    );
  }

  rederCode() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mã nhân viên',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: code,
            ),
          )
        ],
      ),
    );
  }
}
