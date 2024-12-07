import 'dart:io';

import 'package:gastosappg10/models/gasto_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbAdmin {
  Database? myDatabase;

  static final DbAdmin _instance = DbAdmin._();

  DbAdmin._();
  factory DbAdmin() {
    return _instance;
  }

  Future<Database?> _checkDatabase() async {
    if (myDatabase == null) {
      myDatabase = await _initDatabase();
    }
    return myDatabase;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print(directory);
    String pathDatabase = join(directory.path, "GastosDB.db");
    print(pathDatabase);
    return await openDatabase(pathDatabase, version: 1,
        onCreate: (Database db, int version) {
      db.execute("""CREATE TABLE GASTOS (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            price REAL,
            datetime TEXT,
            type TEXT
          )""");
    });
  }

  //INSERCIÓN DE DATOS
  Future<int> insertarGasto(GastoModel gasto) async {
    Database? db = await _checkDatabase();
    int res = await db!.insert(
      "GASTOS",
      gasto.conertirAMap(),
    );
    print(res);
    return res;
  }

  //OBTENER DATOS
  Future<List<GastoModel>> obtenerGastos() async {
    Database? db = await _checkDatabase();
    List<Map<String, dynamic>> data = await db!.query("GASTOS");

    List<GastoModel> gastosModelList = data
        .map(
          (e) => GastoModel.fromDB(e),
        )
        .toList();

    print(gastosModelList);
    return gastosModelList;
  }

  // Método para actualizar un gasto
  Future<int> actualizarGasto(GastoModel gasto) async {
    Database? db = await _checkDatabase();
    int res = await db!.update(
      "GASTOS",
      gasto.conertirAMap(),
      where: "id = ?",
      whereArgs: [gasto.id],
    );
    print("Registros actualizados: $res");
    return res;
  }

  // Método para eliminar un gasto
  Future<int> eliminarGasto(int id) async {
    Database? db = await _checkDatabase();
    int res = await db!.delete(
      "GASTOS",
      where: "id = ?",
      whereArgs: [id],
    );
    print("Registros eliminados: $res");
    return res;
  }
}
