import 'package:expense_tracker/AddExpense.dart';
import 'package:expense_tracker/ExpenseModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  double totalExpense = 0;

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
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      model.deleteExpense(index);
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Deleted record $index")));
                    },
                    child: ListTile(
                      title: Text(model.getText(index)),
                      leading: Icon(Icons.attach_money),
                      trailing: Icon(Icons.delete),
                    ),
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
              children: <Widget> [
                Align(
                  alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) {return EditExpense(model);}));
                      },
                      child: Icon(Icons.edit),
                    ),
                ),
                Spacer(
                  flex: 1,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AddExpense(model);
                      }));
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            )
          )
        ),
      ),
    );
  }
}
