// post_model.dart
class PostModel {
  final String profile;
  final String name;
  final String date;
  final String postImage;
  final String title;
  final String description;
  final String id;
  final String posterid;

  PostModel({
    required this.profile,
    required this.name,
    required this.date,
    required this.postImage,
    required this.title,
    required this.description,
    required this.id,
    required this.posterid,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        profile: json['profile'],
        name: json['name'],
        date: json['date'],
        postImage: json['post_image'],
        title: json['title'],
        description: json['description'],
        id: json['id'],
        posterid: json['user_id']);
  }
}
