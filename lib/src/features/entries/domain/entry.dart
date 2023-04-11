// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Entry extends Equatable {
  final String id;
  final double weight;
  final DateTime date;

  const Entry({
    required this.id,
    required this.weight,
    required this.date,
  });

  factory Entry.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as String;
    final weight = data['weight'] as double;
    final date = DateTime.parse(data['date']);
    return Entry(id: id, weight: weight, date: date);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() => 'Entry(id: $id, weight: $weight, date: $date)';

  @override
  List<Object?> get props => [id, weight, date];
}
