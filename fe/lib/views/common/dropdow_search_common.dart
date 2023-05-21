// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'dart:convert';
import 'package:fe/models/bai-xe.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../controllers/api.dart';
import '../../models/status.dart';

class DropdowSearchComon extends StatefulWidget {
  final Function? onChangedCallback; //hàm call back
  final int indexTypeDropdow; //Lựa chọn các dropdow khác nhau
  final Widget? labelDropdow; //Tiêu đề
  final EdgeInsetsGeometry? marginDropdow; //Khoảng cách
  final double? widthDropdow; //Độ rộng
  final int? selectStatus;
  final Status? selectedItemStatus;
  final String? removeSelection; //Xóa bỏ lựa chọn trả về -1
  final int? selectedValueRpp; //Số lượng hiển thị dữ liệu trong bảng
  final Status? selectedTrueFalse;
  final BaiXe? selectedItemBaiXe;
  double? heightStatus;
  final List<dynamic>? listStatusSelect;

  DropdowSearchComon({
    super.key,
    this.marginDropdow,
    this.onChangedCallback,
    required this.indexTypeDropdow,
    this.labelDropdow,
    this.widthDropdow,
    this.selectStatus,
    this.selectedItemStatus,
    this.removeSelection,
    this.selectedValueRpp,
    this.selectedTrueFalse,
    this.listStatusSelect,
    this.selectedItemBaiXe,
    this.heightStatus,
  });

  @override
  State<DropdowSearchComon> createState() => _DropdowSearchComonState();
}

class _DropdowSearchComonState extends State<DropdowSearchComon> {
  //call api bai gui xe
  Future<List<BaiXe>> callBaixe() async {
    List<BaiXe> listBaiXe = [];
    try {
      var response = await httpGet("/api/lop-hoc/get/page?filter=status:1", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listBaiXe = content.map((e) {
              return BaiXe.fromJson(e);
            }).toList();
            if (widget.removeSelection != null && widget.removeSelection == "removeSelection") {
              BaiXe all = BaiXe(id: null, name: "--Chọn bãi xe--");
              listBaiXe.insert(0, all);
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listBaiXe;
  }

  //Trạng thái
  Future<List<Status>> callStatus() async {
    var object = [];

    if (widget.listStatusSelect != null && widget.listStatusSelect!.isNotEmpty) {
      object = widget.listStatusSelect!;
    } else {
      object = [
        {"id": 0, "name": "Draft"},
        {"id": 1, "name": "active"},
      ];
    }

    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    if (widget.removeSelection != null && widget.removeSelection == "removeSelection") {
      Status all = Status(id: null, name: "--Chọn--");
      listStatus.insert(0, all);
    }

    return listStatus;
  }

  //
  Future<List<Status>> callGender() async {
    var object = [
      {"id": 0, "name": "Nam"},
      {"id": 1, "name": "Nữ"},
    ];
    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    if (widget.removeSelection != null && widget.removeSelection == "removeSelection") {
      Status all = Status(id: null, name: "--Chọn giới tính--");
      listStatus.insert(0, all);
    }

    return listStatus;
  }

  Widget selectDropdow(value) {
    if (value == 1) {
      return dropdowBaixe();
    } else if (value == 5) {
      return dropdowStatus();
    } else if (value == 6) {
      return dropdowTable();
    }
    return const Text("không có dữ liệu ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widthDropdow,
      margin: widget.marginDropdow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.labelDropdow ?? Text(""),
          SizedBox(height: 10),
          selectDropdow(widget.indexTypeDropdow),
        ],
      ),
    );
  }

  //dropdow lop hoc
  Widget dropdowBaixe({String? hintText}) {
    return DropdownSearch<BaiXe>(
      asyncItems: (String? filter) => callBaixe(),
      itemAsString: (BaiXe? u) => u!.name.toString(),
      selectedItem: widget.selectedItemBaiXe,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          constraints: const BoxConstraints.tightFor(
            width: 300,
            height: 40,
          ),
          contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
          ),
          hintText: hintText ?? "--Chọn--",
          hintMaxLines: 1,
          enabledBorder: const OutlineInputBorder(
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
        widget.onChangedCallback!(value);
      },
      // selectedItems: ["Brazil"],
    );
  }

  //Trạng thái
  Widget dropdowStatus({String? hintText}) {
    return DropdownSearch<Status>(
      selectedItem: widget.selectedItemStatus,
      asyncItems: (String? filter) => callStatus(),
      itemAsString: (Status? u) => u!.name.toString(),
      // items: widget.listStatus ?? [],
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
      popupProps: PopupPropsMultiSelection.menu(
        constraints: BoxConstraints.expand(
          width: 300,
          height: widget.heightStatus ?? 300,
        ),
        showSearchBox: false,
      ),
      onChanged: (value) {
        widget.onChangedCallback!(value);
      },
    );
  }

  //gioi tinh
  Widget dropdowGender({String? hintText}) {
    return DropdownSearch<Status>(
      selectedItem: widget.selectedItemStatus,
      asyncItems: (String? filter) => callGender(),
      itemAsString: (Status? u) => u!.name.toString(),
      // items: widget.listStatus ?? [],
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
          // hintText: hintText ?? '--Trạng thái--',
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
        showSearchBox: false,
      ),
      onChanged: (value) {
        widget.onChangedCallback!(value);
      },
    );
  }

  //hien thi
  Widget dropdowTable({String? hintText}) {
    return DropdownSearch<int>(
      selectedItem: widget.selectedValueRpp,
      // asyncItems: (String? filter) => callStatus(),
      // itemAsString: (Status? u) => u!.name.toString(),
      // items: widget.listStatus ?? [],
      items: [5, 10, 20, 50],
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          constraints: const BoxConstraints.tightFor(
            width: 100,
            height: 40,
          ),
          contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
          ),
          // hintText: hintText ?? '--Trạng thái--',
          hintMaxLines: 1,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
          ),
        ),
      ),
      popupProps: const PopupPropsMultiSelection.menu(
        constraints: BoxConstraints.expand(
          width: 100,
          height: 200,
        ),
        showSearchBox: false,
      ),
      onChanged: (value) {
        widget.onChangedCallback!(value);
      },
    );
  }
}
