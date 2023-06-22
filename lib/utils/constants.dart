class Constants {
  Map<String, int> roles = {
    "Almacén": 0,
    "Jefe": 1,
    "Repartidor": 2,
    "Oficinista": 3,
    "Personal de granja": 4
  };

  Map<String, int> orderStatus = {
    "Pendiente de precio": 0,
    "Pedido pendiente": 1,
    "En reparto": 2,
    "Entregado": 3,
    "Intento de entrega": 4,
    "Cancelado": 5
  };

  Map<String, int> paymentMethods = {
    "Al contado": 0,
    "Por recibo": 1,
    "Por transferencia": 2,
  };

  List<String> productClasses = ["XL", "L", "M", "S"];

  Map<String, int> ewgTypes = {"Luz": 0, "Agua": 1, "Gas": 2};

  Map<String, String> monthInSpanish = {
    "01": "Enero",
    "02": "Febrero",
    "03": "Marzo",
    "04": "Abril",
    "05": "Mayo",
    "06": "Junio",
    "07": "Julio",
    "08": "Agosto",
    "09": "Septiembre",
    "10": "Octubre",
    "11": "Noviembre",
    "12": "Diciembre",
  };

  final Map<MenuOptions, String> mapMenuOptions = {
    MenuOptions.billing: "Facturación",
    MenuOptions.selingPrice: "Precio de venta",
    MenuOptions.fpc: "Control prod. final",
    MenuOptions.mcs: "Seg. situación granja",
    MenuOptions.workers: "Trabajadores y salarios",
    MenuOptions.hens: "Gallinas",
    MenuOptions.ewg: "Luz, agua, gas",
    MenuOptions.feed: "Pienso",
    MenuOptions.boxes: "Cajas y cartones",
    MenuOptions.clients: "Clientes",
    MenuOptions.users: "Usuarios internos",
  };

}

enum MenuOptions { billing, selingPrice, fpc, mcs, workers, hens, ewg, feed, boxes, clients, users} 
enum SingleTableCardPositions { leftPosition, rightPosition, centerPosition }