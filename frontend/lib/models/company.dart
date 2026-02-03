class Company {
  final int? id;
  final String companyName; // Razão Social
  final String tradeName; // Nome Fantasia
  final String cnpj;
  final String email;
  final String? phone;
  final String? website;
  final String? addressStreet;
  final String? addressNumber;
  final String? addressComplement;
  final String? addressNeighborhood;
  final String? addressCity;
  final String? addressState;
  final String? addressZipcode;
  final String? logoUrl;
  final String? creci;
  final String planType; // basic, professional, enterprise
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Company({
    this.id,
    required this.companyName,
    required this.tradeName,
    required this.cnpj,
    required this.email,
    this.phone,
    this.website,
    this.addressStreet,
    this.addressNumber,
    this.addressComplement,
    this.addressNeighborhood,
    this.addressCity,
    this.addressState,
    this.addressZipcode,
    this.logoUrl,
    this.creci,
    this.planType = 'basic',
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      companyName: json['company_name'],
      tradeName: json['trade_name'],
      cnpj: json['cnpj'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      addressStreet: json['address_street'],
      addressNumber: json['address_number'],
      addressComplement: json['address_complement'],
      addressNeighborhood: json['address_neighborhood'],
      addressCity: json['address_city'],
      addressState: json['address_state'],
      addressZipcode: json['address_zipcode'],
      logoUrl: json['logo_url'],
      creci: json['creci'],
      planType: json['plan_type'] ?? 'basic',
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
      'company_name': companyName,
      'trade_name': tradeName,
      'cnpj': cnpj,
      'email': email,
      'phone': phone,
      'website': website,
      'address_street': addressStreet,
      'address_number': addressNumber,
      'address_complement': addressComplement,
      'address_neighborhood': addressNeighborhood,
      'address_city': addressCity,
      'address_state': addressState,
      'address_zipcode': addressZipcode,
      'logo_url': logoUrl,
      'creci': creci,
      'plan_type': planType,
      'notes': notes,
      'is_active': isActive,
    };
  }

  Company copyWith({
    int? id,
    String? companyName,
    String? tradeName,
    String? cnpj,
    String? email,
    String? phone,
    String? website,
    String? addressStreet,
    String? addressNumber,
    String? addressComplement,
    String? addressNeighborhood,
    String? addressCity,
    String? addressState,
    String? addressZipcode,
    String? logoUrl,
    String? creci,
    String? planType,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Company(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      tradeName: tradeName ?? this.tradeName,
      cnpj: cnpj ?? this.cnpj,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      addressStreet: addressStreet ?? this.addressStreet,
      addressNumber: addressNumber ?? this.addressNumber,
      addressComplement: addressComplement ?? this.addressComplement,
      addressNeighborhood: addressNeighborhood ?? this.addressNeighborhood,
      addressCity: addressCity ?? this.addressCity,
      addressState: addressState ?? this.addressState,
      addressZipcode: addressZipcode ?? this.addressZipcode,
      logoUrl: logoUrl ?? this.logoUrl,
      creci: creci ?? this.creci,
      planType: planType ?? this.planType,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
