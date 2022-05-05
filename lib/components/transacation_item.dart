import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.tr,
    required MediaQueryData mediaQuery,
    required this.removeTransaction,
  })  : _mediaQuery = mediaQuery,
        super(key: key);

  final Transaction tr;
  final MediaQueryData _mediaQuery;
  final void Function(String p1) removeTransaction;

  @override
  Widget build(BuildContext context) {
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
        trailing: _mediaQuery.size.width > 600
            ? TextButton.icon(
                onPressed: () => removeTransaction(tr.id),
                icon: const Icon(Icons.delete),
                label: const Text('Excluir'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).buttonTheme.colorScheme!.error),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => removeTransaction(tr.id),
                color: Theme.of(context).colorScheme.error,
              ),
      ),
    );
  }
}
