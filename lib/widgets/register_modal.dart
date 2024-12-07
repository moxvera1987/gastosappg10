import 'package:flutter/material.dart';
import 'package:gastosappg10/db/db_admin.dart';
import 'package:gastosappg10/models/gasto_model.dart';
import 'package:gastosappg10/utils/data_general.dart';
import 'package:gastosappg10/widgets/field_modal_widget.dart';
import 'package:gastosappg10/widgets/item_type_widget.dart';

class RegisterModal extends StatefulWidget {
  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String typeSelected = "Alimentos";

  _builAddButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          GastoModel gastoModel = GastoModel(
              title: titleController.text,
              price: double.parse(priceController.text),
              datetime: dateController.text,
              type: typeSelected);
          DbAdmin().insertarGasto(gastoModel).then((value) {
            if (value > 0) {
              //SE HA INSERTADO CORRECTAMENTE
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.cyan,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  content: Text("Se ha registrado correctamente"),
                ),
              );
              Navigator.pop(context);
            }
          });
        },
        child: Text(
          "Agregar",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showDateTimePicker() async {
    DateTime? datePicker = await showDatePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: Colors.red,
            ),
          ),
          child: child!,
        );
      },
    );
    dateController.text = datePicker.toString();
    print(dateController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 24, left: 16, right: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          )),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Registra el gasto"),
            SizedBox(height: 24),
            FieldModalWidget(
                hint: "Ingresa el título", controller: titleController),
            FieldModalWidget(
              hint: "Ingresa el monto",
              controller: priceController,
              isNumberKeyBoard: true,
            ),
            FieldModalWidget(
              hint: "Ingresa la fecha",
              controller: dateController,
              isDatePicker: true,
              function: () {
                showDateTimePicker();
                print("Hola");
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: types
                    .map(
                      (e) => ItemTypeWidget(
                        data: e,
                        isSelected: typeSelected == e["name"],
                        tap: () {
                          typeSelected = e["name"];
                          setState(() {});
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            _builAddButton(),
          ],
        ),
      ),
    );
  }
}
