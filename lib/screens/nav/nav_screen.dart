import 'package:finsta/enums/enums.dart';
import 'package:finsta/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:finsta/screens/nav/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:finsta/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  final Map<BottomNavItem, IconData> items = {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notifications: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  final BottomNavItem selectedItem = BottomNavItem.feed;

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Main')),
            body: Text('Nav Screen'),
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              onTap: (index) {
                context.read<BottomNavBarCubit>().updateSelectedItem(BottomNavItem.values[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
