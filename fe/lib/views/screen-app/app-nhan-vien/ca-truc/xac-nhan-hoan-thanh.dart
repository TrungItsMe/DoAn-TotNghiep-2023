// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously, must_be_immutable
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/ca-truc.dart';
import 'package:fe/models/xe-luu-bai.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/toast.dart';

class XacNhanHoanThanh extends StatefulWidget {
  CaTruc data;
  Function callBack;
  Function? callBackReset;
  XacNhanHoanThanh({Key? key, required this.callBack, required this.data, this.callBackReset}) : super(key: key);
  @override
  State<XacNhanHoanThanh> createState() => _State();
}

class _State extends State<XacNhanHoanThanh> {
  TextEditingController soLgVe = TextEditingController();
  TextEditingController tienVe = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    soLgVe.dispose();
    tienVe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityModel>(
      builder: (context, user, child) => AlertDialog(
          content: SizedBox(
        width: 460,
        height: 300,
        child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Xác nhận hoàn thành', style: textTitleAlertDialog),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.callBack(false);
                },
                icon: Icon(Icons.close)),
          ]),
          const SizedBox(height: 15),
          const Divider(thickness: 1, color: Colors.black),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Số vé ',
                      style: textDropdownTitle,
                    ),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    TextBoxCustom(
                      controller: soLgVe,
                      width: 300,
                      height: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Tiền vé (VND)',
                      style: textDropdownTitle,
                    ),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    TextBoxCustom(
                      controller: tienVe,
                      width: 300,
                      height: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          const Divider(thickness: 1, color: Colors.black),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (soLgVe.text == "" || tienVe.text == "" || int.tryParse(soLgVe.text) == null || int.tryParse(tienVe.text) == null) {
                    showToast(
                      context: context,
                      msg: "Cần nhập đủ thông tin và định dạng",
                      color: Colors.orange,
                      icon: const Icon(Icons.warning),
                    );
                  } else {
                    widget.data.status = 2;
                    widget.data.endClick = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm:ss').format(DateTime.now())}";
                    widget.data.soLgVe = int.tryParse(soLgVe.text);
                    widget.data.tienVe = int.tryParse(tienVe.text);
                    await httpPut("/api/ca-truc/put/${widget.data.id}", widget.data.toJson(), context);
                    widget.callBack(true);
                    widget.callBackReset!(widget.data);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Xác nhận',
                  style: textBtnWhite,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 9, 209, 26),
                  onPrimary: Colors.white,
                  elevation: 3,
                  minimumSize: Size(100, 40),
                ),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  widget.callBack(false);
                  Navigator.pop(context);
                },
                child: Text('Hủy', style: textBtnWhite),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 211, 55, 44),
                  onPrimary: Colors.white,
                  elevation: 3,
                  minimumSize: Size(100, 40),
                ),
              ),
            ],
          ),
        ]),
      )),
    );
  }
}
