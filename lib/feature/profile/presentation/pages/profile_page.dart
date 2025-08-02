import 'package:flutter/material.dart';
import 'package:intetership_project/consts/colors.dart';
import 'package:intetership_project/feature/profile/presentation/pages/edit_profile_page.dart';
import 'package:intetership_project/feature/profile/presentation/pages/faq_page.dart';
import 'package:intetership_project/feature/profile/presentation/widgets/settings_page.dart';
import 'package:intetership_project/feature/registration/pages/login_page.dart';
import 'package:intetership_project/feature/registration/pages/logout_page.dart';
import '../../data/repos/profile_service.dart';
import '../../data/models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  ProfileModel? _userProfile;
  ProfileModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _profileService.getUserInfo();
      final currentUser = await _profileService.getCurrentUser();

      setState(() {
        _userProfile = profile;
        _currentUser = currentUser;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _fullName {
    if (_userProfile != null) {
      return '${_userProfile!.firstName} ${_userProfile!.lastName}';
    } else if (_currentUser != null) {
      final firstName = _currentUser!.firstName ?? '';
      final lastName = _currentUser!.lastName ?? '';
      return '$firstName $lastName'.trim();
    }
    return 'User';
  }

  String get _email {
    if (_userProfile != null) {
      return _userProfile!.email;
    } else if (_currentUser != null) {
      return _currentUser!.email ?? '';
    }
    return '';
  }

  String get _phoneNumber {
    if (_userProfile != null) {
      return _userProfile!.phoneNumber ?? '';
    } else if (_currentUser != null) {
      return _currentUser!.phoneNumber ?? '';
    }
    return '';
  }

  String get _username {
    if (_userProfile != null) {
      return _userProfile!.userName;
    } else if (_currentUser != null) {
      return _currentUser!.userName ?? '';
    }
    return '';
  }

  String get _userImage {
    if (_userProfile != null) {
      return _userProfile!.profilePicture ?? '';
    } else if (_currentUser != null) {
      return _currentUser!.profilePicture ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 600;

    final headerPadding = EdgeInsets.symmetric(
      horizontal: isNarrow ? 16 : 24,
      vertical: isNarrow ? 18 : 24,
    );
    final avatarRadius = isNarrow ? 44.0 : 54.0;
    final nameFontSize = isNarrow ? 22.0 : 28.0;
    final roleFontSize = isNarrow ? 16.0 : 20.0;
    final infoTitleSize = isNarrow ? 16.0 : 18.0;
    final infoTextSize = isNarrow ? 13.0 : 14.0;
    final actionFontSize = isNarrow ? 14.0 : 16.0;

    return Scaffold(
      // backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(color: const Color(0xFF6D5BFF)),
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadUserProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6D5BFF),
                              Color(0xFF46A0FC),
                              Color(0xFF23D2B7),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: headerPadding,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Аватар
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.18),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: avatarRadius,
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(avatarRadius),
                                        child: _userImage.isEmpty
                                            ? Icon(
                                                Icons.person,
                                                size: avatarRadius + 10,
                                                color: const Color(0xFF6D5BFF),
                                              )
                                            : Image.asset(
                                                _userImage,
                                                fit: BoxFit.cover,
                                                color: backLearGradient1,
                                                colorBlendMode: BlendMode.srcIn,
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isNarrow ? 14 : 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _fullName,
                                          style: TextStyle(
                                            fontSize: nameFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          _email == 'admin@gmail.com' ? 'Admin' : 'User',
                                          style: TextStyle(
                                            fontSize: roleFontSize,
                                            color: Colors.white.withOpacity(0.9),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.white.withOpacity(0.8),
                                              size: isNarrow ? 14 : 16,
                                            ),
                                            SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                'Душанбе, Тоҷикистон',
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.8),
                                                  fontSize: isNarrow ? 12 : 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfilePage(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    iconSize: isNarrow ? 22 : 26,
                                    tooltip: 'Таҳрири профил',
                                  ),
                                ],
                              ),
                              SizedBox(height: isNarrow ? 12 : 20),
                            ],
                          ),
                        ),
                      ),

                      // Info & actions
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 16 : 24,
                          vertical: isNarrow ? 16 : 20,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            _buildInfoSection(
                              'Маълумоти тамос',
                              '',
                              Icons.contact_phone,
                              const Color(0xFF46A0FC),
                              isContact: true,
                              titleFontSize: infoTitleSize,
                              textFontSize: infoTextSize,
                            ),
                            SizedBox(height: isNarrow ? 16 : 24),
                            _buildActionButtons(actionFontSize),
                            SizedBox(height: isNarrow ? 12 : 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    String content,
    IconData icon,
    Color color, {
    bool isContact = false,
    bool isSkills = false,
    double titleFontSize = 18,
    double textFontSize = 14,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isContact) ...[
            _buildContactItem(Icons.email, _email.isNotEmpty ? _email : 'No email available', textFontSize),
            const SizedBox(height: 10),
            _buildContactItem(Icons.phone, _phoneNumber.isNotEmpty ? _phoneNumber : 'No phone available', textFontSize),
            const SizedBox(height: 10),
            _buildContactItem(Icons.person, _username.isNotEmpty ? 'Номи истифода: $_username' : 'No username available', textFontSize),
          ] else if (isSkills) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSkillChip('Flutter'),
                _buildSkillChip('Dart'),
                _buildSkillChip('Firebase'),
                _buildSkillChip('REST API'),
                _buildSkillChip('Git'),
                _buildSkillChip('UI/UX Design'),
                _buildSkillChip('Agile'),
                _buildSkillChip('Team Leadership'),
              ],
            ),
          ] else ...[
            Text(
              content,
              style: TextStyle(
                fontSize: textFontSize,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, double fontSize) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF23D2B7).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF23D2B7).withOpacity(0.3)),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF23D2B7),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButtons(double fontSize) {
    return Column(
      children: [
        _buildActionButton('Таҳрири профил', Icons.edit, const Color(0xFF6D5BFF), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfilePage()),
          );
        }, fontSize),
        const SizedBox(height: 12),
        _buildActionButton('Танзимот', Icons.settings, const Color(0xFF46A0FC), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        }, fontSize),
        const SizedBox(height: 12),
        _buildActionButton('Саволҳои маъмул', Icons.help, const Color(0xFF23D2B7), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FaqPage()),
          );
        }, fontSize),
        const SizedBox(height: 12),
        _buildActionButton(
          'Баромадан',
          Icons.logout,
          Colors.red,
          () => confirmLogout(context),
          fontSize,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    double fontSize,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: fontSize + 4),
        label: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
