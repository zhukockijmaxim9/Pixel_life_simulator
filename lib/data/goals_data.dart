import '../models/goal.dart';

class GoalsData {
  static List<GameGoal> getGoalsForMonth(int month) {
    switch (month) {
      case 1:
        return [
          const GameGoal(title: 'Б/у Смартфон', cost: 8000, pointsReward: 30, monthlyContribution: 8000, icon: '📱'),
          const GameGoal(title: 'Наушники', cost: 11000, pointsReward: 45, monthlyContribution: 11000, icon: '🎧'),
          const GameGoal(title: 'Планшет', cost: 18000, pointsReward: 90, monthlyContribution: 18000, icon: '📟'),
        ];
      case 2:
        return [
          const GameGoal(title: 'Умные часы', cost: 12000, pointsReward: 60, monthlyContribution: 12000, icon: '⌚'),
          const GameGoal(title: 'Брендовая одежда', cost: 18000, pointsReward: 90, monthlyContribution: 18000, icon: '👕'),
          const GameGoal(title: 'Робот-пылесос', cost: 27000, pointsReward: 140, monthlyContribution: 27000, icon: '🤖'),
        ];
      case 3:
        return [
          const GameGoal(title: 'Электросамокат', cost: 25000, pointsReward: 110, monthlyContribution: 25000, icon: '🛴'),
          const GameGoal(title: 'Игровая приставка', cost: 40000, pointsReward: 190, monthlyContribution: 40000, icon: '🎮'),
          const GameGoal(title: 'Новый смартфон', cost: 55000, pointsReward: 270, monthlyContribution: 55000, icon: '📱'),
        ];
      case 4:
        return [
          const GameGoal(title: 'Курсы языка', cost: 40000, pointsReward: 190, monthlyContribution: 40000, icon: '🇬🇧'),
          const GameGoal(title: 'Холодильник', cost: 65000, pointsReward: 300, monthlyContribution: 65000, icon: '❄️'),
          const GameGoal(title: 'Ноутбук', cost: 90000, pointsReward: 450, monthlyContribution: 90000, icon: '💻'),
        ];
      case 5:
        return [
          const GameGoal(title: 'Телевизор', cost: 65000, pointsReward: 300, monthlyContribution: 65000, icon: '📺'),
          const GameGoal(title: 'Путевка на выходные', cost: 90000, pointsReward: 450, monthlyContribution: 90000, icon: '🏨'),
          const GameGoal(title: 'Мощный ПК', cost: 130000, pointsReward: 650, monthlyContribution: 130000, icon: '🖥️'),
        ];
      case 6:
        return [
          const GameGoal(title: 'Обновление гардероба', cost: 90000, pointsReward: 450, monthlyContribution: 90000, icon: '👔'),
          const GameGoal(title: 'Поездка на море', cost: 130000, pointsReward: 650, monthlyContribution: 130000, icon: '🌊'),
          const GameGoal(title: 'Дизайнерский ремонт комнаты', cost: 180000, pointsReward: 900, monthlyContribution: 180000, icon: '🎨'),
        ];
      case 7:
        return [
          const GameGoal(title: 'Домашний кинотеатр', cost: 130000, pointsReward: 650, monthlyContribution: 130000, icon: '📽️'),
          const GameGoal(title: 'Обустройство студии', cost: 180000, pointsReward: 900, monthlyContribution: 180000, icon: '🎹'),
          const GameGoal(title: 'Первоначальный взнос за авто', cost: 250000, pointsReward: 1200, monthlyContribution: 250000, icon: '🔑'),
        ];
      case 8:
        return [
          const GameGoal(title: 'Дорогая мебель', cost: 180000, pointsReward: 900, monthlyContribution: 180000, icon: '🛋️'),
          const GameGoal(title: 'Подержанное авто', cost: 250000, pointsReward: 1200, monthlyContribution: 250000, icon: '🚗'),
          const GameGoal(title: 'Поездка в Азию', cost: 350000, pointsReward: 1650, monthlyContribution: 350000, icon: '🏮'),
        ];
      case 9:
        return [
          const GameGoal(title: 'Инвестиционный портфель', cost: 250000, pointsReward: 1200, monthlyContribution: 250000, icon: '📈'),
          const GameGoal(title: 'Кастомный мотоцикл', cost: 350000, pointsReward: 1650, monthlyContribution: 350000, icon: '🏍️'),
          const GameGoal(title: 'Свой проект / Стартап', cost: 450000, pointsReward: 2250, monthlyContribution: 450000, icon: '🚀'),
        ];
      case 10:
        return [
          const GameGoal(title: 'Вклад в банк', cost: 350000, pointsReward: 1650, monthlyContribution: 350000, icon: '🏦'),
          const GameGoal(title: 'Ремонт всей квартиры', cost: 450000, pointsReward: 2250, monthlyContribution: 450000, icon: '🛠️'),
          const GameGoal(title: 'Премиум автомобиль', cost: 700000, pointsReward: 3350, monthlyContribution: 700000, icon: '🏎️'),
        ];
      case 11:
        return [
          const GameGoal(title: 'Кругосветное путешествие', cost: 450000, pointsReward: 2250, monthlyContribution: 450000, icon: '🌍'),
          const GameGoal(title: 'Покупка участка', cost: 700000, pointsReward: 3350, monthlyContribution: 700000, icon: '🏡'),
          const GameGoal(title: 'Автомобиль из салона', cost: 900000, pointsReward: 4500, monthlyContribution: 900000, icon: '🚘'),
        ];
      case 12:
        return [
          const GameGoal(title: 'Погашение кредита семьи', cost: 700000, pointsReward: 3350, monthlyContribution: 700000, icon: '🤝'),
          const GameGoal(title: 'Открытие своего бизнеса', cost: 900000, pointsReward: 4500, monthlyContribution: 900000, icon: '🏬'),
          const GameGoal(title: 'Строительство дома', cost: 1200000, pointsReward: 6000, monthlyContribution: 1200000, icon: '🏰'),
        ];
      case 13: // Boss level
      default:
        return [
          const GameGoal(title: 'Взнос за ипотеку', cost: 1500000, pointsReward: 7500, monthlyContribution: 1500000, icon: '🏗️'),
          const GameGoal(title: 'Покупка студии', cost: 1800000, pointsReward: 9000, monthlyContribution: 1800000, icon: '🌇'),
          const GameGoal(title: 'Своя квартира-мечта (Босс)', cost: 2500000, pointsReward: 11000, monthlyContribution: 2500000, icon: '🏙️'),
        ];
    }
  }
}
