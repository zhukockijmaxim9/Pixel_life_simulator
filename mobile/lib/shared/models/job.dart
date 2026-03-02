import 'package:json_annotation/json_annotation.dart';

part 'job.g.dart';

@JsonSerializable()
class Job {
  final int id;
  final String name;
  final String? description;
  final double salary;

  Job({
    required this.id,
    required this.name,
    this.description,
    required this.salary,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
