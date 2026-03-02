import 'package:json_annotation/json_annotation.dart';

part 'game_event.g.dart';

@JsonSerializable()
class GameEvent {
  final int id;
  final String name;
  final String description;
  final Map<String, dynamic> effect;
  @JsonKey(name: 'event_type')
  final String eventType;

  GameEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.effect,
    required this.eventType,
  });

  factory GameEvent.fromJson(Map<String, dynamic> json) =>
      _$GameEventFromJson(json);
  Map<String, dynamic> toJson() => _$GameEventToJson(this);
}
