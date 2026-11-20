import 'package:material_ui/material_ui.dart';
import 'package:the_closet_club_mobile/core/app_theme.dart';
import 'package:the_closet_club_mobile/modules/feed/models/outfit_post.dart';

class PostCard extends StatelessWidget {
  final OutfitPost post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: post.image == null
                    ? const ColoredBox(color: AppColors.sand)
                    : Image.network(
                        post.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: AppColors.sand,
                          child: Icon(Icons.broken_image_outlined),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.caption.isEmpty ? 'Untitled outfit' : post.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '@${post.author.username}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      if (post.author.isVerified)
                        const Icon(Icons.verified, size: 14, color: AppColors.forest),
                      const SizedBox(width: 6),
                      Icon(
                        post.liked ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text('${post.likeCount}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}