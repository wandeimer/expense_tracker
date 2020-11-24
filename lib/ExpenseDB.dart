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
    return openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT)");
      await db.execute(
          "CREATE TABLE ExpensesPerMonth (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, price REAL)");
    });
  }

  Future<List<Expense>> getAllExpenses() async {
    Database db = await database;
    List<Map> query =
        await db.rawQuery("SELECT * FROM Expenses ORDER BY date DESC");
    var result = List<Expense>();
    query.forEach((r) => result.add(
        Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"])));
    return result;
  }

  Future<List<Month>> getPerMonth() async {
    Database db = await database;
    List<Map> query =
        await db.rawQuery("SELECT * FROM ExpensesPerMonth ORDER BY date DESC");
    var result = List<Month>();
    query.forEach((r) =>
        result.add(Month(r["id"], DateTime.parse(r["date"]), r["price"])));
    return result;
  }

  Future<void> addExpense(String name, double price, DateTime dateTime) async {
    Database db = await database;
    String dateAsString = dateTime.toString();
    db.rawInsert(
        "INSERT INTO Expenses (name, date, price) VALUES (\"$name\", \"$dateAsString\", $price)");
  }

  Future<void> addExpensePerMonth(DateTime date, double price) async {
    Database db = await database;
    String month = DateTime(date.year, date.month).toString();
    List<Map> query = await db.rawQuery(
        "SELECT price FROM ExpensesPerMonth WHERE date = ?;", ["$month"]);
    if (query.isEmpty) {
      db.rawInsert("INSERT INTO ExpensesPerMonth (date, price) VALUES (?, ?)",
          ["$month", "$price"]);
    } else {
      db.rawUpdate(
          "UPDATE ExpensesPerMonth SET price = price + ? WHERE date = ?",
          ["$price", "$month"]);
    }
  }

  Future<void> deleteExpense(int id) async {
    Database db = await database;
    db.rawDelete("DELETE FROM Expenses WHERE id = ?", ["$id"]);
  }

  Future<void> decreaseExpensePerMonth(DateTime date, double price) async {
    Database db = await database;
    DateTime month = DateTime(date.year, date.month);
    List<Map> query = await db.rawQuery(
        "SELECT price FROM ExpensesPerMonth WHERE date = ?;", ["$month"]);
    double pricePerMonth = query[0]["price"];
    if (pricePerMonth - price > 0) {
      db.rawUpdate(
          "UPDATE ExpensesPerMonth SET price = price - ? WHERE date = ?",
          ["$price", "$month"]);
    } else {
      db.rawDelete("DELETE FROM ExpensesPerMonth WHERE date = ?", ["$month"]);
    }
  }

  Future<Expense> getItemToEdit(int id) async {
    Database db = await database;
    List<Map> query =
        await db.rawQuery("SELECT * FROM Expenses WHERE id = ?;", ["$id"]);
    Expense item = Expense(query[0]["id"], DateTime.parse(query[0]["date"]),
        query[0]["name"], query[0]["price"]);
    return item;
  }

  Future<void> updateExpense(int id, String newName, double newPrice) async {
    Database db = await database;
    db.rawUpdate("UPDATE Expenses Set name = ?, price = ? WHERE id = ?",
        ["$newName", "$newPrice", "$id"]);
  }
}
