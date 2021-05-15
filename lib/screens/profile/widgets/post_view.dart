import 'package:cached_network_image/cached_network_image.dart';
import 'package:finsta/models/models.dart';
import 'package:finsta/screens/screens.dart';
import 'package:finsta/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:finsta/extensions/extensions.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLiked;

  const PostView({
    Key? key,
    required this.post,
    required this.isLiked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ProfileScreen.routeName, arguments: ProfileScreenArgs(userId: post.author.id)),
            child: Row(
              children: [
                UserProfileImage(
                  profileImageUrl: post.author.profileImageUrl,
                  radius: 18.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    post.author.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            // todo: 이미지를 더블탭 했을 때 좋아함 올리는 로직 추가.
          },
          child: CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 2.25,
            width: double.infinity,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: isLiked ? const Icon(Icons.favorite, color: Colors.red) : const Icon(Icons.favorite_outline),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.comment_outlined),
              onPressed: () {},
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${post.likes} likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.0),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: post.author.username,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: post.caption),
                ]),
              ),
              SizedBox(height: 4.0),
              Text(
                post.date.toTimeAgo(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
