class CustomSettings {
  int settingId;
  String settingName;
  String settingValue;
  String createdAt;
  String updatedAt;

  CustomSettings(
      {this.settingId,
        this.settingName,
        this.settingValue,
        this.createdAt,
        this.updatedAt});

  CustomSettings.fromJson(Map<String, dynamic> json) {
    settingId = json['setting_id'];
    settingName = json['setting_name'];
    settingValue = json['setting_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['setting_id'] = this.settingId;
    data['setting_name'] = this.settingName;
    data['setting_value'] = this.settingValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
