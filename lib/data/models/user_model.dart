class UserModel {
  final String id;
  final String name;
  final String phone;
  final bool isGuest;
  final bool isAdmin;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.isGuest = false,
    this.isAdmin = false,
  });

  factory UserModel.guest() {
    return const UserModel(
      id: 'guest_user',
      name: 'Guest Customer',
      phone: '',
      isGuest: true,
      isAdmin: false,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      isGuest: map['isGuest'] as bool? ?? false,
      isAdmin: map['isAdmin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'isGuest': isGuest,
      'isAdmin': isAdmin,
    };
  }
}
