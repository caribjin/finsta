import 'package:cached_network_image/cached_network_image.dart';
import 'package:finsta/blocs/blocs.dart';
import 'package:finsta/screens/profile/bloc/profile_bloc.dart';
import 'package:finsta/screens/profile/widgets/widgets.dart';
import 'package:finsta/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

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
                  onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                ),
            ],
          ),
          body: RefreshIndicator(
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
                              posts: 0,
                              // state.post.length,
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

                            return Container(
                              margin: EdgeInsets.all(10),
                              height: 100.0,
                              width: double.infinity,
                              color: Colors.red,
                            );
                          },
                          childCount: state.posts.length,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
