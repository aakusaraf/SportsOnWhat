class Packages {
  int packId;
  String packDuration;
  String packType;
  String packPrice;
  String packDescription;
  String packIsactive;
  String createdAt;
  String updatedAt;

  Packages(
      {this.packId,
        this.packDuration,
        this.packType,
        this.packPrice,
        this.packDescription,
        this.packIsactive,
        this.createdAt,
        this.updatedAt});

  Packages.fromJson(Map<String, dynamic> json) {
    packId = json['pack_id'];
    packDuration = json['pack_duration'];
    packType = json['pack_type'];
    packPrice = json['pack_price'];
    packDescription = json['pack_description'];
    packIsactive = json['pack_isactive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pack_id'] = this.packId;
    data['pack_duration'] = this.packDuration;
    data['pack_type'] = this.packType;
    data['pack_price'] = this.packPrice;
    data['pack_description'] = this.packDescription;
    data['pack_isactive'] = this.packIsactive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
