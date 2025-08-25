enum FastingType { recommended, forbidden, normal }

class FastingDay {
  final DateTime date;
  final FastingType type;
  final String? note;

  FastingDay({required this.date, required this.type, this.note});
}
