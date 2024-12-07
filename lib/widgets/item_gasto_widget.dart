import 'package:flutter/material.dart';
import 'package:gastosappg10/db/db_admin.dart';
import 'package:gastosappg10/models/gasto_model.dart';

class ItemGastoWidget extends StatelessWidget {
  final GastoModel gasto;
  final VoidCallback onDelete;
  final VoidCallback onUpdate; // Callback para actualizar la lista

  // Constructor modificado para aceptar onUpdate
  ItemGastoWidget(this.gasto, {required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icono a la izquierda
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              "assets/images/alimentos.webp",
              fit: BoxFit.cover,
            ),
          ),
          // Información del gasto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gasto.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    gasto.datetime,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Precio
          Text(
            "S/ ${gasto.price}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Botones de editar y eliminar
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showEditModal(context, gasto);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await DbAdmin().eliminarGasto(gasto.id!);
                  onDelete(); // Notifica al widget principal para actualizar la lista
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método para mostrar el modal de edición
  void _showEditModal(BuildContext context, GastoModel gasto) {
    TextEditingController titleController =
        TextEditingController(text: gasto.title);
    TextEditingController priceController =
        TextEditingController(text: gasto.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Gasto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () async {
                // Crear el objeto de gasto editado
                GastoModel gastoEditado = GastoModel(
                  id: gasto.id,
                  title: titleController.text,
                  price: double.parse(priceController.text),
                  datetime: gasto.datetime,
                  type: gasto.type,
                );
                // Actualizar el gasto en la base de datos
                await DbAdmin().actualizarGasto(gastoEditado);
                // Mostrar un mensaje de éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gasto actualizado correctamente')),
                );
                Navigator.of(context).pop();
                // Llamar a onUpdate para actualizar la lista en HomePage
                onUpdate();
              },
            ),
          ],
        );
      },
    );
  }
}
