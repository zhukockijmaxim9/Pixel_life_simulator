import '../models/job.dart';
import '../models/goal.dart';
import '../models/event.dart';
import '../models/merch_item.dart';
import '../models/enums.dart';

class GameData {
  static const double RENT = 7000;
  static const double MONTHLY_GOAL = 10000;

  static final List<Job> tier1Jobs = [
    const Job(title: 'Доставщик', salary: 45000, icon: '🚲', tier: 1),
    const Job(title: 'Кассир', salary: 43000, icon: '🏪', tier: 1),
    const Job(title: 'Работник фастфуда', salary: 42000, icon: '🍔', tier: 1),
    const Job(title: 'Работник ПВЗ', salary: 44000, icon: '📦', tier: 1),
  ];

  static final List<Job> tier2Jobs = [
    const Job(
      title: 'Официант',
      salary: 38000,
      icon: '☕',
      tier: 2,
      requiredPreviousJobs: ['Работник фастфуда'],
    ),
    const Job(
      title: 'Механик',
      salary: 40000,
      icon: '🔧',
      tier: 2,
      requiredPreviousJobs: ['Доставщик'],
    ),
    const Job(
      title: 'Продавец-консультант',
      salary: 35000,
      icon: '🛍️',
      tier: 2,
      requiredPreviousJobs: ['Кассир', 'Работник ПВЗ'],
    ),
    const Job(
      title: 'Бариста',
      salary: 42000,
      icon: '☕',
      tier: 2,
      requiredCourse: 'Бариста',
    ),
    const Job(
      title: 'Бухгалтер',
      salary: 50000,
      icon: '👩‍💼',
      tier: 2,
      requiredCourse: 'Бухгалтер',
    ),
  ];

  static final List<GameGoal> availableGoals = [
    const GameGoal(
      title: 'Смартфон',
      cost: 50000,
      pointsReward: 500,
      monthlyContribution: 5000,
    ),
    const GameGoal(
      title: 'Консоль',
      cost: 70000,
      pointsReward: 750,
      monthlyContribution: 7000,
    ),
    const GameGoal(
      title: 'Ноутбук',
      cost: 120000,
      pointsReward: 1500,
      monthlyContribution: 10000,
    ),
  ];

  static final List<MerchItem> shopItems = [
    const MerchItem(name: 'Худи Neoflex', price: 500, icon: '🧥'),
    const MerchItem(name: 'Кепка', price: 200, icon: '🧢'),
    const MerchItem(name: 'Кружка', price: 100, icon: '☕'),
  ];

  static final List<GameEvent> allEvents = [
    const GameEvent(
      id: 'phone_repair',
      title: 'Сломался экран телефона',
      description:
          'Неудачное падение! Экран вдребезги. Придется раскошелиться на ремонт.',
      type: EventType.random,
      moneyImpact: -1000,
      moodImpact: -10,
      isPositive: false,
    ),
    const GameEvent(
      id: 'lost_transport',
      title: 'Опоздал на транспорт',
      description: 'Автобус ушёл прямо из-под носа. Пришлось брать такси.',
      type: EventType.random,
      moneyImpact: -300,
      moodImpact: -5,
      isPositive: false,
    ),
    const GameEvent(
      id: 'wallet_lost',
      title: 'Потерял кошелёк',
      description: 'Кошелёк выпал из кармана в толпе. Деньги не вернуть.',
      type: EventType.random,
      moneyImpact: -1000,
      moodImpact: -15,
      isPositive: false,
    ),
    const GameEvent(
      id: 'found_money',
      title: 'Нашел 500 рублей',
      description: 'Мелочь, а приятно! Деньги валялись прямо на тротуаре.',
      type: EventType.random,
      moneyImpact: 500,
      moodImpact: 5,
      isPositive: true,
    ),
    const GameEvent(
      id: 'found_coupon',
      title: 'Нашёл купон на скидку',
      description: 'Бесплатный кофе по акции — отличное начало дня!',
      type: EventType.random,
      moneyImpact: 0,
      moodImpact: 8,
      isPositive: true,
    ),
    const GameEvent(
      id: 'pizza_friends',
      title: 'Друзья зовут в пиццерию',
      description:
          'Отличный вечер с друзьями поможет расслабиться, но стоит денег.',
      type: EventType.voluntary,
      moneyImpact: -1500,
      moodImpact: 15,
    ),
    const GameEvent(
      id: 'cinema_night',
      title: 'Поход в кино',
      description: 'Новый блокбастер вышел на экраны! Идем?',
      type: EventType.voluntary,
      moneyImpact: -1000,
      moodImpact: 10,
    ),
    const GameEvent(
      id: 'overtime_offer',
      title: 'Сверхурочная работа',
      description:
          'Начальник просит задержаться. Платят неплохо, но сил совсем не останется.',
      type: EventType.voluntary,
      moneyImpact: 2000,
      moodImpact: -15,
    ),
    const GameEvent(
      id: 'help_colleague',
      title: 'Помочь коллеге',
      description:
          'Коллега просит помочь с задачей. Это займёт время, но улучшит отношения.',
      type: EventType.voluntary,
      moneyImpact: 0,
      moodImpact: 8,
    ),
    const GameEvent(
      id: 'street_food',
      title: 'Фестиваль стрит-фуда',
      description: 'В городе проходит фестиваль еды. Вкусно, но не бесплатно!',
      type: EventType.voluntary,
      moneyImpact: -400,
      moodImpact: 5,
    ),
    const GameEvent(
      id: 'sale_event',
      title: 'Распродажа!',
      description: 'Большие скидки в любимом магазине. Может стоит зайти?',
      type: EventType.voluntary,
      moneyImpact: -1500,
      moodImpact: 10,
    ),
    const GameEvent(
      id: 'quiz_safe_cushion',
      title: 'Квиз от Неофлекс',
      description: 'Что такое финансовая подушка безопасности?',
      type: EventType.quiz,
      options: [
        'Деньги на новый iPhone',
        'Запас денег на 3-6 месяцев жизни',
        'Кредитная карта с лимитом',
        'Мягкая подушка с купюрами',
      ],
      correctAnswerIndex: 1,
      moneyImpact: 2000,
      educationalTip:
          'Финансовая подушка — это резерв на случай потери дохода.',
    ),
    const GameEvent(
      id: 'quiz_inflation',
      title: 'Квиз: Инфляция',
      description: 'Как инфляция влияет на ваши сбережения?',
      type: EventType.quiz,
      options: [
        'Увеличивает их стоимость',
        'Снижает их покупательскую способность',
        'Никак не влияет',
        'Делает цены ниже',
      ],
      correctAnswerIndex: 1,
      moneyImpact: 2000,
      educationalTip: 'Инфляция — это процесс обесценивания денег.',
    ),
    const GameEvent(
      id: 'quiz_budget',
      title: 'Квиз: Бюджет',
      description: 'Какой главный принцип ведения личного бюджета?',
      type: EventType.quiz,
      options: [
        'Тратить всё что заработал',
        'Записывать доходы и расходы',
        'Копить абсолютно все деньги',
        'Брать кредиты на всё',
      ],
      correctAnswerIndex: 1,
      moneyImpact: 2000,
      educationalTip: 'Ведение бюджета — основа финансовой грамотности.',
    ),
    const GameEvent(
      id: 'quiz_savings',
      title: 'Квиз: Сбережения',
      description: 'Зачем нужны сбережения?',
      type: EventType.quiz,
      options: [
        'Чтобы деньги лежали без дела',
        'Для покупки ненужных вещей',
        'Для финансовой безопасности и крупных покупок',
        'Их не нужно иметь',
      ],
      correctAnswerIndex: 2,
      moneyImpact: 2000,
      educationalTip:
          'Сбережения помогают достигать финансовых целей и защищают от непредвиденных расходов.',
    ),
  ];

  static const GameEvent rentEvent = GameEvent(
    id: 'rent_payment',
    title: 'Оплата аренды',
    description: 'Пришло время оплатить аренду жилья.',
    type: EventType.rent,
    moneyImpact: -RENT,
  );

  static const GameEvent courseEvent = GameEvent(
    id: 'course_offer',
    title: 'Предложение записаться на курсы',
    description:
        'Узнали про курсы повышения квалификации. Стоимость: 5000₽. Это откроет новые карьерные возможности!',
    type: EventType.course,
    moneyImpact: -5000,
    options: ['Курс Бариста', 'Курс Бухгалтера', 'Отказаться'],
  );

  static const List<int> quizDays = [9, 19, 29];
}
