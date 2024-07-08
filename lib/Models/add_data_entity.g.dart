// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddEntity _$AddEntityFromJson(Map<String, dynamic> json) => AddEntity(
      dateTime: (json['dateTime'] as Timestamp?)?.toDate(),
      taskname: json['taskname'] as String?,
      image: json['image'] as String?,
      addId: json['addId'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      userID: json['userID'] as String?,
    );

Map<String, dynamic> _$AddEntityToJson(AddEntity instance) => <String, dynamic>{
      'taskname': instance.taskname,
      'image': instance.image,
      'addId': instance.addId,
      'userID': instance.userID,
      'isCompleted': instance.isCompleted,
      'dateTime': instance.dateTime,
    };
