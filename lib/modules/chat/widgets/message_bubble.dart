import 'package:material_ui/material_ui.dart';
import 'package:the_closet_club_mobile/core/app_theme.dart';
import 'package:the_closet_club_mobile/core/time_format.dart';
import 'package:the_closet_club_mobile/modules/chat/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMine;

  const MessageBubble({super.key, required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final background = isMine ? AppColors.forest : AppColors.sand;
    final foreground = isMine ? AppColors.cream : AppColors.ink;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.replyTo != null) _buildReply(foreground),
              _buildBody(foreground),
              const SizedBox(height: 4),
              _buildFooter(foreground),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReply(Color foreground) {
    final reply = message.replyTo!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reply.sender,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            reply.preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: foreground, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _iconLine(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Flexible(child: Text(text, style: TextStyle(color: color))),
      ],
    );
  }

  Widget _buildBody(Color foreground) {
    switch (message.type) {
      case 'location':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconLine(Icons.location_on, message.placeName, foreground),
            if (message.address.isNotEmpty)
              Text(
                message.address,
                style: TextStyle(color: foreground, fontSize: 12),
              ),
          ],
        );
      case 'image':
        return _iconLine(Icons.image_outlined, 'Photo', foreground);
      case 'file':
        return _iconLine(Icons.attach_file, message.attachmentName, foreground);
      case 'swap':
        return _iconLine(Icons.swap_horiz, 'Swap request', foreground);
      default:
        return Text(message.content, style: TextStyle(color: foreground));
    }
  }

  Widget _buildFooter(Color foreground) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (message.isEdited)
          Text(
            'edited · ',
            style: TextStyle(color: foreground.withValues(alpha: 0.7), fontSize: 10),
          ),
        Text(
          formatClock(message.createdAt),
          style: TextStyle(color: foreground.withValues(alpha: 0.7), fontSize: 10),
        ),
        if (isMine) ...[
          const SizedBox(width: 4),
          Icon(
            message.isRead ? Icons.done_all : Icons.done,
            size: 12,
            color: foreground.withValues(alpha: 0.7),
          ),
        ],
      ],
    );
  }
}