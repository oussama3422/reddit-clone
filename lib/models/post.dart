import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communtiyName;
  final String communityProfile;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commmentCount;
  final String username;
  final String uid;
  final String type;
  final DateTime createAt;
  final List<String> awards;
  Post({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.communtiyName,
    required this.communityProfile,
    required this.upvotes,
    required this.downvotes,
    required this.commmentCount,
    required this.username,
    required this.uid,
    required this.type,
    required this.createAt,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communtiyName,
    String? communityProfile,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commmentCount,
    String? username,
    String? uid,
    String? type,
    DateTime? createAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communtiyName: communtiyName ?? this.communtiyName,
      communityProfile: communityProfile ?? this.communityProfile,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commmentCount: commmentCount ?? this.commmentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createAt: createAt ?? this.createAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'communtiyName': communtiyName,
      'communityProfile': communityProfile,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commmentCount': commmentCount,
      'username': username,
      'uid': uid,
      'type': type,
      'createAt': createAt.toUtc().toIso8601String(),
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      link: map['link'],
      description: map['description'],
      communtiyName: map['communtiyName'],
      communityProfile: map['communityProfile'],
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      commmentCount: map['commmentCount']?.toInt(),
      username: map['username'],
      uid: map['uid'],
      type: map['type'],
      createAt: DateTime.parse(map['createAt']).toLocal(),
      awards: List<String>.from(map['awards']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, description: $description, communtiyName: $communtiyName, communityProfile: $communityProfile, upvotes: $upvotes, downvotes: $downvotes, commmentCount: $commmentCount, username: $username, uid: $uid, type: $type, createAt: $createAt, awards: $awards)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Post &&
      other.id == id &&
      other.title == title &&
      other.link == link &&
      other.description == description &&
      other.communtiyName == communtiyName &&
      other.communityProfile == communityProfile &&
      listEquals(other.upvotes, upvotes) &&
      listEquals(other.downvotes, downvotes) &&
      other.commmentCount == commmentCount &&
      other.username == username &&
      other.uid == uid &&
      other.type == type &&
      other.createAt == createAt &&
      listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      link.hashCode ^
      description.hashCode ^
      communtiyName.hashCode ^
      communityProfile.hashCode ^
      upvotes.hashCode ^
      downvotes.hashCode ^
      commmentCount.hashCode ^
      username.hashCode ^
      uid.hashCode ^
      type.hashCode ^
      createAt.hashCode ^
      awards.hashCode;
  }
}
