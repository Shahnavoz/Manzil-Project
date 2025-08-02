import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature/each_bulding/presentation/pages/each_building_page.dart';
import 'package:intetership_project/feature/favourite/data/favourite_provider.dart';
import 'package:intetership_project/feature/home/data/models/building_model.dart';
import 'package:intetership_project/feature/home/data/models/company_model.dart';
import 'package:intetership_project/feature/home/data/repos/building_service.dart';
import 'package:intetership_project/feature/home/data/repos/company_service.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> with TickerProviderStateMixin {
  List<BuildingModel?> allBuildings = [];
  List<CompanyModel?> allCompanies = [];

  late final AnimationController _staggerController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  bool showAllBuildings = false;
  bool _showContent = false;

  final List<String> images = [
    'assets/images/image 5.png',
    'assets/images/image 6.png',
    'assets/images/image 7 (3).png',
    'assets/images/image (14).png',
    'assets/images/image (15).png',
    'assets/images/image (16).png',
  ];

  @override
  void initState() {
    super.initState();
    getBuildings();
    getCompaniesFromService();
    // Запуск задержки для более красивого появления
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _showContent = true);
        _staggerController.forward();
      }
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Future<void> getBuildings() async {
    final building = await BuildingService().getBuildingsFromBack();
    if (!mounted) return;
    setState(() {
      allBuildings = building;
    });
  }

  Future<void> getCompaniesFromService() async {
    final companies = await CompanyService().getCompaniesFromBack();
    if (!mounted) return;
    setState(() {
      allCompanies = companies;
    });
  }

  String getCompanyName(int companyId) {
    try {
      final company = allCompanies.firstWhere((c) => c!.id == companyId);
      return company!.name;
    } catch (_) {
      return 'Company $companyId';
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 600;
    final titleStyle = TextStyle(fontSize: isNarrow ? 22 : 26, fontWeight: FontWeight.bold);
    final subtitleStyle = TextStyle(fontSize: isNarrow ? 14 : 16, color: Colors.grey[700]);
    final cardPadding = EdgeInsets.all(isNarrow ? 10 : 14);
    final imageHeight = media.size.height / (isNarrow ? 10 : 8);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 16 : 20,
            vertical: isNarrow ? 16 : 20,
          ),
          child: Consumer(builder: (context, ref, _) {
            final favourites = ref.watch(favouriteBuildingsProvider);

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _showContent ? 1 : 0,
              child: favourites.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Интихобшуда', style: titleStyle),
                        SizedBox(height: isNarrow ? 12 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'Холо шумо интихоб шуда надоред.',
                                  style: subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showAllBuildings = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1B7EF5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isNarrow ? 16 : 24,
                                    vertical: isNarrow ? 14 : 18,
                                  ),
                                  elevation: 4,
                                ),
                                child: Text(
                                  'Чустучуи эьлонхо',
                                  style: TextStyle(
                                    fontSize: isNarrow ? 16 : 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (showAllBuildings)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final crossAxisCount = isNarrow ? 2 : 3;
                                        return GridView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: allBuildings.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            mainAxisSpacing: 16,
                                            crossAxisSpacing: 16,
                                            childAspectRatio: 0.72,
                                          ),
                                          itemBuilder: (context, index) {
                                            final building = allBuildings[index];
                                            return FadeTransition(
                                              opacity: _staggerController.drive(
                                                Tween<double>(
                                                  begin: 0,
                                                  end: 1,
                                                ).chain(
                                                  CurveTween(
                                                    curve: Interval(
                                                      (index / (allBuildings.length + 2))
                                                          .clamp(0.0, 1.0),
                                                      1.0,
                                                      curve: Curves.easeOut,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (building == null) return;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EachBuildingPage(building: building),
                                                    ),
                                                  );
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18),
                                                  ),
                                                  elevation: 6,
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Padding(
                                                    padding: cardPadding,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(12),
                                                          child: Container(
                                                            width: double.infinity,
                                                            height: imageHeight,
                                                            color: Colors.grey.shade200,
                                                            child: Image.asset(
                                                              images[index % images.length],
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (_, __, ___) =>
                                                                  Icon(
                                                                Icons.image,
                                                                size: 48,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          building?.name ?? 'No Name',
                                                          style: TextStyle(
                                                            fontSize: isNarrow ? 16 : 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.blueGrey.shade900,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        SizedBox(height: 4),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.location_on,
                                                              size: 16,
                                                              color: Colors.blueAccent,
                                                            ),
                                                            const SizedBox(width: 4),
                                                            Expanded(
                                                              child: Text(
                                                                building?.address ?? '',
                                                                style: TextStyle(
                                                                  fontSize: isNarrow ? 12 : 13,
                                                                  color: Colors.blueGrey.shade600,
                                                                ),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Интихоб шуда', style: titleStyle),
                        SizedBox(height: isNarrow ? 12 : 20),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: favourites.length,
                            separatorBuilder: (_, __) => SizedBox(height: isNarrow ? 12 : 16),
                            itemBuilder: (context, index) {
                              final building = favourites[index];
                              return AnimatedBuilder(
                                animation: _staggerController,
                                builder: (context, child) {
                                  final intervalStart = (index / (favourites.length + 1))
                                      .clamp(0.0, 1.0);
                                  final opacity = Curves.easeOut.transform(
                                      (_staggerController.value - intervalStart)
                                          .clamp(0.0, 1.0));
                                  return Opacity(
                                    opacity: opacity,
                                    child: child,
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: isNarrow ? 12 : 16,
                                      vertical: isNarrow ? 8 : 12,
                                    ),
                                    leading: Icon(
                                      Icons.apartment,
                                      color: Colors.blueAccent,
                                      size: isNarrow ? 30 : 36,
                                    ),
                                    title: Text(
                                      building.name ?? 'No Name',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(building.address ?? ''),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(favouriteBuildingsProvider.notifier)
                                            .toggleFavourite(building);
                                      },
                                      tooltip: 'Убрать из избранного',
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          }),
        ),
      ),
    );
  }
}
