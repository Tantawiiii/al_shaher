class MemberModel {
  const MemberModel({
    required this.id,
    required this.name,
    this.phone,
    this.nationalId,
    this.dateOfBirth,
    this.city,
    this.imageUrl,
  });

  final int id;
  final String name;
  final String? phone;
  final String? nationalId;
  final String? dateOfBirth;
  final String? city;
  final String? imageUrl;

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      nationalId: json['national_id'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      city: json['city'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
