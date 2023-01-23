import 'package:intl/intl.dart';

import '../../domain/entities/astronomy_fact.dart';

class AstronomyFactModel extends AstronomyFact {
  const AstronomyFactModel({
    required String title,
    required String explanation,
    required DateTime date,
    required String imageUrl,
    required String copyRight,
  }) : super(
          title: title,
          explanation: explanation,
          date: date,
          imageUrl: imageUrl,
          copyRight: copyRight,
        );
  factory AstronomyFactModel.fromJson(Map<String, dynamic> json) {
    return AstronomyFactModel(
      title: json['title'],
      explanation: json['explanation'],
      date: DateTime.parse(json['date']),
      imageUrl: json['url'],
      copyRight: json['copyright'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String date = dateFormat.format(this.date);
    return {
      'title': title,
      'date': date,
      'explanation': explanation,
      'url': imageUrl,
      'copyright': copyRight,
    };
  }
}
