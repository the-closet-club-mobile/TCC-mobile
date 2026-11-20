import 'package:material_ui/material_ui.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:the_closet_club_mobile/modules/closet/models/clothing.dart';
import 'package:the_closet_club_mobile/modules/closet/services/closet_service.dart';
import 'package:the_closet_club_mobile/modules/closet/widgets/clothing_card.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  late final ClosetService _service;
  List<Clothing> _items = [];
  bool _loading = true;
  String? _error;
  bool _needsLogin = false;

  @override
  void initState() {
    super.initState();
    _service = ClosetService(context.read<CookieRequest>());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _needsLogin = false;
    });
    try {
      final items = await _service.fetchItems();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } on ClosetException catch (e) {
      if (!mounted) return;
      setState(() {
        _needsLogin = e.unauthorized;
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            children: [
              Expanded(
                child: Text('My Closet',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _message(String text) {
    // ListView keeps pull-to-refresh working for the message states too.
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        children: [
          const SizedBox(height: 120),
          Center(child: Text(text, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return _message(
        _needsLogin
            ? 'Please log in from the Account tab to see your closet.'
            : _error!,
      );
    }
    if (_items.isEmpty) return _message('Your closet is empty.');

    return RefreshIndicator(
      onRefresh: _load,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: _items.length,
        itemBuilder: (context, i) => ClothingCard(item: _items[i]),
      ),
    );
  }
}
