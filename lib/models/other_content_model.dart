class OtherContentModel {
  String title;
  List<Levelone> levelone;
  int id;
  String desc;

  OtherContentModel({this.title, this.levelone, this.id, this.desc});

  OtherContentModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['levelone'] != null) {
      levelone = new List<Levelone>();
      json['levelone'].forEach((v) {
        levelone.add(new Levelone.fromJson(v));
      });
    }
    id = json['id'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.levelone != null) {
      data['levelone'] = this.levelone.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['desc'] = this.desc;
    return data;
  }
}

class Levelone {
  String title;
  String content;
  int id;

  Levelone({this.title, this.content, this.id});

  Levelone.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['id'] = this.id;
    return data;
  }
}
