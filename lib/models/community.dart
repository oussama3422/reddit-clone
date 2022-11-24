import 'dart:convert';

import 'package:flutter/foundation.dart';

class Community {



  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<String> membres;
  final List<String> mods;
  Community({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.membres,
    required this.mods,
  });


  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? membres,
    List<String>? mods,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      membres: membres ?? this.membres,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'membres': membres,
      'mods': mods,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      banner: map['banner']  ?? '',
      avatar: map['avatar'] ?? '',
      membres: List<String>.from(map['membres']),
      mods: List<String>.from(map['mods']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) => Community.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Community(id: $id, name: $name, banner: $banner, avatar: $avatar, membres: $membres, mods: $mods)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Community &&
      other.id == id &&
      other.name == name &&
      other.banner == banner &&
      other.avatar == avatar &&
      listEquals(other.membres, membres) &&
      listEquals(other.mods, mods);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      banner.hashCode ^
      avatar.hashCode ^
      membres.hashCode ^
      mods.hashCode;
  }
}
