// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, unused_local_variable, sort_child_properties_last
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/ca-truc.dart';
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
import '../../../common/loadApi.dart';
import '../../../common/pageding.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';
import 'package:intl/intl.dart';

import '../../../common/toast.dart';
import 'sua-ca-truc.dart';
import 'them-moi-ca-truc.dart';
import 'xem-ca-truc.dart';

class QLCaTrucScreen extends StatefulWidget {
  const QLCaTrucScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<QLCaTrucScreen> {
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
  List<CaTruc> listData = [];
  List<bool> selectedDataRow = [];
  Status selectStatus = Status(id: null, name: "--Chọn--");
  DateTime? ngay;
  String search = "";
  Future<List<CaTruc>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet(
            "/api/ca-truc/get/page?filter=$search&sort=status&page=${curentPage - 1}&size=$selectedValueRpp",
            context);
      } else {
        response = await httpGet(
            "/api/ca-truc/get/page?sort=status&  page=${curentPage - 1}&size=$selectedValueRpp",
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
              return CaTruc.fromJson(e);
            }).toList();
            selectedDataRow =
                List<bool>.generate(totalElements, (int index) => false);
          });
          for (CaTruc element in listData) {
            if (element.status == 0 || element.status == 1) {
              if (now.difference(DateTime.parse(element.endTime!)).inHours -
                      0.5 >
                  0) {
                setState(() {
                  element.status = 3;
                });
                await httpPut("/api/ca-truc/put/${element.id}",
                    element.toJson(), context);
              }
            }
          }
        }
      }
    } catch (e) {
      return listData;
    }

    return listData;
  }

  DateTime now = DateTime.now();
  void btnReset() {
    setState(() {
      selectedBx = BaiXe(id: null, code: "--Chọn-", name: "");
      selectedUser = User(id: null, userCode: "--Chọn-", fullName: "");
      selectStatus = Status(id: null, name: "--Chọn--");
      search = "";
    });
    callApiData();
  }

  void clearAllSelections(id) async {
    processing();
    Navigator.pop(context);
  }

  void btnSearch() async {
    setState(() {
      search = "";
      String findNV = "";
      String findBX = "";
      String findNgay = "";
      String findStatus = "";
      if (selectedUser.id != null) {
        findNV = "and idNv:${selectedUser.id} ";
      } else {
        findNV = "";
      }
      if (selectedBx.id != null) {
        findBX = "and idBx:${selectedBx.id} ";
      } else {
        findBX = "";
      }
      if (ngay != null) {
        findNgay =
            "and startTime>:'${DateFormat('dd-MM-yyyy').format(ngay!)} 00:00:00' and startTime<:'${DateFormat('dd-MM-yyyy').format(ngay!)} 23:59:59' ";
      } else {
        findNgay = "";
      }
      if (selectStatus.id != null) {
        findStatus = "and status:${selectStatus.id} ";
      } else {
        findStatus = "";
      }
      search = findNV + findBX + findStatus + findNgay;
      print(search);
      if (search != "") if (search.substring(0, 3) == "and")
        search = search.substring(4);
    });
    callApiData();
  }

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

  onChangeRowTable(value) {
    selectedValueRpp = value;
    curentPage = 1;
    callApiData();
  }

  @override
  void initState() {
    super.initState();
    callApiData();
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
              listPreTitle: [
                {'url': "/trang-chu", 'title': 'Trang chủ'},
              ],
              content: 'Quản lý ca trực nhiện vụ',
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
                                rederNV(),
                                rederBx(),
                                rederNgay(),
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
                                                ThemMoiCTScreen(
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
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            tableWidget(),
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.all(15),
                      //   decoration: BoxDecoration(
                      //     color: white,
                      //     borderRadius: borderRadiusContainer,
                      //     boxShadow: [boxShadowContainer],
                      //     border: borderAllContainerBox,
                      //   ),
                      //   child:
                      // )
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
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(10),
      //     boxShadow: [boxShadowContainer]),
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
                          'Nhân viên',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Bãi xe',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Thời gian bắt đầu',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Thời gian kết thúc',
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
                          DataCell(SelectableText(
                              listData[i].nhanVien != null
                                  ? "${listData[i].nhanVien!.userCode} - ${listData[i].nhanVien!.fullName}"
                                  : "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              listData[i].baiXe != null
                                  ? "${listData[i].baiXe!.code} - ${listData[i].baiXe!.name}"
                                  : "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              listData[i].startTime != null
                                  ? DateFormat('HH:mm dd-MM-yyyy').format(
                                      DateTime.parse(listData[i].startTime!)
                                          .toLocal())
                                  : "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              listData[i].endTime != null
                                  ? DateFormat('HH:mm dd-MM-yyyy').format(
                                      DateTime.parse(listData[i].endTime!)
                                          .toLocal())
                                  : "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              (listData[i].status == 0)
                                  ? "Tạo mới"
                                  : (listData[i].status == 1)
                                      ? "Đang diễn ra"
                                      : (listData[i].status == 2)
                                          ? "Hoàn thành"
                                          : (listData[i].status == 3)
                                              ? "Quá hạn"
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
                                                        XemCTScreen(
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
                                  message: (listData[i].status == 0)
                                      ? "Sửa"
                                      : (listData[i].status == 1)
                                          ? "Ca trực đang thực hiện"
                                          : (listData[i].status == 2)
                                              ? "Ca trực đã hoàn thành"
                                              : "Ca trực đã quá hạn",
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                      
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: (listData[i].status == 0)
                                              ? () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SuaCTScreen(
                                                            data: listData[i],
                                                            callBack: (value) {
                                                              setState(() {
                                                                listData[i] =
                                                                    value;
                                                              });
                                                            },
                                                          ));
                                                }
                                              : null,
                                          child: Icon(
                                            Icons.edit_calendar,
                                            color: (listData[i].status == 0)
                                                ? Colors.orange
                                                : Colors.grey,
                                            size: 20,
                                          ))),
                                ),
                                Tooltip(
                                  message: (listData[i].status == 0 ||
                                          listData[i].status == 3)
                                      ? "Xoá"
                                      : (listData[i].status == 1)
                                          ? "Ca trực đang thực hiện"
                                          : (listData[i].status == 2)
                                              ? "Ca trực đã hoàn thành"
                                              : "",
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: (listData[i].status == 0 ||
                                                  listData[i].status == 3)
                                              ? () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                content:
                                                                    Container(
                                                                  height: 150,
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
                                                                                      Text('Xác nhận xoá ca trực', style: textTitleAlertDialog),
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
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  await httpDelete("/api/ca-truc/del/${listData[i].id}", context);
                                                                                  showToast(
                                                                                    context: context,
                                                                                    msg: "Xoá thành công",
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
                                                }
                                              : null,
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: (listData[i].status == 0 ||
                                                    listData[i].status == 3)
                                                ? Colors.red
                                                : Colors.grey,
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
        {"id": 0, "name": "Tạo mới"},
        {"id": 1, "name": "Đang diễn ra"},
        {"id": 2, "name": "Hoàn thành"},
        {"id": 3, "name": "Quá hạn"},
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
      marginDropdow: EdgeInsets.only(right: 20, bottom: 20),
    );
  }

  rederNV() {
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
                'Nhân viên trực ',
                style: textDropdownTitle,
              ),
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

  rederNgay() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ngày',
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
}
