import '../models/goal.dart';

class GoalsData {
  static List<GameGoal> getGoalsForMonth(int month) {
    switch (month) {
      case 1:
        return [
          const GameGoal(title: 'Б/у Смартфон', cost: 5000, pointsReward: 30, monthlyContribution: 5000),
          const GameGoal(title: 'Наушники', cost: 7000, pointsReward: 45, monthlyContribution: 7000),
          const GameGoal(title: 'Планшет', cost: 12000, pointsReward: 90, monthlyContribution: 12000),
        ];
      case 2:
        return [
          const GameGoal(title: 'Умные часы', cost: 8000, pointsReward: 60, monthlyContribution: 8000),
          const GameGoal(title: 'Брендовая одежда', cost: 12000, pointsReward: 90, monthlyContribution: 12000),
          const GameGoal(title: 'Робот-пылесос', cost: 18000, pointsReward: 140, monthlyContribution: 18000),
        ];
      case 3:
        return [
          const GameGoal(title: 'Электросамокат', cost: 15000, pointsReward: 110, monthlyContribution: 15000),
          const GameGoal(title: 'Игровая приставка', cost: 25000, pointsReward: 190, monthlyContribution: 25000),
          const GameGoal(title: 'Новый смартфон', cost: 35000, pointsReward: 270, monthlyContribution: 35000),
        ];
      case 4:
        return [
          const GameGoal(title: 'Курсы языка', cost: 25000, pointsReward: 190, monthlyContribution: 25000),
          const GameGoal(title: 'Холодильник', cost: 40000, pointsReward: 300, monthlyContribution: 40000),
          const GameGoal(title: 'Ноутбук', cost: 60000, pointsReward: 450, monthlyContribution: 60000),
        ];
      case 5:
        return [
          const GameGoal(title: 'Телевизор', cost: 40000, pointsReward: 300, monthlyContribution: 40000),
          const GameGoal(title: 'Путевка на выходные', cost: 60000, pointsReward: 450, monthlyContribution: 60000),
          const GameGoal(title: 'Мощный ПК', cost: 85000, pointsReward: 650, monthlyContribution: 85000),
        ];
      case 6:
        return [
          const GameGoal(title: 'Обновление гардероба', cost: 60000, pointsReward: 450, monthlyContribution: 60000),
          const GameGoal(title: 'Поездка на море', cost: 85000, pointsReward: 650, monthlyContribution: 85000),
          const GameGoal(title: 'Дизайнерский ремонт комнаты', cost: 120000, pointsReward: 900, monthlyContribution: 120000),
        ];
      case 7:
        return [
          const GameGoal(title: 'Домашний кинотеатр', cost: 85000, pointsReward: 650, monthlyContribution: 85000),
          const GameGoal(title: 'Обустройство студии', cost: 120000, pointsReward: 900, monthlyContribution: 120000),
          const GameGoal(title: 'Первоначальный взнос за авто', cost: 160000, pointsReward: 1200, monthlyContribution: 160000),
        ];
      case 8:
        return [
          const GameGoal(title: 'Дорогая мебель', cost: 120000, pointsReward: 900, monthlyContribution: 120000),
          const GameGoal(title: 'Подержанное авто', cost: 160000, pointsReward: 1200, monthlyContribution: 160000),
          const GameGoal(title: 'Поездка в Азию', cost: 220000, pointsReward: 1650, monthlyContribution: 220000),
        ];
      case 9:
        return [
          const GameGoal(title: 'Инвестиционный портфель', cost: 160000, pointsReward: 1200, monthlyContribution: 160000),
          const GameGoal(title: 'Кастомный мотоцикл', cost: 220000, pointsReward: 1650, monthlyContribution: 220000),
          const GameGoal(title: 'Свой проект / Стартап', cost: 300000, pointsReward: 2250, monthlyContribution: 300000),
        ];
      case 10:
        return [
          const GameGoal(title: 'Вклад в банк', cost: 220000, pointsReward: 1650, monthlyContribution: 220000),
          const GameGoal(title: 'Ремонт всей квартиры', cost: 300000, pointsReward: 2250, monthlyContribution: 300000),
          const GameGoal(title: 'Премиум автомобиль', cost: 450000, pointsReward: 3350, monthlyContribution: 450000),
        ];
      case 11:
        return [
          const GameGoal(title: 'Кругосветное путешествие', cost: 300000, pointsReward: 2250, monthlyContribution: 300000),
          const GameGoal(title: 'Покупка участка', cost: 450000, pointsReward: 3350, monthlyContribution: 450000),
          const GameGoal(title: 'Автомобиль из салона', cost: 600000, pointsReward: 4500, monthlyContribution: 600000),
        ];
      case 12:
        return [
          const GameGoal(title: 'Погашение кредита семьи', cost: 450000, pointsReward: 3350, monthlyContribution: 450000),
          const GameGoal(title: 'Открытие своего бизнеса', cost: 600000, pointsReward: 4500, monthlyContribution: 600000),
          const GameGoal(title: 'Строительство дома', cost: 800000, pointsReward: 6000, monthlyContribution: 800000),
        ];
      case 13: // Boss level
      default:
        return [
          const GameGoal(title: 'Взнос за ипотеку', cost: 1000000, pointsReward: 7500, monthlyContribution: 1000000),
          const GameGoal(title: 'Покупка студии', cost: 1200000, pointsReward: 9000, monthlyContribution: 1200000),
          const GameGoal(title: 'Своя квартира-мечта (Босс)', cost: 1500000, pointsReward: 11000, monthlyContribution: 1500000),
        ];
    }
  }
}
