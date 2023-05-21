import 'user.dart';

class VeXe {
  int? id;
  int? idNv;
  User? nhanVien;
  String? createdDate;
  String? code;
  int? type;
  String? duration;
  String? fullName;
  String? chucVu;
  String? donVi;
  String? sdt;
  String? diaChi;
  int? xe;
  String? moTa;
  String? bienSo;
  String? point;
  int? loaiHinhTt;
  int? statusTt;
  int? status;

  VeXe({
    this.id,
    this.idNv,
    this.createdDate,
    this.nhanVien,
    this.type,
    this.duration,
    this.fullName,
    this.status,
    this.chucVu,
    this.diaChi,
    this.donVi,
    this.loaiHinhTt,
    this.moTa,
    this.bienSo,
    this.point,
    this.sdt,
    this.statusTt,
    this.xe,
  });
  VeXe.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idNv = json['idNv'],
        createdDate = json['createdDate'],
        code = json['code'],
        nhanVien = User.fromJson(json['nhanVien']),
        type = json['type'],
        duration = json['duration'],
        fullName = json['fullName'],
        chucVu = json['chucVu'],
        diaChi = json['diaChi'],
        donVi = json['donVi'],
        loaiHinhTt = json['loaiHinhTt'],
        moTa = json['moTa'],
        sdt = json['sdt'],
        statusTt = json['statusTt'],
        bienSo = json['bienSo'],
        xe = json['xe'],
        point = json['point'],
        status = json['status'];
  Map<String, dynamic> toJson() => {
        'idNv': idNv,
        'type': type,
        'code': code,
        'duration': duration,
        'fullName': fullName,
        'chucVu': chucVu,
        'diaChi': diaChi,
        'donVi': donVi,
        'loaiHinhTt': loaiHinhTt,
        'moTa': moTa,
        'sdt': sdt,
        'statusTt': statusTt,
        'xe': xe,
        'bienSo': bienSo,
        'point': point,
        'status': status,
      };
}
