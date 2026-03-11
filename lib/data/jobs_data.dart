import '../models/job.dart';

class JobsData {
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
}
