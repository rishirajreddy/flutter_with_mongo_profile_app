import 'package:json_annotation/json_annotation.dart';

part 'postmodel.g.dart';

@JsonSerializable()
class PostModel {
  String username = "";
  String title = "";
  String body = "";
  @JsonKey(name: "_id")
  String id = "";

  PostModel(this.username, this.title, this.body, this.id);

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
