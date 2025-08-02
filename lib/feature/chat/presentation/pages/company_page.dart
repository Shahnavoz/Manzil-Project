import 'package:flutter/material.dart';
import 'package:intetership_project/feature/chat/data/models/company_chat_list.dart';
import 'package:intetership_project/feature/chat/data/repos/chat_company_service.dart';
import 'package:intetership_project/feature/chat/data/repos/chat_service.dart';

class CompanyPage extends StatefulWidget {
  final int currentUserId;
  CompanyPage({super.key, required this.currentUserId});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  List<CompanyChatListModel> companies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    final company = await ChatCompanyService().fetchfromBackend();
    if (!mounted) return;
    setState(() {
      companies = company;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 600;
    final headerHeight = media.size.height * 0.08; // примерно 12% высоты устройства
    final horizontalPadding = isNarrow ? 16.0 : 24.0;
    final titleFontSize = isNarrow ? 24.0 : 28.0;
    final companyTitleSize = isNarrow ? 20.0 : 24.0;
    final companyDescSize = isNarrow ? 14.0 : 16.0;
    final cardRadius = 14.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Container(
              width: double.infinity,
              height: headerHeight,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 134, 176, 239),
                    Color.fromARGB(255, 79, 89, 107),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    iconSize: isNarrow ? 28 : 34,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(width: isNarrow ? 12 : 20),
                  Text(
                    "Компанияҳо",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Контент
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            color: const Color.fromARGB(255, 27, 94, 149),
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    : companies.isEmpty
                        ? Center(
                            child: Text(
                              'Нет company',
                              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: companies.length,
                            itemBuilder: (context, index) {
                              final company = companies[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: isNarrow ? 12 : 16),
                                child: GestureDetector(
                                  onTap: () async {
                                    await ChatService().handleCompanyTap(
                                      context,
                                      company,
                                      widget.currentUserId.toString(),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 169, 198, 222),
                                          Color.fromARGB(255, 27, 94, 149),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(cardRadius),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isNarrow ? 14 : 18,
                                      vertical: isNarrow ? 12 : 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          company.name,
                                          style: TextStyle(
                                            fontSize: companyTitleSize,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(255, 27, 94, 149),
                                          ),
                                        ),
                                        SizedBox(height: isNarrow ? 6 : 8),
                                        Text(
                                          company.description.toString(),
                                          style: TextStyle(
                                            fontSize: companyDescSize,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
