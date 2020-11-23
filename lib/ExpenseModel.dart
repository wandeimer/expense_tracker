import 'package:expense_tracker/ExpenseDB.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpenseModel extends Model {
  List<Expense> _items = [];

  double _totalExpense = 0;

  ExpenseDB _database;

  int get recordsCount => _items.length;

  ExpenseModel() {
    _database = ExpenseDB();
    load();
  }

  void load() {
    Future<List<Expense>> future = _database.getAllExpenses();
    future.then((list) {
      _items = list;
      _totalExpense = _countTotalExpense();
      notifyListeners();
    });
  }

  String getKey(int index) {
    return _items[index].id.toString();
  }

  String getText(int index) {
    var e = _items[index];
    return e.name + " for " + e.price.toString() + "\n" + e.date.toString();
  }

  void deleteExpense(int index) {
    _totalExpense -= _items[index].price;
    final int id = _items[index].id;
    _items.removeAt(index);
    Future<void> future = _database.deleteExpense(id);
    future.then((_) {
      load();
    });
    notifyListeners();
  }

  void addExpense(String name, double price) {
    Future<void> future = _database.addExpense(name, price, DateTime.now());
    future.then((_) {
      load();
    });
    notifyListeners();
  }

  double _countTotalExpense() {
    double totalExpense = 0;
    for (var i in _items) {
      totalExpense += i.price;
    }
    return totalExpense;
  }

  double getTotalExpense() {
    return _totalExpense;
  }

}