class Job {
  final String title;
  final double salary;
  final String icon;
  final int tier;
  final String? requiredCourse;
  final List<String> requiredPreviousJobs;

  const Job({
    required this.title,
    required this.salary,
    required this.icon,
    this.tier = 1,
    this.requiredCourse,
    this.requiredPreviousJobs = const [],
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'salary': salary,
        'icon': icon,
        'tier': tier,
        'requiredCourse': requiredCourse,
        'requiredPreviousJobs': requiredPreviousJobs,
      };

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        title: json['title'],
        salary: json['salary'].toDouble(),
        icon: json['icon'],
        tier: json['tier'] ?? 1,
        requiredCourse: json['requiredCourse'],
        requiredPreviousJobs: List<String>.from(json['requiredPreviousJobs'] ?? []),
      );
}
