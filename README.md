# TSQL_TravelAgency_EXAM
# **Для туристичного агентства «Навколо світу за 80 днів» необхідно створити базу даних. За допомогою представлень, збережених процедур, функцій користувача, тригерів реалізуйте певну функціональність.** #

## У базі даних слід зберігати таку інформацію: ##
    ■ Працівники турагентства:
    ▷ ПІБ,
    ▷ посада,
    ▷ контактний телефон та email,
    ▷ дата прийняття на роботу;

    ■ Співробітники, відповідальні за країни, тури;

    ■ Тури:
    ▷ назва туру,
    ▷ вартість,
    ▷ дата старту та закінчення,
    ▷ спосіб(и) пересування,
    ▷ країни та міста туру (зберігати інформацію про дати відвідування),
    ▷ пам'ятки в кожній точці маршруту (включені у вартість туру та опціональні за додаткову плату),
    ▷ зображення визначних пам'яток,
    ▷ інформація про готелі, де ночуватимуть туристи в турі,
    ▷ зображення готелів,
    ▷ список туристів, які оплатили тур,
    ▷ максимальна кількість туристів для туру,
    ▷ список потенційних туристів, які цікавилися туром,
    ▷ ПІБ співробітника, який відповідає за конкретний тур,

    ■ Клієнти агентства:
    ▷ ПІБ,
    ▷ контактний телефон та email,
    ▷ дата народження,
    ▷ майбутні тури клієнта,
    ▷ минулі тури клієнта,

    ■ Архів проведених турів.
    
## За допомогою представлень, збережених процедур, функцій користувача, тригерів реалізуйте наступну функціональність: ##

    ■ Надайте інформацію про всі актуальні тури;
    ■ Відобразіть інформацію про всі тури, які стартують у діапазоні дат. Діапазон дат передається як параметр;
    ■ Відобразіть інформацію про всі тури, які відвідають вказану країну. Країна передається як параметр;
    ■ Відобразіть найпопулярнішу туристичну країну (за найбільшою кількістю турів з урахуванням архівних);
    ■ Показати найпопулярніший актуальний тур (за максимальною кількістю куплених туристичних путівок);
    ■ Показати найпопулярніший архівний тур (за максимальною кількістю куплених туристичних путівок);
    ■ Показати найпопулярніший актуальний тур (за мінімальною кількістю куплених туристичних путівок);
    ■ Показати для конкретного туриста по ПІБ список усіх його турів. ПІБ туриста передається як параметр;
    ■ Перевірити для конкретного туриста по ПІБ чи перебуває він зараз у турі. ПІБ туриста передається як параметр;
    ■ Відобразити інформацію про те, де знаходиться конкретний турист з ПІБ. Якщо турист не в турі згенерувати помилку з описом проблеми, що виникла. ПІБ туриста передається як параметр;
    ■ Відобразити інформацію про найактивнішого туриста (за кількістю придбаних турів);
    ■ Відобразити інформацію про всі тури вказаного способу пересування. Спосіб пересування передається як параметр;
    ■ При вставці нового клієнта необхідно перевіряти, чи немає його вже в базі даних. Якщо такий клієнт є, генерувати помилку  з описом проблеми, що виникла;
    ■ При видаленні минулих турів необхідно переносити їх до архіву турів;
    ■ Відобразити інформацію про найпопулярніший готель серед туристів (за кількістю туристів);
    ■ При додаванні нового туриста в тур перевіряти чи не досягнуто вже максимальної кількості. Якщо максимальна кількість досягнуто, генерувати помилку з інформацією про проблему;
