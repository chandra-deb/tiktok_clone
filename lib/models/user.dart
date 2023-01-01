import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String name;
  final String profilePhoto;
  final String email;
  final String uid;

  User({
    required this.name,
    required this.profilePhoto,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePhoto': profilePhoto,
      'email': email,
      'uid': uid,
    };
  }

  factory User.fromMap(DocumentSnapshot documentSnapshot) {
    var map = documentSnapshot.data() as Map<String, dynamic>;
    return User(
      name: map['name'] as String,
      profilePhoto: map['profilePhoto'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
    );
  }
}
