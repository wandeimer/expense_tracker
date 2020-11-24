import 'package:expense_tracker/AddExpense.dart';
import 'package:expense_tracker/EditExpense.dart';
import 'package:expense_tracker/ExpenseModel.dart';
import 'package:expense_tracker/ExpensesPerMonth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense tracker',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'My Expenses'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  double totalExpense;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpenseModel>(
      model: ExpenseModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ScopedModelDescendant<ExpenseModel>(
          builder: (context, child, model) => ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  totalExpense = model.getTotalExpense();
                  return ListTile(
                    title: Text("Total expense: $totalExpense"),
                  );
                } else {
                  index -= 1;
                  return Dismissible(
                      //direction: DismissDirection.endToStart,
                      key: Key(model.getKey(index)),
                      background: Container(
                        color: Colors.green,
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                      child: ListTile(
                        title: Text(model.getText(index)),
                      ),
                      confirmDismiss: (direction) async => confirm(direction, context, "$index", model, index),
                    );
                }
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: model.recordsCount + 1),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ScopedModelDescendant<ExpenseModel>(
            builder: (context, child, model) => Container(
                    child: Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ExpensesPerMonth(model);
                            }));
                          },
                          child: Icon(Icons.list),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return AddExpense(model);
                            }));
                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}

Future<bool> confirm(direction, context, String text, ExpenseModel model, int index) async {
    if (direction == DismissDirection.endToStart) {
      final bool res = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                  model.getTextToDelete(index)),
                  //"Are you sure you want to delete $text?"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    model.deleteExpense(index);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return res;
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return EditExpense(model, index);
          }));
    }
}
