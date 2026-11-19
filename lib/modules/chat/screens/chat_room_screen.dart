import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:the_closet_club_mobile/core/app_theme.dart';
import 'package:the_closet_club_mobile/modules/chat/models/conversation.dart';
import 'package:the_closet_club_mobile/modules/chat/models/message.dart';
import 'package:the_closet_club_mobile/modules/chat/services/chat_service.dart';
import 'package:the_closet_club_mobile/modules/chat/widgets/message_bubble.dart';

class ChatRoomScreen extends StatefulWidget {
  final int conversationId;
  final String title;

  const ChatRoomScreen({
    super.key,
    required this.conversationId,
    required this.title,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  late final ChatService _service;
  Timer? _poller;

  ConversationInfo? _info;
  List<Message> _messages = [];
  bool _loading = true;
  bool _fetching = false;
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = ChatService(context.read<CookieRequest>());
    _load();
    // Same idea as the web version: poll for new messages.
    _poller = Timer.periodic(const Duration(seconds: 4), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _poller?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (_fetching) return;
    _fetching = true;
    try {
      final room = await _service.fetchRoom(widget.conversationId);
      if (!mounted) return;
      setState(() {
        _info = room.info;
        _messages = room.messages;
        _error = null;
        _loading = false;
      });
    } on ChatException catch (e) {
      if (!mounted) return;
      if (!silent || _info == null) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    } finally {
      _fetching = false;
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await _service.sendMessage(widget.conversationId, text);
      _controller.clear();
      await _load(silent: true);
    } on ChatException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  bool get _canSend {
    final info = _info;
    return info != null && !info.blockedByMe && !info.blockedMe;
  }

  String? get _banner {
    final info = _info;
    if (info == null) return null;
    if (info.blockedByMe) return 'You blocked this user. Unblock on the website to send messages.';
    if (info.blockedMe) return 'You cannot send messages to this user.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          if (_banner != null)
            Container(
              width: double.infinity,
              color: AppColors.sand,
              padding: const EdgeInsets.all(10),
              child: Text(_banner!, textAlign: TextAlign.center),
            ),
          Expanded(child: _buildMessages()),
          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null && _messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 8),
            FilledButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_messages.isEmpty) {
      return const Center(child: Text('No messages yet. Say hello!'));
    }
    final otherUsername = _info?.otherUsername;
    // Newest message at the bottom: reverse the list and the scroll direction.
    final reversed = _messages.reversed.toList();
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: reversed.length,
      itemBuilder: (context, i) {
        final m = reversed[i];
        return MessageBubble(
          message: m,
          isMine: m.sender.username != otherUsername,
        );
      },
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: _canSend,
                minLines: 1,
                maxLines: 4,
                maxLength: 2000,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _canSend && !_sending ? _send : null,
              style: IconButton.styleFrom(backgroundColor: AppColors.forest),
              icon: _sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}