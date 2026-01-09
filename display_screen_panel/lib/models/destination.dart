class Destination {
  final String id;
  final String from;
  final String name;
  final int maxPassengers;
  final int joinedPassengers;
  final double price;
  final String departureTime;
  final List<String> joinedUsers; // New!

  Destination({
    required this.id,
    required this.from,
    required this.name,
    required this.maxPassengers,
    required this.joinedPassengers,
    required this.price,
    required this.departureTime,
    required this.joinedUsers,
  });
}
