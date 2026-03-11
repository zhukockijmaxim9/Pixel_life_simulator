import '../models/course.dart';

class CoursesData {
  static final List<Course> availableCourses = [
    const Course(
      id: 'it',
      title: 'Программирование',
      cost: 50000,
      icon: '💻',
      description: 'Самая прибыльная ветка развития.',
    ),
    const Course(
      id: 'marketing',
      title: 'SMM и Маркетинг',
      cost: 30000,
      icon: '📱',
      description: 'Баланс зарплаты и доступности.',
    ),
    const Course(
      id: 'design',
      title: 'Дизайн',
      cost: 35000,
      icon: '🎨',
      description: 'Творческая ветка со стабильным ростом.',
    ),
    const Course(
      id: 'coffee',
      title: 'Кофейное дело',
      cost: 15000,
      icon: '☕',
      description: 'Возможность дорасти до бизнеса.',
    ),
  ];
}
