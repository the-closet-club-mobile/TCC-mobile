import 'package:material_ui/material_ui.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:the_closet_club_mobile/core/app_theme.dart';
import 'package:the_closet_club_mobile/core/time_format.dart';
import 'package:the_closet_club_mobile/modules/chat/models/conversation.dart';
import 'package:the_closet_club_mobile/modules/chat/screens/chat_room_screen.dart';
import 'package:the_closet_club_mobile/modules/chat/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatService _service;
  List<Conversation> _conversations = [];
  bool _loading = true;
  String? _error;
  bool _needsLogin = false;

  @override
  void initState() {
    super.initState();
    _service = ChatService(context.read<CookieRequest>());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _needsLogin = false;
    });
    try {
      final items = await _service.fetchConversations();
      if (!mounted) return;
      setState(() {
        _conversations = items;
        _loading = false;
      });
    } on ChatException catch (e) {
      if (!mounted) return;
      setState(() {
        _needsLogin = e.unauthorized;
        _error = e.message;
        _loading = false;
      });
    }
  }

  Future<void> _openRoom(Conversation c) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(conversationId: c.id, title: c.other.username),
      ),
    );
    if (mounted) _load(); // refresh previews and unread counts on return
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
                child: Text('Messages', style: Theme.of(context).textTheme.headlineSmall),
              ),
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    // ListView keeps pull-to-refresh working for the message states too.
    if (_error != null) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: [
            const SizedBox(height: 120),
            Center(
              child: Text(
                _needsLogin ? 'Please log in from the Account tab to see your chats.' : _error!,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
    if (_conversations.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Center(child: Text('No conversations yet.')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        itemCount: _conversations.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) => _buildTile(_conversations[i]),
      ),
    );
  }

  Widget _buildTile(Conversation c) {
    final avatar = c.other.avatar;
    return ListTile(
      onTap: () => _openRoom(c),
      leading: CircleAvatar(
        backgroundColor: AppColors.sand,
        backgroundImage: avatar != null ? NetworkImage(avatar) : null,
        child: avatar == null
            ? Text(c.other.username.isEmpty ? '?' : c.other.username[0].toUpperCase())
            : null,
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              c.other.username,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (c.other.isVerified) ...[
            const SizedBox(width: 4),
            const Icon(Icons.verified, size: 16, color: Colors.blue),
          ],
        ],
      ),
      subtitle: Text(
        c.itemName.isNotEmpty ? '${c.itemName} · ${c.preview}' : c.preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(formatChatTime(c.lastTime), style: const TextStyle(fontSize: 12)),
          if (c.unread > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.forest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${c.unread}',
                style: const TextStyle(color: AppColors.cream, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}