/// 1.存到配置文件
/// 2.存到hive数据库
/// 3.存到sqlite数据库
class LolConfig {
  int? id;
  String? configId;
  bool? autoAccept;
  int? autoAcceptDelay;

  bool? autoSelect;
  int? primaryHero;
  int? secondaryHero;

  LolConfig({
    this.id,
    this.configId,
    this.autoAccept,
    this.autoAcceptDelay,
    this.autoSelect,
    this.primaryHero,
    this.secondaryHero,
  });

  factory LolConfig.fromJson(Map<String, dynamic> json) {
    return LolConfig(
      id: json['id'],
      configId: json['configId'],
      autoAccept: json['autoAccept'],
      autoAcceptDelay: json['autoAcceptDelay'],
      autoSelect: json['autoSelect'],
      primaryHero: json['primaryHero'],
      secondaryHero: json['secondaryHero'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'configId': configId,
      'autoAccept': autoAccept,
      'autoAcceptDelay': autoAcceptDelay,
      'autoSelect': autoSelect,
      'primaryHero': primaryHero,
      'secondaryHero': secondaryHero,
    };
  }
}
