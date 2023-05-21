class BaiXe {
  int? id;
  String? name;
  String? code;
  String? dienTich;
  String? viTri;
  String? slotMax;
  int? status;
  BaiXe({
    this.id,
    this.name,
    this.code,
    this.dienTich,
    this.viTri,
    this.slotMax,
    this.status,
  });
  BaiXe.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        code = json['code'],
        dienTich = json['dienTich'],
        viTri = json['viTri'],
        slotMax = json['slotMax'],
        status = json['status'];
  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'dienTich': dienTich,
        'viTri': viTri,
        'slotMax': slotMax,
        'status': status,
      };
}
