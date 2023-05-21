import 'bai-xe.dart';
import 'user.dart';

class XeLuuBai {
  String? createdDate;
  String? modifiedDate;
  int? id;
  int? idNvT;
  User? nhanVienThem;
  int? xe;
  String? bienSo;
  String? moTa;
  int? idNvXN;
  User? nhanVienXacNhan;
  String? lyDo;
  int? idBx;
  BaiXe? baiXe;
  int? status;
  XeLuuBai({
    this.id,
    this.createdDate,
    this.idBx,
    this.baiXe,
    this.modifiedDate,
    this.idNvT,
    this.nhanVienThem,
    this.xe,
    this.bienSo,
    this.moTa,
    this.idNvXN,
    this.nhanVienXacNhan,
    this.lyDo,
    this.status,
  });
  XeLuuBai.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idNvT = json['idNvT'],
        createdDate = json['createdDate'],
        modifiedDate = json['modifiedDate'],
        nhanVienThem = User.fromJson(json['nhanVienThem']),
        idNvXN = json['idNvT'],
        nhanVienXacNhan = (json['nhanVienXacNhan'] != null)
            ? User.fromJson(json['nhanVienXacNhan'])
            : null,
        xe = json['xe'],
        bienSo = json['bienSo'],
        lyDo = json['lyDo'],
        moTa = json['moTa'],
        idBx = json['idBx'],
        baiXe = (json['baiXe'] != null) ? BaiXe.fromJson(json['baiXe']) : null,
        status = json['status'];
  Map<String, dynamic> toJson() => {
        'idNvT': idNvT,
        'xe': xe,
        'bienSo': bienSo,
        'moTa': moTa,
        'idBx': idBx,
        'idNvXN': idNvXN,
        'lyDo': lyDo,
        'status': status,
      };
}
