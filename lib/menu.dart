import 'package:flutter/material.dart';
import 'package:the_closet_club_mobile/modules/auth/screens/auth_screen.dart';
import 'package:the_closet_club_mobile/modules/chat/screens/chat_screen.dart';
import 'package:the_closet_club_mobile/modules/closet/screens/closet_screen.dart';
import 'package:the_closet_club_mobile/modules/feed/screens/feed_screen.dart';
import 'package:the_closet_club_mobile/modules/swap/screens/swap_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Tab yang sedang aktif. Berubah saat user menekan menu bawah.
  int _index = 0;

  final List<Widget> _pages = const [
    FeedScreen(),
    ClosetScreen(),
    SwapScreen(),
    ChatScreen(),
    AuthScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Closet Club',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dynamic_feed), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.checkroom), label: 'Closet'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Swap'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }
}