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
  static const double RENT = 7000;
  static const double MONTHLY_GOAL = 10000;

  static List<Job> get allJobs => JobsData.allJobs;
  static List<Course> get availableCourses => CoursesData.availableCourses;
  static List<GameGoal> get availableGoals => GoalsData.availableGoals;
  static List<MerchItem> get shopItems => MerchData.shopItems;
  
  static List<GameEvent> get allEvents => [
        ...EventsData.randomEvents,
        ...EventsData.quizEvents,
      ];

  static GameEvent get rentEvent => EventsData.rentEvent;
  static const List<int> quizDays = [9, 19, 29];
}
