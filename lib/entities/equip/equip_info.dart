class EquipInfo {
  String? itemId;
  String? name;
  String? icon;
  String? desc;
  String? effect;
  String? effectDesc;
  String? keywords;

  String? price;
  String? sell;
  String? types;

  EquipInfo({
    this.itemId,
    this.keywords,
    this.name,
    this.icon,
    this.desc,
    this.effect,
    this.effectDesc,
    this.price,
    this.sell,
    this.types,
  });

  // copy
  EquipInfo copyWith({
    String? itemId,
    String? keywords,
    String? name,
    String? icon,
    String? desc,
    String? effect,
    String? effectDesc,
    String? price,
    String? sell,
    String? types,
  }) =>
      EquipInfo(
        itemId: itemId ?? this.itemId,
        keywords: keywords ?? this.keywords,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        desc: desc ?? this.desc,
        effect: effect ?? this.effect,
        effectDesc: effectDesc ?? this.effectDesc,
        price: price ?? this.price,
        sell: sell ?? this.sell,
        types: types ?? this.types,
      );

  factory EquipInfo.fromJson(Map<String, dynamic> json) => EquipInfo(
        itemId: json["itemId"],
        keywords: json["keywords"],
        name: json["name"],
        icon: json["icon"],
        desc: json["desc"],
        effect: json["effect"],
        effectDesc: json["effectDesc"],
        price: json["price"],
        sell: json["sell"],
        types: json["types"],
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "keywords": keywords,
        "name": name,
        "icon": icon,
        "desc": desc,
        "effect": effect,
        "effectDesc": effectDesc,
        "price": price,
        "sell": sell,
        "types": types,
      };
}
