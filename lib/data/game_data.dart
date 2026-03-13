import '../models/job.dart';
import '../models/goal.dart';
import '../models/event.dart';
import '../models/merch_item.dart';
import '../models/course.dart';
import 'jobs_data.dart';
import 'courses_data.dart';
import 'goals_data.dart';
import 'events_data.dart';
import 'merch_data.dart';

class GameData {
  // Dynamic rent based on job tier
  static double getRent(int jobTier) {
    switch (jobTier) {
      case 1: return 7000;
      case 2: return 9000;
      case 3: return 12000;
      case 4: return 16000;
      case 5: return 22000;
      case 6: return 30000;
      default: return 7000;
    }
  }

  static const double monthlyGoal = 10000;

  static List<Job> get allJobs => JobsData.allJobs;
  static List<Course> get availableCourses => CoursesData.availableCourses;
  static List<GameGoal> getGoalsForMonth(int month) => GoalsData.getGoalsForMonth(month);
  static List<MerchItem> get shopItems => MerchData.shopItems;
  
  static List<GameEvent> get allEvents => [
        ...EventsData.randomEvents,
        ...EventsData.quizEvents,
      ];

  static const List<int> quizDays = [9, 19, 29];
}
