import 'package:material_ui/material_ui.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:the_closet_club_mobile/core/app_theme.dart';
import 'package:the_closet_club_mobile/modules/feed/models/outfit_post.dart';
import 'package:the_closet_club_mobile/modules/feed/services/feed_service.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final FeedService _service;
  OutfitPost? _post;
  String? _error;
  bool _loading = true;
  bool _liking = false;

  @override
  void initState() {
    super.initState();
    _service = FeedService(context.read<CookieRequest>());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final post = await _service.fetchPost(widget.postId);
      if (!mounted) return;
      setState(() {
        _post = post;
        _loading = false;
      });
    } on FeedException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    final post = _post;
    if (post == null || _liking) return;
    setState(() => _liking = true);
    try {
      final result = await _service.toggleLike(post.id);
      if (!mounted) return;
      setState(() {
        _post = post.copyWith(liked: result.liked, likeCount: result.likeCount);
      });
    } on FeedException catch (e) {
      if (!mounted) return;
      final msg = e.unauthorized ? 'Please log in to like outfits.' : e.message;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _liking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outfit')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
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
    final post = _post!;
    return ListView(
      children: [
        if (post.image != null)
          Image.network(
            post.image!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox(
              height: 200,
              child: Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.sand,
                    backgroundImage:
                        post.author.avatar == null ? null : NetworkImage(post.author.avatar!),
                    child: post.author.avatar == null
                        ? Text(post.author.username[0].toUpperCase())
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            '@${post.author.username}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (post.author.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 16, color: AppColors.forest),
                        ],
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _liking ? null : _toggleLike,
                    icon: Icon(post.liked ? Icons.favorite : Icons.favorite_border),
                    label: Text('${post.likeCount}'),
                  ),
                ],
              ),
              if (post.caption.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(post.caption),
              ],
              const SizedBox(height: 20),
              Text('Items in this outfit',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (post.clothes.isEmpty)
                const Text('No items tagged.')
              else
                for (final c in post.clothes)
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    child: ListTile(
                      leading: c.photo == null
                          ? const Icon(Icons.checkroom)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(c.photo!,
                                  width: 48, height: 48, fit: BoxFit.cover),
                            ),
                      title: Text(c.name),
                      subtitle: Text('${c.sizeLabel} · ${c.conditionLabel} · ${c.statusLabel}'),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}