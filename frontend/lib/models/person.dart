class Person {
  final int? id;
  final String personType; // PF ou PJ
  final String name;
  final String email;
  final String? phone;
  final String? mobile;
  final String? cpf;
  final String? cnpj;
  final String? rg;
  final String? addressStreet;
  final String? addressNumber;
  final String? addressComplement;
  final String? addressNeighborhood;
  final String? addressCity;
  final String? addressState;
  final String? addressZipcode;
  final String role; // admin, corretor, vendedor, cliente, gestor
  final int? companyId;
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Person({
    this.id,
    required this.personType,
    required this.name,
    required this.email,
    this.phone,
    this.mobile,
    this.cpf,
    this.cnpj,
    this.rg,
    this.addressStreet,
    this.addressNumber,
    this.addressComplement,
    this.addressNeighborhood,
    this.addressCity,
    this.addressState,
    this.addressZipcode,
    this.role = 'cliente',
    this.companyId,
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      personType: json['person_type'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      mobile: json['mobile'],
      cpf: json['cpf'],
      cnpj: json['cnpj'],
      rg: json['rg'],
      addressStreet: json['address_street'],
      addressNumber: json['address_number'],
      addressComplement: json['address_complement'],
      addressNeighborhood: json['address_neighborhood'],
      addressCity: json['address_city'],
      addressState: json['address_state'],
      addressZipcode: json['address_zipcode'],
      role: json['role'] ?? 'cliente',
      companyId: json['company_id'],
      notes: json['notes'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'person_type': personType,
      'name': name,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'cpf': cpf,
      'cnpj': cnpj,
      'rg': rg,
      'address_street': addressStreet,
      'address_number': addressNumber,
      'address_complement': addressComplement,
      'address_neighborhood': addressNeighborhood,
      'address_city': addressCity,
      'address_state': addressState,
      'address_zipcode': addressZipcode,
      'role': role,
      'company_id': companyId,
      'notes': notes,
      'is_active': isActive,
    };
  }

  Person copyWith({
    int? id,
    String? personType,
    String? name,
    String? email,
    String? phone,
    String? mobile,
    String? cpf,
    String? cnpj,
    String? rg,
    String? addressStreet,
    String? addressNumber,
    String? addressComplement,
    String? addressNeighborhood,
    String? addressCity,
    String? addressState,
    String? addressZipcode,
    String? role,
    int? companyId,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Person(
      id: id ?? this.id,
      personType: personType ?? this.personType,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      cpf: cpf ?? this.cpf,
      cnpj: cnpj ?? this.cnpj,
      rg: rg ?? this.rg,
      addressStreet: addressStreet ?? this.addressStreet,
      addressNumber: addressNumber ?? this.addressNumber,
      addressComplement: addressComplement ?? this.addressComplement,
      addressNeighborhood: addressNeighborhood ?? this.addressNeighborhood,
      addressCity: addressCity ?? this.addressCity,
      addressState: addressState ?? this.addressState,
      addressZipcode: addressZipcode ?? this.addressZipcode,
      role: role ?? this.role,
      companyId: companyId ?? this.companyId,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
