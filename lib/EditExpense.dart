import 'package:expense_tracker/ExpenseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Expense.dart';

class _EditExpenseState extends State<EditExpense> {
  int _index;
  ExpenseModel _model;
  Expense _item;
  String _newName;
  double _newPrice;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _EditExpenseState(this._model, this._index);

  @override
  Widget build(BuildContext context) {
    _item = _model.getItemToEdit(_index);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _item.name,
                decoration: InputDecoration(
                    icon: Icon(Icons.shopping_basket),
                    hintText: "Bread",
                    helperText: "Name of expense"
                ),
                onSaved: (value) {
                  _newName = value;
                },
              ),
              TextFormField(
                initialValue: _item.price.toString(),
                decoration: InputDecoration(
                    icon: Icon(Icons.attach_money),
                    hintText: "3.5",
                    helperText: "Cost of expense"
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (double.tryParse(value) != null) {
                    return null;
                  } else {
                    return "Enter Valid Value";
                  }
                },
                onSaved: (value) {
                  _newPrice = double.parse(value);
                },
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    //_model.load();
                    _model.updateExpense(_item.id, _newName, _newPrice);
                    Navigator.pop(context);
                  }
                },
                child: Text("Accept changes"),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class EditExpense extends StatefulWidget {
  final ExpenseModel _model;
  final int _index;

  EditExpense(this._model, this._index);
  @override
  State<StatefulWidget> createState() => _EditExpenseState(_model, _index);

}