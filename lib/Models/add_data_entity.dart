import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'add_data_entity.g.dart';

@JsonSerializable()
class AddEntity {
  String? taskname;
  String? image;
  String? addId;
  String? userID;
  bool isCompleted;
  DateTime? dateTime;

  AddEntity(
      {this.dateTime,
      this.taskname,
      this.image,
      this.addId,
      this.isCompleted = false,
      this.userID});

  // From JSON
  factory AddEntity.fromJson(Map<String, dynamic> json) =>
      _$AddEntityFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$AddEntityToJson(this);

  static CollectionReference<AddEntity> collection() {
    return FirebaseFirestore.instance.collection("AddEntity").withConverter(
        fromFirestore: (snapshot, _) => AddEntity.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson());
  }

  static DocumentReference<AddEntity> doc({required String addId}) {
    return FirebaseFirestore.instance.doc("AddEntity/$addId").withConverter(
        fromFirestore: (snapshot, _) => AddEntity.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson());
  }
}
