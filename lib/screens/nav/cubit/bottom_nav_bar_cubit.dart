import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finsta/enums/enums.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarState(selectedItem: BottomNavItem.feed));

  void updateSelectedItem(BottomNavItem item) {
    if (item != state.selectedItem) {
      print('1. 현재 선택된 탭: ${state.selectedItem}');
      print('2. 다음 선택 탭: $item}');

      emit(BottomNavBarState(selectedItem: item));
    }
  }
}
