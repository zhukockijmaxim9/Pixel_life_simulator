import '../models/job.dart';
import '../models/goal.dart';
import '../models/event.dart';
import '../models/merch_item.dart';
import '../models/enums.dart';
import '../models/course.dart';

class GameData {
  static const double RENT = 7000;
  static const double MONTHLY_GOAL = 10000;

  static final List<Job> allJobs = [
    // Branch 1: Logistics
    const Job(title: 'Доставщик', salary: 45000, icon: '🚲', tier: 1),
    const Job(title: 'Водитель-курьер', salary: 60000, icon: '🚗', tier: 2, requiredPreviousJobs: ['Доставщик']),
    const Job(title: 'Диспетчер доставки', salary: 80000, icon: '🎧', tier: 3, requiredPreviousJobs: ['Водитель-курьер']),
    const Job(title: 'Логист', salary: 110000, icon: '🗺️', tier: 4, requiredPreviousJobs: ['Диспетчер доставки']),
    const Job(title: 'Менеджер по логистике', salary: 150000, icon: '📊', tier: 5, requiredPreviousJobs: ['Логист']),
    const Job(title: 'Директор филиала', salary: 200000, icon: '🏢', tier: 6, requiredPreviousJobs: ['Менеджер по логистике']),

    // Branch 2: Retail
    const Job(title: 'Кассир', salary: 43000, icon: '🏪', tier: 1),
    const Job(title: 'Продавец-консультант', salary: 55000, icon: '🛍️', tier: 2, requiredPreviousJobs: ['Кассир']),
    const Job(title: 'Старший смены / Администратор', salary: 75000, icon: '📋', tier: 3, requiredPreviousJobs: ['Продавец-консультант']),
    const Job(title: 'Товаровед', salary: 100000, icon: '📦', tier: 4, requiredPreviousJobs: ['Старший смены / Администратор']),
    const Job(title: 'Заместитель директора магазина', salary: 140000, icon: '👔', tier: 5, requiredPreviousJobs: ['Товаровед']),
    const Job(title: 'Директор магазина', salary: 190000, icon: '👑', tier: 6, requiredPreviousJobs: ['Заместитель директора магазина']),

    // Branch 3: Public Catering
    const Job(title: 'Работник фастфуда', salary: 42000, icon: '🍔', tier: 1),
    const Job(title: 'Повар горячего цеха / Официант', salary: 55000, icon: '🍳', tier: 2, requiredPreviousJobs: ['Работник фастфуда']),
    const Job(title: 'Су-шеф / Менеджер зала', salary: 80000, icon: '👨‍🍳', tier: 3, requiredPreviousJobs: ['Повар горячего цеха / Официант']),
    const Job(title: 'Управляющий кафе', salary: 120000, icon: '☕', tier: 4, requiredPreviousJobs: ['Су-шеф / Менеджер зала']),
    const Job(title: 'Директор ресторана', salary: 160000, icon: '🍽️', tier: 5, requiredPreviousJobs: ['Управляющий кафе']),
    const Job(title: 'Территориальный управляющий', salary: 220000, icon: '🗺️', tier: 6, requiredPreviousJobs: ['Директор ресторана']),

    // Branch 4: E-commerce
    const Job(title: 'Работник ПВЗ', salary: 44000, icon: '📦', tier: 1),
    const Job(title: 'Кладовщик маркетплейса', salary: 58000, icon: '🛒', tier: 2, requiredPreviousJobs: ['Работник ПВЗ']),
    const Job(title: 'Начальник смены склада', salary: 85000, icon: '👷', tier: 3, requiredPreviousJobs: ['Кладовщик маркетплейса']),
    const Job(title: 'Менеджер маркетплейсов', salary: 115000, icon: '💻', tier: 4, requiredPreviousJobs: ['Начальник смены склада']),
    const Job(title: 'Аналитик продаж', salary: 155000, icon: '📈', tier: 5, requiredPreviousJobs: ['Менеджер маркетплейсов']),
    const Job(title: 'E-commerce директор', salary: 210000, icon: '🚀', tier: 6, requiredPreviousJobs: ['Аналитик продаж']),

    // Course Branch: Programming
    const Job(title: 'Junior-разработчик', salary: 80000, icon: '💻', tier: 2, requiredCourse: 'Программирование'),
    const Job(title: 'Middle-разработчик', salary: 120000, icon: '⚙️', tier: 3, requiredPreviousJobs: ['Junior-разработчик']),
    const Job(title: 'Senior-разработчик', salary: 180000, icon: '🧠', tier: 4, requiredPreviousJobs: ['Middle-разработчик']),
    const Job(title: 'Team Lead', salary: 250000, icon: '👥', tier: 5, requiredPreviousJobs: ['Senior-разработчик']),
    const Job(title: 'Технический директор (CTO)', salary: 350000, icon: '🚀', tier: 6, requiredPreviousJobs: ['Team Lead']),

    // Course Branch: SMM
    const Job(title: 'SMM-менеджер', salary: 60000, icon: '📱', tier: 2, requiredCourse: 'SMM и Маркетинг'),
    const Job(title: 'Таргетолог', salary: 90000, icon: '🎯', tier: 3, requiredPreviousJobs: ['SMM-менеджер']),
    const Job(title: 'Digital-маркетолог', salary: 130000, icon: '📊', tier: 4, requiredPreviousJobs: ['Таргетолог']),
    const Job(title: 'Руководитель отдела маркетинга', salary: 180000, icon: '📈', tier: 5, requiredPreviousJobs: ['Digital-маркетолог']),
    const Job(title: 'Директор по маркетингу (CMO)', salary: 250000, icon: '👑', tier: 6, requiredPreviousJobs: ['Руководитель отдела маркетинга']),

    // Course Branch: Design
    const Job(title: 'Junior-дизайнер', salary: 70000, icon: '🎨', tier: 2, requiredCourse: 'Дизайн'),
    const Job(title: 'UX/UI дизайнер', salary: 100000, icon: '🖱️', tier: 3, requiredPreviousJobs: ['Junior-дизайнер']),
    const Job(title: 'Senior-дизайнер', salary: 150000, icon: '🖥️', tier: 4, requiredPreviousJobs: ['UX/UI дизайнер']),
    const Job(title: 'Арт-директор', salary: 200000, icon: '🖼️', tier: 5, requiredPreviousJobs: ['Senior-дизайнер']),
    const Job(title: 'Директор по продукту', salary: 280000, icon: '💎', tier: 6, requiredPreviousJobs: ['Арт-директор']),

    // Course Branch: Coffee
    const Job(title: 'Бариста', salary: 55000, icon: '☕', tier: 2, requiredCourse: 'Кофейное дело'),
    const Job(title: 'Старший бариста', salary: 75000, icon: '📋', tier: 3, requiredPreviousJobs: ['Бариста']),
    const Job(title: 'Шеф-бариста', salary: 100000, icon: '🏆', tier: 4, requiredPreviousJobs: ['Старший бариста']),
    const Job(title: 'Обжарщик кофе', salary: 140000, icon: '🔥', tier: 5, requiredPreviousJobs: ['Шеф-бариста']),
    const Job(title: 'Владелец сети кофеен', salary: 200000, icon: '🏢', tier: 6, requiredPreviousJobs: ['Обжарщик кофе']),
  ];

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

  static final List<GameGoal> availableGoals = [
    const GameGoal(
      title: 'Наушники',
      cost: 5000,
      pointsReward: 500,
      monthlyContribution: 5000,
    ),
    const GameGoal(
      title: 'Умные часы',
      cost: 7000,
      pointsReward: 750,
      monthlyContribution: 7000,
    ),
    const GameGoal(
      title: 'Планшет',
      cost: 12000,
      pointsReward: 1500,
      monthlyContribution: 12000,
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

  static const List<int> quizDays = [9, 19, 29];
}
