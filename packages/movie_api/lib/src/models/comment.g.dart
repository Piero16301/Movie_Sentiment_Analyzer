// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    registerDate: json['registerDate'] as String,
    idMovie: json['idMovie'] as String,
    idSentiment: json['idSentiment'] as int,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'registerDate': instance.registerDate,
      'idMovie': instance.idMovie,
      'idSentiment': instance.idSentiment,
    };
