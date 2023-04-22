import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

/// {@template comment}
/// Modelo de datos para un comentario
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class Comment extends Equatable {
  /// {@macro comment}
  const Comment({
    required this.id,
    required this.title,
    required this.content,
    required this.registerDate,
    required this.idMovie,
    required this.idSentiment,
  });

  /// Crea una instancia de [Comment] desde un [Map]
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  /// Crea un [Map] a partir de una instancia de [Comment]
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  /// Id del comentario
  final int id;

  /// Titulo del comentario
  final String title;

  /// Contenido del comentario
  final String content;

  /// Fecha de registro del comentario
  final String registerDate;

  /// Id de la pelicula
  final String idMovie;

  /// Id del sentimiento
  final int idSentiment;

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        registerDate,
        idMovie,
        idSentiment,
      ];
}
