// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    overview: json['overview'] as String? ?? '',
    posterPath: json['poster'] as String? ?? '',
    releaseYear: json['year'] as int? ?? 0,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'poster': instance.posterPath,
      'year': instance.releaseYear,
    };
