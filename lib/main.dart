import 'package:material_ui/material_ui.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:the_closet_club_mobile/core/app_theme.dart';
import 'package:the_closet_club_mobile/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // One shared CookieRequest keeps the Django session cookie for every module.
    return Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'The Closet Club',
        theme: AppTheme.light,
        home: const MyHomePage(),
      ),
    );
  }
}