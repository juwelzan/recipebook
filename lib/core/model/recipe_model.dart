// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class RecipeModel extends Equatable {
  final int id;
  final String title;
  final String image;
  final String imageType;
  const RecipeModel({
    required this.id,
    required this.title,
    required this.image,
    required this.imageType,
  });

  @override
  List<Object> get props => [id, title, image, imageType];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'image': image,
      'imageType': imageType,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: int.parse(map['id'].toString()),
      title: map['title'] as String,
      image: map['image'] as String,
      imageType: map['imageType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeModel.fromJson(String source) =>
      RecipeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  RecipeModel copyWith({
    int? id,
    String? title,
    String? image,
    String? imageType,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      imageType: imageType ?? this.imageType,
    );
  }

  @override
  bool get stringify => true;
}
