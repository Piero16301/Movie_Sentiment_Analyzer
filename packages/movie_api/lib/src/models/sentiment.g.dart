// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentiment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sentiment _$SentimentFromJson(Map<String, dynamic> json) {
  return Sentiment(
    id: json['id'] as int,
    sentiment: json['sentiment'] as String,
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$SentimentToJson(Sentiment instance) => <String, dynamic>{
      'id': instance.id,
      'sentiment': instance.sentiment,
      'count': instance.count,
    };
