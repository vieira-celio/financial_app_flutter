import 'package:financial_tracker/common/patterns/result.dart';
import 'package:financial_tracker/data/repositories/transaction_repository_impl.dart';
import 'package:financial_tracker/data/services/transaction_fake_service_impl.dart';
import 'package:financial_tracker/domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTransactionForm extends StatefulWidget {
  final TransactionEntity transaction;

  const EditTransactionForm({super.key, required this.transaction});

  @override
  State<EditTransactionForm> createState() => _EditTransactionFormState();
}

class _EditTransactionFormState extends State<EditTransactionForm> {
  final TransactionRepositoryImpl repository = TransactionRepositoryImpl(
    dataSource: TransactionFakeServiceImpl(),
  );

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late TransactionType _selectedType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    _selectedDate = widget.transaction.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final updatedTransaction = TransactionEntity(
      id: widget.transaction.id,
      title: _titleController.text,
      amount: double.tryParse(_amountController.text) ?? 0.0,
      date: _selectedDate,
      type: _selectedType,
    );

    final result = await repository.editTransaction(updatedTransaction);

    if (result is Success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação editada com sucesso!')),
      );
      Navigator.pop(context);
    } else if (result is Error) {
      final failure = (result as Error).value;
      final errorMessage = failure.message;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao editar: $errorMessage')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.transaction.type.nameSingular}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Valor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Digite um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Salvar Alterações'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
