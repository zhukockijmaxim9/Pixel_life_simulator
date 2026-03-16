import '../../models/job.dart';
import '../../data/game_data.dart';

class CareerManager {
  Job? selectedJob;
  List<String> completedCourses = [];
  List<String> jobHistory = [];
  bool eligibleForPromotion = false;

  void reset(Job? job) {
    selectedJob = job;
    completedCourses = [];
    jobHistory = (job != null) ? [job.title] : [];
    eligibleForPromotion = false;
  }

  void addJobToHistory(Job job) {
    if (!jobHistory.contains(job.title)) {
      jobHistory.add(job.title);
    }
  }

  List<Job> getAvailableJobs() {
    if (selectedJob == null && jobHistory.isEmpty) {
      return GameData.allJobs.where((j) => j.tier == 1).toList();
    }

    List<Job> available = [];
    for (var job in GameData.allJobs) {
      if (job.requiredCourse != null && job.tier == 2) {
        if (completedCourses.contains(job.requiredCourse)) {
          available.add(job);
        }
        continue;
      }

      if (job.requiredPreviousJobs.isNotEmpty) {
        bool hasExp = job.requiredPreviousJobs.any((prev) => jobHistory.contains(prev));
        if (hasExp) {
          if (selectedJob != null && job.tier > selectedJob!.tier) {
            if (eligibleForPromotion) {
              available.add(job);
            }
          } else {
            available.add(job);
          }
        }
      }

      if (job.tier == 1) {
        available.add(job);
      }
    }

    // Filter out previous branch jobs
    Set<String> jobsToHide = {};
    for (var jobTitle in jobHistory) {
      try {
        final jobInfo = GameData.allJobs.firstWhere((j) => j.title == jobTitle);
        jobsToHide.addAll(jobInfo.requiredPreviousJobs);
      } catch (_) {}
    }
    for (var job in available) {
      jobsToHide.addAll(job.requiredPreviousJobs);
    }

    available.removeWhere((j) => jobsToHide.contains(j.title));

    final sortedAvailable = available.toSet().toList();
    sortedAvailable.sort((a, b) => b.tier.compareTo(a.tier));

    return sortedAvailable;
  }

  bool hasNewOpportunities() {
    if (selectedJob == null) return true;
    final currentTier = selectedJob!.tier;
    final available = getAvailableJobs();
    return available.any((job) =>
        job.tier > currentTier ||
        (job.requiredCourse != null && !jobHistory.contains(job.title)));
  }

  Map<String, dynamic> toJson() => {
        'selectedJob': selectedJob?.toJson(),
        'completedCourses': completedCourses,
        'jobHistory': jobHistory,
        'eligibleForPromotion': eligibleForPromotion,
      };

  void fromJson(Map<String, dynamic> json) {
    selectedJob = json['selectedJob'] != null ? Job.fromJson(json['selectedJob']) : null;
    completedCourses = List<String>.from(json['completedCourses'] ?? []);
    jobHistory = List<String>.from(json['jobHistory'] ?? []);
    eligibleForPromotion = json['eligibleForPromotion'] ?? false;
  }
}
