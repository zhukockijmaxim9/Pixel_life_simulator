import 'package:json_annotation/json_annotation.dart';

part 'education_card.g.dart';

@JsonSerializable()
class EducationCard {
  final int id;
  final String question;
  final List<String> options;
  @JsonKey(name: 'correct_answer')
  final String correctAnswer;
  final String explanation;
  final String difficulty;

  EducationCard({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.difficulty,
  });

  factory EducationCard.fromJson(Map<String, dynamic> json) =>
      _$EducationCardFromJson(json);
  Map<String, dynamic> toJson() => _$EducationCardToJson(this);
}
