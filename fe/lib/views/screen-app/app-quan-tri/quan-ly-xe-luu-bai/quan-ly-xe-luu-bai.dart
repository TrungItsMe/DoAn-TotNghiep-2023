// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, unused_local_variable
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/ve-xe.dart';
import 'package:fe/models/xe-luu-bai.dart';
import 'package:fe/views/screen-app/app-quan-tri/quan-ly-xe-luu-bai/xac-nhan-xuat-bai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/bai-xe.dart';
import '../../../../models/status.dart';
import '../../../../models/user.dart';
import '../../../common/date-picker.dart';
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

import 'sua-xe-luu-bai.dart';
import 'them-moi-xe-luu-bai.dart';
import 'xem-xe-luu-bai.dart';

class QuanXeLuuBaiScreen extends StatefulWidget {
  const QuanXeLuuBaiScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<QuanXeLuuBaiScreen> {
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
  TextEditingController code = TextEditingController();
  List<XeLuuBai> listData = [];
  List<XeLuuBai> listXacNhan = [];
  List<bool> selectedDataRow = [];

  Status selectStatus = Status(id: null, name: "--Chọn--");
  Status selectType = Status(id: null, name: "--Chọn--");
  DateTime? ngay;
  DateTime? ngayLay;

  List<String> listLoaiXe = [
    "Xe đạp",
    "Xe máy",
    "Ô tô",
    "Khác",
  ];

  String search = "";
  Future<List<XeLuuBai>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet(
            "/api/xe-luu-bai/get/page?filter=$search&sort=status&sort=createdDate,desc&sort=modifiedDate,desc&page=${curentPage - 1}&size=$selectedValueRpp",
            context);
      } else {
        response = await httpGet(
            "/api/xe-luu-bai/get/page?sort=status&sort=createdDate,desc&sort=modifiedDate,desc&page=${curentPage - 1}&size=$selectedValueRpp",
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
              return XeLuuBai.fromJson(e);
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
      code.text = '';
      selectStatus = Status(id: null, name: "--Chọn--");
      selectedBx = BaiXe(id: null, code: "--Chọn-", name: "");
      selectType = Status(id: null, name: "--Chọn--");
      search = "";
    });
    callApiData();
  }

  User selectedUser = User(id: null, userCode: "--Chọn-", fullName: "");
  Future<List<User>> callUser() async {
    List<User> listData = [];
    try {
      var response = await httpGet(
          "/api/nguoi-dung/get/page?filter=status:1 and role:1&size=10000",
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

  void btnSearch() async {
    setState(() {
      search = "";
      String findType = "";
      String findCode = "";
      String findStatus = "";
      String findBX = "";
      String findStatusTT = "";
      String findNT = "";
      String findNgay = "";
      if (selectType.id != null) {
        findType = "and xe:${selectType.id} ";
      } else {
        findType = "";
      }
      if (code.text != "") {
        findCode = "and bienSo~'*${code.text}*' ";
      } else {
        findCode = "";
      }
      if (selectStatus.id != null) {
        findStatus = "and status:${selectStatus.id} ";
      } else {
        findStatus = "";
      }
      if (selectedBx.id != null) {
        findBX = "and idBx:${selectedBx.id} ";
      } else {
        findBX = "";
      }
      if (ngay != null) {
        findNgay =
            "and createdDate>:'${DateFormat('dd-MM-yyyy').format(ngay!)} 00:00:00' and createdDate<:'${DateFormat('dd-MM-yyyy').format(ngay!)} 23:59:59' ";
      } else {
        findNgay = "";
      }
      if (ngayLay != null) {
        findStatusTT =
            "and modifiedDate>:'${DateFormat('dd-MM-yyyy').format(ngayLay!)} 00:00:00' and modifiedDate<:'${DateFormat('dd-MM-yyyy').format(ngayLay!)} 23:59:59' ";
      } else {
        findStatusTT = "";
      }
      search = findType +
          findStatus +
          findCode +
          findNgay +
          findNT +
          findStatusTT +
          findBX;
      print(search);
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
    callApiData();
  }

  @override
  void dispose() {
    code.dispose();
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
              content: 'Quản lý xe lưu bãi',
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
                                loaiVe(),
                                maVe(),
                                rederBx(),
                                rederNgay(),
                                rederNgayLay(),
                                renderStatus()
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
                                                ThemMoiXeLuuBai(
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
                                        color: listXacNhan.isNotEmpty
                                            ? mainColor
                                            : Color.fromARGB(
                                                255, 174, 174, 174),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: TextButton(
                                      onPressed: listXacNhan.isNotEmpty
                                          ? () async {
                                              processing();
                                              bool statusChange = false;
                                              await showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          XacNhanXuatBai(
                                                            data: listXacNhan,
                                                            callBack: (value) {
                                                              statusChange =
                                                                  value;
                                                            },
                                                          ));
                                              if (statusChange) {
                                                showToast(
                                                  context: context,
                                                  msg: "Xác nhận thành công",
                                                  color: Color.fromARGB(
                                                      136, 72, 238, 67),
                                                  icon: const Icon(Icons.done),
                                                );
                                                btnReset();
                                              }
                                              Navigator.pop(context);
                                            }
                                          : null,
                                      child: Text(
                                        "Xác nhận xuất bãi",
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
                          'Loại xe',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Biển số',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Ngày lưu bãi',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Địa điểm',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Ngày xuất bãi',
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
                        onSelectChanged: (bool? selected) {
                          setState(
                            () {
                              if (listData[i].status == 0) {
                                selectedDataRow[i] = selected!;
                                if (selectedDataRow[i] == true) {
                                  listXacNhan.add(listData[i]);
                                } else {
                                  listXacNhan.remove(listData[i]);
                                }
                              }
                            },
                          );
                        },
                        cells: <DataCell>[
                          DataCell(Text(
                            '${tableIndex++}',
                            style: textDataRow,
                          )),
                          DataCell(SelectableText(
                              listLoaiXe[listData[i].xe ?? 0],
                              style: textDataRow)),
                          DataCell(SelectableText(listData[i].bienSo ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(listData[i].createdDate!)
                                      .toLocal()),
                              style: textDataRow)),
                          DataCell(SelectableText(
                              listData[i].baiXe != null
                                  ? "${listData[i].baiXe!.code ?? ""} - ${listData[i].baiXe!.name ?? ""}"
                                  : "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              (listData[i].status == 1)
                                  ? DateFormat('HH:mm dd-MM-yyyy').format(
                                      DateTime.parse(listData[i].modifiedDate!)
                                          .toLocal())
                                  : "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              listData[i].status == 0
                                  ? "Đang lưu bãi"
                                  : listData[i].status == 1
                                      ? "Đã xuất bãi"
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
                                                        XemXeLuuBai(
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
                                                        SuaXeLuuBai(
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
                                  message: "Xóa",
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
                                                          content: Container(
                                                            height: 120,
                                                            width: 460,
                                                            padding:
                                                                const EdgeInsets
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
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text('Xác nhận xoá', style: textTitleAlertDialog),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            onPressed: () =>
                                                                                {
                                                                              Navigator.pop(context)
                                                                            },
                                                                            icon:
                                                                                const Icon(Icons.close),
                                                                          ),
                                                                        ]),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                    const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            var response =
                                                                                await httpDelete("/api/xe-luu-bai/del/${listData[i].id}", context);
                                                                            showToast(
                                                                              context: context,
                                                                              msg: "Xoá thành công",
                                                                              color: const Color.fromARGB(136, 72, 238, 67),
                                                                              icon: const Icon(Icons.done),
                                                                            );
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                100,
                                                                                181,
                                                                                248),
                                                                            minimumSize:
                                                                                const Size(100, 40),
                                                                          ),
                                                                          child:
                                                                              const Text('Xác nhận'),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                15),
                                                                        ElevatedButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                132,
                                                                                124),
                                                                            elevation:
                                                                                3,
                                                                            minimumSize:
                                                                                const Size(100, 40),
                                                                          ),
                                                                          child: Text(
                                                                              'Hủy',
                                                                              style: textBtnWhite),
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
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
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

  loaiVe() {
    return DropdowSearchComon(
      heightStatus: 245,
      listStatusSelect: const [
        {"id": 0, "name": "Xe đạp"},
        {"id": 1, "name": "Xe máy"},
        {"id": 2, "name": "Ô tô"},
        {"id": 3, "name": "Khác"},
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
            "Loại xe ",
            style: textDropdownTitle,
          ),
        ],
      ),
      widthDropdow: 300,
      marginDropdow: EdgeInsets.only(right: 20, bottom: 20),
    );
  }

  renderStatus() {
    return DropdowSearchComon(
      heightStatus: 150,
      listStatusSelect: const [
        {"id": 0, "name": "Đang lưu bãi"},
        {"id": 1, "name": "Đã xuất bãi"},
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

  maVe() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biển số',
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

  rederNgay() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ngày lưu bãi',
            style: textDropdownTitle,
          ),
          SizedBox(height: 10),
          DatePickerBox(
            selectedDate: ngay,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(width: 1 / 5, color: Colors.black45),
                borderRadius: BorderRadius.circular(5)),
            callBack: (value) {
              ngay = value;
            },
          )
        ],
      ),
    );
  }

  rederNgayLay() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ngày chủ xe lấy',
            style: textDropdownTitle,
          ),
          SizedBox(height: 10),
          DatePickerBox(
            selectedDate: ngayLay,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(width: 1 / 5, color: Colors.black45),
                borderRadius: BorderRadius.circular(5)),
            callBack: (value) {
              ngayLay = value;
            },
          )
        ],
      ),
    );
  }

  rederBx() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 20),
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
}
