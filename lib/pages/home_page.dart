import 'package:flutter/material.dart';
import 'package:gastosappg10/db/db_admin.dart';
import 'package:gastosappg10/generated/l10n.dart';
import 'package:gastosappg10/models/gasto_model.dart';
import 'package:gastosappg10/widgets/busqueda_widget.dart';
import 'package:gastosappg10/widgets/item_gasto_widget.dart';
import 'package:gastosappg10/widgets/register_modal.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GastoModel> gastosList = [];

  //Llenando gastos list desde mi DB
  Future<void> getDataFromDB() async {
    gastosList = await DbAdmin().obtenerGastos();
    setState(() {});
  }

  void showRegisterModal() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext contex) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: RegisterModal(),
        );
      },
    ).then((value) {
      getDataFromDB();
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromDB(); // Cargar los datos desde la base de datos al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showRegisterModal();
                  },
                  child: Container(
                    color: Colors.black,
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Agregar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Ingresa tus gatos",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Gestiona tus gastos de mejor forma",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(S.of(context).helloAlguien("Jhony")),
                        BusquedaWidget(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: gastosList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemGastoWidget(
                                gastosList[index],
                                onDelete: () async {
                                  await DbAdmin()
                                      .eliminarGasto(gastosList[index].id!);
                                  // Recargamos los datos después de eliminar
                                  getDataFromDB();
                                },
                                onUpdate:
                                    getDataFromDB, // Pasamos la función de actualización
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 73,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
