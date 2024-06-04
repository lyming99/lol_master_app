// 英雄连招
class HeroCombo {
  int? id;

  // 英雄ID
  int? heroId;

  // 连招名称
  String? comboName;

  // 连招图标
  String? comboIcon;

  // 连招描述
  String? comboDesc;

  // 连招视频
  String? comboVideo;

  // 计算公式
  String? formula;
  HeroCombo({
    this.id,
    this.heroId,
    this.comboName,
    this.comboIcon,
    this.comboDesc,
    this.comboVideo,
    this.formula,
  });

  HeroCombo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heroId = json['heroId'];
    comboName = json['comboName'];
    comboIcon = json['comboIcon'];
    comboDesc= json['comboDesc'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['heroId'] = this.heroId;
    data['comboName'] = this.comboName;
    data['comboIcon'] = this.comboIcon;
    return data;
  }
}
