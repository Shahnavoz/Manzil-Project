import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature/favourite/data/favourite_provider.dart';
import 'package:intetership_project/feature/profile/presentation/blocs/favourite_provider.dart';
import 'package:intetership_project/feature/profile/presentation/blocs/filter_provider.dart';
import 'package:intetership_project/feature/profile/presentation/blocs/theme_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 600;

    final horizontalPadding = isNarrow ? 16.0 : 24.0;
    final verticalSpacing = isNarrow ? 10.0 : 14.0;
    final titleFontSize = isNarrow ? 18.0 : 20.0;
    final buttonFontSize = isNarrow ? 14.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 114, 182),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          splashRadius: 22,
          tooltip: 'Назад',
        ),
        title: Text(
          "Настройки",
          style: TextStyle(color: Colors.white, fontSize: titleFontSize, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: verticalSpacing),
              _buildActionButton(
                'Очистить избранное',
                Icons.favorite_border,
                Colors.redAccent,
                buttonFontSize,
                () {
                  ref.read(favouriteBuildingsProvider.notifier).clearFavourites();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Избранное очищено')),
                  );
                },
              ),
              SizedBox(height: verticalSpacing),
              _buildActionButton(
                'Переключить тему',
                Icons.brightness_6,
                Colors.blueGrey,
                buttonFontSize,
                () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    double fontSize,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: fontSize + 4),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
