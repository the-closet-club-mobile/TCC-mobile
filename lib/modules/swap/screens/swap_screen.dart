import 'package:material_ui/material_ui.dart';

class SwapScreen extends StatelessWidget {
  const SwapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Swap Requests',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          TabBar(
            tabs: [
              Tab(text: 'Incoming'),
              Tab(text: 'Outgoing'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('No incoming swap requests yet')),
                Center(child: Text('No outgoing swap requests yet')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
