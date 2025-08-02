class BuildingImageModel {
  int imageId;
  int buildingId;
  String image;
  String caption;
  int order;

  BuildingImageModel({
    required this.imageId,
    required this.buildingId,
    required this.image,
    required this.caption,
    required this.order,
  });

  factory BuildingImageModel.from(Map<String, dynamic> fromJson) {
    return BuildingImageModel(
      imageId: fromJson['id'],
      buildingId: fromJson['building'],
      image: fromJson['image'],
      caption: fromJson['caption'],
      order: fromJson['order'],
    );
  }
}
