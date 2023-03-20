class CurrentUser {
  final String uid;
  final String visibleID;
  final String name;
  final String surname;
  final String dni;
  final int phone;
  final String email;
  final String direction;
  final String city;
  final String province;
  final int postalCode;
  final bool sameDniDirection;
  final int ssNumber;
  final String bankAccount;
  final int position;
  final String user;
  final String password; // TODO: Esto se va a borrar porque irá por parte de Auth y no de Firestore
  // Lista de permisos app interna
  // Lista de permisos app repartos

  const CurrentUser(
    this.uid,
    this.visibleID,
    this.name,
    this.surname,
    this.dni,
    this.phone,
    this.email,
    this.direction,
    this.city,
    this.province,
    this.postalCode,
    this.sameDniDirection,
    this.ssNumber,
    this.bankAccount,
    this.position,
    this.user,
    this.password
  );
}