import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intetership_project/feature/each_bulding/presentation/pages/each_floor_page.dart';
import 'package:intetership_project/feature/home/data/models/building_image_model.dart';
import 'package:intetership_project/feature/home/data/models/building_model.dart';
import 'package:intetership_project/feature/home/data/models/company_model.dart';
import 'package:intetership_project/feature/home/data/models/flat_model.dart';
import 'package:intetership_project/feature/home/data/models/floor_model.dart';
import 'package:intetership_project/feature/home/data/repos/building_image_service.dart';
import 'package:intetership_project/feature/home/data/repos/company_service.dart';
import 'package:intetership_project/feature/home/data/repos/flat_service.dart';
import 'package:intetership_project/feature/home/data/repos/floor_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EachBuildingPage extends StatefulWidget {
  BuildingModel building;
  EachBuildingPage({super.key, required this.building});

  @override
  State<EachBuildingPage> createState() => _EachBuildingPageState();
}

class _EachBuildingPageState extends State<EachBuildingPage>
    with TickerProviderStateMixin {
  List<FloorModel> allFloors = [];
  List<FlatModel> allFlats = [];
  List<BuildingImageModel?> buildingImages = [];
  CompanyModel? company;
  bool isLoadingCompany = true;

  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    getFloorsFromBackend();
    getCompanyInfo();
    getFlatsFromBackend();
    getBuildingImagesFromService();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // Запуск анимации появления
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  getFloorsFromBackend() async {
    var floors = await FloorService().getFloors();
    if (!mounted) return;
    setState(() {
      allFloors = floors;
    });
  }

  getBuildingImagesFromService() async {
    var image = await BuildingImageService().getImagesFromBackend();
    if (!mounted) return;
    setState(() {
      buildingImages = image;
    });
  }

  getFlatsFromBackend() async {
    var flats = await FlatService().getFlatsFromBack();
    if (!mounted) return;
    setState(() {
      allFlats = flats;
    });
  }

  getCompanyInfo() async {
    try {
      var companyData = await CompanyService().getCompanyById(
        widget.building.company,
      );
      if (!mounted) return;
      setState(() {
        company = companyData;
        isLoadingCompany = false;
      });
    } catch (e) {
      debugPrint('Error loading company: $e');
      if (!mounted) return;
      setState(() {
        isLoadingCompany = false;
      });
    }
  }

  int activeIndex = 0;
  CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final isNarrow = width < 600;

    final floorsForBuilding =
        allFloors
            .where((floor) => floor.building == widget.building.id)
            .toList();
    final buildingImageList =
        buildingImages
            .where((image) => image!.buildingId == widget.building.id)
            .toList();

    final headerTextSize = isNarrow ? 20.0 : 26.0;
    final subTextSize = isNarrow ? 14.0 : 18.0;
    final spacingVertical = isNarrow ? 12.0 : 20.0;
    final carouselHeight = height * 0.25;

    // intervals for staggered fade-in
    final headerInterval = Interval(0.0, 0.25, curve: Curves.easeOut);
    final carouselInterval = Interval(0.15, 0.45, curve: Curves.easeOut);
    final infoInterval = Interval(0.35, 0.65, curve: Curves.easeOut);
    final floorInterval = Interval(0.55, 1.0, curve: Curves.easeOut);

    return Scaffold(
      // gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2FB), Color(0xFFD6E4F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 16 : 20,
              vertical: isNarrow ? 16 : 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with delay
                  FadeTransition(
                    opacity: _staggerController.drive(
                      Tween(
                        begin: 0.0,
                        end: 1.0,
                      ).chain(CurveTween(curve: headerInterval)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            size: isNarrow ? 28 : 32,
                            color: Colors.blueAccent,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        SizedBox(width: isNarrow ? 10 : 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.building.name ?? 'No name',
                                style: TextStyle(
                                  fontSize: headerTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                isLoadingCompany
                                    ? 'Loading company...'
                                    : (company?.name ?? 'Company not found'),
                                style: TextStyle(
                                  fontSize: subTextSize,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacingVertical),

                  // Carousel with delay
                  FadeTransition(
                    opacity: _staggerController.drive(
                      Tween(
                        begin: 0.0,
                        end: 1.0,
                      ).chain(CurveTween(curve: carouselInterval)),
                    ),
                    child: Column(
                      children: [
                        if (buildingImageList.isNotEmpty)
                          CarouselSlider.builder(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              height:
                                  MediaQuery.of(context).size.width *
                                  0.55, // адаптивная высота
                              enlargeCenterPage: true,
                              viewportFraction: 0.9,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  activeIndex = index;
                                });
                              },
                            ),
                            itemCount: buildingImageList.length,
                            itemBuilder: (context, index, realIndex) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        buildingImageList[index]!.image,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        SizedBox(height: 12),
                        AnimatedSmoothIndicator(
                          effect: SwapEffect(
                            activeDotColor: Colors.blue,
                            dotColor: const Color.fromARGB(255, 22, 82, 131),
                            dotHeight: isNarrow ? 8 : 10,
                            dotWidth: isNarrow ? 8 : 10,
                          ),
                          activeIndex: activeIndex,
                          count: buildingImageList.length,
                          onDotClicked: (index) {
                            _carouselController.animateToPage(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacingVertical),

                  // Info & description with delay
                  FadeTransition(
                    opacity: _staggerController.drive(
                      Tween(
                        begin: 0.0,
                        end: 1.0,
                      ).chain(CurveTween(curve: infoInterval)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(
                          iconSize: isNarrow ? 30 : 38,
                          iconPath:
                              'assets/icons/image-removebg-preview (21) 1.png',
                          text: '${widget.building.floors_count} ошёна',
                        ),
                        _infoRow(
                          iconSize: isNarrow ? 30 : 38,
                          iconPath:
                              'assets/icons/image-removebg-preview (22) 1.png',
                          text: 'Соли 2023 сохташудааст.',
                        ),
                        _infoRow(
                          iconSize: isNarrow ? 30 : 38,
                          iconPath:
                              'assets/icons/image-removebg-preview (23) 1.png',
                          text: '2 то лифт дорад.',
                        ),
                        _infoRow(
                          iconSize: isNarrow ? 30 : 38,
                          iconPath:
                              'assets/icons/image-removebg-preview (24) 1.png',
                          text: 'Тавакуфгоҳ мавҷуд аст.',
                        ),
                        SizedBox(height: spacingVertical),
                        Container(
                          padding: EdgeInsets.all(isNarrow ? 12 : 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: isNarrow ? 18 : 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${widget.building.description ?? 'No description'}',
                                style: TextStyle(
                                  fontSize: isNarrow ? 14 : 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacingVertical * 1.5),

                  // Floor selector with delay
                  FadeTransition(
                    opacity: _staggerController.drive(
                      Tween(
                        begin: 0.0,
                        end: 1.0,
                      ).chain(CurveTween(curve: floorInterval)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ошёна интихоб кунед',
                          style: TextStyle(
                            fontSize: isNarrow ? 20 : 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: isNarrow ? 12 : 15),
                        Wrap(
                          spacing: isNarrow ? 10 : 15,
                          runSpacing: isNarrow ? 10 : 15,
                          children: List.generate(widget.building.floors_count, (
                            index,
                          ) {
                            int floorNumber = index + 1;
                            return GestureDetector(
                              onTap: () {
                                final matchingFloors =
                                    allFloors
                                        .where(
                                          (floor) =>
                                              floor.building ==
                                                  widget.building.id &&
                                              floor.floor_number == floorNumber,
                                        )
                                        .toList();
                                if (matchingFloors.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Floor $floorNumber data not available',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                final matchingFloor = matchingFloors.first;
                                final flatsOnThisFloor =
                                    allFlats.where((flat) {
                                      final flatFloorNumber =
                                          int.tryParse(flat.floor_number) ?? -1;
                                      return flatFloorNumber ==
                                              matchingFloor.floor_number &&
                                          flat.building_name
                                                  .trim()
                                                  .toLowerCase() ==
                                              widget.building.name
                                                  .trim()
                                                  .toLowerCase();
                                    }).toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EachFloorPage(
                                          floor: matchingFloor,
                                          buildingName: widget.building.name,
                                          flat: flatsOnThisFloor,
                                        ),
                                  ),
                                );
                              },
                              child: FloorContainer(
                                floorNumber: floorNumber.toString(),
                                isNarrow: isNarrow,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required String iconPath,
    required String text,
    required double iconSize,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Image.asset(iconPath, width: iconSize, height: iconSize),
          SizedBox(width: iconSize * 0.3),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: iconSize * 0.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloorContainer extends StatelessWidget {
  final String floorNumber;
  final bool isNarrow;
  const FloorContainer({
    super.key,
    required this.floorNumber,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final containerWidth = isNarrow ? width * 0.18 : 88.0;
    final containerHeight = isNarrow ? 50.0 : 60.0;
    final fontSize = isNarrow ? 20.0 : 24.0;

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 3, color: const Color(0xFF1B7EF5)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Text(
          floorNumber,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B7EF5),
          ),
        ),
      ),
    );
  }
}
