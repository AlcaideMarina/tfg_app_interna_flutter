class ClientModel {
  final String id;
  final String company;
  final String direction;
  final String city;
  final String province;
  final int postalCode;
  final String cif;
  final String email;
  final List<Map<String, int>> phone;
  final Map<String, double> price;
  final bool hasAccount;
  final String? user;
  final String? emailAccount;

  const ClientModel(
    this.id,
    this.company,
    this.direction,
    this.city,
    this.province,
    this.postalCode,
    this.cif,
    this.email,
    this.phone, 
    this.price,
    this.hasAccount,
    this.user,
    this.emailAccount
  );
}