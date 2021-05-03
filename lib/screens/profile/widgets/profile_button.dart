import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    required this.isCurrentUser,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? ElevatedButton(
            onPressed: () {
              // todo: 프로필 편집 버튼 동작 추가
            },
            child: const Text('Edit Profile'),
          )
        : ElevatedButton(
            onPressed: () {
              // todo: follow / unfollow 동작 추가
            },
            style: ElevatedButton.styleFrom(
              primary: isFollowing ? Colors.grey[300] : Theme.of(context).primaryColor,
              onPrimary: isFollowing ? Colors.black : Colors.white,
            ),
            child: Text(isFollowing ? 'Unfollow' : 'Follow'),
          );
  }
}
