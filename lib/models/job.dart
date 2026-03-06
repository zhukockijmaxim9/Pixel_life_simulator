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
}
