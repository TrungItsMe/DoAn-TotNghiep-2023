// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';

import 'package:fe/controllers/api.dart';
import 'package:fe/models/ca-truc.dart';
import 'package:fe/views/common/loadApi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider.dart';
import '../../../common/footer.dart';
import '../../../common/header.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';
import 'chi-tiet-ca-truc.dart';

class CaTrucNVScreen extends StatefulWidget {
  const CaTrucNVScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<CaTrucNVScreen> {
  bool statusData = false;
  List<CaTruc> listCatrucFuture = [];
  List<CaTruc> listCatrucHistory = [];
  CaTruc caTrucNow = CaTruc();

  callApi() async {
    var myProvider = Provider.of<SecurityModel>(context, listen: false);
    var id = myProvider.user.id;
    var responseCTNow = await httpGet("/api/ca-truc/get/page?filter=idNv:$id and status:1", context);
    var bodyCTNow = jsonDecode(responseCTNow['body']);
    var content = [];
    content = bodyCTNow['result']['content'];
    if (content.isNotEmpty) caTrucNow = CaTruc.fromJson(content.first);
    var responseCTFuture = await httpGet("/api/ca-truc/get/page?filter=idNv:$id and status:0&sort=startTime", context);
    var bodyCTFuture = jsonDecode(responseCTFuture['body']);
    var contentFuture = [];
    contentFuture = bodyCTFuture['result']['content'];
    listCatrucFuture = contentFuture.map((e) {
      return CaTruc.fromJson(e);
    }).toList();

    var responseCTHistory = await httpGet("/api/ca-truc/get/page?filter=idNv:$id and status!0 and status!1&sort=status&sort=endTime", context);
    var bodyCTHistory = jsonDecode(responseCTHistory['body']);
    var contentHistory = [];
    contentHistory = bodyCTHistory['result']['content'];
    listCatrucHistory = contentHistory.map((e) {
      return CaTruc.fromJson(e);
    }).toList();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      callApi();
    });
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
              content: 'Ca trực',
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
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (caTrucNow.id != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Đang diễn ra",
                                style: titleContainerBox,
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CTCTScreen(
                                            data: caTrucNow,
                                            callback: (value) {
                                              setState(() {
                                                caTrucNow = value;
                                              });
                                            },
                                          ));
                                },
                                child: Container(
                                  width: 200,
                                  height: 290,
                                  decoration: BoxDecoration(color: Colors.grey[300]),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: Image.asset(
                                          (DateTime.parse(caTrucNow.startTime!).toLocal().hour < 21) ? "/images/cn-ngay.jpeg" : "/images/cn-dem.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      (caTrucNow.status == 0)
                                          ? Text(
                                              "  Tạo mới",
                                              style: textDropdownTitleOrange,
                                            )
                                          : (caTrucNow.status == 1)
                                              ? Text(
                                                  "  Đang diễn ra",
                                                  style: textDropdownTitleGreen,
                                                )
                                              : (caTrucNow.status == 2)
                                                  ? Text(
                                                      "  Hoàn thành",
                                                      style: textCardContentBlue,
                                                    )
                                                  : Text(
                                                      "  Quá hạn",
                                                      style: textDropdownTitleRed,
                                                    ),
                                      SizedBox(height: 10),
                                      Text(
                                        "  Bãi trực: ${caTrucNow.baiXe!.code}-${caTrucNow.baiXe!.name}",
                                        style: textBtnBlack,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.schedule,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "${DateFormat('HH:mm').format(DateTime.parse(caTrucNow.startTime!).toLocal())} - ${DateFormat('HH:mm dd-MM-yyyy').format(DateTime.parse(caTrucNow.endTime!).toLocal())}",
                                            style: textDataColumn,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(thickness: 1, color: Color.fromARGB(255, 148, 148, 148)),
                              SizedBox(height: 10),
                            ],
                          ),
                        Text(
                          "Được phân công",
                          style: titleContainerBox,
                        ),
                        SizedBox(height: 15),
                        Wrap(
                          children: [
                            for (CaTruc element in listCatrucFuture)
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CTCTScreen(
                                            data: element,
                                            callback: (value) {
                                              setState(() {
                                                element = value;
                                              });
                                            },
                                          ));
                                },
                                child: Container(
                                  width: 200,
                                  height: 290,
                                  decoration: BoxDecoration(color: Colors.grey[300]),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: Image.asset(
                                          (DateTime.parse(element.startTime!).toLocal().hour < 21) ? "/images/cn-ngay.jpeg" : "/images/cn-dem.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      (element.status == 0)
                                          ? Text(
                                              "  Tạo mới",
                                              style: textDropdownTitleOrange,
                                            )
                                          : (element.status == 1)
                                              ? Text(
                                                  "  Đang diễn ra",
                                                  style: textDropdownTitleGreen,
                                                )
                                              : (element.status == 2)
                                                  ? Text(
                                                      "  Hoàn thành",
                                                      style: textCardContentBlue,
                                                    )
                                                  : Text(
                                                      "  Quá hạn",
                                                      style: textDropdownTitleRed,
                                                    ),
                                      SizedBox(height: 10),
                                      Text(
                                        "  Bãi trực: ${element.baiXe!.code}-${element.baiXe!.name}",
                                        style: textBtnBlack,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.schedule,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "${DateFormat('HH:mm').format(DateTime.parse(element.startTime!).toLocal())} - ${DateFormat('HH:mm dd-MM-yyyy').format(DateTime.parse(element.endTime!).toLocal())}",
                                            style: textDataColumn,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: 1, color: Color.fromARGB(255, 148, 148, 148)),
                        SizedBox(height: 10),
                        Text(
                          "Lịch sử",
                          style: titleContainerBox,
                        ),
                        SizedBox(height: 15),
                        Wrap(
                          children: [
                            for (CaTruc element in listCatrucHistory)
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CTCTScreen(
                                            data: element,
                                            callback: (value) {
                                              setState(() {
                                                element = value;
                                              });
                                            },
                                          ));
                                },
                                child: Container(
                                  width: 200,
                                  height: 290,
                                  decoration: BoxDecoration(color: Colors.grey[300]),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: Image.asset(
                                          (DateTime.parse(element.startTime!).toLocal().hour < 21) ? "/images/cn-ngay.jpeg" : "/images/cn-dem.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      (element.status == 0)
                                          ? Text(
                                              "  Tạo mới",
                                              style: textDropdownTitleOrange,
                                            )
                                          : (element.status == 1)
                                              ? Text(
                                                  "  Đang diễn ra",
                                                  style: textDropdownTitleGreen,
                                                )
                                              : (element.status == 2)
                                                  ? Text(
                                                      "  Hoàn thành",
                                                      style: textCardContentBlue,
                                                    )
                                                  : Text(
                                                      "  Quá hạn",
                                                      style: textDropdownTitleRed,
                                                    ),
                                      SizedBox(height: 10),
                                      Text(
                                        "  Bãi trực: ${element.baiXe!.code}-${element.baiXe!.name}",
                                        style: textBtnBlack,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.schedule,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "${DateFormat('HH:mm').format(DateTime.parse(element.startTime!).toLocal())} - ${DateFormat('HH:mm dd-MM-yyyy').format(DateTime.parse(element.endTime!).toLocal())}",
                                            style: textDataColumn,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
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
