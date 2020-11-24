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
    String date = e.date.day.toString() +
        " " +
        monthToName(e.date.month) +
        " " +
        e.date.hour.toString() +
        ":" +
        e.date.minute.toString();
    return e.name + " for " + e.price.toString() + "\n" + date;
  }

  String getTextPerMonth(int index) {
    var e = _monthItems[index];
    return "Total " +
        e.expense.toString() +
        " spend " +
        " in\n" +
        monthToName(e.month.month) +
        " of " +
        e.month.year.toString();
    //return "For " + monthToName(e.month.month) + " " + e.month.year.toString() + " spend " + e.expense.toString();
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

  getKey(int index) {
    return _items[index].id.toString();
  }

  Expense getItemToEdit(int index) {
    return _items[index];
  }

  void updateExpense(int id, String newName, double newPrice) {
    Future<void> future = _database.updateExpense(id, newName, newPrice);
    future.then((_) => load());
    notifyListeners();
  }

  String monthToName(int month) {
    String monthName;
    switch (month) {
      case 1:
        {
          monthName = "January";
        }
        break;

      case 2:
        {
          monthName = "February";
        }
        break;

      case 3:
        {
          monthName = "March";
        }
        break;

      case 4:
        {
          monthName = "April";
        }
        break;

      case 5:
        {
          monthName = "May";
        }
        break;

      case 6:
        {
          monthName = "June";
        }
        break;

      case 7:
        {
          monthName = "July";
        }
        break;

      case 8:
        {
          monthName = "August";
        }
        break;

      case 9:
        {
          monthName = "September";
        }
        break;

      case 10:
        {
          monthName = "October";
        }
        break;

      case 11:
        {
          monthName = "November";
        }
        break;

      case 12:
        {
          monthName = "December";
        }
        break;
    }
    return monthName;
  }

  String getTextToDelete(int index) {
    Expense item = _items[index];
    return "Are you sure you want to delete \n" +
        item.name +
        " for " +
        monthToName(item.date.month) +
        " " +
        item.date.day.toString() +
        "?";
  }
}
