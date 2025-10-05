class Category {
  final int id;
  final String nombre;
  final String? descripcion;

  Category({required this.id, required this.nombre, this.descripcion});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'descripcion': descripcion};
  }
}
