// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, unused_local_variable
import 'dart:convert';

import 'package:fe/views/common/loadApi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../common/footer.dart';
import '../../../common/header.dart';
import '../../../common/style.dart';
import '../../../common/title-page.dart';

class TrangChuScreen extends StatefulWidget {
  const TrangChuScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<TrangChuScreen> {
  List<_SalesData> data = [
    // _SalesData('05/2022', 28),
    // _SalesData('06/2022', 34),
    // _SalesData('07/2022', 32),
    // _SalesData('08/2022', 40),
    // _SalesData('09/2022', 40),
    // _SalesData('10/2022', 40),
    // _SalesData('11/2022', 40),
    // _SalesData('12/2022', 40),
    // _SalesData('01/2023', 40),
    // _SalesData('02/2023', 40),
    // _SalesData('03/2023', 40),
    // _SalesData('04/2023', 35),
  ];
  List<DateTime> listDateDs = [];
  List<String> listDateDsFormat = [];
  bool statusData = false;
  int countXeLuuBai = 0;
  int bienDem = 12;

  DateTime now = DateTime.now();
  late DateTime dateBegin;
  callApi() async {
    dateBegin = DateTime(now.year - 1, now.month + 1, 1);
    DateTime nextMonth = dateBegin;
    if (dateBegin.month == 12) {
      nextMonth = DateTime(dateBegin.year + 1, 1, 1);
    } else {
      nextMonth = DateTime(dateBegin.year, dateBegin.month + 1, 1);
    }
    listDateDs.add(dateBegin);
    listDateDsFormat.add("${DateFormat('dd-MM-yyyy').format(dateBegin)} 00:00:01");
    var responseLB = await httpGet("/api/xe-luu-bai/get/page?filter=status:0", context);
    var bodyLB = jsonDecode(responseLB["body"]);
    var contentLb = bodyLB["result"]["totalElements"];
    //
    var responseCT1 = await httpGet("/api/ca-truc/get/page?filter=status:2 and endTime>:'${DateFormat('dd-MM-yyyy').format(dateBegin)} 00:00:01' and endTime<:'${DateFormat('dd-MM-yyyy').format(nextMonth)} 00:00:01'", context);
    var bodyCT1 = jsonDecode(responseCT1["body"]);
    var contentCT1 = bodyCT1["result"]["content"];
    var responseVX1 = await httpGet("/api/ve-xe/get/page?filter=status:1 and statusTt:1 and modifiedDate>:'${DateFormat('dd-MM-yyyy').format(dateBegin)} 00:00:01' and modifiedDate<:'${DateFormat('dd-MM-yyyy').format(nextMonth)} 00:00:01'", context);
    var bodyVX1 = jsonDecode(responseVX1["body"]);
    var contentVX1 = bodyVX1["result"]["content"];
    var responseXL1 = await httpGet("/api/xe-luu-bai/get/page?filter=status:1 and modifiedDate>:'${DateFormat('dd-MM-yyyy').format(dateBegin)} 00:00:01' and modifiedDate<:'${DateFormat('dd-MM-yyyy').format(nextMonth)} 00:00:01'", context);
    var bodyXL1 = jsonDecode(responseXL1["body"]);
    var totalElementsXL1 = bodyXL1["result"]["totalElements"];
    //
    double countCT1 = 0;
    for (var element in contentCT1) {
      countCT1 += int.parse(element['tienVe'].toString());
    }
    for (var element in contentVX1) {
      countCT1 += int.tryParse(element['point'].toString()) ?? 0;
    }
    if (totalElementsXL1 != 0) {
      countCT1 += (totalElementsXL1 * 50000);
    }

    data.add(_SalesData(DateFormat('MM/yyyy').format(dateBegin), countCT1));
    //
    for (var i = 1; i <= bienDem; i++) {
      if (listDateDs[i - 1].month == 12) {
        listDateDs.add(DateTime(listDateDs[i - 1].year + 1, 1, 1));
        listDateDsFormat.add("${DateFormat('dd-MM-yyyy').format(listDateDs[i])} 00:00:01");
      } else {
        listDateDs.add(DateTime(listDateDs[i - 1].year, listDateDs[i - 1].month + 1, 1));
        listDateDsFormat.add("${DateFormat('dd-MM-yyyy').format(listDateDs[i])} 00:00:01");
      }
    }
    for (var i = 1; i < listDateDsFormat.length - 1; i++) {
      var responseCT2 = await httpGet("/api/ca-truc/get/page?filter=status:2 and endTime>:'${listDateDsFormat[i]}' and endTime<:'${listDateDsFormat[i + 1]}'", context);
      var bodyCT2 = jsonDecode(responseCT2["body"]);
      var contentCT2 = bodyCT2["result"]["content"];
      var responseVX2 = await httpGet("/api/ve-xe/get/page?filter=status:1 and statusTt:1 and modifiedDate>:'${listDateDsFormat[i]}' and modifiedDate<:'${listDateDsFormat[i + 1]}'", context);
      var bodyVX2 = jsonDecode(responseVX2["body"]);
      var contentVX2 = bodyVX2["result"]["content"];
      var responseXL2 = await httpGet("/api/xe-luu-bai/get/page?filter=status:1 and modifiedDate>:'${listDateDsFormat[i]}' and modifiedDate<:'${listDateDsFormat[i + 1]}'", context);
      var bodyXL2 = jsonDecode(responseXL2["body"]);
      var totalElementsXL2 = bodyXL2["result"]["totalElements"];
      double countCT2 = 0;
      for (var element1 in contentCT2) {
        countCT2 += int.parse(element1['tienVe'].toString());
      }
      for (var element in contentVX2) {
        countCT2 += int.tryParse(element['point'].toString()) ?? 0;
      }
      if (totalElementsXL2 != 0) {
        countCT2 += (totalElementsXL2 * 50000);
      }
      data.add(_SalesData(DateFormat('MM/yyyy').format(listDateDs[i]), countCT2));
    }
    // print(listDateDsFormat);
    setState(() {
      countXeLuuBai = contentLb;
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return Header(
        widgetBody: Consumer<SecurityModel>(
      builder: (context, user, child) => Scaffold(
        body: statusData
            ? ListView(
                controller: ScrollController(),
                children: [
                  TitlePage(
                    listPreTitle: [],
                    content: 'Trang chủ',
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: borderRadiusContainer,
                            boxShadow: [boxShadowContainer],
                            border: borderAllContainerBox,
                          ),
                          padding: paddingBoxContainer,
                          child: Column(children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: borderRadiusContainer,
                                    boxShadow: [boxShadowContainer],
                                    border: borderAllContainerBox,
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/quan-ly-xe-luu-bai');
                                      setState(() {
                                        user.changeSttMenu(6);
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 20),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: colorBGIconOverviewDataBox1,
                                                  borderRadius: borderRadiusIconOverviewDataBox,
                                                ),
                                                child: Icon(
                                                  Icons.motorcycle,
                                                  color: white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Xe đang lưu bãi',
                                                        style: titleOverviewDataBox,
                                                        maxLines: 2,
                                                        softWrap: false,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        "$countXeLuuBai",
                                                        style: dataOverviewDataBox,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            //Initialize the chart widget
                            SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                // Chart title
                                title: ChartTitle(text: 'Doanh thu các tháng'),
                                // Enable legend
                                legend: Legend(isVisible: true),
                                // Enable tooltip
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <ChartSeries<_SalesData, String>>[
                                  LineSeries<_SalesData, String>(
                                      dataSource: data,
                                      xValueMapper: (_SalesData sales, _) => sales.year,
                                      yValueMapper: (_SalesData sales, _) => sales.sales,
                                      name: 'Doang thu (VNĐ)',
                                      // Enable data label
                                      dataLabelSettings: DataLabelSettings(isVisible: true))
                                ]),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Footer()
                ],
              )
            : CommonApp().loadingCallAPi(),
      ),
    ));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
