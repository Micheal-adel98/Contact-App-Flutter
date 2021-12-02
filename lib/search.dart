import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:phone_book_system/employee.dart';
import 'package:phone_book_system/db_page.dart';
import 'package:phone_book_system/searchEnum.dart';

import 'details.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var nameAddressController = TextEditingController();
  var mobileController = TextEditingController();
  var fromDateTime;
  var toDateTime;
  int selectedGroupNameIndex;
  bool nameAddressCheckBox = false;
  bool goupNameCheckBox = false;
  bool mobileCheckBox = false;
  Map<Types, bool> searchTypes = {
    Types.nameAddress: false,
    Types.mobile: false,
    Types.groupName: false,
    Types.birthDate: false,
  };

  List<Employee> data = [];
  List<Employee> filterdData = [];
  Map groupNames = {1: 'Family', 2: 'Friends', 3: 'College'};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DBHelper dbHelper = new DBHelper();
    dbHelper.getEmployees().then((value) {
      data.addAll(value);


      filterdData.addAll(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          CheckboxListTile(
              value: searchTypes[Types.nameAddress],
              title: TextField(
                controller: nameAddressController,
                decoration: InputDecoration(labelText: "Name or Address"),
              ),
              onChanged: (v) {
                setState(() {
                  searchTypes[Types.nameAddress] = v;
                });
              }),
          /*CheckboxListTile(
              value: searchTypes[Types.mobile],
              title: TextField(
                controller: mobileController,
                decoration: InputDecoration(labelText: "Mobile"),
              ),
              onChanged: (v) {
                setState(() {
                  searchTypes[Types.mobile] = v;
                });
              }),*/
          CheckboxListTile(
              value: searchTypes[Types.groupName],
              title: DropdownButton(
                  items: [
                    ...groupNames.entries.map((entery) => DropdownMenuItem(
                        child: Text(entery.value), value: entery.key))
                  ],
                  value: selectedGroupNameIndex,
                  hint: Text("Select Group Name"),
                  isExpanded: true,
                  onChanged: (v) {
                    setState(() {
                      selectedGroupNameIndex = v;
                    });
                  }),
              onChanged: (v) {
                setState(() {
                  searchTypes[Types.groupName] = v;
                });
              }),
          CheckboxListTile(
              value: searchTypes[Types.birthDate],
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    RaisedButton(
                      child: Text((fromDateTime == null)
                          ? 'From BirthDate'
                          : fromDateTime.toString().split(' ')[0]),
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          //minTime: DateTime(2018, 3, 5),
                          //maxTime: DateTime(2019, 6, 7),
                          onChanged: (date) {
                            print('change $date');
                          },
                          onConfirm: (date) {
                            fromDateTime = date;

                            setState(() {});
                          },
                        );
                      },
                    ),
                    SizedBox(width: 8,),
                    RaisedButton(
                      child: Text((toDateTime == null)
                          ? 'TO BirthDate'
                          : toDateTime.toString().split(' ')[0]),
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          //minTime: DateTime(2018, 3, 5),
                          //maxTime: DateTime(2019, 6, 7),
                          onChanged: (date) {
                            print('change $date');
                          },
                          onConfirm: (date) {
                            toDateTime = date;

                            setState(() {});
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              onChanged: (v) {
                setState(() {
                  searchTypes[Types.birthDate] = v;
                });
              }),
          RaisedButton(
            onPressed: () {
              filterdData.clear();
              //filterCheck(nameAddressController.text,mobileController.text,selectedGroupNameIndex.toString());

              searchTypes.forEach((key, value) {
                if (value) {
                  switch (key) {
                    case Types.nameAddress:
                      if(filterdData.isNotEmpty){
                        filterdData.removeWhere((element) =>
                        !element.name.contains( nameAddressController.text) ||
                          !  element.address.contains(nameAddressController.text));
                        break;
                      }
                      filterdData.addAll(data.where((element) =>
                      element.name.contains(nameAddressController.text) ||
                          element.address
                              .contains(nameAddressController.text)));

                      break;
                   /* case Types.mobile:
                      if (filterdData.isNotEmpty) {
                        //var listMobile = filterdData.where((element) => element.mobile1==mobileController.text);
                        filterdData.removeWhere((element) =>
                            ! element.mobile1.contains(mobileController.text) ||
                            ! element.mobile2.contains(mobileController.text));
                        break;
                      }
                      filterdData.addAll(data.where((element) =>
                          element.mobile1.contains(mobileController.text) ||
                          element.mobile2.contains(mobileController.text)));
                      break;*/
                    case Types.groupName:
                      if (filterdData.isNotEmpty) {
                        //var listMobile = filterdData.where((element) => element.mobile1==mobileController.text);
                        filterdData.removeWhere((element) =>
                            element.groupName !=
                            selectedGroupNameIndex.toString());
                        break;
                      }
                      filterdData.addAll(data.where((element) =>
                          element.groupName ==
                          selectedGroupNameIndex.toString()));
                      break;
                    case Types.birthDate:
                      if (filterdData.isNotEmpty) {
                        print("date is not empty");
                        print(filterdData);
                        //var listMobile = filterdData.where((element) => element.mobile1==mobileController.text);
                        filterdData.removeWhere((element) =>
                        !(((DateTime.parse(element.birthDate)
                            .isAfter(fromDateTime))||(DateTime.parse(element.birthDate)
                            .compareTo(fromDateTime)==0))&& ((DateTime.parse(element.birthDate)
                            .isBefore(toDateTime))) ||(DateTime.parse(element.birthDate)
                            .compareTo(toDateTime)==0))) ;
                        break;
                      }
                      filterdData.addAll(data.where((element) =>
                      (((DateTime.parse(element.birthDate)
                          .isAfter(fromDateTime))||(DateTime.parse(element.birthDate)
                          .compareTo(fromDateTime)==0))&& ((DateTime.parse(element.birthDate)
                          .isBefore(toDateTime))) ||(DateTime.parse(element.birthDate)
                          .compareTo(toDateTime)==0)))) ;

                      break;
                    default:
                      filterdData.addAll(data);
                  }
                }
              }
              );
              setState(() {});
            },
            child: Text("Search"),
          ),
          Expanded(
            child: ListView.builder(


              itemCount: filterdData.length,
              itemBuilder: (BuildContext ctx, int index) {
                return ListTile(
                  onTap:(){
                    showDialog(context: context,
                      barrierDismissible: false,
                      child: CupertinoAlertDialog(
                        title: Column(
                          children: [
                            Icon(Icons.favorite
                            ,color: Colors.yellow,),
                            Text(filterdData[index].name),
                            Text(filterdData[index].address),
                            Text(filterdData[index].mobile1),
                            Text(filterdData[index].mobile2),
                            Text(filterdData[index].landPhone),
                            Text(convertDateTimeDisplay(filterdData[index].birthDate.toString())),
                          ],

                        ),
                        content: Text(groupNames[groupNames.keys.firstWhere(
                                (element) =>
                            element ==
                                int.parse(filterdData[index].groupName.toString()))]),
                        actions: [
                          FlatButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text("ok"))
                        ],
                      )
                    );
                  },

                  title: Text(filterdData[index].name),
                  subtitle:Text (convertDateTimeDisplay(filterdData[index].birthDate.toString())),
                  trailing:
                  Text(groupNames[groupNames.keys.firstWhere(
                      (element) =>
                          element ==
                          int.parse(filterdData[index].groupName.toString()))]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void filterCheck(String nameAddress, String mobile, String groupName) {
    filterdData.addAll(data.where((element) =>
        ((element.name.contains(nameAddress) ||
                element.address.contains(nameAddress)) ||
            (element.mobile1.contains(mobile) ||
                element.mobile2.contains(mobile)) ||
            element.groupName == groupName)));
  }
  String  convertDateTimeDisplay(String date) {

    var dateTime = DateTime.parse(date);
    var formate1 = "${dateTime.day}-${dateTime.month}-${dateTime.year}";

    return formate1.toString();
  }
  
}
