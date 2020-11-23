import 'package:expense_tracker/ExpenseDB.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpenseModel extends Model {
  List<Expense> _items = [];
  List<Month> _monthItems = [];

  double _totalExpense = 0;

  ExpenseDB _database;

  int get recordsCount => _items.length;
  int get recordsMonthCount => _monthItems.length;

  ExpenseModel() {
    _database = ExpenseDB();
    load();
    loadPerMonth();
  }

  void load() {
    Future<List<Expense>> future = _database.getAllExpenses();
    future.then((list) {
      _items = list;
      _totalExpense = _countTotalExpense();
      notifyListeners();
    });
  }

  void loadPerMonth() {
    Future<List<Month>> future = _database.getPerMonth();
    future.then((list) {
      _monthItems = list;
      notifyListeners();
    });
  }

  String getText(int index) {
    var e = _items[index];
    return e.name + " for " + e.price.toString() + "\n" + e.date.toString();
  }

  String getTextPerMonth(int index) {
    var e = _monthItems[index];
    return "For " + e.month.year.toString() + " - " + e.month.month.toString() + " spend " + e.expense.toString();
  }

  void deleteExpense(int index) {
    _totalExpense -= _items[index].price;
    final int id = _items[index].id;
    decreaseExpensePerMonth(_items[index].date, _items[index].price);
    _items.removeAt(index);
    Future<void> future = _database.deleteExpense(id);
    future.then((_) {
      load();
    });
    notifyListeners();
  }

  void decreaseExpensePerMonth(DateTime date, double price) {
    Future<void> future = _database.decreaseExpensePerMonth(date, price);
    future.then((_) {
      loadPerMonth();
    });
  }

  void addExpense(String name, double price) {
    DateTime date = DateTime.now();
    DateTime month = DateTime(date.year, date.month);
    addExpensePerMonth(month, price);
    Future<void> future = _database.addExpense(name, price, date);
    future.then((_) {
      load();
    });
    notifyListeners();
  }

  void addExpensePerMonth(DateTime date, double price) {
    Future<void> future = _database.addExpensePerMonth(date, price);
    future.then((_) {
      loadPerMonth();
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