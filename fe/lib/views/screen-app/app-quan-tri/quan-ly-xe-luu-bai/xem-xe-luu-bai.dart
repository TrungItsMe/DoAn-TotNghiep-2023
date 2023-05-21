// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously, must_be_immutable
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe/models/xe-luu-bai.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/status.dart';
import '../../../common/input-text.dart';
import '../../../common/style.dart';
import '../../../common/toast.dart';

class XemXeLuuBai extends StatefulWidget {
  XeLuuBai data;
  XemXeLuuBai({Key? key, required this.data}) : super(key: key);
  @override
  State<XemXeLuuBai> createState() => _State();
}

class _State extends State<XemXeLuuBai> {
  XeLuuBai data = XeLuuBai();
  TextEditingController bienSo = TextEditingController();
  TextEditingController moTa = TextEditingController();
  Status selectLoaiXe = Status(id: null, name: "--Chọn--");

  @override
  void initState() {
    super.initState();
    data = widget.data;
    selectLoaiXe = Status(
        id: data.xe,
        name: data.xe == 0
            ? "Xe đạp"
            : data.xe == 1
                ? "Xe máy"
                : data.xe == 2
                    ? "Ô tô"
                    : data.xe == 3
                        ? "Khác"
                        : "--Chọn--");
    bienSo.text = data.bienSo ?? "";
    moTa.text = data.moTa ?? "";
  }

  @override
  void dispose() {
    bienSo.dispose();
    moTa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityModel>(
      builder: (context, user, child) => AlertDialog(
          content: SizedBox(
        width: 460,
        height: 750,
        child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Thông tin chi tiết', style: textTitleAlertDialog),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)),
          ]),
          Divider(thickness: 1, color: Color.fromARGB(255, 201, 201, 201)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Trạng thái ',
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
                      enabled: false,
                      controller: TextEditingController(
                        text: data.status == 0
                            ? "Đang lưu bãi"
                            : data.status == 1
                                ? "Đã xuất bãi"
                                : "",
                      ),
                      width: 300,
                      height: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Loại xe ',
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
                      enabled: false,
                      controller: TextEditingController(text: selectLoaiXe.name),
                      width: 300,
                      height: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
           const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Bãi xe ',
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
                      enabled: false,
                      controller: TextEditingController(text: "${widget.data.baiXe!.code} - ${widget.data.baiXe!.name}"),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Biển số ',
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
                      enabled: false,
                      controller: bienSo,
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
                      'Mô tả ',
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
                      enabled: false,
                      controller: moTa,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Người thêm ',
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
                      enabled: false,
                      controller: TextEditingController(text: "${data.nhanVienThem!.userCode} - ${data.nhanVienThem!.fullName}"),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Ngày lưu bãi ',
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
                      enabled: false,
                      controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(data.createdDate!).toLocal())),
                      width: 300,
                      height: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          if (data.status == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Người xác nhận ',
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
                        enabled: false,
                        controller: TextEditingController(text: "${data.nhanVienXacNhan!.userCode} - ${data.nhanVienXacNhan!.fullName}"),
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          SizedBox(height: 15),
          if (data.status == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Ngày xuất bãi ',
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
                        enabled: false,
                        controller: TextEditingController(text: DateFormat('HH:mm dd-MM-yyyy').format(DateTime.parse(data.modifiedDate!).toLocal())),
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          SizedBox(height: 15),
          if (data.status == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      Tooltip(
                        message:  data.lyDo ?? "",
                        child: TextBoxCustom(
                          enabled: false,
                          controller: TextEditingController(text: data.lyDo ?? ""),
                          width: 300,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
        ]),
      )),
    );
  }
}
