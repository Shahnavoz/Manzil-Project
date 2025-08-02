import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': 'Как пользоваться приложением?',
      'answer':
          'Вы можете искать, сохранять в избранное и общаться с другими пользователями.',
    },
    {
      'question': 'Как изменить свой профиль?',
      'answer': 'Перейдите в Профиль > Редактировать, чтобы внести изменения.',
    },
    {
      'question': 'Как связаться с поддержкой?',
      'answer':
          'Напишите нам через раздел Чат или по указанной почте внизу страницы.',
    },
    {
      'question': 'Можно ли использовать приложение офлайн?',
      'answer':
          'Некоторые функции, такие как просмотр сохранённых данных, доступны офлайн.',
    },
    {
      'question': '🏘️  Как найти интересующий дом или квартиру?',
      'answer':
          'Вы можете воспользоваться вкладкой «Поиск», чтобы найти новостройки по названию, району, этажности или другим параметрам.',
    },
    {
      'question': '📍  Как отфильтровать новостройки по району или цене?',
      'answer':
          'Во вкладке «Поиск» нажмите на иконку фильтра и выберите район, количество комнат, ценовой диапазон и другие параметры.',
    },
    {
      'question': '🧾  Как посмотреть подробную информацию о квартире?',
      'answer':
          'Нажмите на интересующее здание, затем выберите нужный этаж и квартиру. Вы увидите планировку, площадь, цену и другую информацию.',
    },
    {
      'question': '💬  Как задать вопрос или связаться с застройщиком?',
      'answer':
          'Вы можете воспользоваться разделом «Чат», чтобы задать вопрос представителю или оставить заявку на обратный звонок.',
    },
    {
      'question': '🏗️   Как узнать, на каком этапе находится строительство?',
      'answer':
          'Цена указана в карточке квартиры. Также вы можете отправить запрос для получения точной стоимости от застройщика.',
    },
  ];

  FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isNarrow = media.size.width < 600;
    final horizontalPadding = isNarrow ? 12.0 : 16.0;
    final titleFontSize = isNarrow ? 16.0 : 18.0;
    final answerFontSize = isNarrow ? 14.0 : 15.0;
    final cardRadius = 16.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          tooltip: 'Назад',
        ),
        title: const Text(
          'FAQ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2F72A9),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          // color: const Color(0xFFF5F5F5),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
          child: ListView.separated(
            itemCount: faqList.length,
            separatorBuilder: (_, __) => SizedBox(height: isNarrow ? 8 : 12),
            itemBuilder: (context, index) {
              final item = faqList[index];
              return Card(
                margin: EdgeInsets.zero,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    // dividerColor: Colors.transparent,
                    // splashColor: Colors.transparent,
                    // highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(
                        horizontal: isNarrow ? 14 : 16, vertical: isNarrow ? 8 : 12),
                    collapsedIconColor: const Color(0xFF2D5D70),
                    iconColor: const Color(0xFF2D5D70),
                    title: Text(
                      item['question'] ?? '',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        // color: const Color(0xFF2D5D70),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            isNarrow ? 14 : 16, 0, isNarrow ? 14 : 16, isNarrow ? 12 : 16),
                        child: Text(
                          item['answer'] ?? '',
                          style: TextStyle(
                            fontSize: answerFontSize,
                            color: const Color(0xFF444444),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
