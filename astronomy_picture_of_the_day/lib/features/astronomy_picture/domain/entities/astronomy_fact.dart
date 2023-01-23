import 'package:equatable/equatable.dart';

class AstronomyFact extends Equatable {
  final String title;
  final String explanation;
  final DateTime date;
  final String imageUrl;
  final String copyRight;

  const AstronomyFact({
    required this.title,
    required this.explanation,
    required this.date,
    required this.imageUrl,
    required this.copyRight,
  });

  @override
  List<Object?> get props => [title, explanation, date, imageUrl, copyRight];
}
