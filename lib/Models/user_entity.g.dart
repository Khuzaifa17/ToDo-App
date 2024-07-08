// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      email: json['email'] as String?,
      name: json['name'] as String?,
      userId: json['userId'] as String?,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'userId': instance.userId,
      'profileImage': instance.profileImage,
    };
