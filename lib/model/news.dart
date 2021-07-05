import 'package:eigital_exam/model/base_model.dart';

class News extends BaseModel {
  News({
    this.type='',
    this.name='',
    this.url='',
    this.image='',
    this.description='',
    this.datePublished='',
    Map<String, dynamic>? json,
  }):super(json: json);

  String type;
  String name;
  String url;
  String image;
  String description;
  String datePublished;

  @override
  void fromJson(Map<String, dynamic> json) {
    type = json['_type']??'';
    name = json['name']??'';
    url = json['url']??'';
    description = json['description']??'';
    datePublished = json['datePublished']??'';
    image = json['image']?['thumbnail']?['contentUrl']??'';
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['_type'] = type;
    json['name'] = name;
    json['url'] = url;
    json['imager'] = image;
    json['description'] = description;
    json['datePublished'] = datePublished;
    return json;
  }
}