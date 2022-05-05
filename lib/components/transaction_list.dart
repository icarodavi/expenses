import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transacation_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) removeTransaction;
  const TransactionList(this.transactions, this.removeTransaction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .15),
                  Text(
                    'Sem transação cadastrada',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: constraints.maxHeight * .15),
                  Container(
                    height: constraints.maxHeight * .5,
                    margin: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];

              return TransactionItem(
                  key: ValueKey(tr.id),
                  tr: tr,
                  mediaQuery: _mediaQuery,
                  removeTransaction: removeTransaction);
            },
          );
  }
}
