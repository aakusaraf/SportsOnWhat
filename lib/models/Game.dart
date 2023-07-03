class Game {
  int gameId;
  int typeId;
  int steamId;
  int eteamId;
  String date;
  String time;
  String comast;
  String dish;
  String direct;
  String gameIsactive;
  String createdAt;
  String updatedAt;
  String typeName;
  String typeImg;
  String position;
  String isactive;
  String startname;
  String endname;
  String firstteamlogo;
  String secondteamlogo;
  String datetext;
  String timetext;

  Game(
      {this.gameId,
        this.typeId,
        this.steamId,
        this.eteamId,
        this.date,
        this.time,
        this.comast,
        this.dish,
        this.direct,
        this.gameIsactive,
        this.createdAt,
        this.updatedAt,
        this.typeName,
        this.typeImg,
        this.position,
        this.isactive,
        this.startname,
        this.endname,
        this.firstteamlogo,
        this.secondteamlogo,
        this.datetext,
        this.timetext});

  Game.fromJson(Map<String, dynamic> json) {
    gameId = json['game_id'];
    typeId = json['type_id'];
    steamId = json['steam_id'];
    eteamId = json['eteam_id'];
    date = json['date'];
    time = json['time'];
    comast = json['comast'];
    dish = json['dish'];
    direct = json['direct'];
    gameIsactive = json['game_isactive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeName = json['type_name'];
    typeImg = json['type_img'];
    position = json['position'];
    isactive = json['isactive'];
    startname = json['startname'];
    endname = json['endname'];
    firstteamlogo = json['firstteamlogo'];
    secondteamlogo = json['secondteamlogo'];
    datetext = json['datetext'];
    timetext = json['timetext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_id'] = this.gameId;
    data['type_id'] = this.typeId;
    data['steam_id'] = this.steamId;
    data['eteam_id'] = this.eteamId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['comast'] = this.comast;
    data['dish'] = this.dish;
    data['direct'] = this.direct;
    data['game_isactive'] = this.gameIsactive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type_name'] = this.typeName;
    data['type_img'] = this.typeImg;
    data['position'] = this.position;
    data['isactive'] = this.isactive;
    data['startname'] = this.startname;
    data['endname'] = this.endname;
    data['firstteamlogo'] = this.firstteamlogo;
    data['secondteamlogo'] = this.secondteamlogo;
    data['datetext'] = this.datetext;
    data['timetext'] = this.timetext;
    return data;
  }
}
