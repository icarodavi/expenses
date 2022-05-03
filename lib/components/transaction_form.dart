import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  void Function(String, double) addTransaction;
  TransactionForm(this.addTransaction, {Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  late Object? _selectedDate = '';

  _submitForm() {
    final title = _titleController.text;
    final value =
        double.tryParse(_valueController.text.replaceAll(',', '.')) ?? 0.00;
    if (title.isEmpty || value <= 0) {
      return;
    }
    widget.addTransaction(title, value);
  }

  _showDatePicker() {
    showDatePicker(
      // locale: ,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    ).then((pickedDate) {
      setState(() {
        if (pickedDate != null) {
          _selectedDate = pickedDate;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              onSubmitted: (_) => _submitForm(),
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
              ),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate is DateTime
                          ? DateFormat('dd/MM/y')
                              .format((_selectedDate as DateTime))
                          : 'Nenhuma data selecionada!',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Flexible(
                      child: TextButton(
                          onPressed: _showDatePicker,
                          child: const Text('Selecionar data')),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Nova Transação',
                      style: Theme.of(context).textTheme.button,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
