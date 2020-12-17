import 'package:flutter/material.dart';

class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Comment({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  //map data from json
  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        postId: json['postId'],
        id: json['id'],
        name: json['name'],
        email: json['email'],
        body: json['body'],
      );


  //map object to string json
  Map<String, dynamic> toJson() => {
        'postId': postId,
        'id': id,
        'name': name,
        'email': email,
        'body': body,
      };
}
