// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:fe/models/bai-xe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/status.dart';
import '../../../common/dropdow_search_common.dart';
import '../../../common/footer.dart';
import '../../../common/header.dart';
import '../../../common/input-text.dart';
import '../../../common/loadApi.dart';
import '../../../common/pageding.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';
import '../../../common/toast.dart';
import 'sua-bai-xe.dart';
import 'them-bai-xe.dart';

class QuanLyBaiXeScreen extends StatefulWidget {
  const QuanLyBaiXeScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<QuanLyBaiXeScreen> {
  String error = "";
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
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");
  List<BaiXe> listData = [];
  List<bool> selectedDataRow = [];
  // Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");

  String search = "";
  String sort = "&sort=code";
  String sort1 = "&sort=code";
  String sort2 = "&sort=code,desc";
  bool sortName = false;

  Future<List<BaiXe>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet(
            "/api/bai-xe/get/page?filter=$search&$sort&page=${curentPage - 1}&size=$selectedValueRpp",
            context);
      } else {
        response = await httpGet(
            "/api/bai-xe/get/page?$sort&page=${curentPage - 1}&size=$selectedValueRpp",
            context);
      }
      // print(response);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            totalElements = body["result"]["totalElements"];
            content = body["result"]["content"];
            page = body['result']['totalPages'];
            listData = content.map((e) {
              return BaiXe.fromJson(e);
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

  onChangeRowTable(value) {
    selectedValueRpp = value;
    curentPage = 1;
    callApiData();
  }

  void btnSearch() async {
    setState(() {
      search = "";
      String findName = "";
      if (name.text != "") {
        findName = "and name~'*${name.text}*' ";
      } else {
        findName = "";
      }
      search = findName;
      if (search != "") if (search.substring(0, 3) == "and")
        search = search.substring(4);
    });
    callApiData();
  }

  void btnReset() {
    setState(() {
      name.text = '';
      search = "";
    });
    callApiData();
  }

  @override
  void initState() {
    super.initState();
    callApiData();
    setState(() {
      onload = true;
    });
    // listData.add(BaiXe(name: "Bãi xe khu A", code: "BXKA", dienTich: "500 m2", status: 1, viTri: "Phía đông", slotMax: 1000, id: 1));
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
              content: 'Quản lý bãi gửi xe',
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
                                rederName(),
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
                                                ThemMoiBaiXe(
                                                  callBack: (value) {
                                                    statusChange = value;
                                                  },
                                                ));
                                        if (statusChange) {
                                          btnReset();
                                        }
                                      },
                                      child: Text(
                                        "Thêm mới bãi xe",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                    )),
                                // Container(
                                //     margin: const EdgeInsets.only(right: 25),
                                //     padding: const EdgeInsets.symmetric(
                                //         vertical: 5, horizontal: 10),
                                //     decoration: BoxDecoration(
                                //         color: mainColor,
                                //         borderRadius: BorderRadius.circular(8)),
                                //     child: TextButton(
                                //       onPressed: () async {
                                //         bool statusChange = false;
                                //         await showDialog(
                                //             context: context,
                                //             builder: (BuildContext context) =>
                                //                 ThemMoiCTScreen(
                                //                   callBack: (value) {
                                //                     statusChange = value;
                                //                   },
                                //                 ));
                                //         if (statusChange) {
                                //           btnReset();
                                //         }
                                //       },
                                //       child: Text(
                                //         "Tạo mới",
                                //         style: TextStyle(
                                //             fontSize: 13,
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.white),
                                //       ),
                                //     )),
                              ],
                            ),
                            SizedBox(height: 15),
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
      padding: EdgeInsets.all(15),
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
                          'Mã',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Row(
                          children: [
                            Text(
                              'Tên  ',
                              style: textDataColumn,
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    sortName = !sortName;
                                    if (sortName) {
                                      sort = sort2;
                                    } else {
                                      sort = sort1;
                                    }
                                  });
                                  callApiData();
                                },
                                icon: (sortName)
                                    ? Icon(Icons.expand_more)
                                    : Icon(Icons.expand_less))
                          ],
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Diện tích',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Vị trí',
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
                        // onSelectChanged: (bool? selected) {
                        //   setState(
                        //     () {
                        //       selectedDataRow[i] = selected!;
                        //     },
                        //   );
                        // },
                        // selected: selectedDataRow[i],
                        cells: <DataCell>[
                          DataCell(Text(
                            '${tableIndex++}',
                            style: textDataRow,
                          )),
                          DataCell(SelectableText(listData[i].code ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(listData[i].name ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(listData[i].dienTich ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(listData[i].viTri ?? "",
                              style: textDataRow)),
                          DataCell(SelectableText(
                              (listData[i].status == 0)
                                  ? "Đóng"
                                  : (listData[i].status == 1)
                                      ? "Mở"
                                      : "",
                              style: textDataRow)),
                          DataCell(
                            Row(
                              children: [
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
                                                        CapNhatBaiXe(
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
                                      margin: const EdgeInsets.all(10),
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
                                                            height: 300,
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
                                                                                Text('Xác nhận xoá bãi xe', style: textTitleAlertDialog),
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
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    const Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Colors
                                                                            .black),
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                  ],
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                      "Xoá bãi xe: ${listData[i].name}",
                                                                      style:
                                                                          textNormal),
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
                                                                                await httpDelete("/api/bai-xe/del/${listData[i].id}", context);
                                                                            var body =
                                                                                jsonDecode(response["body"]);
                                                                            if (body ==
                                                                                true) {
                                                                              showToast(
                                                                                context: context,
                                                                                msg: "Xoá bãi xe thành công",
                                                                                color: const Color.fromARGB(136, 72, 238, 67),
                                                                                icon: const Icon(Icons.done),
                                                                              );
                                                                              Navigator.pop(context);
                                                                            } else {
                                                                              showToast(
                                                                                context: context,
                                                                                msg: "Bãi xe đã được sử dụng",
                                                                                color: const Color.fromARGB(255, 211, 55, 44),
                                                                                icon: const Icon(Icons.warning),
                                                                              );
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text('Xác nhận'),
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
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                15),
                                                                        ElevatedButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          child: Text(
                                                                              'Hủy',
                                                                              style: textBtnWhite),
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
}
