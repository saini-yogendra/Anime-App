import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF09090F),
      appBar: _appBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(top: -50, left: -30, child: _buildBlurCircle(250)),
                Positioned(top: 100, right: -60, child: _buildBlurCircle(250)),
                Positioned(bottom: -40, left: -30, child: _buildBlurCircle(250)),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  SizedBox(height: size.height * 0.02),
                  const Text("General", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _buildSettingsTile(Icons.person_outline, "Edit Profile", onTap: () {}),
                  _buildSettingsTile(Icons.lock_outline, "Change Password", onTap: () {}),
                  _buildSettingsTile(Icons.notifications_none, "Notifications", onTap: () {}),
                  _buildSettingsTile(Icons.language, "Language", trailingText: "English", onTap: () {}),

                  SizedBox(height: size.height * 0.03),
                  const Text("Preferences", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _buildSettingsTile(Icons.privacy_tip_outlined, "Legal and Policies", onTap: () {}),
                  _buildSettingsTile(Icons.help_outline, "Help & Support", onTap: () {}),

                  SizedBox(height: size.height * 0.03),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF1E1E1E),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {VoidCallback? onTap, String? trailingText}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: trailingText != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(trailingText, style: const TextStyle(color: Colors.white70)),
            const SizedBox(width: 5),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white),
          ],
        )
            : const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBlurCircle(double size) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFFFFF).withAlpha(15),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure you want to logout?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF1E56), Color(0xFFFA4169)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // logout logic
                    },
                    child: const Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.1),
            elevation: 0,
            title: const Text(
              "S E T T I N G",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
    );
  }

}
