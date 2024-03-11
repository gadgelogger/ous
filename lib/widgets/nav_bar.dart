import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ous/Nav/call.dart';
import 'package:ous/Nav/link.dart';
import 'package:ous/Nav/tcp.dart';
import 'package:ous/account/account_page.dart';
import 'package:ous/setting/setting.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Stream<DocumentSnapshot>? _stream;
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Account information
          _buildUserAccountHeader(),
          // Menu items
          _buildMenuItem(
            Icons.event_available_outlined,
            '行事予定',
            () => _launchCalender(),
          ),

          _buildMenuItem(Icons.public_outlined, 'マイログ', () => _launchMyLog()),
          _buildMenuItem(
            Icons.public_outlined,
            'TCP',
            () => _navigateToPage(context, const Tcp()),
          ),
          _buildMenuItem(
            Icons.book_outlined,
            '学生便覧',
            () => _launchStudentHandbook(),
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
            () => _navigateToPage(context, const Setting()),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _stream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  ListTile _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildUserAccountHeader() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _stream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          return _guestUserHeader(context);
        }

        final DocumentSnapshot doc = snapshot.data!;
        return _userHeader(context, doc);
      },
    );
  }

  Widget _guestUserHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          Fluttertoast.showToast(
            msg: "ゲストモードでは利用できません。",
          ) as SnackBar,
        );
      },
      child: UserAccountsDrawerHeader(
        accountName: const Text('ゲストモード'),
        accountEmail: const Text('guest_user@example.com'),
        currentAccountPicture: const CircleAvatar(
          child: ClipOval(
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _launchCalender() {
    Navigator.of(context).pop();
    launchUrlString('https://www.ous.ac.jp/campuslife/academic_calenda/');
  }

  void _launchMyLog() {
    Navigator.of(context).pop();
    launchUrl(
      Uri.https('mylog.pub.ous.ac.jp', '/uprx/up/pk/pky501/Pky50101.xhtml'),
      mode: LaunchMode.externalApplication,
    );
  }

  void _launchStudentHandbook() {
    Navigator.of(context).pop();
    launchUrlString('https://www.ous.ac.jp/outline/disclosure/handbook/');
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _userHeader(BuildContext context, DocumentSnapshot doc) {
    final String displayName = doc.get('displayName') as String;
    final String email = doc.get('email') as String;
    final String image = doc.get('photoURL') as String;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountPage(),
          ),
        );
      },
      child: UserAccountsDrawerHeader(
        accountName: Text(displayName),
        accountEmail: Text(email, style: const TextStyle(color: Colors.white)),
        currentAccountPicture: CircleAvatar(
          child: ClipOval(
            child:
                Image.network(image, width: 90, height: 90, fit: BoxFit.cover),
          ),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
