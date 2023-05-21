class User {
  int? id;
  String? password;
  String? username;
  int? role;
  String? userCode;
  String? fullName;
  String? email;
  String? sdt;
  String? address;
  String? cccd;
  String? ngayVao;
  String? avatar;
  int? gioiTinh;
  String? ngaySinh;
  String? diaChi;
  int? status;
  User({
    this.id,
    this.fullName,
    this.password,
    this.username,
    this.userCode,
    this.role,
    this.email,
    this.sdt,
    this.cccd,
    this.ngayVao,
    this.address,
    this.avatar,
    this.gioiTinh,
    this.ngaySinh,
    this.diaChi,
    this.status,
  });
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        role = json['role'],
        fullName = json['fullName'],
        username = json['userName'],
        password = json['password'],
        userCode = json['userCode'],
        email = json['email'],
        sdt = json['sdt'],
        address = json['address'],
        avatar = json['avatar'],
        gioiTinh = json['gioiTinh'],
        diaChi = json['diaChi'],
        ngaySinh = json['ngaySinh'],
        cccd = json['cccd'],
        ngayVao = json['ngayVao'],
        status = json['status'];
  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'userName': username,
        'password': password,
        'email': email,
        'userCode': userCode,
        'role': role,
        'sdt': sdt,
        'address': address,
        'avatar': avatar,
        'gioiTinh': gioiTinh,
        'ngaySinh': ngaySinh,
        'cccd': cccd,
        'ngayVao': ngayVao,
        'diaChi': diaChi,
        'status': status,
      };
}
