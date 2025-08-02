import 'package:flutter/material.dart';
import 'package:intetership_project/feature/home/data/models/company_model.dart';

class CompanyFormDialog extends StatefulWidget {
  final CompanyModel? company;

  const CompanyFormDialog({super.key, this.company});

  @override
  State<CompanyFormDialog> createState() => _CompanyFormDialogState();
}

class _CompanyFormDialogState extends State<CompanyFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company?.name ?? '');
    _descriptionController = TextEditingController(text: widget.company?.description ?? '');
  }

  @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final fontSize = screenWidth * 0.045;
  final padding = screenWidth * 0.04;

  return AlertDialog(
    title: Text(
      widget.company == null ? 'Добавить компанию' : 'Редактировать компанию',
      style: TextStyle(fontSize: fontSize.clamp(16, 20), fontWeight: FontWeight.w600),
    ),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Название компании',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize.clamp(14, 16),
                color: Colors.black87,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(
                vertical: padding.clamp(12, 20),
                horizontal: padding.clamp(12, 20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Введите название' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Описание компании',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize.clamp(14, 16),
                color: Colors.black87,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(
                vertical: padding.clamp(12, 20),
                horizontal: padding.clamp(12, 20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Введите описание' : null,
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Отмена',
          style: TextStyle(fontSize: fontSize.clamp(14, 16)),
        ),
      ),
      SizedBox(width: 10),
      SizedBox(
        width: screenWidth * 0.35,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newCompany = CompanyModel(
                id: widget.company?.id ?? 0,
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Компания сохранена'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pop(context, newCompany);
              });
            }
          },
          child: Text(
            'Сохранить',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontSize.clamp(14, 16),
            ),
          ),
        ),
      ),
    ],
  );
}
}