// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      json['username'] as String,
      json['title'] as String,
      json['body'] as String,
      json['_id'] as String,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'username': instance.username,
      'title': instance.title,
      'body': instance.body,
      '_id': instance.id,
    };
