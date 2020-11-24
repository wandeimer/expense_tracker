class Expense {
  final int id;
  final DateTime date;
  final String name;
  final double price;

  Expense(this.id, this.date, this.name, this.price);
}

class Month {
  final int id;
  final DateTime month;
  final double expense;

  Month(this.id, this.month, this.expense);
}
