import 'package:finsta/cubits/liked_post/liked_post_cubit.dart';
import 'package:finsta/screens/feed/bloc/feed_bloc.dart';
import 'package:finsta/screens/profile/widgets/post_view.dart';
import 'package:finsta/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange &&
          context.read<FeedBloc>().state.status != FeedStatus.paginating) {
        context.read<FeedBloc>().add(FeedPaginatePosts());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          child: ListView.builder(
              controller: _scrollController,
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];

                if (post == null) return SizedBox.shrink();

                final likedPostsState = context.watch<LikedPostCubit>().state;
                final isLiked = likedPostsState.likedPostIds.contains(post.id);
                final recentlyLiked = likedPostsState.recentlyLikedPostIds.contains(post.id);

                return PostView(
                  post: post,
                  isLiked: isLiked,
                  recentlyLiked: recentlyLiked,
                  onLike: () {
                    if (isLiked) {
                      context.read<LikedPostCubit>().unlikePost(post: post);
                    } else {
                      context.read<LikedPostCubit>().likePost(post: post);
                    }
                  },
                );
              }),
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPosts());
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message ?? ''),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Finsta'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => context.read<FeedBloc>().add(FeedFetchPosts()),
              ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }
}
