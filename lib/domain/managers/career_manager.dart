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
    return available.toSet().toList();
  }

  bool hasNewOpportunities() {
    if (selectedJob == null) return true;
    final currentTier = selectedJob!.tier;
    final available = getAvailableJobs();
    return available.any((job) =>
        job.tier > currentTier ||
        (job.requiredCourse != null && !jobHistory.contains(job.title)));
  }
}
