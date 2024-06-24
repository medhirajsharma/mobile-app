class NftDetailModel {
  List<Attributes>? attributes;
  String? description;
  String? image;
  String? name;

  NftDetailModel({this.attributes, this.description, this.image, this.name});

  NftDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(new Attributes.fromJson(v));
      });
    }
    description = json['description'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['image'] = this.image;
    data['name'] = this.name;
    return data;
  }
}

class Attributes {
  String? traitType;
  String? value;

  Attributes({this.traitType, this.value});

  Attributes.fromJson(Map<String, dynamic> json) {
    traitType = json['trait_type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trait_type'] = this.traitType;
    data['value'] = this.value;
    return data;
  }
}