abstract class BaseModel {
  BaseModel({
    Map<String, dynamic>? json,
  }) {
    if (json != null) {
      fromJson(json);
    }
  }
  void fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}
