import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpenseModel extends Model {
  final List<Expense> _items = [
    Expense(1, DateTime.now(), "Car", 1000),
    Expense(2, DateTime.now(), "Food", 645),
    Expense(3, DateTime.now(), "Stuff", 788),
  ];

  int _idGenerator = 3;

  int get recordsCount => _items.length;

  String GetKey(int index) {
    return _items[index].id.toString();
  }

  String GetText(int index) {
    var e = _items[index];
    return e.name + " for " + e.price.toString() + "\n" + e.date.toString();
  }

  void removeAtIndex(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void addExpense(String name, double price) {
    _idGenerator += 1;
    var e = Expense(_idGenerator, DateTime.now(), name, price);
    _items.add(e);
    notifyListeners();
  }

}