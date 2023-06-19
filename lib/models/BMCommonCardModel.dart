class BMCommonCardModel {
  double latitude;
  double longitude;
  String storeUid;
  String image;
  String title;
  int number;
  String? subtitle;
  String? rating;
  String? likes;
  String? comments;
  String? distance;
  bool saveTag;
  bool? liked;

  BMCommonCardModel(
      {required this.storeUid,
      required this.image,
      required this.title,
      required this.latitude,
      required this.longitude,
      required this.number,
      this.subtitle,
      this.comments,
      this.distance,
      this.likes,
      this.rating,
      required this.saveTag,
      this.liked});
}

class ServiceCardModel {
  String name;
  String price;
  List<dynamic> valid;
  List<dynamic> invalid;

  ServiceCardModel(
      {required this.name,
      required this.price,
      required this.valid,
      required this.invalid});
}
