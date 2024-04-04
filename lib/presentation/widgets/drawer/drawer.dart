// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:ous/presentation/pages/Nav/call_screen.dart';
import 'package:ous/presentation/pages/Nav/link_screen.dart';
import 'package:ous/presentation/pages/setting/setting_screen.dart';
import 'package:ous/presentation/widgets/drawer/drawer_user_widget.dart';
// Package imports:
import 'package:url_launcher/url_launcher.dart';

// URL Constants
const String calendarUrl = 'https://www.ous.ac.jp/campuslife/academic_calenda/';
const String handbookUrl = 'https://www.ous.ac.jp/outline/disclosure/handbook/';
const String mylogUrl =
    'https://mylog.pub.ous.ac.jp/uprx/up/pk/pky501/Pky50101.xhtml';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerUserHeader(),
          _buildMenuItem(
            Icons.event_available_outlined,
            '行事予定',
            () => _launchUrl(
              context,
              calendarUrl,
              mode: LaunchMode.inAppBrowserView,
            ),
          ),
          _buildMenuItem(
            Icons.public_outlined,
            'マイログ',
            () => _launchUrl(
              context,
              mylogUrl,
              mode: LaunchMode.inAppBrowserView,
            ),
          ),
          _buildMenuItem(
            Icons.book_outlined,
            '学生便覧',
            () => _launchUrl(
              context,
              handbookUrl,
              mode: LaunchMode.inAppBrowserView,
            ),
          ),
          const Divider(),
          _buildMenuItem(
            Icons.link_outlined,
            '各種リンク集',
            () => _navigateToPage(context, const Link()),
          ),
          _buildMenuItem(
            Icons.call_outlined,
            '各種連絡先',
            () => _navigateToPage(context, const Call()),
          ),
          const Divider(),
          _buildMenuItem(
            Icons.settings_outlined,
            '設定/その他',
            () => _navigateToPage(context, const SettingPage()),
          ),
        ],
      ),
    );
  }

  ListTile _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _launchUrl(BuildContext context, String url, {LaunchMode? mode}) {
    Navigator.of(context).pop();
    launchUrl(Uri.parse(url), mode: mode ?? LaunchMode.externalApplication);
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
