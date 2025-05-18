/// Sample data model class
class FitModel {
  final int id;
  final String title;
  final String description;

  FitModel({required this.id, required this.title, required this.description});

  factory FitModel.fromJson(Map<String, dynamic> json) {
    return FitModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
