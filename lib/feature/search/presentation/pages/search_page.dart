import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/each_bulding/presentation/pages/each_building_page.dart';
import 'package:intetership_project/feature/favourite/data/favourite_provider.dart';
import 'package:intetership_project/feature/home/data/models/building_image_model.dart';
import 'package:intetership_project/feature/home/data/models/building_model.dart';
import 'package:intetership_project/feature/home/data/models/company_model.dart';
import 'package:intetership_project/feature/home/data/repos/building_image_service.dart';
import 'package:intetership_project/feature/home/data/repos/building_service.dart';
import 'package:intetership_project/feature/home/data/repos/company_service.dart';
import 'package:intetership_project/feature/home/presentation/pages/home_page.dart';
import 'package:intetership_project/feature/home/presentation/pages/shimmer_page.dart';
import 'package:intetership_project/feature/search/data/repos/building_map.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  final int? selectedBuildingId;
  SearchPage({super.key, this.selectedBuildingId});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> images = [
    'assets/images/image 5.png',
    'assets/images/image 6.png',
    'assets/images/image 7 (3).png',
    'assets/images/image (14).png',
    'assets/images/image (15).png',
    'assets/images/image (16).png',
  ];

  List<BuildingModel?> allBuildings = [];
  List<BuildingModel?> filteredBuildings = [];
  List<CompanyModel> allCompanies = [];
  String searchQuery = "";
  bool isLoading = true;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getBuildingsFromService();
    getCompaniesFromService();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  getBuildingsFromService() async {
    try {
      var buildings = await BuildingService().getBuildingsFromBack();
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted)
        return; // <<< защита: если виджет уже убрали, не вызываем setState
      setState(() {
        allBuildings = buildings;
        filteredBuildings = buildings;
        isLoading = false;
      });
    } catch (e, st) {
      debugPrint('Ошибка при получении зданий: $e\n$st');
      if (!mounted) return;
      // можно показать ошибку пользователю, если нужно
    }
  }

  getCompaniesFromService() async {
    try {
      var companies = await CompanyService().getCompaniesFromBack();
      if (!mounted) return;
      setState(() {
        allCompanies = companies;
      });
    } catch (e, st) {
      debugPrint('Ошибка при получении компаний: $e\n$st');
      // при ошибке тоже можно защититься, но если ничего не делаем — просто выходим
    }
  }

  String getCompanyName(int companyId) {
    try {
      final company = allCompanies.firstWhere((c) => c.id == companyId);
      return company.name;
    } catch (e) {
      return 'Company $companyId';
    }
  }

  void filterBuildings(String query) {
    final lowerQuery = query.toLowerCase();

    final result =
        allBuildings.where((building) {
          final buildingName = building!.name.toLowerCase();
          final address = building.address.toLowerCase();
          final companyName = getCompanyName(building.company).toLowerCase();

          return buildingName.contains(lowerQuery) ||
              address.contains(lowerQuery) ||
              companyName.contains(lowerQuery);
        }).toList();

    setState(() {
      searchQuery = query;
      filteredBuildings = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final designWidth = 390.0;

    double fontSize(double baseSize) {
      double scale = media.width / designWidth;
      return (baseSize * scale).clamp(12.0, 20.0);
    }

    double iconSize(double baseSize) {
      double scale = media.width / designWidth;
      return (baseSize * scale).clamp(16.0, 28.0);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Search
          SliverAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.tune, size: 35, color: Colors.blue),
                ),
              ),
            ],
            expandedHeight: media.height * 0.15,
            floating: true,
            pinned: true,
            snap: false,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: media.width * 0.1,
                bottom: 12,
              ),

              title: Text(
                'Биноҳо',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),

              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // Search Field
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: media.width * 0.05,
              vertical: media.height * 0.02,
            ),
            sliver: SliverToBoxAdapter(
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(media.width * 0.03),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: media.width * 0.03),
                      child: Icon(Icons.search, size: iconSize(20)),
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear, size: iconSize(16)),
                              onPressed: () {
                                _searchController.clear();
                                filterBuildings('');
                              },
                            )
                            : null,
                    hintText: 'Ҷӯстуҷу бо ном,суроға ва номи компания...',
                    hintStyle: TextStyle(fontSize: fontSize(14)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(media.width * 0.03),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(media.width * 0.03),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: media.height * 0.015,
                      horizontal: media.width * 0.04,
                    ),
                  ),
                  onChanged: filterBuildings,
                ),
              ),
            ),
          ),
          // Content
          isLoading
              ? SliverFillRemaining(
                child: Center(child: _buildShimmerEffect(media)),
              )
              : filteredBuildings.isEmpty
              ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        searchQuery.isEmpty
                            ? 'No buildings available'
                            : 'No results found',
                        style: TextStyle(
                          fontSize: fontSize(16),
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (searchQuery.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            filterBuildings('');
                          },
                          child: Text('Clear search'),
                        ),
                    ],
                  ),
                ),
              )
              : SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: media.width * 0.04,
                  vertical: media.height * 0.01,
                ),
                sliver: Consumer(
                  builder: (context, ref, _) {
                    final favourites = ref.watch(favouriteBuildingsProvider);
                    final notifier = ref.read(
                      favouriteBuildingsProvider.notifier,
                    );
                    final buildingsToShow =
                        searchQuery.isEmpty ? allBuildings : filteredBuildings;

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: media.width * 0.04,
                        crossAxisSpacing: media.width * 0.04,
                        childAspectRatio: 0.75,
                        mainAxisExtent: media.height * 0.32,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final building = buildingsToShow[index]!;
                        final isFav = favourites.any(
                          (b) => b.id == building.id,
                        );

                        return _buildBuildingCard(
                          context: context,
                          media: media,
                          building: building,
                          isFav: isFav,
                          notifier: notifier,
                          fontSize: fontSize,
                          iconSize: iconSize,
                          index: index,
                        );
                      }, childCount: buildingsToShow.length),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect(Size media) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: EdgeInsets.all(media.width * 0.04),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: media.width * 0.04,
          crossAxisSpacing: media.width * 0.04,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(media.width * 0.045),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBuildingCard({
    required BuildContext context,
    required Size media,
    required BuildingModel building,
    required bool isFav,
    required FavouriteBuildingsNotifier notifier,
    required double Function(double) fontSize,
    required double Function(double) iconSize,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    EachBuildingPage(building: building),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(media.width * 0.045),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(media.width * 0.045),
          child: Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  images[index % images.length],
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image,
                          size: iconSize(24),
                          color: Colors.grey.shade400,
                        ),
                      ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(media.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Building Name
                    Text(
                      building.name ?? 'No Name',
                      style: TextStyle(
                        fontSize: fontSize(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: media.height * 0.005),

                    // Address
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: iconSize(14),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        SizedBox(width: media.width * 0.01),
                        Expanded(
                          child: Text(
                            building.address ?? '',
                            style: TextStyle(
                              fontSize: fontSize(12),
                              color: Colors.white.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: media.height * 0.005),

                    // Company
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: iconSize(14),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        SizedBox(width: media.width * 0.01),
                        Expanded(
                          child: Text(
                            getCompanyName(building.company),
                            style: TextStyle(
                              fontSize: fontSize(12),
                              color: Colors.white.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: media.height * 0.01),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Flats
                        Row(
                          children: [
                            Icon(
                              Icons.apartment,
                              size: iconSize(14),
                              color: Colors.white,
                            ),
                            SizedBox(width: media.width * 0.01),
                            Text(
                              '${building.flats_count}',
                              style: TextStyle(
                                fontSize: fontSize(12),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        // Floors
                        Row(
                          children: [
                            Icon(
                              Icons.stairs,
                              size: iconSize(14),
                              color: Colors.white,
                            ),
                            SizedBox(width: media.width * 0.01),
                            Text(
                              '${building.floors_count}',
                              style: TextStyle(
                                fontSize: fontSize(12),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button
              Positioned(
                top: media.width * 0.02,
                right: media.width * 0.02,
                child: InkWell(
                  onTap: () {
                    notifier.toggleFavourite(building);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(media.width * 0.015),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : Colors.white,
                      size: iconSize(16),
                    ),
                  ),
                ),
              ),

              // Highlight if selected
              if (widget.selectedBuildingId == building.id)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade400, width: 3),
                    borderRadius: BorderRadius.circular(media.width * 0.045),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
