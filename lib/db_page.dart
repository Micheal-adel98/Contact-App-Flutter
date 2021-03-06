import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'employee.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String BIRTHDATE = 'birthDate';
  static const String NAME = 'name';
  static const String LANDPHONE = 'landPhone';
  static const String MOBILE1 = 'mobile1';
  static const String MOBILE2 = 'mobile2';
  static const String GROUPNAME = 'groupName';
  static const String ADDRESS = 'address';
  static const String TABLE = 'Employee';
  static const String DB_NAME = 'employee.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $NAME TEXT, $LANDPHONE TEXT, $MOBILE1 TEXT, $MOBILE2 TEXT, $GROUPNAME TEXT, $ADDRESS TEXT, $BIRTHDATE TEXT)");
  }
  Future<int> insertDb(Employee employee) async{
    var dbClient = await db;
    int row = await dbClient.insert(TABLE, employee.toMap());

    return row;
  }

  Future<Employee> save(Employee employee) async {
    var dbClient = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
    return employee;
  }

  Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Employee> employees = [];
    if(maps.length>0){
      for(int i = 0; i< maps.length; i++){
        employees.add(Employee.fromMap(maps[i]));
      }
    }
    return employees;
  }
  Future<List> viewDb() async {
    var dbClient = await db;

    List<Map<String, dynamic>> data = await dbClient.query(TABLE);


    return data;
  }
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}