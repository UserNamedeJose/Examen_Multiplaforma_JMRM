import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistroVehiculos(),
    );
  }
}

class RegistroVehiculos extends StatefulWidget {
  const RegistroVehiculos({super.key});

  @override
  State<RegistroVehiculos> createState() => _RegistroVehiculosState();
}

class _RegistroVehiculosState extends State<RegistroVehiculos> {
 
  final txtPlaca = TextEditingController();
  final txtMarca = TextEditingController();
  final txtModelo = TextEditingController();
  final txtAnio = TextEditingController();

 
  List<Map<String, String>> vehiculos = [];

  void registrarVehiculo() {
    String placa = txtPlaca.text.trim();
    String marca = txtMarca.text.trim();
    String modelo = txtModelo.text.trim();
    String anio = txtAnio.text.trim();

    
    if (placa.isEmpty || marca.isEmpty || modelo.isEmpty || anio.isEmpty) {
      mostrarMensaje("No deben haber campos vacios", Colors.red);
      return;
    }

   
    if (int.tryParse(anio) == null) {
      mostrarMensaje("El año debe contener únicamente números", Colors.red);
      return;
    }

    
    bool placaExiste = vehiculos.any((vehiculo) => vehiculo['placa'] == placa);
    if (placaExiste) {
      mostrarMensaje("La placa ya está registrada", Colors.red);
      return;
    }

    setState(() {
      vehiculos.add({
        "placa": placa,
        "marca": marca,
        "modelo": modelo,
        "anio": anio,
      });

      
      txtPlaca.clear();
      txtMarca.clear();
      txtModelo.clear();
      txtAnio.clear();
    });

    mostrarMensaje("Vehículo registrado con éxito", Colors.green);
  }


  void mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Vehículos"),
        backgroundColor: Colors.grey.shade300,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // --- Formulario ---
            TextField(
              controller: txtPlaca,
              decoration: const InputDecoration(labelText: "Placa"),
            ),
            TextField(
              controller: txtMarca,
              decoration: const InputDecoration(labelText: "Marca"),
            ),
            TextField(
              controller: txtModelo,
              decoration: const InputDecoration(labelText: "Modelo"),
            ),
            TextField(
              controller: txtAnio,
              decoration: const InputDecoration(labelText: "Año"),
              //keyboardType: TextInputType.number, // Muestra teclado numérico
            ),
            const SizedBox(height: 20),

            
            ElevatedButton(
              onPressed: registrarVehiculo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
              ),
              child: const Text("Registrar Vehículo"),
            ),
            const SizedBox(height: 20),

            // --- Tabla de Registros ---
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, 
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Placa", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Marca", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Modelo", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Año", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: vehiculos.map((vehiculo) {
                      return DataRow(cells: [
                        DataCell(Text(vehiculo["placa"]!)),
                        DataCell(Text(vehiculo["marca"]!)),
                        DataCell(Text(vehiculo["modelo"]!)),
                        DataCell(Text(vehiculo["anio"]!)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}