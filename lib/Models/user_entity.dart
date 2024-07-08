import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class UserEntity {
  String? name;
  String? email;
  String? userId;
  String? profileImage;

  UserEntity({
    this.email,
    this.name,
    this.userId,
    this.profileImage,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  static CollectionReference<UserEntity> collection() {
    return FirebaseFirestore.instance.collection("UserEntity").withConverter(
        fromFirestore: (snapshot, _) => UserEntity.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson());
  }

  static DocumentReference<UserEntity> doc({required String userId}) {
    return FirebaseFirestore.instance.doc("UserEntity/$userId").withConverter(
        fromFirestore: (snapshot, _) => UserEntity.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson());
  }
}
