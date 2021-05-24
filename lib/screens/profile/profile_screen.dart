import 'package:cached_network_image/cached_network_image.dart';
import 'package:finsta/blocs/blocs.dart';
import 'package:finsta/cubits/liked_post/liked_post_cubit.dart';
import 'package:finsta/repositories/repositories.dart';
import 'package:finsta/screens/profile/bloc/profile_bloc.dart';
import 'package:finsta/screens/profile/widgets/widgets.dart';
import 'package:finsta/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreenArgs {
  final String userId;

  const ProfileScreenArgs({required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route({required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
          likedPostCubit: context.read<LikedPostCubit>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildBody(ProfileState state) {
    // todo: 임시
    // context.read<ProfileBloc>().add(ProfileToggleGridView(isGridView: false));

    switch (state.status) {
      case ProfileStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileBloc>().add(ProfileLoadUser(userId: state.user.id));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
                      child: Row(
                        children: [
                          UserProfileImage(
                            radius: 40,
                            profileImageUrl: state.user.profileImageUrl,
                          ),
                          ProfileStats(
                            isCurrentUser: state.isCurrentUser,
                            isFollowing: state.isFollowing,
                            posts: state.posts.length,
                            followers: state.user.followers,
                            following: state.user.following,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: ProfileInfo(
                        username: state.user.username,
                        bio: state.user.bio,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  // indicatorWeight: 3,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.grid_on),
                    ),
                    Tab(
                      icon: Icon(Icons.list),
                    ),
                  ],
                  onTap: (index) {
                    context.read<ProfileBloc>().add(ProfileToggleGridView(isGridView: index == 0));
                  },
                ),
              ),
              state.isGridView
                  ? SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (state.posts.isEmpty) return null;

                          final post = state.posts[index];

                          return GestureDetector(
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl: post!.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () {},
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];

                          if (post == null) return null;

                          final likedPostsState = context.watch<LikedPostCubit>().state;
                          final isLiked = likedPostsState.likedPostIds.contains(post.id);
                          final recentlyLiked = likedPostsState.recentlyLikedPostIds.contains(post.id);

                          return PostView(
                            post: post,
                            isLiked: isLiked,
                            onLike: () {
                              if (isLiked) {
                                context.read<LikedPostCubit>().unlikePost(post: post);
                              } else {
                                context.read<LikedPostCubit>().likePost(post: post);
                              }
                            },
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message!),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            centerTitle: true,
            actions: [
              if (state.isCurrentUser)
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    context.read<LikedPostCubit>().clearAllLikedPosts();
                  },
                ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }
}
