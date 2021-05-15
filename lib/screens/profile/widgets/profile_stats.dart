import 'package:finsta/screens/profile/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;

  const ProfileStats({
    required this.isCurrentUser,
    required this.isFollowing,
    required this.posts,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stats(label: 'Posts', count: posts),
              _Stats(label: 'Followers', count: followers),
              _Stats(label: 'Following', count: following),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ProfileButton(
                isCurrentUser: isCurrentUser,
                isFollowing: isFollowing,
              )),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final String label;
  final int count;

  const _Stats({
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
