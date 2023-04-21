import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

/// {@template movie}
/// Modelo de datos para una película
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class Movie extends Equatable {
  /// {@macro movie}
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseYear,
  });

  /// Crea una instancia de [Movie] desde un [Map]
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  /// Crea un [Map] a partir de una instancia de [Movie]
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  /// Id de la película
  final String id;

  /// Titulo de la película
  final String title;

  /// Descripción de la película
  final String overview;

  /// URL de la imagen de la película
  final String posterPath;

  /// Fecha de lanzamiento de la película
  final int releaseYear;

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        releaseYear,
      ];
}
