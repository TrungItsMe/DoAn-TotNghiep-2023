// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously, must_be_immutable
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/xe-luu-bai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';

class XacNhanXuatBai extends StatefulWidget {
  List<XeLuuBai> data;
  Function callBack;
  XacNhanXuatBai({Key? key, required this.callBack, required this.data})
      : super(key: key);
  @override
  State<XacNhanXuatBai> createState() => _State();
}

class _State extends State<XacNhanXuatBai> {
  TextEditingController lyDo = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    lyDo.dispose();
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
            Text('Xác nhận xuất bãi', style: textTitleAlertDialog),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Thu 50,000 VNĐ/Xe ',
                style: textDropdownTitle,
              ),
            ],
          ),
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
                      'Lý do ',
                      style: textDropdownTitle,
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
                      controller: lyDo,
                      width: 300,
                      maxLines: 20,
                      minLines: 5,
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
                  for (XeLuuBai element in widget.data) {
                    element.idNvXN = user.user.id;
                    element.status = 1;
                    element.lyDo = lyDo.text;
                    await httpPut("/api/xe-luu-bai/put/${element.id}",
                        element.toJson(), context);
                  }
                  widget.callBack(true);
                  Navigator.pop(context);
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
