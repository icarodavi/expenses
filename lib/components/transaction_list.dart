import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) removeTransaction;
  const TransactionList(this.transactions, this.removeTransaction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text('R\$ ${tr.value.toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    tr.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(DateFormat('d MMM y').format(tr.date)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeTransaction(tr.id),
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            },
          );
  }
}
