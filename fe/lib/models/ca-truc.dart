// ignore_for_file: file_names

import 'bai-xe.dart';
import 'user.dart';

class CaTruc {
  int? id;
  int? idNv;
  User? nhanVien;
  int? idBx;
  BaiXe? baiXe;
  String? noiDung;
  String? startTime;
  String? endTime;
  String? startClick;
  String? endClick;
  int? soLgVe;
  int? ca;
  int? tienVe;
  int? status;
  CaTruc({
    this.id,
    this.idNv,
    this.nhanVien,
    this.idBx,
    this.baiXe,
    this.noiDung,
    this.startTime,
    this.endTime,
    this.startClick,
    this.endClick,
    this.soLgVe,
    this.ca,
    this.tienVe,
    this.status,
  });
  CaTruc.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idNv = json['idNv'],
        nhanVien = User.fromJson(json['nhanVien']),
        idBx = json['idBx'],
        baiXe = BaiXe.fromJson(json['baiXe']),
        noiDung = json['noiDung'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        startClick = json['startClick'],
        endClick = json['endClick'],
        soLgVe = json['soLgVe'],
        tienVe = json['tienVe'],
        status = json['status'];
  Map<String, dynamic> toJson() => {
        'idNv': idNv,
        'idBx': idBx,
        'noiDung': noiDung,
        'ca': ca,
        'startTime': startTime,
        'endTime': endTime,
        'startClick': startClick,
        'endClick': endClick,
        'soLgVe': soLgVe,
        'tienVe': tienVe,
        'status': status,
      };
}
