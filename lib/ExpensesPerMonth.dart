import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ExpenseModel.dart';

class ExpensesPerMonth extends StatelessWidget {
  final String _title = "Expenses per month";
  ExpenseModel _model;
  ExpensesPerMonth(this._model);
  double totalExpense = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  totalExpense = _model.getTotalExpense();
                  return ListTile(
                    title: Text("Total expense: $totalExpense"),
                  );
                } else {
                  index -= 1;
                  return ListTile(
                      title: Text(_model.getTextPerMonth(index)),
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: _model.recordsMonthCount + 1),
        );
  }
}
