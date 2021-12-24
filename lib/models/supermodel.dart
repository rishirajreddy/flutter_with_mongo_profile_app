import 'package:blog_post_app/models/postmodel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supermodel.g.dart';

@JsonSerializable()
class SuperModel {
  List<PostModel> data;
  SuperModel(this.data);

  factory SuperModel.fromJson(Map<String, dynamic> json) =>
      _$SuperModelFromJson(json);
  Map<String, dynamic> toJson() => _$SuperModelToJson(this);
}
