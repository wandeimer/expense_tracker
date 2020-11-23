import 'package:expense_tracker/Expense.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class ExpenseDB {
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialize();
    }
    return _database;
  }

  ExpenseDB();

  initialize() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    var path = join(documentsDir.path, "db.db");
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT)");
      }
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    Database db = await database;
    List<Map> query = await db.rawQuery("SELECT * FROM Expenses ORDER BY date DESC");
    var result = List<Expense>();
    query.forEach((r) => result.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"])));
    return result;
  }

  Future<void> addExpense(String name, double price, DateTime dateTime) async {
    Database db = await database;
    String dateAsString = dateTime.toString();
    db.rawInsert("INSERT INTO Expenses (name, date, price) VALUES (\"$name\", \"$dateAsString\", $price)");
  }

  Future<void> deleteExpense(int id) async {
    Database db = await database;
    db.rawDelete("DELETE FROM Expenses WHERE id = ?", ["$id"]);
  }
}
