// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use, sort_child_properties_last
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/bai-xe.dart';
import 'package:fe/models/ca-truc.dart';
import 'package:fe/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../common/date-picker.dart';
import '../../../common/footer.dart';
import '../../../common/header.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';
import 'package:intl/intl.dart';

import '../../../common/toast.dart';
import 'xac-nhan-hoan-thanh.dart';

class CTCTScreen extends StatefulWidget {
  CaTruc data;
  Function? callback;
  CTCTScreen({Key? key, required this.data, this.callback}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CTCTScreen> {
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

  CaTruc data = CaTruc();
  @override
  void initState() {
    super.initState();
    data = widget.data;
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
              listPreTitle: [],
              content: "Thông tin chi tiết ca trực ",
              widgetBoxRight: Container(
                margin: EdgeInsets.only(top: 20),
                child: StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Text(DateFormat('dd/MM/yyyy  hh:mm:ss').format(DateTime.now()), style: textCardTitle);
                  },
                ),
              ),
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
                            rederStatus(),
                            Wrap(
                              children: [rederMaNV(), rederTenNV(), rederSdtNV()],
                            ),
                            Wrap(
                              children: [rederMaBx(), rederTenBx()],
                            ),
                            Wrap(
                              children: [rederStartTime(), rederEndTime()],
                            ),
                            Wrap(
                              children: [rederND()],
                            ),
                            if (data.status == 2 || data.status == 1)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(thickness: 1, color: Color.fromARGB(255, 148, 148, 148)),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Text(
                                        'Diễn biến',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Wrap(
                                    children: [rederStartClick(), rederEndClick(), rederSolg(), rederTienVe()],
                                  ),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (data.status == 0)
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          processing();
                                          var responseCTNow = await httpGet("/api/ca-truc/get/page?filter=idNv:${widget.data.idNv} and status:1", context);
                                          var bodyCTNow = jsonDecode(responseCTNow['body']);
                                          var content = [];
                                          content = bodyCTNow['result']['content'];
                                          if (content.isNotEmpty) {
                                            showToast(
                                              context: context,
                                              msg: "Đang tham gia ca trực lúc ${DateFormat('HH:mm dd-MM-yyyy').format(DateTime.parse(content.first['startTime']).toLocal())}",
                                              color: Colors.orange,
                                              icon: const Icon(Icons.warning),
                                            );
                                            Navigator.pop(context);
                                          } else {
                                            setState(() {
                                              data.status = 1;
                                              data.startClick = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm:ss').format(DateTime.now())}";
                                            });
                                            await httpPut("/api/ca-truc/put/${widget.data.id}", data.toJson(), context);
                                            widget.callback!(data);
                                            showToast(
                                              context: context,
                                              msg: "Đã xác nhận trực",
                                              color: Color.fromARGB(136, 72, 238, 67),
                                              icon: const Icon(Icons.done),
                                            );
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text('Xác nhận trực', style: textBtnWhite),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color.fromARGB(255, 0, 129, 32),
                                          onPrimary: Colors.white,
                                          elevation: 3,
                                          minimumSize: Size(100, 40),
                                        ),
                                      )
                                    : (data.status == 1)
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              processing();
                                              bool statusChange = false;
                                              CaTruc? reset;
                                              await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => XacNhanHoanThanh(
                                                        data: data,
                                                        callBack: (value) {
                                                          statusChange = value;
                                                        },
                                                        callBackReset: (value) {
                                                          setState(() {
                                                            reset = value;
                                                          });
                                                        },
                                                      ));
                                              if (statusChange) {
                                                showToast(
                                                  context: context,
                                                  msg: "Đã xác nhận hoàn thành",
                                                  color: Color.fromARGB(136, 72, 238, 67),
                                                  icon: const Icon(Icons.done),
                                                );
                                                widget.callback!(reset);
                                              }
                                              Navigator.pop(context);
                                              // processing();
                                              // bool statusChange = false;
                                              // CaTruc? reset;
                                              // await showDialog(
                                              //     context: context,
                                              //     builder: (BuildContext context) => XacNhanHoanThanh(
                                              //           data: data,
                                              //           callBack: (value) {
                                              //             statusChange = value;
                                              //           },
                                              //           callBackReset: (value){
                                              //             setState(() {
                                              //               reset = value;
                                              //             });
                                              //           },
                                              //         ));
                                              // if (statusChange) {
                                              //   showToast(
                                              //     context: context,
                                              //     msg: "Đã xác nhận hoàn thành",
                                              //     color: Color.fromARGB(136, 72, 238, 67),
                                              //     icon: const Icon(Icons.done),
                                              //   );
                                              //   setState(() {

                                              //   });
                                              //   widget.callback!(data);
                                              // }
                                              // Navigator.pop(context);

                                              // await httpPut("/api/ca-truc/put/${widget.data.id}", data.toJson(), context);
                                            },
                                            child: Text('Hoàn thành', style: textBtnWhite),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                              onPrimary: Colors.white,
                                              elevation: 3,
                                              minimumSize: Size(100, 40),
                                            ),
                                          )
                                        : Container(),
                                SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.callback!(data);
                                  },
                                  child: Text('Trở về', style: textBtnWhite),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.orange,
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

  rederStatus() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trạng thái',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(
                text: (data.status == 0)
                    ? "Tạo mới"
                    : (data.status == 1)
                        ? "Đang diễn ra"
                        : (data.status == 2)
                            ? "Hoàn thành"
                            : (data.status == 3)
                                ? "Quá hạn"
                                : "",
              ),
            ),
          )
        ],
      ),
    );
  }

  rederMaNV() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mã NV',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: data.nhanVien!.userCode ?? ""),
            ),
          )
        ],
      ),
    );
  }

  rederTenNV() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tên NV',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: data.nhanVien!.fullName ?? ""),
            ),
          )
        ],
      ),
    );
  }

  rederSdtNV() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SĐT',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: data.nhanVien!.sdt ?? ""),
            ),
          )
        ],
      ),
    );
  }

  rederTenBx() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tên bãi xe',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: data.baiXe!.name ?? ""),
            ),
          )
        ],
      ),
    );
  }

  rederMaBx() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mã bãi xe',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: data.baiXe!.code ?? ""),
            ),
          )
        ],
      ),
    );
  }

  rederStartTime() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Từ',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: DateFormat('HH:mm dd-MM-yyyy').format(DateTime.parse(data.startTime!).toLocal())),
            ),
          )
        ],
      ),
    );
  }

  rederEndTime() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đến',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: DateFormat('HH:mm dd-MM-yyyy').format(DateTime.parse(data.endTime!).toLocal())),
            ),
          )
        ],
      ),
    );
  }

  rederStartClick() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NV bắt đầu lúc',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: data.startClick != null ? DateFormat('HH:mm').format(DateTime.parse(data.startClick!).toLocal()) : ""),
            ),
          )
        ],
      ),
    );
  }

  rederEndClick() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NV hoàn thành lúc',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              enabled: false,
              controller: TextEditingController(text: data.endClick != null ? DateFormat('HH:mm').format(DateTime.parse(data.endClick!).toLocal()) : ""),
            ),
          )
        ],
      ),
    );
  }

  rederND() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nội dung',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              enabled: false,
              controller: TextEditingController(text: data.noiDung ?? ""),
              maxLines: 50,
              minLines: 4,
            ),
          )
        ],
      ),
    );
  }

  rederSolg() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Số lượng vé',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              enabled: false,
              controller: TextEditingController(text: (data.soLgVe != null) ? data.soLgVe.toString() : ""),
              height: 40,
            ),
          )
        ],
      ),
    );
  }

  rederTienVe() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiền vé',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              enabled: false,
              controller: TextEditingController(text: (data.tienVe != null) ? "${data.tienVe} VND" : ""),
              height: 40,
            ),
          )
        ],
      ),
    );
  }

}
