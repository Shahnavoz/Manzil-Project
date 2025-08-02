import 'package:flutter/material.dart';
import 'package:intetership_project/consts/colors.dart';
import 'package:intetership_project/feature/registration/pages/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  // Размеры анимированных кругов (в процентах от ширины)
  double circleScale1 = 0;
  double circleScale2 = 0;
  double circleScale3 = 0;

  // Анимации логотипа
  late AnimationController _logoController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;

  // Анимации по буквам
  late List<AnimationController> _letterControllers;
  late List<Animation<double>> _letterAnimations;

  final String animatedText = "Добро пожаловать!";

  // Анимации текста
  late AnimationController _textController;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textBounceAnimation;

  @override
  void initState() {
    super.initState();

    // Круги появляются плавно
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        circleScale1 = 0.5; // 50% от ширины
        circleScale2 = 0.3;
        circleScale3 = 0.3;
      });
    });

    // Логотип
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_logoController);

    // Текст
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_textController);
    _textBounceAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
    );

    // Запуск анимаций логотипа и текста
    Future.delayed(const Duration(milliseconds: 300), () {
      _logoController.forward();
      _textController.forward();
    });

    // Автоматический переход
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });

    // Инициализация по буквам
    _letterControllers = List.generate(animatedText.length, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      );
    });

    _letterAnimations = _letterControllers
        .map(
          (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.elasticOut),
          ),
        )
        .toList();

    // Запуск поочерёдно
    Future.delayed(const Duration(milliseconds: 800), () async {
      for (int i = 0; i < _letterControllers.length; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        _letterControllers[i].forward();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    for (final controller in _letterControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  double responsiveSize(BuildContext context, double fractionOfWidth) {
    return MediaQuery.of(context).size.width * fractionOfWidth;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final baseTextSize = 26.0 * media.textScaleFactor;

    return Scaffold(
      backgroundColor: backLearGradient2,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6D5BFF),
                Color.fromARGB(255, 46, 26, 197),
                Color(0xFF46A0FC),
                Color(0xFF23D2B7),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Адаптивные круги
              Positioned(
                top: height * 0.1,
                left: width * 0.05,
                child: _buildAnimatedCircle(
                  responsiveSize(context, circleScale1),
                  const Color.fromARGB(255, 12, 80, 70),
                ),
              ),
              Positioned(
                top: height * 0.2,
                left: width * 0.45,
                child: _buildAnimatedCircle(
                  responsiveSize(context, circleScale2),
                  const Color.fromARGB(255, 5, 52, 91),
                ),
              ),
              Positioned(
                top: height * 0.35,
                right: width * 0.1,
                child: _buildAnimatedCircle(
                  responsiveSize(context, circleScale3),
                  const Color.fromARGB(255, 4, 135, 242),
                ),
              ),

              // Логотип в центре
              Center(
                child: FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: width * 0.7,
                        maxHeight: height * 0.4,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(75),
                            bottomRight: Radius.circular(66),
                          ),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6D5BFF),
                              Color.fromARGB(255, 71, 51, 224),
                              Color(0xFF46A0FC),
                              Color.fromARGB(255, 30, 103, 176),
                              Color.fromARGB(255, 21, 105, 92),
                              Color.fromARGB(255, 175, 211, 206),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(-5, 1),
                              spreadRadius: 5,
                              blurRadius: 8,
                              color: const Color.fromARGB(255, 103, 214, 197)
                                  .withOpacity(0.9),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.05),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset(
                              'assets/images/image-removebg-preview (3) 1.png',
                              // не указываем жестко height/width, FittedBox сделает масштаб
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Анимированный текст снизу
              Positioned(
                bottom: height * 0.05,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(animatedText.length, (index) {
                        final char = animatedText[index];
                        return ScaleTransition(
                          scale: _letterAnimations[index],
                          child: Text(
                            char,
                            style: TextStyle(
                              fontSize: baseTextSize,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle(double size, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.08),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.12),
            blurRadius: 32,
            spreadRadius: 8,
          ),
        ],
      ),
    );
  }
}
