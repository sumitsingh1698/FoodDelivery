class CampusResponse {
  String name;
  University university;
  String slug;

  CampusResponse({this.name, this.university, this.slug});

  CampusResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    university = json['university'] != null
        ? new University.fromJson(json['university'])
        : null;
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.university != null) {
      data['university'] = this.university.toJson();
    }
    data['slug'] = this.slug;
    return data;
  }
}

class University {
  String name;
  String slug;
  int id;

  University({this.name, this.slug, this.id});

  University.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['id'] = this.id;
    return data;
  }
}
