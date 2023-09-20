import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuState {
  MenuState({required this.hasMenu, required this.restaurantId, required this.menuId});
  final bool hasMenu;
  final String? restaurantId;
  final String? menuId;
}

class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier() : super(MenuState(hasMenu: false, restaurantId: null, menuId: null));

  clearMenu() {
    state = MenuState(hasMenu: false, restaurantId: null, menuId: null);
  }

  enterMenu(String restaurantId, DMenu menu) {
    state = MenuState(hasMenu: true, restaurantId: restaurantId, menuId: menu.id);
  }
}

// final menuProvider =
//     StateNotifierProvider<MenuNotifier, MenuState>((ref) => MenuNotifier());
