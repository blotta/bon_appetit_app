import 'package:bon_appetit_app/models/menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItemsNotifier extends StateNotifier<List<OrderItem>> {
  OrderItemsNotifier() : super([]);

  void clear() {
    state = [];
  }

  void addItem(MenuItem item) {
    if (state.any((i) => i.item.name == item.name)) {
      var orderItem = state.firstWhere((i) => i.item.name == item.name);
      orderItem.quantity += 1;
      state = [...(state.where((i) => i.item.name != item.name)), orderItem];
    } else {
      state = [...state, OrderItem(item, 1)];
    }
  }
}

final orderItemsProvider =
    StateNotifierProvider<OrderItemsNotifier, List<OrderItem>>(
        (ref) => OrderItemsNotifier());
