class BranchModel {
  const BranchModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
    );
  }
}
