import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sentiment.g.dart';

/// {@template sentiment}
/// Modelo de datos para un sentimiento
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class Sentiment extends Equatable {
  /// {@macro sentiment}
  const Sentiment({
    required this.id,
    required this.sentiment,
    required this.count,
  });

  /// Crea una instancia de [Sentiment] desde un [Map]
  factory Sentiment.fromJson(Map<String, dynamic> json) =>
      _$SentimentFromJson(json);

  /// Crea un [Map] a partir de una instancia de [Sentiment]
  Map<String, dynamic> toJson() => _$SentimentToJson(this);

  /// Id del sentimiento
  final int id;

  /// Sentimiento
  final String sentiment;

  /// Cantidad de comentarios con este sentimiento
  final int count;

  @override
  List<Object?> get props => [
        id,
        sentiment,
        count,
      ];
}
