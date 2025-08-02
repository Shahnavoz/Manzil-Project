import 'package:flutter/material.dart';
import 'package:intetership_project/feature/home/data/models/company_model.dart';
import 'package:intetership_project/feature/home/data/repos/company_service.dart';
import 'package:intetership_project/feature_admin/controll_companies/presentation/pages/company_form_dialog.dart';

class AdminControlCompanyPage extends StatefulWidget {
  const AdminControlCompanyPage({super.key});

  @override
  State<AdminControlCompanyPage> createState() =>
      _AdminControlCompanyPageState();
}

class _AdminControlCompanyPageState extends State<AdminControlCompanyPage> {
  List<CompanyModel> _companies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() => _isLoading = true);
    try {
      _companies = await CompanyService().getCompaniesFromBack();
    } catch (e) {
      debugPrint('Ошибка загрузки компаний: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки данных')));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _addOrEditCompany({CompanyModel? company}) async {
    final result = await showDialog<CompanyModel>(
      context: context,
      builder: (context) => CompanyFormDialog(company: company),
    );

    if (result != null) {
      if (company == null) {
        await CompanyService().createCompany(result);
      } else {
        await CompanyService().updateCompany(result, company.id!);
      }
      _loadCompanies();
    }
  }

  Future<void> _deleteCompany(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Удалить компанию'),
            content: const Text('Вы уверены, что хотите удалить эту компанию?'),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            actions: [
              SizedBox(
                width: 110,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey.shade600,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Отмена'),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 110,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Удалить'),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await CompanyService().deleteCompany(id);
      _loadCompanies(); // обновляем список после удаления
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.06; // адаптивный размер иконок
    final fontSize = screenWidth * 0.045; // размер заголовка
    final paddingH = screenWidth * 0.05;
    final paddingV = screenWidth * 0.010;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: iconSize.clamp(24, 30),
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Управление компаниями',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize.clamp(16, 20),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 36, 119, 187),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadCompanies,
                child: ListView.builder(
                  itemCount: _companies.length,
                  itemBuilder: (context, index) {
                    final company = _companies[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: paddingH,
                        vertical: paddingV,
                      ),
                      child: Card(
                        // margin: const EdgeInsets.all(8),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: paddingH * 0.8,
                            vertical: paddingV,
                          ),
                          title: Text(
                            company.name,
                            style: TextStyle(
                              fontSize: fontSize.clamp(16, 18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            company.description ?? '',
                            style: TextStyle(fontSize: fontSize.clamp(12, 14)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: iconSize.clamp(20, 26),
                                ),
                                onPressed:
                                    () => _addOrEditCompany(company: company),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: iconSize.clamp(20, 26),
                                ),
                                onPressed: () => _deleteCompany(company.id!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Company',
        onPressed: () => _addOrEditCompany(),
        backgroundColor: const Color.fromARGB(255, 36, 119, 187),
        child: Icon(
          Icons.add,
          size: iconSize.clamp(22, 28),
          color: Colors.white,
        ),
      ),
    );
  }
}
