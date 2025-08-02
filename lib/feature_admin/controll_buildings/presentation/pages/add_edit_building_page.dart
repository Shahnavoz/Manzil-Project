// import 'package:flutter/material.dart';
// import 'package:intetership_project/feature/home/data/models/building_model.dart';
// import 'package:intetership_project/feature/home/data/repos/building_service.dart';

// class AddEditBuildingPage extends StatefulWidget {
//   final BuildingModel? building;

//   const AddEditBuildingPage({super.key, this.building});

//   @override
//   State<AddEditBuildingPage> createState() => _AddEditBuildingPageState();
// }

// class _AddEditBuildingPageState extends State<AddEditBuildingPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _flatsCountController = TextEditingController();
//   final TextEditingController _floorCountController = TextEditingController();
//   final TextEditingController _latitudeCountController =
//       TextEditingController();
//   final TextEditingController _longitudeController = TextEditingController();

//   bool isSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.building != null) {
//       _nameController.text = widget.building!.name ?? '';
//       _addressController.text = widget.building!.address ?? '';
//       _descriptionController.text = widget.building!.description ?? '';
//       _flatsCountController.text =
//           widget.building!.flats_count != null
//               ? widget.building!.flats_count.toString()
//               : '';
//       _floorCountController.text =
//           widget.building!.floors_count != null
//               ? widget.building!.floors_count.toString()
//               : '';
//       _longitudeController.text =
//           widget.building!.longitude != null
//               ? widget.building!.longitude.toString()
//               : '';
//       _latitudeCountController.text =
//           widget.building!.latitude != null
//               ? widget.building!.latitude.toString()
//               : '';
//     }
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isSaving = true);
//     final name = _nameController.text.trim();

//     try {
//       if (widget.building == null) {
//         await BuildingService().createBuilding(
//           BuildingModel(
//             id: 0,
//             name: name,
//             description: _descriptionController.text.trim(),
//             flats_count: int.parse(_flatsCountController.text.trim()),
//             floors_count: int.parse(_floorCountController.text.trim()),
//             longitude: double.parse(_longitudeController.text.trim()),
//             latitude: double.parse(_latitudeCountController.text.trim()),
//             address: _addressController.text.trim(),
//             image: '',
//             model_3d: '',
//             company: 0,
//           ),
//         );
//       } else {
//         await BuildingService().updateBuilding(
//           BuildingModel(
//             id: widget.building!.id!,
//             name: name,
//             description: _descriptionController.text.trim(),
//             flats_count: int.parse(_flatsCountController.text.trim()),
//             floors_count: int.parse(_floorCountController.text.trim()),
//             longitude: double.parse(_longitudeController.text.trim()),
//             latitude: double.parse(_latitudeCountController.text.trim()),
//             address: _addressController.text.trim(),
//             image: '',
//             model_3d: '',
//             company: 0,
//           ),
//           widget.building!.id!,
//         );
//       }
//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Ошибка сохранения")));
//     } finally {
//       setState(() => isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.building != null;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
//           ),
//         ),
//         title: Text(
//           isEditing ? 'Редактировать здание' : 'Добавить здание',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 44, 123, 187),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Header Card
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C7BBB), Color(0xFF1E5A8A)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         isEditing ? Icons.edit : Icons.add_business,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             isEditing ? 'Редактирование' : 'Новое здание',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             isEditing
//                                 ? 'Обновите информацию о здании'
//                                 : 'Заполните данные для нового здания',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.9),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Form Fields Card
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Основная информация',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF2C3E50),
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       _buildTextField(
//                         controller: _nameController,
//                         label: 'Номи бино',
//                         icon: Icons.business,
//                         isRequired: true,
//                       ),
//                       const SizedBox(height: 16),

//                       _buildTextField(
//                         controller: _addressController,
//                         label: 'Суроғаи бино',
//                         icon: Icons.location_on,
//                         isRequired: true,
//                       ),
//                       const SizedBox(height: 16),

//                       _buildTextField(
//                         controller: _descriptionController,
//                         label: 'Тавсифи бино',
//                         icon: Icons.description,
//                         maxLines: 3,
//                         isRequired: true,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Technical Details Card
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Технические характеристики',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF2C3E50),
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildTextField(
//                               controller: _flatsCountController,
//                               label: 'Шумораи ошёна',
//                               icon: Icons.layers,
//                               keyboardType: TextInputType.number,
//                               isRequired: true,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: _buildTextField(
//                               controller: _floorCountController,
//                               label: 'Шумораи хонаҳо дар ошёна',
//                               icon: Icons.home,
//                               keyboardType: TextInputType.number,
//                               isRequired: true,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Location Card
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Географические координаты',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF2C3E50),
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildTextField(
//                               controller: _longitudeController,
//                               label: 'Дарозии ҷуғрофӣ',
//                               icon: Icons.explore,
//                               keyboardType: TextInputType.number,
//                               isRequired: true,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: _buildTextField(
//                               controller: _latitudeCountController,
//                               label: 'Барии ҷуғрофӣ',
//                               icon: Icons.explore_outlined,
//                               keyboardType: TextInputType.number,
//                               isRequired: true,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 32),

//               // Save Button
//               Container(
//                 height: 56,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF2C7BBB), Color(0xFF1E5A8A)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF2C7BBB).withOpacity(0.3),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: ElevatedButton(
//                   onPressed: isSaving ? null : _save,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child:
//                       isSaving
//                           ? const SizedBox(
//                             height: 24,
//                             width: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                           : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 isEditing ? Icons.save : Icons.add,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 isEditing ? 'Сохранить' : 'Добавить',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool isRequired = false,
//     int maxLines = 1,
//     TextInputType? keyboardType,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FA),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
//       ),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: const Color(0xFF6C757D), size: 20),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//           labelStyle: const TextStyle(color: Color(0xFF6C757D), fontSize: 14),
//         ),
//         validator: (value) {
//           if (isRequired && (value == null || value.isEmpty)) {
//             return label;
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intetership_project/feature/home/data/models/building_model.dart';
import 'package:intetership_project/feature/home/data/repos/building_service.dart';
import 'package:intetership_project/feature/home/data/repos/company_service.dart';

class AddEditBuildingPage extends StatefulWidget {
  final BuildingModel? building;

  const AddEditBuildingPage({super.key, this.building});

  @override
  State<AddEditBuildingPage> createState() => _AddEditBuildingPageState();
}

class _AddEditBuildingPageState extends State<AddEditBuildingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _floorCountsController = TextEditingController();
  final TextEditingController _flatCountsController = TextEditingController();

  int? _selectedCompanyId;
  List<Map<String, dynamic>> _companies = [];

  @override
  void initState() {
    super.initState();
    _loadCompanies();

    if (widget.building != null) {
      _nameController.text = widget.building!.name ?? '';
      _descriptionController.text = widget.building!.description ?? '';
      _addressController.text = widget.building!.address ?? '';
      _longitudeController.text = widget.building!.longitude?.toString() ?? '';
      _latitudeController.text = widget.building!.latitude?.toString() ?? '';
      _floorCountsController.text =
          widget.building!.floors_count?.toString() ?? '';
      _flatCountsController.text =
          widget.building!.flats_count?.toString() ?? '';
      _selectedCompanyId = widget.building!.company;
    }
  }

  Future<void> _loadCompanies() async {
    final result = await CompanyService().getCompaniesFromBack();
    setState(() {
      _companies =
          result
              .map((e) => {'id': e.id, 'name': e.name})
              .toList()
              .cast<Map<String, dynamic>>();
    });
  }

  Future<void> _saveBuilding() async {
    if (_formKey.currentState!.validate()) {
      final building = BuildingModel(
        id: widget.building?.id ?? 0,
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        longitude: double.tryParse(_longitudeController.text)!,
        latitude: double.tryParse(_latitudeController.text)!,
        floors_count: int.tryParse(_floorCountsController.text)!,
        flats_count: int.tryParse(_flatCountsController.text)!,
        company: _selectedCompanyId!,
        image: '',
        model_3d: '',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Здание сохранена'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      if (widget.building == null) {
        await BuildingService().createBuilding(building);
      } else {
        await BuildingService().updateBuilding(building, building.id);
      }

      // Только один Navigator.pop, с возвратом обновлённого здания
      if (context.mounted) {
        Navigator.pop(context, building);
      }
    }
  }

  Widget _buildFieldCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double baseFont = screenWidth * 0.04; // адаптивный размер шрифта
    final double titleFont = screenWidth * 0.045;
    final double iconSize = screenWidth * 0.06;
    final double paddingSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: iconSize.clamp(22, 28),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF2C7BBB),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          widget.building == null ? 'Иловаи бино' : 'Тағйири бино',
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFont.clamp(16, 22),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:
            _companies.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Header Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2C7BBB), Color(0xFF1E5A8A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                widget.building == null
                                    ? Icons.add_business
                                    : Icons.edit,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.building == null
                                        ? 'Новое здание'
                                        : 'Редактирование',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.building == null
                                        ? 'Заполните данные для нового здания'
                                        : 'Обновите информацию о здании',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Main Info Card
                      _buildFieldCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Маълумоти бино',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildLabeledField(
                              context: context,
                              label: 'Номи бино',
                              child: TextFormField(
                                controller: _nameController,
                                decoration: _inputDecoration(
                                  'Номи бино',
                                  context,
                                  icon: Icons.location_city,
                                ),
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? 'Ин майдонро пур кунед'
                                            : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildLabeledField(
                              context: context,
                              label: 'Тавсиф',
                              child: TextFormField(
                                controller: _descriptionController,
                                decoration: _inputDecoration(
                                  'Тавсиф',
                                  context,
                                  icon: Icons.description,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildLabeledField(
                              context: context,
                              label: 'Суроға',
                              child: TextFormField(
                                controller: _addressController,
                                decoration: _inputDecoration(
                                  'Суроға',
                                  context,
                                  icon: Icons.place,
                                ),
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? 'Ин майдонро пур кунед'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Technical Details Card
                      _buildFieldCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Тех. маълумот',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildLabeledField(
                                    context: context,
                                    label: 'Ошёнаҳо',
                                    child: TextFormField(
                                      controller: _floorCountsController,
                                      decoration: _inputDecoration(
                                        'Шумораи ошёнаҳо',
                                        context,
                                        icon: Icons.apartment,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildLabeledField(
                                    context: context,
                                    label: 'Хонаҳо',
                                    child: TextFormField(
                                      controller: _flatCountsController,
                                      decoration: _inputDecoration(
                                        'Шумораи хонаҳо',
                                        context,
                                        icon: Icons.home_work,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Location Card
                      _buildFieldCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Географические координаты',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildLabeledField(
                                    context: context,
                                    label: 'Дарозии ҷуғрофӣ',
                                    child: TextFormField(
                                      controller: _longitudeController,
                                      decoration: _inputDecoration(
                                        'Дарозии ҷуғрофӣ',
                                        context,
                                        icon: Icons.straighten,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildLabeledField(
                                    context: context,
                                    label: 'Бари ҷуғрофӣ',
                                    child: TextFormField(
                                      controller: _latitudeController,
                                      decoration: _inputDecoration(
                                        'бари ҷуғрофӣ',
                                        context,
                                        icon: Icons.straighten,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Company Card
                      _buildFieldCard(
                        child: _buildLabeledField(
                          context: context,
                          label: 'Ширкат',
                          child: DropdownButtonFormField<int>(
                            value: _selectedCompanyId,
                            decoration: _inputDecoration(
                              'Ширкат',
                              context,
                              icon: Icons.business,
                            ),
                            items:
                                _companies.map((company) {
                                  return DropdownMenuItem<int>(
                                    value: company['id'],
                                    child: Text(company['name']),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCompanyId = value!;
                              });
                            },
                            validator:
                                (value) =>
                                    value == null
                                        ? 'Лутфан ширкатро интихоб кунед'
                                        : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2C7BBB), Color(0xFF1E5A8A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2C7BBB).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _saveBuilding,
                          icon: Icon(
                            widget.building == null ? Icons.add : Icons.save,
                            color: Colors.white,
                          ),
                          label: Text(
                            widget.building == null ? 'Илова' : 'Ҳифз',
                            style: TextStyle(
                              fontSize: baseFont.clamp(14, 18),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

Widget _buildLabeledField({
  required String label,
  required Widget child,
  required BuildContext context,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final labelFont = screenWidth * 0.038;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: labelFont.clamp(12, 16),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2C7BBB),
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}

InputDecoration _inputDecoration(
  String label,
  BuildContext context, {
  IconData? icon,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final iconSize = screenWidth * 0.05;
  final labelFont = screenWidth * 0.035;

  return InputDecoration(
    labelText: label,
    prefixIcon:
        icon != null
            ? Icon(
              icon,
              color: const Color(0xFF6C757D),
              size: iconSize.clamp(18, 24),
            )
            : null,
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(
      horizontal: screenWidth * 0.04,
      vertical: screenWidth * 0.035,
    ),
    labelStyle: TextStyle(
      color: const Color(0xFF6C757D),
      fontSize: labelFont.clamp(12, 14),
    ),
  );
}
