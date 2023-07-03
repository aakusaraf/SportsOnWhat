class GameType {
  int typeId;
  String typeName;
  String typeImg;
  String position;
  String isactive;
  String createdAt;
  String updatedAt;

  GameType(
      {this.typeId,
        this.typeName,
        this.typeImg,
        this.position,
        this.isactive,
        this.createdAt,
        this.updatedAt});

  GameType.fromJson(Map<String, dynamic> json) {
    typeId = json['type_id'];
    typeName = json['type_name'];
    typeImg = json['type_img'];
    position = json['position'];
    isactive = json['isactive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_id'] = this.typeId;
    data['type_name'] = this.typeName;
    data['type_img'] = this.typeImg;
    data['position'] = this.position;
    data['isactive'] = this.isactive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
