import 'package:phone_book_system/db_page.dart';
import 'employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int selectedGroupNameIndex;
  Map groupNames = {1: 'Family', 2: 'Friends', 3: 'College'};
  var idController = TextEditingController();
  var nameController = TextEditingController();

  var addressController = TextEditingController();

  var landPhoneController = TextEditingController();

  var mobile1Controller = TextEditingController();
  var mobile2Controller = TextEditingController();
  var groupNameController = TextEditingController();
  DateTime selectedDateTime ;
  List data = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: landPhoneController,
                  decoration: InputDecoration(labelText: "Land Phone"),
                ),
                TextField(
                  controller: mobile1Controller,
                  decoration: InputDecoration(labelText: "Mobile1"),
                ),
                TextField(
                  controller: mobile2Controller,
                  decoration: InputDecoration(labelText: "Mobile2"),
                ),
                DropdownButton(items: [
                  ...groupNames.entries.map((entery) => DropdownMenuItem(
                      child: Text(entery.value), value: entery.key))
                ], value: selectedGroupNameIndex,
                    hint: Text("Select Group Name"),
                    isExpanded: true,
                    onChanged: (v){
                  setState(() {
                    selectedGroupNameIndex = v;
                  });

                    }),
                RaisedButton(onPressed: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      //minTime: DateTime(2018, 3, 5),
                      //maxTime: DateTime(2019, 6, 7),
                      onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                    selectedDateTime = date;
                    setState(() {

                    });

                      }, );
                },
                  child: Text((selectedDateTime== null)?'Select BirthDate':selectedDateTime.toString().split(' ')[0]),

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        //int id = int.parse(idController.text);
                        String name = nameController.text;
                        String address = addressController.text;
                        String landPhone = landPhoneController.text;
                        String mobile1 = mobile1Controller.text;
                        String mobile2 = mobile2Controller.text;
                        String groupName = selectedGroupNameIndex.toString();

                        Employee employee = new Employee(name, address,
                            landPhone, mobile1, mobile2, groupName, selectedDateTime.toString());

                        //Person p = new Person(name, age, job, salary);

                        //insertDatabase
                        DBHelper dbHelep = new DBHelper();

                        dbHelep.insertDb(employee).then((row) {
                          print("Done inserted :$row");
                          data.add(employee.toMap());
                        }).catchError((error) {
                          print('Error:$error');
                        });

                        setState(() {
                          idController.clear();
                          nameController.clear();
                          addressController.clear();
                          landPhoneController.clear();
                          mobile1Controller.clear();
                          mobile2Controller.clear();
                          groupNameController.clear();

                        });
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
