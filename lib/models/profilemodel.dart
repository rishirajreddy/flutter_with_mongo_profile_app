import 'package:json_annotation/json_annotation.dart';

part 'profilemodel.g.dart';

@JsonSerializable()
class ProfileModel {
  String name = "";
  String username = "";
  String profession = "";
  String bio = "";

  ProfileModel(this.name, this.profession, this.bio, this.username);

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
