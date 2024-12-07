class GastoModel {
  final int? id; // Cambiado para incluir 'id' como nullable
  final String title;
  final double price;
  final String datetime;
  final String type;

  GastoModel({
    this.id, // id es opcional
    required this.title,
    required this.price,
    required this.datetime,
    required this.type,
  });

  // Método para convertir a un mapa para operaciones con la base de datos
  Map<String, dynamic> conertirAMap() {
    return {
      if (id != null) 'id': id, // Solo incluye el id si no es nulo
      'title': title,
      'price': price,
      'datetime': datetime,
      'type': type,
    };
  }

  // Constructor para crear una instancia desde la base de datos
  factory GastoModel.fromDB(Map<String, dynamic> data) {
    return GastoModel(
      id: data['id'] as int?,
      title: data['title'] as String,
      price: data['price'] as double,
      datetime: data['datetime'] as String,
      type: data['type'] as String,
    );
  }
}
