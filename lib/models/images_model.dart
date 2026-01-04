class ImageModel {
  final String smallImage;
  final String regularImage;
  final String description;

  ImageModel ({
    required this.smallImage,
    required this.regularImage,
    required this.description
  });

  factory ImageModel.fromJson(Map<String, dynamic> json){
    return ImageModel(
        smallImage: json['urls']['small'],
        regularImage: json['urls']['regular'],
        description: json['description'] ?? json['alt_description'] ?? '',
    );
  }
}