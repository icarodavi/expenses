import 'dart:math';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

import 'components/chart.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';

void main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({Key? key}) : super(key: key);
  final ThemeData tema = ThemeData(fontFamily: 'OpenSans');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
            primary: Colors.purple[700],
            secondary: Colors.amber,
          ),
          textTheme: tema.textTheme.copyWith(
              headline6: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              button: const TextStyle(
                color: Colors.white,
              )),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transaction = [];
  bool _showChart = false;
  bool _ran = false;

  List<Transaction> get _recentTransactions {
    return _transaction.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  _addTransaction(String title, double value, DateTime date) {
    var newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    setState(() {
      _transaction.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transaction.removeWhere((element) => element.id == id);
    });
  }

  _generate() {
    if (!_ran) {
      for (var i = 0; i <= 10; i++) {
        _transaction.add(Transaction(
          date: DateTime.now().subtract(Duration(days: Random().nextInt(7))),
          id: Random().nextDouble().toString(),
          title: 'Title ${Random().nextInt(100)}',
          value: double.parse(Random().nextInt(1000).toString()),
        ));
      }
    }
    _ran = true;
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    _generate();
    bool isLandscape = _mediaQuery.orientation == Orientation.landscape;
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text('Despesas Pessoais'),
      actions: <Widget>[
        if (isLandscape)
          IconButton(
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
              icon: Icon(_showChart ? Icons.list : Icons.bar_chart)),
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: const Icon(Icons.add),
          color: Colors.white,
        ),
      ],
    );
    final availableHeight = _mediaQuery.size.height -
        appBar.preferredSize.height -
        _mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_showChart || !isLandscape)
                Container(
                  height: availableHeight * (isLandscape ? .45 : 0.25),
                  child: Chart(_recentTransactions),
                ),
              Container(
                height:
                    availableHeight * ((isLandscape && !_showChart) ? 1 : .75),
                child: TransactionList(_transaction, _removeTransaction),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        foregroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => _openTransactionFormModal(context),
      ),
    );
  }
}
