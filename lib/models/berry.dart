class Berry {
  final int id;
  final String name;
  final int growthTime;
  final int maxHarvest;
  final int size;

  Berry({
    required this.id,
    required this.name,
    required this.growthTime,
    required this.maxHarvest,
    required this.size,
  });

  factory Berry.fromJson(Map<String, dynamic> json) {
    return Berry(
      id: json['id'],
      name: json['name'],
      growthTime: json['growth_time'],
      maxHarvest: json['max_harvest'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'growth_time': growthTime,
      'max_harvest': maxHarvest,
      'size': size,
    };
  }

  @override
  String toString() {
    return 'Berry(id: $id, name: $name, growthTime: $growthTime, maxHarvest: $maxHarvest, size: $size)';
  }
}
