import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registro de Producto'),
        ),
        body: RegistroProducto(),
      ),
    );
  }
}

class RegistroProducto extends StatefulWidget {
  @override
  _RegistroProductoState createState() => _RegistroProductoState();
}

class _RegistroProductoState extends State<RegistroProducto> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  List<Map<String, dynamic>> productos = [];

  Future<void> _guardarDatos() async {
    String nombre = nombreController.text;
    String precio = precioController.text;
    int stock = int.tryParse(stockController.text) ?? 0;

    try {
      await FirebaseFirestore.instance.collection('tb_productos').add({
        'nombre': nombre,
        'precio': precio,
        'stock': stock,
      });

      print(
          'Datos guardados en Firebase Firestore. Nombre: $nombre, Precio: $precio, Stock: $stock');

      // Actualiza la lista de productos
      productos.add({
        'nombre': nombre,
        'precio': precio,
        'stock': stock,
      });

      // Limpia los controladores
      nombreController.clear();
      precioController.clear();
      stockController.clear();

      // Actualiza la interfaz de usuario
      setState(() {});
    } catch (e) {
      print('Error al guardar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: nombreController,
            decoration: InputDecoration(labelText: 'Nombre del Producto'),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: precioController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Precio'),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: stockController,
            decoration: InputDecoration(labelText: 'Stock'),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _guardarDatos,
            child: Text('Guardar'),
          ),
          if (productos.isNotEmpty)
            DataTable(
              columns: [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Precio')),
                DataColumn(label: Text('Stock')),
              ],
              rows: productos
                  .map(
                    (producto) => DataRow(
                  cells: [
                    DataCell(Text(producto['nombre'])),
                    DataCell(Text(producto['precio'].toString())),
                    DataCell(Text(producto['stock'].toString())),
                  ],
                ),
              )
                  .toList(),
            ),
        ],
      ),
    );
  }
}